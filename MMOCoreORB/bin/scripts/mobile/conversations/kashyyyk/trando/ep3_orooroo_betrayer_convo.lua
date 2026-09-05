-- ep3_orooroo_betrayer -- ep3_trandoshan_orooroo_zssik_04
-- ruling 2026-09-04
-- Transcribed from the giver's java branches. Strings are shipped keys.
-- The journal row for the .qst comes from the integration branch later; do not call the journal engine.

ep3_orooroo_betrayer_convo = ConvoTemplate:new {
	initialScreen = "s_202",
	templateType = "Lua",
	luaClassHandler = "ep3_orooroo_betrayer_conv_handler",
	screens = {}
}

ep3_orooroo_betrayer_convo_s_159 = ConvoScreen:new {
	id = "s_159",
	animation = "whisper",
	leftDialog = "@conversation/ep3_trandoshan_orooroo_zssik_04:s_159",
	stopConversation = "false",
	options = {
		{"@conversation/ep3_trandoshan_orooroo_zssik_04:s_161", "s_164"},
	}
}
ep3_orooroo_betrayer_convo:addScreen(ep3_orooroo_betrayer_convo_s_159)

ep3_orooroo_betrayer_convo_s_164 = ConvoScreen:new {
	id = "s_164",
	animation = "whisper",
	leftDialog = "@conversation/ep3_trandoshan_orooroo_zssik_04:s_164",
	stopConversation = "true",
	options = {
	}
}
ep3_orooroo_betrayer_convo:addScreen(ep3_orooroo_betrayer_convo_s_164)

ep3_orooroo_betrayer_convo_s_172 = ConvoScreen:new {
	id = "s_172",
	animation = "whisper",
	leftDialog = "@conversation/ep3_trandoshan_orooroo_zssik_04:s_172",
	stopConversation = "false",
	options = {
		{"@conversation/ep3_trandoshan_orooroo_zssik_04:s_174", "s_176"},
	}
}
ep3_orooroo_betrayer_convo:addScreen(ep3_orooroo_betrayer_convo_s_172)

ep3_orooroo_betrayer_convo_s_196 = ConvoScreen:new {
	id = "s_196",
	animation = "whisper",
	leftDialog = "@conversation/ep3_trandoshan_orooroo_zssik_04:s_196",
	stopConversation = "false",
	options = {
		{"@conversation/ep3_trandoshan_orooroo_zssik_04:s_198", "s_172"},
	}
}
ep3_orooroo_betrayer_convo:addScreen(ep3_orooroo_betrayer_convo_s_196)

ep3_orooroo_betrayer_convo_s_176 = ConvoScreen:new {
	id = "s_176",
	animation = "whisper",
	leftDialog = "@conversation/ep3_trandoshan_orooroo_zssik_04:s_176",
	stopConversation = "false",
	options = {
		{"@conversation/ep3_trandoshan_orooroo_zssik_04:s_178", "s_180"},
	}
}
ep3_orooroo_betrayer_convo:addScreen(ep3_orooroo_betrayer_convo_s_176)

ep3_orooroo_betrayer_convo_s_180 = ConvoScreen:new {
	id = "s_180",
	animation = "whisper",
	leftDialog = "@conversation/ep3_trandoshan_orooroo_zssik_04:s_180",
	stopConversation = "false",
	options = {
		{"@conversation/ep3_trandoshan_orooroo_zssik_04:s_182", "s_184"},
	}
}
ep3_orooroo_betrayer_convo:addScreen(ep3_orooroo_betrayer_convo_s_180)

ep3_orooroo_betrayer_convo_s_184 = ConvoScreen:new {
	id = "s_184",
	animation = "whisper",
	leftDialog = "@conversation/ep3_trandoshan_orooroo_zssik_04:s_184",
	stopConversation = "false",
	options = {
		{"@conversation/ep3_trandoshan_orooroo_zssik_04:s_186", "s_188"},
		{"@conversation/ep3_trandoshan_orooroo_zssik_04:s_190", "s_192"},
	}
}
ep3_orooroo_betrayer_convo:addScreen(ep3_orooroo_betrayer_convo_s_184)

ep3_orooroo_betrayer_convo_s_188 = ConvoScreen:new {
	id = "s_188",
	animation = "whisper",
	leftDialog = "@conversation/ep3_trandoshan_orooroo_zssik_04:s_188",
	stopConversation = "true",
	options = {
	}
}
ep3_orooroo_betrayer_convo:addScreen(ep3_orooroo_betrayer_convo_s_188)

ep3_orooroo_betrayer_convo_s_192 = ConvoScreen:new {
	id = "s_192",
	animation = "whisper",
	leftDialog = "@conversation/ep3_trandoshan_orooroo_zssik_04:s_192",
	stopConversation = "true",
	options = {
	}
}
ep3_orooroo_betrayer_convo:addScreen(ep3_orooroo_betrayer_convo_s_192)

ep3_orooroo_betrayer_convo_s_97 = ConvoScreen:new {
	id = "s_97",
	leftDialog = "@conversation/ep3_trandoshan_orooroo_zssik_04:s_97",
	stopConversation = "true",
	options = {
	}
}
ep3_orooroo_betrayer_convo:addScreen(ep3_orooroo_betrayer_convo_s_97)

ep3_orooroo_betrayer_convo_s_153 = ConvoScreen:new {
	id = "s_153",
	animation = "wave_on_dismissing",
	leftDialog = "@conversation/ep3_trandoshan_orooroo_zssik_04:s_153",
	stopConversation = "true",
	options = {
	}
}
ep3_orooroo_betrayer_convo:addScreen(ep3_orooroo_betrayer_convo_s_153)

ep3_orooroo_betrayer_convo_s_155 = ConvoScreen:new {
	id = "s_155",
	animation = "whisper",
	leftDialog = "@conversation/ep3_trandoshan_orooroo_zssik_04:s_155",
	stopConversation = "true",
	options = {
	}
}
ep3_orooroo_betrayer_convo:addScreen(ep3_orooroo_betrayer_convo_s_155)

ep3_orooroo_betrayer_convo_s_166 = ConvoScreen:new {
	id = "s_166",
	animation = "smell_air",
	leftDialog = "@conversation/ep3_trandoshan_orooroo_zssik_04:s_166",
	stopConversation = "true",
	options = {
	}
}
ep3_orooroo_betrayer_convo:addScreen(ep3_orooroo_betrayer_convo_s_166)

ep3_orooroo_betrayer_convo_s_168 = ConvoScreen:new {
	id = "s_168",
	animation = "whisper",
	leftDialog = "@conversation/ep3_trandoshan_orooroo_zssik_04:s_168",
	stopConversation = "true",
	options = {
	}
}
ep3_orooroo_betrayer_convo:addScreen(ep3_orooroo_betrayer_convo_s_168)

ep3_orooroo_betrayer_convo_s_200 = ConvoScreen:new {
	id = "s_200",
	leftDialog = "@conversation/ep3_trandoshan_orooroo_zssik_04:s_200",
	stopConversation = "true",
	options = {
	}
}
ep3_orooroo_betrayer_convo:addScreen(ep3_orooroo_betrayer_convo_s_200)

ep3_orooroo_betrayer_convo_s_202 = ConvoScreen:new {
	id = "s_202",
	animation = "wave_on_dismissing",
	leftDialog = "@conversation/ep3_trandoshan_orooroo_zssik_04:s_202",
	stopConversation = "true",
	options = {
	}
}
ep3_orooroo_betrayer_convo:addScreen(ep3_orooroo_betrayer_convo_s_202)

addConversationTemplate("ep3_orooroo_betrayer_convo", ep3_orooroo_betrayer_convo)
