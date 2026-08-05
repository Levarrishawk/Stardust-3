-- The Gotal Pirates' Base - clientpoi kashyyyk_gotal_pirate_base
-- (-5950, 2700, 4575). Hostile: no conversation ships for this base.
-- Hull spacestation_talus is ours.
station_gotal_pirate_base = ShipAgent:new {
	template = "spacestation_talus",
	shipType = "capital",

	lootChance = 0,
	lootRolls = 0,
	lootTable = "space_pirate_tier1",

	minCredits = 10000,
	maxCredits = 20000,

	aggressive = 0,

	spaceFaction = "gotal",
	alliedFactions = {"gotal"},
	enemyFactions = {"imperial", "rebel", "civilian", "merchant", "rsf", "corsec", "rodian"},

	pvpBitmask = ATTACKABLE,
	shipBitmask = NONE,
	optionsBitmask = AIENABLED,

	customShipAiMap = "attackableSpaceStations",

	conversationTemplate = "",
	conversationMobile = "",
	conversationMessage = "", -- Too Far Message
}

ShipAgentTemplates:addShipAgentTemplate(station_gotal_pirate_base, "station_gotal_pirate_base")
