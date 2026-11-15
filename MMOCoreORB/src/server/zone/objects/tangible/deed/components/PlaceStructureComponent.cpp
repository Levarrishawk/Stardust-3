/*
 * PlaceStructureComponent.cpp
 *
 *  Created on: Feb 5, 2012
 *      Author: xyborn
 */

#include "PlaceStructureComponent.h"
#include "server/zone/objects/creature/CreatureObject.h"
#include "server/zone/managers/structure/StructureManager.h"
#include "server/zone/objects/structure/StructureObject.h"
#include "server/zone/objects/installation/InstallationObject.h"
#include "server/zone/objects/tangible/deed/structure/StructureDeed.h"
#include "server/zone/Zone.h"
#include "templates/appearance/PaletteTemplate.h"
#include "templates/customization/AssetCustomizationManagerTemplate.h"
#include "templates/customization/CustomizationIdManager.h"
#include "templates/manager/TemplateManager.h"
#include "templates/params/PaletteColorCustomizationVariable.h"

static void applyDeedPaint(StructureDeed* deed, StructureObject* structure) {
	const auto* selectedColors = deed->getCustomizationVariables();
	const auto* deedTemplate = deed->getObjectTemplate();
	const auto* structureTemplate = structure->getObjectTemplate();

	if (selectedColors == nullptr || selectedColors->isEmpty() || deedTemplate == nullptr || structureTemplate == nullptr)
		return;

	VectorMap<String, Reference<CustomizationVariable*> > deedVariables;
	VectorMap<String, Reference<CustomizationVariable*> > structureVariables;
	auto* customizationManager = AssetCustomizationManagerTemplate::instance();
	customizationManager->getCustomizationVariables(deedTemplate->getAppearanceFilename().hashCode(), deedVariables, true);
	customizationManager->getCustomizationVariables(structureTemplate->getAppearanceFilename().hashCode(), structureVariables, true);

	if (deedVariables.isEmpty() || structureVariables.isEmpty())
		return;

	const String housePalette = "palette/tatt_house.pal";
	UniqueReference<PaletteTemplate*> palette(TemplateManager::instance()->getPaletteTemplate(housePalette));

	if (palette == nullptr)
		return;

	for (int i = 0; i < selectedColors->size(); ++i) {
		const auto& selection = selectedColors->elementAt(i);
		const auto& name = CustomizationIdManager::instance()->getCustomizationVariable(selection.getKey());

		if (!deedVariables.contains(name) || !structureVariables.contains(name))
			continue;

		const auto* deedPalette = dynamic_cast<PaletteColorCustomizationVariable*>(deedVariables.get(name).get());
		const auto* structurePalette = dynamic_cast<PaletteColorCustomizationVariable*>(structureVariables.get(name).get());

		if (deedPalette == nullptr || structurePalette == nullptr ||
				deedPalette->getPaletteFileName() != housePalette || structurePalette->getPaletteFileName() != housePalette)
			continue;

		int16 color = selection.getValue();

		if (color >= 0 && color < palette->getColorCount())
			structure->setCustomizationVariable(selection.getKey(), color);
	}
}

int PlaceStructureComponent::placeStructure(StructureDeed* deed, CreatureObject* creature, float x, float y, int angle) const {
	Zone* zone = creature->getZone();

	if (zone != nullptr)
		StructureManager::instance()->placeStructureFromDeed(creature, deed, x, y, angle);

	return 0;
}

int PlaceStructureComponent::notifyStructurePlaced(StructureDeed* deed, CreatureObject* creature, StructureObject* structureObject) const {
	structureObject->setSurplusMaintenance(deed->getSurplusMaintenance());
	structureObject->setSurplusPower(deed->getSurplusPower());
	applyDeedPaint(deed, structureObject);

	if (structureObject->isInstallationObject()) {
		InstallationObject* installationObject = cast<InstallationObject*>(structureObject);
		installationObject->setExtractionRate(deed->getExtractionRate());
		installationObject->setHopperSizeMax(deed->getHopperSize());
	}

	return 0;
}
