corvetteBledsoeConvoTemplate = ConvoTemplate:new {
	initialScreen = "",
	templateType = "Lua",
	luaClassHandler = "corvetteBledsoeConvoHandler",
	screens = {}
}

intro = ConvoScreen:new {
	id = "intro",
	customDialogText = "Darkstone sent you, I take it. They keep talking about a hearing. I signed a quarantine order. What the local commanders did with it is their affair.",
	stopConversation = "false",
	options = {
		{"Darkstone sent us. The way out is clear.", "good_work"},
		{"Some of your captors may still be in the corridor.", "cleanse_ship"},
	}
}
corvetteBledsoeConvoTemplate:addScreen(intro);

already_rescued = ConvoScreen:new {
	id = "already_rescued",
	customDialogText = "We should discuss this once I'm back in Imperial custody. Where's that elevator?",
	stopConversation = "true",
	options = { }
}
corvetteBledsoeConvoTemplate:addScreen(already_rescued);

good_work = ConvoScreen:new {
	id = "good_work",
	customDialogText = "Good. I'll head to the forward elevator. I expect a proper escort back into custody.",
	stopConversation = "true",
	options = {}
}
corvetteBledsoeConvoTemplate:addScreen(good_work);

cleanse_ship = ConvoScreen:new {
	id = "cleanse_ship",
	customDialogText = "They intended to put me on display. I expect you to deal with anyone still in the corridor.",
	stopConversation = "false",
	options = {
		{"I'll see you through it.", "great_work"},
		{"My orders are to bring you back. Let's go.", "breed_and_spread"},
	}
}
corvetteBledsoeConvoTemplate:addScreen(cleanse_ship);

great_work = ConvoScreen:new {
	id = "great_work",
	customDialogText = "See that the corridor is clear. I'll make for the forward elevator.",
	stopConversation = "true",
	options = {}
}
corvetteBledsoeConvoTemplate:addScreen(great_work);

breed_and_spread = ConvoScreen:new {
	id = "breed_and_spread",
	customDialogText = "Fine, get me out of here. If anyone asks, I signed those orders under instruction.",
	stopConversation = "true",
	options = {}
}
corvetteBledsoeConvoTemplate:addScreen(breed_and_spread);

addConversationTemplate("corvetteBledsoeConvoTemplate", corvetteBledsoeConvoTemplate);
