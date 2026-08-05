-- Deep Space - Kessel Space Battlefield entry station (Rebel, Dantooine space).
-- clientpoi_n:battlefield_rebel names it "Station: Deep Space"; Publish 27.4 calls
-- the object class "Space Battlefield entry station".
--
-- template: the client's own object for this station is
-- object/tangible/space/spacestations/shared_spacestation_rebel_battlefield_entry.iff
-- (present in mtg_patch_010_object_01.tre, and already parsed at server start - see
-- bin/log/core3.log "[SharedObjectTemplate spacestation_rebel_battlefield_entry]").
-- It CANNOT be used here: ShipManager::createAiShip hard-prefixes the agent's
-- template with "object/ship/" and requires a SharedShipObjectTemplate
-- (ShipManager.cpp:723-733), while Core3 registers the battlefield_entry shared
-- template as a SharedTangibleObjectTemplate under object/tangible/... instead
-- (object/tangible/space/spacestations/objects.lua:398-399).  spacestation_rebel is
-- the closest reachable hull.  Flagged in the report as an owner decision.

jumpstation_rebel = ShipAgent:new {
	template = "spacestation_rebel",
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

	conversationTemplate = "jumpstation_rebel_convotemplate",
	conversationMobile = "object/mobile/shared_space_comm_rebel_transport_01.iff",
	-- Too Far Message. battlefield_entry_station_rebel.stf carries its own
	-- out-of-range line, s_3b257674 "You need to move close to this station, %TU."
	-- (pvp_station_rebel:s_48f82131 belongs to the faction-DECLARATION station, a
	-- different object: "Welcome to the Rebel Alliance Space Station, %TU. Would you
	-- like to declare your affiliation with the Rebel Alliance?").
	conversationMessage = "@conversation/battlefield_entry_station_rebel:s_3b257674",
}

ShipAgentTemplates:addShipAgentTemplate(jumpstation_rebel, "jumpstation_rebel")
