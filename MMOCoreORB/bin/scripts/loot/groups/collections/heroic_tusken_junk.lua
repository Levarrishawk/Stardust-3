-- SOURCED -- collection_loot.tab column heroic_tusken_junk; cell-count weights (loot.java:1572-1575 rand among cells, duplicates included).
heroic_tusken_junk = {
	description = "",
	minimumLevel = 0,
	maximumLevel = 0,
	lootItems = {
		{itemTemplate = "item_heroic_tusken_disabled_beacon_02_01", weight = 3333334},
		{itemTemplate = "item_heroic_tusken_medic_kit_02_01", weight = 3333333},
		{itemTemplate = "item_heroic_tusken_old_capacitor_02_01", weight = 3333333}
	}
}

addLootGroupTemplate("heroic_tusken_junk", heroic_tusken_junk)
