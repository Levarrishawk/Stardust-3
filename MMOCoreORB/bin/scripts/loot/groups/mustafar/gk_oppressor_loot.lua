-- Transcribes datatables/loot/loot_items/mustafar/gk_oppressor_loot.tab.
-- Weights sum to 10000000 as transcribed; do not recompute.
gk_oppressor_loot = {
	description = "",
	minimumLevel = 0,
	maximumLevel = -1,
	lootItems = {
		{itemTemplate = "weapon_tow_heavy_repub_flamethrower_05_01", weight = 2500000},
		{itemTemplate = "weapon_tow_pistol_ion_relic_05_01", weight = 2500000},
		{itemTemplate = "weapon_tow_polearm_obsidian_05_01", weight = 2500000},
		{itemTemplate = "cube_loot_3e", weight = 2500000}
	}
}

addLootGroupTemplate("gk_oppressor_loot", gk_oppressor_loot)
