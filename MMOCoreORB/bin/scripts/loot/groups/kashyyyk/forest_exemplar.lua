-- Transcribes datatables/loot/loot_types/kashyyyk/forest_exemplar.tab
-- strItems lists: kashyyyk/forest_exemplar
-- OURS: equal weights (SOE gives no per-item weights in these tables). Sum 10000000.
-- ruling 2026-09-04: ensure kashyyyk is done in full.
forest_exemplar = {
	description = "",
	minimumLevel = 0,
	maximumLevel = -1,
	lootItems = {
		{itemTemplate = "ep3_loot_mark", weight = 833334},
		{itemTemplate = "ep3_loot_corestrike", weight = 833334},
		{itemTemplate = "outcast_rations", weight = 833334},
		{itemTemplate = "outcast_spice", weight = 833334},
		{itemTemplate = "outcast_tool_01", weight = 833333},
		{itemTemplate = "outcast_tool_02", weight = 833333},
		{itemTemplate = "outcast_tool_03", weight = 833333},
		{itemTemplate = "outcast_tool_04", weight = 833333},
		{itemTemplate = "outcast_tool_05", weight = 833333},
		{itemTemplate = "outcast_tool_06", weight = 833333},
		{itemTemplate = "outcast_tool_07", weight = 833333},
		{itemTemplate = "outcast_vitamins", weight = 833333},
	}
}

addLootGroupTemplate("forest_exemplar", forest_exemplar)
