-- ep3_negal_teklon -- ep3_trandoshan_negal_teklon
-- ruling 2026-09-04
-- Transcribed from the giver's java branches. Strings are shipped keys.
-- The journal row for the .qst comes from the integration branch later; do not call the journal engine.

ep3_negal_teklon_convo = ConvoTemplate:new {
	initialScreen = "s_1189",
	templateType = "Lua",
	luaClassHandler = "ep3_negal_teklon_conv_handler",
	screens = {}
}

ep3_negal_teklon_convo_s_1173 = ConvoScreen:new {
	id = "s_1173",
	animation = "gesticulate_wildly",
	leftDialog = "@conversation/ep3_trandoshan_negal_teklon:s_1173",
	stopConversation = "false",
	options = {
		{"@conversation/ep3_trandoshan_negal_teklon:s_1175", "s_1177"},
	}
}
ep3_negal_teklon_convo:addScreen(ep3_negal_teklon_convo_s_1173)

ep3_negal_teklon_convo_s_1177 = ConvoScreen:new {
	id = "s_1177",
	animation = "point_accusingly",
	leftDialog = "@conversation/ep3_trandoshan_negal_teklon:s_1177",
	stopConversation = "false",
	options = {
		{"@conversation/ep3_trandoshan_negal_teklon:s_1179", "s_1181"},
	}
}
ep3_negal_teklon_convo:addScreen(ep3_negal_teklon_convo_s_1177)

ep3_negal_teklon_convo_s_1181 = ConvoScreen:new {
	id = "s_1181",
	animation = "shrug_hands",
	leftDialog = "@conversation/ep3_trandoshan_negal_teklon:s_1181",
	stopConversation = "false",
	options = {
		{"@conversation/ep3_trandoshan_negal_teklon:s_1183", "s_1185"},
	}
}
ep3_negal_teklon_convo:addScreen(ep3_negal_teklon_convo_s_1181)

ep3_negal_teklon_convo_s_1185 = ConvoScreen:new {
	id = "s_1185",
	animation = "wave_on_dismissing",
	leftDialog = "@conversation/ep3_trandoshan_negal_teklon:s_1185",
	stopConversation = "true",
	options = {
	}
}
ep3_negal_teklon_convo:addScreen(ep3_negal_teklon_convo_s_1185)

ep3_negal_teklon_convo_s_1167 = ConvoScreen:new {
	id = "s_1167",
	animation = "wave_on_dismissing",
	leftDialog = "@conversation/ep3_trandoshan_negal_teklon:s_1167",
	stopConversation = "true",
	options = {
	}
}
ep3_negal_teklon_convo:addScreen(ep3_negal_teklon_convo_s_1167)

ep3_negal_teklon_convo_s_1169 = ConvoScreen:new {
	id = "s_1169",
	animation = "whisper",
	leftDialog = "@conversation/ep3_trandoshan_negal_teklon:s_1169",
	stopConversation = "true",
	options = {
	}
}
ep3_negal_teklon_convo:addScreen(ep3_negal_teklon_convo_s_1169)

ep3_negal_teklon_convo_s_1187 = ConvoScreen:new {
	id = "s_1187",
	animation = "shake_head_disgust",
	leftDialog = "@conversation/ep3_trandoshan_negal_teklon:s_1187",
	stopConversation = "true",
	options = {
	}
}
ep3_negal_teklon_convo:addScreen(ep3_negal_teklon_convo_s_1187)

ep3_negal_teklon_convo_s_1189 = ConvoScreen:new {
	id = "s_1189",
	animation = "wave_on_dismissing",
	leftDialog = "@conversation/ep3_trandoshan_negal_teklon:s_1189",
	stopConversation = "true",
	options = {
	}
}
ep3_negal_teklon_convo:addScreen(ep3_negal_teklon_convo_s_1189)

addConversationTemplate("ep3_negal_teklon_convo", ep3_negal_teklon_convo)
