alderaGrandTowerElevatorConvo = ConvoTemplate:new {
	initialScreen = "doorman",
	templateType = "Lua",
	luaClassHandler = "alderaGrandTowerElevatorConvoHandler",
	screens = {}
}

alderaGrandTowerElevatorConvo:addScreen(ConvoScreen:new {
	id = "doorman",
	leftDialog = "",
	customDialogText = "Welcome to the Aldera Grand-Tower. Would you like me to take you up the elevator to the observation lounge?",
	stopConversation = "false",
	options = {
		{"Yes, take me up to the observation lounge.", "go_up"},
		{"Not right now.", "goodbye"}
	}
})

alderaGrandTowerElevatorConvo:addScreen(ConvoScreen:new {
	id = "operator",
	leftDialog = "",
	customDialogText = "Welcome to the observation lounge. Would you like me to take you back to the lobby?",
	stopConversation = "false",
	options = {
		{"Yes, take me back down.", "go_down"},
		{"I'll stay a while.", "goodbye"}
	}
})

alderaGrandTowerElevatorConvo:addScreen(ConvoScreen:new {
	id = "go_up",
	leftDialog = "",
	customDialogText = "Right this way.",
	stopConversation = "true",
	options = {}
})

alderaGrandTowerElevatorConvo:addScreen(ConvoScreen:new {
	id = "go_down",
	leftDialog = "",
	customDialogText = "I'll take you down now.",
	stopConversation = "true",
	options = {}
})

alderaGrandTowerElevatorConvo:addScreen(ConvoScreen:new {
	id = "goodbye",
	leftDialog = "",
	customDialogText = "Enjoy your visit.",
	stopConversation = "true",
	options = {}
})

addConversationTemplate("aldera_grand_tower_elevator", alderaGrandTowerElevatorConvo)
