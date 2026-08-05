-- Deep Space - Kessel Space Battlefield entry station (Imperial, Endor space).
-- clientpoi_n:battlefield_imperial names it "Imperial Claw Station (Deep Space)".
--
-- template: the client's own object for this station is
-- object/tangible/space/spacestations/shared_spacestation_imperial_battlefield_entry.iff
-- (present in mtg_patch_010_object_01.tre, already parsed at server start).  It
-- CANNOT be used here - ShipManager::createAiShip hard-prefixes "object/ship/" and
-- requires a SharedShipObjectTemplate (ShipManager.cpp:723-733), while Core3
-- registers the battlefield_entry shared template as a SharedTangibleObjectTemplate
-- (object/tangible/space/spacestations/objects.lua:162-163).  See jumpstation_rebel.lua.

jumpstation_imperial = ShipAgent:new {
	template = "spacestation_imperial",
	shipType = "capital",

	lootChance = 0,
	lootRolls = 0,
	lootTable = "space_civilian_tier1",

	minCredits = 791,
	maxCredits = 1300,

	aggressive = 0,

	spaceFaction = "station",
	appearance = "spacestation",
	tauntAttackChance = 0.1,
	tauntDefendChance = 0.05,
	tauntDieChance = 0.1,

	pvpBitmask = NONE,
	shipBitmask = NONE,
	optionsBitmask = AIENABLED + INVULNERABLE,

	customShipAiMap = "spaceStations",

	conversationTemplate = "jumpstation_imperial_convotemplate",
	conversationMobile = "object/mobile/shared_space_comm_imperial_officer_01.iff",
	-- Too Far Message. battlefield_entry_station_imperial.stf carries its own
	-- out-of-range line, s_48f82131 "You need to move closer to this station."
	-- (Same key id as pvp_station_imperial:s_48f82131, but that table belongs to the
	-- faction-DECLARATION station, a different object.)
	conversationMessage = "@conversation/battlefield_entry_station_imperial:s_48f82131",
}

ShipAgentTemplates:addShipAgentTemplate(jumpstation_imperial, "jumpstation_imperial")
