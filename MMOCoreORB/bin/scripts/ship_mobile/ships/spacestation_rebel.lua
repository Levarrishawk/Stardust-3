spacestation_rebel = ShipAgent:new {
	template = "spacestation_rebel",
	shipType = "capital",

	experience = 50000,

	lootChance = 0,
	lootRolls = 0,
	lootTable = "space_rebel_tier1",

	minCredits = 10000,
	maxCredits = 20000,

	aggressive = 0,

	spaceFaction = "rebel",
	imperialFactionReward = 200,
	rebelFactionReward = -500,
	appearance = "rebel_officer",
	tauntAttackChance = 0.1,
	tauntDefendChance = 0.05,
	tauntDieChance = 0.1,

	pvpBitmask = ATTACKABLE,
	shipBitmask = NONE,
	optionsBitmask = AIENABLED,

	customShipAiMap = "attackableSpaceStations",

	conversationTemplate = "spacestation_rebel_convotemplate",
	conversationMobile = "object/mobile/shared_space_comm_rebel_transport_01.iff",
	conversationMessage = "@conversation/pvp_station_rebel:s_48f82131", -- Too Far Message
}

ShipAgentTemplates:addShipAgentTemplate(spacestation_rebel, "spacestation_rebel")
