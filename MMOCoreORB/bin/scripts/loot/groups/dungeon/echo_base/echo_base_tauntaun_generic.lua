-- echo_base_tauntaun_generic -- tauntaun corpse table.
--
-- SOURCED (SOE, datatables/loot/loot_types/heroic/heroic.tab col 14
-- echo_base_tauntaun_generic): dungeon/heroic_drops:echo_base_tauntaun_junk.
-- Nested groupTemplate, sum 10 000 000.

echo_base_tauntaun_generic = {
	description = "",
	minimumLevel = 0,
	maximumLevel = -1,
	lootItems = {
		{groupTemplate = "echo_base_tauntaun_junk", weight = 10000000},
	}
}

addLootGroupTemplate("echo_base_tauntaun_generic", echo_base_tauntaun_generic)
