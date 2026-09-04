-- echo_base_generic_soldier_roll -- hop-1 soldier composition.
--
-- Name suffix _roll is OURS, NOT SOURCED: SOE names this table
-- echo_base_generic_soldier, which collides with the hop-3 leaf of the
-- same name (loot/groups/dungeon/echo_base/echo_base_generic_soldier.lua).
--
-- SOURCED (SOE, datatables/loot/loot_types/heroic/heroic.tab col 17
-- echo_base_generic_soldier): dungeon/heroic_drops:echo_base_generic_soldier
-- x1 (heroic_drops.tab col 17 = 15 st_pr_hoth_* + costume_darktrooper_3)
-- plus dungeon/heroic_drops:echo_base_soldier_junk x4 (heroic_drops.tab
-- col 13 = 10 junk). SD3 groups do not nest, so this is the flat union:
-- the 16 leaf items share 1/5 of 10 000 000 (16 x 125 000), the 10 junk
-- items share 4/5 (10 x 800 000). Sum 10 000 000.

echo_base_generic_soldier_roll = {
	description = "",
	minimumLevel = 0,
	maximumLevel = -1,
	lootItems = {
		{itemTemplate = "st_pr_hoth_cable_box_01", weight = 125000},
		{itemTemplate = "st_pr_hoth_cable_box_02", weight = 125000},
		{itemTemplate = "st_pr_hoth_cable_box_03", weight = 125000},
		{itemTemplate = "st_pr_hoth_crate_01", weight = 125000},
		{itemTemplate = "st_pr_hoth_crate_02", weight = 125000},
		{itemTemplate = "st_pr_hoth_crate_03", weight = 125000},
		{itemTemplate = "st_pr_hoth_icicle_01", weight = 125000},
		{itemTemplate = "st_pr_hoth_icicle_02", weight = 125000},
		{itemTemplate = "st_pr_hoth_icicle_03", weight = 125000},
		{itemTemplate = "st_pr_hoth_light_standing", weight = 125000},
		{itemTemplate = "st_pr_hoth_scaffold", weight = 125000},
		{itemTemplate = "st_pr_hoth_terminal_01", weight = 125000},
		{itemTemplate = "st_pr_hoth_toolbox", weight = 125000},
		{itemTemplate = "st_pr_hoth_radio", weight = 125000},
		{itemTemplate = "st_pr_hoth_snow_trooper_gun", weight = 125000},
		{itemTemplate = "costume_darktrooper_3", weight = 125000},
		{itemTemplate = "heroic_echo_at_at_junk_02_01", weight = 800000},
		{itemTemplate = "heroic_echo_at_at_junk_02_02", weight = 800000},
		{itemTemplate = "heroic_echo_at_at_junk_02_03", weight = 800000},
		{itemTemplate = "heroic_echo_at_at_junk_02_04", weight = 800000},
		{itemTemplate = "heroic_echo_at_at_junk_02_05", weight = 800000},
		{itemTemplate = "heroic_echo_snow_speeder_junk_02_01", weight = 800000},
		{itemTemplate = "heroic_echo_snow_speeder_junk_02_02", weight = 800000},
		{itemTemplate = "heroic_echo_snow_speeder_junk_02_03", weight = 800000},
		{itemTemplate = "heroic_echo_snow_speeder_junk_02_04", weight = 800000},
		{itemTemplate = "heroic_echo_snow_speeder_junk_02_05", weight = 800000},
	}
}

addLootGroupTemplate("echo_base_generic_soldier_roll", echo_base_generic_soldier_roll)
