ep3_chawroo = Creature:new {
	customName = "Chawroo",
	socialGroup = "kashyyyk",
	faction = "",
	mobType = MOB_NPC,
	level = 1,
	baseHAM = 1000,
	baseHAMmax = 1000,
	pvpBitmask = NONE,
	creatureBitmask = NONE,
	optionsBitmask = AIENABLED + CONVERSABLE + INTERESTING,
	templates = {"object/mobile/ep3/ep3_chawroo.iff"},
	conversationTemplate = "ep3_trandoshan_chawroo_zssik_01a_convo",
}

CreatureTemplates:addCreatureTemplate(ep3_chawroo, "ep3_chawroo")
