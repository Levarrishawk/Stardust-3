eker_liaison_convo = ConvoTemplate:new {
	initialScreen = "greeting",
	templateType = "Lua",
	luaClassHandler = "ekerLiaisonConvoHandler",
	screens = {}
}

eker_liaison_greeting = ConvoScreen:new {
	id = "greeting",
	customDialogText = "Commander Socuna has cleared you to report to Major Eker. He's no longer stationed at this outpost; his unit has relocated to the Hidden Rebel Base. I can upload the base coordinates to your datapad.",
	stopConversation = "false",
	options = {
		{"Upload Major Eker's coordinates.", "give_waypoint"},
		{"No, thank you.", "decline"}
	}
}
eker_liaison_convo:addScreen(eker_liaison_greeting)

eker_liaison_give_waypoint = ConvoScreen:new {
	id = "give_waypoint",
	customDialogText = "Major Eker is at the Hidden Rebel Base near -3078, -2998. The waypoint is now in your datapad.",
	stopConversation = "true",
	options = {}
}
eker_liaison_convo:addScreen(eker_liaison_give_waypoint)

eker_liaison_decline = ConvoScreen:new {
	id = "decline",
	customDialogText = "Very well. Return if you need Major Eker's location.",
	stopConversation = "true",
	options = {}
}
eker_liaison_convo:addScreen(eker_liaison_decline)

addConversationTemplate("eker_liaison_convo", eker_liaison_convo)
