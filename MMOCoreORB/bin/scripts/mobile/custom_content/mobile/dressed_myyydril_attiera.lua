-- SOURCED (ruling 2026-09-04): socialGroup/faction from datatables/mob/creatures.tab line 1431 (ep3_myyydril_attiera, where=myyydril, NORMAL).
-- Level/damage/HAM: OURS, unchanged -- the Kashyyyk curve is an open maintainer decision.
dressed_myyydril_attiera = Creature:new {
	customName = "human_base_male",
	randomNameType = NAME_GENERIC,
	randomNameTag = true,
	socialGroup = "myyydril",
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
	optionsBitmask = AIENABLED + CONVERSABLE,
	diet = HERBIVORE,

	templates = {"object/mobile/dressed_myyydril_attiera.iff"},
	lootGroups = {},
	weapons = {},
	conversationTemplate = "ep3_myyydril_attiera_convo",
	attacks = {
	}
}

CreatureTemplates:addCreatureTemplate(dressed_myyydril_attiera, "dressed_myyydril_attiera")
