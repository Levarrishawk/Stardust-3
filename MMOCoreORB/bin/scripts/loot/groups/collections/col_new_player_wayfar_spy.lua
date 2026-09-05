-- SOURCED -- collection_loot.tab column col_new_player_wayfar_spy; cell-count weights (loot.java:1572-1575 rand among cells, duplicates included).
col_new_player_wayfar_spy = {
	description = "",
	minimumLevel = 0,
	maximumLevel = 0,
	lootItems = {
		{itemTemplate = "item_col_wayfar_spy_camera_01_01", weight = 2500000},
		{itemTemplate = "item_col_wayfar_spy_disguise_01_01", weight = 2500000},
		{itemTemplate = "item_col_wayfar_spy_case_01_01", weight = 2500000},
		{itemTemplate = "item_col_wayfar_spy_detonator_01_01", weight = 2500000}
	}
}

addLootGroupTemplate("col_new_player_wayfar_spy", col_new_player_wayfar_spy)
