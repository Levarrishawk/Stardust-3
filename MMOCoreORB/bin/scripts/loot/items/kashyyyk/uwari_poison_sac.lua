-- Transcribes datatables/loot/loot_items/kashyyyk/myyydril_deathswarm, uwari.tab (SOE strItemType).
-- Object template is in-tree. ruling 2026-09-04: ensure kashyyyk is done in full.
uwari_poison_sac = {
	minimumLevel = 0,
	maximumLevel = -1,
	customObjectName = "",
	directObjectTemplate = "object/tangible/loot/creature_loot/kashyyyk_loot/uwari_poison_sac.iff",
	craftingValues = {},
	customizationStringNames = {},
	customizationValues = {}
}

addLootItemTemplate("uwari_poison_sac", uwari_poison_sac)
