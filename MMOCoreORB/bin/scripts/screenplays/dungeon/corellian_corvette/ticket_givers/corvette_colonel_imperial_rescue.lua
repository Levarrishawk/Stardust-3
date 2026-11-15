darkstoneIntel =	{
	itemTemplates = { "object/tangible/loot/dungeon/corellian_corvette/imperial_rescue_filler01.iff", "object/tangible/loot/dungeon/corellian_corvette/imperial_rescue_filler02.iff", "object/tangible/loot/dungeon/corellian_corvette/imperial_rescue_intel.iff" },
	itemNames = { "Superseded Detainee Movement Order", "Transponder Service Receipt", "Detainee Movement Order" },
}

darkstoneTicketInfo = { depPlanet = "naboo", faction = "imperial", missionType = "rescue" }

darkstoneCompensation = { { compType = "faction", faction = "imperial",  amount = 100 } }

darkstone = { planetName = "tatooine", npcTemplate = "corvette_imperial_darkstone", x = -5313 , z = 8.4, y = 2662, direction = -175, cellID = 0, position = STAND, mood = "npc_imperial"}

ticketGiverDarkstone = CorvetteTicketGiverLogic:new {
	npc = darkstone,
	intelMap = darkstoneIntel,
	ticketInfo = darkstoneTicketInfo,
	contractTitle = "Return to Custody",
	giverName = "ticketGiverDarkstone",
	faction = FACTIONIMPERIAL,
	compensation = darkstoneCompensation,
	menuComponent = "DarkstoneIntelSearchMenuComponent",

	first_location = "Woolamander Temple, Yavin IV.",
	second_location = "Mokk stronghold, Dantooine.",
	third_location = "Droid Engineer Cave, Lok.",
	go_get_intel = "@conversation/corvette_colonel_imperial1:s_a5591c27",	--I accept this mission.
	hear_locations_quit = "@conversation/corvette_colonel_imperial1:s_2a8874c3",--Then again, I'd rather not help. Sorry.

	has_intel = "@conversation/corvette_colonel_imperial1:s_1b0601e4", --I think I've found what you're looking for.
	which_planet = "Can you go over the leads again?",
	back_already_reset = "@conversation/corvette_colonel_imperial1:s_5dad02b", --I don't want to do this anymore. Find someone else and erase all records of my progress.

	bad_intel_1 = "I found the Superseded Detainee Movement Order.",
	bad_intel_2 = "I found the Transponder Service Receipt.",
	good_intel = "Here is the Detainee Movement Order.",

	go_to_corvette = "Where do I take this authorization?",
	check_other_places = "@conversation/corvette_colonel_imperial1:s_a128e067",--Looks like I have more to do.
	other_documents = "@conversation/corvette_colonel_imperial1:s_2f26b4c4", --I still have documents for you.

	launch_location =  "Remind me where the pickup is.",
	still_here_decline =  "@conversation/corvette_colonel_imperial1:s_d5ab67dd", --I don't want to do this anymore. Erase all records of my progress.
}

registerScreenPlay("ticketGiverDarkstone", true)

ticketGiverDarkstoneConvoHandler = CorvetteTicketGiverConvoHandler:new {
	ticketGiver = ticketGiverDarkstone
}

DarkstoneIntelSearchMenuComponent = CorvetteIntelSearchMenuComponent:new {
	ticketGiver = ticketGiverDarkstone
}
