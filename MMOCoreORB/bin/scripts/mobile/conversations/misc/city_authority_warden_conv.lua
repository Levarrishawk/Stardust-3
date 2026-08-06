cityAuthorityWardenConvoTemplate = ConvoTemplate:new {
	initialScreen = "init",
	templateType = "Lua",
	luaClassHandler = "cityAuthorityWardenConvoHandler",
	screens = {},
}

local init = ConvoScreen:new {
	id = "init",
	leftDialog = "",
	stopConversation = "false",
	options = {},
}
cityAuthorityWardenConvoTemplate:addScreen(init)

local payFine = ConvoScreen:new {
	id = "pay_fine",
	leftDialog = "",
	stopConversation = "true",
	options = {},
}
cityAuthorityWardenConvoTemplate:addScreen(payFine)

local endConversation = ConvoScreen:new {
	id = "end_conversation",
	leftDialog = "Very well.",
	stopConversation = "true",
	options = {},
}
cityAuthorityWardenConvoTemplate:addScreen(endConversation)

addConversationTemplate("cityAuthorityWardenConvoTemplate", cityAuthorityWardenConvoTemplate)
