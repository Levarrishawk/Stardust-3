-- Deep Space - Kessel Space Battlefield entry station (Freelance/Privateer,
-- Dathomir space).  clientpoi_n:battlefield_neutral names it "Last Nav Station
-- (Deep Space)".  Scrapbook: "Rebels get there from the Deep Space Station in the
-- Dantooine System. Imperials get there from the Empire Deep Space station in the
-- Endor System. Freelancers get there from the Neutral Deep Space Station in the
-- Dathomir System."
--
-- template: unlike the Rebel and Imperial stations, the client ships NO
-- shared_spacestation_neutral_battlefield_entry.iff - the only neutral station
-- object is shared_spacestation_neutral_01.iff.  So spacestation_neutral is the
-- correct hull here, not a fallback.
--
-- spaceFaction "stationDeepSpace" matches the in-tree spacestation_neutral
-- template (scripts/ship_mobile/ships/spacestation_neutral.lua:14), which Core3
-- already registers as its own deep-space station faction key
-- (SpaceManagerImplementation.cpp:41-44).

jumpstation_neutral = ShipAgent:new {
	template = "spacestation_neutral",
	shipType = "capital",

	lootChance = 0,
	lootRolls = 0,
	lootTable = "space_civilian_tier1",

	minCredits = 791,
	maxCredits = 1300,

	aggressive = 0,

	spaceFaction = "stationDeepSpace",
	appearance = "spacestation",
	tauntAttackChance = 0.1,
	tauntDefendChance = 0.05,
	tauntDieChance = 0.1,

	pvpBitmask = NONE,
	shipBitmask = NONE,
	optionsBitmask = AIENABLED + INVULNERABLE,

	customShipAiMap = "spaceStations",

	conversationTemplate = "jumpstation_neutral_convotemplate",
	conversationMobile = "object/mobile/shared_space_comm_civilian_01.iff",
	-- Too Far Message. battlefield_entry_station_neutral.stf carries its own
	-- out-of-range line, s_3b257674 "You need to move close to this station, %TU."
	-- (This replaces a borrowed station_dathomir:s_562, which was chosen before the
	-- battlefield_entry_station_* tables were located.)
	conversationMessage = "@conversation/battlefield_entry_station_neutral:s_3b257674",
}

ShipAgentTemplates:addShipAgentTemplate(jumpstation_neutral, "jumpstation_neutral")
