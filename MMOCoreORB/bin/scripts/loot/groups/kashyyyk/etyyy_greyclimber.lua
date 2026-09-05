-- Transcribes datatables/loot/loot_types/kashyyyk/etyyy_greyclimber.tab
-- strItems lists: kashyyyk/etyyy_greyclimber, kashyyyk/kashyyyk_bantha
-- OURS: equal weights (SOE gives no per-item weights in these tables). Sum 10000000.
-- ruling 2026-09-04: ensure kashyyyk is done in full.
etyyy_greyclimber = {
	description = "",
	minimumLevel = 0,
	maximumLevel = -1,
	lootItems = {
		{itemTemplate = "ep3_hunt_loot_greyclimber_eye", weight = 3333334},
		{itemTemplate = "kashyyyk_bantha_horn_01", weight = 3333333},
		{itemTemplate = "kashyyyk_bantha_pelt_01", weight = 3333333},
	}
}

addLootGroupTemplate("etyyy_greyclimber", etyyy_greyclimber)
