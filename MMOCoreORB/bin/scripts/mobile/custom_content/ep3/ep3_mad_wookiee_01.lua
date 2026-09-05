-- SOURCED (ruling 2026-09-04): socialGroup/faction from datatables/mob/creatures.tab line 1488 (ep3_qst_mad_wookiee, where=kachirho, NORMAL).
-- Level/damage/HAM: OURS, unchanged -- the Kashyyyk curve is an open maintainer decision.
ep3_mad_wookiee_01 = Creature:new {
	customName = "Mad Wookiee",
	randomNameType = NAME_GENERIC_TAG,
	socialGroup = "mad_wookiee",
	faction = "",
	mobType = MOB_NPC,
	level = 105,
	chanceHit = 1.05,
	damageMin = 1150,
	damageMax = 1470,
	baseXp = 7500,
	baseHAM = 80000,
	baseHAMmax = 90000,
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
	pvpBitmask = AGGRESSIVE + ATTACKABLE + ENEMY,
	creatureBitmask = NONE,
	optionsBitmask = AIENABLED,
	diet = HERBIVORE,

	templates = {"object/mobile/ep3/ep3_mad_wookiee_01.iff"},
	lootGroups = {},
	weapons = {"chewbacca_weapons"},
	conversationTemplate = "",
	attacks = merge(brawlermaster,marksmanmaster)
}

CreatureTemplates:addCreatureTemplate(ep3_mad_wookiee_01, "ep3_mad_wookiee_01")
