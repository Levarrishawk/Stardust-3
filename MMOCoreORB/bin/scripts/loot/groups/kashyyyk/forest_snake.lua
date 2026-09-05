-- Transcribes datatables/loot/loot_types/kashyyyk/forest_snake.tab
-- strItems lists: kashyyyk/forest_snake
-- OURS: equal weights (SOE gives no per-item weights in these tables). Sum 10000000.
-- ruling 2026-09-04: ensure kashyyyk is done in full.
forest_snake = {
	description = "",
	minimumLevel = 0,
	maximumLevel = -1,
	lootItems = {
		{itemTemplate = "snake_blood", weight = 833334},
		{itemTemplate = "snake_brain", weight = 833334},
		{itemTemplate = "snake_egg", weight = 833334},
		{itemTemplate = "snake_eye", weight = 833334},
		{itemTemplate = "snake_forgotten_relic", weight = 833333},
		{itemTemplate = "snake_meat", weight = 833333},
		{itemTemplate = "snake_poison", weight = 833333},
		{itemTemplate = "snake_riverpearl", weight = 833333},
		{itemTemplate = "snake_riverweed", weight = 833333},
		{itemTemplate = "lost_chance_dice", weight = 833333},
		{itemTemplate = "decomposed_fish_01", weight = 833333},
		{itemTemplate = "decomposed_fish_02", weight = 833333},
	}
}

addLootGroupTemplate("forest_snake", forest_snake)
