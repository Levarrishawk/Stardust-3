-- Transcribes datatables/loot/loot_items/mustafar/sher_kar_consort.tab, which is the
-- table datatables/loot/loot_types/mustafar/mustafar_sherkar_consort.tab points at.
-- One real row (cube_loot_3r) and ten blank rows -- the blanks are how live expresses
-- the drop rate, so they are NOT reproduced as entries here. The 1-in-11 they encode is
-- carried by lootChance = 909091 on the creature instead, which is where Core3 puts it.

sher_kar_consort = {
	description = "",
	minimumLevel = 0,
	maximumLevel = -1,
	lootItems = {
		{itemTemplate = "cube_loot_3r", weight = 10000000}
	}
}

addLootGroupTemplate("sher_kar_consort", sher_kar_consort)
