-- Transcribes datatables/loot/loot_types/kashyyyk/forest_mouf.tab
-- strItems lists: kashyyyk/forest_mouf
-- OURS: equal weights (SOE gives no per-item weights in these tables). Sum 10000000.
-- ruling 2026-09-04: ensure kashyyyk is done in full.
forest_mouf = {
	description = "",
	minimumLevel = 0,
	maximumLevel = -1,
	lootItems = {
		{itemTemplate = "ep3_loot_blackhand", weight = 2500000},
		{itemTemplate = "ep3_loot_hydra", weight = 2500000},
		{itemTemplate = "mouf_paw_01", weight = 2500000},
		{itemTemplate = "mouf_pelt_01", weight = 2500000},
	}
}

addLootGroupTemplate("forest_mouf", forest_mouf)
