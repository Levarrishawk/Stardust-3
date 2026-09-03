-- Transcribes datatables/loot/loot_items/mustafar/blistmok.tab in full.
-- Trophy rate stays 12.5%: widening is on both sides of the multiply.
som_blistmok_trophy = {
	description = "",
	minimumLevel = 0,
	maximumLevel = 0,
	lootItems = {
		{itemTemplate = "item_tow_junk_creature_eye_02_01", weight = 2500000},
		{itemTemplate = "blistmok_heart", weight = 2500000},
		{itemTemplate = "cube_loot_1y", weight = 2500000},
		{itemTemplate = "cube_loot_1f", weight = 2500000}
	}
}

addLootGroupTemplate("som_blistmok_trophy", som_blistmok_trophy)
