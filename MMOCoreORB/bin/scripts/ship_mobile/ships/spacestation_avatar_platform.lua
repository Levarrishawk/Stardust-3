-- Avatar Platform. No clientpoi row ships for this station - its position is ours,
-- not Live-attested. Hull spacestation_corellia is ours. No avatar-platform comm
-- portrait ships; imperial_officer_01 matches the .stf voice ("You are not
-- authorized to be in this area").
spacestation_avatar_platform = ShipAgent:new {
	template = "spacestation_corellia",
	shipType = "capital",

	lootChance = 0,
	lootRolls = 0,
	lootTable = "space_imperial_tier1",

	minCredits = 791,
	maxCredits = 1300,

	aggressive = 0,

	spaceFaction = "imperial",

	pvpBitmask = NONE,
	shipBitmask = NONE,
	optionsBitmask = AIENABLED + INVULNERABLE,

	customShipAiMap = "spaceStations",

	conversationTemplate = "spacestation_avatar_platform_convotemplate",
	conversationMobile = "object/mobile/shared_space_comm_imperial_officer_01.iff",
	conversationMessage = "@conversation/station_avatar_platform:s_60", -- Too Far Message
}

ShipAgentTemplates:addShipAgentTemplate(spacestation_avatar_platform, "spacestation_avatar_platform")
