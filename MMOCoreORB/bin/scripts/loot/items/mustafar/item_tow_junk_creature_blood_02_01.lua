-- Live master_item key item_tow_junk_creature_blood_02_01.
-- From loot_items/mustafar/creature.tab.
-- Split path npc/loot is deliberate and matches the repo's own registration.
item_tow_junk_creature_blood_02_01 = {
	minimumLevel = 0,
	maximumLevel = -1,
	customObjectName = "a bottle of Mustafarian creature blood",
	directObjectTemplate = "object/tangible/loot/npc/loot/serum_vial_generic.iff",
	craftingValues = {},
	customizationStringNames = {},
	customizationValues = {}
}

addLootItemTemplate("item_tow_junk_creature_blood_02_01", item_tow_junk_creature_blood_02_01)
