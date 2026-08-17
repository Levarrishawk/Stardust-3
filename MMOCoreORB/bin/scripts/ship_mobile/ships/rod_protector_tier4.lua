rod_protector_tier4 = ShipAgent:new {
	template = "blacksun_medium_s02_tier4",
	pilotTemplate = "medium_fighter_tier4",
	shipType = "fighter",

	experience = 3604.48,

	lootChance = 0.154,
	lootRolls = 1,
	lootTable = "space_civilian_tier4",

	minCredits = 260,
	maxCredits = 575,

	aggressive = 0,

	spaceFaction = "rodian",
	alliedFactions = {"rodian", "civilian", "merchant", "corsec", "rsf"},
	enemyFactions = {"gotal", "chiss", "ghrag", "pirate"},

	pvpBitmask = ATTACKABLE,
	shipBitmask = NONE,
	optionsBitmask = AIENABLED,

	customShipAiMap = "",

	conversationTemplate = "",
	conversationMobile = "object/mobile/shared_space_comm_rod_protector_02.iff",
	conversationMessage = "", --Too Far Message
}

ShipAgentTemplates:addShipAgentTemplate(rod_protector_tier4, "rod_protector_tier4")
