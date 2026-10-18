-- loot/items/npc_loot/heroic_destroyer_reactor_console.lua
-- SOURCED: master_item.tab -- "Star Destroyer Reactor Console" (SOE "solar console"), a plain tangible quest/collection part.
-- OURS, NOT SOURCED: nothing.
-- directObjectTemplate deliberately uses SD3's MANGLED registration string npc/loot (the tree registers
-- object/custom_content/tangible/loot/npc_loot/*.lua under object/tangible/loot/npc/loot/*.iff -- board item X-1,
-- underscore->slash directory mangling, ~1,060 files). It resolves TODAY; when X-1 is fixed this string changes with it.
heroic_destroyer_reactor_console = {
	minimumLevel = 0, maximumLevel = 0, customObjectName = "",
	directObjectTemplate = "object/tangible/loot/npc/loot/heroic_destroyer_reactor_console.iff",
	craftingValues = {}, customizationStringNames = {}, customizationValues = {}
}
addLootItemTemplate("heroic_destroyer_reactor_console", heroic_destroyer_reactor_console)
