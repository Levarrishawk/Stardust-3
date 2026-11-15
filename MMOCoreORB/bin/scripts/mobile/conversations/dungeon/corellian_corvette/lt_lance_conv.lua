corvetteLtLanceConvoTemplate = ConvoTemplate:new {
	initialScreen = "start",
	templateType = "Lua",
	luaClassHandler = "ticketTakerLtLanceConvoHandler",
	screens = {}
}

start = ConvoScreen:new {
	id = "start",
	customDialogText = "Tyrena Freight Dispatch. Are you checking in for a crew transfer?",
	stopConversation = "false",
	options = {}
}

corvetteLtLanceConvoTemplate:addScreen(start);

goodbye = ConvoScreen:new {
	id = "goodbye",
	customDialogText = "Passenger inquiries are at the main terminal.",
	stopConversation = "true",
	options = {}
}

corvetteLtLanceConvoTemplate:addScreen(goodbye);

too_many = ConvoScreen:new {
	id = "too_many",
	customDialogText = "The shuttle carries ten. Check in again when you've got ten or fewer.",
	stopConversation = "true",
	options = {}
}

corvetteLtLanceConvoTemplate:addScreen(too_many);

wrong_faction = ConvoScreen:new {
	id = "wrong_faction",
	customDialogText = "Everyone boarding must be cleared for this flight.",
	stopConversation = "true",
	options = {}
}

corvetteLtLanceConvoTemplate:addScreen(wrong_faction);

wrong_faction_too_many = ConvoScreen:new {
	id = "wrong_faction_too_many",
	customDialogText = "I can take ten cleared passengers. Check your roster.",
	stopConversation = "true",
	options = {}
}

corvetteLtLanceConvoTemplate:addScreen(wrong_faction_too_many);

continue = ConvoScreen:new {
	id = "continue",
	customDialogText = "Keep your voice down and show me your crew authorization.",
	stopConversation = "false",
	options = {}
}

corvetteLtLanceConvoTemplate:addScreen(continue);

goodbye2 = ConvoScreen:new {
	id = "goodbye2",
	customDialogText = "Understood. Come back when your crew is ready.",
	stopConversation = "true",
	options = {}
}

corvetteLtLanceConvoTemplate:addScreen(goodbye2);

mission_too_many = ConvoScreen:new {
	id = "mission_too_many",
	customDialogText = "I can take ten. Come back when the crew is within that limit.",
	stopConversation = "true",
	options = {}
}

corvetteLtLanceConvoTemplate:addScreen(mission_too_many);

mission_wrong_faction = ConvoScreen:new {
	id = "mission_wrong_faction",
	customDialogText = "I can only take people cleared for this work. Check your roster.",
	stopConversation = "true",
	options = {}
}

corvetteLtLanceConvoTemplate:addScreen(mission_wrong_faction);

mission_wrong_faction_too_many = ConvoScreen:new {
	id = "mission_wrong_faction_too_many",
	customDialogText = "I have ten seats and each one needs a cleared name. Check your roster.",
	stopConversation = "true",
	options = {}
}

corvetteLtLanceConvoTemplate:addScreen(mission_wrong_faction_too_many);

mission = ConvoScreen:new {
	id = "mission",
	customDialogText = "You're the relief crew? Good. Keep that authorization handy until we're clear. You'll have an hour aboard the corvette. Bring everyone to the pickup before we leave.",
	stopConversation = "false",
	options = {
		{"Here's the crew authorization.", "authorization"},
		{"We need a little more time.", "goodbye3"}
	}
}

corvetteLtLanceConvoTemplate:addScreen(mission);

authorization = ConvoScreen:new {
	id = "authorization",
	customDialogText = "Let's see the crew authorization. Have your crew stand close enough for me to clear them.",
	stopConversation = "true",
	options = {}
}

corvetteLtLanceConvoTemplate:addScreen(authorization);

goodbye3 = ConvoScreen:new {
	id = "goodbye3",
	customDialogText = "I'll be here when you're ready.",
	stopConversation = "true",
	options = {}
}

corvetteLtLanceConvoTemplate:addScreen(goodbye3);

addConversationTemplate("corvetteLtLanceConvoTemplate", corvetteLtLanceConvoTemplate);
