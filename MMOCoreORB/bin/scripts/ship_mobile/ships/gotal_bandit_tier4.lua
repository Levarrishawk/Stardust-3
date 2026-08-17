gotal_bandit_tier4 = ShipAgent:new {
	template = "blacksun_light_s03_tier4",
	pilotTemplate = "light_fighter_tier4",
	shipType = "fighter",

	experience = 3276.8,

	lootChance = 0.14,
	lootRolls = 1,
	lootTable = "space_pirate_tier4",

	minCredits = 225,
	maxCredits = 525,

	aggressive = 1,

	spaceFaction = "gotal",
	alliedFactions = {"gotal"},
	enemyFactions = {"imperial", "rebel", "civilian", "merchant", "rsf", "corsec", "rodian"},

	pvpBitmask = ATTACKABLE,
	shipBitmask = NONE,
	optionsBitmask = AIENABLED,

	customShipAiMap = "",

	conversationTemplate = "",
	conversationMobile = "object/mobile/shared_space_comm_gotal_bandit_02.iff",
	conversationMessage = "", --Too Far Message
}

ShipAgentTemplates:addShipAgentTemplate(gotal_bandit_tier4, "gotal_bandit_tier4")
