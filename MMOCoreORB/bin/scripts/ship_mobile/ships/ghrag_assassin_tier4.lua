ghrag_assassin_tier4 = ShipAgent:new {
	template = "firespray_tier4",
	pilotTemplate = "heavy_fighter_tier4",
	shipType = "fighter",

	experience = 4259.84,

	lootChance = 0.182,
	lootRolls = 1,
	lootTable = "space_ghrag_tier4",

	minCredits = 280,
	maxCredits = 650,

	aggressive = 1,

	spaceFaction = "ghrag",
	alliedFactions = {"ghrag"},
	enemyFactions = {"imperial", "rebel", "civilian", "merchant", "rsf", "corsec", "hutt", "valarian"},

	pvpBitmask = ATTACKABLE,
	shipBitmask = NONE,
	optionsBitmask = AIENABLED,

	customShipAiMap = "",

	conversationTemplate = "",
	conversationMobile = "object/mobile/shared_space_comm_ghrag_assassin_01.iff",
	conversationMessage = "", --Too Far Message
}

ShipAgentTemplates:addShipAgentTemplate(ghrag_assassin_tier4, "ghrag_assassin_tier4")
