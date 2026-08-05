wke_pirate_tier3 = ShipAgent:new {
	template = "ykl37r_tier3",
	pilotTemplate = "heavy_tier3",
	shipType = "fighter",

	experience = 2560,

	lootChance = 0.3,
	lootRolls = 1,
	lootTable = "space_pirate_tier3",

	minCredits = 200,
	maxCredits = 480,

	aggressive = 1,

	spaceFaction = "wke_pirate",
	alliedFactions = {"wke_pirate"},
	enemyFactions = {"imperial", "rebel", "civilian", "merchant", "rsf", "corsec"},

	pvpBitmask = ATTACKABLE,
	shipBitmask = TURRETSHIP,
	optionsBitmask = AIENABLED,

	customShipAiMap = "",

	conversationTemplate = "",
	conversationMobile = "object/mobile/shared_space_comm_wke_pirate_01.iff",
	conversationMessage = "", --Too Far Message
}

ShipAgentTemplates:addShipAgentTemplate(wke_pirate_tier3, "wke_pirate_tier3")
