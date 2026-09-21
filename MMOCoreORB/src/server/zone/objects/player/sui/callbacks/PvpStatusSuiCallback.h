#ifndef PVPSTATUSSUICALLBACK_H_
#define PVPSTATUSSUICALLBACK_H_

#include "server/zone/objects/player/sui/SuiCallback.h"
#include "server/zone/objects/player/sui/listbox/SuiListBox.h"
#include "server/zone/objects/player/PlayerObject.h"
#include "server/zone/objects/player/FactionStatus.h"
#include "server/zone/Zone.h"
#include "templates/faction/Factions.h"

class PvpStatusCommandChecks {
public:
	static bool validate(CreatureObject* player) {
		if (player == nullptr)
			return false;

		uint32 faction = player->getFaction();

		if (faction != Factions::FACTIONREBEL && faction != Factions::FACTIONIMPERIAL) {
			player->sendSystemMessage("You must be a member of a faction to use this command.");
			return false;
		}

		if (player->isDead()) {
			player->sendSystemMessage("You can not change your faction status while dead.");
			return false;
		}

		if (player->isIncapacitated()) {
			player->sendSystemMessage("You can not change your faction status while incapacitated.");
			return false;
		}

		if (player->isInCombat()) {
			player->sendSystemMessage("You must not be in combat to use this command.");
			return false;
		}

		PlayerObject* ghost = player->getPlayerObject();

		if (ghost != nullptr && ghost->getActivePetsSize() > 0) {
			player->sendSystemMessage("You must store your pet before using this command.");
			return false;
		}

		Zone* zone = player->getZone();

		if (zone != nullptr && (zone->getZoneName() == "elysium" || zone->getZoneName() == "elysium2")) {
			player->sendSystemMessage("You can not change your faction status while dead.");
			return false;
		}

		if (player->getFutureFactionStatus() != -1) {
			player->sendSystemMessage("A faction status change is already in progress.");
			return false;
		}

		return true;
	}
};

class PvpStatusSuiCallback : public SuiCallback {
public:
	PvpStatusSuiCallback(ZoneServer* server)
		: SuiCallback(server) {
	}

	void run(CreatureObject* player, SuiBox* suiBox, uint32 eventIndex, Vector<UnicodeString>* args) {
		if (player == nullptr || suiBox == nullptr || args == nullptr || !suiBox->isListBox() || eventIndex == 1 || args->size() < 1)
			return;

		if (!PvpStatusCommandChecks::validate(player))
			return;

		int index = Integer::valueOf(args->get(0).toString());
		SuiListBox* listBox = cast<SuiListBox*>(suiBox);

		if (index < 0 || index >= listBox->getMenuSize())
			return;

		int newStatus = FactionStatus::ONLEAVE;

		switch (index) {
		case 0:
			newStatus = FactionStatus::ONLEAVE;
			break;
		case 1:
			newStatus = FactionStatus::COVERT;
			break;
		case 2:
			newStatus = FactionStatus::OVERT;
			break;
		default:
			return;
		}

		int currentStatus = player->getFactionStatus();

		if (currentStatus == newStatus)
			return;

		int transitionTime = 0;

		if (currentStatus == FactionStatus::ONLEAVE) {
			transitionTime = 30000;
		} else if (currentStatus == FactionStatus::COVERT) {
			transitionTime = newStatus == FactionStatus::OVERT ? 30000 : 300000;
		} else if (currentStatus == FactionStatus::OVERT) {
			transitionTime = 300000;
		} else {
			return;
		}

		if (newStatus == FactionStatus::ONLEAVE) {
			player->sendSystemMessage("Your faction status will change to On Leave in 5 minutes.");
		} else if (newStatus == FactionStatus::COVERT) {
			player->sendSystemMessage(transitionTime == 30000 ? "Your faction status will change to Combatant in 30 seconds." : "Your faction status will change to Combatant in 5 minutes.");
		} else {
			player->sendSystemMessage("Your faction status will change to Special Forces in 30 seconds.");
		}

		player->setFutureFactionStatus(newStatus);

		ManagedReference<CreatureObject*> playerReference = player->asCreatureObject();

		Core::getTaskManager()->scheduleTask([playerReference, newStatus] {
			if (playerReference == nullptr)
				return;

			Locker locker(playerReference);

			if (playerReference->getFutureFactionStatus() == newStatus)
				playerReference->setFactionStatus(newStatus);
		}, "PvpStatusTransitionTask", transitionTime);
	}
};

#endif // PVPSTATUSSUICALLBACK_H_
