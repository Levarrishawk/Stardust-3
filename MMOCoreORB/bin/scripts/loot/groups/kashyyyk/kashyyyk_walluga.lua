-- Transcribes datatables/loot/loot_types/kashyyyk/kashyyyk_walluga.tab
-- strItems lists: kashyyyk/walluga
-- OURS: equal weights (SOE gives no per-item weights in these tables). Sum 10000000.
-- ruling 2026-09-04: ensure kashyyyk is done in full.
kashyyyk_walluga = {
	description = "",
	minimumLevel = 0,
	maximumLevel = -1,
	lootItems = {
		{itemTemplate = "walluga_ear_01", weight = 5000000},
		{itemTemplate = "walluga_foot_01", weight = 5000000},
	}
}

addLootGroupTemplate("kashyyyk_walluga", kashyyyk_walluga)
