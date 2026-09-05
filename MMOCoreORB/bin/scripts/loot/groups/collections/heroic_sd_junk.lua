-- SOURCED -- collection_loot.tab column heroic_sd_junk; cell-count weights (loot.java:1572-1575 rand among cells, duplicates included).
heroic_sd_junk = {
	description = "",
	minimumLevel = 0,
	maximumLevel = 0,
	lootItems = {
		{itemTemplate = "item_heroic_sd_missile_crate_02_01", weight = 3333334},
		{itemTemplate = "item_heroic_sd_poison_canister_02_01", weight = 3333333},
		{itemTemplate = "item_heroic_sd_pressure_pump_02_01", weight = 3333333}
	}
}

addLootGroupTemplate("heroic_sd_junk", heroic_sd_junk)
