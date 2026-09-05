-- Transcribes datatables/loot/loot_items/kashyyyk/forest_exemplar, forest_outcast.tab (SOE strItemType).
-- Object template is in-tree. ruling 2026-09-04: ensure kashyyyk is done in full.
outcast_rations = {
	minimumLevel = 0,
	maximumLevel = -1,
	customObjectName = "",
	directObjectTemplate = "object/tangible/loot/creature_loot/kashyyyk_loot/outcast_rations.iff",
	craftingValues = {},
	customizationStringNames = {},
	customizationValues = {}
}

addLootItemTemplate("outcast_rations", outcast_rations)
