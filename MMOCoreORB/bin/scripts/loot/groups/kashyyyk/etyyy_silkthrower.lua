-- Transcribes datatables/loot/loot_types/kashyyyk/etyyy_silkthrower.tab
-- strItems lists: kashyyyk/etyyy_silkthrower, kashyyyk/webweaver
-- OURS: equal weights (SOE gives no per-item weights in these tables). Sum 10000000.
-- ruling 2026-09-04: ensure kashyyyk is done in full.
etyyy_silkthrower = {
	description = "",
	minimumLevel = 0,
	maximumLevel = -1,
	lootItems = {
		{itemTemplate = "ep3_hunt_loot_silkthrower_fang", weight = 3333334},
		{itemTemplate = "webweaver_leg_01", weight = 3333333},
		{itemTemplate = "webweaver_poison_sac_01", weight = 3333333},
	}
}

addLootGroupTemplate("etyyy_silkthrower", etyyy_silkthrower)
