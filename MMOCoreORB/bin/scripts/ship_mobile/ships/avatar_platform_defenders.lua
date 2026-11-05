local platformFighter = ShipAgent:new {
	template = "blacksun_light_s02_tier3",
	pilotTemplate = "light_fighter_tier3",
	shipType = "fighter",
	experience = 1280,
	lootChance = 0.15,
	lootRolls = 1,
	lootTable = "space_pirate_tier3",
	minCredits = 120,
	maxCredits = 294,
	spaceFaction = "slaver",
	alliedFactions = {"merchant", "civilian"},
	appearance = "trandoshan_pilot",
	pvpBitmask = ATTACKABLE,
	optionsBitmask = AIENABLED,
}
ShipAgentTemplates:addShipAgentTemplate(platformFighter, "ep3_trandoshan_fighter")

ShipAgentTemplates:addShipAgentTemplate(platformFighter:new {
	template = "freighterheavy_tier3",
	pilotTemplate = "slow_tier3",
	shipType = "transport",
	experience = 0,
	lootChance = 0,
	lootRolls = 0,
	minCredits = 90,
	maxCredits = 225,
}, "ep3_trandoshan_slave_shuttle")

ShipAgentTemplates:addShipAgentTemplate(platformFighter:new {
	template = "blacksun_medium_s01_tier3",
	pilotTemplate = "medium_fighter_tier4",
	experience = 440,
	lootChance = 0.176,
	lootTable = "space_pirate_tier2",
	minCredits = 75,
	maxCredits = 160,
	cargoString = "avatar_landing_codes",
}, "ep3_trandoshan_blackscale_leader")

ShipAgentTemplates:addShipAgentTemplate(platformFighter:new {
	template = "blacksun_medium_s01_tier3",
	pilotTemplate = "medium_fighter_tier3",
	experience = 1408,
	lootChance = 0.165,
	minCredits = 150,
	maxCredits = 323,
}, "ep3_trandoshan_blackscale_fighter")

ShipAgentTemplates:addShipAgentTemplate(platformFighter:new {
	template = "blacksun_heavy_s01_tier4",
	pilotTemplate = "heavy_fighter_tier4",
	experience = 3932,
	lootChance = 0.168,
	lootTable = "space_civilian_tier4",
	minCredits = 275,
	maxCredits = 600,
}, "ep3_trandoshan_blackscale_bomber")

for tier = 1, 5 do
	local mine = platformFighter:new {
		template = "kessel_mine_turret_tier" .. tier,
		pilotTemplate = "light_fighter_tier4",
		experience = 100,
		lootChance = 0,
		lootRolls = 0,
		minCredits = 120,
		maxCredits = 125,
		aggressive = 1,
		enemyFactions = {"imperial", "rebel", "rsf", "corsec", "hutt", "valarian"},
		shipBitmask = TURRETSHIP,
	}
	ShipAgentTemplates:addShipAgentTemplate(mine, "ep3_avatar_platform_turret_mine_tier" .. tier)
end
