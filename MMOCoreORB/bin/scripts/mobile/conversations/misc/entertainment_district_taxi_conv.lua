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
	id = "southCantina",
	customDialogText = "Hear that bass through the wall? When the glasses start rattling, it's time for my opera run. Fancy trading it for a string section?",
	stopConversation = "false",
	options = {
		{"Yes, take me up to the Opera House.", "board"},
		{"I'm staying at the cantina, thanks.", "decline"},
	},
})

taxi:addScreen(ConvoScreen:new {
	id = "opera",
	customDialogText = "I used to wait for the applause before warming up the cab. Turns out that opera has three endings. Where shall I drop you, the West Bank or the South Cantina?",
	stopConversation = "false",
	options = {
		{"Take me to the West Bank taxi stand.", "board"},
		{"Drop me at the South Cantina taxi stand.", "boardSouthCantina"},
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
	id = "boardSouthCantina",
	customDialogText = "South Cantina it is. I'll let you out by Vela's cab.",
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
