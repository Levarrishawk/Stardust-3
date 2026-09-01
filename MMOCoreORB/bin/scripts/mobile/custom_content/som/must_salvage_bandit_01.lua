must_salvage_bandit_01 = Creature:new {
	customName = "a Salvage Bandit thug",
	socialGroup = "thug",
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
	pvpBitmask = ATTACKABLE + ENEMY,
	creatureBitmask = PACK + STALKER,
	optionsBitmask = AIENABLED,
	diet = HERBIVORE,

	templates = {"object/mobile/som/must_salvage_bandit_01.iff"},
	lootGroups = {
		{
			groups = {
				{group = "thug_tier_1", chance = 10000000}
			}
		}
	},
	primaryWeapon = "pirate_weapons_light",
	secondaryWeapon = "none",
	conversationTemplate = "",
	primaryAttacks = merge(marksmanmaster,pistoleermaster),
	secondaryAttacks = pistoleermaster
}

CreatureTemplates:addCreatureTemplate(must_salvage_bandit_01, "must_salvage_bandit_01")
