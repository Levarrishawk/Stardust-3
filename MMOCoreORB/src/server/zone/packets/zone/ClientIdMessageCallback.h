/*
 * ClientIdMessageCallback.h
 *
 *  Created on: Sep 4, 2009
 *      Author: theanswer
 */

#ifndef CLIENTIDMESSAGECALLBACK_H_
#define CLIENTIDMESSAGECALLBACK_H_

#include "server/zone/ZoneServer.h"
#include "server/zone/packets/MessageCallback.h"
#include "server/db/ServerDatabase.h"
#include "server/login/packets/ErrorMessage.h"
#include "server/login/account/Account.h"
#include "server/login/objects/CharacterList.h"
#include "server/login/account/AccountManager.h"

#include "ClientPermissionsMessage.h"

#ifdef WITH_SWGREALMS_API
#include "server/login/SWGRealmsAPI.h"
#endif // WITH_SWGREALMS_API

class ClientIdMessageCallback : public MessageCallback {
	uint32 gameBits{};
	uint32 dataLen;
	String sessionID;
	uint32 accountID;
	String version;

public:
	ClientIdMessageCallback(ZoneClientSession* client, ZoneProcessServer* server) : MessageCallback(client, server), dataLen(0), accountID(0) {
		setCustomTaskQueue("slowQueue");
	}

	void parse(Message* message) {
		gameBits = message->parseInt();
		dataLen = message->parseInt() - 4; //accountid embedded

		StringBuffer buf;

		for (uint32 i = 0; i < dataLen; ++i) {
			buf << static_cast<char>(message->parseByte());
		}

		sessionID = buf.toString();

		accountID = message->parseInt();
		version = message->parseAscii();
	}

	void run() {
#ifdef WITH_SWGREALMS_API
		SWGRealmsAPI::instance()->validateSession(sessionID, accountID, client->getSession()->getIPAddress(),
				[zoneClient = Reference<ZoneClientSession*>(client),
				zoneServer = server,
				approved_sessionID = sessionID,
				approved_accountID = accountID](const SessionApprovalResult& result) {

			if (!result.isActionAllowed()) {
				zoneClient->sendMessage(new ErrorMessage(result.getTitle(), result.getMessage(), 0x0));
				zoneClient->info(true) << "Invalid session in ClientIDMessageCallback: " << result.getLogMessage();
				return;
			}

			SWGRealmsAPI::updateClientIPAddress(zoneClient, result);

			approveSession(zoneClient, zoneServer, approved_sessionID, approved_accountID);
		});
#else // WITH_SWGREALMS_API
		// Check client version
		const String& validClient = ConfigManager::instance()->getLoginRequiredVersion();

		if (version != validClient) {
			ErrorMessage* errMsg = new ErrorMessage("Login Error", "You are using an improper client version.", 0x0);
			client->sendMessage(errMsg);

			return;
		}

		approveSession(client, server, sessionID, accountID);
#endif // WITH_SWGREALMS_API
	}

	static void approveSession(ZoneClientSession* client, ZoneProcessServer* server, String sessionID, uint32 accountID) {
		auto zoneServer = server->getZoneServer();

		if (zoneServer == nullptr) {
			return;
		}

#ifdef WITH_SWGREALMS_API
		client->setSessionID(sessionID);
		client->setAccountID(accountID);
		auto account = AccountManager::getAccount(accountID, true);
		if (account == nullptr) {
			return;
		}
#else
		auto connection = client->getSession();
		if (connection == nullptr)
			return;

		Reference<Account*> account;
		try {
			account = AccountManager::getAccountForZoneSession(accountID, sessionID, connection->getIPAddress());
		} catch (const DatabaseException& e) {
			client->error() << e.getMessage();
			client->sendMessage(new ErrorMessage("Login Error", "Unable to verify your session. Please log in again.", 0x0));
			return;
		}
		if (account == nullptr) {
			client->sendMessage(new ErrorMessage("Login Error", "Your session key is invalid, or has expired. Please re-login", 0x0));
			return;
		}
		client->setSessionID(sessionID);
		client->setAccountID(accountID);
#endif

		// Lock the account object
		Locker alocker(account);

		client->resetCharacters();

		int galaxyID = zoneServer->getGalaxyID();

		Reference<CharacterList*> characters = account->getCharacterList();
		const GalaxyBanEntry* galaxyBan = account->getGalaxyBan(galaxyID);

		bool canConnect = true;

		if (galaxyBan != nullptr) {
			ErrorMessage* errMsg = new ErrorMessage("Login Error", "You are banned from this galaxy.\n\nReason:" + galaxyBan->getBanReason(), 0x0);
			client->sendMessage(errMsg);

			canConnect = false;
		} else {
			for (int i = 0; i < characters->size(); ++i) {
				const CharacterListEntry* entry = &characters->get(i);

				if (!entry->isBanned()) {
					client->addCharacter(entry->getObjectID(), entry->getGalaxyID());
				} else {
					client->addBannedCharacter(entry->getObjectID(), entry->getGalaxyID());
				}
			}

			if (zoneServer->isServerLoading() || zoneServer->isServerShuttingDown()) {
				canConnect = false;
			}
		}

		auto allowedChars = ConfigManager::instance()->getInt("Core3.PlayerCreationManager.MaxCharactersPerGalaxy", 10);
		bool canCreateCharacter = (client->getCharacterCount(galaxyID) < allowedChars);

		// Check if player has permission to create more characters
		auto permissionMessage = new ClientPermissionsMessage(canConnect, canCreateCharacter);
		client->sendMessage(permissionMessage);
	}

	inline uint32 getDataLen() const {
		return dataLen;
	}

	inline const String& getSessionID() const {
		return sessionID;
	}

	inline uint32 getAccountID() const {
		return accountID;
	}
};

#endif /* CLIENTIDMESSAGECALLBACK_H_ */
