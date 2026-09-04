-- Transcribes datatables/loot/loot_items/mustafar/tulrus.tab in full.
-- Trophy rate stays 12.5%: widening is on both sides of the multiply.
som_tulrus_trophy = {
	description = "",
	minimumLevel = 0,
	maximumLevel = 0,
	lootItems = {
		{itemTemplate = "item_tow_junk_creature_horn_02_01", weight = 2500000},
		{itemTemplate = "tulrus_parts", weight = 2500000},
		{itemTemplate = "cube_loot_1g", weight = 2500000},
		{itemTemplate = "cube_loot_1p", weight = 2500000}
	}
}

addLootGroupTemplate("som_tulrus_trophy", som_tulrus_trophy)
