-- SOURCED -- collection_loot.tab column col_rancor_parts; cell-count weights (loot.java:1572-1575 rand among cells, duplicates included).
col_rancor_parts = {
	description = "",
	minimumLevel = 0,
	maximumLevel = 0,
	lootItems = {
		{itemTemplate = "col_rancor_bone_02_01", weight = 2222223},
		{itemTemplate = "col_rancor_entrails_02_01", weight = 2222223},
		{itemTemplate = "col_rancor_fang_02_01", weight = 2222222},
		{itemTemplate = "col_rancor_finger_02_01", weight = 2222222},
		{itemTemplate = "col_rancor_eye_02_01", weight = 740740},
		{itemTemplate = "col_fried_icecream_fryer_broken_activation", weight = 370370}
	}
}

addLootGroupTemplate("col_rancor_parts", col_rancor_parts)
