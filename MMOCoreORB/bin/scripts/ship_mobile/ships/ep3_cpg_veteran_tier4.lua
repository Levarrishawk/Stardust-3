-- CPG Veteran - YT-1300 asteroid-belt patrol protecting civilian traffic
-- (PreCU Scrapbook v5.1).
ep3_cpg_veteran_tier4 = ShipAgent:new {
	template = "yt1300_tier4",
	pilotTemplate = "heavy_tier5",
	shipType = "fighter",

	experience = 13421.77,

	lootChance = 0.26,
	lootRolls = 1,
	lootTable = "space_civilian_tier4",

	minCredits = 465,
	maxCredits = 975,

	aggressive = 0,

	spaceFaction = "civilian",
	alliedFactions = {"civilian", "merchant", "corsec", "rsf", "rodian"},
	enemyFactions = {"ghrag", "gotal", "chiss", "pirate", "blacksun", "hutt"},

	pvpBitmask = ATTACKABLE,
	shipBitmask = TURRETSHIP,
	optionsBitmask = AIENABLED,

	customShipAiMap = "",

	conversationTemplate = "ep3_cpg_veteran_convotemplate",
	conversationMobile = "object/mobile/shared_space_comm_ep3_cpg_veteran_01.iff",
	conversationMessage = "@conversation/ep3_cpg_veteran:s_185", --Too Far Message: What? You're breaking up!
}

ShipAgentTemplates:addShipAgentTemplate(ep3_cpg_veteran_tier4, "ep3_cpg_veteran_tier4")
