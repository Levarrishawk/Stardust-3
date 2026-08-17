ghrag_persuader_tier4 = ShipAgent:new {
	template = "blacksun_light_s04_tier4",
	pilotTemplate = "light_fighter_tier4",
	shipType = "fighter",

	experience = 3276.8,

	lootChance = 0.14,
	lootRolls = 1,
	lootTable = "space_ghrag_tier4",

	minCredits = 225,
	maxCredits = 525,

	aggressive = 1,

	spaceFaction = "ghrag",
	alliedFactions = {"ghrag"},
	enemyFactions = {"imperial", "rebel", "civilian", "merchant", "rsf", "corsec", "hutt", "valarian"},

	pvpBitmask = ATTACKABLE,
	shipBitmask = NONE,
	optionsBitmask = AIENABLED,

	customShipAiMap = "",

	conversationTemplate = "",
	conversationMobile = "object/mobile/shared_space_comm_ghrag_persuader_02.iff",
	conversationMessage = "", --Too Far Message
}

ShipAgentTemplates:addShipAgentTemplate(ghrag_persuader_tier4, "ghrag_persuader_tier4")
