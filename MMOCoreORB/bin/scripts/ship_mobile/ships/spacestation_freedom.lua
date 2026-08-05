spacestation_freedom = ShipAgent:new {
	template = "spacestation_freedom",
	pilotTemplate = "heavy_tier5",
	shipType = "capital",

	-- Matches spacestation_rebel / spacestation_imperial, the only other attackableSpaceStations
	-- entries that declare experience. ShipAgentTemplate.cpp:19 defaults this to 0, so the old
	-- "experience = 0" was indistinguishable from an unfilled field, and it left a destroyable
	-- station awarding zero pilot XP (PlayerManagerImplementation.cpp:2335). Value is ours.
	experience = 50000,

	lootChance = 0,
	lootRolls = 0,
	lootTable = "space_rebel_tier1",

	minCredits = 10000,
	maxCredits = 20000,

	aggressive = 0,

	spaceFaction = "rebel",
	alliedFactions = {"nym", "rebel"},
	enemyFactions = {"imperial", "blacksun", "borvo", "hutt", "pirate", "aynat"},
	imperialFactionReward = 200,
	rebelFactionReward = -500,
	appearance = "rebel_officer",
	tauntAttackChance = 0.1,
	tauntDefendChance = 0.05,
	tauntDieChance = 0.1,

	pvpBitmask = ATTACKABLE,
	shipBitmask = TURRETSHIP,
	optionsBitmask = AIENABLED,

	customShipAiMap = "attackableSpaceStations",

	conversationTemplate = "",
	conversationMobile = "",
	conversationMessage = "", -- Too Far Message
}

ShipAgentTemplates:addShipAgentTemplate(spacestation_freedom, "spacestation_freedom")
