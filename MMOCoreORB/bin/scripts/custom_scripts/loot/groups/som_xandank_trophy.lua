-- Transcribes datatables/loot/loot_items/mustafar/xandank.tab in full.
-- Trophy rate stays 12.5%: widening is on both sides of the multiply.
som_xandank_trophy = {
	description = "",
	minimumLevel = 0,
	maximumLevel = 0,
	lootItems = {
		{itemTemplate = "item_tow_junk_creature_jaw_02_01", weight = 2500000},
		{itemTemplate = "xandank_jaw", weight = 2500000},
		{itemTemplate = "cube_loot_1o", weight = 2500000},
		{itemTemplate = "cube_loot_1x", weight = 2500000}
	}
}

addLootGroupTemplate("som_xandank_trophy", som_xandank_trophy)
