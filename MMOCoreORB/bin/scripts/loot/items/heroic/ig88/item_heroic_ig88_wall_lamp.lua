-- Live master_item key item_heroic_ig88_wall_lamp (master_item.tab:8268).
-- Named by loot group ig88_heroic_drops. Obtainable since the X-1 registration fix (H(ig) fix-4, 2026-09-04).
-- customObjectName empty: the template carries its own name; SOE master_item has no display override for this prop.
item_heroic_ig88_wall_lamp = {
	minimumLevel = 0,
	maximumLevel = -1,
	customObjectName = "",
	directObjectTemplate = "object/tangible/loot/npc_loot/heroic_wall_lamp.iff",
	craftingValues = {},
	customizationStringNames = {},
	customizationValues = {}
}

addLootItemTemplate("item_heroic_ig88_wall_lamp", item_heroic_ig88_wall_lamp)
