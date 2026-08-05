ghrag_avenger_tier5 = ShipAgent:new {
	template = "smuggler_warlord_ship_tier5",
	pilotTemplate = "slow_tier5",
	shipType = "capital",

	experience = 26843.55,

	lootChance = 0.52,
	lootRolls = 1,
	lootTable = "space_ghrag_tier5",

	minCredits = 617,
	maxCredits = 1100,

	aggressive = 1,

	spaceFaction = "ghrag",
	alliedFactions = {"ghrag"},
	enemyFactions = {"imperial", "rebel", "civilian", "merchant", "rsf", "corsec", "hutt", "valarian"},

	pvpBitmask = ATTACKABLE,
	shipBitmask = TURRETSHIP,
	optionsBitmask = AIENABLED,

	customShipAiMap = "",

	conversationTemplate = "",
	conversationMobile = "object/mobile/shared_space_comm_ghrag_avenger_02.iff",
	conversationMessage = "", --Too Far Message
}

ShipAgentTemplates:addShipAgentTemplate(ghrag_avenger_tier5, "ghrag_avenger_tier5")
