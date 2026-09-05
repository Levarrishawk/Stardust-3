-- SOURCED -- collection_loot.tab column col_contraband_set_04; cell-count weights (loot.java:1572-1575 rand among cells, duplicates included).
col_contraband_set_04 = {
	description = "",
	minimumLevel = 0,
	maximumLevel = 0,
	lootItems = {
		{itemTemplate = "col_contraband1_item_02_04", weight = 967742},
		{itemTemplate = "col_contraband2_item_02_04", weight = 967742},
		{itemTemplate = "col_contraband3_item_02_04", weight = 2419355},
		{itemTemplate = "col_contraband4_item_02_04", weight = 1935484},
		{itemTemplate = "col_contraband5_item_02_04", weight = 1451613},
		{itemTemplate = "col_contraband1_item_02_05", weight = 967742},
		{itemTemplate = "col_contraband2_item_02_05", weight = 483871},
		{itemTemplate = "col_contraband3_item_02_05", weight = 483871},
		{itemTemplate = "col_fried_icecream_fryer_broken_activation", weight = 322580}
	}
}

addLootGroupTemplate("col_contraband_set_04", col_contraband_set_04)
