gotal_bandit_tier3 = ShipAgent:new {
	template = "blacksun_light_s03_tier3",
	pilotTemplate = "light_fighter_tier3",
	shipType = "fighter",

	experience = 1280,

	lootChance = 0.15,
	lootRolls = 1,
	lootTable = "space_pirate_tier3",

	minCredits = 120,
	maxCredits = 294,

	aggressive = 1,

	spaceFaction = "gotal",
	alliedFactions = {"gotal"},
	enemyFactions = {"imperial", "rebel", "civilian", "merchant", "rsf", "corsec", "rodian"},

	pvpBitmask = ATTACKABLE,
	shipBitmask = NONE,
	optionsBitmask = AIENABLED,

	customShipAiMap = "",

	conversationTemplate = "",
	conversationMobile = "object/mobile/shared_space_comm_gotal_bandit_01.iff",
	conversationMessage = "", --Too Far Message
}

ShipAgentTemplates:addShipAgentTemplate(gotal_bandit_tier3, "gotal_bandit_tier3")
