-- Transcribes datatables/loot/loot_types/kashyyyk/kashyyyk_bantha.tab
-- strItems lists: kashyyyk/kashyyyk_bantha
-- OURS: equal weights (SOE gives no per-item weights in these tables). Sum 10000000.
-- ruling 2026-09-04: ensure kashyyyk is done in full.
kashyyyk_bantha = {
	description = "",
	minimumLevel = 0,
	maximumLevel = -1,
	lootItems = {
		{itemTemplate = "kashyyyk_bantha_horn_01", weight = 5000000},
		{itemTemplate = "kashyyyk_bantha_pelt_01", weight = 5000000},
	}
}

addLootGroupTemplate("kashyyyk_bantha", kashyyyk_bantha)
