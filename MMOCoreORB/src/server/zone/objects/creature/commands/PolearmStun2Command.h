/*
				Copyright <SWGEmu>
		See file COPYING for copying conditions.*/

#ifndef POLEARMSTUN2COMMAND_H_
#define POLEARMSTUN2COMMAND_H_

#include "CombatQueueCommand.h"

class PolearmStun2Command : public CombatQueueCommand {
public:

	PolearmStun2Command(const String& name, ZoneProcessServer* server)
		: CombatQueueCommand(name, server) {
	}

	void applyMovementControlOnHit(CreatureObject* creature, CreatureObject* targetCreature) const override {
		applyMovementControl(creature, targetCreature, "polearmstun2", "Improved Polearm Stun", 36, 0.01f, 8);
	}

	int doQueueCommand(CreatureObject* creature, const uint64& target, const UnicodeString& arguments) const {

		if (!checkStateMask(creature))
			return INVALIDSTATE;

		if (!checkInvalidLocomotions(creature))
			return INVALIDLOCOMOTION;

		return doCombatAction(creature, target);
	}

};

#endif //POLEARMSTUN2COMMAND_H_
