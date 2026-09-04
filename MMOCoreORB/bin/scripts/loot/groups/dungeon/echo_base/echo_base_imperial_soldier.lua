-- echo_base_imperial_soldier -- Imperial corpse table.
--
-- SOURCED (SOE, datatables/loot/loot_types/heroic/heroic.tab col 19
-- echo_base_imperial_soldier): dungeon/heroic_drops:echo_base_imperial_soldier x2
-- (heroic_drops.tab col 19 = st_cn_hoth_imperial_snowtrooper) plus
-- dungeon/heroic_drops:echo_base_generic_soldier x3 plus
-- dungeon/heroic_drops:echo_base_soldier_junk x4. SOE repetition = weighting.
-- 9 parts. 10 000 000 / 9 does not divide evenly; remainder on junk
-- (2 222 222 + 3 333 333 + 4 444 445 = 10 000 000).

echo_base_imperial_soldier = {
	description = "",
	minimumLevel = 0,
	maximumLevel = -1,
	lootItems = {
		{itemTemplate = "st_cn_hoth_imperial_snowtrooper", weight = 2222222},
		{groupTemplate = "echo_base_generic_soldier", weight = 3333333},
		{groupTemplate = "echo_base_soldier_junk", weight = 4444445},
	}
}

addLootGroupTemplate("echo_base_imperial_soldier", echo_base_imperial_soldier)
