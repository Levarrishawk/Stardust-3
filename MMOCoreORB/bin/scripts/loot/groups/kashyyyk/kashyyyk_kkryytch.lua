-- Transcribes datatables/loot/loot_types/kashyyyk/kashyyyk_kkryytch.tab
-- strItems lists: kashyyyk/kkryytch
-- OURS: equal weights (SOE gives no per-item weights in these tables). Sum 10000000.
-- ruling 2026-09-04: ensure kashyyyk is done in full.
kashyyyk_kkryytch = {
	description = "",
	minimumLevel = 0,
	maximumLevel = -1,
	lootItems = {
		{itemTemplate = "kkryytch_feather_01", weight = 10000000},
	}
}

addLootGroupTemplate("kashyyyk_kkryytch", kashyyyk_kkryytch)
