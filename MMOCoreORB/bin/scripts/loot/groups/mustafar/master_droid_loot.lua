-- Transcribes datatables/loot/loot_items/mustafar/master_droid_loot.tab
-- (live mustafar/mustafar_trial_engineer).
-- Weights sum to 10000000 as transcribed; do not recompute.
master_droid_loot = {
	description = "",
	minimumLevel = 0,
	maximumLevel = -1,
	lootItems = {
		{itemTemplate = "weapon_tow_pistol_kyd21_04_01", weight = 3333333},
		{itemTemplate = "weapon_tow_sword_2h_04_03", weight = 3333333},
		{itemTemplate = "cube_loot_3d", weight = 3333334}
	}
}

addLootGroupTemplate("master_droid_loot", master_droid_loot)
