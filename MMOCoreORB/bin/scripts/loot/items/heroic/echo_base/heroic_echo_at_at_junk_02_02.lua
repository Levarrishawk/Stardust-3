-- Live master_item key heroic_echo_at_at_junk_02_02 (master_item.tab:5855).
-- string_name "an Imperial ration kit". template_name is
-- object/tangible/loot/creature_loot/generic/heroic_echo_at_at_junk_02.iff
-- (the 02 skew is real). SD3 addTemplate registers
-- object/tangible/loot/creature/loot/generic/heroic_echo_at_at_junk_02.iff.

heroic_echo_at_at_junk_02_02 = {
	minimumLevel = 0,
	maximumLevel = -1,
	customObjectName = "an Imperial ration kit",
	directObjectTemplate = "object/tangible/loot/creature/loot/generic/heroic_echo_at_at_junk_02.iff",
	craftingValues = {},
	customizationStringNames = {},
	customizationValues = {}
}

addLootItemTemplate("heroic_echo_at_at_junk_02_02", heroic_echo_at_at_junk_02_02)
