-- ep3_olima_grunc -- ep3_trandoshan_olima_grunc
-- ruling 2026-09-04
-- Transcribed from the giver's java branches. Strings are shipped keys.
-- The journal row for the .qst comes from the integration branch later; do not call the journal engine.

ep3_olima_grunc_convo = ConvoTemplate:new {
	initialScreen = "s_1215",
	templateType = "Lua",
	luaClassHandler = "ep3_olima_grunc_conv_handler",
	screens = {}
}

ep3_olima_grunc_convo_s_1197 = ConvoScreen:new {
	id = "s_1197",
	animation = "goodbye",
	leftDialog = "@conversation/ep3_trandoshan_olima_grunc:s_1197",
	stopConversation = "true",
	options = {
	}
}
ep3_olima_grunc_convo:addScreen(ep3_olima_grunc_convo_s_1197)

ep3_olima_grunc_convo_s_1201 = ConvoScreen:new {
	id = "s_1201",
	animation = "goodbye",
	leftDialog = "@conversation/ep3_trandoshan_olima_grunc:s_1201",
	stopConversation = "true",
	options = {
	}
}
ep3_olima_grunc_convo:addScreen(ep3_olima_grunc_convo_s_1201)

ep3_olima_grunc_convo_s_1207 = ConvoScreen:new {
	id = "s_1207",
	animation = "manipulate_medium",
	leftDialog = "@conversation/ep3_trandoshan_olima_grunc:s_1207",
	stopConversation = "true",
	options = {
	}
}
ep3_olima_grunc_convo:addScreen(ep3_olima_grunc_convo_s_1207)

ep3_olima_grunc_convo_s_1213 = ConvoScreen:new {
	id = "s_1213",
	animation = "slump_head",
	leftDialog = "@conversation/ep3_trandoshan_olima_grunc:s_1213",
	stopConversation = "true",
	options = {
	}
}
ep3_olima_grunc_convo:addScreen(ep3_olima_grunc_convo_s_1213)

ep3_olima_grunc_convo_s_1219 = ConvoScreen:new {
	id = "s_1219",
	animation = "laugh_cackle",
	leftDialog = "@conversation/ep3_trandoshan_olima_grunc:s_1219",
	stopConversation = "false",
	options = {
		{"@conversation/ep3_trandoshan_olima_grunc:s_1221", "s_1223"},
	}
}
ep3_olima_grunc_convo:addScreen(ep3_olima_grunc_convo_s_1219)

ep3_olima_grunc_convo_s_1259 = ConvoScreen:new {
	id = "s_1259",
	animation = "goodbye",
	leftDialog = "@conversation/ep3_trandoshan_olima_grunc:s_1259",
	stopConversation = "true",
	options = {
	}
}
ep3_olima_grunc_convo:addScreen(ep3_olima_grunc_convo_s_1259)

ep3_olima_grunc_convo_s_1223 = ConvoScreen:new {
	id = "s_1223",
	animation = "gesticulate_wildly",
	leftDialog = "@conversation/ep3_trandoshan_olima_grunc:s_1223",
	stopConversation = "false",
	options = {
		{"@conversation/ep3_trandoshan_olima_grunc:s_1225", "s_1227"},
		{"@conversation/ep3_trandoshan_olima_grunc:s_1253", "s_1255"},
	}
}
ep3_olima_grunc_convo:addScreen(ep3_olima_grunc_convo_s_1223)

ep3_olima_grunc_convo_s_1227 = ConvoScreen:new {
	id = "s_1227",
	animation = "gesticulate_wildly",
	leftDialog = "@conversation/ep3_trandoshan_olima_grunc:s_1227",
	stopConversation = "false",
	options = {
		{"@conversation/ep3_trandoshan_olima_grunc:s_1229", "s_1231"},
	}
}
ep3_olima_grunc_convo:addScreen(ep3_olima_grunc_convo_s_1227)

ep3_olima_grunc_convo_s_1255 = ConvoScreen:new {
	id = "s_1255",
	animation = "goodbye",
	leftDialog = "@conversation/ep3_trandoshan_olima_grunc:s_1255",
	stopConversation = "true",
	options = {
	}
}
ep3_olima_grunc_convo:addScreen(ep3_olima_grunc_convo_s_1255)

ep3_olima_grunc_convo_s_1231 = ConvoScreen:new {
	id = "s_1231",
	animation = "smack_self",
	leftDialog = "@conversation/ep3_trandoshan_olima_grunc:s_1231",
	stopConversation = "false",
	options = {
		{"@conversation/ep3_trandoshan_olima_grunc:s_1233", "s_1235"},
	}
}
ep3_olima_grunc_convo:addScreen(ep3_olima_grunc_convo_s_1231)

ep3_olima_grunc_convo_s_1235 = ConvoScreen:new {
	id = "s_1235",
	animation = "wave_finger_warning",
	leftDialog = "@conversation/ep3_trandoshan_olima_grunc:s_1235",
	stopConversation = "false",
	options = {
		{"@conversation/ep3_trandoshan_olima_grunc:s_1237", "s_1239"},
		{"@conversation/ep3_trandoshan_olima_grunc:s_1249", "s_1251"},
	}
}
ep3_olima_grunc_convo:addScreen(ep3_olima_grunc_convo_s_1235)

ep3_olima_grunc_convo_s_1239 = ConvoScreen:new {
	id = "s_1239",
	animation = "nod_head_once",
	leftDialog = "@conversation/ep3_trandoshan_olima_grunc:s_1239",
	stopConversation = "false",
	options = {
		{"@conversation/ep3_trandoshan_olima_grunc:s_1241", "s_1243"},
	}
}
ep3_olima_grunc_convo:addScreen(ep3_olima_grunc_convo_s_1239)

ep3_olima_grunc_convo_s_1251 = ConvoScreen:new {
	id = "s_1251",
	animation = "goodbye",
	leftDialog = "@conversation/ep3_trandoshan_olima_grunc:s_1251",
	stopConversation = "true",
	options = {
	}
}
ep3_olima_grunc_convo:addScreen(ep3_olima_grunc_convo_s_1251)

ep3_olima_grunc_convo_s_1243 = ConvoScreen:new {
	id = "s_1243",
	animation = "laugh",
	leftDialog = "@conversation/ep3_trandoshan_olima_grunc:s_1243",
	stopConversation = "false",
	options = {
		{"@conversation/ep3_trandoshan_olima_grunc:s_1245", "s_1247"},
	}
}
ep3_olima_grunc_convo:addScreen(ep3_olima_grunc_convo_s_1243)

ep3_olima_grunc_convo_s_1247 = ConvoScreen:new {
	id = "s_1247",
	animation = "rub_chin_thoughtful",
	leftDialog = "@conversation/ep3_trandoshan_olima_grunc:s_1247",
	stopConversation = "true",
	options = {
	}
}
ep3_olima_grunc_convo:addScreen(ep3_olima_grunc_convo_s_1247)

ep3_olima_grunc_convo_s_1193 = ConvoScreen:new {
	id = "s_1193",
	animation = "bow5",
	leftDialog = "@conversation/ep3_trandoshan_olima_grunc:s_1193",
	stopConversation = "true",
	options = {
	}
}
ep3_olima_grunc_convo:addScreen(ep3_olima_grunc_convo_s_1193)

ep3_olima_grunc_convo_s_1203 = ConvoScreen:new {
	id = "s_1203",
	animation = "rub_belly",
	leftDialog = "@conversation/ep3_trandoshan_olima_grunc:s_1203",
	stopConversation = "true",
	options = {
	}
}
ep3_olima_grunc_convo:addScreen(ep3_olima_grunc_convo_s_1203)

ep3_olima_grunc_convo_s_1209 = ConvoScreen:new {
	id = "s_1209",
	animation = "greet",
	leftDialog = "@conversation/ep3_trandoshan_olima_grunc:s_1209",
	stopConversation = "true",
	options = {
	}
}
ep3_olima_grunc_convo:addScreen(ep3_olima_grunc_convo_s_1209)

ep3_olima_grunc_convo_s_1215 = ConvoScreen:new {
	id = "s_1215",
	animation = "greet",
	leftDialog = "@conversation/ep3_trandoshan_olima_grunc:s_1215",
	stopConversation = "true",
	options = {
	}
}
ep3_olima_grunc_convo:addScreen(ep3_olima_grunc_convo_s_1215)

addConversationTemplate("ep3_olima_grunc_convo", ep3_olima_grunc_convo)
