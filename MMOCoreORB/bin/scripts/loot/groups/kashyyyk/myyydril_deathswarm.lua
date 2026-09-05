-- Transcribes datatables/loot/loot_types/kashyyyk/myyydril_deathswarm.tab
-- strItems lists: kashyyyk/myyydril_deathswarm
-- OURS: equal weights (SOE gives no per-item weights in these tables). Sum 10000000.
-- ruling 2026-09-04: ensure kashyyyk is done in full.
myyydril_deathswarm = {
	description = "",
	minimumLevel = 0,
	maximumLevel = -1,
	lootItems = {
		{itemTemplate = "ep3_loot_pestilence", weight = 588236},
		{itemTemplate = "adventurers_remains_01", weight = 588236},
		{itemTemplate = "adventurers_remains_02", weight = 588236},
		{itemTemplate = "adventurers_remains_03", weight = 588236},
		{itemTemplate = "adventurers_remains_04", weight = 588236},
		{itemTemplate = "adventurers_remains_05", weight = 588235},
		{itemTemplate = "adventurers_remains_06", weight = 588235},
		{itemTemplate = "uwari_blood", weight = 588235},
		{itemTemplate = "uwari_enzymes", weight = 588235},
		{itemTemplate = "uwari_fluid", weight = 588235},
		{itemTemplate = "uwari_larvae", weight = 588235},
		{itemTemplate = "uwari_leg", weight = 588235},
		{itemTemplate = "uwari_parasites", weight = 588235},
		{itemTemplate = "uwari_pincer", weight = 588235},
		{itemTemplate = "uwari_poison", weight = 588235},
		{itemTemplate = "uwari_poison_sac", weight = 588235},
		{itemTemplate = "uwari_rotting_meat", weight = 588235},
	}
}

addLootGroupTemplate("myyydril_deathswarm", myyydril_deathswarm)
