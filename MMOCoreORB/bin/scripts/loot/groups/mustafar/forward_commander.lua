-- Transcribes datatables/loot/loot_items/mustafar/forward_commander.tab.
-- ABSENT from live and not delivered: item_tow_commander_stim_04_01 --
-- object/tangible/medicine/instant_stimpack/stimpack_generic_e.iff has no registered
-- repo template. Do not substitute.
-- Weights sum to 10000000 as transcribed; do not recompute.
forward_commander = {
	description = "",
	minimumLevel = 0,
	maximumLevel = -1,
	lootItems = {
		{itemTemplate = "weapon_tow_rifle_ld1_04_01", weight = 2000000},
		{itemTemplate = "weapon_tow_pistol_04_03", weight = 2000000},
		{itemTemplate = "weapon_tow_sword_junti_04_01", weight = 2000000},
		{itemTemplate = "cube_loot_3f", weight = 2000000},
		{itemTemplate = "cube_loot_3l", weight = 2000000}
	}
}

addLootGroupTemplate("forward_commander", forward_commander)
