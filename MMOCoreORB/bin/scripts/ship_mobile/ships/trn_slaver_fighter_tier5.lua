trn_slaver_fighter_tier5 = ShipAgent:new {
	template = "z95_tier5",
	pilotTemplate = "light_fighter_tier5",
	shipType = "fighter",

	experience = 6710.89,

	lootChance = 0.13,
	lootRolls = 1,
	lootTable = "space_pirate_tier5",

	minCredits = 425,
	maxCredits = 825,

	aggressive = 0,

	spaceFaction = "pirate",
	alliedFactions = {"pirate"},
	enemyFactions = {"imperial", "merchant", "civilian"},

	pvpBitmask = ATTACKABLE,
	shipBitmask = NONE,
	optionsBitmask = AIENABLED,

	customShipAiMap = "",

	conversationTemplate = "",
	conversationMobile = "object/mobile/shared_space_comm_trn_slaver_03.iff",
	conversationMessage = "", --Too Far Message

	-- Gate for inspect_ep3_trando_mosolium_zssik_04. ShipAgentTemplate.cpp:141 parses
	-- cargoString; ShipAiAgentImplementation.cpp:351 copies it onto the agent;
	-- ShipInspectTask.cpp:75 hashes it into the INSPECTEDSHIP observer, which
	-- SpaceInspectScreenplay.lua:244 compares against inspectCargo.
	-- CLIENT-ATTESTED KEY: string/en/space/cargo.stf ships "avatar_landing_codes" =
	-- "Avatar Platform Landing Code". There is no "avatar_approach_codes" row in that file, and
	-- ShipInspectTask.cpp renders the cargo as "@space/cargo:<cargoString>", so the client key is
	-- used here so the inspect result displays translated text instead of a raw key.
	cargoString = "avatar_landing_codes",
}

ShipAgentTemplates:addShipAgentTemplate(trn_slaver_fighter_tier5, "trn_slaver_fighter_tier5")
