mtp_angry_meatlump = Creature:new {
	customName = "mtp_angry_meatlump",
	randomNameType = NAME_GENERIC,
	randomNameTag = true,
	socialGroup = "meatlump", -- SOURCED creatures.tab:6037 base=meatlump_hideout_thug
	faction = "meatlump",
	mobType = MOB_NPC,
	level = 7, -- OURS: hub maps meatlump_hideout_thug -> meatlump_stooge Pre-CU combat
	chanceHit = 0.260000,
	damageMin = 55,
	damageMax = 65,
	baseXp = 187,
	baseHAM = 270,
	baseHAMmax = 330,
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
	pvpBitmask = ATTACKABLE, -- kill-12 quest; eavesdrop npc_01 is INVULNERABLE
	creatureBitmask = PACK,
	optionsBitmask = AIENABLED,
	diet = HERBIVORE,

	templates = {"object/mobile/dressed_meatlump_hideout_male_01.iff"}, -- SOURCED creatures.tab:6037 appearance col 14 (meatlump_hideout_thug)
	lootGroups = {
		{
			groups = {
				{group = "meatlump_tier_1", chance = 10000000}
			}
		}
	},
	primaryWeapon = "pirate_weapons_light",
	secondaryWeapon = "unarmed",
	reactionStf = "@npc_reaction/slang",
	conversationTemplate = "",
	primaryAttacks = merge(brawlernovice,marksmannovice),
	secondaryAttacks = { }
}

CreatureTemplates:addCreatureTemplate(mtp_angry_meatlump, "mtp_angry_meatlump")
