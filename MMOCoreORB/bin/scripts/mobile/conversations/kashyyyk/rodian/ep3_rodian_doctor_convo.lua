-- ep3_rodian_doctor
-- ruling 2026-09-04
-- Transcribed from the giver's java branches. Strings are shipped keys.
-- NO JOURNAL: this branch has no managers/quest/journal.lua. The client ships
-- the .qst; the journal row comes from the integration branch later.

ep3_rodian_doctor_convo = ConvoTemplate:new {
	initialScreen = "s_4",
	templateType = "Lua",
	luaClassHandler = "ep3_rodian_doctor_conv_handler",
	screens = {}
}

ep3_rodian_doctor_convo_s_4 = ConvoScreen:new {
	id = "s_4",
	leftDialog = "@conversation/ep3_rodian_doctor:s_4", -- What can I do for you today?
	stopConversation = "false",
	options = {
		{"@conversation/ep3_rodian_doctor:s_7", "s_17"},
	}
}
ep3_rodian_doctor_convo:addScreen(ep3_rodian_doctor_convo_s_4)

ep3_rodian_doctor_convo_s_17 = ConvoScreen:new {
	id = "s_17",
	leftDialog = "@conversation/ep3_rodian_doctor:s_17", -- Well, just let me know if there is anything I can do.
	stopConversation = "true",
	options = {}
}
ep3_rodian_doctor_convo:addScreen(ep3_rodian_doctor_convo_s_17)

addConversationTemplate("ep3_rodian_doctor_convo", ep3_rodian_doctor_convo)
