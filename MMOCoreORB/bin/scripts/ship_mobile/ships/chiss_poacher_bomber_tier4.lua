chiss_poacher_bomber_tier4 = ShipAgent:new {
	template = "tieoppressor_tier4",
	pilotTemplate = "light_fighter_tier4",
	shipType = "bomber",

	experience = 3604.48,

	lootChance = 0.154,
	lootRolls = 1,
	lootTable = "space_pirate_tier4",

	minCredits = 260,
	maxCredits = 575,

	aggressive = 1,

	spaceFaction = "chiss",
	alliedFactions = {"chiss"},
	enemyFactions = {"imperial", "rebel", "civilian", "merchant", "rsf", "corsec", "rodian"},

	pvpBitmask = ATTACKABLE,
	shipBitmask = NONE,
	optionsBitmask = AIENABLED,

	customShipAiMap = "",

	conversationTemplate = "",
	conversationMobile = "object/mobile/shared_space_comm_chiss_poacher_04.iff",
	conversationMessage = "", --Too Far Message
}

ShipAgentTemplates:addShipAgentTemplate(chiss_poacher_bomber_tier4, "chiss_poacher_bomber_tier4")
