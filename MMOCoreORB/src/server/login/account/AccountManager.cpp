/*
 * AccountManager.cpp
 *
 *  Created on: Oct 13, 2010
 *      Author: crush
 */

#include "server/login/account/Account.h"
#include "AccountManager.h"
#include "server/login/LoginClient.h"
#include "server/login/LoginServer.h"
#ifdef WITH_SWGREALMS_API
#include "server/login/SWGRealmsAPI.h"
#endif // WITH_SWGREALMS_API
#include "server/login/packets/AccountVersionMessage.h"
#include "server/login/packets/EnumerateCharacterId.h"
#include "server/login/packets/LoginClientToken.h"
#include "server/login/packets/LoginClusterStatus.h"
#include "server/login/packets/LoginEnumCluster.h"
#include "server/ServerCore.h"

#include "server/zone/managers/object/ObjectManager.h"

ReadWriteLock AccountManager::mutex;

AccountManager::AccountManager(LoginServer* loginserv) : Logger("AccountManager") {
	loginServer = loginserv;

	autoRegistration = true;
	requiredVersion = "";
	maxOnlineCharacters = 1;

	setLogging(false);
	setGlobalLogging(false);

#ifndef WITH_SWGREALMS_API
	if (ServerCore::truncateDatabases()) {
		try {
			String query = "TRUNCATE TABLE characters";

			UniqueReference<ResultSet*> res(ServerDatabase::instance()->executeQuery(query));

			info("characters table truncated", true);
		} catch (const Exception& e) {
			error(e.getMessage());
		}
	}
#endif // !WITH_SWGREALMS_API
}

AccountManager::~AccountManager() {

}

#ifndef WITH_SWGREALMS_API
namespace {
// A binary literal preserves the exact bytes regardless of the sessions table's collation.
String sessionMatch(uint32 accountID, const String& sessionID) {
	static const char hex[] = "0123456789abcdef";
	StringBuffer match;
	match << " WHERE account_id = " << accountID << " AND BINARY session_id = X'";
	for (const auto ch : sessionID) {
		const auto byte = static_cast<uint8>(ch);
		match << hex[byte >> 4] << hex[byte & 15];
	}
	match << "' AND expires > NOW()";
	return match.toString();
}

bool sessionExists(const String& match) {
	UniqueReference<ResultSet*> result(ServerDatabase::instance()->executeQuery("SELECT 1 FROM sessions" + match));
	return result != nullptr && result->next();
}

bool consumeSession(const String& match) {
	UniqueReference<ResultSet*> result(ServerDatabase::instance()->executeQuery("DELETE FROM sessions" + match));
	return result != nullptr && result->getRowsAffected() == 1;
}

bool saveLoginSession(Account* account, const String& ip, String& sessionID) {
	Locker locker(account);
	const uint32 accountID = account->getAccountID();
	const bool reusable = !sessionID.isEmpty();
	String duration = ConfigManager::instance()->getString("Core3.Login.SessionDuration", "00:15");
	Database::escapeString(duration);
	StringBuffer query;
	String match;
	if (reusable) {
		// Only renew the credential that was verified, while it is still current.
		match = sessionMatch(accountID, sessionID);
		query << "UPDATE sessions SET ip = '" << ip << "', expires = ADDTIME(NOW(), '" << duration << "')" << match;
	} else {
		sessionID = Crypto::randomSalt<64>();
		query << "REPLACE INTO sessions (account_id, session_id, ip, expires) VALUES ("
		      << accountID << ", '" << sessionID << "', '" << ip << "', ADDTIME(NOW(), '" << duration << "'))";
	}

	UniqueReference<ResultSet*> result(ServerDatabase::instance()->executeQuery(query));
	if (result == nullptr)
		return false;

	if (result->getRowsAffected() == 0) {
		// MySQL reports zero for a renewal from the same IP in the same second.
		if (!reusable || !sessionExists(match + " AND ip = '" + ip + "'"))
			return false;
	}

	account->setSessionId(reusable ? sessionID : String());
	return true;
}
}
#endif // !WITH_SWGREALMS_API

void AccountManager::loginAccount(LoginClient* client, Message* packet) {
	String username, password, version;
	AccountVersionMessage::parse(packet, username, password, version);

#ifndef WITH_SWGREALMS_API
	Database::escapeString(username);
	Database::escapeString(password);

	if (!isRequiredVersion(version)) {
		client->sendErrorMessage("Login Error", "The client you are attempting to connect with does not match that required by the server.");
		return;
	}

	String sessionID;
	Reference<Account*> account = validateAccountCredentials(client, username, password, sessionID);

	if (account == nullptr)
		return;

	auto connection = client->getSession();
	if (connection == nullptr)
		return;

	String ip = connection->getAddress().getIPAddress();
	try {
		if (!saveLoginSession(account, ip, sessionID)) {
			client->sendErrorMessage("Login Error", "Unable to start your session. Please log in again.");
			return;
		}
	} catch (const DatabaseException& e) {
		client->error() << e.getMessage();
		client->sendErrorMessage("Login Error", "Unable to start your session. Please try again.");
		return;
	}

#else // WITH_SWGREALMS_API
	StringBuffer clientEndpoint;

	auto session = client->getSession();

	if (session == nullptr)
		return;

	auto address = session->getAddress();

	clientEndpoint << address.getIPAddress() << ":" << address.getPort();

	SWGRealmsAPI::instance()->createSession(username, password, version, clientEndpoint.toString(),
			[this, username, loginClient = Reference<LoginClient*>(client)](const SessionApprovalResult& result) {

		if (result.isActionTemporaryFailure()) {
			error() << "Unexpected failure in createSession for user [" << username << "]: " << result.getLogMessage();
		}

		if (loginClient == nullptr)
			return;

		if (!result.isActionAllowed()) {
			loginClient->sendErrorMessage(result.getTitle(), result.getMessage(true));
			return;
		}

		auto sessionId = result.getSessionID();

		if (sessionId.isEmpty()) {
			StringBuffer errorMsg;
			errorMsg << "Your session key was invalid, exit the client and try logging in again, if this continues contact support.\n\ntrx_id: " << result.getTrxId();

			loginClient->sendErrorMessage("Login Error", errorMsg.toString());

			error() << "missing sessionId in createSession for user [" << username << "]: " << result.getLogMessage();

			return;
		}

		Reference<Account*> loginAccount = getAccount(result.getAccountID(), true);

		if (loginAccount == nullptr) {
			loginClient->sendErrorMessage("Login Error", "Failed to find your account, please contact support.");

			error() << "getAccount(" << result.getAccountID() << ") failed in createSession for user [" << username << "]: " << result.getLogMessage();
			return;
		}

		Locker locker(loginAccount);

		loginAccount->setSessionId(sessionId);
		loginAccount->setStationID(result.getStationID());

		if (!loginFinalize(loginClient, loginAccount)) {
			return;
		}

		loginApprovedAccount(loginClient, loginAccount);
	});
};

void AccountManager::loginApprovedAccount(LoginClient* client, ManagedReference<Account*> account) {
	String sessionID = account->getSessionId();

	if (sessionID.isEmpty()) {
		sessionID = Crypto::randomSalt<64>();
	}
#endif // WITH_SWGREALMS_API

	auto* lct = new LoginClientToken(account, sessionID);
	client->sendMessage(lct);

	uint32 accountID = account->getAccountID();

	client->setAccountID(accountID);

#ifdef WITH_SWGREALMS_API
	String ip = client->getSession()->getAddress().getIPAddress();
	SWGRealmsAPI::instance()->notifySessionStart(ip, accountID);
#else
	StringBuffer logQuery;
	logQuery << "INSERT INTO account_log (account_id, ip_address, timestamp) VALUES (" << accountID << ", '" << ip << "', NOW());";

	try {
		ServerDatabase::instance()->executeStatement(logQuery);
	} catch (const DatabaseException& e) {
		client->error() << e.getMessage();
	}
#endif // WITH_SWGREALMS_API

	client->sendMessage(loginServer->getLoginEnumClusterMessage(account));
	client->sendMessage(loginServer->getLoginClusterStatusMessage(account));

	auto eci = new EnumerateCharacterId(account);
	client->sendMessage(eci);
}

#ifndef WITH_SWGREALMS_API
Reference<Account*> AccountManager::validateAccountCredentials(LoginClient* client, const String& username, const String& password, String& sessionID) {
	if (client == nullptr) {
		return nullptr;
	}

	bool isSessionIdLogin = false;
	String passwordStored;
	Reference<Account*> account = nullptr;

	sessionID = "";
	if (!password.isEmpty() && ConfigManager::instance()->getLoginEnableSessionId()) {
		StringBuffer sessionIdQuery;
		sessionIdQuery << "SELECT a.active, a.username, a.password, a.salt, a.account_id, a.station_id, "
			     "UNIX_TIMESTAMP(a.created), a.admin_level, IFNULL(s.session_id, '') AS session_id "
			     "FROM accounts a, sessions s "
			     "WHERE s.account_id = a.account_id AND s.expires > NOW() AND BINARY s.session_id = '" << password << "'";

		if (!username.isEmpty()) {
			sessionIdQuery << " AND a.username = '" << username << "'";
		}

		sessionIdQuery << " LIMIT 1;";

		account = getAccount(sessionIdQuery.toString(), passwordStored, true, &sessionID);

		if (account != nullptr) {
			isSessionIdLogin = true;
		}
	}

	if (account == nullptr) {
		StringBuffer query;
		query << "SELECT a.account_id, a.username, a.password, a.salt, a.account_id, a.station_id, "
			"UNIX_TIMESTAMP(a.created), a.admin_level, '' as session_id FROM accounts a WHERE a.username = '" << username << "' LIMIT 1;";

		account = getAccount(query.toString(), passwordStored, true);
	}

	if (account == nullptr) {
		// The user name didn't exist, so we check if auto registration is enabled and create a new account
		if (isAutoRegistrationEnabled()) {
			if (username.isEmpty()) {
				client->sendErrorMessage("Login Error", "You must choose a valid username!");
				return nullptr;
			}

			account = createAccount(username, password, passwordStored);
		} else {
			client->sendErrorMessage("Login Error",
				ConfigManager::instance()->getString("Core3.RegistrationMessage",
					"Automatic registration is currently disabled. "
					"Please contact the administrators of the server in order to get an authorized account."
				)
			);

			return nullptr;
		}
	}

	// Handle username / password login
	if (!isSessionIdLogin) {
		// Check hash version
		String passwordHashed;

		if (account->getSalt() == "") {
			passwordHashed = Crypto::SHA1Hash(password);
		} else {
			passwordHashed = Crypto::SHA256Hash(dbSecret + password + account->getSalt());
		}

		if (passwordStored != passwordHashed) {
			client->sendErrorMessage("Wrong Password", "The password you entered was incorrect.");

			return nullptr;
		}

		// update hash if unsalted
		if (account->getSalt() == "")
			updateHash(username, password);
	}

	return loginFinalize(client, account) == true ? account : nullptr;
}
#endif // !WITH_SWGREALMS_API

bool AccountManager::loginFinalize(LoginClient* client, ManagedReference<Account*> account) {
	if (client == nullptr || account == nullptr) {
		return false;
	}

	Locker lock(account);

	if (!account->isActive()) {
		const String& inactTitle = ConfigManager::instance()->getInactiveAccountTitle();
		const String& inactText = ConfigManager::instance()->getInactiveAccountText();

		client->sendErrorMessage(
			inactTitle.length() == 0 ? "Account Disabled" : inactTitle,
			inactText.length() == 0 ? "The server administrators have disabled your account." : inactText
		);

		return false;
	}

	// Check if they are banned
	if (account->isBanned()) {
		StringBuffer reason;

		reason << "Your account has been banned from the server by the administrators.\n\n";
		int totalBan = account->getBanExpires() - time(0);

		int daysBanned = floor((float)totalBan / 60.f / 60.f / 24.f);
		totalBan -= (daysBanned * 60 * 60 * 24);

		int hoursBanned = floor(((float)totalBan / 60.0f) / 60.f);
		totalBan -= (hoursBanned * 60 * 60);

		int minutesBanned = floor((float)totalBan / 60.0f);
		totalBan -= (minutesBanned * 60);

		reason << "Time remaining: ";

		if (daysBanned > 0)
			reason << daysBanned << " Days ";

		if (hoursBanned > 0)
			reason << hoursBanned << " Hours ";

		if (minutesBanned > 0)
			reason << minutesBanned << " Minutes ";

		reason << totalBan << " Seconds\n";

		reason << "Reason: " << account->getBanReason();

		client->sendErrorMessage("Account Banned", reason.toString());

		return false;
	}

	return true;
}

#ifndef WITH_SWGREALMS_API
void AccountManager::updateHash(const String& username, const String& password) {
	String salt = Crypto::randomSalt();
	String hash = Crypto::SHA256Hash(dbSecret + password + salt);

	StringBuffer query;
	query << "UPDATE accounts SET password = '" << hash << "', ";
	query << "salt = '" << salt << "' ";
	query << "WHERE username = '" << username << "';";

	try {
		ServerDatabase::instance()->executeStatement(query);
	} catch (const DatabaseException& e) {
		error(e.getMessage());
	}
}

Reference<Account*> AccountManager::createAccount(const String& username, const String& password, String& passwordStored) {
	uint32 stationID = System::random();

	String salt = Crypto::randomSalt();
	String hash = Crypto::SHA256Hash(dbSecret + password + salt);

	StringBuffer query;
	query << "INSERT INTO accounts (username, password, station_id, salt) VALUES (";
	query << "'" << username << "',";
	query << "'" << hash << "',";
	query << stationID << ",";
	query << "'" << salt << "');";

	UniqueReference<ResultSet*> result(ServerDatabase::instance()->executeQuery(query.toString()));

	if (result == nullptr)
		return nullptr;

	uint32 accountID = result->getLastAffectedRow();

	return getAccount(accountID, passwordStored, true);
}

Reference<Account*> AccountManager::getAccount(uint32 accountID, bool forceSqlUpdate) {
	static Logger logger("AccountManager");

	Locker locker(&mutex);

	Reference<Account*> accObj;

	static uint64 databaseID = ObjectDatabaseManager::instance()->getDatabaseID("accounts");

	uint64 oid = (accountID | (databaseID << 48));

	accObj = Core::getObjectBroker()->lookUp(oid).castTo<Account*>();

	if (accObj == nullptr) {
		// Lazily create account object
		accObj = dynamic_cast<Account*>(ObjectManager::instance()->createObject("Account", 3, "accounts", oid));

		if (accObj == nullptr) {
			logger.error("Error creating account object with account ID " + String::hexvalueOf((int64)oid));

			return nullptr;
		}
	} else if (!forceSqlUpdate && accObj->isSqlLoaded() && !accObj->isAccountDataStale()) {
		return accObj;
	}

	StringBuffer query;
	query << "SELECT a.active, a.username, a.password, a.salt, a.account_id, a.station_id, UNIX_TIMESTAMP(a.created), a.admin_level, '' AS session_id FROM accounts a WHERE a.account_id = '" << accountID << "' LIMIT 1;";

	UniqueReference<ResultSet*> result(ServerDatabase::instance()->executeQuery(query.toString()));

	if (result->next()) {
		Locker locker(accObj);

		accObj->setActive(result->getBoolean(0));
		accObj->setUsername(result->getString(1));
		accObj->setSalt(result->getString(3));
		accObj->setAccountID(accountID);
		accObj->setStationID(result->getUnsignedInt(5));

		Time ttl;
		ttl.addMiliTime(3600 * 1000);
		accObj->setAccountDataValidUntil(ttl);

		if (!ConfigManager::instance()->getBool("Core3.AccountManager.CreatedDateFirstConnect", false)) {
			accObj->setTimeCreated(result->getUnsignedInt(6));
		} else {
			if (accObj->getTimeCreated() == 0) {
				Time now;
				accObj->setTimeCreated(now.getTime());
			}
		}

		accObj->setAdminLevel(result->getInt(7));

		accObj->updateFromDatabase();

		return accObj;
	}

	return nullptr;
}

Reference<Account*> AccountManager::getAccount(uint32 accountID, String& passwordStored, bool forceSqlUpdate) {
	StringBuffer query;
	query << "SELECT a.active, a.username, a.password, a.salt, a.account_id, a.station_id, UNIX_TIMESTAMP(a.created), a.admin_level, '' AS session_id FROM accounts a WHERE a.account_id = '" << accountID << "' LIMIT 1;";

	return getAccount(query.toString(), passwordStored, forceSqlUpdate);
}

Reference<Account*> AccountManager::getAccount(String query, String& passwordStored, bool forceSqlUpdate, String* sessionID) {
	static Logger logger("AccountManager");

	Locker locker(&mutex);

	Reference<Account*> account;

	UniqueReference<ResultSet*> result(ServerDatabase::instance()->executeQuery(query));

	if (result->next()) {
		static uint64 databaseID = ObjectDatabaseManager::instance()->getDatabaseID("accounts");
		uint64 accountID = result->getUnsignedInt(4);

		uint64 oid = (accountID | (databaseID << 48));

		account = Core::getObjectBroker()->lookUp(oid).castTo<Account*>();

		if (account == nullptr) {
			// Lazily create account object
			account = dynamic_cast<Account*>(ObjectManager::instance()->createObject("Account", 3, "accounts", oid));

			if (account == nullptr) {
				logger.error("Error creating account object with account ID " + String::hexvalueOf((int64)oid));

				return nullptr;
			}
		} else if (!forceSqlUpdate && account->isSqlLoaded()) {
			return account;
		}

		if (account == nullptr) {
			return nullptr;
		}

		Locker locker(account);

		account->setActive(result->getBoolean(0));
		account->setUsername(result->getString(1));

		passwordStored = result->getString(2);

		account->setSalt(result->getString(3));
		account->setAccountID(accountID);
		account->setStationID(result->getUnsignedInt(5));

		if (!ConfigManager::instance()->getBool("Core3.AccountManager.CreatedDateFirstConnect", false)) {
			account->setTimeCreated(result->getUnsignedInt(6));
		} else {
			if (account->getTimeCreated() == 0) {
				Time now;
				account->setTimeCreated(now.getTime());
			}
		}

		account->setAdminLevel(result->getInt(7));

		if (sessionID != nullptr)
			*sessionID = result->getString(8);

		Time ttl;
		ttl.addMiliTime(3600 * 1000);
		account->setAccountDataValidUntil(ttl);

		account->updateFromDatabase();

		return account;
	}

	return nullptr;
}

Reference<Account*> AccountManager::getAccount(const String& accountName, bool forceSqlUpdate) {
	String name = accountName;

	Database::escapeString(name);

	StringBuffer query;
	query << "SELECT a.active, a.username, a.password, a.salt, a.account_id, a.station_id, UNIX_TIMESTAMP(a.created), a.admin_level, '' AS session_id FROM accounts a WHERE a.username = '" << name << "' LIMIT 1;";

	String temp;

	return getAccount(query.toString(), temp, forceSqlUpdate);
}
#else // WITH_SWGREALMS_API
Reference<Account*> AccountManager::getAccount(uint32 accountID, bool forceSqlUpdate) {
	static Logger logger("AccountManager");

	Reference<Account*> accObj;

	{
		// Scope mutext ot just ObjectBroker since API can process result on separate thread
		Locker locker(&mutex);

		static uint64 databaseID = ObjectDatabaseManager::instance()->getDatabaseID("accounts");

		uint64 oid = (accountID | (databaseID << 48));

		accObj = Core::getObjectBroker()->lookUp(oid).castTo<Account*>();

		if (accObj == nullptr) {
			// Lazily create account object
			accObj = dynamic_cast<Account*>(ObjectManager::instance()->createObject("Account", 3, "accounts", oid));

			if (accObj == nullptr) {
				logger.error("Error creating account object with account ID " + String::hexvalueOf((int64)oid));

				return nullptr;
			}
		} else if (!forceSqlUpdate && accObj->isSqlLoaded() && !accObj->isAccountDataStale()) {
			return accObj;
		}
	}

	// Try to get account data from API
	String errorMessage;
	auto swgRealmsAPI = SWGRealmsAPI::instance();

	if (swgRealmsAPI == nullptr) {
		logger.error() << "SWGRealms API instance is null";
		return nullptr;
	}

	if (swgRealmsAPI->getAccountDataBlocking(accountID, accObj, errorMessage)) {
		Locker locker(accObj);
		accObj->updateFromDatabase();

		return accObj;
	}

	logger.error() << "SWGRealms API getAccountDataBlocking failed for accountID " << accountID << ": " << errorMessage;
	return nullptr;
}

Reference<Account*> AccountManager::getAccount(const String& accountName, bool forceSqlUpdate) {
	static Logger logger("AccountManager");

	String errorMessage;
	auto swgRealmsAPI = SWGRealmsAPI::instance();

	// Get account_id from username via API
	uint32 accountID = swgRealmsAPI->getAccountID(accountName, errorMessage);

	if (accountID == 0) {
		logger.error() << "Failed to get account_id for username " << accountName << ": " << errorMessage;
		return nullptr;
	}

	// Use account_id to get full account (may use cache, avoiding second API call)
	return getAccount(accountID, forceSqlUpdate);
}
#endif // WITH_SWGREALMS_API

#ifndef WITH_SWGREALMS_API
Reference<Account*> AccountManager::getAccountForZoneSession(uint32 accountID, const String& sessionID, const String& ip) {
	if (sessionID.isEmpty() || sessionID.length() > 255)
		return nullptr;

	const String match = sessionMatch(accountID, sessionID) + " AND ip = '" + ip + "'";
	// Ignore invalid requests before loading the account. The locked check below decides admission.
	if (!sessionExists(match))
		return nullptr;
	auto account = getAccount(accountID, true);
	if (account == nullptr)
		return nullptr;

	Locker locker(account);
	const bool reusable = ConfigManager::instance()->getLoginEnableSessionId() && account->getSessionId() == sessionID;
	if (reusable ? sessionExists(match) : consumeSession(match))
		return account;
	return nullptr;
}
#endif // !WITH_SWGREALMS_API
