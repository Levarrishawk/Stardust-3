--[[ som_orf_beetle_hatchling -- Old Republic Facility beetle.
     Retail creatures.tab: BaseLevel 84, difficultyClass NORMAL,
     socialGroup orf_beetle, template som/kubaza_beetle.iff,
     lootTable mustafar/mustafar_lava_beetle.
     Placed on STD 70: retail difficultyClass NORMAL maps to the STD 70 row.
     Retail BaseLevel 84 is recorded here and NOT copied into level.
     Copied from kubaza_beetle.lua. controlDeviceTemplate deleted and
     tamingChance set to 0 -- dungeon spawn, not a tameable pet. Shared
     appearance object/mobile/som/kubaza_beetle.iff -- the tree ships no
     separate worker/soldier art (kubaza_beetle, kubaza_worker_beetle and
     kubaza_soldier_beetle already share this one). mobType/diet CARNIVORE
     to match retail niche=carnivore. ]]
som_orf_beetle_hatchling = Creature:new {
	customName = "an ORF beetle hatchling",
	socialGroup = "orf_beetle",
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
	resists = {5,5,5,30,-1,30,-1,-1,-1},
	meatType = "meat_insect",
	meatAmount = 21,
	hideType = "hide_scaley",
	hideAmount = 28,
	boneType = "",
	boneAmount = 0,
	milk = 0,
	tamingChance = 0,
	ferocity = 0,
	pvpBitmask = ATTACKABLE,
	creatureBitmask = PACK + STALKER,
	optionsBitmask = AIENABLED,
	diet = CARNIVORE,

	templates = {"object/mobile/som/kubaza_beetle.iff"},
	lootGroups = {},
	primaryWeapon = "unarmed",
	secondaryWeapon = "none",
	conversationTemplate = "",
	primaryAttacks = { {"creatureareaattack",""} },
	secondaryAttacks = { }
}

CreatureTemplates:addCreatureTemplate(som_orf_beetle_hatchling, "som_orf_beetle_hatchling")