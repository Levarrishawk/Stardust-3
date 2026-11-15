pashnaIntel = {
	itemTemplates = { "object/tangible/loot/dungeon/corellian_corvette/rebel_assassin_filler01.iff", "object/tangible/loot/dungeon/corellian_corvette/rebel_assassin_filler02.iff", "object/tangible/loot/dungeon/corellian_corvette/rebel_assassin_intel.iff" },
	itemNames = { "Superseded Transit Warrant", "Confiscated Effects Inventory", "Inquisitorial Transit Warrant" },
}

pashnaTicketInfo = { depPlanet = "corellia", faction = "rebel", missionType = "assassinate" }

pashnaCompensation = { { compType = "faction", faction = "rebel", amount = 100 } }

pashna = { planetName = "corellia", npcTemplate = "corvette_rebel_pashna", x = 6772.57, z = 315, y = -5697.8, direction = 245, cellID = 0, position = STAND }

ticketGiverPashna = CorvetteTicketGiverLogic:new {
	npc = pashna,
	intelMap = pashnaIntel,
	ticketInfo = pashnaTicketInfo,
	contractTitle = "The Inquisitor's Warrant",
	giverName = "ticketGiverPashna",
	faction = FACTIONREBEL,
	compensation = pashnaCompensation,
	menuComponent = "PashnaIntelSearchMenuComponent",

	first_location ="Fort Tusken, Tatooine.",
	second_location = "Lord Nyax bunker, Corellia.",
	third_location = "Geonosian laboratory, Yavin IV.",
	go_get_intel = "@conversation/corvette_pashna_rebel1:s_a5591c27", -- I accept this mission.
	hear_locations_quit = "@conversation/corvette_pashna_rebel1:s_36cb0506",--No, maybe another time. Good bye.

	has_intel = "@conversation/corvette_pashna_rebel1:s_aa504b9e",--I think I've found something...
	which_planet = "Can you go over the leads again?",
	back_already_reset = "@conversation/corvette_pashna_rebel1:s_1729866a",--I've decided to abort the mission. Please erase all records of my progress.

	bad_intel_1 = "I found the Superseded Transit Warrant.",
	bad_intel_2 = "I found the Confiscated Effects Inventory.",
	good_intel = "Here is the Inquisitorial Transit Warrant.",

	go_to_corvette = "Where do I take this authorization?",
	check_other_places = "@conversation/corvette_pashna_rebel1:s_a128e067",--Looks like I have more to do.
	other_documents = "@conversation/corvette_pashna_rebel1:s_2f26b4c4",--I still have documents for you.

	launch_location = "Remind me where the pickup is.",
	still_here_decline = "@conversation/corvette_pashna_rebel1:s_32abdf15",--I can't do this anymore. I have to resign from the mission.
}

registerScreenPlay("ticketGiverPashna", true)

ticketGiverPashnaConvoHandler = CorvetteTicketGiverConvoHandler:new {
	ticketGiver = ticketGiverPashna
}

PashnaIntelSearchMenuComponent = CorvetteIntelSearchMenuComponent:new {
	ticketGiver = ticketGiverPashna
}
