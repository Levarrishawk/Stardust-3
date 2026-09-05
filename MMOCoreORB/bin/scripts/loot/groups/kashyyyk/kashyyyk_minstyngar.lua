-- Transcribes datatables/loot/loot_types/kashyyyk/kashyyyk_minstyngar.tab
-- strItems lists: kashyyyk/minstyngar
-- OURS: equal weights (SOE gives no per-item weights in these tables). Sum 10000000.
-- ruling 2026-09-04: ensure kashyyyk is done in full.
kashyyyk_minstyngar = {
	description = "",
	minimumLevel = 0,
	maximumLevel = -1,
	lootItems = {
		{itemTemplate = "minstyngar_fang_01", weight = 5000000},
		{itemTemplate = "minstyngar_horn_01", weight = 5000000},
	}
}

addLootGroupTemplate("kashyyyk_minstyngar", kashyyyk_minstyngar)
