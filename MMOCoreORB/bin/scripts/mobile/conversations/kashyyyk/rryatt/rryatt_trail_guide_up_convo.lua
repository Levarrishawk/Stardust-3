rryatt_trail_guide_up_convo = ConvoTemplate:new {
	initialScreen = "s_86",
	templateType = "Lua",
	luaClassHandler = "rryatt_trail_guide_conv_handler",
	screens = {}
}

rryatt_trail_guide_up_convo:addScreen(ConvoScreen:new {
	id = "s_86",
	leftDialog = "@conversation/rryatt_trail_guide_up:s_86",
	stopConversation = "false",
	options = {
		{"@conversation/rryatt_trail_guide_up:s_88", "s_90"},
		{"@conversation/rryatt_trail_guide_up:s_92", "s_94"},
	}
})

rryatt_trail_guide_up_convo:addScreen(ConvoScreen:new {
	id = "s_90",
	leftDialog = "@conversation/rryatt_trail_guide_up:s_90",
	stopConversation = "true",
	options = {}
})

rryatt_trail_guide_up_convo:addScreen(ConvoScreen:new {
	id = "s_94",
	leftDialog = "@conversation/rryatt_trail_guide_up:s_94",
	stopConversation = "true",
	options = {}
})

addConversationTemplate("rryatt_trail_guide_up_convo", rryatt_trail_guide_up_convo)
