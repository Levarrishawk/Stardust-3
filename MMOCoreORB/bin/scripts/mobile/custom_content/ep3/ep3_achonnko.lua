ep3_achonnko = Creature:new {
	customName = "Achonnko the Trail Master",
	socialGroup = "kashyyyk",
	faction = "",
	mobType = MOB_NPC,
	level = 1,
	baseHAM = 1000,
	baseHAMmax = 1000,
	pvpBitmask = NONE,
	creatureBitmask = NONE,
	optionsBitmask = AIENABLED + CONVERSABLE,
	templates = {"object/mobile/ep3/ep3_achonnko.iff"},
	conversationTemplate = "ep3_achonnko_convo",
}

CreatureTemplates:addCreatureTemplate(ep3_achonnko, "ep3_achonnko")
