local taxi = ConvoTemplate:new {
	initialScreen = "unavailable",
	templateType = "Lua",
	luaClassHandler = "entertainmentDistrictTaxiConvoHandler",
	screens = {},
}

taxi:addScreen(ConvoScreen:new {
	id = "district",
	customDialogText = "Galaxies Opera House? My sister plays third horn up there. She says I'm missing my calling. I tell her I get to honk all day. Want a lift to the red carpet?",
	stopConversation = "false",
	options = {
		{"Yes, take me up to the Opera House.", "board"},
		{"I'll stay in the district, thanks.", "decline"},
	},
})

taxi:addScreen(ConvoScreen:new {
	id = "opera",
	customDialogText = "I used to wait for the applause before warming up the cab. Turns out that opera has three endings. Heading back down to the Entertainment District?",
	stopConversation = "false",
	options = {
		{"Yes, drop me at the district taxi stand.", "board"},
		{"I'll stay at the Opera House a little longer.", "decline"},
	},
})

taxi:addScreen(ConvoScreen:new {
	id = "board",
	customDialogText = "Grab the rail and mind your head getting out.",
	stopConversation = "true",
	options = {},
})

taxi:addScreen(ConvoScreen:new {
	id = "decline",
	customDialogText = "Take your time. You know where to find me.",
	stopConversation = "true",
	options = {},
})

taxi:addScreen(ConvoScreen:new {
	id = "unavailable",
	customDialogText = "Can't clear that pickup just now. Catch me at the stand in a bit.",
	stopConversation = "true",
	options = {},
})

addConversationTemplate("entertainmentDistrictTaxiConvoTemplate", taxi)
