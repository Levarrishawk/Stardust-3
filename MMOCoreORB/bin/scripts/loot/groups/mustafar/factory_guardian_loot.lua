-- Transcribes datatables/loot/loot_items/mustafar/factory_guardian_loot.tab
-- (live mustafar/mustafar_trial_factory_guardian).
-- item_tow_factory_gaurd_trinket_04_01 keeps live's own misspelling "gaurd"
-- verbatim; that is live's key, not a typo introduced here.
-- Weights sum to 10000000 as transcribed; do not recompute.
factory_guardian_loot = {
	description = "",
	minimumLevel = 0,
	maximumLevel = -1,
	lootItems = {
		{itemTemplate = "item_tow_ring_droideng_04_01", weight = 1428574},
		{itemTemplate = "item_tow_ring_bioeng_04_01", weight = 1428571},
		{itemTemplate = "item_tow_ring_chef_04_01", weight = 1428571},
		{itemTemplate = "weapon_tow_rifle_lightning_cannon_04_01", weight = 1428571},
		{itemTemplate = "weapon_tow_blasterfist_04_01", weight = 1428571},
		{itemTemplate = "item_tow_factory_gaurd_trinket_04_01", weight = 1428571},
		{itemTemplate = "cube_loot_3a", weight = 1428571}
	}
}

addLootGroupTemplate("factory_guardian_loot", factory_guardian_loot)
