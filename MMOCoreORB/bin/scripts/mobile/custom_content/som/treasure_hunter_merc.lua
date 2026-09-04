treasure_hunter_merc = Creature:new {
	customName = "a treasure hunter mercenary",
	socialGroup = "mercenary",
	faction = "",
	mobType = MOB_NPC,
	level = 70,
	chanceHit = 0.65,
	damageMin = 430,
	damageMax = 570,
	baseXp = 6747,
	baseHAM = 12000,
	baseHAMmax = 15000,
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
	creatureBitmask = PACK + STALKER,
	optionsBitmask = AIENABLED,
	diet = HERBIVORE,

	templates = {"object/mobile/som/treasure_hunter_merc.iff"},
	lootGroups = {
		{
			groups = {
				{group = "mercenary_tier_1", chance = 10000000}
			}
		}
	},
	primaryWeapon = "pirate_weapons_light",
	secondaryWeapon = "none",
	conversationTemplate = "",
	primaryAttacks = merge(marksmanmaster,pistoleermaster),
	secondaryAttacks = pistoleermaster
}

CreatureTemplates:addCreatureTemplate(treasure_hunter_merc, "treasure_hunter_merc")
