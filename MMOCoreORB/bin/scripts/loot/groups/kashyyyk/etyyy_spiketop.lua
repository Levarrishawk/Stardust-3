-- Transcribes datatables/loot/loot_types/kashyyyk/etyyy_spiketop.tab
-- strItems lists: kashyyyk/etyyy_spiketop, kashyyyk/uller
-- OURS: equal weights (SOE gives no per-item weights in these tables). Sum 10000000.
-- ruling 2026-09-04: ensure kashyyyk is done in full.
etyyy_spiketop = {
	description = "",
	minimumLevel = 0,
	maximumLevel = -1,
	lootItems = {
		{itemTemplate = "ep3_hunt_loot_spiketop_horn", weight = 3333334},
		{itemTemplate = "uller_horn_01", weight = 3333333},
		{itemTemplate = "uller_teeth_01", weight = 3333333},
	}
}

addLootGroupTemplate("etyyy_spiketop", etyyy_spiketop)
