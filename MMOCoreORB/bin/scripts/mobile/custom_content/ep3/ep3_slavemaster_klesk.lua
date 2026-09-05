-- SOURCED (ruling 2026-09-04): socialGroup/faction from datatables/mob/creatures.tab line 1491 (ep3_qst_slavemaster_klesk, where=etyyy, NORMAL).
-- Level/damage/HAM: OURS, unchanged -- the Kashyyyk curve is an open maintainer decision.
ep3_slavemaster_klesk = Creature:new {
	customName = "Slavemaster Klesk",
	--randomNameType = NAME_GENERIC_TAG,
	socialGroup = "hsskor",
	faction = "",
	mobType = MOB_NPC,
	level = 115,
	chanceHit = 1.25,
	damageMin = 1380,
	damageMax = 1790,
	baseXp = 11509,
	baseHAM = 125000,
	baseHAMmax = 135500,
	armor = 1,
	resists = {80,80,80,60,35,55,75,20,-1},
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

	templates = {"object/mobile/ep3/ep3_slavemaster_klesk.iff"},
	lootGroups = {},
	weapons = {"pirate_weapons_heavy"},
	conversationTemplate = "",
	reactionStf = "@npc_reaction/slang",
	attacks = merge(brawlermaster,marksmanmaster)
}

CreatureTemplates:addCreatureTemplate(ep3_slavemaster_klesk, "ep3_slavemaster_klesk")
