-- SOURCED (ruling 2026-09-04): socialGroup/faction from datatables/mob/creatures.tab line 1506 (ep3_rryatt_abandoned_battle_droid, where=rryatt_trail, ELITE).
-- Level/damage/HAM: OURS, unchanged -- the Kashyyyk curve is an open maintainer decision.
ep3_rryatt_abandoned_battle_droid_02 = Creature:new {
	customName = "Abandoned Battle Droid",
	--randomNameType = NAME_GENERIC_TAG,
	socialGroup = "rryatt_abandoned_droid",
	faction = "",
	mobType = MOB_ANDROID,
	level = 134,
	chanceHit = 5.5,
	damageMin = 795,
	damageMax = 1300,
	baseXp = 12612,
	baseHAM = 56000,
	baseHAMmax = 68000,
	armor = 1,
	resists = {75,75,100,60,100,25,40,85,-1},
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

	templates = {"object/mobile/ep3/ep3_rryatt_abandoned_battle_droid_02.iff"},
	lootGroups = {},
	weapons = {"battle_droid_weapons"},
	conversationTemplate = "",
	attacks = merge(pistoleermaster,carbineermaster,marksmanmaster)
}

CreatureTemplates:addCreatureTemplate(ep3_rryatt_abandoned_battle_droid_02, "ep3_rryatt_abandoned_battle_droid_02")
