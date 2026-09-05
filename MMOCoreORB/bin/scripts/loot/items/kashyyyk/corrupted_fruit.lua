-- Transcribes datatables/loot/loot_items/kashyyyk/sayormi, sayormi_cyrans, sayormi_monk, sayormi_queen, sayormi_warrior, sayormi_witch.tab (SOE strItemType).
-- Object template is in-tree. ruling 2026-09-04: ensure kashyyyk is done in full.
corrupted_fruit = {
	minimumLevel = 0,
	maximumLevel = -1,
	customObjectName = "",
	directObjectTemplate = "object/tangible/loot/creature_loot/kashyyyk_loot/corrupted_fruit.iff",
	craftingValues = {},
	customizationStringNames = {},
	customizationValues = {}
}

addLootItemTemplate("corrupted_fruit", corrupted_fruit)
