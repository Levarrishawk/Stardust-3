-- SOURCED -- collection_loot.tab column housing_improvement_02; cell-count weights (loot.java:1572-1575 rand among cells, duplicates included).
housing_improvement_02 = {
	description = "",
	minimumLevel = 0,
	maximumLevel = 0,
	lootItems = {
		{itemTemplate = "item_collection_housing_improvement_02_01", weight = 625000},
		{itemTemplate = "item_collection_housing_improvement_02_02", weight = 312500},
		{itemTemplate = "item_collection_housing_improvement_02_03", weight = 1562500},
		{itemTemplate = "item_collection_housing_improvement_02_04", weight = 937500},
		{itemTemplate = "item_collection_housing_improvement_02_05", weight = 937500},
		{itemTemplate = "item_collection_housing_improvement_02_06", weight = 1562500},
		{itemTemplate = "item_collection_housing_improvement_02_07", weight = 312500},
		{itemTemplate = "item_collection_housing_improvement_02_08", weight = 1875000},
		{itemTemplate = "item_collection_housing_improvement_02_09", weight = 937500},
		{itemTemplate = "item_collection_housing_improvement_02_10", weight = 625000},
		{itemTemplate = "col_fried_icecream_fryer_broken_activation", weight = 312500}
	}
}

addLootGroupTemplate("housing_improvement_02", housing_improvement_02)
