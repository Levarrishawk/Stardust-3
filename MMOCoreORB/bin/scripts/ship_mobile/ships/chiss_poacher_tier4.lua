chiss_poacher_tier4 = ShipAgent:new {
	template = "tieaggressor_tier4",
	pilotTemplate = "medium_fighter_tier4",
	shipType = "fighter",

	experience = 5242.88,

	lootChance = 0.224,
	lootRolls = 1,
	lootTable = "space_pirate_tier4",

	minCredits = 275,
	maxCredits = 600,

	aggressive = 1,

	spaceFaction = "chiss",
	alliedFactions = {"chiss"},
	enemyFactions = {"imperial", "rebel", "civilian", "merchant", "rsf", "corsec", "rodian"},

	pvpBitmask = ATTACKABLE,
	shipBitmask = TURRETSHIP,
	optionsBitmask = AIENABLED,

	customShipAiMap = "",

	conversationTemplate = "",
	conversationMobile = "object/mobile/shared_space_comm_chiss_poacher_02.iff",
	conversationMessage = "", --Too Far Message
}

ShipAgentTemplates:addShipAgentTemplate(chiss_poacher_tier4, "chiss_poacher_tier4")
