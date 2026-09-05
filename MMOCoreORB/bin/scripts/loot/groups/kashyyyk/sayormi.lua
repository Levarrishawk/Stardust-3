-- Transcribes datatables/loot/loot_types/kashyyyk/sayormi.tab
-- strItems lists: kashyyyk/sayormi
-- OURS: equal weights (SOE gives no per-item weights in these tables). Sum 10000000.
-- ruling 2026-09-04: ensure kashyyyk is done in full.
sayormi = {
	description = "",
	minimumLevel = 0,
	maximumLevel = -1,
	lootItems = {
		{itemTemplate = "archaic_sayormi_blade", weight = 434783},
		{itemTemplate = "black_potion", weight = 434783},
		{itemTemplate = "corrupted_fruit", weight = 434783},
		{itemTemplate = "glow_stick", weight = 434783},
		{itemTemplate = "mystical_scroll", weight = 434783},
		{itemTemplate = "mystical_tome", weight = 434783},
		{itemTemplate = "mystical_tome_01", weight = 434783},
		{itemTemplate = "mystical_tome_02", weight = 434783},
		{itemTemplate = "mystical_tome_03", weight = 434783},
		{itemTemplate = "mystical_tome_04", weight = 434783},
		{itemTemplate = "orange_potion", weight = 434783},
		{itemTemplate = "potion_component_01", weight = 434783},
		{itemTemplate = "potion_component_02", weight = 434783},
		{itemTemplate = "potion_component_03", weight = 434783},
		{itemTemplate = "purple_potion", weight = 434782},
		{itemTemplate = "red_potion", weight = 434782},
		{itemTemplate = "sacrificial_knife", weight = 434782},
		{itemTemplate = "sayormi_heart", weight = 434782},
		{itemTemplate = "sayormi_silk", weight = 434782},
		{itemTemplate = "sayormi_spirits", weight = 434782},
		{itemTemplate = "scarecrow_toy", weight = 434782},
		{itemTemplate = "voodoo_bag", weight = 434782},
		{itemTemplate = "white_potion", weight = 434782},
	}
}

addLootGroupTemplate("sayormi", sayormi)
