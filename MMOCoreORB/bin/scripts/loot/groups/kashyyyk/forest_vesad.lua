-- Transcribes datatables/loot/loot_types/kashyyyk/forest_vesad.tab
-- strItems lists: kashyyyk/forest_vesad
-- OURS: equal weights (SOE gives no per-item weights in these tables). Sum 10000000.
-- ruling 2026-09-04: ensure kashyyyk is done in full.
forest_vesad = {
	description = "",
	minimumLevel = 0,
	maximumLevel = -1,
	lootItems = {
		{itemTemplate = "ep3_loot_void", weight = 3333334},
		{itemTemplate = "webweaver_leg_01", weight = 3333333},
		{itemTemplate = "webweaver_poison_sac_01", weight = 3333333},
	}
}

addLootGroupTemplate("forest_vesad", forest_vesad)
