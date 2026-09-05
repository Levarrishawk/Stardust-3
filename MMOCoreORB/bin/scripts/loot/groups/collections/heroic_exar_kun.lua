-- SOURCED -- collection_loot.tab column heroic_exar_kun; cell-count weights (loot.java:1572-1575 rand among cells, duplicates included).
heroic_exar_kun = {
	description = "",
	minimumLevel = 0,
	maximumLevel = 0,
	lootItems = {
		{itemTemplate = "col_heroic_exar_kun_lost_journal_02_08", weight = 4651163},
		{itemTemplate = "item_heroic_exar_broach_02_01", weight = 697675},
		{itemTemplate = "item_heroic_exar_excavation_toolchest_02_01", weight = 1395349},
		{itemTemplate = "item_heroic_exar_artifact_crate_02_01", weight = 697675},
		{itemTemplate = "item_heroic_exar_artifact_scroll_02_01", weight = 1162790},
		{itemTemplate = "item_heroic_exar_artifact_02_01", weight = 1162790},
		{itemTemplate = "item_heroic_exar_kun_ultra_rare_02_01", weight = 232558}
	}
}

addLootGroupTemplate("heroic_exar_kun", heroic_exar_kun)
