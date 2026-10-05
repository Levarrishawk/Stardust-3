/*
				Copyright <SWGEmu>
		See file COPYING for copying conditions.*/

#ifndef MELEE1HBODYHIT1COMMAND_H_
#define MELEE1HBODYHIT1COMMAND_H_

#include "CombatQueueCommand.h"

class Melee1hBodyHit1Command : public CombatQueueCommand {
public:

	Melee1hBodyHit1Command(const String& name, ZoneProcessServer* server)
		: CombatQueueCommand(name, server) {
	}

	void applyMovementControlOnHit(CreatureObject* creature, CreatureObject* targetCreature) const override {
		applyMovementControl(creature, targetCreature, "melee1hbodyhit1", "One-Hand Body Hit", 36, 0.01f, 6);
	}

	int doQueueCommand(CreatureObject* creature, const uint64& target, const UnicodeString& arguments) const {

		if (!checkStateMask(creature))
			return INVALIDSTATE;

		if (!checkInvalidLocomotions(creature))
			return INVALIDLOCOMOTION;

		return doCombatAction(creature, target);
	}

};

#endif //MELEE1HBODYHIT1COMMAND_H_
