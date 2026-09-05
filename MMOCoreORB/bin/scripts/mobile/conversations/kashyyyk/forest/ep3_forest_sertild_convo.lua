-- Sertild -- ep3_forest_dahlia_epic_3, ep3_forest_dahlia_epic_4
-- ruling 2026-09-04: "ensure kashyyyk is fully done"
-- Transcribed from the giver's java branches. Strings are shipped keys.
-- The journal row for quest/ep3_forest_*.qst comes from the integration branch later; this arc does not call the Journal API.

ep3_forest_sertild_convo = ConvoTemplate:new {
	initialScreen = "s_843",
	templateType = "Lua",
	luaClassHandler = "ep3_forest_sertild_conv_handler",
	screens = {}
}

ep3_forest_sertild_convo_s_827 = ConvoScreen:new {
	id = "s_827",
	leftDialog = "@conversation/ep3_forest_sertild:s_827", -- [Sertild says nothing, concentrating on the matters at hand.]
	stopConversation = "true",
	options = {}
}
ep3_forest_sertild_convo:addScreen(ep3_forest_sertild_convo_s_827)

ep3_forest_sertild_convo_s_829 = ConvoScreen:new {
	id = "s_829",
	leftDialog = "@conversation/ep3_forest_sertild:s_829", -- [Sertild nods.] Mercenary..
	stopConversation = "false",
	options = {
		{"@conversation/ep3_forest_sertild:s_831", "s_833"},
	}
}
ep3_forest_sertild_convo:addScreen(ep3_forest_sertild_convo_s_829)

ep3_forest_sertild_convo_s_843 = ConvoScreen:new {
	id = "s_843",
	leftDialog = "@conversation/ep3_forest_sertild:s_843", -- ...
	stopConversation = "true",
	options = {}
}
ep3_forest_sertild_convo:addScreen(ep3_forest_sertild_convo_s_843)

ep3_forest_sertild_convo_s_833 = ConvoScreen:new {
	id = "s_833",
	leftDialog = "@conversation/ep3_forest_sertild:s_833", -- [Sertild nods again.] Good, then let's begin this. Are you ready?
	stopConversation = "false",
	options = {
		{"@conversation/ep3_forest_sertild:s_835", "s_841"},
		{"@conversation/ep3_forest_sertild:s_839", "s_841"},
	}
}
ep3_forest_sertild_convo:addScreen(ep3_forest_sertild_convo_s_833)

ep3_forest_sertild_convo_s_837 = ConvoScreen:new {
	id = "s_837",
	leftDialog = "@conversation/ep3_forest_sertild:s_837", -- [Sertild nods.]
	stopConversation = "true",
	options = {}
}
ep3_forest_sertild_convo:addScreen(ep3_forest_sertild_convo_s_837)

ep3_forest_sertild_convo_s_841 = ConvoScreen:new {
	id = "s_841",
	leftDialog = "@conversation/ep3_forest_sertild:s_841", -- It is done...
	stopConversation = "true",
	options = {}
}
ep3_forest_sertild_convo:addScreen(ep3_forest_sertild_convo_s_841)

addConversationTemplate("ep3_forest_sertild_convo", ep3_forest_sertild_convo)
