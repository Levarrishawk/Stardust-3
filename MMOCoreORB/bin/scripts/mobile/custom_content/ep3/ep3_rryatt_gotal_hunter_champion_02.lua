-- SOURCED (ruling 2026-09-04): socialGroup/faction from datatables/mob/creatures.tab line 1517 (ep3_rryatt_gotal_hunter_champion, where=rryatt_trail, NORMAL).
-- Level/damage/HAM: OURS, unchanged -- the Kashyyyk curve is an open maintainer decision.
ep3_rryatt_gotal_hunter_champion_02 = Creature:new {
	customName = "Gotal Hunter Champion",
	randomNameType = NAME_GENERIC_TAG,
	socialGroup = "gotal_hunter_rryatt",
	faction = "",
	mobType = MOB_NPC,
	level = 115,
	chanceHit = 3.85,
	damageMin = 1800,
	damageMax = 2400,
	baseXp = 8500,
	baseHAM = 85000,
	baseHAMmax = 105000,
	armor = 1,
	resists = {80,80,80,80,80,80,80,80,-1},
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
	creatureBitmask = NONE,
	optionsBitmask = AIENABLED,
	diet = HERBIVORE,

	templates = {"object/mobile/ep3/ep3_rryatt_gotal_hunter_champion_02.iff"},
	lootGroups = {},
	weapons = {"pirate_weapons_heavy"},
	conversationTemplate = "",
	reactionStf = "@npc_reaction/slang",
	attacks = merge(brawlermaster,marksmanmaster)
}

CreatureTemplates:addCreatureTemplate(ep3_rryatt_gotal_hunter_champion_02, "ep3_rryatt_gotal_hunter_champion_02")
