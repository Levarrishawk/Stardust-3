-- Chiss Poachers' Base - clientpoi kashyyyk_chiss_poacher_base
-- (-6825, 763, 2065). Hostile: no conversation ships for this base.
-- Hull spacestation_yavin4 is ours.
station_chiss_poacher_base = ShipAgent:new {
	template = "spacestation_yavin4",
	shipType = "capital",

	lootChance = 0,
	lootRolls = 0,
	lootTable = "space_pirate_tier1",

	minCredits = 10000,
	maxCredits = 20000,

	aggressive = 0,

	spaceFaction = "chiss",
	alliedFactions = {"chiss"},
	enemyFactions = {"imperial", "rebel", "civilian", "merchant", "rsf", "corsec", "rodian"},

	pvpBitmask = ATTACKABLE,
	shipBitmask = NONE,
	optionsBitmask = AIENABLED,

	customShipAiMap = "attackableSpaceStations",

	conversationTemplate = "",
	conversationMobile = "",
	conversationMessage = "", -- Too Far Message
}

ShipAgentTemplates:addShipAgentTemplate(station_chiss_poacher_base, "station_chiss_poacher_base")
