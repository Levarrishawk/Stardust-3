rod_protector_tier5 = ShipAgent:new {
	template = "blacksun_medium_s02_tier5",
	pilotTemplate = "medium_fighter_tier5",
	shipType = "fighter",

	experience = 7381.98,

	lootChance = 0.143,
	lootRolls = 1,
	lootTable = "space_civilian_tier5",

	minCredits = 455,
	maxCredits = 875,

	aggressive = 0,

	spaceFaction = "rodian",
	alliedFactions = {"rodian", "civilian", "merchant", "corsec", "rsf"},
	enemyFactions = {"gotal", "chiss", "ghrag", "pirate"},

	pvpBitmask = ATTACKABLE,
	shipBitmask = NONE,
	optionsBitmask = AIENABLED,

	customShipAiMap = "",

	conversationTemplate = "",
	conversationMobile = "object/mobile/shared_space_comm_rod_protector_03.iff",
	conversationMessage = "", --Too Far Message
}

ShipAgentTemplates:addShipAgentTemplate(rod_protector_tier5, "rod_protector_tier5")
