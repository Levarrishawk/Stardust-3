-- Transcribes datatables/loot/loot_types/kashyyyk/kashyyyk_uller.tab
-- strItems lists: kashyyyk/uller
-- OURS: equal weights (SOE gives no per-item weights in these tables). Sum 10000000.
-- ruling 2026-09-04: ensure kashyyyk is done in full.
kashyyyk_uller = {
	description = "",
	minimumLevel = 0,
	maximumLevel = -1,
	lootItems = {
		{itemTemplate = "uller_horn_01", weight = 5000000},
		{itemTemplate = "uller_teeth_01", weight = 5000000},
	}
}

addLootGroupTemplate("kashyyyk_uller", kashyyyk_uller)
