tukata = Creature:new {
	customName = "a Tuk'ata",
	socialGroup = "tukata",
	faction = "",
	mobType = MOB_CARNIVORE,
	level = 70,
	chanceHit = 0.27,
	damageMin = 550,
	damageMax = 1800,
	baseXp = 235,
	baseHAM = 36000,
	baseHAMmax = 39000,
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
	pvpBitmask = AGGRESSIVE + ATTACKABLE + ENEMY,
	creatureBitmask = PACK + STALKER,
	optionsBitmask = AIENABLED,
	diet = CARNIVORE,

	templates = {"object/mobile/som/xandank.iff"},
	lootGroups = {
		{
			groups = {},
			lootChance = 2100000
		}
	},
	primaryWeapon = "unarmed",
	secondaryWeapon = "none",
	secondaryAttacks = {},
	conversationTemplate = "",
	primaryAttacks = {
    {"creatureareableeding",""},
    {"creatureareacombo",""}
  }
}

CreatureTemplates:addCreatureTemplate(tukata, "tukata")
