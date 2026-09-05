-- Transcribes datatables/loot/loot_types/kashyyyk/myyydril_eviserator.tab
-- strItems lists: kashyyyk/myyydril_eviserator
-- OURS: equal weights (SOE gives no per-item weights in these tables). Sum 10000000.
-- ruling 2026-09-04: ensure kashyyyk is done in full.
myyydril_eviserator = {
	description = "",
	minimumLevel = 0,
	maximumLevel = -1,
	lootItems = {
		{itemTemplate = "ep3_loot_retribution", weight = 5000000},
		{itemTemplate = "ep3_loot_silencer", weight = 5000000},
	}
}

addLootGroupTemplate("myyydril_eviserator", myyydril_eviserator)
