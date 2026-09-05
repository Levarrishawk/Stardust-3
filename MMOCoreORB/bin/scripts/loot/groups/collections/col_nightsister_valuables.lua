-- SOURCED -- collection_loot.tab column col_nightsister_valuables; cell-count weights (loot.java:1572-1575 rand among cells, duplicates included).
col_nightsister_valuables = {
	description = "",
	minimumLevel = 0,
	maximumLevel = 0,
	lootItems = {
		{itemTemplate = "col_nightsister_bracelet_02_01", weight = 1538462},
		{itemTemplate = "col_nightsister_broach_02_01", weight = 1538462},
		{itemTemplate = "col_nightsister_pendant_02_01", weight = 1153847},
		{itemTemplate = "col_nightsister_ring_02_01", weight = 769231},
		{itemTemplate = "col_nightsister_earrings_02_01", weight = 384616},
		{itemTemplate = "col_trader_dom_gem_bead_02_01", weight = 769231},
		{itemTemplate = "col_trader_dom_gold_wire_02_01", weight = 769230},
		{itemTemplate = "col_trader_dom_green_bead_02_01", weight = 769230},
		{itemTemplate = "col_trader_dom_jewelry_clasp_02_01", weight = 769230},
		{itemTemplate = "col_trader_dom_gold_bead_02_01", weight = 1153846},
		{itemTemplate = "col_fried_icecream_fryer_broken_activation", weight = 384615}
	}
}

addLootGroupTemplate("col_nightsister_valuables", col_nightsister_valuables)
