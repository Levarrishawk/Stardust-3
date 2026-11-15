yondallaIntel =	{
	itemTemplates = { "object/tangible/loot/dungeon/corellian_corvette/neutral_rescue_filler01.iff", "object/tangible/loot/dungeon/corellian_corvette/neutral_rescue_filler02.iff", "object/tangible/loot/dungeon/corellian_corvette/neutral_rescue_intel.iff" },
	itemNames = { "Superseded CorSec Transfer Order", "Joint Custody Handoff Terms", "CorSec Transfer Order" },
}

yondallaTicketInfo = { depPlanet = "tatooine", faction = "neutral", missionType = "rescue" }

yondallaCompensation = { { compType = "credits", amount = 500 } }

yondalla = { planetName = "tatooine", npcTemplate = "corvette_neutral_yondalla", x = 20.19, z = -0.89, y = -19.07, direction = 109, cellID = 1134561, position = STAND }

ticketGiverYondalla = CorvetteTicketGiverLogic:new {
	npc = yondalla,
	intelMap = yondallaIntel,
	ticketInfo = yondallaTicketInfo,
	contractTitle = "Before He Talks",
	giverName = "ticketGiverYondalla",
	faction = 0,
	compensation = yondallaCompensation,
	menuComponent = "YondallaIntelSearchMenuComponent",

	first_location ="Kahmurra research station, Talus.",
	second_location ="Cobral hideout, Rori.",
	third_location ="Korga cave, Endor.",
	go_get_intel ="@conversation/corvette_yondalla_neutral_rescue:s_f7147ad", --Alright, I'll try and find the right papers.
	hear_locations_quit = "@conversation/corvette_yondalla_neutral_rescue:s_3dfd3c32",-- I prefer to stay here on Tatooine, sorry.

	bad_intel_1 = "I found the Superseded CorSec Transfer Order.",
	bad_intel_2 ="I found the Joint Custody Handoff Terms.",
	good_intel ="Here is the CorSec Transfer Order.",

	has_intel ="@conversation/corvette_yondalla_neutral_rescue:s_aa693144",--I have retrieved some documents.
	which_planet = "Can you go over the leads again?",
	back_already_reset ="@conversation/corvette_yondalla_neutral_rescue:s_ec881702", -- I cannot continue. Erase my progress from your records.

	go_to_corvette = "Where do I take this authorization?",
	check_other_places ="@conversation/corvette_yondalla_neutral_rescue:s_6919fb6b",--I will get back to finding it.
	other_documents ="@conversation/corvette_yondalla_neutral_rescue:s_4e2be81c", -- I still have some of the other documents that I found.

	launch_location ="Remind me where the pickup is.",
	still_here_decline = "@conversation/corvette_yondalla_neutral_rescue:s_5dc4acd", -- I've changed my mind. Erase all progress I've made from your records.

}

registerScreenPlay("ticketGiverYondalla", true)

ticketGiverYondallaConvoHandler = CorvetteTicketGiverConvoHandler:new {
	ticketGiver = ticketGiverYondalla
}

YondallaIntelSearchMenuComponent = CorvetteIntelSearchMenuComponent:new {
	ticketGiver = ticketGiverYondalla
}
