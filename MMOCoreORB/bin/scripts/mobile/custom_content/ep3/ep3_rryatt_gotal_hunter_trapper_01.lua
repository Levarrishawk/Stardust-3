-- SOURCED (ruling 2026-09-04): socialGroup/faction from datatables/mob/creatures.tab line 1519 (ep3_rryatt_gotal_hunter_trapper, where=rryatt_trail, NORMAL).
-- Level/damage/HAM: OURS, unchanged -- the Kashyyyk curve is an open maintainer decision.
ep3_rryatt_gotal_hunter_trapper_01 = Creature:new {
	customName = "Gotal Hunter Trapper",
	randomNameType = NAME_GENERIC_TAG,
	socialGroup = "gotal_hunter_rryatt",
	faction = "",
	mobType = MOB_NPC,
	level = 85,
	chanceHit = 0.85,
	damageMin = 1200,
	damageMax = 1800,
	baseXp = 8500,
	baseHAM = 45000,
	baseHAMmax = 55000,
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

	templates = {"object/mobile/ep3/ep3_rryatt_gotal_hunter_trapper_01.iff"},
	lootGroups = {},
	weapons = {"pirate_weapons_heavy"},
	conversationTemplate = "",
	reactionStf = "@npc_reaction/slang",
	attacks = merge(brawlermaster,marksmanmaster)
}

CreatureTemplates:addCreatureTemplate(ep3_rryatt_gotal_hunter_trapper_01, "ep3_rryatt_gotal_hunter_trapper_01")
