-- SOURCED (ruling 2026-09-04): socialGroup/faction from datatables/mob/creatures.tab line 1291 (ep3_etyyy_chiss_poacher_hunter, where=etyyy, ELITE).
-- Level/damage/HAM: OURS, unchanged -- the Kashyyyk curve is an open maintainer decision.
ep3_etyyy_chiss_poacher_hunter_02 = Creature:new {
	customName = "Chiss Poacher Hunter",
	randomNameType = NAME_GENERIC_TAG,
	socialGroup = "chiss_poacher_etyyy",
	faction = "",
	mobType = MOB_NPC,
	level = 45,
	chanceHit = 0.45,
	damageMin = 400,
	damageMax = 500,
	baseXp = 4500,
	baseHAM = 17000,
	baseHAMmax = 20000,
	armor = 1,
	resists = {70,70,70,30,30,0,0,-1,-1},
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

	templates = {"object/mobile/ep3/ep3_etyyy_chiss_poacher_hunter_02.iff"},
	lootGroups = {},
	weapons = {"pirate_weapons_heavy"},
	conversationTemplate = "",
	reactionStf = "@npc_reaction/slang",
	attacks = merge(brawlermaster,marksmanmaster)
}

CreatureTemplates:addCreatureTemplate(ep3_etyyy_chiss_poacher_hunter_02, "ep3_etyyy_chiss_poacher_hunter_02")
