-- Transcribes datatables/loot/loot_types/kashyyyk/myyydril_nefarious.tab
-- strItems lists: kashyyyk/myyydril_nefarious
-- OURS: equal weights (SOE gives no per-item weights in these tables). Sum 10000000.
-- ruling 2026-09-04: ensure kashyyyk is done in full.
myyydril_nefarious = {
	description = "",
	minimumLevel = 0,
	maximumLevel = -1,
	lootItems = {
		{itemTemplate = "ep3_loot_eventide", weight = 5000000},
		{itemTemplate = "rifle_naktra_crystal", weight = 5000000},
	}
}

addLootGroupTemplate("myyydril_nefarious", myyydril_nefarious)
