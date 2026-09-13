aqzow_liaison_convo = ConvoTemplate:new {
	initialScreen = "greeting",
	templateType = "Lua",
	luaClassHandler = "aqzowLiaisonConvoHandler",
	screens = {}
}

aqzow_liaison_greeting = ConvoScreen:new {
	id = "greeting",
	customDialogText = "Lieutenant Colonel Aqzow has transferred to the Hidden Rebel Base on Yavin 4. I can upload his new coordinates to your datapad.",
	stopConversation = "false",
	options = {
		{"Upload Aqzow's coordinates.", "give_waypoint"},
		{"No, thank you.", "decline"}
	}
}
aqzow_liaison_convo:addScreen(aqzow_liaison_greeting)

aqzow_liaison_give_waypoint = ConvoScreen:new {
	id = "give_waypoint",
	customDialogText = "Aqzow is at the Hidden Rebel Base, near -3078, -2998. The waypoint is now in your datapad.",
	stopConversation = "true",
	options = {}
}
aqzow_liaison_convo:addScreen(aqzow_liaison_give_waypoint)

aqzow_liaison_decline = ConvoScreen:new {
	id = "decline",
	customDialogText = "Very well. Return if you need Aqzow's location.",
	stopConversation = "true",
	options = {}
}
aqzow_liaison_convo:addScreen(aqzow_liaison_decline)

addConversationTemplate("aqzow_liaison_convo", aqzow_liaison_convo)
