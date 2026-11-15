bruceIntel =	{
	itemTemplates = { "object/tangible/loot/dungeon/corellian_corvette/neutral_destroy_filler01.iff", "object/tangible/loot/dungeon/corellian_corvette/neutral_destroy_filler02.iff", "object/tangible/loot/dungeon/corellian_corvette/neutral_destroy_intel.iff" },
	itemNames = { "Expired CorSec Destruct Codes", "CorSec Evidence Shipping Record", "CorSec Destruct Sequence Codes" },
}

bruceTicketInfo = { depPlanet = "tatooine", faction = "neutral", missionType = "destroy" }

bruceCompensation = { { compType = "credits", amount = 487 } }

bruce_mcbrain = { planetName = "tatooine", npcTemplate = "corvette_neutral_bruce", x = 7.71, z = 0.2, y = 130.29, direction = 292, cellID = 1177466, position = STAND }

ticketGiverBruce = CorvetteTicketGiverLogic:new {
	npc = bruce_mcbrain,
	intelMap = bruceIntel,
	ticketInfo = bruceTicketInfo,
	contractTitle = "The Audit Shipment",
	giverName = "ticketGiverBruce",
	faction = 0,
	compensation = bruceCompensation,
	menuComponent = "BruceIntelSearchMenuComponent",

	first_location = "Mauler stronghold, Naboo.",
	second_location = "Rogue CorSec bunker, Corellia.",
	third_location = "Nightsister labor camp, Dathomir.",
	go_get_intel = "@conversation/corvette_bruce_neutral_destroy:s_65ecd99d", -- Alright, I will try and find the sequence.
	hear_locations_quit = "@conversation/corvette_bruce_neutral_destroy:s_369d526d",-- Sorry, this sounds like something I can't do right now.

	has_intel = "@conversation/corvette_bruce_neutral_destroy:s_ca5faf1b", --I've found some documents that may be it.
	which_planet = "Can you go over the leads again?",
	back_already_reset = "@conversation/corvette_bruce_neutral_destroy:s_283ba480", -- Sorry, I give up, this is taking too long.

	bad_intel_1 = "I found the Expired CorSec Destruct Codes.",
	bad_intel_2 = "I found the CorSec Evidence Shipping Record.",
	good_intel = "Here is the CorSec Destruct Sequence Codes.",
	go_to_corvette = "Where do I take this authorization?",

	check_other_places = "@conversation/corvette_bruce_neutral_destroy:s_7e619810",--So I guess I'll have to go and check the other places.
	other_documents = "@conversation/corvette_bruce_neutral_destroy:s_3bfca8b3", -- I was wondering if these other documents would be of use?

	launch_location= "Remind me where the pickup is.",
	still_here_decline = "@conversation/corvette_bruce_neutral_destroy:s_dc1051b",-- Something came up, can't do it right now.
}

registerScreenPlay("ticketGiverBruce", true)

ticketGiverBruceConvoHandler = CorvetteTicketGiverConvoHandler:new {
	ticketGiver = ticketGiverBruce
}

BruceIntelSearchMenuComponent = CorvetteIntelSearchMenuComponent:new {
	ticketGiver = ticketGiverBruce
}
