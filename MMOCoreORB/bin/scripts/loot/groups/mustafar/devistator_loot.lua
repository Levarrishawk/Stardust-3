-- Transcribes datatables/loot/loot_items/mustafar/devistator_loot.tab
-- (live mustafar/mustafar_trial_devistator).
-- ABSENT from live and not delivered: weapon_tow_heavy_acid_beam_04_01 -- its template
-- object/weapon/ranged/heavy/heavy_acid_beam_static.iff has no registered repo
-- template (the custom_content copy declares 2h_sword_kashyyk.iff and is not
-- included by any serverobjects). Do not substitute.
-- Weights sum to 10000000 as transcribed; do not recompute.
devistator_loot = {
	description = "",
	minimumLevel = 0,
	maximumLevel = -1,
	lootItems = {
		{itemTemplate = "weapon_tow_cannon_04_02", weight = 5000000},
		{itemTemplate = "cube_loot_3j", weight = 5000000}
	}
}

addLootGroupTemplate("devistator_loot", devistator_loot)
