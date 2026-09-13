aqzow_liaison_convo = ConvoTemplate:new {
	initialScreen = "greeting",
	templateType = "Lua",
	luaClassHandler = "aqzowLiaisonConvoHandler",
	screens = {}
}

aqzow_liaison_greeting = ConvoScreen:new {
	id = "greeting",
	customDialogText = "Lady Viopa has vetted you for clearance, and guess what... You've been cleared, otherwise I'd have met you with a blaster in your face.   You're looking for Colonel Aqzow right?   I can upload his coordinates to your datapad.  Hope you don't mind trudging through the heat and mud in this Jungle to get to him.   You'll understand when you get there why we take such precautions.",
	stopConversation = "false",
	options = {
		{"Upload Aqzow's coordinates.", "give_waypoint"},
		{"No, thank you.", "decline"}
	}
}
aqzow_liaison_convo:addScreen(aqzow_liaison_greeting)

aqzow_liaison_give_waypoint = ConvoScreen:new {
	id = "give_waypoint",
	customDialogText = "Aqzow is near -3078, -2998. The waypoint is now in your datapad.",
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
