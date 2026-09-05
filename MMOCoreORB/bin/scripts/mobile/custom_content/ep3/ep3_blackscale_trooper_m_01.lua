-- SOURCED (ruling 2026-09-04): socialGroup/faction from datatables/mob/creatures.tab lines 1246 (ep3_avatar_blackscale_watch_cmd, where=avatar, ELITE); 1566 (ep3_slaver_blackscale_trooper, where=slave_camp, ELITE; primary).
-- Level/damage/HAM: OURS, unchanged -- the Kashyyyk curve is an open maintainer decision.
ep3_blackscale_trooper_m_01 = Creature:new {
	customName = "Blackscale Trooper",
	randomNameType = NAME_GENERIC_TAG,
	socialGroup = "blackscale",
	faction = "",
	mobType = MOB_NPC,
	level = 100,
	chanceHit = 1.00,
	damageMin = 1150,
	damageMax = 1470,
	baseXp = 7500,
	baseHAM = 50000,
	baseHAMmax = 75000,
	armor = 1,
	resists = {60,60,80,60,55,65,85,45,-1},
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

	templates = {"object/mobile/ep3/ep3_blackscale_trooper_m_01.iff"},
	lootGroups = {},
	weapons = {"pirate_weapons_heavy"},
	conversationTemplate = "",
	reactionStf = "@npc_reaction/slang",
	attacks = merge(brawlermaster,marksmanmaster)
}

CreatureTemplates:addCreatureTemplate(ep3_blackscale_trooper_m_01, "ep3_blackscale_trooper_m_01")
