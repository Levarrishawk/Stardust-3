/*
				Copyright <SWGEmu>
		See file COPYING for copying conditions.*/

#ifndef MELEE1HBODYHIT3COMMAND_H_
#define MELEE1HBODYHIT3COMMAND_H_

#include "CombatQueueCommand.h"

class Melee1hBodyHit3Command : public CombatQueueCommand {
public:

	Melee1hBodyHit3Command(const String& name, ZoneProcessServer* server)
		: CombatQueueCommand(name, server) {
	}

	void applyMovementControlOnHit(CreatureObject* creature, CreatureObject* targetCreature) const override {
		applyMovementControl(creature, targetCreature, "melee1hbodyhit3", "Advanced One-Hand Body Hit", 36, 0.01f, 10);
	}

	int doQueueCommand(CreatureObject* creature, const uint64& target, const UnicodeString& arguments) const {

		if (!checkStateMask(creature))
			return INVALIDSTATE;

		if (!checkInvalidLocomotions(creature))
			return INVALIDLOCOMOTION;

		return doCombatAction(creature, target);
	}

};

#endif //MELEE1HBODYHIT3COMMAND_H_
