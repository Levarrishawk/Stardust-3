-- samaritan quest giver -- Ithorian geologist/ambassador.
-- Name from som_kenobi_samaritan.stf: "I am Pwwoz Pwwa, geologist and ambassador
--   for the Ithorian people on Mustafar".
-- NOT invulnerable: som_kenobi_samaritan_1.qst carries a killIthorian
-- Destroy Multiple task against this same template, so live had him attackable.
som_pwwoz_pwwa = Creature:new {
	customName = "Pwwoz Pwwa",
	socialGroup = "townsperson",
	faction = "",
	mobType = MOB_NPC,
	level = 45,
	chanceHit = 0.44,
	damageMin = 345,
	damageMax = 400,
	baseXp = 4461,
	baseHAM = 9300,
	baseHAMmax = 11300,
	armor = 0,
	resists = {0,0,0,0,0,0,0,-1,-1},
	meatType = "",
	meatAmount = 0,
	hideType = "",
	hideAmount = 0,
	boneType = "",
	boneAmount = 0,
	milk = 0,
	tamingChance = 0,
	ferocity = 0,
	pvpBitmask = ATTACKABLE,
	creatureBitmask = PACK,
	optionsBitmask = AIENABLED + CONVERSABLE + INTERESTING,
	diet = HERBIVORE,

	templates = {"object/mobile/som/som_pwwoz_pwwa.iff"},
	lootGroups = {},

	-- Primary and secondary weapon should be different types (rifle/carbine, carbine/pistol, rifle/unarmed, etc)
	-- Unarmed should be put on secondary unless the mobile doesn't use weapons, in which case "unarmed" should be put primary and "none" as secondary
	primaryWeapon = "unarmed",
	secondaryWeapon = "none",
	conversationTemplate = "som_kenobi_pwwoz_pwwa",

	-- primaryAttacks and secondaryAttacks should be separate skill groups specific to the weapon type listed in primaryWeapon and secondaryWeapon
	-- Use merge() to merge groups in creatureskills.lua together. If a weapon is set to "none", set the attacks variable to empty brackets
	primaryAttacks = { },
	secondaryAttacks = { }
}

CreatureTemplates:addCreatureTemplate(som_pwwoz_pwwa, "som_pwwoz_pwwa")
