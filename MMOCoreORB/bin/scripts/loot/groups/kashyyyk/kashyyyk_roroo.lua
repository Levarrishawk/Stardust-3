-- Transcribes datatables/loot/loot_types/kashyyyk/kashyyyk_roroo.tab
-- strItems lists: kashyyyk/roroo
-- OURS: equal weights (SOE gives no per-item weights in these tables). Sum 10000000.
-- ruling 2026-09-04: ensure kashyyyk is done in full.
kashyyyk_roroo = {
	description = "",
	minimumLevel = 0,
	maximumLevel = -1,
	lootItems = {
		{itemTemplate = "roroo_paw_01", weight = 10000000},
	}
}

addLootGroupTemplate("kashyyyk_roroo", kashyyyk_roroo)
