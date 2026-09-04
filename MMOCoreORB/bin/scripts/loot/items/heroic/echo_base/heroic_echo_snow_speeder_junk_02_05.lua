-- Live master_item key heroic_echo_snow_speeder_junk_02_05 (master_item.tab:5863).
-- string_name "an empty crate". template_name is
-- object/tangible/loot/creature_loot/generic/heroic_echo_snow_speeder_junk_05.iff
-- (the 02 skew is real). SD3 addTemplate registers
-- object/tangible/loot/creature/loot/generic/heroic_echo_snow_speeder_junk_05.iff.

heroic_echo_snow_speeder_junk_02_05 = {
	minimumLevel = 0,
	maximumLevel = -1,
	customObjectName = "an empty crate",
	directObjectTemplate = "object/tangible/loot/creature/loot/generic/heroic_echo_snow_speeder_junk_05.iff",
	craftingValues = {},
	customizationStringNames = {},
	customizationValues = {}
}

addLootItemTemplate("heroic_echo_snow_speeder_junk_02_05", heroic_echo_snow_speeder_junk_02_05)
