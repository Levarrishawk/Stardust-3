-- Transcribes datatables/loot/loot_types/kashyyyk/forest_kerritamba.tab
-- strItems lists: kashyyyk/forest_kerritamba
-- OURS: equal weights (SOE gives no per-item weights in these tables). Sum 10000000.
-- ruling 2026-09-04: ensure kashyyyk is done in full.
forest_kerritamba = {
	description = "",
	minimumLevel = 0,
	maximumLevel = -1,
	lootItems = {
		{itemTemplate = "ep3_loot_corellian", weight = 1111112},
		{itemTemplate = "ep3_loot_dragoneye", weight = 1111111},
		{itemTemplate = "ep3_loot_liquidsilver", weight = 1111111},
		{itemTemplate = "kerritamba_artifact", weight = 1111111},
		{itemTemplate = "kerritamba_fruit", weight = 1111111},
		{itemTemplate = "kerritamba_jaw", weight = 1111111},
		{itemTemplate = "kerritamba_medallion", weight = 1111111},
		{itemTemplate = "kerritamba_skull", weight = 1111111},
		{itemTemplate = "kerritamba_spirits", weight = 1111111},
	}
}

addLootGroupTemplate("forest_kerritamba", forest_kerritamba)
