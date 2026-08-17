spacestation_imperial = ShipAgent:new {
	template = "spacestation_imperial",
	shipType = "capital",

	experience = 50000,

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
	appearance = "imperial_officer",
	tauntAttackChance = 0.1,
	tauntDefendChance = 0.05,
	tauntDieChance = 0.1,

	pvpBitmask = ATTACKABLE,
	shipBitmask = NONE,
	optionsBitmask = AIENABLED,

	customShipAiMap = "attackableSpaceStations",

	conversationTemplate = "spacestation_imperial_convotemplate",
	conversationMobile = "object/mobile/shared_space_comm_imperial_officer_01.iff",
	conversationMessage = "@conversation/pvp_station_imperial:s_48f82131", -- Too Far Message
}

ShipAgentTemplates:addShipAgentTemplate(spacestation_imperial, "spacestation_imperial")
