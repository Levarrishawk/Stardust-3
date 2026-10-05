/*
				Copyright <SWGEmu>
		See file COPYING for copying conditions.*/

#ifndef POLEARMLEGHIT2COMMAND_H_
#define POLEARMLEGHIT2COMMAND_H_

#include "CombatQueueCommand.h"

class PolearmLegHit2Command : public CombatQueueCommand {
public:

	PolearmLegHit2Command(const String& name, ZoneProcessServer* server)
		: CombatQueueCommand(name, server) {
	}

	void applyMovementControlOnHit(CreatureObject* creature, CreatureObject* targetCreature) const override {
		applyMovementControl(creature, targetCreature, "polearmleghit2", "Improved Polearm Leg Hit", 36, 0.60f, 7);
	}

	int doQueueCommand(CreatureObject* creature, const uint64& target, const UnicodeString& arguments) const {

		if (!checkStateMask(creature))
			return INVALIDSTATE;

		if (!checkInvalidLocomotions(creature))
			return INVALIDLOCOMOTION;

		return doCombatAction(creature, target);
	}

};

#endif //POLEARMLEGHIT2COMMAND_H_
