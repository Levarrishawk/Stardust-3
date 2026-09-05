-- SOURCED (ruling 2026-09-04): socialGroup/faction from datatables/mob/creatures.tab lines 1243 (ep3_avatar_blackscale_guard, where=avatar, ELITE); 1244 (ep3_avatar_blackscale_jailer, where=avatar, ELITE); 1288 (ep3_etyyy_blackscale_guard, where=etyyy, ELITE; primary); 1341 (ep3_forest_blackscale_guard, where=dead_forest, ELITE); 1562 (ep3_slaver_blackscale_guard, where=slave_camp, ELITE); 1563 (ep3_slaver_blackscale_guard_rryatt, where=slave_camp, NORMAL).
-- Level/damage/HAM: OURS, unchanged -- the Kashyyyk curve is an open maintainer decision.
ep3_blackscale_guard_m_04 = Creature:new {
	customName = "Blackscale Guard",
	randomNameType = NAME_GENERIC_TAG,
	socialGroup = "blackscale",
	faction = "",
	mobType = MOB_NPC,
	level = 95,
	chanceHit = 0.95,
	damageMin = 850,
	damageMax = 1170,
	baseXp = 7500,
	baseHAM = 40000,
	baseHAMmax = 45000,
	armor = 1,
	resists = {40,40,80,60,35,55,75,40,-1},
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

	templates = {"object/mobile/ep3/ep3_blackscale_guard_m_04.iff"},
	lootGroups = {},
	weapons = {"pirate_weapons_heavy"},
	conversationTemplate = "",
	reactionStf = "@npc_reaction/slang",
	attacks = {
		{"intimidationattack",""}
	}
}

CreatureTemplates:addCreatureTemplate(ep3_blackscale_guard_m_04, "ep3_blackscale_guard_m_04")
