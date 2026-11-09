-- Source: DSRC datatables/ship/shiptype.tab (Stella Bellum / Cekis).
object_ship_blacksun_heavy_s01_npe = object_ship_shared_blacksun_heavy_s01_npe:new {
	name = "blacksun_heavy_npe",
	type = "blacksun_heavy_s01_npe",
	faction = "blacksun",
	difficulty = "tier1",

	slideFactor = 1.77,
	chassisHitpoints = 144,
	chassisMass = 5000,
	gameObjectType = 536870919,

	reactor = {name = "rct_generic", hitpoints = 180, armor = 180},
	engine = {name = "eng_incom_fusialthrust", hitpoints = 180, armor = 180, speed = 42, acceleration = 10.2, deceleration = 8.7, yaw = 18.3, yawRate = 38.4, pitch = 23.1, pitchRate = 46.2, roll = 28.6, rollRate = 52.1},
	shield_0 = {name = "shd_generic", hitpoints = 100, armor = 100, front = 300, back = 300, regen = 3.3},
	armor_0 = {name = "arm_generic", hitpoints = 150, armor = 150},
	armor_1 = {name = "arm_generic", hitpoints = 150, armor = 150},
	capacitor = {name = "cap_generic", hitpoints = 180, armor = 180, energy = 5000, rechargeRate = 100},
	weapon_0 = {name = "wpn_incom_disruptor", hitpoints = 180, armor = 180, rate = 0.78, drain = 1, maxDamage = 48, minDamage = 36, shieldEfficiency = 0.56, armorEfficiency = 0.56},
	weapon_1 = {name = "wpn_incom_disruptor", hitpoints = 180, armor = 180, rate = 0.78, drain = 1, maxDamage = 48, minDamage = 36, shieldEfficiency = 0.56, armorEfficiency = 0.56},
	weapon_3 = {name = "wpn_seinar_concussion_missile_s01", hitpoints = 180, armor = 180, rate = 3, drain = 1, maxDamage = 144, minDamage = 72, shieldEfficiency = 0.75, armorEfficiency = 0.75, ammo = 5, ammo_type = 16},
}

ObjectTemplates:addTemplate(object_ship_blacksun_heavy_s01_npe, "object/ship/blacksun_heavy_s01_npe.iff")
