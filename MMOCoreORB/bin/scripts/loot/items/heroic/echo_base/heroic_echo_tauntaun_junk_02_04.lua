-- Live master_item key heroic_echo_tauntaun_junk_02_04 (master_item.tab:5867).
-- string_name "a ruptured Tauntaun stomach". template_name is
-- object/tangible/loot/creature_loot/generic/heroic_echo_tauntaun_junk_04.iff
-- (the 02 skew is real). SD3 addTemplate registers
-- object/tangible/loot/creature/loot/generic/heroic_echo_tauntaun_junk_04.iff.

heroic_echo_tauntaun_junk_02_04 = {
	minimumLevel = 0,
	maximumLevel = -1,
	customObjectName = "a ruptured Tauntaun stomach",
	directObjectTemplate = "object/tangible/loot/creature/loot/generic/heroic_echo_tauntaun_junk_04.iff",
	craftingValues = {},
	customizationStringNames = {},
	customizationValues = {}
}

addLootItemTemplate("heroic_echo_tauntaun_junk_02_04", heroic_echo_tauntaun_junk_02_04)
