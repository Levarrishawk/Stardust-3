-- echo_base_wampa_boss -- Uncle Joe's required story-token hop.
--
-- SOURCED (SOE, datatables/loot/loot_types/heroic/echo_base_wampa_boss.tab):
-- strRequiredItems = st_cn_hoth_wampa, strItems =
-- dungeon/heroic_drops:echo_base_wampa_junk. Core3 cannot express "always drop
-- A AND also roll B" in one loot group, so the required hop is this group
-- (token at 10 000 000) and the items hop is a second 100% roll of
-- echo_base_wampa_generic on the boss mobile. Together they are D-EBe4's
-- "guaranteed st_cn_hoth_wampa + echo_base_wampa_junk".

echo_base_wampa_boss = {
	description = "",
	minimumLevel = 0,
	maximumLevel = -1,
	lootItems = {
		{itemTemplate = "st_cn_hoth_wampa", weight = 10000000},
	}
}

addLootGroupTemplate("echo_base_wampa_boss", echo_base_wampa_boss)
