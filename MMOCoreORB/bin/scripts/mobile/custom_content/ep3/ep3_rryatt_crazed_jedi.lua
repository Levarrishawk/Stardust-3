-- SOURCED (ruling 2026-09-04): socialGroup/faction from datatables/mob/creatures.tab line 1513 (ep3_rryatt_crazed_jedi, where=rryatt_trail, ELITE).
-- Level/damage/HAM: OURS, unchanged -- the Kashyyyk curve is an open maintainer decision.
ep3_rryatt_crazed_jedi = Creature:new {
	customName = "Crazed Jedi",
	socialGroup = "rryatt_crazed_jedi",
	faction = "",
	mobType = MOB_NPC,
	level = 120,
	chanceHit = 4.50,
	damageMin = 1250,
	damageMax = 1850,
	baseXp = 12000,
	baseHAM = 120000,
	baseHAMmax = 150000,
	armor = 1,
	resists = {70,70,70,70,70,70,70,70,-1},
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
	creatureBitmask = KILLER + STALKER,
	optionsBitmask = AIENABLED,
	diet = HERBIVORE,

	templates = {"object/mobile/ep3/ep3_rryatt_crazed_jedi.iff"},
	lootGroups = {},
	weapons = {"light_jedi_weapons"},
	conversationTemplate = "",
	reactionStf = "@npc_reaction/slang",
	attacks = merge(lightsabermaster)
}

CreatureTemplates:addCreatureTemplate(ep3_rryatt_crazed_jedi, "ep3_rryatt_crazed_jedi")
