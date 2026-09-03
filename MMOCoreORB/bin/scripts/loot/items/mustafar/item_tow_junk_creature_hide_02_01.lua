-- Live master_item key item_tow_junk_creature_hide_02_01.
-- From loot_items/mustafar/creature.tab.
-- Split path creature/loot is deliberate and matches the repo's own registration.
item_tow_junk_creature_hide_02_01 = {
	minimumLevel = 0,
	maximumLevel = -1,
	customObjectName = "a patch of tough hide",
	directObjectTemplate = "object/tangible/loot/creature/loot/generic/generic_hide.iff",
	craftingValues = {},
	customizationStringNames = {},
	customizationValues = {}
}

addLootItemTemplate("item_tow_junk_creature_hide_02_01", item_tow_junk_creature_hide_02_01)
