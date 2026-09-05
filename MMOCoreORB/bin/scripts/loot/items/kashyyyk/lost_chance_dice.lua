-- Transcribes datatables/loot/loot_items/kashyyyk/forest_snake.tab (SOE strItemType).
-- Object template is in-tree. ruling 2026-09-04: ensure kashyyyk is done in full.
lost_chance_dice = {
	minimumLevel = 0,
	maximumLevel = -1,
	customObjectName = "",
	directObjectTemplate = "object/tangible/loot/creature_loot/kashyyyk_loot/lost_chance_dice.iff",
	craftingValues = {},
	customizationStringNames = {},
	customizationValues = {}
}

addLootItemTemplate("lost_chance_dice", lost_chance_dice)
