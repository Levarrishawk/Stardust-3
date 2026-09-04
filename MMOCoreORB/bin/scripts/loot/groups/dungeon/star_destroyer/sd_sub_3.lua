-- loot/groups/dungeon/star_destroyer/sd_sub_3.lua
-- SOURCED: the item list and the relative frequencies come from
--   SRC/datatables/loot/loot_items/dungeon/heroic_drops.tab column sd_sub_3 (22 entries, 13 distinct),
--   reached from SRC/datatables/loot/loot_types/heroic/heroic.tab:3-5 column sd_sub_3.
--   Consumer: creatures.tab:5814 heroic_sd_commander_kenkirk, lootTable heroic/heroic:sd_sub_3.
-- OURS, NOT SOURCED: the weights. Same 17-resolvable-share construction as sd_sub_1.
--   5 left bracelets x2 + neck_01_12 x2 = 12 shares at 1176470; 4 parts + costume = 5 at 588236.
-- UNOBTAINABLE: item_schematic_pistol_heroic_sd_01_01, item_limited_use_schematic_commando_ice_gun_04_01.
sd_sub_3 = {
	description = "",
	minimumLevel = 0,
	maximumLevel = 0,
	lootItems = {
		{itemTemplate = "bracelet_s02_l", weight = 1176470},
		{itemTemplate = "bracelet_s03_l", weight = 1176470},
		{itemTemplate = "bracelet_s04_l", weight = 1176470},
		{itemTemplate = "bracelet_s05_l", weight = 1176470},
		{itemTemplate = "bracelet_s06_l", weight = 1176470},
		{itemTemplate = "necklace_s12",   weight = 1176470},
		{itemTemplate = "heroic_destroyer_cooling_coil",      weight = 588236},
		{itemTemplate = "heroic_destroyer_power_transformer", weight = 588236},
		{itemTemplate = "heroic_destroyer_reactor_console",   weight = 588236},
		{itemTemplate = "heroic_destroyer_space_beacon",      weight = 588236},
		{itemTemplate = "costume_darktrooper_3",              weight = 588236},
	}
}
addLootGroupTemplate("sd_sub_3", sd_sub_3)
