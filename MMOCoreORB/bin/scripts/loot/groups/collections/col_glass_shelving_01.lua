-- SOURCED -- collection_loot.tab column col_glass_shelving_01; cell-count weights (loot.java:1572-1575 rand among cells, duplicates included).
col_glass_shelving_01 = {
	description = "",
	minimumLevel = 0,
	maximumLevel = 0,
	lootItems = {
		{itemTemplate = "col_glass_shelf_02_01", weight = 1612904},
		{itemTemplate = "col_glass_shelf_02_02", weight = 3225807},
		{itemTemplate = "col_glass_shelf_02_03", weight = 4838709},
		{itemTemplate = "col_fried_icecream_fryer_broken_activation", weight = 322580}
	}
}

addLootGroupTemplate("col_glass_shelving_01", col_glass_shelving_01)
