storm_lord_guard = Creature:new {
	customName = "a storm lord guard",
	socialGroup = "storm_lord",
	faction = "",
	mobType = MOB_NPC,
	level = 100,
	chanceHit = 1,
	damageMin = 645,
	damageMax = 1000,
	baseXp = 9429,
	baseHAM = 24000,
	baseHAMmax = 30000,
	armor = 1,
	resists = {5,5,5,30,-1,30,-1,-1,-1},
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

	templates = {"object/mobile/som/storm_lord_guard.iff"},
	lootGroups = {
		{
			groups = {
				{group = "wilder_tier_1", chance = 6000000},
				{group = "armor_attachments", chance = 2000000},
				{group = "clothing_attachments", chance = 2000000}
			},
			lootChance = 7000000
		}
	},
	primaryWeapon = "melee_weapons",
	secondaryWeapon = "none",
	conversationTemplate = "",
	primaryAttacks = merge(brawlermaster,swordsmanmaster,forcewielder),
	secondaryAttacks = forcewielder
}

CreatureTemplates:addCreatureTemplate(storm_lord_guard, "storm_lord_guard")
