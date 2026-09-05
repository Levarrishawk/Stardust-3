-- ep3_etyyy_jerrol_chupapa -- Etyyy hunting-grounds ground conversation
-- ruling 2026-09-04: "ensure kashyyyk is fully done"
-- Transcribed from the giver's java branches. Strings are shipped keys.
-- The journal row for quest/ep3_hunt_*.qst comes from the integration branch later; do not call the journal engine.

ep3_etyyy_jerrol_chupapa_convo = ConvoTemplate:new {
	initialScreen = "s_285",
	templateType = "Lua",
	luaClassHandler = "ep3_etyyy_jerrol_chupapa_conv_handler",
	screens = {}
}

ep3_etyyy_jerrol_chupapa_convo_s_289 = ConvoScreen:new {
	id = "s_289",
	leftDialog = "@conversation/ep3_etyyy_jerrol_chupapa:s_289", -- Hmm... that name. I know it from somewhere. I think Johnson Smith might know this person. Go speak w...
	stopConversation = "true",
	options = {}
}
ep3_etyyy_jerrol_chupapa_convo:addScreen(ep3_etyyy_jerrol_chupapa_convo_s_289)

ep3_etyyy_jerrol_chupapa_convo_s_293 = ConvoScreen:new {
	id = "s_293",
	leftDialog = "@conversation/ep3_etyyy_jerrol_chupapa:s_293", -- Any time.
	stopConversation = "true",
	options = {}
}
ep3_etyyy_jerrol_chupapa_convo:addScreen(ep3_etyyy_jerrol_chupapa_convo_s_293)

ep3_etyyy_jerrol_chupapa_convo_s_285 = ConvoScreen:new {
	id = "s_285",
	leftDialog = "@conversation/ep3_etyyy_jerrol_chupapa:s_285", -- Welcome to the Arcona salt addict compounds. I myself used to be a salt addict, so I know what it ta...
	stopConversation = "false",
	options = {
		{"@conversation/ep3_etyyy_jerrol_chupapa:s_287", "s_289"},
		{"@conversation/ep3_etyyy_jerrol_chupapa:s_291", "s_293"},
	}
}
ep3_etyyy_jerrol_chupapa_convo:addScreen(ep3_etyyy_jerrol_chupapa_convo_s_285)

addConversationTemplate("ep3_etyyy_jerrol_chupapa_convo", ep3_etyyy_jerrol_chupapa_convo)
