-- ep3_unluto_bartender -- ep3_trandoshan_unluto_bartender
-- ruling 2026-09-04
-- Transcribed from the giver's java branches. Strings are shipped keys.
-- The journal row for the .qst comes from the integration branch later; do not call the journal engine.

ep3_unluto_bartender_convo = ConvoTemplate:new {
	initialScreen = "s_1389",
	templateType = "Lua",
	luaClassHandler = "ep3_unluto_bartender_conv_handler",
	screens = {}
}

ep3_unluto_bartender_convo_s_1393 = ConvoScreen:new {
	id = "s_1393",
	animation = "explain",
	leftDialog = "@conversation/ep3_trandoshan_unluto_bartender:s_1393",
	stopConversation = "false",
	options = {
		{"@conversation/ep3_trandoshan_unluto_bartender:s_1395", "s_1397"},
	}
}
ep3_unluto_bartender_convo:addScreen(ep3_unluto_bartender_convo_s_1393)

ep3_unluto_bartender_convo_s_1441 = ConvoScreen:new {
	id = "s_1441",
	animation = "yawn",
	leftDialog = "@conversation/ep3_trandoshan_unluto_bartender:s_1441",
	stopConversation = "true",
	options = {
	}
}
ep3_unluto_bartender_convo:addScreen(ep3_unluto_bartender_convo_s_1441)

ep3_unluto_bartender_convo_s_1397 = ConvoScreen:new {
	id = "s_1397",
	animation = "sigh_deeply",
	leftDialog = "@conversation/ep3_trandoshan_unluto_bartender:s_1397",
	stopConversation = "false",
	options = {
		{"@conversation/ep3_trandoshan_unluto_bartender:s_1399", "s_1401"},
	}
}
ep3_unluto_bartender_convo:addScreen(ep3_unluto_bartender_convo_s_1397)

ep3_unluto_bartender_convo_s_1401 = ConvoScreen:new {
	id = "s_1401",
	animation = "rub_chin_thoughtful",
	leftDialog = "@conversation/ep3_trandoshan_unluto_bartender:s_1401",
	stopConversation = "false",
	options = {
		{"@conversation/ep3_trandoshan_unluto_bartender:s_1403", "s_1405"},
	}
}
ep3_unluto_bartender_convo:addScreen(ep3_unluto_bartender_convo_s_1401)

ep3_unluto_bartender_convo_s_1405 = ConvoScreen:new {
	id = "s_1405",
	animation = "explain",
	leftDialog = "@conversation/ep3_trandoshan_unluto_bartender:s_1405",
	stopConversation = "false",
	options = {
		{"@conversation/ep3_trandoshan_unluto_bartender:s_1407", "s_1409"},
	}
}
ep3_unluto_bartender_convo:addScreen(ep3_unluto_bartender_convo_s_1405)

ep3_unluto_bartender_convo_s_1409 = ConvoScreen:new {
	id = "s_1409",
	animation = "explain",
	leftDialog = "@conversation/ep3_trandoshan_unluto_bartender:s_1409",
	stopConversation = "false",
	options = {
		{"@conversation/ep3_trandoshan_unluto_bartender:s_1411", "s_1413"},
		{"@conversation/ep3_trandoshan_unluto_bartender:s_1427", "s_1429"},
	}
}
ep3_unluto_bartender_convo:addScreen(ep3_unluto_bartender_convo_s_1409)

ep3_unluto_bartender_convo_s_1413 = ConvoScreen:new {
	id = "s_1413",
	animation = "point_accusingly",
	leftDialog = "@conversation/ep3_trandoshan_unluto_bartender:s_1413",
	stopConversation = "false",
	options = {
		{"@conversation/ep3_trandoshan_unluto_bartender:s_1415", "s_1417"},
	}
}
ep3_unluto_bartender_convo:addScreen(ep3_unluto_bartender_convo_s_1413)

ep3_unluto_bartender_convo_s_1429 = ConvoScreen:new {
	id = "s_1429",
	animation = "shrug_hands",
	leftDialog = "@conversation/ep3_trandoshan_unluto_bartender:s_1429",
	stopConversation = "false",
	options = {
		{"@conversation/ep3_trandoshan_unluto_bartender:s_1431", "s_1433"},
	}
}
ep3_unluto_bartender_convo:addScreen(ep3_unluto_bartender_convo_s_1429)

ep3_unluto_bartender_convo_s_1417 = ConvoScreen:new {
	id = "s_1417",
	animation = "slow_down",
	leftDialog = "@conversation/ep3_trandoshan_unluto_bartender:s_1417",
	stopConversation = "false",
	options = {
		{"@conversation/ep3_trandoshan_unluto_bartender:s_1419", "s_1421"},
	}
}
ep3_unluto_bartender_convo:addScreen(ep3_unluto_bartender_convo_s_1417)

ep3_unluto_bartender_convo_s_1421 = ConvoScreen:new {
	id = "s_1421",
	animation = "shake_head_no",
	leftDialog = "@conversation/ep3_trandoshan_unluto_bartender:s_1421",
	stopConversation = "false",
	options = {
		{"@conversation/ep3_trandoshan_unluto_bartender:s_1423", "s_1425"},
	}
}
ep3_unluto_bartender_convo:addScreen(ep3_unluto_bartender_convo_s_1421)

ep3_unluto_bartender_convo_s_1425 = ConvoScreen:new {
	id = "s_1425",
	animation = "nod_head_once",
	leftDialog = "@conversation/ep3_trandoshan_unluto_bartender:s_1425",
	stopConversation = "true",
	options = {
	}
}
ep3_unluto_bartender_convo:addScreen(ep3_unluto_bartender_convo_s_1425)

ep3_unluto_bartender_convo_s_1433 = ConvoScreen:new {
	id = "s_1433",
	animation = "rub_chin_thoughtful",
	leftDialog = "@conversation/ep3_trandoshan_unluto_bartender:s_1433",
	stopConversation = "false",
	options = {
		{"@conversation/ep3_trandoshan_unluto_bartender:s_1435", "s_1437"},
	}
}
ep3_unluto_bartender_convo:addScreen(ep3_unluto_bartender_convo_s_1433)

ep3_unluto_bartender_convo_s_1437 = ConvoScreen:new {
	id = "s_1437",
	animation = "nod_head_multiple",
	leftDialog = "@conversation/ep3_trandoshan_unluto_bartender:s_1437",
	stopConversation = "true",
	options = {
	}
}
ep3_unluto_bartender_convo:addScreen(ep3_unluto_bartender_convo_s_1437)

ep3_unluto_bartender_convo_s_1389 = ConvoScreen:new {
	id = "s_1389",
	animation = "manipulate_high",
	leftDialog = "@conversation/ep3_trandoshan_unluto_bartender:s_1389",
	stopConversation = "true",
	options = {
	}
}
ep3_unluto_bartender_convo:addScreen(ep3_unluto_bartender_convo_s_1389)

addConversationTemplate("ep3_unluto_bartender_convo", ep3_unluto_bartender_convo)
