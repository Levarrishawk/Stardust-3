-- SOURCED -- collection_loot.tab column heroic_exar_caretaker; cell-count weights (loot.java:1572-1575 rand among cells, duplicates included).
heroic_exar_caretaker = {
	description = "",
	minimumLevel = 0,
	maximumLevel = 0,
	lootItems = {
		{itemTemplate = "col_heroic_exar_kun_lost_journal_02_01", weight = 3333334},
		{itemTemplate = "col_heroic_exar_kun_lost_journal_02_02", weight = 3333334},
		{itemTemplate = "item_heroic_exar_broach_02_01", weight = 666667},
		{itemTemplate = "item_heroic_exar_excavation_toolchest_02_01", weight = 666667},
		{itemTemplate = "item_heroic_exar_artifact_crate_02_01", weight = 666666},
		{itemTemplate = "item_heroic_exar_artifact_scroll_02_01", weight = 666666},
		{itemTemplate = "item_heroic_exar_artifact_02_01", weight = 666666}
	}
}

addLootGroupTemplate("heroic_exar_caretaker", heroic_exar_caretaker)
