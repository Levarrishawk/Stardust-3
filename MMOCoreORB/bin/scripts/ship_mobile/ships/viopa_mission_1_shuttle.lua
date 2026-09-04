viopa_mission_1_shuttle = ShipAgent:new {
	template = "lambdashuttle_tier2",
	pilotTemplate = "bomber_tier2",
	shipType = "bomber",

	experience = 1000,

	lootChance = 0.4,
	lootRolls = 1,
	lootTable = "space_imperial_tier2",

	minCredits = 18,
	maxCredits = 230,

	aggressive = 0,

	-- This is an Imperial shuttle captured and operated by pirates.  Keeping the
	-- ship in the Imperial space faction prevents Imperial pilots from attacking
	-- it during the disable-and-inspect mission.
	spaceFaction = "pirate",
	alliedFactions = {"pirate"},
	enemyFactions = {"imperial", "rebel", "civilian", "merchant", "rsf", "corsec", "hutt", "valarian"},
	imperialFactionReward = -25,
	rebelFactionReward = 13,
	questLoot = "viopa_rebel_1",
	appearance = "imperial_officer",
	tauntAttackChance = 0.1,
	tauntDefendChance = 0.05,
	tauntDieChance = 0.1,

	pvpBitmask = ATTACKABLE,
	shipBitmask = TURRETSHIP,
	optionsBitmask = AIENABLED,

	customShipAiMap = "",

	conversationTemplate = "",
	conversationMobile = "",
	conversationMessage = "", --Too Far Message

	cargoString = "imperial_data",
}

ShipAgentTemplates:addShipAgentTemplate(viopa_mission_1_shuttle, "viopa_mission_1_shuttle")
