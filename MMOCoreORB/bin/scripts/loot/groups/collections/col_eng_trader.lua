-- SOURCED -- collection_loot.tab column col_eng_trader; cell-count weights (loot.java:1572-1575 rand among cells, duplicates included).
col_eng_trader = {
	description = "",
	minimumLevel = 0,
	maximumLevel = 0,
	lootItems = {
		{itemTemplate = "col_trader_eng_head_02_01", weight = 1481482},
		{itemTemplate = "col_trader_eng_left_arm_02_01", weight = 370371},
		{itemTemplate = "col_trader_eng_left_leg_02_01", weight = 1111112},
		{itemTemplate = "col_trader_eng_right_arm_02_01", weight = 1111112},
		{itemTemplate = "col_trader_eng_right_leg_02_01", weight = 740740},
		{itemTemplate = "col_trader_eng_stand_base_02_01", weight = 1851851},
		{itemTemplate = "col_trader_eng_torso_02_01", weight = 1111111},
		{itemTemplate = "col_ig_88_wooden_dowel_02_01", weight = 1851851},
		{itemTemplate = "col_fried_icecream_fryer_broken_activation", weight = 370370}
	}
}

addLootGroupTemplate("col_eng_trader", col_eng_trader)
