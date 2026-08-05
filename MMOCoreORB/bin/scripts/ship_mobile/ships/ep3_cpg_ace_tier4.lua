ep3_cpg_ace_tier4 = ShipAgent:new {
	template = "awing_tier4",
	pilotTemplate = "light_fighter_tier4",
	shipType = "fighter",

	experience = 2949.12,

	lootChance = 0.126,
	lootRolls = 1,
	lootTable = "space_civilian_tier4",

	minCredits = 200,
	maxCredits = 500,

	aggressive = 0,

	spaceFaction = "civilian",
	alliedFactions = {"civilian", "merchant", "corsec", "rsf", "rodian"},
	enemyFactions = {"ghrag", "gotal", "chiss", "pirate", "blacksun", "hutt"},

	pvpBitmask = ATTACKABLE,
	shipBitmask = NONE,
	optionsBitmask = AIENABLED,

	customShipAiMap = "",

	conversationTemplate = "ep3_cpg_ace_convotemplate",
	conversationMobile = "object/mobile/shared_space_comm_ep3_cpg_ace_01.iff",
	conversationMessage = "@conversation/ep3_cpg_ace:s_185", --Too Far Message: [ ... Transmission Blocked ... ]
}

ShipAgentTemplates:addShipAgentTemplate(ep3_cpg_ace_tier4, "ep3_cpg_ace_tier4")
