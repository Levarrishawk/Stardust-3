wke_resist_tier5 = ShipAgent:new {
	template = "bwing_tier5",
	pilotTemplate = "bomber_tier5",
	shipType = "fighter",

	experience = 8053.06,

	lootChance = 0.156,
	lootRolls = 1,
	lootTable = "space_rebel_tier5",

	minCredits = 465,
	maxCredits = 900,

	aggressive = 0,

	spaceFaction = "wke_resist",
	alliedFactions = {"wke_resist", "rebel", "civilian"},
	enemyFactions = {"imperial", "pirate", "ghrag", "chiss"},

	pvpBitmask = ATTACKABLE,
	shipBitmask = NONE,
	optionsBitmask = AIENABLED,

	customShipAiMap = "",

	conversationTemplate = "",
	conversationMobile = "object/mobile/shared_space_comm_wke_resist_03.iff",
	conversationMessage = "", --Too Far Message
}

ShipAgentTemplates:addShipAgentTemplate(wke_resist_tier5, "wke_resist_tier5")
