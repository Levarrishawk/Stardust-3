storm_lord_prophet = Creature:new {
	customName = "Prophet of the Storm Lord",
	socialGroup = "storm_lord",
	faction = "",
	mobType = MOB_NPC,
	level = 87,
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
	creatureBitmask = PACK + STALKER + KILLER,
	optionsBitmask = AIENABLED,
	diet = HERBIVORE,

	templates = {"object/mobile/som/storm_lord_prophet.iff"},
	lootGroups = {
		{
			groups = {},
			lootChance = 2100000
		}
	},
	primaryWeapon = "jedi_dark",
	secondaryWeapon = "unarmed",
	conversationTemplate = "",
	primaryAttacks = merge(marksmannovice,brawlernovice),
	secondaryAttacks = { }
}

CreatureTemplates:addCreatureTemplate(storm_lord_prophet, "storm_lord_prophet")
