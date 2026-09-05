-- Transcribes datatables/loot/loot_types/kashyyyk/etyyy_stoneleg.tab
-- strItems lists: kashyyyk/etyyy_stoneleg, kashyyyk/walluga
-- OURS: equal weights (SOE gives no per-item weights in these tables). Sum 10000000.
-- ruling 2026-09-04: ensure kashyyyk is done in full.
etyyy_stoneleg = {
	description = "",
	minimumLevel = 0,
	maximumLevel = -1,
	lootItems = {
		{itemTemplate = "ep3_hunt_loot_stoneleg_heart", weight = 3333334},
		{itemTemplate = "walluga_ear_01", weight = 3333333},
		{itemTemplate = "walluga_foot_01", weight = 3333333},
	}
}

addLootGroupTemplate("etyyy_stoneleg", etyyy_stoneleg)
