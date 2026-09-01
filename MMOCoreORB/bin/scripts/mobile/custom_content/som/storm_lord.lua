storm_lord = Creature:new {
	customName = "Storm Lord",
	socialGroup = "storm_lord",
	faction = "",
	mobType = MOB_NPC,
	level = 140,
	chanceHit = 7,
	damageMin = 845,
	damageMax = 1400,
	baseXp = 13273,
	baseHAM = 68000,
	baseHAMmax = 83000,
	armor = 2,
	resists = {90,90,90,90,90,90,90,90,-1},
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

	templates = {"object/mobile/som/storm_lord.iff"},
	lootGroups = {
		{
			groups = {
				{group = "dark_jedi_tier_5", chance = 3000000},
				{group = "force_tier_4", chance = 2000000},
				{group = "holocron_dark", chance = 1500000},
				{group = "color_crystals", chance = 1500000},
				{group = "power_crystals", chance = 1000000},
				{group = "armor_attachments", chance = 1000000}
			},
			lootChance = 7000000
		}
	},
	primaryWeapon = "melee_weapons",
	secondaryWeapon = "none",
	conversationTemplate = "",
	primaryAttacks = merge(brawlermaster,swordsmanmaster,forcepowermaster),
	secondaryAttacks = forcepowermaster
}

CreatureTemplates:addCreatureTemplate(storm_lord, "storm_lord")
