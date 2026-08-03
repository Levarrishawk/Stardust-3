elysiumForceSpiritConvoTemplate = ConvoTemplate:new {
	initialScreen = "waiting",
	templateType = "Lua",
	luaClassHandler = "elysiumForceSpiritConvoHandler",
	screens = {}
}

local silent = ConvoScreen:new {
	id = "silent",
	leftDialog = "",
	customDialogText = "The spirit looks through you as though you are not there.",
	stopConversation = "true",
	options = {}
}

elysiumForceSpiritConvoTemplate:addScreen(silent)

local waiting = ConvoScreen:new {
	id = "waiting",
	leftDialog = "",
	customDialogText = "You have followed the vision and found me. Few who wander this place would have recognized the call.",
	stopConversation = "false",
	options = {
		{"The structure showed me where to look.", "search_complete"}
	}
}

elysiumForceSpiritConvoTemplate:addScreen(waiting)

local searchComplete = ConvoScreen:new {
	id = "search_complete",
	leftDialog = "",
	customDialogText = "Then the first veil has been lifted. I can send you to the place where the next part of your journey must begin.",
	stopConversation = "false",
	options = {
		{"I am ready. Send me there.", "teleport"},
		{"I need more time.", "not_ready"}
	}
}

elysiumForceSpiritConvoTemplate:addScreen(searchComplete)

local found = ConvoScreen:new {
	id = "found",
	leftDialog = "",
	customDialogText = "You have already proven that you can follow the faintest movement of the Force. Are you ready to continue?",
	stopConversation = "false",
	options = {
		{"I am ready. Send me there.", "teleport"},
		{"Not yet.", "not_ready"}
	}
}

elysiumForceSpiritConvoTemplate:addScreen(found)

local teleport = ConvoScreen:new {
	id = "teleport",
	leftDialog = "",
	customDialogText = "Then step beyond this place and follow where the Force leads you.",
	stopConversation = "true",
	options = {}
}

elysiumForceSpiritConvoTemplate:addScreen(teleport)

local notReady = ConvoScreen:new {
	id = "not_ready",
	leftDialog = "",
	customDialogText = "Return when you are prepared. I will remain here.",
	stopConversation = "true",
	options = {}
}

elysiumForceSpiritConvoTemplate:addScreen(notReady)

addConversationTemplate("elysiumForceSpiritConvoTemplate", elysiumForceSpiritConvoTemplate)
