wke_resist_tier3 = ShipAgent:new {
	template = "bwing_tier3",
	pilotTemplate = "bomber_tier3",
	shipType = "fighter",

	experience = 1536,

	lootChance = 0.18,
	lootRolls = 1,
	lootTable = "space_rebel_tier3",

	minCredits = 160,
	maxCredits = 353,

	aggressive = 0,

	spaceFaction = "wke_resist",
	alliedFactions = {"wke_resist", "rebel", "civilian"},
	enemyFactions = {"imperial", "pirate", "ghrag", "chiss"},

	pvpBitmask = ATTACKABLE,
	shipBitmask = NONE,
	optionsBitmask = AIENABLED,

	customShipAiMap = "",

	conversationTemplate = "",
	conversationMobile = "object/mobile/shared_space_comm_wke_resist_01.iff",
	conversationMessage = "", --Too Far Message
}

ShipAgentTemplates:addShipAgentTemplate(wke_resist_tier3, "wke_resist_tier3")
