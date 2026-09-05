-- SOURCED (ruling 2026-09-04): socialGroup/faction from datatables/mob/creatures.tab lines 1250 (ep3_avatar_wke_captive, where=avatar, ELITE); 1492 (ep3_qst_wookiee_captive, where=kashyyyk, NORMAL); 1493 (ep3_qst_wookiee_civilians, where=kashyyyk, NORMAL; primary); 1494 (ep3_qst_wookiee_escaped, where=kashyyyk, NORMAL); 1496 (ep3_qst_wookiee_tagged, where=kashyyyk, NORMAL).
-- Level/damage/HAM: OURS, unchanged -- the Kashyyyk curve is an open maintainer decision.
ep3_wke_civilian_06 = Creature:new {
	customName = "Wookiee Civilian",
	randomNameType = NAME_GENERIC_TAG,
	socialGroup = "kashyyyk",
	faction = "",
	mobType = MOB_NPC,
	level = 30,
	chanceHit = 0.33,
	damageMin = 180,
	damageMax = 190,
	baseXp = 1609,
	baseHAM = 4500,
	baseHAMmax = 5500,
	armor = 0,
	resists = {10,10,10,10,10,10,10,-1,-1},
	meatType = "",
	meatAmount = 0,
	hideType = "",
	hideAmount = 0,
	boneType = "",
	boneAmount = 0,
	milk = 0,
	tamingChance = 0,
	ferocity = 0,
	pvpBitmask = NONE,
	creatureBitmask = NONE,
	optionsBitmask = AIENABLED,
	diet = HERBIVORE,

	templates = {"object/mobile/ep3/ep3_wke_civilian_06.iff"},
	lootGroups = {},
	weapons = {},
	conversationTemplate = "",
	reactionStf = "@npc_reaction/slang",
	attacks = merge(brawlermaster,marksmanmaster)
}

CreatureTemplates:addCreatureTemplate(ep3_wke_civilian_06, "ep3_wke_civilian_06")
