-- Transcribes datatables/loot/loot_types/kashyyyk/kashyyyk_mouf.tab
-- strItems lists: kashyyyk/mouf
-- OURS: equal weights (SOE gives no per-item weights in these tables). Sum 10000000.
-- ruling 2026-09-04: ensure kashyyyk is done in full.
kashyyyk_mouf = {
	description = "",
	minimumLevel = 0,
	maximumLevel = -1,
	lootItems = {
		{itemTemplate = "mouf_paw_01", weight = 5000000},
		{itemTemplate = "mouf_pelt_01", weight = 5000000},
	}
}

addLootGroupTemplate("kashyyyk_mouf", kashyyyk_mouf)
