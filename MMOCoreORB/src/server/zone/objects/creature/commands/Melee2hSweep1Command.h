/*
				Copyright <SWGEmu>
		See file COPYING for copying conditions.*/

#ifndef MELEE2HSWEEP1COMMAND_H_
#define MELEE2HSWEEP1COMMAND_H_

#include "CombatQueueCommand.h"

class Melee2hSweep1Command : public CombatQueueCommand {
public:

	Melee2hSweep1Command(const String& name, ZoneProcessServer* server)
		: CombatQueueCommand(name, server) {
	}

	void applyMovementControlOnHit(CreatureObject* creature, CreatureObject* targetCreature) const override {
		applyMovementControl(creature, targetCreature, "melee2hsweep1", "Two-Hand Sweep", 36, 0.01f, 6);
	}

	int doQueueCommand(CreatureObject* creature, const uint64& target, const UnicodeString& arguments) const {

		if (!checkStateMask(creature))
			return INVALIDSTATE;

		if (!checkInvalidLocomotions(creature))
			return INVALIDLOCOMOTION;

		return doCombatAction(creature, target);
	}

};

#endif //MELEE2HSWEEP1COMMAND_H_
