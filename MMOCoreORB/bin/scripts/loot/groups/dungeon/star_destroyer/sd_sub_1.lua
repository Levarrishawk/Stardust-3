-- loot/groups/dungeon/star_destroyer/sd_sub_1.lua
-- SOURCED: the item list and the relative frequencies come from
--   SRC/datatables/loot/loot_items/dungeon/heroic_drops.tab column sd_sub_1 (22 entries, 13 distinct),
--   reached from SRC/datatables/loot/loot_types/heroic/heroic.tab:3-5 column sd_sub_1.
--   Consumer: creatures.tab:5834 heroic_sd_krix_swiftshadow, lootTable heroic/heroic:sd_sub_1.
-- OURS, NOT SOURCED: the weights. SOE has no weight column -- it repeats an entry to double it.
--   The polearm schematic (x4) and the cryo-projector draft (x1) are DROPPED: they need
--   object/tangible/loot/loot_schematic/generic_limited_use.iff, which is not registered on SD3
--   (PART 7.3). Their 5/22 share is redistributed proportionally across the 17 that remain.
--   Arithmetic: 6 necklaces x2 = 12 shares at 1176470; 4 parts + costume = 5 shares at 588236.
--   6*1176470 + 5*588236 = 7058820 + 2941180 = 10000000.
-- UNOBTAINABLE: item_schematic_polearm_heroic_sd_01_01, item_limited_use_schematic_commando_ice_gun_04_01.
sd_sub_1 = {
	description = "",
	minimumLevel = 0,
	maximumLevel = 0,
	lootItems = {
		{itemTemplate = "necklace_s05", weight = 1176470},
		{itemTemplate = "necklace_s06", weight = 1176470},
		{itemTemplate = "necklace_s07", weight = 1176470},
		{itemTemplate = "necklace_s08", weight = 1176470},
		{itemTemplate = "necklace_s09", weight = 1176470},
		{itemTemplate = "necklace_s10", weight = 1176470},
		{itemTemplate = "heroic_destroyer_cooling_coil",      weight = 588236},
		{itemTemplate = "heroic_destroyer_power_transformer", weight = 588236},
		{itemTemplate = "heroic_destroyer_reactor_console",   weight = 588236},
		{itemTemplate = "heroic_destroyer_space_beacon",      weight = 588236},
		{itemTemplate = "costume_darktrooper_3",              weight = 588236},
	}
}
addLootGroupTemplate("sd_sub_1", sd_sub_1)
