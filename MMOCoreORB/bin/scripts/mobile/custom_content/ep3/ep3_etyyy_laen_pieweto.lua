-- SOURCED (ruling 2026-09-04): socialGroup/faction from datatables/mob/creatures.tab line 1292 (ep3_etyyy_chiss_poacher_laen_pieweto, where=etyyy, ELITE).
-- Level/damage/HAM: OURS, unchanged -- the Kashyyyk curve is an open maintainer decision.
ep3_etyyy_laen_pieweto = Creature:new {
	customName = "Laen Pieweto, Chiss Poacher Leader",
	--randomNameType = NAME_GENERIC_TAG,
	socialGroup = "chiss_poacher_etyyy",
	faction = "",
	mobType = MOB_NPC,
	level = 47,
	chanceHit = 0.47,
	damageMin = 500,
	damageMax = 600,
	baseXp = 4700,
	baseHAM = 20000,
	baseHAMmax = 25000,
	armor = 1,
	resists = {80,80,80,40,40,0,0,-1,-1},
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

	templates = {"object/mobile/ep3/ep3_etyyy_laen_pieweto.iff"},
	lootGroups = {},
	weapons = {"pirate_weapons_heavy"},
	conversationTemplate = "",
	reactionStf = "@npc_reaction/slang",
	attacks = merge(brawlermaster,marksmanmaster)
}

CreatureTemplates:addCreatureTemplate(ep3_etyyy_laen_pieweto, "ep3_etyyy_laen_pieweto")
