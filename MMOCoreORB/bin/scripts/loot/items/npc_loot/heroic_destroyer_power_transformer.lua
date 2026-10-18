-- loot/items/npc_loot/heroic_destroyer_power_transformer.lua
-- SOURCED: master_item.tab -- "Star Destroyer Power Transformer", a plain tangible quest/collection part.
-- OURS, NOT SOURCED: nothing.
-- directObjectTemplate deliberately uses SD3's MANGLED registration string npc/loot (the tree registers
-- object/custom_content/tangible/loot/npc_loot/*.lua under object/tangible/loot/npc/loot/*.iff -- board item X-1,
-- underscore->slash directory mangling, ~1,060 files). It resolves TODAY; when X-1 is fixed this string changes with it.
heroic_destroyer_power_transformer = {
	minimumLevel = 0, maximumLevel = 0, customObjectName = "",
	directObjectTemplate = "object/tangible/loot/npc/loot/heroic_destroyer_power_transformer.iff",
	craftingValues = {}, customizationStringNames = {}, customizationValues = {}
}
addLootItemTemplate("heroic_destroyer_power_transformer", heroic_destroyer_power_transformer)
