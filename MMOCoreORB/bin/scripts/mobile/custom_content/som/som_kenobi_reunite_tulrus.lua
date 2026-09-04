-- Quest-spawn variant of the Mustafar tulrus; name matches the sibling
-- template mobile/custom_content/som/tulrus.lua.
som_kenobi_reunite_tulrus = Creature:new {
	customName = "a Tulrus",
	socialGroup = "tulrus",
	faction = "",
	mobType = MOB_HERBIVORE,
	level = 70,
	chanceHit = 0.65,
	damageMin = 430,
	damageMax = 570,
	baseXp = 6747,
	baseHAM = 12000,
	baseHAMmax = 15000,
	armor = 1,
	resists = {5,5,5,30,-1,30,-1,-1,-1},
	meatType = "meat_herbivore",
	meatAmount = 300,
	hideType = "hide_leathery",
	hideAmount = 200,
	boneType = "bone_mammal",
	boneAmount = 150,
	milk = 0,
	tamingChance = 0,
	ferocity = 0,
	pvpBitmask = AGGRESSIVE + ATTACKABLE + ENEMY,
	creatureBitmask = PACK + STALKER,
	optionsBitmask = AIENABLED,
	diet = HERBIVORE,

	templates = {"object/mobile/som/som_kenobi_reunite_tulrus.iff"},
	lootGroups = {},

	-- Primary and secondary weapon should be different types (rifle/carbine, carbine/pistol, rifle/unarmed, etc)
	-- Unarmed should be put on secondary unless the mobile doesn't use weapons, in which case "unarmed" should be put primary and "none" as secondary
	primaryWeapon = "unarmed",
	secondaryWeapon = "none",
	conversationTemplate = "",

	-- primaryAttacks and secondaryAttacks should be separate skill groups specific to the weapon type listed in primaryWeapon and secondaryWeapon
	-- Use merge() to merge groups in creatureskills.lua together. If a weapon is set to "none", set the attacks variable to empty brackets
	primaryAttacks = { {"stunattack",""}, {"intimidationattack",""} },
	secondaryAttacks = { }
}

CreatureTemplates:addCreatureTemplate(som_kenobi_reunite_tulrus, "som_kenobi_reunite_tulrus")
