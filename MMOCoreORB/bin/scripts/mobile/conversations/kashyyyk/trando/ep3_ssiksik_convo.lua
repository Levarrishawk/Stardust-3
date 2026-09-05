-- ep3_ssiksik -- ep3_trandoshan_ssiksik
-- ruling 2026-09-04
-- Transcribed from the giver's java branches. Strings are shipped keys.
-- The journal row for the .qst comes from the integration branch later; do not call the journal engine.

ep3_ssiksik_convo = ConvoTemplate:new {
	initialScreen = "s_1317",
	templateType = "Lua",
	luaClassHandler = "ep3_ssiksik_conv_handler",
	screens = {}
}

ep3_ssiksik_convo_s_95 = ConvoScreen:new {
	id = "s_95",
	animation = "wave_finger_warning",
	leftDialog = "@conversation/ep3_trandoshan_ssiksik:s_95",
	stopConversation = "true",
	options = {
	}
}
ep3_ssiksik_convo:addScreen(ep3_ssiksik_convo_s_95)

ep3_ssiksik_convo_s_19 = ConvoScreen:new {
	id = "s_19",
	animation = "wave_on_dismissing",
	leftDialog = "@conversation/ep3_trandoshan_ssiksik:s_19",
	stopConversation = "true",
	options = {
	}
}
ep3_ssiksik_convo:addScreen(ep3_ssiksik_convo_s_19)

ep3_ssiksik_convo_s_1321 = ConvoScreen:new {
	id = "s_1321",
	animation = "pound_fist_palm",
	leftDialog = "@conversation/ep3_trandoshan_ssiksik:s_1321",
	stopConversation = "false",
	options = {
		{"@conversation/ep3_trandoshan_ssiksik:s_1323", "s_1325"},
		{"@conversation/ep3_trandoshan_ssiksik:s_1337", "s_1339"},
	}
}
ep3_ssiksik_convo:addScreen(ep3_ssiksik_convo_s_1321)

ep3_ssiksik_convo_s_1325 = ConvoScreen:new {
	id = "s_1325",
	animation = "explain",
	leftDialog = "@conversation/ep3_trandoshan_ssiksik:s_1325",
	stopConversation = "false",
	options = {
		{"@conversation/ep3_trandoshan_ssiksik:s_1327", "s_1329"},
	}
}
ep3_ssiksik_convo:addScreen(ep3_ssiksik_convo_s_1325)

ep3_ssiksik_convo_s_1339 = ConvoScreen:new {
	id = "s_1339",
	animation = "sigh_deeply",
	leftDialog = "@conversation/ep3_trandoshan_ssiksik:s_1339",
	stopConversation = "true",
	options = {
	}
}
ep3_ssiksik_convo:addScreen(ep3_ssiksik_convo_s_1339)

ep3_ssiksik_convo_s_1329 = ConvoScreen:new {
	id = "s_1329",
	animation = "point_away",
	leftDialog = "@conversation/ep3_trandoshan_ssiksik:s_1329",
	stopConversation = "false",
	options = {
		{"@conversation/ep3_trandoshan_ssiksik:s_1331", "s_1333"},
		{"@conversation/ep3_trandoshan_ssiksik:s_1335", "s_1339"},
	}
}
ep3_ssiksik_convo:addScreen(ep3_ssiksik_convo_s_1329)

ep3_ssiksik_convo_s_1333 = ConvoScreen:new {
	id = "s_1333",
	animation = "pound_fist_palm",
	leftDialog = "@conversation/ep3_trandoshan_ssiksik:s_1333",
	stopConversation = "true",
	options = {
	}
}
ep3_ssiksik_convo:addScreen(ep3_ssiksik_convo_s_1333)

ep3_ssiksik_convo_s_1313 = ConvoScreen:new {
	id = "s_1313",
	animation = "salute2",
	leftDialog = "@conversation/ep3_trandoshan_ssiksik:s_1313",
	stopConversation = "true",
	options = {
	}
}
ep3_ssiksik_convo:addScreen(ep3_ssiksik_convo_s_1313)

ep3_ssiksik_convo_s_1315 = ConvoScreen:new {
	id = "s_1315",
	animation = "explain",
	leftDialog = "@conversation/ep3_trandoshan_ssiksik:s_1315",
	stopConversation = "true",
	options = {
	}
}
ep3_ssiksik_convo:addScreen(ep3_ssiksik_convo_s_1315)

ep3_ssiksik_convo_s_1317 = ConvoScreen:new {
	id = "s_1317",
	animation = "explain",
	leftDialog = "@conversation/ep3_trandoshan_ssiksik:s_1317",
	stopConversation = "true",
	options = {
	}
}
ep3_ssiksik_convo:addScreen(ep3_ssiksik_convo_s_1317)

addConversationTemplate("ep3_ssiksik_convo", ep3_ssiksik_convo)
