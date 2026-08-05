-- Tripp's Rodian Hunter Outpost - clientpoi kashyyyk_tripp_outpost
-- (-2618, 70, 2624). Hull spacestation_dathomir is ours.
spacestation_rodian_tripp_base = ShipAgent:new {
	template = "spacestation_dathomir",
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

	conversationTemplate = "spacestation_rodian_tripp_base_convotemplate",
	conversationMobile = "object/mobile/shared_space_comm_rod_protector_02.iff",
	conversationMessage = "@conversation/station_rodian_tripp_base:s_204", -- Too Far Message
}

ShipAgentTemplates:addShipAgentTemplate(spacestation_rodian_tripp_base, "spacestation_rodian_tripp_base")
