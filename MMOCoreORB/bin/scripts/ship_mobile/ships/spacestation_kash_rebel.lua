-- Kashyyyk Rebel Outpost. No clientpoi row ships for this station - its position
-- is ours, not Live-attested. Hull spacestation_rebel is ours.
spacestation_kash_rebel = ShipAgent:new {
	template = "spacestation_rebel",
	shipType = "capital",

	lootChance = 0,
	lootRolls = 0,
	lootTable = "space_rebel_tier1",

	minCredits = 10000,
	maxCredits = 20000,

	aggressive = 0,

	spaceFaction = "rebel",
	imperialFactionReward = 200,
	rebelFactionReward = -500,

	pvpBitmask = NONE,
	shipBitmask = NONE,
	optionsBitmask = AIENABLED + INVULNERABLE,

	customShipAiMap = "spaceStations",

	conversationTemplate = "spacestation_kash_rebel_convotemplate",
	conversationMobile = "object/mobile/shared_space_comm_kash_reb_base.iff",
	conversationMessage = "@conversation/station_rebel_outpost:s_727", -- Too Far Message
}

ShipAgentTemplates:addShipAgentTemplate(spacestation_kash_rebel, "spacestation_kash_rebel")
