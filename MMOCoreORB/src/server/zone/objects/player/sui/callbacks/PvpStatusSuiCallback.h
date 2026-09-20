#ifndef PVPSTATUSSUICALLBACK_H_
#define PVPSTATUSSUICALLBACK_H_

#include "server/zone/objects/player/sui/SuiCallback.h"
#include "server/zone/objects/player/sui/listbox/SuiListBox.h"
#include "server/zone/objects/player/FactionStatus.h"
#include "templates/faction/Factions.h"

class PvpStatusSuiCallback : public SuiCallback {
public:
	PvpStatusSuiCallback(ZoneServer* server)
		: SuiCallback(server) {
	}

	void run(CreatureObject* player, SuiBox* suiBox, uint32 eventIndex, Vector<UnicodeString>* args) {
		if (player == nullptr || suiBox == nullptr || args == nullptr || !suiBox->isListBox() || eventIndex == 1 || args->size() < 1)
			return;

		uint32 faction = player->getFaction();

		if (faction != Factions::FACTIONREBEL && faction != Factions::FACTIONIMPERIAL) {
			player->sendSystemMessage("You must be a member of a faction to use this command.");
			return;
		}

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

		if (player->getFactionStatus() != newStatus)
			player->setFactionStatus(newStatus);
	}
};

#endif // PVPSTATUSSUICALLBACK_H_
