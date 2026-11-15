#ifndef INSPIRECOMMAND_H_
#define INSPIRECOMMAND_H_

#include "server/zone/objects/player/sessions/Inspiration.h"

class InspireCommand : public QueueCommand {
public:
	InspireCommand(const String& name, ZoneProcessServer* server) : QueueCommand(name, server) {
		setDefaultPriority(IMMEDIATE);
	}

	int doQueueCommand(CreatureObject* creature, const uint64& target, const UnicodeString& arguments) const override {
		if (!checkStateMask(creature))
			return INVALIDSTATE;

		if (!checkInvalidLocomotions(creature))
			return INVALIDLOCOMOTION;

		ZoneServer* zoneServer = creature->getZoneServer();
		if (!creature->isPlayerCreature() || zoneServer == nullptr)
			return GENERALERROR;

		ManagedReference<CreatureObject*> patron = zoneServer->getObject(target).castTo<CreatureObject*>();
		Inspiration::open(creature, patron);
		return SUCCESS;
	}
};

#endif // INSPIRECOMMAND_H_
