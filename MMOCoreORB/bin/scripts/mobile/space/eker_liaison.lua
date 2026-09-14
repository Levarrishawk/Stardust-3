eker_liaison = Creature:new {
	objectName = "Crimson Phoenix Squadron Liaison",
	randomNameType = NAME_GENERIC,
	randomNameTag = false,
	mobType = MOB_NPC,
	socialGroup = "rebel",
	faction = "rebel",
	level = 20,
	chanceHit = 0.33,
	damageMin = 190,
	damageMax = 200,
	baseXp = 1803,
	baseHAM = 5000,
	baseHAMmax = 6100,
	armor = 0,
	resists = {0, 0, 0, 0, 0, 0, 0, -1, -1},
	meatType = "",
	meatAmount = 0,
	hideType = "",
	hideAmount = 0,
	boneType = "",
	boneAmount = 0,
	milk = 0,
	tamingChance = 0,
	ferocity = 0,
	pvpBitmask = 0,
	creatureBitmask = PACK,
	optionsBitmask = AIENABLED + CONVERSABLE + JTLINTERESTING,
	diet = HERBIVORE,

	templates = {
		"object/mobile/dressed_rebel_pilot_human_male_01.iff",
		"object/mobile/dressed_rebel_pilot_human_male_02.iff",
		"object/mobile/dressed_rebel_pilot_human_female_01.iff"
	},
	lootGroups = {},
	primaryWeapon = "unarmed",
	secondaryWeapon = "none",
	conversationTemplate = "eker_liaison_convo",
	primaryAttacks = {},
	secondaryAttacks = {}
}

CreatureTemplates:addCreatureTemplate(eker_liaison, "eker_liaison")
