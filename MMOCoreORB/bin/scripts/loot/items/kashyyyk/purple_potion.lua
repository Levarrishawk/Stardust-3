-- Transcribes datatables/loot/loot_items/kashyyyk/sayormi, sayormi_cyrans, sayormi_monk, sayormi_queen, sayormi_warrior, sayormi_witch.tab (SOE strItemType).
-- Object template is in-tree. ruling 2026-09-04: ensure kashyyyk is done in full.
purple_potion = {
	minimumLevel = 0,
	maximumLevel = -1,
	customObjectName = "",
	directObjectTemplate = "object/tangible/loot/creature_loot/kashyyyk_loot/purple_potion.iff",
	craftingValues = {},
	customizationStringNames = {},
	customizationValues = {}
}

addLootItemTemplate("purple_potion", purple_potion)
