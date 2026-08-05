ep3_cpg_ace_tier5 = ShipAgent:new {
	template = "awing_tier5",
	pilotTemplate = "light_fighter_tier5",
	shipType = "fighter",

	experience = 6039.8,

	lootChance = 0.117,
	lootRolls = 1,
	lootTable = "space_civilian_tier5",

	minCredits = 350,
	maxCredits = 750,

	aggressive = 0,

	spaceFaction = "civilian",
	alliedFactions = {"civilian", "merchant", "corsec", "rsf", "rodian"},
	enemyFactions = {"ghrag", "gotal", "chiss", "pirate", "blacksun", "hutt"},

	pvpBitmask = ATTACKABLE,
	shipBitmask = NONE,
	optionsBitmask = AIENABLED,

	customShipAiMap = "",

	conversationTemplate = "ep3_cpg_ace_convotemplate",
	conversationMobile = "object/mobile/shared_space_comm_ep3_cpg_ace_02.iff",
	conversationMessage = "@conversation/ep3_cpg_ace:s_185", --Too Far Message: [ ... Transmission Blocked ... ]
}

ShipAgentTemplates:addShipAgentTemplate(ep3_cpg_ace_tier5, "ep3_cpg_ace_tier5")
