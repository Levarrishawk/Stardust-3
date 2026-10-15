spacestation_coruscant_convotemplate = ConvoTemplate:new {
	initialScreen = "greeting",
	templateType = "Lua",
	luaClassHandler = "SpacestationCoruscantConvoHandler",
	screens = {}
}

local screens = {
	{id = "greeting", customDialogText = "Coruscant Orbital Control. Maintain your assigned approach and keep clear of Imperial fleet operations. State your request.", stopConversation = "false", options = {
		{"Request clearance to Coruscant Spaceport.", "landing"},
		{"Request a full repair estimate.", "repair_quote"},
		{"End transmission.", "goodbye"},
	}},
	{id = "landing", customDialogText = "You are cleared for Coruscant Spaceport. Confirm descent.", stopConversation = "false", options = {
		{"Begin descent.", "land"}, {"Cancel.", "goodbye"},
	}},
	{id = "land", customDialogText = "Transmitting landing coordinates.", stopConversation = "true", options = {}},
	{id = "repair_quote", customDialogText = "Calculating your repair estimate.", stopConversation = "false", options = {
		{"Authorize payment and full repairs.", "repair"}, {"Cancel.", "goodbye"},
	}},
	{id = "repair", customDialogText = "Repair request authorized.", stopConversation = "true", options = {}},
	{id = "unavailable", customDialogText = "Repairs are unavailable. Check your ship's damage and available cash credits.", stopConversation = "true", options = {}},
	{id = "out_of_range", customDialogText = "Approach Coruscant Orbital Control before requesting services.", stopConversation = "true", options = {}},
	{id = "goodbye", customDialogText = "Maintain a safe distance from military vessels. Orbital Control out.", stopConversation = "true", options = {}},
}

for i = 1, #screens do
	spacestation_coruscant_convotemplate:addScreen(ConvoScreen:new(screens[i]))
end

addConversationTemplate("spacestation_coruscant_convotemplate", spacestation_coruscant_convotemplate)
