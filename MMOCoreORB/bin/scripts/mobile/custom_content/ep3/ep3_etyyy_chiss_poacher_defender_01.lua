-- SOURCED (ruling 2026-09-04): socialGroup/faction from datatables/mob/creatures.tab lines 1290 (ep3_etyyy_chiss_poacher_defender, where=etyyy, NORMAL; primary); 1403 (ep3_kachirho_chiss_guard, where=kachirho, NORMAL).
-- Level/damage/HAM: OURS, unchanged -- the Kashyyyk curve is an open maintainer decision.
ep3_etyyy_chiss_poacher_defender_01 = Creature:new {
	customName = "Chiss Poacher Defender",
	randomNameType = NAME_GENERIC_TAG,
	socialGroup = "chiss_poacher_etyyy",
	faction = "",
	mobType = MOB_NPC,
	level = 45,
	chanceHit = 0.45,
	damageMin = 300,
	damageMax = 550,
	baseXp = 1609,
	baseHAM = 8000,
	baseHAMmax = 9000,
	armor = 0,
	resists = {40,40,10,10,10,10,10,-1,-1},
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

	templates = {"object/mobile/ep3/ep3_etyyy_chiss_poacher_defender_01.iff"},
	lootGroups = {},
	weapons = {"pirate_weapons_heavy"},
	conversationTemplate = "",
	reactionStf = "@npc_reaction/slang",
	attacks = merge(brawlermaster,marksmanmaster)
}

CreatureTemplates:addCreatureTemplate(ep3_etyyy_chiss_poacher_defender_01, "ep3_etyyy_chiss_poacher_defender_01")
