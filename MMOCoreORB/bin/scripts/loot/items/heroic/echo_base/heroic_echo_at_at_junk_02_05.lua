-- Live master_item key heroic_echo_at_at_junk_02_05 (master_item.tab:5858).
-- string_name "AT-AT seam sealant". template_name is
-- object/tangible/loot/creature_loot/generic/heroic_echo_at_at_junk_05.iff
-- (the 02 skew is real). SD3 addTemplate registers
-- object/tangible/loot/creature/loot/generic/heroic_echo_at_at_junk_05.iff.

heroic_echo_at_at_junk_02_05 = {
	minimumLevel = 0,
	maximumLevel = -1,
	customObjectName = "AT-AT seam sealant",
	directObjectTemplate = "object/tangible/loot/creature/loot/generic/heroic_echo_at_at_junk_05.iff",
	craftingValues = {},
	customizationStringNames = {},
	customizationValues = {}
}

addLootItemTemplate("heroic_echo_at_at_junk_02_05", heroic_echo_at_at_junk_02_05)
