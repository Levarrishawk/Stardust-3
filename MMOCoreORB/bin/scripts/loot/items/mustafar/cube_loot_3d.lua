-- Live master_item key cube_loot_3d.
-- Named by loot group master_droid_loot.
-- Split path cube/loot is deliberate; see cube_loot_3r.lua.
cube_loot_3d = {
	minimumLevel = 0,
	maximumLevel = -1,
	customObjectName = "",
	directObjectTemplate = "object/tangible/loot/mustafar/cube/loot/cube_loot_3d.iff",
	craftingValues = {},
	customizationStringNames = {},
	customizationValues = {}
}

addLootItemTemplate("cube_loot_3d", cube_loot_3d)
