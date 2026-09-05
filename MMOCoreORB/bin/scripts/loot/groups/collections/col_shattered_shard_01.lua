-- SOURCED -- collection_loot.tab column col_shattered_shard_01; cell-count weights (loot.java:1572-1575 rand among cells, duplicates included).
col_shattered_shard_01 = {
	description = "",
	minimumLevel = 0,
	maximumLevel = 0,
	lootItems = {
		{itemTemplate = "col_shattered_shard_unknown_02_01", weight = 2758621},
		{itemTemplate = "col_shattered_shard_unknown_02_10", weight = 4137932},
		{itemTemplate = "col_shattered_shard_unknown_02_03", weight = 1379310},
		{itemTemplate = "col_shattered_shard_unknown_02_07", weight = 1379310},
		{itemTemplate = "col_fried_icecream_fryer_broken_activation", weight = 344827}
	}
}

addLootGroupTemplate("col_shattered_shard_01", col_shattered_shard_01)
