-- Transcribes datatables/loot/loot_types/kashyyyk/kashyyyk_fern_bicker.tab
-- strItems lists: kashyyyk/fern_bicker
-- OURS: equal weights (SOE gives no per-item weights in these tables). Sum 10000000.
-- ruling 2026-09-04: ensure kashyyyk is done in full.
kashyyyk_fern_bicker = {
	description = "",
	minimumLevel = 0,
	maximumLevel = -1,
	lootItems = {
		{itemTemplate = "fern_bicker_brain_01", weight = 10000000},
	}
}

addLootGroupTemplate("kashyyyk_fern_bicker", kashyyyk_fern_bicker)
