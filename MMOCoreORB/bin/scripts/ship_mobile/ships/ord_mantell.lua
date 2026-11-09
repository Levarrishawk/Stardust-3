-- Source: DSRC space_mobile/space_mobile.tab (Stella Bellum / Cekis).
local blackSun = ShipAgent:new {
	spaceFaction = "blacksun",
	alliedFactions = {"blacksun"},
	lootTable = "npe_space_loot",
	pvpBitmask = ATTACKABLE,
	optionsBitmask = AIENABLED,
}

local traffic = ShipAgent:new {
	optionsBitmask = AIENABLED,
}

ShipAgentTemplates:addShipAgentTemplate(blackSun:new {
	template = "blacksun_light_s01_npe",
	pilotTemplate = "light_fighter_tier1",
	shipType = "fighter",
	experience = 100,
	lootChance = 0.17,
	lootRolls = 1,
	minCredits = 51,
	maxCredits = 103,
	enemyFactions = {"imperial", "rebel", "merchant", "rsf", "corsec", "hutt", "valarian", "nym"},
	color1 = 23,
	color2 = 4,
	texture = 7,
	appearance = "blacksun",
	tauntType = "blacksun_low",
	tauntAttackChance = 0.1,
	tauntDefendChance = 0.05,
	tauntDieChance = 0.1,
	cargoString = "npe_easy_main_1a",
}, "npe_easy_main_blacksun_spy")

ShipAgentTemplates:addShipAgentTemplate(blackSun:new {
	template = "blacksun_light_s01_npe",
	pilotTemplate = "light_fighter_tier1",
	shipType = "fighter",
	experience = 100,
	lootChance = 0.17,
	lootRolls = 1,
	minCredits = 51,
	maxCredits = 103,
	aggressive = 1,
	enemyFactions = {"imperial", "rebel", "civilian", "merchant", "rsf", "corsec", "hutt", "valarian", "nym", "cardas"},
	appearance = "blacksun",
	tauntType = "blacksun_low",
	tauntAttackChance = 0.1,
	tauntDefendChance = 0.05,
	tauntDieChance = 0.1,
}, "npe_easy_main_blacksun_assassin")

ShipAgentTemplates:addShipAgentTemplate(traffic:new {
	template = "hutt_light_s01_tier3",
	pilotTemplate = "light_fighter_tier3",
	shipType = "fighter",
	spaceFaction = "unattackable",
	alliedFactions = {"cardas", "hutt"},
	enemyFactions = {"blacksun"},
	appearance = "civilian",
	optionsBitmask = AIENABLED + INVULNERABLE,
}, "npe_main_cardas_agent")

ShipAgentTemplates:addShipAgentTemplate(traffic:new {
	template = "transport_science_tier1",
	pilotTemplate = "slow_tier1",
	shipType = "transport",
	spaceFaction = "unattackable",
	alliedFactions = {"cardas", "hutt"},
	enemyFactions = {"blacksun"},
	appearance = "civilian",
	optionsBitmask = AIENABLED + INVULNERABLE,
}, "npe_easy_main_dynath_miner")

ShipAgentTemplates:addShipAgentTemplate(blackSun:new {
	template = "blacksun_light_s01_npe",
	pilotTemplate = "light_fighter_tier1",
	shipType = "fighter",
	experience = 100,
	lootChance = 0.17,
	lootRolls = 1,
	minCredits = 51,
	maxCredits = 103,
	aggressive = 1,
	enemyFactions = {"imperial", "rebel", "civilian", "merchant", "rsf", "corsec", "hutt", "valarian", "nym", "cardas"},
	appearance = "blacksun",
	tauntType = "blacksun_low",
	tauntAttackChance = 0.1,
	tauntDefendChance = 0.05,
	tauntDieChance = 0.1,
}, "npe_blacksun_hunter_tier1")

ShipAgentTemplates:addShipAgentTemplate(blackSun:new {
	template = "blacksun_medium_s01_npe",
	pilotTemplate = "medium_fighter_tier1",
	shipType = "fighter",
	experience = 110,
	lootChance = 0.187,
	lootRolls = 1,
	minCredits = 55,
	maxCredits = 110,
	aggressive = 1,
	enemyFactions = {"imperial", "rebel", "civilian", "merchant", "rsf", "corsec", "hutt", "valarian", "nym", "cardas"},
	appearance = "blacksun",
	tauntType = "blacksun",
	tauntAttackChance = 0.1,
	tauntDefendChance = 0.05,
	tauntDieChance = 0.1,
}, "npe_blacksun_stalker_tier1")

ShipAgentTemplates:addShipAgentTemplate(blackSun:new {
	template = "blacksun_heavy_s01_tier1",
	pilotTemplate = "heavy_fighter_tier5",
	shipType = "fighter",
	experience = 120,
	lootChance = 0.204,
	lootRolls = 1,
	minCredits = 60,
	maxCredits = 200,
	aggressive = 1,
	enemyFactions = {"imperial", "rebel", "civilian", "merchant", "rsf", "corsec", "hutt", "valarian", "nym", "cardas"},
	appearance = "blacksun",
	tauntType = "blacksun",
	tauntAttackChance = 0.1,
	tauntDefendChance = 0.05,
	tauntDieChance = 0.1,
}, "npe_talonbane_cobra_tier1")

ShipAgentTemplates:addShipAgentTemplate(blackSun:new {
	template = "z95_tier1",
	pilotTemplate = "medium_fighter_tier1",
	shipType = "fighter",
	enemyFactions = {"imperial", "rebel", "civilian", "merchant", "rsf", "corsec", "hutt", "valarian", "nym", "cardas"},
	appearance = "civilian",
	tauntType = "generic_low",
	tauntAttackChance = 0.1,
	tauntDefendChance = 0.05,
	tauntDieChance = 0.1,
}, "npe_waris_kallor")

ShipAgentTemplates:addShipAgentTemplate(traffic:new {
	template = "z95_tier1",
	pilotTemplate = "medium_fighter_tier1",
	shipType = "fighter",
	spaceFaction = "unattackable",
	alliedFactions = {"civilian", "cardas"},
	enemyFactions = {"blacksun"},
	appearance = "civilian",
	tauntType = "generic_low",
	tauntAttackChance = 0.1,
	tauntDefendChance = 0.05,
	tauntDieChance = 0.1,
	optionsBitmask = AIENABLED + INVULNERABLE,
}, "npe_sulale_kallor")

ShipAgentTemplates:addShipAgentTemplate(blackSun:new {
	template = "blacksun_medium_s01_npe",
	pilotTemplate = "medium_fighter_tier1",
	shipType = "fighter",
	experience = 110,
	lootChance = 0.187,
	lootRolls = 1,
	minCredits = 70,
	maxCredits = 210,
	aggressive = 1,
	enemyFactions = {"imperial", "rebel", "civilian", "merchant", "rsf", "corsec", "hutt", "valarian", "nym", "cardas"},
	appearance = "blacksun",
	tauntType = "blacksun",
	tauntAttackChance = 0.1,
	tauntDefendChance = 0.05,
	tauntDieChance = 0.1,
}, "npe_med_blacksun_assassin_tier1")

ShipAgentTemplates:addShipAgentTemplate(traffic:new {
	template = "hutt_medium_s01_tier1",
	pilotTemplate = "medium_fighter_tier1",
	shipType = "fighter",
	spaceFaction = "unattackable",
	alliedFactions = {"civilian", "cardas", "hutt"},
	enemyFactions = {"imperial", "rebel", "civilian", "merchant", "rsf", "corsec", "hutt", "valarian", "nym", "cardas"},
	appearance = "civilian",
	tauntType = "civilian",
	tauntAttackChance = 0.1,
	tauntDefendChance = 0.05,
	tauntDieChance = 0.1,
	optionsBitmask = AIENABLED + INVULNERABLE,
}, "npe_atris")

ShipAgentTemplates:addShipAgentTemplate(blackSun:new {
	template = "blacksun_heavy_s01_tier1",
	pilotTemplate = "heavy_fighter_tier3",
	shipType = "fighter",
	experience = 480,
	lootChance = 0.192,
	lootRolls = 1,
	minCredits = 150,
	maxCredits = 200,
	aggressive = 1,
	enemyFactions = {"imperial", "rebel", "civilian", "merchant", "rsf", "corsec", "hutt", "valarian", "nym", "cardas"},
	appearance = "blacksun",
	tauntType = "blacksun",
	tauntAttackChance = 0.1,
	tauntDefendChance = 0.05,
	tauntDieChance = 0.1,
}, "npe_blacksun_rilis")

ShipAgentTemplates:addShipAgentTemplate(blackSun:new {
	template = "blacksun_heavy_s01_tier1",
	pilotTemplate = "heavy_fighter_tier3",
	shipType = "fighter",
	experience = 480,
	lootChance = 0.192,
	lootRolls = 1,
	minCredits = 150,
	maxCredits = 200,
	aggressive = 1,
	enemyFactions = {"imperial", "rebel", "civilian", "merchant", "rsf", "corsec", "hutt", "valarian", "nym", "cardas"},
	appearance = "blacksun",
	tauntType = "blacksun",
	tauntAttackChance = 0.1,
	tauntDefendChance = 0.05,
	tauntDieChance = 0.1,
}, "npe_blacksun_ondara")

ShipAgentTemplates:addShipAgentTemplate(blackSun:new {
	template = "blacksun_heavy_s01_tier1",
	pilotTemplate = "heavy_fighter_tier3",
	shipType = "fighter",
	experience = 480,
	lootChance = 0.192,
	lootRolls = 1,
	minCredits = 150,
	maxCredits = 200,
	aggressive = 1,
	enemyFactions = {"imperial", "rebel", "civilian", "merchant", "rsf", "corsec", "hutt", "valarian", "nym", "cardas"},
	appearance = "blacksun",
	tauntType = "blacksun",
	tauntAttackChance = 0.1,
	tauntDefendChance = 0.05,
	tauntDieChance = 0.1,
}, "npe_blacksun_chaen")

ShipAgentTemplates:addShipAgentTemplate(blackSun:new {
	template = "blacksun_heavy_s01_npe",
	pilotTemplate = "light_fighter_tier3",
	shipType = "fighter",
	experience = 100,
	lootChance = 0.17,
	lootRolls = 1,
	minCredits = 110,
	maxCredits = 190,
	aggressive = 1,
	enemyFactions = {"imperial", "rebel", "civilian", "merchant", "rsf", "corsec", "hutt", "valarian", "nym", "cardas"},
	appearance = "blacksun",
	tauntType = "blacksun_low",
	tauntAttackChance = 0.1,
	tauntDefendChance = 0.05,
	tauntDieChance = 0.1,
}, "npe_blacksun_guard_tier1")

ShipAgentTemplates:addShipAgentTemplate(traffic:new {
	template = "hutt_heavy_s02_tier1",
	pilotTemplate = "heavy_fighter_tier1",
	shipType = "fighter",
	spaceFaction = "unattackable",
	alliedFactions = {"civilian", "cardas", "hutt"},
	enemyFactions = {"blacksun"},
	appearance = "civilian",
	tauntType = "generic_low",
	tauntAttackChance = 0.1,
	tauntDefendChance = 0.05,
	tauntDieChance = 0.1,
	optionsBitmask = AIENABLED + INVULNERABLE,
}, "npe_cardas_destroyer_tier1")

ShipAgentTemplates:addShipAgentTemplate(traffic:new {
	template = "blacksun_medium_s01_npe",
	pilotTemplate = "medium_fighter_tier1",
	shipType = "fighter",
	spaceFaction = "unattackable",
	alliedFactions = {"civilian", "cardas", "hutt"},
	enemyFactions = {"blacksun"},
	appearance = "civilian",
	tauntType = "generic_low",
	tauntAttackChance = 0.1,
	tauntDefendChance = 0.05,
	tauntDieChance = 0.1,
	optionsBitmask = AIENABLED + INVULNERABLE,
}, "npe_cardas_fighter_tier1")

ShipAgentTemplates:addShipAgentTemplate(blackSun:new {
	template = "blacksun_heavy_s01_tier1",
	pilotTemplate = "heavy_fighter_tier3",
	shipType = "fighter",
	experience = 480,
	lootChance = 0.192,
	lootRolls = 1,
	minCredits = 75,
	maxCredits = 160,
	aggressive = 1,
	enemyFactions = {"imperial", "rebel", "civilian", "merchant", "rsf", "corsec", "hutt", "valarian", "nym", "cardas"},
	appearance = "blacksun",
	tauntType = "blacksun",
	tauntAttackChance = 0.1,
	tauntDefendChance = 0.05,
	tauntDieChance = 0.1,
}, "npe_hard_blacksun_bomber_tier2")

ShipAgentTemplates:addShipAgentTemplate(blackSun:new {
	template = "blacksun_light_s01_npe",
	pilotTemplate = "light_fighter_tier3",
	shipType = "fighter",
	experience = 100,
	lootChance = 0.17,
	lootRolls = 1,
	minCredits = 51,
	maxCredits = 103,
	aggressive = 1,
	enemyFactions = {"imperial", "rebel", "civilian", "merchant", "rsf", "corsec", "hutt", "valarian", "nym", "cardas"},
	appearance = "blacksun",
	tauntType = "blacksun_low",
	tauntAttackChance = 0.1,
	tauntDefendChance = 0.05,
	tauntDieChance = 0.1,
}, "npe_hard_blacksun_fighter_tier1")

ShipAgentTemplates:addShipAgentTemplate(traffic:new {
	template = "hutt_light_s01_tier1",
	pilotTemplate = "light_fighter_tier1",
	shipType = "fighter",
	spaceFaction = "unattackable",
	alliedFactions = {"civilian", "cardas", "hutt"},
	enemyFactions = {"blacksun"},
	appearance = "civilian",
	optionsBitmask = AIENABLED + INVULNERABLE,
}, "npe_easy_main_dynath_agent")

ShipAgentTemplates:addShipAgentTemplate(blackSun:new {
	template = "blacksun_heavy_s01_npe",
	pilotTemplate = "heavy_fighter_tier2",
	shipType = "fighter",
	experience = 120,
	lootChance = 0.204,
	lootRolls = 1,
	minCredits = 55,
	maxCredits = 110,
	aggressive = 1,
	enemyFactions = {"imperial", "rebel", "civilian", "merchant", "rsf", "corsec", "hutt", "valarian", "nym", "cardas"},
	appearance = "blacksun",
	tauntType = "blacksun",
	tauntAttackChance = 0.1,
	tauntDefendChance = 0.05,
	tauntDieChance = 0.1,
}, "npe_med_blacksun_bomber_tier1")

ShipAgentTemplates:addShipAgentTemplate(blackSun:new {
	template = "blacksun_light_s01_npe",
	pilotTemplate = "light_fighter_tier2",
	shipType = "fighter",
	experience = 100,
	lootChance = 0.17,
	lootRolls = 1,
	minCredits = 51,
	maxCredits = 103,
	aggressive = 1,
	enemyFactions = {"imperial", "rebel", "civilian", "merchant", "rsf", "corsec", "hutt", "valarian", "nym", "cardas"},
	appearance = "blacksun",
	tauntType = "blacksun_low",
	tauntAttackChance = 0.1,
	tauntDefendChance = 0.05,
	tauntDieChance = 0.1,
}, "npe_med_blacksun_hunter_tier1")

ShipAgentTemplates:addShipAgentTemplate(blackSun:new {
	template = "blacksun_medium_s01_npe",
	pilotTemplate = "medium_fighter_tier2",
	shipType = "fighter",
	experience = 110,
	lootChance = 0.187,
	lootRolls = 1,
	minCredits = 55,
	maxCredits = 110,
	aggressive = 1,
	enemyFactions = {"imperial", "rebel", "civilian", "merchant", "rsf", "corsec", "hutt", "valarian", "nym", "cardas"},
	appearance = "blacksun",
	tauntType = "blacksun",
	tauntAttackChance = 0.1,
	tauntDefendChance = 0.05,
	tauntDieChance = 0.1,
}, "npe_med_blacksun_stalker_tier1")

ShipAgentTemplates:addShipAgentTemplate(blackSun:new {
	template = "blacksun_heavy_s01_npe",
	pilotTemplate = "heavy_fighter_tier3",
	shipType = "fighter",
	experience = 120,
	lootChance = 0.204,
	lootRolls = 1,
	minCredits = 55,
	maxCredits = 110,
	aggressive = 1,
	enemyFactions = {"imperial", "rebel", "civilian", "merchant", "rsf", "corsec", "hutt", "valarian", "nym", "cardas"},
	appearance = "blacksun",
	tauntType = "blacksun",
	tauntAttackChance = 0.1,
	tauntDefendChance = 0.05,
	tauntDieChance = 0.1,
}, "npe_hard_blacksun_bomber_tier1")

ShipAgentTemplates:addShipAgentTemplate(blackSun:new {
	template = "blacksun_light_s01_npe",
	pilotTemplate = "light_fighter_tier3",
	shipType = "fighter",
	experience = 100,
	lootChance = 0.17,
	lootRolls = 1,
	minCredits = 51,
	maxCredits = 103,
	aggressive = 1,
	enemyFactions = {"imperial", "rebel", "civilian", "merchant", "rsf", "corsec", "hutt", "valarian", "nym", "cardas"},
	appearance = "blacksun",
	tauntType = "blacksun_low",
	tauntAttackChance = 0.1,
	tauntDefendChance = 0.05,
	tauntDieChance = 0.1,
}, "npe_hard_blacksun_hunter_tier1")

ShipAgentTemplates:addShipAgentTemplate(blackSun:new {
	template = "blacksun_medium_s01_npe",
	pilotTemplate = "medium_fighter_tier3",
	shipType = "fighter",
	experience = 110,
	lootChance = 0.187,
	lootRolls = 1,
	minCredits = 55,
	maxCredits = 110,
	aggressive = 1,
	enemyFactions = {"imperial", "rebel", "civilian", "merchant", "rsf", "corsec", "hutt", "valarian", "nym", "cardas"},
	appearance = "blacksun",
	tauntType = "blacksun",
	tauntAttackChance = 0.1,
	tauntDefendChance = 0.05,
	tauntDieChance = 0.1,
}, "npe_hard_blacksun_stalker_tier1")

ShipAgentTemplates:addShipAgentTemplate(blackSun:new {
	template = "blacksun_light_s01_tier1",
	pilotTemplate = "light_fighter_tier4",
	shipType = "fighter",
	experience = 400,
	lootChance = 0.16,
	lootRolls = 1,
	minCredits = 80,
	maxCredits = 300,
	aggressive = 1,
	enemyFactions = {"imperial", "rebel", "civilian", "merchant", "rsf", "corsec", "hutt", "valarian", "nym", "cardas"},
	appearance = "blacksun",
	tauntType = "blacksun_low",
	tauntAttackChance = 0.1,
	tauntDefendChance = 0.05,
	tauntDieChance = 0.1,
}, "npe_hard_blacksun_fighter_tier2")

ShipAgentTemplates:addShipAgentTemplate(blackSun:new {
	template = "blacksun_light_s01_tier1",
	pilotTemplate = "light_fighter_tier3",
	shipType = "fighter",
	experience = 100,
	lootChance = 0.17,
	lootRolls = 1,
	minCredits = 80,
	maxCredits = 300,
	aggressive = 1,
	enemyFactions = {"imperial", "rebel", "civilian", "merchant", "rsf", "corsec", "hutt", "valarian", "nym", "cardas"},
	appearance = "blacksun",
	tauntType = "blacksun_low",
	tauntAttackChance = 0.1,
	tauntDefendChance = 0.05,
	tauntDieChance = 0.1,
	cargoString = "npe_easy_main_1a",
}, "npe_hard_blacksun_spy")

ShipAgentTemplates:addShipAgentTemplate(blackSun:new {
	template = "blacksun_heavy_s01_tier1",
	pilotTemplate = "heavy_fighter_tier4",
	shipType = "fighter",
	experience = 120,
	lootChance = 0.204,
	lootRolls = 1,
	minCredits = 60,
	maxCredits = 200,
	aggressive = 1,
	enemyFactions = {"imperial", "rebel", "civilian", "merchant", "rsf", "corsec", "hutt", "valarian", "nym", "cardas"},
	appearance = "blacksun",
	tauntType = "blacksun",
	tauntAttackChance = 0.1,
	tauntDefendChance = 0.05,
	tauntDieChance = 0.1,
}, "npe_blacksun_demonrunner_tier1")

ShipAgentTemplates:addShipAgentTemplate(traffic:new {
	template = "z95_tier1",
	pilotTemplate = "slow_tier1",
	shipType = "transport",
	spaceFaction = "unattackable",
	alliedFactions = {"civilian", "cardas", "hutt"},
	enemyFactions = {"blacksun"},
	appearance = "civilian",
	optionsBitmask = AIENABLED + INVULNERABLE,
}, "npe_evn_dynath_miner")

ShipAgentTemplates:addShipAgentTemplate(traffic:new {
	template = "z95_tier1",
	pilotTemplate = "light_fighter_tier1",
	shipType = "fighter",
	spaceFaction = "unattackable",
	alliedFactions = {"civilian", "cardas", "hutt"},
	enemyFactions = {"blacksun"},
	appearance = "civilian",
	optionsBitmask = AIENABLED + INVULNERABLE,
}, "npe_evn_dynath_guardian")

ShipAgentTemplates:addShipAgentTemplate(traffic:new {
	template = "transport_science_tier1",
	pilotTemplate = "light_fighter_tier1",
	shipType = "fighter",
	spaceFaction = "unattackable",
	alliedFactions = {"civilian", "cardas", "hutt"},
	enemyFactions = {"blacksun"},
	appearance = "civilian",
	optionsBitmask = AIENABLED + INVULNERABLE,
}, "npe_evn_dynath_transport")

ShipAgentTemplates:addShipAgentTemplate(traffic:new {
	template = "merchant_cruiser_light_tier1",
	pilotTemplate = "bomber_tier1",
	shipType = "fighter",
	spaceFaction = "civilian",
	alliedFactions = {"civilian", "cardas", "hutt"},
	enemyFactions = {"blacksun"},
	appearance = "civilian",
	pvpBitmask = ATTACKABLE,
}, "npe_evn_merchant")

ShipAgentTemplates:addShipAgentTemplate(traffic:new {
	template = "lambdashuttle_tier1",
	pilotTemplate = "bomber_tier1",
	shipType = "transport",
	spaceFaction = "civilian",
	alliedFactions = {"civilian", "cardas", "hutt"},
	enemyFactions = {"blacksun"},
	appearance = "civilian",
	tauntAttackChance = 0.1,
	tauntDefendChance = 0.05,
	tauntDieChance = 0.1,
	pvpBitmask = ATTACKABLE,
}, "npe_evn_shuttle")

ShipAgentTemplates:addShipAgentTemplate(traffic:new {
	template = "z95_tier1",
	pilotTemplate = "light_fighter_tier1",
	shipType = "fighter",
	spaceFaction = "civilian",
	alliedFactions = {"civilian", "cardas", "imperial"},
	color1 = 23,
	color2 = 4,
	texture = 7,
	appearance = "civilian",
	tauntType = "generic_low",
	tauntAttackChance = 0.1,
	tauntDefendChance = 0.05,
	tauntDieChance = 0.1,
	pvpBitmask = ATTACKABLE,
}, "npe_evn_unknown_miner")

ShipAgentTemplates:addShipAgentTemplate(traffic:new {
	template = "hutt_medium_s01_tier1",
	pilotTemplate = "medium_fighter_tier1",
	shipType = "fighter",
	spaceFaction = "unattackable",
	alliedFactions = {"cardas", "civilian", "hutt"},
	enemyFactions = {"blacksun"},
	appearance = "civilian",
	tauntType = "generic_low",
	tauntAttackChance = 0.1,
	tauntDefendChance = 0.05,
	tauntDieChance = 0.1,
	optionsBitmask = AIENABLED + INVULNERABLE,
}, "npe_evn_cardas_police")

ShipAgentTemplates:addShipAgentTemplate(traffic:new {
	template = "z95_tier1",
	pilotTemplate = "medium_fighter_tier1",
	shipType = "transport",
	spaceFaction = "unattackable",
	alliedFactions = {"civilian", "cardas"},
	enemyFactions = {"blacksun"},
	appearance = "civilian",
	optionsBitmask = AIENABLED + INVULNERABLE,
}, "npe_smuggle_buyer")

-- Comm and docking routes are staged with the interiors under screenplays/space/ord_mantell.
local station = ShipAgent:new {
	template = "spacestation_neutral",
	shipType = "capital",
	spaceFaction = "station",
	appearance = "spacestation",
	optionsBitmask = AIENABLED + INVULNERABLE,
	customShipAiMap = "spaceStations",
}

ShipAgentTemplates:addShipAgentTemplate(station, "station_ord_mantell")
ShipAgentTemplates:addShipAgentTemplate(station:new {
	template = "spacestation_ord_mantell_dungeon",
}, "spacestation_ord_mantell_dungeon")
