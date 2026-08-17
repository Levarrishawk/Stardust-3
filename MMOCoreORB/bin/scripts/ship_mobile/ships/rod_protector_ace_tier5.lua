rod_protector_ace_tier5 = ShipAgent:new {
	template = "blacksun_light_s02_tier5",
	pilotTemplate = "light_fighter_tier5",
	shipType = "fighter",

	experience = 6710.89,

	lootChance = 0.13,
	lootRolls = 1,
	lootTable = "space_civilian_tier5",

	minCredits = 425,
	maxCredits = 825,

	aggressive = 0,

	spaceFaction = "rodian",
	alliedFactions = {"rodian", "civilian", "merchant", "corsec", "rsf"},
	enemyFactions = {"gotal", "chiss", "ghrag", "pirate"},

	pvpBitmask = ATTACKABLE,
	shipBitmask = NONE,
	optionsBitmask = AIENABLED,

	customShipAiMap = "",

	conversationTemplate = "",
	conversationMobile = "object/mobile/shared_space_comm_rod_protector_04.iff",
	conversationMessage = "", --Too Far Message
}

ShipAgentTemplates:addShipAgentTemplate(rod_protector_ace_tier5, "rod_protector_ace_tier5")
