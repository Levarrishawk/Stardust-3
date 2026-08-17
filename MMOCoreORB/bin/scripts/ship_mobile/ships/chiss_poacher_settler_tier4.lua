-- Chiss settler landing craft - station_rodian_tripp_base.stf s_188 names the
-- "settler ships" and "landing craft" that the Tripp contract intercepts.
chiss_poacher_settler_tier4 = ShipAgent:new {
	template = "merchant_cruiser_light_tier4",
	pilotTemplate = "slow_tier4",
	shipType = "transport",

	experience = 0,

	lootChance = 0,
	lootRolls = 0,
	lootTable = "space_pirate_tier4",

	minCredits = 16,
	maxCredits = 200,

	aggressive = 0,

	spaceFaction = "chiss",
	alliedFactions = {"chiss"},
	enemyFactions = {"imperial", "rebel", "civilian", "merchant", "rsf", "corsec", "rodian"},

	pvpBitmask = ATTACKABLE,
	shipBitmask = NONE,
	optionsBitmask = AIENABLED,

	customShipAiMap = "",

	conversationTemplate = "",
	conversationMobile = "object/mobile/shared_space_comm_chiss_poacher_06.iff",
	conversationMessage = "", --Too Far Message
}

ShipAgentTemplates:addShipAgentTemplate(chiss_poacher_settler_tier4, "chiss_poacher_settler_tier4")
