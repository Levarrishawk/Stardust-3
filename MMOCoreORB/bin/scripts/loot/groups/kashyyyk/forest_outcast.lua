-- Transcribes datatables/loot/loot_types/kashyyyk/forest_outcast.tab
-- strItems lists: kashyyyk/forest_outcast
-- OURS: equal weights (SOE gives no per-item weights in these tables). Sum 10000000.
-- ruling 2026-09-04: ensure kashyyyk is done in full.
forest_outcast = {
	description = "",
	minimumLevel = 0,
	maximumLevel = -1,
	lootItems = {
		{itemTemplate = "ep3_loot_rhiss", weight = 769231},
		{itemTemplate = "ep3_loot_rilctur", weight = 769231},
		{itemTemplate = "ep3_loot_sharpshooter", weight = 769231},
		{itemTemplate = "outcast_rations", weight = 769231},
		{itemTemplate = "outcast_spice", weight = 769231},
		{itemTemplate = "outcast_tool_01", weight = 769231},
		{itemTemplate = "outcast_tool_02", weight = 769231},
		{itemTemplate = "outcast_tool_03", weight = 769231},
		{itemTemplate = "outcast_tool_04", weight = 769231},
		{itemTemplate = "outcast_tool_05", weight = 769231},
		{itemTemplate = "outcast_tool_06", weight = 769230},
		{itemTemplate = "outcast_tool_07", weight = 769230},
		{itemTemplate = "outcast_vitamins", weight = 769230},
	}
}

addLootGroupTemplate("forest_outcast", forest_outcast)
