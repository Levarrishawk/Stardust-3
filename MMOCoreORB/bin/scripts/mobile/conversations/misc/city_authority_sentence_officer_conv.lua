cityAuthoritySentenceOfficerConvoTemplate = ConvoTemplate:new {
	initialScreen = "sentence_info",
	templateType = "Lua",
	luaClassHandler = "cityAuthorityWardenConvoHandler",
	screens = {},
}

local sentenceInfo = ConvoScreen:new {
	id = "sentence_info",
	leftDialog = "",
	stopConversation = "false",
	options = {},
}
cityAuthoritySentenceOfficerConvoTemplate:addScreen(sentenceInfo)

local sentenceInfoEnd = ConvoScreen:new {
	id = "sentence_info_end",
	leftDialog = "",
	stopConversation = "true",
	options = {},
}
cityAuthoritySentenceOfficerConvoTemplate:addScreen(sentenceInfoEnd)

addConversationTemplate("cityAuthoritySentenceOfficerConvoTemplate", cityAuthoritySentenceOfficerConvoTemplate)
