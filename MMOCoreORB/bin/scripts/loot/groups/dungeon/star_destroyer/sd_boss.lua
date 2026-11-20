-- loot/groups/dungeon/star_destroyer/sd_boss.lua
-- SOURCED: the item list and the relative frequencies come from
--   SRC/datatables/loot/loot_items/dungeon/heroic_drops.tab column sd_boss (19 entries, 12 distinct),
--   reached from SRC/datatables/loot/loot_types/heroic/heroic.tab:3-5 column sd_boss.
--   Consumer: creatures.tab:5813 heroic_sd_captain_sait, lootTable heroic/heroic:sd_boss.
-- OURS, NOT SOURCED: the weights. SOE has no weight column -- it repeats an entry to double it.
--   The 3 backpack schematics (x2 each) and the cryo-projector draft are DROPPED: they need
--   object/tangible/loot/loot_schematic/generic_limited_use.iff, which is not registered on SD3
--   (PART 7.3). Their 7/19 share is redistributed proportionally across the 12 that remain.
-- UNOBTAINABLE: item_heroic_schematic_backpack_01_07/08/09, item_limited_use_schematic_commando_ice_gun_04_01.
sd_boss = {
	description = "",
	minimumLevel = 0,
	maximumLevel = 0,
	lootItems = {
		{itemTemplate = "necklace_s01", weight = 1666666},
		{itemTemplate = "necklace_s02", weight = 1666666},
		{itemTemplate = "necklace_s03", weight = 1666667},
		{itemTemplate = "necklace_s04", weight = 1666667},
		{itemTemplate = "heroic_destroyer_cooling_coil", weight = 833333},
		{itemTemplate = "heroic_destroyer_power_transformer", weight = 833333},
		{itemTemplate = "heroic_destroyer_reactor_console", weight = 833334},
		{itemTemplate = "heroic_destroyer_space_beacon", weight = 833334},
	}
}
addLootGroupTemplate("sd_boss", sd_boss)
