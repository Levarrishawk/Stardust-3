-- SOURCED (ruling 2026-09-04): socialGroup/faction from datatables/mob/creatures.tab line 1339 (ep3_forest_arena_guard_outer, where=kashyyyk, NORMAL).
-- Level/damage/HAM: OURS, unchanged -- the Kashyyyk curve is an open maintainer decision.
arena_guard_outer = Creature:new {
	customName = "Arena Guard",
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
	pvpBitmask = ATTACKABLE,
	creatureBitmask = NONE,
	optionsBitmask = AIENABLED + CONVERSABLE,
	diet = HERBIVORE,

	templates = {"object/mobile/ep3/arena_guard_outer.iff"},
	lootGroups = {},
	weapons = {"pirate_weapons_light"},
	conversationTemplate = "ep3_forest_arena_guard_convo",
	reactionStf = "@npc_reaction/slang",
	attacks = merge(brawlermaster,marksmanmaster)
}

CreatureTemplates:addCreatureTemplate(arena_guard_outer, "arena_guard_outer")
