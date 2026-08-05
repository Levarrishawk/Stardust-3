wke_resist_tier4 = ShipAgent:new {
	template = "bwing_tier4",
	pilotTemplate = "bomber_tier4",
	shipType = "fighter",

	experience = 3932.16,

	lootChance = 0.168,
	lootRolls = 1,
	lootTable = "space_rebel_tier4",

	minCredits = 275,
	maxCredits = 600,

	aggressive = 0,

	spaceFaction = "wke_resist",
	alliedFactions = {"wke_resist", "rebel", "civilian"},
	enemyFactions = {"imperial", "pirate", "ghrag", "chiss"},

	pvpBitmask = ATTACKABLE,
	shipBitmask = NONE,
	optionsBitmask = AIENABLED,

	customShipAiMap = "",

	conversationTemplate = "",
	conversationMobile = "object/mobile/shared_space_comm_wke_resist_02.iff",
	conversationMessage = "", --Too Far Message
}

ShipAgentTemplates:addShipAgentTemplate(wke_resist_tier4, "wke_resist_tier4")
