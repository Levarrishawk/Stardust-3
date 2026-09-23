-- ig88_heroic_drops -- IG-88 heroic corpse table.
--
-- SOURCED (SOE, datatables/loot/loot_types/heroic/heroic.tab column ig88):
-- three rolls of dungeon/heroic_drops:ig88 plus one roll of
-- crafting_loot/weapon_components:wp_comp_heroic. Those four hops are folded
-- into this one group (OURS, NOT SOURCED -- Core3 has one lootGroups list per
-- mobile, not SOE's column-as-loot-type tables). The boss rolls this group
-- three times, matching hop 1's three heroic_drops cells; the component slot
-- is in the same group so it can drop on those rolls.
--
-- Weights: SOE heroic_drops.tab repetition counts transcribed (x2 = double
-- weight). The six wp_comp_heroic components have no repetition listed in
-- that tab; each is treated as x1. Ratio head:ring:component = 2:2:1.
-- Normalisation OURS to Core3's 10 000 000 sum (16 parts: head x2 + 4 rings
-- x2 + 6 components x1 = 2+8+6). 10 000 000 / 16 = 625 000 exactly; x2 items
-- weigh 1 250 000, x1 items weigh 625 000.
--
-- H(ig) fix-4 (2026-09-04): the X-1 registration fix landed (npc_loot / loot_schematic strings corrected, generic_limited_use
-- added), so every SOE cell below is now a real loot item: 15 dungeon cells (head x2, saber x2, rings x2 each, ice gun,
-- sm_generator, wall_lamp) + the six wp_comp_heroic components (slot 4) = 21 parts, OURS normalisation to 10,000,000.
-- The list below is kept as the record of what WAS unobtainable before the fix:
--   object/tangible/loot/loot/schematic/generic_limited_use_flashy.iff
--     BROKEN -- addTemplate rewrote loot_schematic -> loot/schematic
--     (object/custom_content/tangible/loot/loot_schematic/generic_limited_use_flashy.lua).
--     SOE's saber schematic container.
--   object/draft_schematic/weapon/lightsaber_polearm_gen4_heroic.iff
--     wrapper template (generic_limited_use / _flashy) mangled or absent on SD3; a bare draft
--     schematic is not a lootable item -- waits on the addTemplate-path fix (board X-1).
--   object/tangible/loot/npc/loot/heroic_sm_generator.iff
--     BROKEN -- addTemplate rewrote npc_loot -> npc/loot
--     (object/custom_content/tangible/loot/npc_loot/heroic_sm_generator.lua).
--   object/tangible/loot/npc/loot/heroic_wall_lamp.iff
--     BROKEN -- addTemplate rewrote npc_loot -> npc/loot
--     (object/custom_content/tangible/loot/npc_loot/heroic_wall_lamp.lua).
--   object/tangible/loot/loot_schematic/generic_limited_use.iff
--     NOT PRESENT -- no generic_limited_use.lua on SD3. SOE's ice-gun
--     schematic container.
--   object/draft_schematic/weapon/appearance/weapon_appearance_heavy_carbonite_rifle.iff
--     wrapper template (generic_limited_use / _flashy) mangled or absent on SD3; a bare draft
--     schematic is not a lootable item -- waits on the addTemplate-path fix (board X-1).

ig88_heroic_drops = {
	description = "",
	minimumLevel = 0,
	maximumLevel = -1,
	lootItems = {
		{itemTemplate = "item_heroic_ig_88_head_01_01", weight = 952380},
		{itemTemplate = "item_heroic_schematic_saber_03_01", weight = 952380},
		{itemTemplate = "item_heroic_random_ring_01_01", weight = 952380},
		{itemTemplate = "item_heroic_random_ring_01_02", weight = 952380},
		{itemTemplate = "item_heroic_random_ring_01_03", weight = 952380},
		{itemTemplate = "item_heroic_random_ring_01_04", weight = 952380},
		{itemTemplate = "item_limited_use_schematic_commando_ice_gun_04_01", weight = 476190},
		{itemTemplate = "item_heroic_ig88_sm_generator", weight = 476190},
		{itemTemplate = "item_heroic_ig88_wall_lamp", weight = 476190},
		{itemTemplate = "wp_comp_heroic_enhancement_melee_slot_one_s09", weight = 476190},
		{itemTemplate = "wp_comp_heroic_enhancement_melee_slot_two_s09", weight = 476190},
		{itemTemplate = "wp_comp_heroic_enhancement_ranged_slot_one_s09", weight = 476190},
		{itemTemplate = "wp_comp_heroic_enhancement_ranged_slot_two_s09", weight = 476190},
		{itemTemplate = "wp_comp_heroic_enhancement_melee_slot_one_s18", weight = 476190},
		{itemTemplate = "wp_comp_heroic_enhancement_ranged_slot_one_s18", weight = 476200},
	}
}

addLootGroupTemplate("ig88_heroic_drops", ig88_heroic_drops)
