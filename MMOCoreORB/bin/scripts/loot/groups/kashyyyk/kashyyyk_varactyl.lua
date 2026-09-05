-- Transcribes datatables/loot/loot_types/kashyyyk/kashyyyk_varactyl.tab
-- strItems lists: kashyyyk/varactyl
-- OURS: equal weights (SOE gives no per-item weights in these tables). Sum 10000000.
-- ruling 2026-09-04: ensure kashyyyk is done in full.
kashyyyk_varactyl = {
	description = "",
	minimumLevel = 0,
	maximumLevel = -1,
	lootItems = {
		{itemTemplate = "varactyl_claw_01", weight = 5000000},
		{itemTemplate = "varactyl_feather_01", weight = 5000000},
	}
}

addLootGroupTemplate("kashyyyk_varactyl", kashyyyk_varactyl)
