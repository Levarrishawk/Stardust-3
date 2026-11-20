-- loot/items/npc_loot/heroic_destroyer_cooling_coil.lua
-- SOURCED: master_item.tab -- "Star Destroyer Cooling Coil", a plain tangible quest/collection part.
-- OURS, NOT SOURCED: nothing.
-- directObjectTemplate deliberately uses SD3's MANGLED registration string npc/loot (the tree registers
-- object/custom_content/tangible/loot/npc_loot/*.lua under object/tangible/loot/npc/loot/*.iff -- board item X-1,
-- underscore->slash directory mangling, ~1,060 files). It resolves TODAY; when X-1 is fixed this string changes with it.
heroic_destroyer_cooling_coil = {
	minimumLevel = 0, maximumLevel = 0, customObjectName = "",
	directObjectTemplate = "object/tangible/loot/npc/loot/heroic_destroyer_cooling_coil.iff",
	craftingValues = {}, customizationStringNames = {}, customizationValues = {}
}
addLootItemTemplate("heroic_destroyer_cooling_coil", heroic_destroyer_cooling_coil)
