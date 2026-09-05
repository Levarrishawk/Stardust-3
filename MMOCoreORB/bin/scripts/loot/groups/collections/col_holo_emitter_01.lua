-- SOURCED -- collection_loot.tab column col_holo_emitter_01; cell-count weights (loot.java:1572-1575 rand among cells, duplicates included).
col_holo_emitter_01 = {
	description = "",
	minimumLevel = 0,
	maximumLevel = 0,
	lootItems = {
		{itemTemplate = "col_holo_emitter_circuit_02_01", weight = 3333334},
		{itemTemplate = "col_holo_emitter_light_source_02_01", weight = 2500001},
		{itemTemplate = "col_holo_emitter_photo_detector_02_01", weight = 1666666},
		{itemTemplate = "col_holo_emitter_processor_02_01", weight = 1666666},
		{itemTemplate = "col_holo_emitter_receptor_02_01", weight = 833333}
	}
}

addLootGroupTemplate("col_holo_emitter_01", col_holo_emitter_01)
