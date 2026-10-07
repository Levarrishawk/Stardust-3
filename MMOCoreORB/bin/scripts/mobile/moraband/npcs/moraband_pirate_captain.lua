moraband_pirate_captain = Creature:new {
	objectName = "",
	customName = "a stranded pirate captain",
	randomNameType = NAME_GENERIC,
	randomNameTag = true,
	mobType = MOB_NPC,
	socialGroup = "pirate",
	faction = "pirate",
	level = 24,
	chanceHit = 0.35,
	damageMin = 210,
	damageMax = 220,
	baseXp = 2543,
	baseHAM = 5900,
	baseHAMmax = 7200,
	armor = 0,
	resists = {20,20,10,40,-1,40,10,-1,-1},
	meatType = "",
	meatAmount = 0,
	hideType = "",
	hideAmount = 0,
	boneType = "",
	boneAmount = 0,
	milk = 0,
	tamingChance = 0,
	ferocity = 0,
	pvpBitmask = AGGRESSIVE + ATTACKABLE + ENEMY,
	creatureBitmask = PACK,
	optionsBitmask = AIENABLED,
	diet = HERBIVORE,

	templates = {
		"object/mobile/dressed_marooned_pirate_captain_hum_m.iff",
		"object/mobile/dressed_marooned_pirate_captain_nikto_m.iff",
		"object/mobile/dressed_marooned_pirate_captain_tran_m.iff",
		"object/mobile/dressed_marooned_pirate_captain_wee_m.iff"
	},
	lootGroups = {
		{
			groups = {
				{group = "pirate_tier_1", chance = 10000000}
			}
		}
	},

	primaryWeapon = "pirate_weapons_heavy",
	secondaryWeapon = "unarmed",
	conversationTemplate = "",
	reactionStf = "@npc_reaction/slang",
	
	primaryAttacks = merge(brawlermaster,marksmanmaster),
	secondaryAttacks = { }
}

CreatureTemplates:addCreatureTemplate(moraband_pirate_captain, "moraband_pirate_captain")
