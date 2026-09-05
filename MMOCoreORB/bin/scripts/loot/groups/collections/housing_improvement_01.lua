-- SOURCED -- collection_loot.tab column housing_improvement_01; cell-count weights (loot.java:1572-1575 rand among cells, duplicates included).
housing_improvement_01 = {
	description = "",
	minimumLevel = 0,
	maximumLevel = 0,
	lootItems = {
		{itemTemplate = "item_collection_housing_improvement_01_01", weight = 937500},
		{itemTemplate = "item_collection_housing_improvement_01_02", weight = 937500},
		{itemTemplate = "item_collection_housing_improvement_01_03", weight = 1562500},
		{itemTemplate = "item_collection_housing_improvement_01_04", weight = 312500},
		{itemTemplate = "item_collection_housing_improvement_01_05", weight = 625000},
		{itemTemplate = "item_collection_housing_improvement_01_06", weight = 1250000},
		{itemTemplate = "item_collection_housing_improvement_01_07", weight = 937500},
		{itemTemplate = "item_collection_housing_improvement_01_08", weight = 1250000},
		{itemTemplate = "item_collection_housing_improvement_01_09", weight = 937500},
		{itemTemplate = "item_collection_housing_improvement_01_10", weight = 937500},
		{itemTemplate = "col_fried_icecream_fryer_broken_activation", weight = 312500}
	}
}

addLootGroupTemplate("housing_improvement_01", housing_improvement_01)
