-- Live master_item key heroic_echo_at_at_junk_02_01 (master_item.tab:5854).
-- string_name "an ammunition crate". template_name is
-- object/tangible/loot/creature_loot/generic/heroic_echo_at_at_junk_01.iff
-- (the 02 skew is real). SD3 addTemplate registers
-- object/tangible/loot/creature/loot/generic/heroic_echo_at_at_junk_01.iff.

heroic_echo_at_at_junk_02_01 = {
	minimumLevel = 0,
	maximumLevel = -1,
	customObjectName = "an ammunition crate",
	directObjectTemplate = "object/tangible/loot/creature/loot/generic/heroic_echo_at_at_junk_01.iff",
	craftingValues = {},
	customizationStringNames = {},
	customizationValues = {}
}

addLootItemTemplate("heroic_echo_at_at_junk_02_01", heroic_echo_at_at_junk_02_01)
