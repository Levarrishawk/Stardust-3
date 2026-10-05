/*
				Copyright <SWGEmu>
		See file COPYING for copying conditions.*/

#ifndef LEGSHOT3COMMAND_H_
#define LEGSHOT3COMMAND_H_

#include "CombatQueueCommand.h"

class LegShot3Command : public CombatQueueCommand {
public:

	LegShot3Command(const String& name, ZoneProcessServer* server)
		: CombatQueueCommand(name, server) {
	}

	void applyMovementControlOnHit(CreatureObject* creature, CreatureObject* targetCreature) const override {
		applyMovementControl(creature, targetCreature, "legShot3", "Advanced Leg Shot", 36, 0.45f, 10);
	}

	int doQueueCommand(CreatureObject* creature, const uint64& target, const UnicodeString& arguments) const {

		if (!checkStateMask(creature))
			return INVALIDSTATE;

		if (!checkInvalidLocomotions(creature))
			return INVALIDLOCOMOTION;

		return doCombatAction(creature, target);
	}

};

#endif //LEGSHOT3COMMAND_H_
