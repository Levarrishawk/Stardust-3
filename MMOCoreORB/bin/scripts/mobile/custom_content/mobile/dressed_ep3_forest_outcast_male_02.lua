-- SOURCED (ruling 2026-09-04): socialGroup/faction from datatables/mob/creatures.tab line 1357 (ep3_forest_outcast_male_02, where=kashyyyk, NORMAL).
-- Level/damage/HAM: OURS, unchanged -- the Kashyyyk curve is an open maintainer decision.
dressed_ep3_forest_outcast_male_02 = Creature:new {
	customName = "human_base_male",
	randomNameType = NAME_GENERIC,
	randomNameTag = true,
	socialGroup = "kashyyyk",
	faction = "",
	level = 4,
	chanceHit = 0.24,
	damageMin = 40,
	damageMax = 45,
	baseXp = 62,
	baseHAM = 113,
	baseHAMmax = 118,
	armor = 0,
	resists = {0,0,0,0,0,0,0,-1,-1},
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

	templates = {"object/mobile/dressed_ep3_forest_outcast_male_02.iff"},
	lootGroups = {},
	weapons = {},
	conversationTemplate = "",
	attacks = {
	}
}

CreatureTemplates:addCreatureTemplate(dressed_ep3_forest_outcast_male_02, "dressed_ep3_forest_outcast_male_02")
