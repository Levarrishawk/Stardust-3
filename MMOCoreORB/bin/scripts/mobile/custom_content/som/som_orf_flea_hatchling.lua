--[[ som_orf_flea_hatchling -- Old Republic Facility flea.
     Retail creatures.tab: BaseLevel 83, difficultyClass NORMAL,
     socialGroup orf_flea, template som/lava_flea.iff,
     lootTable mustafar/mustafar_lava_flea.
     Placed on STD 70: retail difficultyClass NORMAL maps to the STD 70 row.
     Retail BaseLevel 83 is recorded here and NOT copied into level.
     Copied from lava_flea.lua. controlDeviceTemplate deleted and tamingChance
     set to 0 -- dungeon spawn, not a tameable pet. scale 0.3 is retail
     minScale=maxScale (life-stage split). mobType/diet CARNIVORE to match
     retail niche=carnivore. ]]
som_orf_flea_hatchling = Creature:new {
	customName = "an ORF flea hatchling",
	socialGroup = "orf_flea",
	faction = "",
	mobType = MOB_CARNIVORE,
	level = 70,
	chanceHit = 0.65,
	damageMin = 430,
	damageMax = 570,
	baseXp = 6747,
	baseHAM = 12000,
	baseHAMmax = 15000,
	armor = 1,
	scale = 0.3,
	resists = {130,130,-1,160,160,160,-1,-1,-1},
	meatType = "meat_insect",
	meatAmount = 20,
	hideType = "hide_scaley",
	hideAmount = 29,
	boneType = "",
	boneAmount = 0,
	milk = 0,
	tamingChance = 0,
	ferocity = 0,
	pvpBitmask = ATTACKABLE,
	creatureBitmask = PACK + STALKER,
	optionsBitmask = AIENABLED,
	diet = CARNIVORE,

	templates = {"object/mobile/som/lava_flea.iff"},
	lootGroups = {},
	primaryWeapon = "unarmed",
	secondaryWeapon = "none",
	conversationTemplate = "",
	primaryAttacks = { {"creatureareaattack",""} },
	secondaryAttacks = { }
}

CreatureTemplates:addCreatureTemplate(som_orf_flea_hatchling, "som_orf_flea_hatchling")