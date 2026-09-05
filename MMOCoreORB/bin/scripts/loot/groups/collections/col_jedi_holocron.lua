-- SOURCED -- collection_loot.tab column col_jedi_holocron; cell-count weights (loot.java:1572-1575 rand among cells, duplicates included).
col_jedi_holocron = {
	description = "",
	minimumLevel = 0,
	maximumLevel = 0,
	lootItems = {
		{itemTemplate = "item_collection_jedi_holocron_01_01", weight = 512821},
		{itemTemplate = "item_collection_jedi_holocron_01_02", weight = 1025642},
		{itemTemplate = "item_collection_jedi_holocron_01_03", weight = 1538462},
		{itemTemplate = "item_collection_jedi_holocron_01_04", weight = 256411},
		{itemTemplate = "item_collection_jedi_holocron_01_05", weight = 769231},
		{itemTemplate = "item_collection_jedi_holocron_02_01", weight = 1282051},
		{itemTemplate = "item_collection_jedi_holocron_02_02", weight = 1025641},
		{itemTemplate = "item_collection_jedi_holocron_02_03", weight = 1794871},
		{itemTemplate = "item_collection_jedi_holocron_02_04", weight = 512820},
		{itemTemplate = "item_collection_jedi_holocron_02_05", weight = 769230},
		{itemTemplate = "col_fried_icecream_fryer_broken_activation", weight = 512820}
	}
}

addLootGroupTemplate("col_jedi_holocron", col_jedi_holocron)
