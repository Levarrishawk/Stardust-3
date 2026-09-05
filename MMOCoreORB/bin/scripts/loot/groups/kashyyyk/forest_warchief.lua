-- Transcribes datatables/loot/loot_types/kashyyyk/forest_warchief.tab
-- strItems lists: kashyyyk/forest_warchief
-- OURS: equal weights (SOE gives no per-item weights in these tables). Sum 10000000.
-- ruling 2026-09-04: ensure kashyyyk is done in full.
forest_warchief = {
	description = "",
	minimumLevel = 0,
	maximumLevel = -1,
	lootItems = {
		{itemTemplate = "kerritamba_artifact", weight = 1666667},
		{itemTemplate = "kerritamba_fruit", weight = 1666667},
		{itemTemplate = "kerritamba_jaw", weight = 1666667},
		{itemTemplate = "kerritamba_medallion", weight = 1666667},
		{itemTemplate = "kerritamba_skull", weight = 1666666},
		{itemTemplate = "kerritamba_spirits", weight = 1666666},
	}
}

addLootGroupTemplate("forest_warchief", forest_warchief)
