crowleyIntel = {
	itemTemplates = { "object/tangible/loot/dungeon/corellian_corvette/rebel_destroy_filler01.iff", "object/tangible/loot/dungeon/corellian_corvette/rebel_destroy_filler02.iff", "object/tangible/loot/dungeon/corellian_corvette/rebel_destroy_intel.iff" },
	itemNames = { "Superseded Impound Flight Order", "Navigation Trial Requisition", "Impound Flight Order" },
}

crowleyTicketInfo = { depPlanet = "corellia", faction = "rebel", missionType = "destroy" }

crowleyCompensation = { { compType = "faction", faction = "rebel", amount = 100 } }

crowley = { planetName = "corellia", npcTemplate = "corvette_rebel_crowley", x = -3404.73, z = 86, y = 3092.64, direction = 323, cellID = 0, position = STAND }

ticketGiverCrowley = CorvetteTicketGiverLogic:new {
	npc = crowley,
	intelMap = crowleyIntel,
	ticketInfo = crowleyTicketInfo,
	contractTitle = "An Accident on Paper",
	giverName = "ticketGiverCrowley",
	faction = FACTIONREBEL,
	compensation = crowleyCompensation,
	menuComponent = "CrowleyIntelSearchMenuComponent",

	first_location ="Imperial Outpost, Lok.",
	second_location = "Rogue CorSec bunker, Corellia.",
	third_location = "Imperial Prison, Dathomir.",
	go_get_intel = "@conversation/corvette_crowley_rebel1:s_a5591c27", -- I accept this mission.
	hear_locations_quit = "@conversation/corvette_crowley_rebel1:s_74a0348d",--No thanks. I'm not interested in doing this.

	has_intel = "@conversation/corvette_crowley_rebel1:s_b30bd73c",--Yes, I did.
	which_planet = "Can you go over the leads again?",
	back_already_reset = "@conversation/corvette_crowley_rebel1:s_d5084988", --I cannot continue with this mission. Please erase my progress from your records.

	bad_intel_1 ="I found the Superseded Impound Flight Order.",
	bad_intel_2 ="I found the Navigation Trial Requisition.",
	good_intel ="Here is the Impound Flight Order.",

	go_to_corvette = "Where do I take this authorization?",
	check_other_places = "@conversation/corvette_crowley_rebel1:s_a128e067",--Looks like I have more to do.
	other_documents = "@conversation/corvette_crowley_rebel1:s_2f26b4c4",--I still have documents for you.

	launch_location = "Remind me where the pickup is.",
	still_here_decline = "@conversation/corvette_crowley_rebel1:s_d5084988",--I cannot continue with this mission. Please erase my progress from your records.
}

registerScreenPlay("ticketGiverCrowley", true)

ticketGiverCrowleyConvoHandler = CorvetteTicketGiverConvoHandler:new {
	ticketGiver = ticketGiverCrowley
}

CrowleyIntelSearchMenuComponent = CorvetteIntelSearchMenuComponent:new {
	ticketGiver = ticketGiverCrowley
}
