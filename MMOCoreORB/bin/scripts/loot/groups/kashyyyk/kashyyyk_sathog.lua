-- Transcribes datatables/loot/loot_types/kashyyyk/kashyyyk_sathog.tab
-- strItems lists: kashyyyk/sathog
-- OURS: equal weights (SOE gives no per-item weights in these tables). Sum 10000000.
-- ruling 2026-09-04: ensure kashyyyk is done in full.
kashyyyk_sathog = {
	description = "",
	minimumLevel = 0,
	maximumLevel = -1,
	lootItems = {
		{itemTemplate = "sathog_snout_01", weight = 10000000},
	}
}

addLootGroupTemplate("kashyyyk_sathog", kashyyyk_sathog)
