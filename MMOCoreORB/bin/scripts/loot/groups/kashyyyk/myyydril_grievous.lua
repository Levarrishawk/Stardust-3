-- Transcribes datatables/loot/loot_types/kashyyyk/myyydril_grievous.tab
-- strItems lists: kashyyyk/myyydril_grievous
-- OURS: equal weights (SOE gives no per-item weights in these tables). Sum 10000000.
-- ruling 2026-09-04: ensure kashyyyk is done in full.
myyydril_grievous = {
	description = "",
	minimumLevel = 0,
	maximumLevel = -1,
	lootItems = {
		{itemTemplate = "ep3_loot_necrosis", weight = 833334},
		{itemTemplate = "ep3_loot_ripper", weight = 833334},
		{itemTemplate = "ep3_loot_executer", weight = 833334},
		{itemTemplate = "ep3_loot_poisonspike", weight = 833334},
		{itemTemplate = "ep3_loot_darksting", weight = 833333},
		{itemTemplate = "ep3_loot_deathrain", weight = 833333},
		{itemTemplate = "ep3_loot_grievance", weight = 833333},
		{itemTemplate = "ep3_loot_nullifier", weight = 833333},
		{itemTemplate = "rifle_proton", weight = 833333},
		{itemTemplate = "ep3_loot_retaliation", weight = 833333},
		{itemTemplate = "ep3_loot_calibrated", weight = 833333},
		{itemTemplate = "ep3_loot_dawnsorrow", weight = 833333},
	}
}

addLootGroupTemplate("myyydril_grievous", myyydril_grievous)
