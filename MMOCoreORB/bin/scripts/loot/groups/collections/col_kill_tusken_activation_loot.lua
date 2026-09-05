-- SOURCED -- collection_loot.tab column col_kill_tusken_activation_loot; cell-count weights (loot.java:1572-1575 rand among cells, duplicates included).
col_kill_tusken_activation_loot = {
	description = "",
	minimumLevel = 0,
	maximumLevel = 0,
	lootItems = {
		{itemTemplate = "col_kill_tusken_activation_02_01", weight = 9696970},
		{itemTemplate = "col_fried_icecream_fryer_broken_activation", weight = 303030}
	}
}

addLootGroupTemplate("col_kill_tusken_activation_loot", col_kill_tusken_activation_loot)
