wke_pirate_tier5 = ShipAgent:new {
	template = "ykl37r_tier5",
	pilotTemplate = "heavy_tier5",
	shipType = "fighter",

	experience = 13421.77,

	lootChance = 0.26,
	lootRolls = 1,
	lootTable = "space_pirate_tier5",

	minCredits = 465,
	maxCredits = 975,

	aggressive = 1,

	spaceFaction = "wke_pirate",
	alliedFactions = {"wke_pirate"},
	enemyFactions = {"imperial", "rebel", "civilian", "merchant", "rsf", "corsec"},

	pvpBitmask = ATTACKABLE,
	shipBitmask = TURRETSHIP,
	optionsBitmask = AIENABLED,

	customShipAiMap = "",

	conversationTemplate = "",
	conversationMobile = "object/mobile/shared_space_comm_wke_pirate_03.iff",
	conversationMessage = "", --Too Far Message
}

ShipAgentTemplates:addShipAgentTemplate(wke_pirate_tier5, "wke_pirate_tier5")
