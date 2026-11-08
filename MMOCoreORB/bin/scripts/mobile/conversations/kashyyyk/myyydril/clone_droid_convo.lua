local template = ConvoTemplate:new {
	initialScreen = "s_4",
	templateType = "Lua",
	luaClassHandler = "myyydril_clone_droid_conv_handler",
	screens = {},
}

template:addScreen(ConvoScreen:new {
	id = "s_4",
	leftDialog = "@conversation/clone_droid:s_4",
	stopConversation = "true",
})

addConversationTemplate("clone_droid_convo", template)
