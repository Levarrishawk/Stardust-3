incom_technician = imperial_scientist:new {
	customName = "an Incom Technician",
	randomNameTag = false,
	socialGroup = "imperial",
	faction = "imperial",
	level = 50,
	chanceHit = 0.5,
	damageMin = 250,
	damageMax = 350,
	baseXp = 5000,
	baseHAM = 9000,
	baseHAMmax = 11000,
	pvpBitmask = ATTACKABLE,
	creatureBitmask = PACK,
	optionsBitmask = AIENABLED,
	primaryWeapon = "imperial_pistol",
	secondaryWeapon = "unarmed",
	primaryAttacks = marksmanmaster,
	secondaryAttacks = brawlernovice,
}

CreatureTemplates:addCreatureTemplate(incom_technician, "incom_technician")
