-- Transcribes datatables/loot/loot_items/kashyyyk/forest_kerritamba, forest_warchief.tab (SOE strItemType).
-- Object template is in-tree. ruling 2026-09-04: ensure kashyyyk is done in full.
kerritamba_skull = {
	minimumLevel = 0,
	maximumLevel = -1,
	customObjectName = "",
	directObjectTemplate = "object/tangible/loot/creature_loot/kashyyyk_loot/kerritamba_skull.iff",
	craftingValues = {},
	customizationStringNames = {},
	customizationValues = {}
}

addLootItemTemplate("kerritamba_skull", kerritamba_skull)
