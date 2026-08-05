-- Independent Slavers' Base - clientpoi kashyyyk_independent_slavers
-- (-6830, -350, 4200). Hull spacestation_rori is ours. No independent-slaver comm
-- portrait ships; trn_slaver_01 is the nearest shipped slaver portrait.
spacestation_indie_slaver = ShipAgent:new {
	template = "spacestation_rori",
	shipType = "capital",

	lootChance = 0,
	lootRolls = 0,
	lootTable = "space_pirate_tier1",

	minCredits = 791,
	maxCredits = 1300,

	aggressive = 0,

	spaceFaction = "pirate",
	alliedFactions = {"pirate"},
	enemyFactions = {"imperial", "merchant", "civilian"},

	pvpBitmask = NONE,
	shipBitmask = NONE,
	optionsBitmask = AIENABLED + INVULNERABLE,

	customShipAiMap = "spaceStations",

	conversationTemplate = "spacestation_indie_slaver_convotemplate",
	conversationMobile = "object/mobile/shared_space_comm_trn_slaver_01.iff",
	conversationMessage = "@conversation/station_indie_slaver:s_204", -- Too Far Message
}

ShipAgentTemplates:addShipAgentTemplate(spacestation_indie_slaver, "spacestation_indie_slaver")
