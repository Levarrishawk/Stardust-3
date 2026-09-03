-- Transcribes datatables/loot/loot_items/mustafar/doombringer_loot.tab.
-- ABSENT from live and not delivered: item_tow_schematic_psg_05_01 -- its template
-- object/tangible/loot/loot_schematic/generic_limited_use.iff has no registered repo
-- template (the flashy variant does; the plain one does not). Do not substitute.
-- Weights sum to 10000000 as transcribed; do not recompute.
doombringer_loot = {
	description = "",
	minimumLevel = 0,
	maximumLevel = -1,
	lootItems = {
		{itemTemplate = "weapon_tow_pistol_scatter_04_01", weight = 2500000},
		{itemTemplate = "weapon_tow_rifle_dp3_04_01", weight = 2500000},
		{itemTemplate = "weapon_tow_2h_obsidian_04_01", weight = 2500000},
		{itemTemplate = "cube_loot_3c", weight = 2500000}
	}
}

addLootGroupTemplate("doombringer_loot", doombringer_loot)
