tallonIntel = {
	itemTemplates = { "object/tangible/loot/dungeon/corellian_corvette/rebel_rescue_filler01.iff", "object/tangible/loot/dungeon/corellian_corvette/rebel_rescue_filler02.iff", "object/tangible/loot/dungeon/corellian_corvette/rebel_rescue_intel.iff" },
	itemNames = { "Superseded Transfer Override", "Seizure Report", "Prisoner Transfer Override" },
}

tallonTicketInfo = { depPlanet = "corellia", faction = "rebel", missionType = "rescue" }

tallonCompensation = { { compType = "faction", faction = "rebel", amount = 100 } }

tallon = { planetName = "corellia", npcTemplate = "corvette_rebel_adar", x = -5448.03, z = 21, y = -2674.92, direction = 163, cellID = 0, position = STAND }

ticketGiverTallon = CorvetteTicketGiverLogic:new {
	npc = tallon,
	intelMap = tallonIntel,
	ticketInfo = tallonTicketInfo,
	contractTitle = "A Witness in Transit",
	giverName = "ticketGiverTallon",
	faction = FACTIONREBEL,
	compensation = tallonCompensation,
	menuComponent = "tallonIntelSearchMenuComponent",

	first_location = "The Warren, Dantooine.",
	second_location = "Imperial Prison, Dathomir.",
	third_location = "Bloodrazor wreck, Lok.",
	go_get_intel ="@conversation/corvette_tallon_rebel1:s_a5591c27", -- I accept this mission.
	hear_locations_quit = "@conversation/corvette_tallon_rebel1:s_d6695e83",-- No thanks.

	has_intel ="@conversation/corvette_tallon_rebel1:s_4d865d46",--I found several interesting documents and codes.
	which_planet ="Can you go over the leads again?",
	back_already_reset = "@conversation/corvette_tallon_rebel1:s_e70aed96", -- I can't continue. Please erase all records of my progress on this mission.

	bad_intel_1 = "I found the Superseded Transfer Override.",
	bad_intel_2 = "I found the Seizure Report.",
	good_intel = "Here is the Prisoner Transfer Override.",

	go_to_corvette = "Where do I take this authorization?",
	check_other_places = "@conversation/corvette_tallon_rebel1:s_a128e067", --Looks like I have more to do.
	other_documents = "@conversation/corvette_tallon_rebel1:s_2f26b4c4", -- I still have documents for you.

	launch_location ="Remind me where the pickup is.",
	still_here_decline ="@conversation/corvette_tallon_rebel1:s_e70aed96", -- I can't continue. Please erase all records of my progress on this mission.

}

registerScreenPlay("ticketGiverTallon", true)

ticketGiverTallonConvoHandler = CorvetteTicketGiverConvoHandler:new {
	ticketGiver = ticketGiverTallon
}

tallonIntelSearchMenuComponent = CorvetteIntelSearchMenuComponent:new {
	ticketGiver = ticketGiverTallon
}
