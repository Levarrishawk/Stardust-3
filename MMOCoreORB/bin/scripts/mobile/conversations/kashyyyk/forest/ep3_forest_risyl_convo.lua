-- Risyl -- ep3_forest_cryl_quest_1
-- ruling 2026-09-04: "ensure kashyyyk is fully done"
-- Transcribed from the giver's java branches. Strings are shipped keys.
-- The journal row for quest/ep3_forest_*.qst comes from the integration branch later; this arc does not call the Journal API.

ep3_forest_risyl_convo = ConvoTemplate:new {
	initialScreen = "s_823",
	templateType = "Lua",
	luaClassHandler = "ep3_forest_risyl_conv_handler",
	screens = {}
}

ep3_forest_risyl_convo_s_803 = ConvoScreen:new {
	id = "s_803",
	leftDialog = "@conversation/ep3_forest_risyl:s_803", -- [Risyl just nods and continues his work.]
	stopConversation = "true",
	options = {}
}
ep3_forest_risyl_convo:addScreen(ep3_forest_risyl_convo_s_803)

ep3_forest_risyl_convo_s_805 = ConvoScreen:new {
	id = "s_805",
	leftDialog = "@conversation/ep3_forest_risyl:s_805", -- [Risyl nods.]
	stopConversation = "false",
	options = {
		{"@conversation/ep3_forest_risyl:s_807", "s_809"},
	}
}
ep3_forest_risyl_convo:addScreen(ep3_forest_risyl_convo_s_805)

ep3_forest_risyl_convo_s_823 = ConvoScreen:new {
	id = "s_823",
	leftDialog = "@conversation/ep3_forest_risyl:s_823", -- [Risyl only smirks at you. He seems to be busy.]
	stopConversation = "true",
	options = {}
}
ep3_forest_risyl_convo:addScreen(ep3_forest_risyl_convo_s_823)

ep3_forest_risyl_convo_s_809 = ConvoScreen:new {
	id = "s_809",
	leftDialog = "@conversation/ep3_forest_risyl:s_809", -- Yeah. What's the password?
	stopConversation = "false",
	options = {
		{"@conversation/ep3_forest_risyl:s_811", "s_813"},
	}
}
ep3_forest_risyl_convo:addScreen(ep3_forest_risyl_convo_s_809)

ep3_forest_risyl_convo_s_813 = ConvoScreen:new {
	id = "s_813",
	leftDialog = "@conversation/ep3_forest_risyl:s_813", -- You're right. He didn't. Good answer. [Risyl smirks.] Here. And be careful with it.
	stopConversation = "false",
	options = {
		{"@conversation/ep3_forest_risyl:s_815", "s_817"},
	}
}
ep3_forest_risyl_convo:addScreen(ep3_forest_risyl_convo_s_813)

ep3_forest_risyl_convo_s_817 = ConvoScreen:new {
	id = "s_817",
	leftDialog = "@conversation/ep3_forest_risyl:s_817", -- Good. Go before anyone sees you.
	stopConversation = "false",
	options = {
		{"@conversation/ep3_forest_risyl:s_819", "s_821"},
	}
}
ep3_forest_risyl_convo:addScreen(ep3_forest_risyl_convo_s_817)

ep3_forest_risyl_convo_s_821 = ConvoScreen:new {
	id = "s_821",
	leftDialog = "@conversation/ep3_forest_risyl:s_821", -- Just go. [Risyl shakes his head.]
	stopConversation = "true",
	options = {}
}
ep3_forest_risyl_convo:addScreen(ep3_forest_risyl_convo_s_821)

addConversationTemplate("ep3_forest_risyl_convo", ep3_forest_risyl_convo)
