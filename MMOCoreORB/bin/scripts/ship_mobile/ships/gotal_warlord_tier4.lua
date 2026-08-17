gotal_warlord_tier4 = ShipAgent:new {
	template = "decimator_tier4",
	pilotTemplate = "heavy_tier4",
	shipType = "bomber",

	experience = 6553.6,

	lootChance = 0.28,
	lootRolls = 1,
	lootTable = "space_pirate_tier4",

	minCredits = 400,
	maxCredits = 800,

	aggressive = 1,

	spaceFaction = "gotal",
	alliedFactions = {"gotal"},
	enemyFactions = {"imperial", "rebel", "civilian", "merchant", "rsf", "corsec", "rodian"},

	pvpBitmask = ATTACKABLE,
	shipBitmask = TURRETSHIP,
	optionsBitmask = AIENABLED,

	customShipAiMap = "",

	conversationTemplate = "",
	conversationMobile = "object/mobile/shared_space_comm_gotal_warlord_01.iff",
	conversationMessage = "", --Too Far Message
}

ShipAgentTemplates:addShipAgentTemplate(gotal_warlord_tier4, "gotal_warlord_tier4")
