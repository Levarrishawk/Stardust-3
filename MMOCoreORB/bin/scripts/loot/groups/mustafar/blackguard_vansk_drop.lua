-- Transcribes datatables/loot/loot_items/mustafar/blackguard_vansk_drop.tab.
-- Weights sum to 10000000 as transcribed; do not recompute.
blackguard_vansk_drop = {
	description = "",
	minimumLevel = 0,
	maximumLevel = -1,
	lootItems = {
		{itemTemplate = "weapon_tow_sword_1h_03_01", weight = 5000000},
		{itemTemplate = "cube_loot_2i", weight = 5000000}
	}
}

addLootGroupTemplate("blackguard_vansk_drop", blackguard_vansk_drop)
