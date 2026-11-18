local palace = ConvoTemplate:new {
	initialScreen = "visitor",
	templateType = "Lua",
	luaClassHandler = "imperialPalaceLiaisonConvoHandler",
	screens = {},
}

palace:addScreen(ConvoScreen:new {
	id = "visitor",
	customDialogText = "The five spires above the port are the Imperial Palace. They stood here when this was the Jedi Temple. I can spare a moment before the next transport. What did you want to know?",
	stopConversation = "false",
	options = {
		{"Whose statues stand in the Great Hall?", "sages"},
		{"What became of the old Council Chamber?", "council"},
		{"Could I see the palace for myself?", "move_along"},
	},
})

palace:addScreen(ConvoScreen:new {
	id = "sages",
	customDialogText = "The Four Sages of Dwartii. The Jedi statues came down when the Emperor took possession. Yesterday a cadet saluted the Sage with the book. I let him finish. A philosopher can use a little encouragement. Now move along, please. This pad is for palace business.",
	stopConversation = "true",
	options = {},
})

palace:addScreen(ConvoScreen:new {
	id = "council",
	customDialogText = "The Council sat in the northwest tower. The Emperor ordered the chamber kept exactly as it was. Once a year someone still has to go up and count the chairs. Now, unless you've brought me a dispatch, move along. I have a departure to clear.",
	stopConversation = "true",
	options = {},
})

palace:addScreen(ConvoScreen:new {
	id = "move_along",
	customDialogText = "You've a fine view of the spires from this rail. Your name is absent from the passenger manifest, so this is as close as I can take you. Move along, please.",
	stopConversation = "true",
	options = {},
})

palace:addScreen(ConvoScreen:new {
	id = "trusted",
	customDialogText = "I recognize your service seal from the Emperor's Retreat. His Majesty keeps a seat available for the people he trusts. Shall I put you aboard the palace transport?",
	stopConversation = "false",
	options = {
		{"Yes. Take me to the Great Hall.", "imperial_board"},
		{"Another time, Officer.", "decline"},
	},
})

palace:addScreen(ConvoScreen:new {
	id = "papers",
	customDialogText = "One seat left on the palace run. If you're the courier, I'll need the whole authorization chain. Yesterday someone tried to board with nothing but a luggage seal.",
	stopConversation = "false",
	options = {
		{"[Present forged authorization] Courier Dorn-Seven, countersigned by Palace Dispatch, seal Aurek-Nine.", "rebel_board"},
		{"You must be expecting someone else.", "decline"},
	},
})

palace:addScreen(ConvoScreen:new {
	id = "privileged",
	customDialogText = "Priority clearance acknowledged. Shall I wave the transport through?",
	stopConversation = "false",
	options = {
		{"[Privileged bypass] Take me directly to the palace.", "privileged_board"},
		{"Stand down, Officer.", "decline"},
	},
})

palace:addScreen(ConvoScreen:new {
	id = "insurgent",
	customDialogText = "I know that insignia. Step away from the transport, insurgent.",
	stopConversation = "true",
	options = {},
})

palace:addScreen(ConvoScreen:new {
	id = "imperial_board",
	customDialogText = "Pilot, one passenger for the Great Hall. Safe journey.",
	stopConversation = "true",
	options = {},
})

palace:addScreen(ConvoScreen:new {
	id = "rebel_board",
	customDialogText = "Aurek-Nine checks out. Mind your dispatch case when you disembark, courier.",
	stopConversation = "true",
	options = {},
})

palace:addScreen(ConvoScreen:new {
	id = "privileged_board",
	customDialogText = "Right away. The Great Hall landing is yours.",
	stopConversation = "true",
	options = {},
})

palace:addScreen(ConvoScreen:new {
	id = "unavailable",
	customDialogText = "The palace landing hasn't cleared us. We're holding here until I hear from them.",
	stopConversation = "true",
	options = {},
})

palace:addScreen(ConvoScreen:new {
	id = "decline",
	customDialogText = "Very good. I'll keep the manifest open until departure.",
	stopConversation = "true",
	options = {},
})

palace:addScreen(ConvoScreen:new {
	id = "departure",
	customDialogText = "Returning to the starport? There's a transport on the pad. I can have you back in the district before the pilot finishes complaining about the traffic.",
	stopConversation = "false",
	options = {
		{"Yes. Take me back to the starport.", "return_board"},
		{"I'll stay a little longer.", "decline"},
	},
})

palace:addScreen(ConvoScreen:new {
	id = "return_board",
	customDialogText = "One for the starport. Watch your step on the landing.",
	stopConversation = "true",
	options = {},
})

addConversationTemplate("imperialPalaceLiaisonConvoTemplate", palace)
