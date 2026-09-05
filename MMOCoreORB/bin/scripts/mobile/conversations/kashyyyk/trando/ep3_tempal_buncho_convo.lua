-- ep3_tempal_buncho -- ep3_trandoshan_tempal_buncho
-- ruling 2026-09-04
-- Transcribed from the giver's java branches. Strings are shipped keys.
-- The journal row for the .qst comes from the integration branch later; do not call the journal engine.

ep3_tempal_buncho_convo = ConvoTemplate:new {
	initialScreen = "s_1357",
	templateType = "Lua",
	luaClassHandler = "ep3_tempal_buncho_conv_handler",
	screens = {}
}

ep3_tempal_buncho_convo_s_1349 = ConvoScreen:new {
	id = "s_1349",
	animation = "laugh",
	leftDialog = "@conversation/ep3_trandoshan_tempal_buncho:s_1349",
	stopConversation = "true",
	options = {
	}
}
ep3_tempal_buncho_convo:addScreen(ep3_tempal_buncho_convo_s_1349)

ep3_tempal_buncho_convo_s_1355 = ConvoScreen:new {
	id = "s_1355",
	animation = "shake_head_no",
	leftDialog = "@conversation/ep3_trandoshan_tempal_buncho:s_1355",
	stopConversation = "true",
	options = {
	}
}
ep3_tempal_buncho_convo:addScreen(ep3_tempal_buncho_convo_s_1355)

ep3_tempal_buncho_convo_s_1361 = ConvoScreen:new {
	id = "s_1361",
	animation = "point_to_self",
	leftDialog = "@conversation/ep3_trandoshan_tempal_buncho:s_1361",
	stopConversation = "false",
	options = {
		{"@conversation/ep3_trandoshan_tempal_buncho:s_1363", "s_1365"},
	}
}
ep3_tempal_buncho_convo:addScreen(ep3_tempal_buncho_convo_s_1361)

ep3_tempal_buncho_convo_s_1365 = ConvoScreen:new {
	id = "s_1365",
	animation = "laugh",
	leftDialog = "@conversation/ep3_trandoshan_tempal_buncho:s_1365",
	stopConversation = "false",
	options = {
		{"@conversation/ep3_trandoshan_tempal_buncho:s_1367", "s_1369"},
	}
}
ep3_tempal_buncho_convo:addScreen(ep3_tempal_buncho_convo_s_1365)

ep3_tempal_buncho_convo_s_1369 = ConvoScreen:new {
	id = "s_1369",
	animation = "explain",
	leftDialog = "@conversation/ep3_trandoshan_tempal_buncho:s_1369",
	stopConversation = "false",
	options = {
		{"@conversation/ep3_trandoshan_tempal_buncho:s_1371", "s_1373"},
		{"@conversation/ep3_trandoshan_tempal_buncho:s_1383", "s_1385"},
	}
}
ep3_tempal_buncho_convo:addScreen(ep3_tempal_buncho_convo_s_1369)

ep3_tempal_buncho_convo_s_1373 = ConvoScreen:new {
	id = "s_1373",
	animation = "laugh",
	leftDialog = "@conversation/ep3_trandoshan_tempal_buncho:s_1373",
	stopConversation = "false",
	options = {
		{"@conversation/ep3_trandoshan_tempal_buncho:s_1375", "s_1377"},
		{"@conversation/ep3_trandoshan_tempal_buncho:s_1379", "s_1381"},
	}
}
ep3_tempal_buncho_convo:addScreen(ep3_tempal_buncho_convo_s_1373)

ep3_tempal_buncho_convo_s_1385 = ConvoScreen:new {
	id = "s_1385",
	animation = "goodbye",
	leftDialog = "@conversation/ep3_trandoshan_tempal_buncho:s_1385",
	stopConversation = "true",
	options = {
	}
}
ep3_tempal_buncho_convo:addScreen(ep3_tempal_buncho_convo_s_1385)

ep3_tempal_buncho_convo_s_1377 = ConvoScreen:new {
	id = "s_1377",
	animation = "goodbye",
	leftDialog = "@conversation/ep3_trandoshan_tempal_buncho:s_1377",
	stopConversation = "true",
	options = {
	}
}
ep3_tempal_buncho_convo:addScreen(ep3_tempal_buncho_convo_s_1377)

ep3_tempal_buncho_convo_s_1381 = ConvoScreen:new {
	id = "s_1381",
	animation = "goodbye",
	leftDialog = "@conversation/ep3_trandoshan_tempal_buncho:s_1381",
	stopConversation = "true",
	options = {
	}
}
ep3_tempal_buncho_convo:addScreen(ep3_tempal_buncho_convo_s_1381)

ep3_tempal_buncho_convo_s_1343 = ConvoScreen:new {
	id = "s_1343",
	animation = "greet",
	leftDialog = "@conversation/ep3_trandoshan_tempal_buncho:s_1343",
	stopConversation = "true",
	options = {
	}
}
ep3_tempal_buncho_convo:addScreen(ep3_tempal_buncho_convo_s_1343)

ep3_tempal_buncho_convo_s_1345 = ConvoScreen:new {
	id = "s_1345",
	animation = "greet",
	leftDialog = "@conversation/ep3_trandoshan_tempal_buncho:s_1345",
	stopConversation = "true",
	options = {
	}
}
ep3_tempal_buncho_convo:addScreen(ep3_tempal_buncho_convo_s_1345)

ep3_tempal_buncho_convo_s_1351 = ConvoScreen:new {
	id = "s_1351",
	animation = "shake_head_no",
	leftDialog = "@conversation/ep3_trandoshan_tempal_buncho:s_1351",
	stopConversation = "true",
	options = {
	}
}
ep3_tempal_buncho_convo:addScreen(ep3_tempal_buncho_convo_s_1351)

ep3_tempal_buncho_convo_s_1357 = ConvoScreen:new {
	id = "s_1357",
	animation = "rub_chin_thoughtful",
	leftDialog = "@conversation/ep3_trandoshan_tempal_buncho:s_1357",
	stopConversation = "true",
	options = {
	}
}
ep3_tempal_buncho_convo:addScreen(ep3_tempal_buncho_convo_s_1357)

addConversationTemplate("ep3_tempal_buncho_convo", ep3_tempal_buncho_convo)
