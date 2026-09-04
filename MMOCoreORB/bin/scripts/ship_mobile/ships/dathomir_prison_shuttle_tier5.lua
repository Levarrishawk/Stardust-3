dathomir_prison_shuttle_tier5 = ShipAgent:new {
	template = "decimator_tier5",
	pilotTemplate = "heavy_tier5",
	shipType = "bomber",

	experience = 13421.77,

	lootChance = 0.26,
	lootRolls = 1,
	lootTable = "space_imperial_tier5",

	minCredits = 465,
	maxCredits = 975,

	aggressive = 0,

	spaceFaction = "imperial",
	alliedFactions = {"corsec", "rsf"},
	imperialFactionReward = -191,
	rebelFactionReward = 96,
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
}

ShipAgentTemplates:addShipAgentTemplate(dathomir_prison_shuttle_tier5, "dathomir_prison_shuttle_tier5")
