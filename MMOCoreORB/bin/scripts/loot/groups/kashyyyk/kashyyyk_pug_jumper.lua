-- Transcribes datatables/loot/loot_types/kashyyyk/kashyyyk_pug_jumper.tab
-- strItems lists: kashyyyk/pug_jumper
-- OURS: equal weights (SOE gives no per-item weights in these tables). Sum 10000000.
-- ruling 2026-09-04: ensure kashyyyk is done in full.
kashyyyk_pug_jumper = {
	description = "",
	minimumLevel = 0,
	maximumLevel = -1,
	lootItems = {
		{itemTemplate = "pug_jumper_tongue_01", weight = 10000000},
	}
}

addLootGroupTemplate("kashyyyk_pug_jumper", kashyyyk_pug_jumper)
