-- echo_base_generic_soldier -- hop-3 soldier prop table.
--
-- SOURCED (SOE, datatables/loot/loot_items/dungeon/heroic_drops.tab col 17
-- echo_base_generic_soldier): 15 st_pr_hoth_* plus costume_darktrooper_3,
-- once each. Equal weight, sum 10 000 000 (16 x 625 000).
--
-- Name collision: heroic.tab col 17 is also echo_base_generic_soldier and
-- is the hop-1 composition (this table x1 + echo_base_soldier_junk x4).
-- SD3 has one loot-group namespace, so this file is the hop-3 leaf that
-- rebel/imperial nest. Nobody's creatures.tab lootTable is hop-1 col 17.

echo_base_generic_soldier = {
	description = "",
	minimumLevel = 0,
	maximumLevel = -1,
	lootItems = {
		{itemTemplate = "st_pr_hoth_cable_box_01", weight = 625000},
		{itemTemplate = "st_pr_hoth_cable_box_02", weight = 625000},
		{itemTemplate = "st_pr_hoth_cable_box_03", weight = 625000},
		{itemTemplate = "st_pr_hoth_crate_01", weight = 625000},
		{itemTemplate = "st_pr_hoth_crate_02", weight = 625000},
		{itemTemplate = "st_pr_hoth_crate_03", weight = 625000},
		{itemTemplate = "st_pr_hoth_icicle_01", weight = 625000},
		{itemTemplate = "st_pr_hoth_icicle_02", weight = 625000},
		{itemTemplate = "st_pr_hoth_icicle_03", weight = 625000},
		{itemTemplate = "st_pr_hoth_light_standing", weight = 625000},
		{itemTemplate = "st_pr_hoth_scaffold", weight = 625000},
		{itemTemplate = "st_pr_hoth_terminal_01", weight = 625000},
		{itemTemplate = "st_pr_hoth_toolbox", weight = 625000},
		{itemTemplate = "st_pr_hoth_radio", weight = 625000},
		{itemTemplate = "st_pr_hoth_snow_trooper_gun", weight = 625000},
		{itemTemplate = "costume_darktrooper_3", weight = 625000},
	}
}

addLootGroupTemplate("echo_base_generic_soldier", echo_base_generic_soldier)
