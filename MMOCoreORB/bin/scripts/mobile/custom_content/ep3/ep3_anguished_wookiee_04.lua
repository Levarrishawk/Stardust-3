-- SOURCED (ruling 2026-09-04): socialGroup/faction from datatables/mob/creatures.tab line 1485 (ep3_qst_anguished_wookiee, where=kachirho, NORMAL).
-- Level/damage/HAM: OURS, unchanged -- the Kashyyyk curve is an open maintainer decision.
ep3_anguished_wookiee_04 = Creature:new {
	customName = "Anguished Wookiee",
	randomNameType = NAME_GENERIC_TAG,
	socialGroup = "mad_wookiee",
	faction = "",
	mobType = MOB_NPC,
	level = 45,
	chanceHit = 0.45,
	damageMin = 750,
	damageMax = 900,
	baseXp = 4500,
	baseHAM = 20000,
	baseHAMmax = 30000,
	armor = 1,
	resists = {60,60,60,60,60,60,60,60,-1},
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

	templates = {"object/mobile/ep3/ep3_anguished_wookiee_04.iff"},
	lootGroups = {},
	weapons = {},
	conversationTemplate = "",
	reactionStf = "@npc_reaction/slang",
	attacks = {
		{"intimidationattack",""}
	}
}

CreatureTemplates:addCreatureTemplate(ep3_anguished_wookiee_04, "ep3_anguished_wookiee_04")
