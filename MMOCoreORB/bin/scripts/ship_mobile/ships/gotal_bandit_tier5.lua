gotal_bandit_tier5 = ShipAgent:new {
	template = "blacksun_light_s03_tier5",
	pilotTemplate = "light_fighter_tier5",
	shipType = "fighter",

	experience = 6710.89,

	lootChance = 0.13,
	lootRolls = 1,
	lootTable = "space_pirate_tier5",

	minCredits = 425,
	maxCredits = 825,

	aggressive = 1,

	spaceFaction = "gotal",
	alliedFactions = {"gotal"},
	enemyFactions = {"imperial", "rebel", "civilian", "merchant", "rsf", "corsec", "rodian"},

	pvpBitmask = ATTACKABLE,
	shipBitmask = NONE,
	optionsBitmask = AIENABLED,

	customShipAiMap = "",

	conversationTemplate = "",
	conversationMobile = "object/mobile/shared_space_comm_gotal_bandit_03.iff",
	conversationMessage = "", --Too Far Message
}

ShipAgentTemplates:addShipAgentTemplate(gotal_bandit_tier5, "gotal_bandit_tier5")
