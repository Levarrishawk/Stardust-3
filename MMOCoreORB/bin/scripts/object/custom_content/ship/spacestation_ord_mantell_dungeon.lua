-- Source: DSRC datatables/ship/shiptype.tab (Stella Bellum / Cekis).
object_ship_spacestation_ord_mantell_dungeon = object_ship_shared_spacestation_ord_mantell_dungeon:new {
	objectName = "@npe:ord_mantell_dungeon",
	name = "spacestation_ord_mantell_dungeon",
	type = "spacestation_ord_mantell_dungeon",
	faction = "civilian",
	difficulty = "",

	slideFactor = 1.76,
	chassisHitpoints = 30000,
	chassisMass = 50000,
	gameObjectType = 536870920,

	reactor = {name = "rct_generic", hitpoints = 5000, armor = 2000},
	shield_0 = {name = "shd_generic", hitpoints = 10000, armor = 3000, front = 6000, back = 6000, regen = 50},
	shield_1 = {name = "shd_generic", hitpoints = 5000, armor = 3000, front = 3000, back = 3000, regen = 40},
	armor_0 = {name = "arm_generic", hitpoints = 5000, armor = 5000},
	armor_1 = {name = "arm_generic", hitpoints = 5000, armor = 5000},
	capacitor = {name = "cap_generic", hitpoints = 5000, armor = 1000, energy = 2356.5, rechargeRate = 128.3},
	bridge = {name = "bdg_generic", hitpoints = 2000, armor = 2000},
	hangar = {name = "hgr_generic", hitpoints = 2000, armor = 2000},
	targeting_station = {name = "tst_generic", hitpoints = 2000, armor = 2000},
}

ObjectTemplates:addTemplate(object_ship_spacestation_ord_mantell_dungeon, "object/ship/spacestation_ord_mantell_dungeon.iff")
