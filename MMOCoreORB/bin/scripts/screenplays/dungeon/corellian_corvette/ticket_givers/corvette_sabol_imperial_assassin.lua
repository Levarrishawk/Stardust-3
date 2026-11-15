sabolIntel =	{
	itemTemplates = { "object/tangible/loot/dungeon/corellian_corvette/imperial_assassin_filler01.iff", "object/tangible/loot/dungeon/corellian_corvette/imperial_assassin_filler02.iff", "object/tangible/loot/dungeon/corellian_corvette/imperial_assassin_intel.iff" },
	itemNames = { "Superseded Freight Manifest", "Freight Registration Receipt", "Outbound Freight Manifest" },
}

sabolTicketInfo = { depPlanet = "naboo", faction = "imperial", missionType = "assassinate" }

sabolCompensation = { { compType = "faction", faction = "imperial", amount = 100 } }

lt_sabol = { planetName = "tatooine", npcTemplate = "corvette_imperial_sabol", x = -1291.67, z = 12, y = -3539, direction = 110, cellID = 0, position = STAND, mood = "npc_imperial" }

ticketGiverSabol = CorvetteTicketGiverLogic:new {
	npc = lt_sabol,
	intelMap = sabolIntel,
	ticketInfo = sabolTicketInfo,
	contractTitle = "Close the Corridor",
	giverName = "ticketGiverSabol",
	faction = FACTIONIMPERIAL,
	compensation = sabolCompensation,
	menuComponent = "sabolIntelSearchMenuComponent",

	first_location = "Tzarina wreck, Dathomir.",
	second_location = "Freight broker's house, Anchorhead.",
	third_location = "Abandoned outpost, Dantooine.",
	go_get_intel ="@conversation/corvette_sabol_imperial1:s_a5591c27",	--I accept this mission.
	hear_locations_quit = "@conversation/corvette_sabol_imperial1:s_edb0a2f5",	--I can't get myself into this.

	has_intel = "@conversation/corvette_velso_imperial_destroy:s_6e1e63ff", --I believe I found the sequence Sir.
	which_planet = "Can you go over the leads again?",
	back_already_reset = "@conversation/corvette_velso_imperial_destroy:s_a1e2f8b6", --I give up...sir. Please remove all progress I've made from your records.

	bad_intel_1 = "I found the Superseded Freight Manifest.",
	bad_intel_2 = "I found the Freight Registration Receipt.",
	good_intel = "Here is the Outbound Freight Manifest.",

	go_to_corvette = "Where do I take this authorization?",
	check_other_places = "@conversation/corvette_sabol_imperial1:s_a128e067",--Looks like I have more to do.
	other_documents = "@conversation/corvette_sabol_imperial1:s_2f26b4c4", -- I still have documents for you.

	launch_location =  "Remind me where the pickup is.",
	still_here_decline =  "@conversation/corvette_sabol_imperial1:s_5fd624ee", --I wish to quit this mission. Please erase my progress from your records.
}

registerScreenPlay("ticketGiverSabol", true)

ticketGiverSabolConvoHandler = CorvetteTicketGiverConvoHandler:new {
	ticketGiver = ticketGiverSabol
}

sabolIntelSearchMenuComponent = CorvetteIntelSearchMenuComponent:new {
	ticketGiver = ticketGiverSabol
}
