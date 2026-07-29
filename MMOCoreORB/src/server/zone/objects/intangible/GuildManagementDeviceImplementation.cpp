/*
 * GuildManagementDeviceImplementation.cpp
 */

#include "server/zone/objects/intangible/GuildManagementDevice.h"
#include "server/zone/ZoneServer.h"
#include "server/zone/managers/guild/GuildManager.h"
#include "server/zone/objects/creature/CreatureObject.h"
#include "server/zone/objects/guild/GuildObject.h"
#include "server/zone/objects/player/PlayerObject.h"
#include "server/zone/packets/object/ObjectMenuResponse.h"

void GuildManagementDeviceImplementation::fillObjectMenuResponse(ObjectMenuResponse* menuResponse, CreatureObject* player) {
	if (player == nullptr || !isASubChildOf(player))
		return;

	ManagedReference<PlayerObject*> playerGhost = player->getPlayerObject().get();
	ManagedReference<GuildObject*> guildObject = player->getGuildObject().get();

	if (playerGhost == nullptr || guildObject == nullptr)
		return;

	uint64 playerID = player->getObjectID();

	if (!guildObject->hasMember(playerID) && !playerGhost->isPrivileged())
		return;

	bool isLeader = guildObject->getGuildLeaderID() == playerID;

	menuResponse->addRadialMenuItem(193, 3, "@guild:menu_guild_management");
	menuResponse->addRadialMenuItemToRadialID(193, 186, 3, "@guild:menu_info");
	menuResponse->addRadialMenuItemToRadialID(193, 189, 3, "@guild:menu_enemies");

	if (guildObject->hasDisbandPermission(playerID))
		menuResponse->addRadialMenuItemToRadialID(193, 191, 3, "@guild:menu_disband");

	if (guildObject->hasNamePermission(playerID) || playerGhost->isPrivileged())
		menuResponse->addRadialMenuItemToRadialID(193, 192, 3, "@guild:menu_namechange");

	menuResponse->addRadialMenuItem(194, 3, "@guild:menu_member_management");
	menuResponse->addRadialMenuItemToRadialID(194, 187, 3, "@guild:menu_members");

	if (guildObject->getSponsoredPlayerCount() > 0)
		menuResponse->addRadialMenuItemToRadialID(194, 188, 3, "@guild:menu_sponsored");

	if (guildObject->hasMember(playerID))
		menuResponse->addRadialMenuItemToRadialID(194, 190, 3, "@guild:menu_sponsor");

	if (guildObject->isElectionEnabled()) {
		menuResponse->addRadialMenuItem(70, 3, "@guild:menu_leader_race");
		menuResponse->addRadialMenuItemToRadialID(70, 71, 3, "@guild:menu_leader_standings");

		if (guildObject->hasMember(playerID)) {
			menuResponse->addRadialMenuItemToRadialID(70, 72, 3, "@guild:menu_leader_vote");

			if (guildObject->isCandidate(playerID))
				menuResponse->addRadialMenuItemToRadialID(70, 73, 3, "@guild:menu_leader_unregister");
			else
				menuResponse->addRadialMenuItemToRadialID(70, 73, 3, "@guild:menu_leader_register");
		}

		if (isLeader) {
			menuResponse->addRadialMenuItemToRadialID(70, 74, 3, "@guild:menu_leader_reset_vote");
			menuResponse->addRadialMenuItemToRadialID(70, 75, 3, "@guild:menu_disable_elections");
		}
	} else if (isLeader) {
		menuResponse->addRadialMenuItem(70, 3, "@guild:menu_leader_race");
		menuResponse->addRadialMenuItemToRadialID(70, 75, 3, "@guild:menu_enable_elections");
	}
}

int GuildManagementDeviceImplementation::handleObjectMenuSelect(CreatureObject* player, byte selectedID) {
	Locker _lock(_this.getReferenceUnsafeStaticCast());

	if (player == nullptr || !isASubChildOf(player))
		return 1;

	ManagedReference<GuildManager*> guildManager = getZoneServer()->getGuildManager();
	ManagedReference<PlayerObject*> playerGhost = player->getPlayerObject().get();
	ManagedReference<GuildObject*> guildObject = player->getGuildObject().get();

	if (guildManager == nullptr || playerGhost == nullptr || guildObject == nullptr)
		return 1;

	uint64 playerID = player->getObjectID();
	bool isMember = guildObject->hasMember(playerID);
	bool isLeader = guildObject->getGuildLeaderID() == playerID;
	SceneObject* device = _this.getReferenceUnsafeStaticCast();

	switch (selectedID) {
	case 70:
		if (isLeader && !guildObject->isElectionEnabled())
			guildManager->toggleElection(guildObject, player);
		else if (guildObject->isElectionEnabled())
			guildManager->viewElectionStandings(guildObject, player, device);
		break;
	case 71:
		if (guildObject->isElectionEnabled())
			guildManager->viewElectionStandings(guildObject, player, device);
		break;
	case 72:
		if (isMember && guildObject->isElectionEnabled())
			guildManager->promptCastVote(guildObject, player, device);
		break;
	case 73:
		if (isMember && guildObject->isElectionEnabled()) {
			if (guildObject->isCandidate(playerID))
				guildManager->unregisterFromElection(guildObject, player);
			else
				guildManager->registerForElection(guildObject, player);
		}
		break;
	case 74:
		if (isLeader && guildObject->isElectionEnabled())
			guildManager->resetElection(guildObject, player);
		break;
	case 75:
		if (isLeader)
			guildManager->toggleElection(guildObject, player);
		break;
	case 189:
		if (isMember || playerGhost->isPrivileged())
			guildManager->sendGuildWarStatusTo(player, guildObject, device);
		break;
	case 193:
	case 186:
		if (isMember || playerGhost->isPrivileged())
			guildManager->sendGuildInformationTo(player, guildObject, device);
		break;
	case 191:
		guildManager->sendGuildDisbandConfirmTo(player, guildObject, device);
		break;
	case 194:
	case 187:
		if (isMember || playerGhost->isPrivileged())
			guildManager->sendGuildMemberListTo(player, guildObject, device);
		break;
	case 188:
		if (isMember || playerGhost->isPrivileged())
			guildManager->sendGuildSponsoredListTo(player, guildObject, device);
		break;
	case 190:
		if (isMember || playerGhost->isPrivileged())
			guildManager->sendGuildSponsorTo(player, guildObject, device);
		break;
	case 192:
		guildManager->sendGuildChangeNameTo(player, guildObject);
		break;
	default:
		return IntangibleObjectImplementation::handleObjectMenuSelect(player, selectedID);
	}

	return 0;
}
