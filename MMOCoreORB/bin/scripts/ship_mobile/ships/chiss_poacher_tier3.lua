chiss_poacher_tier3 = ShipAgent:new {
	template = "tieaggressor_tier3",
	pilotTemplate = "medium_fighter_tier3",
	shipType = "fighter",

	experience = 2048,

	lootChance = 0.24,
	lootRolls = 1,
	lootTable = "space_pirate_tier3",

	minCredits = 160,
	maxCredits = 353,

	aggressive = 1,

	spaceFaction = "chiss",
	alliedFactions = {"chiss"},
	enemyFactions = {"imperial", "rebel", "civilian", "merchant", "rsf", "corsec", "rodian"},

	pvpBitmask = ATTACKABLE,
	shipBitmask = TURRETSHIP,
	optionsBitmask = AIENABLED,

	customShipAiMap = "",

	conversationTemplate = "",
	conversationMobile = "object/mobile/shared_space_comm_chiss_poacher_01.iff",
	conversationMessage = "", --Too Far Message
}

ShipAgentTemplates:addShipAgentTemplate(chiss_poacher_tier3, "chiss_poacher_tier3")
