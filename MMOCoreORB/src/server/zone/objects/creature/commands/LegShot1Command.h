/*
				Copyright <SWGEmu>
		See file COPYING for copying conditions.*/

#ifndef LEGSHOT1COMMAND_H_
#define LEGSHOT1COMMAND_H_

#include "CombatQueueCommand.h"

class LegShot1Command : public CombatQueueCommand {
public:

	LegShot1Command(const String& name, ZoneProcessServer* server)
		: CombatQueueCommand(name, server) {
	}

	void applyMovementControlOnHit(CreatureObject* creature, CreatureObject* targetCreature) const override {
		applyMovementControl(creature, targetCreature, "legShot1", "Leg Shot", 36, 0.75f, 10);
	}

	int doQueueCommand(CreatureObject* creature, const uint64& target, const UnicodeString& arguments) const {

		if (!checkStateMask(creature))
			return INVALIDSTATE;

		if (!checkInvalidLocomotions(creature))
			return INVALIDLOCOMOTION;

		return doCombatAction(creature, target);
	}

};

#endif //LEGSHOT1COMMAND_H_
