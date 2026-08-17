ghrag_merc_tier3 = ShipAgent:new {
	template = "blacksun_medium_s04_tier3",
	pilotTemplate = "medium_fighter_tier3",
	shipType = "fighter",

	experience = 1408,

	lootChance = 0.165,
	lootRolls = 1,
	lootTable = "space_ghrag_tier3",

	minCredits = 150,
	maxCredits = 323,

	aggressive = 1,

	spaceFaction = "ghrag",
	alliedFactions = {"ghrag"},
	enemyFactions = {"imperial", "rebel", "civilian", "merchant", "rsf", "corsec", "hutt", "valarian"},

	pvpBitmask = ATTACKABLE,
	shipBitmask = NONE,
	optionsBitmask = AIENABLED,

	customShipAiMap = "",

	conversationTemplate = "",
	conversationMobile = "object/mobile/shared_space_comm_ghrag_merc_01.iff",
	conversationMessage = "", --Too Far Message
}

ShipAgentTemplates:addShipAgentTemplate(ghrag_merc_tier3, "ghrag_merc_tier3")
