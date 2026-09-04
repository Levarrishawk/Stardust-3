-- Live master_item key heroic_echo_wampa_junk_02_02 (master_item.tab:5869).
-- string_name "Tauntaun skull and bones". template_name is
-- object/tangible/loot/creature_loot/generic/heroic_echo_wampa_junk_02.iff
-- (the 02 skew is real). SD3 addTemplate registers
-- object/tangible/loot/creature/loot/generic/heroic_echo_wampa_junk_02.iff.

heroic_echo_wampa_junk_02_02 = {
	minimumLevel = 0,
	maximumLevel = -1,
	customObjectName = "Tauntaun skull and bones",
	directObjectTemplate = "object/tangible/loot/creature/loot/generic/heroic_echo_wampa_junk_02.iff",
	craftingValues = {},
	customizationStringNames = {},
	customizationValues = {}
}

addLootItemTemplate("heroic_echo_wampa_junk_02_02", heroic_echo_wampa_junk_02_02)
