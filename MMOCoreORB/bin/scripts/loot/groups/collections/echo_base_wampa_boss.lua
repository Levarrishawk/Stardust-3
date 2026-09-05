-- SOURCED -- collection_loot.tab column echo_base_wampa_boss; cell-count weights (loot.java:1572-1575 rand among cells, duplicates included).
echo_base_wampa_boss = {
	description = "",
	minimumLevel = 0,
	maximumLevel = 0,
	lootItems = {
		{itemTemplate = "item_heroic_backpack_tauntaun_skull_01_01", weight = 5000000},
		{itemTemplate = "item_wampa_snow_globe", weight = 5000000}
	}
}

addLootGroupTemplate("echo_base_wampa_boss", echo_base_wampa_boss)
