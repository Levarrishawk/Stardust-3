-- Kashyyyk Imperial Overseers Base. No clientpoi row ships for this station - its
-- position is ours, not Live-attested. Hull spacestation_imperial is ours.
spacestation_kash_imperial = ShipAgent:new {
	template = "spacestation_imperial",
	shipType = "capital",

	lootChance = 0,
	lootRolls = 0,
	lootTable = "space_imperial_tier1",

	minCredits = 10000,
	maxCredits = 20000,

	aggressive = 0,

	spaceFaction = "imperial",
	alliedFactions = {"rsf"},
	imperialFactionReward = -100,
	rebelFactionReward = 250,

	pvpBitmask = NONE,
	shipBitmask = NONE,
	optionsBitmask = AIENABLED + INVULNERABLE,

	customShipAiMap = "spaceStations",

	conversationTemplate = "spacestation_kash_imperial_convotemplate",
	conversationMobile = "object/mobile/shared_space_comm_kash_imp_base.iff",
	conversationMessage = "@conversation/station_imperial_base:s_48f82131", -- Too Far Message
}

ShipAgentTemplates:addShipAgentTemplate(spacestation_kash_imperial, "spacestation_kash_imperial")
