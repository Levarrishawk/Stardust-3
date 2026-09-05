-- Transcribes datatables/loot/loot_types/kashyyyk/kashyyyk_jyykle_vulture.tab
-- strItems lists: kashyyyk/jyykle_vulture
-- OURS: equal weights (SOE gives no per-item weights in these tables). Sum 10000000.
-- ruling 2026-09-04: ensure kashyyyk is done in full.
kashyyyk_jyykle_vulture = {
	description = "",
	minimumLevel = 0,
	maximumLevel = -1,
	lootItems = {
		{itemTemplate = "jyykle_vulture_beak_01", weight = 10000000},
	}
}

addLootGroupTemplate("kashyyyk_jyykle_vulture", kashyyyk_jyykle_vulture)
