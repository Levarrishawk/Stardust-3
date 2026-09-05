-- Transcribes datatables/loot/loot_types/kashyyyk/kashyyyk_webweaver.tab
-- strItems lists: kashyyyk/webweaver
-- OURS: equal weights (SOE gives no per-item weights in these tables). Sum 10000000.
-- ruling 2026-09-04: ensure kashyyyk is done in full.
kashyyyk_webweaver = {
	description = "",
	minimumLevel = 0,
	maximumLevel = -1,
	lootItems = {
		{itemTemplate = "webweaver_leg_01", weight = 5000000},
		{itemTemplate = "webweaver_poison_sac_01", weight = 5000000},
	}
}

addLootGroupTemplate("kashyyyk_webweaver", kashyyyk_webweaver)
