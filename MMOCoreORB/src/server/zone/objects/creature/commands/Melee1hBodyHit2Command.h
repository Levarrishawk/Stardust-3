/*
				Copyright <SWGEmu>
		See file COPYING for copying conditions.*/

#ifndef MELEE1HBODYHIT2COMMAND_H_
#define MELEE1HBODYHIT2COMMAND_H_

#include "CombatQueueCommand.h"

class Melee1hBodyHit2Command : public CombatQueueCommand {
public:

	Melee1hBodyHit2Command(const String& name, ZoneProcessServer* server)
		: CombatQueueCommand(name, server) {
	}

	void applyMovementControlOnHit(CreatureObject* creature, CreatureObject* targetCreature) const override {
		applyMovementControl(creature, targetCreature, "melee1hbodyhit2", "Improved One-Hand Body Hit", 36, 0.01f, 8);
	}

	int doQueueCommand(CreatureObject* creature, const uint64& target, const UnicodeString& arguments) const {

		if (!checkStateMask(creature))
			return INVALIDSTATE;

		if (!checkInvalidLocomotions(creature))
			return INVALIDLOCOMOTION;

		return doCombatAction(creature, target);
	}

};

#endif //MELEE1HBODYHIT2COMMAND_H_
