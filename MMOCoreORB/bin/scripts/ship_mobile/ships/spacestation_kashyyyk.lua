-- Kashyyyk Space Station - Civilian Protection Guild, commander Rian Ry.
-- clientpoi station_kashyyyk (-5000, 250, -5000).
-- Hull spacestation_neutral is ours - no kashyyyk station hull is registered.
spacestation_kashyyyk = ShipAgent:new {
	template = "spacestation_neutral",
	shipType = "capital",

	lootChance = 0,
	lootRolls = 0,
	lootTable = "space_civilian_tier1",

	minCredits = 791,
	maxCredits = 1300,

	aggressive = 0,

	spaceFaction = "station",

	pvpBitmask = NONE,
	shipBitmask = NONE,
	optionsBitmask = AIENABLED + INVULNERABLE,

	customShipAiMap = "spaceStations",

	conversationTemplate = "spacestation_kashyyyk_convotemplate",
	conversationMobile = "object/mobile/shared_space_comm_rian_ry.iff",
	conversationMessage = "@conversation/station_kashyyyk:s_204", -- Too Far Message
}

ShipAgentTemplates:addShipAgentTemplate(spacestation_kashyyyk, "spacestation_kashyyyk")
