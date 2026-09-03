-- Transcribes datatables/loot/loot_items/mustafar/kubaza_foreman.tab
-- (live mustafar/mustafar_trial_foreman).
-- ABSENT from live and not delivered: weapon_tow_grenade_fragmentation_04_01 --
-- object/weapon/ranged/grenade/grenade_fragmentation_generic.iff has no registered
-- repo template. Do not substitute.
-- Weights sum to 10000000 as transcribed; do not recompute.
kubaza_foreman = {
	description = "",
	minimumLevel = 0,
	maximumLevel = -1,
	lootItems = {
		{itemTemplate = "weapon_tow_carbine_sfor_03_01", weight = 1428571},
		{itemTemplate = "weapon_tow_polearm_obsidian_03_01", weight = 1428571},
		{itemTemplate = "item_tow_ring_armorsmith_04_01", weight = 1428571},
		{itemTemplate = "item_tow_ring_weaponsmith_04_01", weight = 1428571},
		{itemTemplate = "item_tow_foreman_fire_absorb_04_01", weight = 1428571},
		{itemTemplate = "item_tow_foreman_burst_run_04_01", weight = 1428571},
		{itemTemplate = "cube_loot_3b", weight = 1428574}
	}
}

addLootGroupTemplate("kubaza_foreman", kubaza_foreman)
