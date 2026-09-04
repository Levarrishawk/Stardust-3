-- echo_base_wampa_berserker -- berzerker corpse table.
--
-- SOURCED (SOE, datatables/loot/loot_types/heroic/heroic.tab col 16
-- echo_base_wampa_berserker): dungeon/heroic_drops:echo_base_wampa_berserker
-- (heroic_drops.tab col 16 = st_cn_hoth_wampa) plus
-- dungeon/heroic_drops:echo_base_wampa_junk x6. SOE repetition = weighting.
-- Folded into one Core3 group: 1 token part + 6 junk-group parts = 7 parts.
-- Each junk item is 1/4 of the junk group, so token:each_junk = 1:(6/4) = 2:3.
-- 10 000 000 does not divide by 7; remainder is put on the token
-- (1 428 572 + 4 x 2 142 857 = 10 000 000).

echo_base_wampa_berserker = {
	description = "",
	minimumLevel = 0,
	maximumLevel = -1,
	lootItems = {
		{itemTemplate = "st_cn_hoth_wampa", weight = 1428572},
		{itemTemplate = "heroic_echo_wampa_junk_02_01", weight = 2142857},
		{itemTemplate = "heroic_echo_wampa_junk_02_02", weight = 2142857},
		{itemTemplate = "heroic_echo_wampa_junk_02_03", weight = 2142857},
		{itemTemplate = "heroic_echo_wampa_junk_02_04", weight = 2142857},
	}
}

addLootGroupTemplate("echo_base_wampa_berserker", echo_base_wampa_berserker)
