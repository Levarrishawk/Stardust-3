#ifndef PACKEDSTRUCTUREMENUCOMPONENT_H_
#define PACKEDSTRUCTUREMENUCOMPONENT_H_

#include "ObjectMenuComponent.h"
#include "server/zone/objects/scene/SceneObject.h"
#include "server/zone/objects/creature/CreatureObject.h"
#include "server/zone/objects/structure/StructureObject.h"
#include "server/zone/managers/structure/StructureManager.h"
#include "server/zone/packets/object/ObjectMenuResponse.h"
#include "server/zone/packets/player/EnterStructurePlacementModeMessage.h"
#include "templates/manager/TemplateManager.h"

class PackedStructureMenuComponent : public ObjectMenuComponent {
public:
	void fillObjectMenuResponse(SceneObject* object, ObjectMenuResponse* menu, CreatureObject* player) const override {
		if (StructureManager::instance()->getPackedStructure(player, object) != nullptr) {
			menu->addRadialMenuItem(20, 3, "Unpack");
			menu->addRadialMenuItem(21, 3, "Pay Maintenance");
			menu->addRadialMenuItem(22, 3, "Status");
		}
	}

	int handleObjectMenuSelect(SceneObject* object, CreatureObject* player, byte selectedID) const override {
		if (player == nullptr)
			return 1;

		Reference<StructureObject*> structure = StructureManager::instance()->getPackedStructure(player, object);
		if (structure == nullptr)
			return 1;
		Locker structureLocker(structure, player);
		if (selectedID == 21) {
			StructureManager::instance()->promptPayMaintenance(structure, player, object);
			return 0;
		}
		if (selectedID == 22) {
			StructureManager::instance()->reportStructureStatus(player, structure, object);
			return 0;
		}
		if (selectedID != 20 || player->getParent() != nullptr || player->getZone() == nullptr)
			return 1;

		String templatePath = TemplateManager::instance()->getTemplateFile(structure->getObjectTemplate()->getClientObjectCRC());
		player->sendMessage(new EnterStructurePlacementModeMessage(object->getObjectID(), templatePath));
		return 0;
	}
};

#endif
