-- Transcribes datatables/loot/loot_items/mustafar/sher_kar_loot.tab (Sher Kar boss).
-- Weights sum to 10000000 as transcribed; do not recompute.
sher_kar_loot = {
	description = "",
	minimumLevel = 0,
	maximumLevel = -1,
	lootItems = {
		{itemTemplate = "weapon_tow_heavy_flamer_repub_06_01", weight = 909090},
		{itemTemplate = "weapon_tow_carbine_wookiee_06_01", weight = 909090},
		{itemTemplate = "weapon_tow_pistol_renegade_06_01", weight = 909090},
		{itemTemplate = "weapon_tow_knuckler_blacksun_06_01", weight = 909090},
		{itemTemplate = "weapon_tow_1h_obsidian_sword_06_01", weight = 909090},
		{itemTemplate = "weapon_tow_2h_massassi_sword_06_01", weight = 909090},
		{itemTemplate = "weapon_tow_polearm_wookiee_lance_06_01", weight = 909090},
		{itemTemplate = "item_tow_mafosa_mez_immune_06_01", weight = 909090},
		{itemTemplate = "cube_loot_3n", weight = 909090},
		{itemTemplate = "cube_loot_3o", weight = 909090},
		{itemTemplate = "item_tow_schematic_saber_03_02", weight = 909100}
	}
}

addLootGroupTemplate("sher_kar_loot", sher_kar_loot)
