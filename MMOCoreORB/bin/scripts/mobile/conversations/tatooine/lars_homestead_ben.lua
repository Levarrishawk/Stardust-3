larsHomesteadBenConvo = ConvoTemplate:new {
	initialScreen = "hello",
	templateType = "Lua",
	luaClassHandler = "larsHomesteadBenConvoHandler",
	screens = {}
}

larsHomesteadBenConvo:addScreen(ConvoScreen:new {
	id = "hello",
	leftDialog = "",
	customDialogText = "Hello there.",
	stopConversation = "false",
	options = {
		{"Who are you?", "directions"}
	}
})

larsHomesteadBenConvo:addScreen(ConvoScreen:new {
	id = "directions",
	leftDialog = "",
	customDialogText = "My name is Ben. I assume you're lost. If you're looking for Anchorhead, you need to travel to the east.",
	stopConversation = "false",
	options = {
		{"Alright thank you, I will head that way.", "good_journey"},
		{"I'm not looking for anchorhead.", "mind_trick"}
	}
})

larsHomesteadBenConvo:addScreen(ConvoScreen:new {
	id = "good_journey",
	leftDialog = "",
	customDialogText = "May you have a good journey.",
	stopConversation = "true",
	options = {}
})

larsHomesteadBenConvo:addScreen(ConvoScreen:new {
	id = "mind_trick",
	leftDialog = "",
	customDialogText = "** Waves his hand subtly ** You are Looking for Anchorhead, and are grateful for the directions.",
	stopConversation = "false",
	options = {
		{"I am looking for Anchorhead, I am very grateful for the assistance.", "run_along"}
	}
})

larsHomesteadBenConvo:addScreen(ConvoScreen:new {
	id = "run_along",
	leftDialog = "",
	customDialogText = "Now run along, and forget this conversation ever took place.",
	stopConversation = "true",
	options = {}
})

addConversationTemplate("lars_homestead_ben", larsHomesteadBenConvo)
