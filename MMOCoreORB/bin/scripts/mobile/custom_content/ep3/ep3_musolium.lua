ep3_musolium = Creature:new {
	customName = "Musolium",
	--randomNameType = NAME_GENERIC_TAG,
	socialGroup = "townsperson",
	faction = "",
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
	-- CONVERSABLE is required, not cosmetic: CreatureTemplateManager only builds a conversation
	-- observer for a mobile that carries the CONVERSE option bit, and src/tests/LuaMobileTest.cpp
	-- (the repo gauntlet) asserts that a mobile with the bit also has a conversationTemplate. The
	-- two below must therefore be set together.
	optionsBitmask = AIENABLED + CONVERSABLE,
	diet = HERBIVORE,

	templates = {"object/mobile/ep3/ep3_musolium.iff"},
	lootGroups = {},
	weapons = {},
	conversationTemplate = "ep3_musolium_convotemplate",
	reactionStf = "@npc_reaction/slang",
	attacks = merge(brawlermaster,marksmanmaster)
}

CreatureTemplates:addCreatureTemplate(ep3_musolium, "ep3_musolium")
