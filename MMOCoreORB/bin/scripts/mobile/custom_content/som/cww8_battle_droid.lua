-- mobType was absent, so getMobType() sat at 0 and isDroid/isAndroid/isHumanoid all
-- returned false. MOB_ANDROID, not MOB_DROID: every plain battle droid in the shipped
-- tree is MOB_ANDROID (corellian_corvette rebel/corsec/imperial_battle_droid,
-- death_watch_battle_droid, separatist_battle_droid, kaas_battle_droid -- 6 of 6).
-- The split only matters at AiAgent.idl:1691/1696/1708: MOB_ANDROID counts as humanoid
-- and stays mind-trickable (JediMindTrickCommand.h:47), MOB_DROID does not.
cww8_battle_droid = Creature:new {
	customName = "CWW8 Battle Droid",
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

	templates = {"object/mobile/som/cww8_battle_droid.iff"},
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

CreatureTemplates:addCreatureTemplate(cww8_battle_droid, "cww8_battle_droid")
