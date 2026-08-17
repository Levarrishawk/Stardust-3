trn_slaver_barge_tier3 = ShipAgent:new {
	template = "ywing_tier3",
	pilotTemplate = "bomber_tier3",
	shipType = "bomber",

	experience = 1344,

	lootChance = 0.1575,
	lootRolls = 1,
	lootTable = "space_pirate_tier3",

	minCredits = 150,
	maxCredits = 309,

	aggressive = 0,

	spaceFaction = "pirate",
	alliedFactions = {"pirate"},
	enemyFactions = {"imperial", "merchant", "civilian"},

	pvpBitmask = ATTACKABLE,
	shipBitmask = NONE,
	optionsBitmask = AIENABLED,

	customShipAiMap = "",

	conversationTemplate = "",
	conversationMobile = "object/mobile/shared_space_comm_trn_slaver_01.iff",
	conversationMessage = "", --Too Far Message
}

ShipAgentTemplates:addShipAgentTemplate(trn_slaver_barge_tier3, "trn_slaver_barge_tier3")
