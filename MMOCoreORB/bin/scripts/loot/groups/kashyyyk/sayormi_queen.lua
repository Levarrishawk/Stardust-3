-- Transcribes datatables/loot/loot_types/kashyyyk/sayormi_queen.tab
-- strItems lists: kashyyyk/sayormi_queen
-- OURS: equal weights (SOE gives no per-item weights in these tables). Sum 10000000.
-- ruling 2026-09-04: ensure kashyyyk is done in full.
sayormi_queen = {
	description = "",
	minimumLevel = 0,
	maximumLevel = -1,
	lootItems = {
		{itemTemplate = "archaic_sayormi_blade", weight = 416667},
		{itemTemplate = "black_potion", weight = 416667},
		{itemTemplate = "corrupted_fruit", weight = 416667},
		{itemTemplate = "glow_stick", weight = 416667},
		{itemTemplate = "mystical_scroll", weight = 416667},
		{itemTemplate = "mystical_tome", weight = 416667},
		{itemTemplate = "mystical_tome_01", weight = 416667},
		{itemTemplate = "mystical_tome_02", weight = 416667},
		{itemTemplate = "mystical_tome_03", weight = 416667},
		{itemTemplate = "mystical_tome_04", weight = 416667},
		{itemTemplate = "orange_potion", weight = 416667},
		{itemTemplate = "potion_component_01", weight = 416667},
		{itemTemplate = "potion_component_02", weight = 416667},
		{itemTemplate = "potion_component_03", weight = 416667},
		{itemTemplate = "purple_potion", weight = 416667},
		{itemTemplate = "red_potion", weight = 416667},
		{itemTemplate = "sacrificial_knife", weight = 416666},
		{itemTemplate = "sayormi_heart", weight = 416666},
		{itemTemplate = "sayormi_silk", weight = 416666},
		{itemTemplate = "sayormi_spirits", weight = 416666},
		{itemTemplate = "scarecrow_toy", weight = 416666},
		{itemTemplate = "voodoo_bag", weight = 416666},
		{itemTemplate = "white_potion", weight = 416666},
		{itemTemplate = "ep3_loot_soulstinger", weight = 416666},
	}
}

addLootGroupTemplate("sayormi_queen", sayormi_queen)
