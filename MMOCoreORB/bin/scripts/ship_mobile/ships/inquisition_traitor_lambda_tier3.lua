inquisition_traitor_lambda_tier3 = ShipAgent:new {
	template = "lambdashuttle_tier3",
	pilotTemplate = "bomber_tier3",
	shipType = "transport",

	experience = 3200,

	lootChance = 0.375,
	lootRolls = 1,
	lootTable = "space_blacksun_tier3",

	minCredits = 150,
	maxCredits = 736,

	aggressive = 1,

	spaceFaction = "blacksun",
	alliedFactions = {"blacksun"},
	enemyFactions = {"imperial", "rebel", "civilian", "merchant", "rsf", "corsec", "hutt", "valarian", "nym"},
	imperialFactionReward = 32,
	rebelFactionReward = -64,
	appearance = "imperial_officer",

	tauntType = "blacksun",
	tauntAttackChance = 0.1,
	tauntDefendChance = 0.05,
	tauntDieChance = 0.1,

	pvpBitmask = ATTACKABLE,
	shipBitmask = TURRETSHIP,
	optionsBitmask = AIENABLED,

	customShipAiMap = "",

	conversationTemplate = "",
	conversationMobile = "",
	conversationMessage = "", --Too Far Message
}

ShipAgentTemplates:addShipAgentTemplate(inquisition_traitor_lambda_tier3, "inquisition_traitor_lambda_tier3")
