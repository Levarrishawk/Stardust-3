-- Transcribes datatables/loot/loot_items/mustafar/storm_lord_drop.tab.
-- ABSENT and not delivered: item_tow_ring_01_01 -- not present in live's own
-- master_item.tab at all (a live data bug), so there is nothing to port.
-- Weights sum to 10000000 as transcribed; do not recompute.
storm_lord_drop = {
	description = "",
	minimumLevel = 0,
	maximumLevel = -1,
	lootItems = {
		{itemTemplate = "weapon_tow_sword_1h_03_02", weight = 2500000},
		{itemTemplate = "item_jedi_robe_04_02", weight = 2500000},
		{itemTemplate = "cube_loot_2s", weight = 2500000},
		{itemTemplate = "cube_loot_2o", weight = 2500000}
	}
}

addLootGroupTemplate("storm_lord_drop", storm_lord_drop)
