-- MOB_ANDROID for the same reason as cww8_battle_droid.lua: 6 of 6 plain battle droids
-- in the shipped tree use it. (The eradicator alongside stays MOB_DROID -- it is
-- droideka-class, and there the shipped split runs the other way, 5 of 6.)
cww8a_battle_droid = Creature:new {
	customName = "CWW8A Battle Droid",
	socialGroup = "townsperson",
	faction = "",
	mobType = MOB_ANDROID,
	level = 70,
	chanceHit = 0.27,
	damageMin = 550,
	damageMax = 800,
	baseXp = 235,
	baseHAM = 16000,
	baseHAMmax = 19000,
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
	creatureBitmask = PACK + STALKER,
	optionsBitmask = AIENABLED,
	diet = HERBIVORE,

	templates = {"object/mobile/som/cww8a_battle_droid.iff"},
	lootGroups = {
		{
			groups = {},
			lootChance = 2100000
		}
	},
	weapons = {"pirate_weapons_light"},
	conversationTemplate = "",
	attacks = merge(marksmannovice,brawlernovice)
}

CreatureTemplates:addCreatureTemplate(cww8a_battle_droid, "cww8a_battle_droid")
