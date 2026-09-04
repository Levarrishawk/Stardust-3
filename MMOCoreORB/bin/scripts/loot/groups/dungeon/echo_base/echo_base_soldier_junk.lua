-- echo_base_soldier_junk -- soldier junk hop.
--
-- SOURCED (SOE, datatables/loot/loot_items/dungeon/heroic_drops.tab col 13
-- echo_base_soldier_junk): heroic_echo_at_at_junk_02_01..05 and
-- heroic_echo_snow_speeder_junk_02_01..05 once each. Equal weight, sum 10 000 000.

echo_base_soldier_junk = {
	description = "",
	minimumLevel = 0,
	maximumLevel = -1,
	lootItems = {
		{itemTemplate = "heroic_echo_at_at_junk_02_01", weight = 1000000},
		{itemTemplate = "heroic_echo_at_at_junk_02_02", weight = 1000000},
		{itemTemplate = "heroic_echo_at_at_junk_02_03", weight = 1000000},
		{itemTemplate = "heroic_echo_at_at_junk_02_04", weight = 1000000},
		{itemTemplate = "heroic_echo_at_at_junk_02_05", weight = 1000000},
		{itemTemplate = "heroic_echo_snow_speeder_junk_02_01", weight = 1000000},
		{itemTemplate = "heroic_echo_snow_speeder_junk_02_02", weight = 1000000},
		{itemTemplate = "heroic_echo_snow_speeder_junk_02_03", weight = 1000000},
		{itemTemplate = "heroic_echo_snow_speeder_junk_02_04", weight = 1000000},
		{itemTemplate = "heroic_echo_snow_speeder_junk_02_05", weight = 1000000},
	}
}

addLootGroupTemplate("echo_base_soldier_junk", echo_base_soldier_junk)
