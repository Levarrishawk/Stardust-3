-- ep3_jessokk_scarhand -- ep3_trandoshan_jessokk
-- ruling 2026-09-04
-- Transcribed from the giver's java branches. Strings are shipped keys.
-- The journal row for the .qst comes from the integration branch later; do not call the journal engine.

ep3_jessokk_scarhand_convo = ConvoTemplate:new {
	initialScreen = "s_151",
	templateType = "Lua",
	luaClassHandler = "ep3_jessokk_scarhand_conv_handler",
	screens = {}
}

ep3_jessokk_scarhand_convo_s_155 = ConvoScreen:new {
	id = "s_155",
	leftDialog = "@conversation/ep3_trandoshan_jessokk:s_155",
	stopConversation = "true",
	options = {
	}
}
ep3_jessokk_scarhand_convo:addScreen(ep3_jessokk_scarhand_convo_s_155)

ep3_jessokk_scarhand_convo_s_156 = ConvoScreen:new {
	id = "s_156",
	leftDialog = "@conversation/ep3_trandoshan_jessokk:s_156",
	stopConversation = "true",
	options = {
	}
}
ep3_jessokk_scarhand_convo:addScreen(ep3_jessokk_scarhand_convo_s_156)

ep3_jessokk_scarhand_convo_s_9 = ConvoScreen:new {
	id = "s_9",
	leftDialog = "@conversation/ep3_trandoshan_jessokk:s_9",
	stopConversation = "true",
	options = {
	}
}
ep3_jessokk_scarhand_convo:addScreen(ep3_jessokk_scarhand_convo_s_9)

ep3_jessokk_scarhand_convo_s_146 = ConvoScreen:new {
	id = "s_146",
	leftDialog = "@conversation/ep3_trandoshan_jessokk:s_146",
	stopConversation = "true",
	options = {
	}
}
ep3_jessokk_scarhand_convo:addScreen(ep3_jessokk_scarhand_convo_s_146)

ep3_jessokk_scarhand_convo_s_150 = ConvoScreen:new {
	id = "s_150",
	leftDialog = "@conversation/ep3_trandoshan_jessokk:s_150",
	stopConversation = "true",
	options = {
	}
}
ep3_jessokk_scarhand_convo:addScreen(ep3_jessokk_scarhand_convo_s_150)

ep3_jessokk_scarhand_convo_s_151 = ConvoScreen:new {
	id = "s_151",
	leftDialog = "@conversation/ep3_trandoshan_jessokk:s_151",
	stopConversation = "true",
	options = {
	}
}
ep3_jessokk_scarhand_convo:addScreen(ep3_jessokk_scarhand_convo_s_151)

addConversationTemplate("ep3_jessokk_scarhand_convo", ep3_jessokk_scarhand_convo)
