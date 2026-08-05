ghrag_merc_tier5 = ShipAgent:new {
	template = "blacksun_medium_s04_tier5",
	pilotTemplate = "medium_fighter_tier5",
	shipType = "fighter",

	experience = 7381.98,

	lootChance = 0.143,
	lootRolls = 1,
	lootTable = "space_ghrag_tier5",

	minCredits = 455,
	maxCredits = 875,

	aggressive = 1,

	spaceFaction = "ghrag",
	alliedFactions = {"ghrag"},
	enemyFactions = {"imperial", "rebel", "civilian", "merchant", "rsf", "corsec", "hutt", "valarian"},

	pvpBitmask = ATTACKABLE,
	shipBitmask = NONE,
	optionsBitmask = AIENABLED,

	customShipAiMap = "",

	conversationTemplate = "",
	conversationMobile = "object/mobile/shared_space_comm_ghrag_merc_03.iff",
	conversationMessage = "", --Too Far Message
}

ShipAgentTemplates:addShipAgentTemplate(ghrag_merc_tier5, "ghrag_merc_tier5")
