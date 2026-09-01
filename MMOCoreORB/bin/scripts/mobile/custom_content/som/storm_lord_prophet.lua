storm_lord_prophet = Creature:new {
	customName = "Prophet of the Storm Lord",
	socialGroup = "storm_lord",
	faction = "",
	mobType = MOB_NPC,
	level = 120,
	chanceHit = 4.0,
	damageMin = 745,
	damageMax = 1200,
	baseXp = 11390,
	baseHAM = 44000,
	baseHAMmax = 54000,
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
	pvpBitmask = ATTACKABLE + AGGRESSIVE,
	creatureBitmask = PACK + STALKER + KILLER,
	optionsBitmask = AIENABLED,
	diet = HERBIVORE,

	templates = {"object/mobile/som/storm_lord_prophet.iff"},
	lootGroups = {
		{
			groups = {
				{group = "dark_jedi_tier_5", chance = 4000000},
				{group = "holocron_dark", chance = 1500000},
				{group = "color_crystals", chance = 2000000},
				{group = "power_crystals", chance = 1500000},
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

CreatureTemplates:addCreatureTemplate(storm_lord_prophet, "storm_lord_prophet")
