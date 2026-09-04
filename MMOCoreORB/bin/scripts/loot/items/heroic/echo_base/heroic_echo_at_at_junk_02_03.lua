-- Live master_item key heroic_echo_at_at_junk_02_03 (master_item.tab:5856).
-- string_name "AT-AT movement control module". template_name is
-- object/tangible/loot/creature_loot/generic/heroic_echo_at_at_junk_03.iff
-- (the 02 skew is real). SD3 addTemplate registers
-- object/tangible/loot/creature/loot/generic/heroic_echo_at_at_junk_03.iff.

heroic_echo_at_at_junk_02_03 = {
	minimumLevel = 0,
	maximumLevel = -1,
	customObjectName = "AT-AT movement control module",
	directObjectTemplate = "object/tangible/loot/creature/loot/generic/heroic_echo_at_at_junk_03.iff",
	craftingValues = {},
	customizationStringNames = {},
	customizationValues = {}
}

addLootItemTemplate("heroic_echo_at_at_junk_02_03", heroic_echo_at_at_junk_02_03)
