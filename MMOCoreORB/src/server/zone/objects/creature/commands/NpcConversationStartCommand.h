/*
				Copyright <SWGEmu>
		See file COPYING for copying conditions.*/

#ifndef NPCCONVERSATIONSTARTCOMMAND_H_
#define NPCCONVERSATIONSTARTCOMMAND_H_

#include "server/zone/objects/scene/SceneObject.h"
#include "server/zone/objects/ship/ai/SpaceStationObject.h"

class NpcConversationStartCommand : public QueueCommand {
public:
	NpcConversationStartCommand(const String& name, ZoneProcessServer* server) : QueueCommand(name, server) {
	}

	int doQueueCommand(CreatureObject* creature, const uint64& target, const UnicodeString& arguments) const {
		if (!checkStateMask(creature)) {
			return INVALIDSTATE;
		}

		if (!checkInvalidLocomotions(creature)) {
			return INVALIDLOCOMOTION;
		}

		if (!creature->isPlayerCreature()) {
			return GENERALERROR;
		}

		auto ghost = creature->getPlayerObject();

		if (ghost == nullptr) {
			return GENERALERROR;
		}

		auto zoneServer = creature->getZoneServer();

		if (zoneServer == nullptr) {
			return GENERALERROR;
		}

		ManagedReference<SceneObject*> object = zoneServer->getObject(target);

		if (object == nullptr)
			return GENERALERROR;

		if (object->isAiAgent()) {
			AiAgent* agent = object->asAiAgent();

			if (agent == nullptr)
				return INVALIDTARGET;

			try {
				Locker clocker(agent, creature);

				ValidatedPosition* validPosition = ghost->getLastValidatedPosition();

				if (validPosition == nullptr)
					return GENERALERROR;

				Vector3 playerPosition = validPosition->getPosition();
				uint64 playerParentID = validPosition->getParent();

				Vector3 agentPosition = agent->getPosition();
				uint64 agentParentID = agent->getParentID();

				// Trace administrator attempts here to distinguish tree collision from dialogue failures.
				auto zone = creature->getZone();
				bool trace = ghost->isPrivileged() && zone != nullptr && zone->getZoneName() == "kashyyyk_main";
				auto traceConversation = [&](const char* result) {
					if (!trace)
						return;

					creature->info(true) << "Kashyyyk converse -- " << result
						<< " npc=" << agent->getDisplayedName() << " id=" << agent->getObjectID()
						<< " template=" << agent->getConvoTemplateCRC()
						<< " player=" << creature->getPosition() << " validated=" << playerPosition
						<< " npcPosition=" << agentPosition
						<< " playerParent=" << creature->getParentID() << " validatedParent=" << playerParentID
						<< " npcParent=" << agentParentID;
				};

				// No conversing from different cells
				if (playerParentID != agentParentID) {
					traceConversation("rejected: different parents");
					return TOOFAR;
				}

				// If the conversing NPC is outdoors, we will acount for distance based on x, y only. LoS also checked below
				if (agentParentID == 0) {
					// Calculate the distance squared without use of the z coordinate. We also check LoS below
					float distanceSq = playerPosition.squaredDistanceTo2d(agentPosition);

					if (distanceSq > 25) {
						traceConversation("rejected: outdoor range");
						return TOOFAR;
					}
				} else if (playerPosition.squaredDistanceTo(agentPosition) > 25) {
					traceConversation("rejected: indoor range");
					return TOOFAR;
				}

				// No conversing without LoS
				if (!CollisionManager::checkLineOfSight(agent, creature, trace)) {
					traceConversation("rejected: line of sight");
					return GENERALERROR;
				}

				ghost->setConversatingObject(agent);

				if (agent->sendConversationStartTo(creature)) {
					traceConversation("start sent; invoking conversation handler");
					agent->notifyObservers(ObserverEventType::STARTCONVERSATION, creature);
				} else {
					traceConversation("rejected: conversation start");
				}
			} catch (Exception& e) {
				e.printStackTrace();
				creature->error("unreported ObjectControllerMessage::parseNpcStartConversation(creature* creature, Message* pack) exception");
			}
		} else if (object->isShipAiAgent()) {
			try {
				auto shipAgent = object->asShipAiAgent();

				if (shipAgent == nullptr) {
					return INVALIDTARGET;
				}

				Locker lock(shipAgent, creature);

				ghost->setConversatingObject(shipAgent);

				if (shipAgent->sendConversationStartTo(creature)) {
					shipAgent->notifyObservers(ObserverEventType::STARTCONVERSATION, creature);
				}
			} catch (Exception& e) {
				e.printStackTrace();
			}
		}

		return SUCCESS;
	}
};

#endif // NPCCONVERSATIONSTARTCOMMAND_H_
