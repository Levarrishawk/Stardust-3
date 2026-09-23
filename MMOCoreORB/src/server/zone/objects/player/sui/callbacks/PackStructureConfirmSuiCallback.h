#ifndef PACKSTRUCTURECONFIRMSUICALLBACK_H_
#define PACKSTRUCTURECONFIRMSUICALLBACK_H_

#include "server/zone/objects/player/sui/SuiCallback.h"
#include "server/zone/objects/creature/CreatureObject.h"
#include "server/zone/objects/tangible/terminal/Terminal.h"
#include "server/zone/objects/structure/StructureObject.h"
#include "server/zone/managers/structure/StructureManager.h"

class PackStructureConfirmSuiCallback : public SuiCallback {
public:
	PackStructureConfirmSuiCallback(ZoneServer* serv) : SuiCallback(serv) {
	}

	void run(CreatureObject* creature, SuiBox* sui, uint32 eventIndex, Vector<UnicodeString>* args) {
		if (creature == nullptr || !sui->isMessageBox() || eventIndex != 0)
			return;

		ManagedReference<SceneObject*> object = sui->getUsingObject().get();
		if (object == nullptr || !object->isTerminal() || !creature->isInRange(object, 15.0f))
			return;

		Terminal* terminal = cast<Terminal*>(object.get());
		ManagedReference<StructureObject*> structure = cast<StructureObject*>(terminal->getControlledObject());
		if (structure == nullptr || !structure->isBuildingObject() || structure->getZone() == nullptr || structure->getOwnerObjectID() != creature->getObjectID() || !structure->isOnAdminList(creature))
			return;

		Locker structureLocker(structure, creature);
		StructureManager::instance()->packStructure(creature, structure);
	}
};

#endif /* PACKSTRUCTURECONFIRMSUICALLBACK_H_ */
