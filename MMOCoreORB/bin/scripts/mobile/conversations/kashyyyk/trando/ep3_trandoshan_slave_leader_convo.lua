-- ep3_trandoshan_slave_leader -- ep3_trandoshan_slave_leader
-- ruling 2026-09-04
-- Transcribed from the giver's java branches. Strings are shipped keys.
-- The journal row for the .qst comes from the integration branch later; do not call the journal engine.

ep3_trandoshan_slave_leader_convo = ConvoTemplate:new {
	initialScreen = "s_93",
	templateType = "Lua",
	luaClassHandler = "ep3_trandoshan_slave_leader_conv_handler",
	screens = {}
}

ep3_trandoshan_slave_leader_convo_s_91 = ConvoScreen:new {
	id = "s_91",
	leftDialog = "@conversation/ep3_trandoshan_slave_leader:s_91",
	stopConversation = "true",
	options = {
	}
}
ep3_trandoshan_slave_leader_convo:addScreen(ep3_trandoshan_slave_leader_convo_s_91)

ep3_trandoshan_slave_leader_convo_s_81 = ConvoScreen:new {
	id = "s_81",
	leftDialog = "@conversation/ep3_trandoshan_slave_leader:s_81",
	stopConversation = "true",
	options = {
	}
}
ep3_trandoshan_slave_leader_convo:addScreen(ep3_trandoshan_slave_leader_convo_s_81)

ep3_trandoshan_slave_leader_convo_s_83 = ConvoScreen:new {
	id = "s_83",
	leftDialog = "@conversation/ep3_trandoshan_slave_leader:s_83",
	stopConversation = "true",
	options = {
	}
}
ep3_trandoshan_slave_leader_convo:addScreen(ep3_trandoshan_slave_leader_convo_s_83)

ep3_trandoshan_slave_leader_convo_s_85 = ConvoScreen:new {
	id = "s_85",
	leftDialog = "@conversation/ep3_trandoshan_slave_leader:s_85",
	stopConversation = "true",
	options = {
	}
}
ep3_trandoshan_slave_leader_convo:addScreen(ep3_trandoshan_slave_leader_convo_s_85)

ep3_trandoshan_slave_leader_convo_s_87 = ConvoScreen:new {
	id = "s_87",
	leftDialog = "@conversation/ep3_trandoshan_slave_leader:s_87",
	stopConversation = "true",
	options = {
	}
}
ep3_trandoshan_slave_leader_convo:addScreen(ep3_trandoshan_slave_leader_convo_s_87)

ep3_trandoshan_slave_leader_convo_s_93 = ConvoScreen:new {
	id = "s_93",
	leftDialog = "@conversation/ep3_trandoshan_slave_leader:s_93",
	stopConversation = "true",
	options = {
	}
}
ep3_trandoshan_slave_leader_convo:addScreen(ep3_trandoshan_slave_leader_convo_s_93)

addConversationTemplate("ep3_trandoshan_slave_leader_convo", ep3_trandoshan_slave_leader_convo)
