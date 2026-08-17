rod_protector_tier3 = ShipAgent:new {
	template = "blacksun_medium_s02_tier3",
	pilotTemplate = "medium_fighter_tier3",
	shipType = "fighter",

	experience = 1408,

	lootChance = 0.165,
	lootRolls = 1,
	lootTable = "space_civilian_tier3",

	minCredits = 150,
	maxCredits = 323,

	aggressive = 0,

	spaceFaction = "rodian",
	alliedFactions = {"rodian", "civilian", "merchant", "corsec", "rsf"},
	enemyFactions = {"gotal", "chiss", "ghrag", "pirate"},

	pvpBitmask = ATTACKABLE,
	shipBitmask = NONE,
	optionsBitmask = AIENABLED,

	customShipAiMap = "",

	conversationTemplate = "",
	conversationMobile = "object/mobile/shared_space_comm_rod_protector_01.iff",
	conversationMessage = "", --Too Far Message
}

ShipAgentTemplates:addShipAgentTemplate(rod_protector_tier3, "rod_protector_tier3")
