-- Transcribes datatables/loot/loot_items/kashyyyk/forest_snake.tab (SOE strItemType).
-- Object template is in-tree. ruling 2026-09-04: ensure kashyyyk is done in full.
snake_egg = {
	minimumLevel = 0,
	maximumLevel = -1,
	customObjectName = "",
	directObjectTemplate = "object/tangible/loot/creature_loot/kashyyyk_loot/snake_egg.iff",
	craftingValues = {},
	customizationStringNames = {},
	customizationValues = {}
}

addLootItemTemplate("snake_egg", snake_egg)
