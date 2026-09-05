-- SOURCED -- collection_loot.tab column heroic_exar_minder; cell-count weights (loot.java:1572-1575 rand among cells, duplicates included).
heroic_exar_minder = {
	description = "",
	minimumLevel = 0,
	maximumLevel = 0,
	lootItems = {
		{itemTemplate = "col_heroic_exar_kun_lost_journal_02_07", weight = 4347827},
		{itemTemplate = "item_heroic_exar_broach_02_01", weight = 652174},
		{itemTemplate = "item_heroic_exar_excavation_toolchest_02_01", weight = 1304348},
		{itemTemplate = "item_heroic_exar_artifact_crate_02_01", weight = 652174},
		{itemTemplate = "item_heroic_exar_artifact_scroll_02_01", weight = 652174},
		{itemTemplate = "item_heroic_exar_artifact_02_01", weight = 1086957},
		{itemTemplate = "col_pristine_egg_02_01", weight = 652173},
		{itemTemplate = "col_pristine_milk_02_01", weight = 652173}
	}
}

addLootGroupTemplate("heroic_exar_minder", heroic_exar_minder)
