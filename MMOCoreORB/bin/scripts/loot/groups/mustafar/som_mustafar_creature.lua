-- Transcribes datatables/loot/loot_items/mustafar/creature.tab
-- (live mustafar/creature), the shared second pool all three Mustafar bounty
-- species roll against. Five items, uniform. Weights sum to 10000000.
som_mustafar_creature = {
	description = "",
	minimumLevel = 0,
	maximumLevel = -1,
	lootItems = {
		{itemTemplate = "item_tow_junk_creature_brain_02_01", weight = 2000000},
		{itemTemplate = "item_tow_junk_creature_bone_02_01", weight = 2000000},
		{itemTemplate = "item_tow_junk_creature_intestines_02_01", weight = 2000000},
		{itemTemplate = "item_tow_junk_creature_hide_02_01", weight = 2000000},
		{itemTemplate = "item_tow_junk_creature_blood_02_01", weight = 2000000}
	}
}

addLootGroupTemplate("som_mustafar_creature", som_mustafar_creature)
