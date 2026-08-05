chiss_poacher_tier5 = ShipAgent:new {
	template = "tieaggressor_tier5",
	pilotTemplate = "medium_fighter_tier5",
	shipType = "fighter",

	experience = 10737.42,

	lootChance = 0.208,
	lootRolls = 1,
	lootTable = "space_pirate_tier5",

	minCredits = 465,
	maxCredits = 900,

	aggressive = 1,

	spaceFaction = "chiss",
	alliedFactions = {"chiss"},
	enemyFactions = {"imperial", "rebel", "civilian", "merchant", "rsf", "corsec", "rodian"},

	pvpBitmask = ATTACKABLE,
	shipBitmask = TURRETSHIP,
	optionsBitmask = AIENABLED,

	customShipAiMap = "",

	conversationTemplate = "",
	conversationMobile = "object/mobile/shared_space_comm_chiss_poacher_03.iff",
	conversationMessage = "", --Too Far Message
}

ShipAgentTemplates:addShipAgentTemplate(chiss_poacher_tier5, "chiss_poacher_tier5")
