-- Live master_item key cube_loot_2s.
-- Named by loot group storm_lord_drop.
-- Split path cube/loot is deliberate; see cube_loot_3r.lua.
cube_loot_2s = {
	minimumLevel = 0,
	maximumLevel = -1,
	customObjectName = "",
	directObjectTemplate = "object/tangible/loot/mustafar/cube/loot/cube_loot_2s.iff",
	craftingValues = {},
	customizationStringNames = {},
	customizationValues = {}
}

addLootItemTemplate("cube_loot_2s", cube_loot_2s)
