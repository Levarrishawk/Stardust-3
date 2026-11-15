corvetteIanConvoTemplate = ConvoTemplate:new {
	initialScreen = "",
	templateType = "Lua",
	luaClassHandler = "corvetteIanConvoHandler",
	screens = {}
}

intro = ConvoScreen:new {
	id = "intro",
	customDialogText = "They stopped asking about the seized freight when they realized I'd seen who signed the reports. Is Tallon the one who sent you?",
	stopConversation = "false",
	options = {
		{"We came on our own. Can you walk?", "safe_haven"},
		{"Tallon sent us. He arranged a pickup.", "excellent_work"},
	}
}
corvetteIanConvoTemplate:addScreen(intro);

already_rescued = ConvoScreen:new {
	id = "already_rescued",
	customDialogText = "I'll tell you what I saw after we get off this ship. Let's move.",
	stopConversation = "true",
	options = { }
}
corvetteIanConvoTemplate:addScreen(already_rescued);

safe_haven = ConvoScreen:new {
	id = "safe_haven",
	customDialogText = "Then I owe you one. I can get to the forward elevator. Tell Tallon I'll make the pickup.",
	stopConversation = "true",
	options = { }
}
corvetteIanConvoTemplate:addScreen(safe_haven);

excellent_work = ConvoScreen:new {
	id = "excellent_work",
	customDialogText = "I had a feeling he'd find a way. I'll head for the forward elevator and take his ride out.",
	stopConversation = "true",
	options = {}
}
corvetteIanConvoTemplate:addScreen(excellent_work);

addConversationTemplate("corvetteIanConvoTemplate", corvetteIanConvoTemplate);
