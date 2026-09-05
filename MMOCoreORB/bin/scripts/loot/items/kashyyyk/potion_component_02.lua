-- Transcribes datatables/loot/loot_items/kashyyyk/sayormi, sayormi_cyrans, sayormi_monk, sayormi_queen, sayormi_warrior, sayormi_witch.tab (SOE strItemType).
-- Object template is in-tree. ruling 2026-09-04: ensure kashyyyk is done in full.
potion_component_02 = {
	minimumLevel = 0,
	maximumLevel = -1,
	customObjectName = "",
	directObjectTemplate = "object/tangible/loot/creature_loot/kashyyyk_loot/potion_component_02.iff",
	craftingValues = {},
	customizationStringNames = {},
	customizationValues = {}
}

addLootItemTemplate("potion_component_02", potion_component_02)
