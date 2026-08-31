storm_lord_touched = Creature:new {
	customName = "a storm lord zealot",
	socialGroup = "storm_lord",
	faction = "",
	mobType = MOB_NPC,
	level = 83,
	chanceHit = 0.27,
	damageMin = 550,
	damageMax = 800,
	baseXp = 235,
	baseHAM = 16000,
	baseHAMmax = 19000,
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
	pvpBitmask = ATTACKABLE + AGGRESSIVE,
	creatureBitmask = PACK + STALKER,
	optionsBitmask = AIENABLED,
	diet = HERBIVORE,

	templates = {"object/mobile/som/storm_lord_touched.iff"},
	lootGroups = {
		{
			groups = {},
			lootChance = 2100000
		}
	},
	primaryWeapon = "imperial_sword",
	secondaryWeapon = "force_sword_ranged",
	conversationTemplate = "",
	primaryAttacks = merge(marksmannovice,brawlernovice),
	secondaryAttacks = { }
}

CreatureTemplates:addCreatureTemplate(storm_lord_touched, "storm_lord_touched")
