elysiumGuardianConvoTemplate = ConvoTemplate:new {
	initialScreen = "waiting",
	templateType = "Lua",
	luaClassHandler = "elysiumGuardianConvoHandler",
	screens = {}
}

local privileged = ConvoScreen:new {
	id = "privileged",
	leftDialog = "",
	customDialogText = "Which path would you like to test?",
	stopConversation = "false",
	options = {
		{"Test the regular conversation result.", "test_regular"},
		{"Bypass the wait and test the teleport exit.", "test_exit"}
	}
}
elysiumGuardianConvoTemplate:addScreen(privileged)

local testRegular = ConvoScreen:new {
	id = "test_regular",
	leftDialog = "",
	customDialogText = "",
	stopConversation = "true",
	options = {}
}
elysiumGuardianConvoTemplate:addScreen(testRegular)

local testExit = ConvoScreen:new {
	id = "test_exit",
	leftDialog = "",
	customDialogText = "",
	stopConversation = "true",
	options = {}
}
elysiumGuardianConvoTemplate:addScreen(testExit)

local waiting = ConvoScreen:new {
	id = "waiting",
	leftDialog = "",
	customDialogText = "You must continue to contemplate your existence. Return to me once sufficient time has passed.",
	stopConversation = "true",
	options = {}
}
elysiumGuardianConvoTemplate:addScreen(waiting)

local mortisOffer = ConvoScreen:new {
	id = "mortis_offer",
	leftDialog = "",
	customDialogText = "Your path no longer leads back to the living world, Jedi. Death has called you to a greater purpose. Beyond Elysium lies Mortis, where others who once walked your path wage an unending struggle for the balance of the Force. Your arrival may turn the tide. Will you answer that calling?",
	stopConversation = "false",
	options = {
		{"I will answer the call. Take me to Mortis.", "mortis_accept"},
		{"I am not ready. I will remain here.", "mortis_decline"}
	}
}
elysiumGuardianConvoTemplate:addScreen(mortisOffer)

local mortisAccept = ConvoScreen:new {
	id = "mortis_accept",
	leftDialog = "",
	customDialogText = "Then go, and carry your purpose into the struggle. The balance of the Force awaits you on Mortis.",
	stopConversation = "true",
	options = {}
}
elysiumGuardianConvoTemplate:addScreen(mortisAccept)

local mortisDecline = ConvoScreen:new {
	id = "mortis_decline",
	leftDialog = "",
	customDialogText = "Remain in Elysium and seek clarity. When you are ready to face what lies beyond, return to me.",
	stopConversation = "true",
	options = {}
}
elysiumGuardianConvoTemplate:addScreen(mortisDecline)

local mortisUnavailable = ConvoScreen:new {
	id = "mortis_unavailable",
	leftDialog = "",
	customDialogText = "The passage to Mortis is closed for now. Remain here, and return to me when the way opens.",
	stopConversation = "true",
	options = {}
}
elysiumGuardianConvoTemplate:addScreen(mortisUnavailable)

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
