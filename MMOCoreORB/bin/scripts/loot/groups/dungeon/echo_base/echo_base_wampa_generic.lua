-- echo_base_wampa_generic -- wampa trash junk hop.
--
-- SOURCED (SOE, datatables/loot/loot_types/heroic/heroic.tab col 15
-- echo_base_wampa_generic): dungeon/heroic_drops:echo_base_wampa_junk.
-- heroic_drops.tab col 14 echo_base_wampa_junk lists
-- heroic_echo_wampa_junk_02_01..04 once each. Equal weight, sum 10 000 000.

echo_base_wampa_generic = {
	description = "",
	minimumLevel = 0,
	maximumLevel = -1,
	lootItems = {
		{itemTemplate = "heroic_echo_wampa_junk_02_01", weight = 2500000},
		{itemTemplate = "heroic_echo_wampa_junk_02_02", weight = 2500000},
		{itemTemplate = "heroic_echo_wampa_junk_02_03", weight = 2500000},
		{itemTemplate = "heroic_echo_wampa_junk_02_04", weight = 2500000},
	}
}

addLootGroupTemplate("echo_base_wampa_generic", echo_base_wampa_generic)
