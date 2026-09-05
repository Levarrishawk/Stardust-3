-- Transcribes datatables/loot/loot_types/kashyyyk/uwari.tab
-- strItems lists: kashyyyk/uwari
-- OURS: equal weights (SOE gives no per-item weights in these tables). Sum 10000000.
-- ruling 2026-09-04: ensure kashyyyk is done in full.
uwari = {
	description = "",
	minimumLevel = 0,
	maximumLevel = -1,
	lootItems = {
		{itemTemplate = "adventurers_remains_01", weight = 625000},
		{itemTemplate = "adventurers_remains_02", weight = 625000},
		{itemTemplate = "adventurers_remains_03", weight = 625000},
		{itemTemplate = "adventurers_remains_04", weight = 625000},
		{itemTemplate = "adventurers_remains_05", weight = 625000},
		{itemTemplate = "adventurers_remains_06", weight = 625000},
		{itemTemplate = "uwari_blood", weight = 625000},
		{itemTemplate = "uwari_enzymes", weight = 625000},
		{itemTemplate = "uwari_fluid", weight = 625000},
		{itemTemplate = "uwari_larvae", weight = 625000},
		{itemTemplate = "uwari_leg", weight = 625000},
		{itemTemplate = "uwari_parasites", weight = 625000},
		{itemTemplate = "uwari_pincer", weight = 625000},
		{itemTemplate = "uwari_poison", weight = 625000},
		{itemTemplate = "uwari_poison_sac", weight = 625000},
		{itemTemplate = "uwari_rotting_meat", weight = 625000},
	}
}

addLootGroupTemplate("uwari", uwari)
