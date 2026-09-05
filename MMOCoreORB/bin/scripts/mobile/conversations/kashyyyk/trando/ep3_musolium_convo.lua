-- ep3_musolium -- ep3_trandoshan_mosolium_zssik_03
-- ruling 2026-09-04
-- Transcribed from the giver's java branches. Strings are shipped keys.
-- The journal row for the .qst comes from the integration branch later; do not call the journal engine.

ep3_musolium_convo = ConvoTemplate:new {
	initialScreen = "s_1113",
	templateType = "Lua",
	luaClassHandler = "ep3_musolium_conv_handler",
	screens = {}
}

ep3_musolium_convo_s_1045 = ConvoScreen:new {
	id = "s_1045",
	animation = "point_away",
	leftDialog = "@conversation/ep3_trandoshan_mosolium_zssik_03:s_1045",
	stopConversation = "true",
	options = {
	}
}
ep3_musolium_convo:addScreen(ep3_musolium_convo_s_1045)

ep3_musolium_convo_s_1049 = ConvoScreen:new {
	id = "s_1049",
	animation = "shrug_hands",
	leftDialog = "@conversation/ep3_trandoshan_mosolium_zssik_03:s_1049",
	stopConversation = "true",
	options = {
	}
}
ep3_musolium_convo:addScreen(ep3_musolium_convo_s_1049)

ep3_musolium_convo_s_1057 = ConvoScreen:new {
	id = "s_1057",
	animation = "shake_head_disgust",
	leftDialog = "@conversation/ep3_trandoshan_mosolium_zssik_03:s_1057",
	stopConversation = "false",
	options = {
		{"@conversation/ep3_trandoshan_mosolium_zssik_03:s_1059", "s_1061"},
	}
}
ep3_musolium_convo:addScreen(ep3_musolium_convo_s_1057)

ep3_musolium_convo_s_1061 = ConvoScreen:new {
	id = "s_1061",
	animation = "explain",
	leftDialog = "@conversation/ep3_trandoshan_mosolium_zssik_03:s_1061",
	stopConversation = "false",
	options = {
		{"@conversation/ep3_trandoshan_mosolium_zssik_03:s_1063", "s_1065"},
	}
}
ep3_musolium_convo:addScreen(ep3_musolium_convo_s_1061)

ep3_musolium_convo_s_1065 = ConvoScreen:new {
	id = "s_1065",
	animation = "sigh_deeply",
	leftDialog = "@conversation/ep3_trandoshan_mosolium_zssik_03:s_1065",
	stopConversation = "false",
	options = {
		{"@conversation/ep3_trandoshan_mosolium_zssik_03:s_1067", "s_1069"},
		{"@conversation/ep3_trandoshan_mosolium_zssik_03:s_1071", "s_1073"},
	}
}
ep3_musolium_convo:addScreen(ep3_musolium_convo_s_1065)

ep3_musolium_convo_s_1069 = ConvoScreen:new {
	id = "s_1069",
	animation = "slit_throat",
	leftDialog = "@conversation/ep3_trandoshan_mosolium_zssik_03:s_1069",
	stopConversation = "true",
	options = {
	}
}
ep3_musolium_convo:addScreen(ep3_musolium_convo_s_1069)

ep3_musolium_convo_s_1073 = ConvoScreen:new {
	id = "s_1073",
	animation = "wave_on_dismissing",
	leftDialog = "@conversation/ep3_trandoshan_mosolium_zssik_03:s_1073",
	stopConversation = "true",
	options = {
	}
}
ep3_musolium_convo:addScreen(ep3_musolium_convo_s_1073)

ep3_musolium_convo_s_1079 = ConvoScreen:new {
	id = "s_1079",
	animation = "wave_on_dismissing",
	leftDialog = "@conversation/ep3_trandoshan_mosolium_zssik_03:s_1079",
	stopConversation = "true",
	options = {
	}
}
ep3_musolium_convo:addScreen(ep3_musolium_convo_s_1079)

ep3_musolium_convo_s_1083 = ConvoScreen:new {
	id = "s_1083",
	animation = "wave_on_dismissing",
	leftDialog = "@conversation/ep3_trandoshan_mosolium_zssik_03:s_1083",
	stopConversation = "true",
	options = {
	}
}
ep3_musolium_convo:addScreen(ep3_musolium_convo_s_1083)

ep3_musolium_convo_s_1091 = ConvoScreen:new {
	id = "s_1091",
	animation = "nod_head_once",
	leftDialog = "@conversation/ep3_trandoshan_mosolium_zssik_03:s_1091",
	stopConversation = "false",
	options = {
		{"@conversation/ep3_trandoshan_mosolium_zssik_03:s_1093", "s_1095"},
	}
}
ep3_musolium_convo:addScreen(ep3_musolium_convo_s_1091)

ep3_musolium_convo_s_1095 = ConvoScreen:new {
	id = "s_1095",
	animation = "point_accusingly",
	leftDialog = "@conversation/ep3_trandoshan_mosolium_zssik_03:s_1095",
	stopConversation = "false",
	options = {
		{"@conversation/ep3_trandoshan_mosolium_zssik_03:s_1097", "s_1099"},
		{"@conversation/ep3_trandoshan_mosolium_zssik_03:s_1109", "s_1111"},
	}
}
ep3_musolium_convo:addScreen(ep3_musolium_convo_s_1095)

ep3_musolium_convo_s_1099 = ConvoScreen:new {
	id = "s_1099",
	animation = "explain",
	leftDialog = "@conversation/ep3_trandoshan_mosolium_zssik_03:s_1099",
	stopConversation = "false",
	options = {
		{"@conversation/ep3_trandoshan_mosolium_zssik_03:s_1101", "s_1103"},
	}
}
ep3_musolium_convo:addScreen(ep3_musolium_convo_s_1099)

ep3_musolium_convo_s_1111 = ConvoScreen:new {
	id = "s_1111",
	animation = "point_accusingly",
	leftDialog = "@conversation/ep3_trandoshan_mosolium_zssik_03:s_1111",
	stopConversation = "true",
	options = {
	}
}
ep3_musolium_convo:addScreen(ep3_musolium_convo_s_1111)

ep3_musolium_convo_s_1103 = ConvoScreen:new {
	id = "s_1103",
	animation = "explain",
	leftDialog = "@conversation/ep3_trandoshan_mosolium_zssik_03:s_1103",
	stopConversation = "false",
	options = {
		{"@conversation/ep3_trandoshan_mosolium_zssik_03:s_1105", "s_1107"},
	}
}
ep3_musolium_convo:addScreen(ep3_musolium_convo_s_1103)

ep3_musolium_convo_s_1107 = ConvoScreen:new {
	id = "s_1107",
	animation = "dismiss",
	leftDialog = "@conversation/ep3_trandoshan_mosolium_zssik_03:s_1107",
	stopConversation = "true",
	options = {
	}
}
ep3_musolium_convo:addScreen(ep3_musolium_convo_s_1107)

ep3_musolium_convo_s_1039 = ConvoScreen:new {
	id = "s_1039",
	animation = "point_away",
	leftDialog = "@conversation/ep3_trandoshan_mosolium_zssik_03:s_1039",
	stopConversation = "true",
	options = {
	}
}
ep3_musolium_convo:addScreen(ep3_musolium_convo_s_1039)

ep3_musolium_convo_s_1041 = ConvoScreen:new {
	id = "s_1041",
	animation = "nod_head_once",
	leftDialog = "@conversation/ep3_trandoshan_mosolium_zssik_03:s_1041",
	stopConversation = "true",
	options = {
	}
}
ep3_musolium_convo:addScreen(ep3_musolium_convo_s_1041)

ep3_musolium_convo_s_1051 = ConvoScreen:new {
	id = "s_1051",
	animation = "point_accusingly",
	leftDialog = "@conversation/ep3_trandoshan_mosolium_zssik_03:s_1051",
	stopConversation = "true",
	options = {
	}
}
ep3_musolium_convo:addScreen(ep3_musolium_convo_s_1051)

ep3_musolium_convo_s_1053 = ConvoScreen:new {
	id = "s_1053",
	animation = "rub_chin_thoughtful",
	leftDialog = "@conversation/ep3_trandoshan_mosolium_zssik_03:s_1053",
	stopConversation = "true",
	options = {
	}
}
ep3_musolium_convo:addScreen(ep3_musolium_convo_s_1053)

ep3_musolium_convo_s_1075 = ConvoScreen:new {
	id = "s_1075",
	animation = "shake_head_disgust",
	leftDialog = "@conversation/ep3_trandoshan_mosolium_zssik_03:s_1075",
	stopConversation = "true",
	options = {
	}
}
ep3_musolium_convo:addScreen(ep3_musolium_convo_s_1075)

ep3_musolium_convo_s_1085 = ConvoScreen:new {
	id = "s_1085",
	animation = "dismiss",
	leftDialog = "@conversation/ep3_trandoshan_mosolium_zssik_03:s_1085",
	stopConversation = "true",
	options = {
	}
}
ep3_musolium_convo:addScreen(ep3_musolium_convo_s_1085)

ep3_musolium_convo_s_1087 = ConvoScreen:new {
	id = "s_1087",
	animation = "point_accusingly",
	leftDialog = "@conversation/ep3_trandoshan_mosolium_zssik_03:s_1087",
	stopConversation = "true",
	options = {
	}
}
ep3_musolium_convo:addScreen(ep3_musolium_convo_s_1087)

ep3_musolium_convo_s_148 = ConvoScreen:new {
	id = "s_148",
	leftDialog = "@conversation/ep3_trandoshan_mosolium_zssik_03:s_148",
	stopConversation = "true",
	options = {
	}
}
ep3_musolium_convo:addScreen(ep3_musolium_convo_s_148)

ep3_musolium_convo_s_1113 = ConvoScreen:new {
	id = "s_1113",
	animation = "wave_on_dismissing",
	leftDialog = "@conversation/ep3_trandoshan_mosolium_zssik_03:s_1113",
	stopConversation = "true",
	options = {
	}
}
ep3_musolium_convo:addScreen(ep3_musolium_convo_s_1113)

addConversationTemplate("ep3_musolium_convo", ep3_musolium_convo)
