-- SOURCED -- collection_loot.tab column col_mun_trader; cell-count weights (loot.java:1572-1575 rand among cells, duplicates included).
col_mun_trader = {
	description = "",
	minimumLevel = 0,
	maximumLevel = 0,
	lootItems = {
		{itemTemplate = "col_trader_mun_head_02_01", weight = 1538462},
		{itemTemplate = "col_trader_mun_left_arm_02_01", weight = 1153847},
		{itemTemplate = "col_trader_mun_left_leg_02_01", weight = 384616},
		{itemTemplate = "col_trader_mun_right_arm_02_01", weight = 1153846},
		{itemTemplate = "col_trader_mun_right_leg_02_01", weight = 1538461},
		{itemTemplate = "col_trader_mun_stand_base_02_01", weight = 1153846},
		{itemTemplate = "col_trader_mun_torso_02_01", weight = 1153846},
		{itemTemplate = "col_stormtrooper_wooden_dowel_02_01", weight = 1538461},
		{itemTemplate = "col_fried_icecream_fryer_broken_activation", weight = 384615}
	}
}

addLootGroupTemplate("col_mun_trader", col_mun_trader)
