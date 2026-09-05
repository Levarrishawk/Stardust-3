-- Transcribes datatables/loot/loot_types/kashyyyk/sayormi_warrior.tab
-- strItems lists: kashyyyk/sayormi_warrior
-- OURS: equal weights (SOE gives no per-item weights in these tables). Sum 10000000.
-- ruling 2026-09-04: ensure kashyyyk is done in full.
sayormi_warrior = {
	description = "",
	minimumLevel = 0,
	maximumLevel = -1,
	lootItems = {
		{itemTemplate = "archaic_sayormi_blade", weight = 400000},
		{itemTemplate = "black_potion", weight = 400000},
		{itemTemplate = "corrupted_fruit", weight = 400000},
		{itemTemplate = "glow_stick", weight = 400000},
		{itemTemplate = "mystical_scroll", weight = 400000},
		{itemTemplate = "mystical_tome", weight = 400000},
		{itemTemplate = "mystical_tome_01", weight = 400000},
		{itemTemplate = "mystical_tome_02", weight = 400000},
		{itemTemplate = "mystical_tome_03", weight = 400000},
		{itemTemplate = "mystical_tome_04", weight = 400000},
		{itemTemplate = "orange_potion", weight = 400000},
		{itemTemplate = "potion_component_01", weight = 400000},
		{itemTemplate = "potion_component_02", weight = 400000},
		{itemTemplate = "potion_component_03", weight = 400000},
		{itemTemplate = "purple_potion", weight = 400000},
		{itemTemplate = "red_potion", weight = 400000},
		{itemTemplate = "sacrificial_knife", weight = 400000},
		{itemTemplate = "sayormi_heart", weight = 400000},
		{itemTemplate = "sayormi_silk", weight = 400000},
		{itemTemplate = "sayormi_spirits", weight = 400000},
		{itemTemplate = "scarecrow_toy", weight = 400000},
		{itemTemplate = "voodoo_bag", weight = 400000},
		{itemTemplate = "white_potion", weight = 400000},
		{itemTemplate = "ep3_loot_lifeblood", weight = 400000},
		{itemTemplate = "ep3_loot_strike", weight = 400000},
	}
}

addLootGroupTemplate("sayormi_warrior", sayormi_warrior)
