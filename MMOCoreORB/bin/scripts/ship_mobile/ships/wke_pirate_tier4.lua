wke_pirate_tier4 = ShipAgent:new {
	template = "ykl37r_tier4",
	pilotTemplate = "heavy_tier4",
	shipType = "fighter",

	experience = 6553.6,

	lootChance = 0.28,
	lootRolls = 1,
	lootTable = "space_pirate_tier4",

	minCredits = 400,
	maxCredits = 800,

	aggressive = 1,

	spaceFaction = "wke_pirate",
	alliedFactions = {"wke_pirate"},
	enemyFactions = {"imperial", "rebel", "civilian", "merchant", "rsf", "corsec"},

	pvpBitmask = ATTACKABLE,
	shipBitmask = TURRETSHIP,
	optionsBitmask = AIENABLED,

	customShipAiMap = "",

	conversationTemplate = "",
	conversationMobile = "object/mobile/shared_space_comm_wke_pirate_02.iff",
	conversationMessage = "", --Too Far Message
}

ShipAgentTemplates:addShipAgentTemplate(wke_pirate_tier4, "wke_pirate_tier4")
