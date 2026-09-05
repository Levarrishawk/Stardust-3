-- Transcribes datatables/loot/loot_types/kashyyyk/etyyy_brightclaw.tab
-- strItems lists: kashyyyk/etyyy_brightclaw, kashyyyk/mouf
-- OURS: equal weights (SOE gives no per-item weights in these tables). Sum 10000000.
-- ruling 2026-09-04: ensure kashyyyk is done in full.
etyyy_brightclaw = {
	description = "",
	minimumLevel = 0,
	maximumLevel = -1,
	lootItems = {
		{itemTemplate = "ep3_hunt_loot_brightclaw_jaw", weight = 3333334},
		{itemTemplate = "mouf_paw_01", weight = 3333333},
		{itemTemplate = "mouf_pelt_01", weight = 3333333},
	}
}

addLootGroupTemplate("etyyy_brightclaw", etyyy_brightclaw)
