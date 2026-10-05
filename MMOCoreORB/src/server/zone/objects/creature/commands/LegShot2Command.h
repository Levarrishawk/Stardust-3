/*
				Copyright <SWGEmu>
		See file COPYING for copying conditions.*/

#ifndef LEGSHOT2COMMAND_H_
#define LEGSHOT2COMMAND_H_

#include "CombatQueueCommand.h"

class LegShot2Command : public CombatQueueCommand {
public:

	LegShot2Command(const String& name, ZoneProcessServer* server)
		: CombatQueueCommand(name, server) {
	}

	void applyMovementControlOnHit(CreatureObject* creature, CreatureObject* targetCreature) const override {
		applyMovementControl(creature, targetCreature, "legShot2", "Improved Leg Shot", 36, 0.60f, 10);
	}

	int doQueueCommand(CreatureObject* creature, const uint64& target, const UnicodeString& arguments) const {

		if (!checkStateMask(creature))
			return INVALIDSTATE;

		if (!checkInvalidLocomotions(creature))
			return INVALIDLOCOMOTION;

		return doCombatAction(creature, target);
	}

};

#endif //LEGSHOT2COMMAND_H_
