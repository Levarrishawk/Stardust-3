/*
 				Copyright <SWGEmu>
		See file COPYING for copying conditions. */

#include "PlayerObjectMenuComponent.h"
#include "server/zone/packets/object/ObjectMenuResponse.h"
#include "server/zone/objects/creature/CreatureObject.h"
#include "server/zone/objects/player/PlayerObject.h"
#include "server/zone/objects/group/GroupObject.h"
#include "server/zone/managers/player/PlayerManager.h"
#include "server/zone/managers/mission/MissionManager.h"
#include "server/zone/managers/radial/RadialOptions.h"
#include "server/zone/objects/mission/MissionObject.h"
#include "server/zone/objects/mission/BountyMissionObjective.h"

void PlayerObjectMenuComponent::fillObjectMenuResponse(SceneObject* sceneObject, ObjectMenuResponse* menuResponse, CreatureObject* player) const {
	if (!sceneObject->isCreatureObject())
		return;

	CreatureObject* creature = cast<CreatureObject*>(sceneObject);
	GroupObject* group = creature->getGroup();
	PlayerObject* ghost = player->getPlayerObject();
	PlayerObject* targetGhost = creature->getPlayerObject();

	if (group != nullptr) {
		if (group->hasMember(player))
			menuResponse->addRadialMenuItem(51, 3, "@sui:teach");
	}

	if (creature->isPlayingMusic()) {
		if (!player->isListening())
			menuResponse->addRadialMenuItem(113, 3, "@radial_performance:listen");
		else
			menuResponse->addRadialMenuItem(115, 3, "@radial_performance:listen_stop");
	} else if (creature->isDancing()) {
		if (!player->isWatching())
			menuResponse->addRadialMenuItem(114, 3, "@radial_performance:watch");
		else
			menuResponse->addRadialMenuItem(116, 3, "@radial_performance:watch_stop");
	}

	// Allow admins to grant divorce to married players
	if (targetGhost != nullptr && targetGhost->isMarried() && ghost != nullptr && ghost->isPrivileged()) {
		menuResponse->addRadialMenuItem(117, 3, "@unity:mnu_divorce"); // "Divorce"
	}

	if (targetGhost != nullptr && creature != player && creature->isIncapacitated() && !creature->isDead() && !creature->isFeigningDeath()) {
		MissionManager* missionManager = player->getZoneServer()->getMissionManager();
		Reference<MissionObject*> mission = missionManager == nullptr ? nullptr : missionManager->getBountyHunterMission(player);

		if (mission != nullptr && mission->getTargetObjectId() == creature->getObjectID())
			menuResponse->addRadialMenuItem(RadialOptions::SERVER_MENU10, 3, "Arrest");
	}
}

int PlayerObjectMenuComponent::handleObjectMenuSelect(SceneObject* sceneObject, CreatureObject* player, byte selectedID) const {
	ManagedReference<CreatureObject*> ownerPlayer = dynamic_cast<CreatureObject*> (sceneObject);
	PlayerObject* ghost = player->getPlayerObject();

	switch (selectedID) {
	case 113:
		player->executeObjectControllerAction(0x5855BB1B, sceneObject->getObjectID(), ""); // listen
		break;
	case 115:
		player->executeObjectControllerAction(0xC2E4D4D0, sceneObject->getObjectID(), ""); // stoplistening
		break;
	case 114:
		player->executeObjectControllerAction(0xEC93CA43, sceneObject->getObjectID(), ""); // watch
		break;
	case 116:
		player->executeObjectControllerAction(0x6651AD9A, sceneObject->getObjectID(), ""); // stopwatching
		break;
	case 51:
		player->executeObjectControllerAction(0x5041F83A, sceneObject->getObjectID(), ""); // teach
		break;
	case 117:
		if (ghost != nullptr && ghost->isPrivileged()) {
			PlayerManager* playerManager = player->getZoneServer()->getPlayerManager();

			Core::getTaskManager()->executeTask([=] () {
				Locker locker(ownerPlayer);

				playerManager->grantDivorce(ownerPlayer);
			}, "GrantDivorceLambda");
		}
		break;
	case RadialOptions::SERVER_MENU10: {
		MissionManager* missionManager = player->getZoneServer()->getMissionManager();
		Reference<MissionObject*> mission = missionManager == nullptr ? nullptr : missionManager->getBountyHunterMission(player);

		if (mission == nullptr || mission->getTargetObjectId() != ownerPlayer->getObjectID()) {
			player->sendSystemMessage("You do not have an active bounty mission for this target.");
			break;
		}

		ManagedReference<BountyMissionObjective*> objective = cast<BountyMissionObjective*>(mission->getMissionObjective());

		if (objective == nullptr || !objective->arrestPlayerTarget(ownerPlayer))
			player->sendSystemMessage("The target must be incapacitated and within five meters to be arrested.");

		break;
	}
	}

	return 0;
}
