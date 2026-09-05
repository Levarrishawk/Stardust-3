-- SOURCED (ruling 2026-09-04): socialGroup/faction from datatables/mob/creatures.tab lines 1242 (ep3_avatar_blackscale_captain, where=avatar, ELITE); 1558 (ep3_slaver_blackscale_assault, where=slave_camp, ELITE; primary).
-- Level/damage/HAM: OURS, unchanged -- the Kashyyyk curve is an open maintainer decision.
ep3_blackscale_assault_m_01 = Creature:new {
	customName = "Blackscale Assault",
	randomNameType = NAME_GENERIC_TAG,
	socialGroup = "blackscale",
	faction = "",
	mobType = MOB_NPC,
	level = 75,
	chanceHit = 0.75,
	damageMin = 550,
	damageMax = 870,
	baseXp = 7500,
	baseHAM = 20000,
	baseHAMmax = 25000,
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

	templates = {"object/mobile/ep3/ep3_blackscale_assault_m_01.iff"},
	lootGroups = {},
	weapons = {"pirate_weapons_heavy"},
	conversationTemplate = "",
	reactionStf = "@npc_reaction/slang",
	attacks = merge(brawlermaster,marksmanmaster)
}

CreatureTemplates:addCreatureTemplate(ep3_blackscale_assault_m_01, "ep3_blackscale_assault_m_01")
