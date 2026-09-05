-- SOURCED (ruling 2026-09-04): socialGroup/faction from datatables/mob/creatures.tab lines 1398 (ep3_kachirho_canopy_bandit, where=kachirho, NORMAL; primary); 1400 (ep3_kachirho_canopy_cutthroat, where=kachirho, NORMAL).
-- Level/damage/HAM: OURS, unchanged -- the Kashyyyk curve is an open maintainer decision.
ep3_canopy_bandit_02 = Creature:new {
	customName = "Canopy Bandit",
	randomNameType = NAME_GENERIC_TAG,
	socialGroup = "canopy_bandit",
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
	pvpBitmask = AGGRESSIVE + ATTACKABLE + ENEMY,
	creatureBitmask = NONE,
	optionsBitmask = AIENABLED,
	diet = HERBIVORE,

	templates = {"object/mobile/ep3/ep3_canopy_bandit_02.iff"},
	lootGroups = {},
	weapons = {"pirate_weapons_light"},
	conversationTemplate = "",
	reactionStf = "@npc_reaction/slang",
	attacks = merge(brawlermaster,marksmanmaster)
}

CreatureTemplates:addCreatureTemplate(ep3_canopy_bandit_02, "ep3_canopy_bandit_02")
