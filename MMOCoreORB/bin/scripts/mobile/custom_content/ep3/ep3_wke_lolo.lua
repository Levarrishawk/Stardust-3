ep3_wke_lolo = Creature:new {
	customName = "Lolo",
	--randomNameType = NAME_GENERIC_TAG,
	socialGroup = "townsperson",
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
	-- CONVERSABLE and conversationTemplate must be set together: LuaMobileTest.cpp asserts that any
	-- mobile carrying the CONVERSE option bit has a non-empty conversationTemplate. The template is
	-- ep3_wke_lolo_convotemplate, defined in
	-- mobile/conversations/space/neutral/kashyyyk_bowcaster/ep3_wke_lolo_convo.lua. Lolo is the ground
	-- giver for inspect/ep3_wke_bowcaster_crafting.
	optionsBitmask = AIENABLED + CONVERSABLE,
	diet = HERBIVORE,

	templates = {"object/mobile/ep3/ep3_wke_lolo.iff"},
	lootGroups = {},
	weapons = {},
	conversationTemplate = "ep3_wke_lolo_convotemplate",
	reactionStf = "@npc_reaction/slang",
	attacks = merge(brawlermaster,marksmanmaster)
}

CreatureTemplates:addCreatureTemplate(ep3_wke_lolo, "ep3_wke_lolo")
