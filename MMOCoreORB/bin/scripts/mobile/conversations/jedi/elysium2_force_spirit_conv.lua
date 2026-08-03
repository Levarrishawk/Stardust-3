local function createElysiumTwoConversation(templateName, handlerName, openingText, optionText, completionText)
	local convoTemplate = ConvoTemplate:new {
		initialScreen = "intro",
		templateType = "Lua",
		luaClassHandler = handlerName,
		screens = {}
	}

	convoTemplate:addScreen(ConvoScreen:new {
		id = "silent",
		leftDialog = "",
		customDialogText = "The spirit offers no response.",
		stopConversation = "true",
		options = {}
	})

	convoTemplate:addScreen(ConvoScreen:new {
		id = "intro",
		leftDialog = "",
		customDialogText = openingText,
		stopConversation = "false",
		options = {{optionText, "complete"}}
	})

	convoTemplate:addScreen(ConvoScreen:new {
		id = "complete",
		leftDialog = "",
		customDialogText = completionText,
		stopConversation = "true",
		options = {}
	})

	convoTemplate:addScreen(ConvoScreen:new {
		id = "already_complete",
		leftDialog = "",
		customDialogText = "You already carry everything I can teach you.",
		stopConversation = "true",
		options = {}
	})

	addConversationTemplate(templateName, convoTemplate)
	return convoTemplate
end

elysiumTwoForceSpiritConvoTemplate = createElysiumTwoConversation(
	"elysiumTwoForceSpiritConvoTemplate",
	"elysiumTwoForceSpiritConvoHandler",
	"You have crossed the threshold. What stirred within you on Elysium must now be acknowledged before it can be shaped.",
	"I am ready to accept what I have become.",
	"Then awaken. The paths of Force sensitivity now stand before you. Seek the spirits gathered here and learn what each guards."
)

elysiumCombatSpiritConvoTemplate = createElysiumTwoConversation(
	"elysiumCombatSpiritConvoTemplate",
	"elysiumCombatSpiritConvoHandler",
	"The Force moves through every strike, but prowess without discipline is merely violence.",
	"Teach me the path of combat prowess.",
	"Your body now remembers what your conscious mind has yet to understand."
)

elysiumReflexesSpiritConvoTemplate = createElysiumTwoConversation(
	"elysiumReflexesSpiritConvoTemplate",
	"elysiumReflexesSpiritConvoHandler",
	"To move with the Force, you must cease waiting for danger to announce itself.",
	"Teach me the path of enhanced reflexes.",
	"Release thought. Let the Force move before uncertainty can restrain you."
)

elysiumCraftingSpiritConvoTemplate = createElysiumTwoConversation(
	"elysiumCraftingSpiritConvoTemplate",
	"elysiumCraftingSpiritConvoHandler",
	"Creation is not separate from the Force. Every material carries a history and every finished work carries intent.",
	"Teach me the path of crafting mastery.",
	"You can now feel the possibilities held within the things you shape."
)

elysiumSensesSpiritConvoTemplate = createElysiumTwoConversation(
	"elysiumSensesSpiritConvoTemplate",
	"elysiumSensesSpiritConvoHandler",
	"Your eyes reveal only what light permits. The Force is not limited by such boundaries.",
	"Teach me the path of heightened senses.",
	"Be still, and what was hidden beneath the noise will reveal itself."
)

elysiumInitiateSpiritConvoTemplate = ConvoTemplate:new {
	initialScreen = "intro",
	templateType = "Lua",
	luaClassHandler = "elysiumInitiateSpiritConvoHandler",
	screens = {}
}

elysiumInitiateSpiritConvoTemplate:addScreen(ConvoScreen:new {
	id = "silent",
	leftDialog = "",
	customDialogText = "The spirit regards you in silence. Your preparation is not yet complete.",
	stopConversation = "true",
	options = {}
})

elysiumInitiateSpiritConvoTemplate:addScreen(ConvoScreen:new {
	id = "intro",
	leftDialog = "",
	customDialogText = "You have learned the four disciplines and awakened what slept within you. One threshold remains. Beyond it, you will stand as a Jedi Initiate and your trials will begin.",
	stopConversation = "false",
	options = {{"I am ready to leave Elysium and face the trials.", "depart"}}
})

elysiumInitiateSpiritConvoTemplate:addScreen(ConvoScreen:new {
	id = "depart",
	leftDialog = "",
	customDialogText = "Then go. Seek the shrine before you and meditate there. The Force will determine where your trials begin.",
	stopConversation = "true",
	options = {}
})

elysiumInitiateSpiritConvoTemplate:addScreen(ConvoScreen:new {
	id = "complete",
	leftDialog = "",
	customDialogText = "Your path now lies beyond Elysium.",
	stopConversation = "true",
	options = {}
})

addConversationTemplate("elysiumInitiateSpiritConvoTemplate", elysiumInitiateSpiritConvoTemplate)
