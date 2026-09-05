-- SOURCED (ruling 2026-09-04): socialGroup/faction from datatables/mob/creatures.tab line 1422 (ep3_mining_captain_koh, where=kashyyyk, NORMAL).
-- Level/damage/HAM: OURS, unchanged -- the Kashyyyk curve is an open maintainer decision.
ep3_mining_captain_koh = Creature:new {
	customName = "Captain Koh",
	--randomNameType = NAME_GENERIC_TAG,
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
	pvpBitmask = NONE,
	creatureBitmask = NONE,
	-- CONVERSABLE and conversationTemplate must be set together: LuaMobileTest.cpp:463-477 asserts that
	-- any mobile carrying the CONVERSE option bit has a non-empty conversationTemplate. The template is
	-- ep3_mining_captain_koh_convotemplate, defined in
	-- mobile/conversations/space/neutral/kashyyyk_mining/ep3_mining_captain_koh_convo.lua.
	optionsBitmask = AIENABLED + CONVERSABLE,
	diet = HERBIVORE,

	templates = {"object/mobile/ep3/ep3_mining_captain_koh.iff"},
	lootGroups = {},
	weapons = {},
	conversationTemplate = "ep3_mining_captain_koh_convotemplate",
	reactionStf = "@npc_reaction/slang",
	attacks = merge(brawlermaster,marksmanmaster)
}

CreatureTemplates:addCreatureTemplate(ep3_mining_captain_koh, "ep3_mining_captain_koh")
