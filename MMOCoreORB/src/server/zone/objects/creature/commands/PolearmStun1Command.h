/*
				Copyright <SWGEmu>
		See file COPYING for copying conditions.*/

#ifndef POLEARMSTUN1COMMAND_H_
#define POLEARMSTUN1COMMAND_H_

#include "CombatQueueCommand.h"

class PolearmStun1Command : public CombatQueueCommand {
public:

	PolearmStun1Command(const String& name, ZoneProcessServer* server)
		: CombatQueueCommand(name, server) {
	}

	void applyMovementControlOnHit(CreatureObject* creature, CreatureObject* targetCreature) const override {
		applyMovementControl(creature, targetCreature, "polearmstun1", "Polearm Stun", 36, 0.01f, 6);
	}

	int doQueueCommand(CreatureObject* creature, const uint64& target, const UnicodeString& arguments) const {

		if (!checkStateMask(creature))
			return INVALIDSTATE;

		if (!checkInvalidLocomotions(creature))
			return INVALIDLOCOMOTION;

		return doCombatAction(creature, target);
	}

};

#endif //POLEARMSTUN1COMMAND_H_
