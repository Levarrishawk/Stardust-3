djedi_twk_f_01 = Creature:new {
	customName = "Dark Jedi",
	socialGroup = "dark_jedi",
	faction = "",
	mobType = MOB_NPC,
	level = 85,
	chanceHit = 0.75,
	damageMin = 555,
	damageMax = 820,
	baseXp = 8130,
	baseHAM = 12000,
	baseHAMmax = 15000,
	armor = 1,
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

	templates = {"object/mobile/som/djedi_twk_f_01.iff"},
	lootGroups = {
		{
			groups = {
				{group = "dark_jedi_tier_4", chance = 6000000},
				{group = "color_crystals", chance = 2000000},
				{group = "power_crystals", chance = 1000000},
				{group = "holocron_dark", chance = 1000000}
			},
			lootChance = 5000000
		}
	},
	primaryWeapon = "dark_jedi_weapons_gen3",
	secondaryWeapon = "dark_jedi_weapons_ranged",
	conversationTemplate = "",
	primaryAttacks = merge(lightsabermaster,forcepowermaster),
	secondaryAttacks = forcepowermaster
}

CreatureTemplates:addCreatureTemplate(djedi_twk_f_01, "djedi_twk_f_01")
