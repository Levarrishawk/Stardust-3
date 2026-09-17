smuggler_imperial_patrol_fighter_tier2 = ShipAgent:new {
	template = "tiefighter_tier2",
	pilotTemplate = "light_fighter_tier2",
	shipType = "fighter",

	experience = 400,

	lootChance = 0.16,
	lootRolls = 1,
	lootTable = "space_imperial_tier2",

	minCredits = 70,
	maxCredits = 140,

	aggressive = 1,

	-- A mission-local hostile faction allows privateer pilots to engage these
	-- Imperial-looking ships without changing every Imperial TIE globally.
	spaceFaction = "blacksun",
	alliedFactions = {"blacksun"},
	enemyFactions = {"imperial", "rebel", "civilian", "merchant", "rsf", "corsec", "hutt", "valarian", "nym"},
	imperialFactionReward = -10,
	rebelFactionReward = 5,
	formationLocation = 2,
	appearance = "imperial_pilot",

	tauntType = "imperial_low",
	tauntAttackChance = 0.1,
	tauntDefendChance = 0.05,
	tauntDieChance = 0.1,

	pvpBitmask = ATTACKABLE,
	shipBitmask = NONE,
	optionsBitmask = AIENABLED,

	customShipAiMap = "",

	conversationTemplate = "",
	conversationMobile = "",
	conversationMessage = "",
}

ShipAgentTemplates:addShipAgentTemplate(smuggler_imperial_patrol_fighter_tier2, "smuggler_imperial_patrol_fighter_tier2")
