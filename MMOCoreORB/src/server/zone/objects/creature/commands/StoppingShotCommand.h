/*
				Copyright <SWGEmu>
		See file COPYING for copying conditions.*/

#ifndef STOPPINGSHOTCOMMAND_H_
#define STOPPINGSHOTCOMMAND_H_

#include "CombatQueueCommand.h"

class StoppingShotCommand : public CombatQueueCommand {
public:

	StoppingShotCommand(const String& name, ZoneProcessServer* server)
		: CombatQueueCommand(name, server) {
	}

	void applyMovementControlOnHit(CreatureObject* creature, CreatureObject* targetCreature) const override {
		applyMovementControl(creature, targetCreature, "stoppingShot", "Stopping Shot", 36, 0.01f, 6);
	}

	int doQueueCommand(CreatureObject* creature, const uint64& target, const UnicodeString& arguments) const {

		if (!checkStateMask(creature))
			return INVALIDSTATE;

		if (!checkInvalidLocomotions(creature))
			return INVALIDLOCOMOTION;

		return doCombatAction(creature, target);
	}

};

#endif //STOPPINGSHOTCOMMAND_H_
