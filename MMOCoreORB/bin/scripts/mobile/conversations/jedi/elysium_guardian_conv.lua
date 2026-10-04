elysiumGuardianConvoTemplate = ConvoTemplate:new {
	initialScreen = "waiting",
	templateType = "Lua",
	luaClassHandler = "elysiumGuardianConvoHandler",
	screens = {}
}

local waiting = ConvoScreen:new {
	id = "waiting",
	leftDialog = "",
	customDialogText = "You must continue to contemplate your existence. Return to me once sufficient time has passed.",
	stopConversation = "true",
	options = {}
}
elysiumGuardianConvoTemplate:addScreen(waiting)

local rejected = ConvoScreen:new {
	id = "rejected",
	leftDialog = "",
	customDialogText = "There are no second chances for people like you.",
	stopConversation = "true",
	options = {}
}
elysiumGuardianConvoTemplate:addScreen(rejected)

local offer = ConvoScreen:new {
	id = "offer",
	leftDialog = "",
	customDialogText = "You have contemplated your existence for sufficient time. I offer you resurrection. Will you return to the living?",
	stopConversation = "false",
	options = {
		{"I accept. Return me to the living.", "resurrect"},
		{"I am not ready.", "decline"}
	}
}
elysiumGuardianConvoTemplate:addScreen(offer)

local resurrect = ConvoScreen:new {
	id = "resurrect",
	leftDialog = "",
	customDialogText = "Return to the living. Your journey begins anew at a shrine of the Force.",
	stopConversation = "true",
	options = {}
}
elysiumGuardianConvoTemplate:addScreen(resurrect)

local decline = ConvoScreen:new {
	id = "decline",
	leftDialog = "",
	customDialogText = "Return to me when you are ready.",
	stopConversation = "true",
	options = {}
}
elysiumGuardianConvoTemplate:addScreen(decline)

local unavailable = ConvoScreen:new {
	id = "unavailable",
	leftDialog = "",
	customDialogText = "The way to the living is closed for now. Return to me later.",
	stopConversation = "true",
	options = {}
}
elysiumGuardianConvoTemplate:addScreen(unavailable)

addConversationTemplate("elysiumGuardianConvoTemplate", elysiumGuardianConvoTemplate)
