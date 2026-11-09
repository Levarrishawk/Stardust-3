-- Source: DSRC datatables/ship/shiptype.tab (Stella Bellum / Cekis).
object_ship_blacksun_light_s01_npe = object_ship_shared_blacksun_light_s01_npe:new {
	name = "blacksun_light_npe",
	type = "blacksun_light_s01_npe",
	faction = "blacksun",
	difficulty = "tier1",

	slideFactor = 1.87,
	chassisHitpoints = 120,
	chassisMass = 5000,
	gameObjectType = 536870919,

	reactor = {name = "rct_generic", hitpoints = 135, armor = 135},
	engine = {name = "eng_generic", hitpoints = 135, armor = 135, speed = 42, acceleration = 10.2, deceleration = 8.7, yaw = 18.3, yawRate = 38.4, pitch = 23.1, pitchRate = 46.2, roll = 28.6, rollRate = 52.1},
	shield_0 = {name = "shd_generic", hitpoints = 135, armor = 135, front = 275, back = 275, regen = 3.3},
	armor_0 = {name = "arm_generic", hitpoints = 100, armor = 100},
	armor_1 = {name = "arm_generic", hitpoints = 100, armor = 100},
	capacitor = {name = "cap_generic", hitpoints = 135, armor = 135, energy = 5000, rechargeRate = 100},
	weapon_0 = {name = "wpn_incom_disruptor", hitpoints = 135, armor = 135, rate = 0.78, drain = 1, maxDamage = 36, minDamage = 27, shieldEfficiency = 0.56, armorEfficiency = 0.56},
}

ObjectTemplates:addTemplate(object_ship_blacksun_light_s01_npe, "object/ship/blacksun_light_s01_npe.iff")
