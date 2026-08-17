-- Sordaan's Rodian Hunter Outpost - clientpoi kashyyyk_sordaan_outpost
-- (2556, 3225, 3890). Hull spacestation_lok is ours.
spacestation_rodian_base = ShipAgent:new {
	template = "spacestation_lok",
	shipType = "capital",

	lootChance = 0,
	lootRolls = 0,
	lootTable = "space_civilian_tier1",

	minCredits = 791,
	maxCredits = 1300,

	aggressive = 0,

	spaceFaction = "rodian",
	alliedFactions = {"rodian", "civilian", "merchant"},
	enemyFactions = {"gotal", "chiss", "ghrag", "pirate"},

	pvpBitmask = NONE,
	shipBitmask = NONE,
	optionsBitmask = AIENABLED + INVULNERABLE,

	customShipAiMap = "spaceStations",

	conversationTemplate = "spacestation_rodian_base_convotemplate",
	conversationMobile = "object/mobile/shared_space_comm_rod_protector_01.iff",
	conversationMessage = "@conversation/station_rodian_base:s_204", -- Too Far Message
}

ShipAgentTemplates:addShipAgentTemplate(spacestation_rodian_base, "spacestation_rodian_base")
