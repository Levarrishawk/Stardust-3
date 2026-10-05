/*
				Copyright <SWGEmu>
		See file COPYING for copying conditions.*/

#ifndef POLEARMLEGHIT1COMMAND_H_
#define POLEARMLEGHIT1COMMAND_H_

#include "CombatQueueCommand.h"

class PolearmLegHit1Command : public CombatQueueCommand {
public:

	PolearmLegHit1Command(const String& name, ZoneProcessServer* server)
		: CombatQueueCommand(name, server) {
	}

	void applyMovementControlOnHit(CreatureObject* creature, CreatureObject* targetCreature) const override {
		applyMovementControl(creature, targetCreature, "polearmleghit1", "Polearm Leg Hit", 36, 0.75f, 5);
	}

	int doQueueCommand(CreatureObject* creature, const uint64& target, const UnicodeString& arguments) const {

		if (!checkStateMask(creature))
			return INVALIDSTATE;

		if (!checkInvalidLocomotions(creature))
			return INVALIDLOCOMOTION;

		return doCombatAction(creature, target);
	}

};

#endif //POLEARMLEGHIT1COMMAND_H_
