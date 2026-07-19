/*
 * ShuttleZoneComponent.cpp
 *
 *  Created on: Aug 19, 2011
 *      Author: crush
 */

#include "ShuttleZoneComponent.h"
#include "server/zone/objects/creature/CreatureObject.h"
#include "server/zone/objects/building/tasks/ScheduleShuttleTask.h"

//#define SHUTTLE_TIMER_DEBUG

void ShuttleZoneComponent::notifyInsertToZone(SceneObject* sceneObject, Zone* zone) const {
	GroundZoneComponent::notifyInsertToZone(sceneObject, zone);

	if (sceneObject == nullptr) {
		error() << "ShuttleZoneComponent::notifyInsertToZone -- inserted object is null";
		return;
	}

	if (!sceneObject->isCreatureObject()) {
		error() << "ShuttleZoneComponent::notifyInsertToZone -- inserted object is not a Creature Object";
		return;
	}

	auto shuttle = sceneObject->asCreatureObject();

	if (shuttle == nullptr)
		return;

	auto zoneServer = zone->getZoneServer();

	if (zoneServer == nullptr)
		return;

	Reference<ScheduleShuttleTask*> task = new ScheduleShuttleTask(shuttle, zone);

	if (task == nullptr)
		return;

	int delay = 500;

	if (zoneServer->isServerLoading()) {
		uint32 startDiff = zone->getZoneServer()->getStartTimestamp()->miliDifference();

		int bootDelay = ConfigManager::instance()->getInt("Core3.ShuttleZoneComponent.BootDelay", 2 * 60 * 1000);

		delay = bootDelay - startDiff;

		// Limit shuttle startup delay to 2 minutes maximum
		if (delay > 120 * 1000)
			delay = 120 * 1000;

		if (delay <= 0)
			delay = 500;

	#ifdef SHUTTLE_TIMER_DEBUG
		info(true) << "ScheduleShuttleTask for " << zone->getZoneName() << " scheduled due to server loading: militime since server start - " << startDiff << " shuttle delay time - " << delay << " milliseconds.";
	#endif
	}

	task->schedule(delay);
}

void ShuttleZoneComponent::notifyRemoveFromZone(SceneObject* sceneObject) const {
	GroundZoneComponent::notifyRemoveFromZone(sceneObject);
}
