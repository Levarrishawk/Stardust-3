-- SOURCED (ruling 2026-09-04): socialGroup/faction from datatables/mob/creatures.tab line 1568 (ep3_slaver_blackscale_wookiee_berserker, where=slave_camp, ELITE).
-- Level/damage/HAM: OURS, unchanged -- the Kashyyyk curve is an open maintainer decision.
ep3_blackscale_wookiee_berserker_03 = Creature:new {
	customName = "Wookiee Berserker",
	randomNameType = NAME_GENERIC_TAG,
	socialGroup = "blackscale",
	faction = "",
	mobType = MOB_NPC,
	level = 105,
	chanceHit = 1.05,
	damageMin = 1150,
	damageMax = 1470,
	baseXp = 7500,
	baseHAM = 80000,
	baseHAMmax = 90000,
	armor = 1,
	resists = {60,60,60,60,60,60,60,60,-1},
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
	creatureBitmask = KILLER,
	optionsBitmask = AIENABLED,
	diet = HERBIVORE,

	templates = {"object/mobile/ep3/ep3_blackscale_wookiee_berserker_03.iff"},
	lootGroups = {},
	weapons = {},
	conversationTemplate = "",
	attacks = merge(brawlermaster,marksmanmaster,commandomaster,bountyhuntermaster,carbineermaster,riflemanmaster,pistoleermaster)
}

CreatureTemplates:addCreatureTemplate(ep3_blackscale_wookiee_berserker_03, "ep3_blackscale_wookiee_berserker_03")
