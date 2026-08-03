elysiumForceSpiritConvoTemplate = ConvoTemplate:new {
	initialScreen = "",
	templateType = "Lua",
	luaClassHandler = "elysiumForceSpiritConvoHandler",
	screens = {}
}

local silent = ConvoScreen:new {
	id = "silent",
	leftDialog = "The spirit looks through you as though you are not there.",
	stopConversation = "true",
	options = {}
}

elysiumForceSpiritConvoTemplate:addScreen(silent)

local waiting = ConvoScreen:new {
	id = "waiting",
	leftDialog = "You have followed the vision and found me. Few who wander this place would have recognized the call.",
	stopConversation = "false",
	options = {
		{"The structure showed me where to look.", "search_complete"}
	}
}

elysiumForceSpiritConvoTemplate:addScreen(waiting)

local searchComplete = ConvoScreen:new {
	id = "search_complete",
	leftDialog = "Then the first veil has been lifted. Return when you are prepared to learn why the Force has drawn you here.",
	stopConversation = "true",
	options = {}
}

elysiumForceSpiritConvoTemplate:addScreen(searchComplete)

local found = ConvoScreen:new {
	id = "found",
	leftDialog = "You have already proven that you can follow the faintest movement of the Force. Our work will continue when you are ready.",
	stopConversation = "true",
	options = {}
}

elysiumForceSpiritConvoTemplate:addScreen(found)

addConversationTemplate("elysiumForceSpiritConvoTemplate", elysiumForceSpiritConvoTemplate)
