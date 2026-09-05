-- ep3_ysith -- ep3_trandoshan_ysith
-- ruling 2026-09-04
-- Transcribed from the giver's java branches. Strings are shipped keys.
-- The journal row for the .qst comes from the integration branch later; do not call the journal engine.

ep3_ysith_convo = ConvoTemplate:new {
	initialScreen = "s_1466",
	templateType = "Lua",
	luaClassHandler = "ep3_ysith_conv_handler",
	screens = {}
}

ep3_ysith_convo_s_1454 = ConvoScreen:new {
	id = "s_1454",
	animation = "shrug_hands",
	leftDialog = "@conversation/ep3_trandoshan_ysith:s_1454",
	stopConversation = "false",
	options = {
		{"@conversation/ep3_trandoshan_ysith:s_1456", "s_1458"},
	}
}
ep3_ysith_convo:addScreen(ep3_ysith_convo_s_1454)

ep3_ysith_convo_s_1458 = ConvoScreen:new {
	id = "s_1458",
	animation = "celebrate",
	leftDialog = "@conversation/ep3_trandoshan_ysith:s_1458",
	stopConversation = "true",
	options = {
	}
}
ep3_ysith_convo:addScreen(ep3_ysith_convo_s_1458)

ep3_ysith_convo_s_1464 = ConvoScreen:new {
	id = "s_1464",
	animation = "wave_on_dismissing",
	leftDialog = "@conversation/ep3_trandoshan_ysith:s_1464",
	stopConversation = "true",
	options = {
	}
}
ep3_ysith_convo:addScreen(ep3_ysith_convo_s_1464)

ep3_ysith_convo_s_1470 = ConvoScreen:new {
	id = "s_1470",
	animation = "rub_chin_thoughtful",
	leftDialog = "@conversation/ep3_trandoshan_ysith:s_1470",
	stopConversation = "false",
	options = {
		{"@conversation/ep3_trandoshan_ysith:s_1472", "s_1474"},
	}
}
ep3_ysith_convo:addScreen(ep3_ysith_convo_s_1470)

ep3_ysith_convo_s_1474 = ConvoScreen:new {
	id = "s_1474",
	animation = "gesticulate_wildly",
	leftDialog = "@conversation/ep3_trandoshan_ysith:s_1474",
	stopConversation = "false",
	options = {
		{"@conversation/ep3_trandoshan_ysith:s_1476", "s_1478"},
	}
}
ep3_ysith_convo:addScreen(ep3_ysith_convo_s_1474)

ep3_ysith_convo_s_1478 = ConvoScreen:new {
	id = "s_1478",
	animation = "explain",
	leftDialog = "@conversation/ep3_trandoshan_ysith:s_1478",
	stopConversation = "false",
	options = {
		{"@conversation/ep3_trandoshan_ysith:s_1480", "s_1482"},
		{"@conversation/ep3_trandoshan_ysith:s_1484", "s_1486"},
	}
}
ep3_ysith_convo:addScreen(ep3_ysith_convo_s_1478)

ep3_ysith_convo_s_1482 = ConvoScreen:new {
	id = "s_1482",
	animation = "celebrate1",
	leftDialog = "@conversation/ep3_trandoshan_ysith:s_1482",
	stopConversation = "true",
	options = {
	}
}
ep3_ysith_convo:addScreen(ep3_ysith_convo_s_1482)

ep3_ysith_convo_s_1486 = ConvoScreen:new {
	id = "s_1486",
	animation = "wave_on_dismissing",
	leftDialog = "@conversation/ep3_trandoshan_ysith:s_1486",
	stopConversation = "true",
	options = {
	}
}
ep3_ysith_convo:addScreen(ep3_ysith_convo_s_1486)

ep3_ysith_convo_s_1448 = ConvoScreen:new {
	id = "s_1448",
	animation = "goodbye",
	leftDialog = "@conversation/ep3_trandoshan_ysith:s_1448",
	stopConversation = "true",
	options = {
	}
}
ep3_ysith_convo:addScreen(ep3_ysith_convo_s_1448)

ep3_ysith_convo_s_1450 = ConvoScreen:new {
	id = "s_1450",
	animation = "nervous",
	leftDialog = "@conversation/ep3_trandoshan_ysith:s_1450",
	stopConversation = "true",
	options = {
	}
}
ep3_ysith_convo:addScreen(ep3_ysith_convo_s_1450)

ep3_ysith_convo_s_1460 = ConvoScreen:new {
	id = "s_1460",
	animation = "nervous",
	leftDialog = "@conversation/ep3_trandoshan_ysith:s_1460",
	stopConversation = "true",
	options = {
	}
}
ep3_ysith_convo:addScreen(ep3_ysith_convo_s_1460)

ep3_ysith_convo_s_1466 = ConvoScreen:new {
	id = "s_1466",
	animation = "beckon",
	leftDialog = "@conversation/ep3_trandoshan_ysith:s_1466",
	stopConversation = "true",
	options = {
	}
}
ep3_ysith_convo:addScreen(ep3_ysith_convo_s_1466)

addConversationTemplate("ep3_ysith_convo", ep3_ysith_convo)
