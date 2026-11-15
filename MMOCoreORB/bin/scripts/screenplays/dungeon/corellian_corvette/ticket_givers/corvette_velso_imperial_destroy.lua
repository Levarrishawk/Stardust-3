velsoIntel =	{
	itemTemplates = { "object/tangible/loot/dungeon/corellian_corvette/imperial_destroy_filler01.iff", "object/tangible/loot/dungeon/corellian_corvette/imperial_destroy_filler02.iff", "object/tangible/loot/dungeon/corellian_corvette/imperial_destroy_intel.iff" },
	itemNames = { "Superseded Drive Service Packet", "Spare Parts Waybill", "Drive Service Packet" },
}

velsoTicketInfo = { depPlanet = "naboo", faction = "imperial", missionType = "destroy" }

velsoCompensation = { { compType = "faction", faction = "imperial",  amount = 100 } }

lt_velso = { planetName = "naboo", npcTemplate = "corvette_imperial_velso", x = 23.4, z = .2, y = -19.4, direction = 180, cellID = 1418874, position = STAND, mood = "npc_imperial"}

ticketGiverVelso = CorvetteTicketGiverLogic:new {
	npc = lt_velso,
	intelMap = velsoIntel,
	ticketInfo = velsoTicketInfo,
	contractTitle = "Medical Registry",
	giverName = "ticketGiverVelso",
	faction = FACTIONIMPERIAL,
	compensation = velsoCompensation,
	menuComponent = "VelsoIntelSearchMenuComponent",

	first_location = "Erran Sif's bunker, Talus.",
	second_location = "Afarathu cave, Corellia.",
	third_location = "Janta cave, Dantooine.",
	go_get_intel = "@conversation/corvette_velso_imperial_destroy:s_8b2cc767", -- Alright Sir. I will take off at once.
	hear_locations_quit = "@conversation/corvette_velso_imperial_destroy:s_d5fd52c1",--Ok this definitely doesn't sound like my cup of Doxxen tea.

	has_intel = "@conversation/corvette_velso_imperial_destroy:s_6e1e63ff",  --I believe I found the sequence Sir.
	which_planet = "Can you go over the leads again?",
	back_already_reset = "@conversation/corvette_velso_imperial_destroy:s_a1e2f8b6", --I give up...sir. Please remove all progress I've made from your records.

	bad_intel_1 = "I found the Superseded Drive Service Packet.",
	bad_intel_2 = "I found the Spare Parts Waybill.",
	good_intel = "Here is the Drive Service Packet.",

	go_to_corvette = "Where do I take this authorization?",
	check_other_places = "@conversation/corvette_velso_imperial_destroy:s_e60ca0aa", --Alright Sir, I'll get back to searching.
	other_documents = "@conversation/corvette_velso_imperial_destroy:s_cd8ede71", --I found some other documents as well.

	launch_location = "Remind me where the pickup is.",
	still_here_decline = "@conversation/corvette_velso_imperial_destroy:s_547609c8", --I can't do this. Please remove all progress I've made from your records.
}

registerScreenPlay("ticketGiverVelso", true)

ticketGiverVelsoConvoHandler = CorvetteTicketGiverConvoHandler:new {
	ticketGiver = ticketGiverVelso
}

VelsoIntelSearchMenuComponent = CorvetteIntelSearchMenuComponent:new {
	ticketGiver = ticketGiverVelso
}
