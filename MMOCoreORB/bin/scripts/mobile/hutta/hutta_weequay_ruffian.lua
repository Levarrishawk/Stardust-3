hutta_weequay_ruffian = Creature:new {
	objectName = "",
	customName = "a Weequay ruffian",
	randomNameType = NAME_GENERIC,
	randomNameTag = true,
	mobType = MOB_NPC,
	socialGroup = "weequay",
	faction = "",
	level = 9,
	chanceHit = 0.27,
	damageMin = 80,
	damageMax = 90,
	baseXp = 356,
	baseHAM = 675,
	baseHAMmax = 825,
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
	creatureBitmask = PACK,
	optionsBitmask = AIENABLED,
	diet = HERBIVORE,

	templates = {"object/mobile/dressed_tatooine_weequay_thug.iff"},
	lootGroups = {
		{
			groups = {
				{group = "weequay_tier_1", chance = 10000000}
			}
		}
	},

	primaryWeapon = "pirate_weapons_medium",
	secondaryWeapon = "unarmed",
	conversationTemplate = "",
	reactionStf = "@npc_reaction/military",
	
	primaryAttacks = merge(brawlermid,marksmanmaster,carbineernovice),
	secondaryAttacks = { }
}

CreatureTemplates:addCreatureTemplate(hutta_weequay_ruffian, "hutta_weequay_ruffian")
