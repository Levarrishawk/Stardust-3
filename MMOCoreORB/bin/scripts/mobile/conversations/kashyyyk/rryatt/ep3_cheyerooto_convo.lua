-- Cheyerooto -- ep3_cheyerooto_5_rrwii_root
-- ruling 2026-09-04: "ensure kashyyyk is fully done"
-- Transcribed from ep3_cheyerooto.java. Conversation stf was not in strings-rryatt.json;
-- keys are the shipped conversation/ep3_cheyerooto table. NO new stf.
-- OPEN: wrhisch_liver branches are transcribed and idle (that quest is not this arc).
-- Do not call the journal engine.

ep3_cheyerooto_convo = ConvoTemplate:new {
	initialScreen = "s_540",
	templateType = "Lua",
	luaClassHandler = "ep3_cheyerooto_conv_handler",
	screens = {}
}

ep3_cheyerooto_convo_s_207 = ConvoScreen:new {
	id = "s_207",
	leftDialog = "@conversation/ep3_cheyerooto:s_207",
	stopConversation = "true",
	options = {}
}
ep3_cheyerooto_convo:addScreen(ep3_cheyerooto_convo_s_207)

ep3_cheyerooto_convo_s_322 = ConvoScreen:new {
	id = "s_322",
	leftDialog = "@conversation/ep3_cheyerooto:s_322",
	stopConversation = "true",
	options = {}
}
ep3_cheyerooto_convo:addScreen(ep3_cheyerooto_convo_s_322)

ep3_cheyerooto_convo_s_512 = ConvoScreen:new {
	id = "s_512",
	leftDialog = "@conversation/ep3_cheyerooto:s_512",
	stopConversation = "false",
	options = {
		{"@conversation/ep3_cheyerooto:s_514", "s_516"},
		{"@conversation/ep3_cheyerooto:s_518", "s_520"},
	}
}
ep3_cheyerooto_convo:addScreen(ep3_cheyerooto_convo_s_512)

ep3_cheyerooto_convo_s_516 = ConvoScreen:new {
	id = "s_516",
	leftDialog = "@conversation/ep3_cheyerooto:s_516",
	stopConversation = "false",
	options = {
		{"@conversation/ep3_cheyerooto:s_327", "s_329"},
	}
}
ep3_cheyerooto_convo:addScreen(ep3_cheyerooto_convo_s_516)

ep3_cheyerooto_convo_s_520 = ConvoScreen:new {
	id = "s_520",
	leftDialog = "@conversation/ep3_cheyerooto:s_520",
	stopConversation = "true",
	options = {}
}
ep3_cheyerooto_convo:addScreen(ep3_cheyerooto_convo_s_520)

ep3_cheyerooto_convo_s_329 = ConvoScreen:new {
	id = "s_329",
	leftDialog = "@conversation/ep3_cheyerooto:s_329",
	stopConversation = "true",
	options = {}
}
ep3_cheyerooto_convo:addScreen(ep3_cheyerooto_convo_s_329)

ep3_cheyerooto_convo_s_522 = ConvoScreen:new {
	id = "s_522",
	leftDialog = "@conversation/ep3_cheyerooto:s_522",
	stopConversation = "false",
	options = {
		{"@conversation/ep3_cheyerooto:s_524", "s_526"},
	}
}
ep3_cheyerooto_convo:addScreen(ep3_cheyerooto_convo_s_522)

ep3_cheyerooto_convo_s_526 = ConvoScreen:new {
	id = "s_526",
	leftDialog = "@conversation/ep3_cheyerooto:s_526",
	stopConversation = "false",
	options = {
		{"@conversation/ep3_cheyerooto:s_528", "s_530"},
	}
}
ep3_cheyerooto_convo:addScreen(ep3_cheyerooto_convo_s_526)

ep3_cheyerooto_convo_s_530 = ConvoScreen:new {
	id = "s_530",
	leftDialog = "@conversation/ep3_cheyerooto:s_530",
	stopConversation = "true",
	options = {}
}
ep3_cheyerooto_convo:addScreen(ep3_cheyerooto_convo_s_530)

ep3_cheyerooto_convo_s_532 = ConvoScreen:new {
	id = "s_532",
	leftDialog = "@conversation/ep3_cheyerooto:s_532",
	stopConversation = "false",
	options = {
		{"@conversation/ep3_cheyerooto:s_534", "s_536"},
	}
}
ep3_cheyerooto_convo:addScreen(ep3_cheyerooto_convo_s_532)

ep3_cheyerooto_convo_s_536 = ConvoScreen:new {
	id = "s_536",
	leftDialog = "@conversation/ep3_cheyerooto:s_536",
	stopConversation = "false",
	options = {
		{"@conversation/ep3_cheyerooto:s_538", "s_522"},
	}
}
ep3_cheyerooto_convo:addScreen(ep3_cheyerooto_convo_s_536)

ep3_cheyerooto_convo_s_540 = ConvoScreen:new {
	id = "s_540",
	leftDialog = "@conversation/ep3_cheyerooto:s_540",
	stopConversation = "true",
	options = {}
}
ep3_cheyerooto_convo:addScreen(ep3_cheyerooto_convo_s_540)

addConversationTemplate("ep3_cheyerooto_convo", ep3_cheyerooto_convo)
