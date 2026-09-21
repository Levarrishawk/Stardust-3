/*
				Copyright <SWGEmu>
		See file COPYING for copying conditions.*/

#ifndef PVPCOMMAND_H_
#define PVPCOMMAND_H_

#include "server/zone/objects/player/sui/listbox/SuiListBox.h"
#include "server/zone/objects/player/sui/callbacks/PvpStatusSuiCallback.h"
#include "templates/faction/Factions.h"

class PvpCommand : public QueueCommand {
public:
	PvpCommand(const String& name, ZoneProcessServer* server)
		: QueueCommand(name, server) {
	}

	int doQueueCommand(CreatureObject* creature, const uint64& target, const UnicodeString& arguments) const {
		if (!PvpStatusCommandChecks::validate(creature))
			return GENERALERROR;

		if (!checkStateMask(creature))
			return INVALIDSTATE;

		if (!checkInvalidLocomotions(creature))
			return INVALIDLOCOMOTION;

		ManagedReference<PlayerObject*> ghost = creature->getPlayerObject();

		if (ghost == nullptr)
			return GENERALERROR;

		ghost->closeSuiWindowType(SuiWindowType::PVP_STATUS_SELECTION);

		ManagedReference<SuiListBox*> sui = new SuiListBox(creature, SuiWindowType::PVP_STATUS_SELECTION);
		sui->setPromptTitle("PvP Faction Status");
		sui->setPromptText("Select your faction status:");
		sui->setCancelButton(true, "@ui:cancel");
		sui->setOkButton(true, "@ui:ok");
		sui->setCallback(new PvpStatusSuiCallback(server->getZoneServer()));

		sui->addMenuItem("On Leave");
		sui->addMenuItem("Combatant");
		sui->addMenuItem("Special Forces");

		ghost->addSuiBox(sui);
		creature->sendMessage(sui->generateMessage());

		return SUCCESS;
	}
};

#endif // PVPCOMMAND_H_
