-- Ship agents for the Resistance flights and pirate capital convoys in the Kashyyyk buildout.
local resistance = ShipAgent:new {
	lootRolls = 1,
	lootTable = "space_rebel_tier3",
	aggressive = 0,
	spaceFaction = "resistance",
	alliedFactions = {"resistance"},
	enemyFactions = {"blackscale", "pirate"},
	appearance = "wookiee_pilot",
	pvpBitmask = ATTACKABLE,
	optionsBitmask = AIENABLED,
}

ShipAgentTemplates:addShipAgentTemplate(resistance:new {
	template = "awing_tier3",
	pilotTemplate = "light_fighter_tier3",
	shipType = "fighter",
	experience = 1152,
	lootChance = 0.135,
	minCredits = 105,
	maxCredits = 264,
	color1 = 39,
	color2 = 45,
	texture = 2,
}, "ep3_wookiee_resistance_fighter")

ShipAgentTemplates:addShipAgentTemplate(resistance:new {
	template = "xwing_tier3",
	pilotTemplate = "medium_fighter_tier3",
	shipType = "fighter",
	experience = 1408,
	lootChance = 0.165,
	minCredits = 150,
	maxCredits = 323,
	color1 = 17,
	color2 = 14,
	texture = 2,
}, "ep3_wookiee_resistance_commander")

ShipAgentTemplates:addShipAgentTemplate(resistance:new {
	template = "ywing_tier3",
	pilotTemplate = "bomber_tier3",
	shipType = "bomber",
	experience = 1344,
	lootChance = 0.1575,
	minCredits = 150,
	maxCredits = 309,
	color1 = 23,
	color2 = 18,
	texture = 0,
}, "ep3_wookiee_resistance_bomber")

local hiddenDaggers = ShipAgent:new {
	lootRolls = 1,
	lootTable = "space_pirate_tier5",
	aggressive = 1,
	spaceFaction = "pirate",
	alliedFactions = {"pirate"},
	enemyFactions = {"imperial", "rebel", "civilian", "merchant", "rsf", "corsec", "hutt", "valarian"},
	appearance = "hiddendagger_pilots",
	pvpBitmask = ATTACKABLE,
	optionsBitmask = AIENABLED,
}

ShipAgentTemplates:addShipAgentTemplate(hiddenDaggers:new {
	template = "yt1300_tier5",
	pilotTemplate = "heavy_tier5",
	shipType = "fighter",
	experience = 13421,
	lootChance = 0.26,
	minCredits = 465,
	maxCredits = 975,
	color1 = 63,
	color2 = 63,
	texture = 4,
}, "hiddendaggers_smuggler_tier5")

ShipAgentTemplates:addShipAgentTemplate(hiddenDaggers:new {
	template = "smuggler_warlord_ship_tier5",
	pilotTemplate = "slow_tier5",
	shipType = "capital",
	experience = 26843,
	lootChance = 0.52,
	minCredits = 1840,
	maxCredits = 23000,
	color1 = 26,
	color2 = 24,
	texture = 3,
}, "hiddendaggers_capital_ship_tier5")

ShipAgentTemplates:addShipAgentTemplate(hiddenDaggers:new {
	template = "ywing_tier5",
	pilotTemplate = "bomber_tier5",
	shipType = "bomber",
	experience = 7046,
	lootChance = 0.1365,
	minCredits = 425,
	maxCredits = 850,
	color2 = 52,
	texture = 1,
}, "hiddendaggers_bomber_tier5")

local voidWing = ShipAgent:new {
	lootRolls = 1,
	lootTable = "space_pirate_tier5",
	aggressive = 1,
	spaceFaction = "pirate",
	alliedFactions = {"pirate"},
	enemyFactions = {"imperial", "rebel", "civilian", "merchant", "hutt", "valarian", "rsf", "corsec"},
	appearance = "nebula_assassin",
	pvpBitmask = ATTACKABLE,
	optionsBitmask = AIENABLED,
}

ShipAgentTemplates:addShipAgentTemplate(voidWing:new {
	template = "yt1300_tier5",
	pilotTemplate = "heavy_tier5",
	shipType = "fighter",
	experience = 13421,
	lootChance = 0.26,
	minCredits = 465,
	maxCredits = 975,
	color1 = 23,
	color2 = 22,
	texture = 6,
}, "void_wing_yt1300_tier5")

ShipAgentTemplates:addShipAgentTemplate(voidWing:new {
	template = "smuggler_warlord_ship_tier5",
	pilotTemplate = "slow_tier5",
	shipType = "capital",
	experience = 26843,
	lootChance = 0.52,
	minCredits = 1840,
	maxCredits = 23000,
	color1 = 26,
	color2 = 24,
	texture = 3,
}, "void_wing_capital_ship_tier5")

ShipAgentTemplates:addShipAgentTemplate(voidWing:new {
	template = "hutt_medium_s02_tier5",
	pilotTemplate = "medium_fighter_tier5",
	shipType = "fighter",
	experience = 6710,
	lootChance = 0.13,
	minCredits = 425,
	maxCredits = 825,
	color1 = 3,
	color2 = 55,
	texture = 3,
}, "void_wing_dune_lizard_tier5")

ShipAgentTemplates:addShipAgentTemplate(voidWing:new {
	template = "blacksun_heavy_s02_tier5",
	pilotTemplate = "heavy_fighter_tier5",
	shipType = "bomber",
	experience = 8053,
	lootChance = 0.156,
	minCredits = 465,
	maxCredits = 900,
	color1 = 22,
	color2 = 3,
	texture = 4,
}, "void_wing_bomber_tier5")
