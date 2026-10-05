/*
				Copyright <SWGEmu>
		See file COPYING for copying conditions.*/

#ifndef MELEE2HSWEEP2COMMAND_H_
#define MELEE2HSWEEP2COMMAND_H_

#include "CombatQueueCommand.h"

class Melee2hSweep2Command : public CombatQueueCommand {
public:

	Melee2hSweep2Command(const String& name, ZoneProcessServer* server)
		: CombatQueueCommand(name, server) {
	}

	void applyMovementControlOnHit(CreatureObject* creature, CreatureObject* targetCreature) const override {
		applyMovementControl(creature, targetCreature, "melee2hsweep2", "Improved Two-Hand Sweep", 36, 0.01f, 8);
	}

	int doQueueCommand(CreatureObject* creature, const uint64& target, const UnicodeString& arguments) const {

		if (!checkStateMask(creature))
			return INVALIDSTATE;

		if (!checkInvalidLocomotions(creature))
			return INVALIDLOCOMOTION;

		return doCombatAction(creature, target);
	}

};

#endif //MELEE2HSWEEP2COMMAND_H_
