-- SOURCED (ruling 2026-09-04): socialGroup/faction from datatables/mob/creatures.tab lines 1289 (ep3_etyyy_chiss_poacher, where=etyyy, NORMAL; primary); 1404 (ep3_kachirho_chiss_villager, where=kachirho, NORMAL).
-- Level/damage/HAM: OURS, unchanged -- the Kashyyyk curve is an open maintainer decision.
ep3_etyyy_chiss_poacher_02 = Creature:new {
	customName = "Chiss Poacher",
	randomNameType = NAME_GENERIC_TAG,
	socialGroup = "chiss_poacher_etyyy",
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
	resists = {30,30,0,0,0,0,0,-1,-1},
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

	templates = {"object/mobile/ep3/ep3_etyyy_chiss_poacher_02.iff"},
	lootGroups = {},
	weapons = {"pirate_weapons_heavy"},
	conversationTemplate = "",
	reactionStf = "@npc_reaction/slang",
	attacks = merge(brawlermaster,marksmanmaster)
}

CreatureTemplates:addCreatureTemplate(ep3_etyyy_chiss_poacher_02, "ep3_etyyy_chiss_poacher_02")
