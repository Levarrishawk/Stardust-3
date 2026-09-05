-- Transcribes datatables/loot/loot_types/kashyyyk/kashyyyk_bolotaur.tab
-- strItems lists: kashyyyk/bolotaur
-- OURS: equal weights (SOE gives no per-item weights in these tables). Sum 10000000.
-- ruling 2026-09-04: ensure kashyyyk is done in full.
kashyyyk_bolotaur = {
	description = "",
	minimumLevel = 0,
	maximumLevel = -1,
	lootItems = {
		{itemTemplate = "bolotaur_fang_01", weight = 5000000},
		{itemTemplate = "bolotaur_scale_01", weight = 5000000},
	}
}

addLootGroupTemplate("kashyyyk_bolotaur", kashyyyk_bolotaur)
