-- Transcribes datatables/loot/loot_items/mustafar/colonel_or5_loot.tab
-- (live mustafar/mustafar_trial_col_or5).
-- Weights sum to 10000000 as transcribed; do not recompute.
colonel_or5_loot = {
	description = "",
	minimumLevel = 0,
	maximumLevel = -1,
	lootItems = {
		{itemTemplate = "weapon_tow_carbine_e5_04_01", weight = 3333334},
		{itemTemplate = "weapon_tow_pistol_de10_04_01", weight = 3333333},
		{itemTemplate = "weapon_tow_sword_rsf_04_01", weight = 3333333}
	}
}

addLootGroupTemplate("colonel_or5_loot", colonel_or5_loot)
