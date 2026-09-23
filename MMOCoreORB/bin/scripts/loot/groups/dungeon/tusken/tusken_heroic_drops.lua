-- tusken_heroic_drops -- Tusken Army heroic corpse table.
--
-- SOURCED (SOE, datatables/loot/loot_types/heroic/heroic.tab column tusken):
-- slots 1-3 dungeon/heroic_drops:tusken plus slot 4
-- crafting_loot/weapon_components:wp_comp_heroic. Those four hops are folded
-- into this one group (OURS, NOT SOURCED -- Core3 has one lootGroups list per
-- mobile, not SOE's column-as-loot-type tables).
--
-- Weights: SOE heroic_drops.tab repetition counts transcribed (x4, x2, x1).
-- The six wp_comp_heroic components have no repetition listed in that tab;
-- each is treated as x1. Normalisation OURS to Core3's 10 000 000 sum (29 parts:
-- 23 from heroic_drops:tusken + 6 from wp_comp_heroic).
-- Rep 4 items weigh 1 379 310 each (2 items = 2 758 620).
-- Rep 2 items weigh 689 655 each (5 items = 3 448 275).
-- Rep 1 items weigh 344 828 (8 items: 6 components + 2 drops = 2 758 624)
-- and 344 827 (3 drops = 1 034 481).
-- Sum = 2 758 620 + 3 448 275 + 2 758 624 + 1 034 481 = 10 000 000 exactly.

tusken_heroic_drops = {
	description = "",
	minimumLevel = 0,
	maximumLevel = -1,
	lootItems = {
		{itemTemplate = "item_heroic_schematic_elite_gaffi_stick_01_01", weight = 689655},
		{itemTemplate = "item_heroic_schematic_elite_tusken_rifle_01_01", weight = 689655},
		{itemTemplate = "item_heroic_schematic_backpack_krayt_skull_01_01", weight = 689655},
		{itemTemplate = "item_heroic_random_ring_01_01", weight = 1379310},
		{itemTemplate = "item_heroic_random_ring_01_02", weight = 1379310},
		{itemTemplate = "item_heroic_random_ring_01_03", weight = 689655},
		{itemTemplate = "item_heroic_random_ring_01_04", weight = 689655},
		{itemTemplate = "item_limited_use_schematic_commando_ice_gun_04_01", weight = 344828},
		{itemTemplate = "item_heroic_tusken_meat_rack", weight = 344828},
		{itemTemplate = "item_heroic_tusken_shelves", weight = 344827},
		{itemTemplate = "item_heroic_tusken_stairs", weight = 344827},
		{itemTemplate = "item_heroic_tusken_vent_pillar", weight = 344827},
		{itemTemplate = "wp_comp_heroic_enhancement_melee_slot_one_s09", weight = 344828},
		{itemTemplate = "wp_comp_heroic_enhancement_melee_slot_two_s09", weight = 344828},
		{itemTemplate = "wp_comp_heroic_enhancement_ranged_slot_one_s09", weight = 344828},
		{itemTemplate = "wp_comp_heroic_enhancement_ranged_slot_two_s09", weight = 344828},
		{itemTemplate = "wp_comp_heroic_enhancement_melee_slot_one_s18", weight = 344828},
		{itemTemplate = "wp_comp_heroic_enhancement_ranged_slot_one_s18", weight = 344828},
	}
}

addLootGroupTemplate("tusken_heroic_drops", tusken_heroic_drops)
