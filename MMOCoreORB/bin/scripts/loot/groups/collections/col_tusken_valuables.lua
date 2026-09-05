-- SOURCED -- collection_loot.tab column col_tusken_valuables; cell-count weights (loot.java:1572-1575 rand among cells, duplicates included).
col_tusken_valuables = {
	description = "",
	minimumLevel = 0,
	maximumLevel = 0,
	lootItems = {
		{itemTemplate = "col_tusken_bantha_braid_02_01", weight = 1612904},
		{itemTemplate = "col_tusken_bantha_bracelet_02_01", weight = 645162},
		{itemTemplate = "col_tusken_gaderffi_02_01", weight = 1612904},
		{itemTemplate = "col_tusken_hubba_gourd_02_01", weight = 645162},
		{itemTemplate = "col_tusken_massif_thorn_02_01", weight = 1290322},
		{itemTemplate = "col_tusken_metal_02_01", weight = 645161},
		{itemTemplate = "col_tusken_talisman_02_01", weight = 1290322},
		{itemTemplate = "col_tusken_spirit_mask_02_01", weight = 1612903},
		{itemTemplate = "col_tusken_womp_rat_tusk_02_01", weight = 322580},
		{itemTemplate = "col_fried_icecream_fryer_broken_activation", weight = 322580}
	}
}

addLootGroupTemplate("col_tusken_valuables", col_tusken_valuables)
