-- SOURCED -- collection_loot.tab column col_dejarik_table; cell-count weights (loot.java:1572-1575 rand among cells, duplicates included).
col_dejarik_table = {
	description = "",
	minimumLevel = 0,
	maximumLevel = 0,
	lootItems = {
		{itemTemplate = "col_dejarik_battery_02_01", weight = 1216217},
		{itemTemplate = "col_dejarik_board_02_01", weight = 1216217},
		{itemTemplate = "col_dejarik_holoprojector_02_01", weight = 405405},
		{itemTemplate = "col_dejarik_keypad_02_01", weight = 2027027},
		{itemTemplate = "col_dejarik_keypad_02_02", weight = 2027027},
		{itemTemplate = "col_dejarik_table_base_02_01", weight = 1216216},
		{itemTemplate = "col_dejarik_table_stand_02_01", weight = 1621621},
		{itemTemplate = "col_fried_icecream_fryer_broken_activation", weight = 270270}
	}
}

addLootGroupTemplate("col_dejarik_table", col_dejarik_table)
