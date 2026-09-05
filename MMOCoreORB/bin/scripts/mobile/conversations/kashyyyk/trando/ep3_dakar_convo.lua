-- ep3_dakar -- ep3_trandoshan_dakar_zssik_02
-- ruling 2026-09-04
-- Transcribed from the giver's java branches. Strings are shipped keys.
-- The journal row for the .qst comes from the integration branch later; do not call the journal engine.

ep3_dakar_convo = ConvoTemplate:new {
	initialScreen = "s_834",
	templateType = "Lua",
	luaClassHandler = "ep3_dakar_conv_handler",
	screens = {}
}

ep3_dakar_convo_s_804 = ConvoScreen:new {
	id = "s_804",
	animation = "rub_chin_thoughtful",
	leftDialog = "@conversation/ep3_trandoshan_dakar_zssik_02:s_804",
	stopConversation = "true",
	options = {
	}
}
ep3_dakar_convo:addScreen(ep3_dakar_convo_s_804)

ep3_dakar_convo_s_810 = ConvoScreen:new {
	id = "s_810",
	animation = "wave_on_dismissing",
	leftDialog = "@conversation/ep3_trandoshan_dakar_zssik_02:s_810",
	stopConversation = "true",
	options = {
	}
}
ep3_dakar_convo:addScreen(ep3_dakar_convo_s_810)

ep3_dakar_convo_s_816 = ConvoScreen:new {
	id = "s_816",
	animation = "explain",
	leftDialog = "@conversation/ep3_trandoshan_dakar_zssik_02:s_816",
	stopConversation = "false",
	options = {
		{"@conversation/ep3_trandoshan_dakar_zssik_02:s_818", "s_820"},
	}
}
ep3_dakar_convo:addScreen(ep3_dakar_convo_s_816)

ep3_dakar_convo_s_820 = ConvoScreen:new {
	id = "s_820",
	animation = "explain",
	leftDialog = "@conversation/ep3_trandoshan_dakar_zssik_02:s_820",
	stopConversation = "false",
	options = {
		{"@conversation/ep3_trandoshan_dakar_zssik_02:s_822", "s_824"},
	}
}
ep3_dakar_convo:addScreen(ep3_dakar_convo_s_820)

ep3_dakar_convo_s_824 = ConvoScreen:new {
	id = "s_824",
	animation = "explain",
	leftDialog = "@conversation/ep3_trandoshan_dakar_zssik_02:s_824",
	stopConversation = "false",
	options = {
		{"@conversation/ep3_trandoshan_dakar_zssik_02:s_826", "s_828"},
		{"@conversation/ep3_trandoshan_dakar_zssik_02:s_830", "s_832"},
	}
}
ep3_dakar_convo:addScreen(ep3_dakar_convo_s_824)

ep3_dakar_convo_s_828 = ConvoScreen:new {
	id = "s_828",
	animation = "pound_fist_palm",
	leftDialog = "@conversation/ep3_trandoshan_dakar_zssik_02:s_828",
	stopConversation = "true",
	options = {
	}
}
ep3_dakar_convo:addScreen(ep3_dakar_convo_s_828)

ep3_dakar_convo_s_832 = ConvoScreen:new {
	id = "s_832",
	animation = "wave_on_dismissing",
	leftDialog = "@conversation/ep3_trandoshan_dakar_zssik_02:s_832",
	stopConversation = "true",
	options = {
	}
}
ep3_dakar_convo:addScreen(ep3_dakar_convo_s_832)

ep3_dakar_convo_s_798 = ConvoScreen:new {
	id = "s_798",
	animation = "wave_on_dismissing",
	leftDialog = "@conversation/ep3_trandoshan_dakar_zssik_02:s_798",
	stopConversation = "true",
	options = {
	}
}
ep3_dakar_convo:addScreen(ep3_dakar_convo_s_798)

ep3_dakar_convo_s_800 = ConvoScreen:new {
	id = "s_800",
	animation = "search",
	leftDialog = "@conversation/ep3_trandoshan_dakar_zssik_02:s_800",
	stopConversation = "true",
	options = {
	}
}
ep3_dakar_convo:addScreen(ep3_dakar_convo_s_800)

ep3_dakar_convo_s_806 = ConvoScreen:new {
	id = "s_806",
	animation = "search",
	leftDialog = "@conversation/ep3_trandoshan_dakar_zssik_02:s_806",
	stopConversation = "true",
	options = {
	}
}
ep3_dakar_convo:addScreen(ep3_dakar_convo_s_806)

ep3_dakar_convo_s_812 = ConvoScreen:new {
	id = "s_812",
	animation = "rub_chin_thoughtful",
	leftDialog = "@conversation/ep3_trandoshan_dakar_zssik_02:s_812",
	stopConversation = "true",
	options = {
	}
}
ep3_dakar_convo:addScreen(ep3_dakar_convo_s_812)

ep3_dakar_convo_s_95 = ConvoScreen:new {
	id = "s_95",
	leftDialog = "@conversation/ep3_trandoshan_dakar_zssik_02:s_95",
	stopConversation = "true",
	options = {
	}
}
ep3_dakar_convo:addScreen(ep3_dakar_convo_s_95)

ep3_dakar_convo_s_834 = ConvoScreen:new {
	id = "s_834",
	animation = "dismiss",
	leftDialog = "@conversation/ep3_trandoshan_dakar_zssik_02:s_834",
	stopConversation = "true",
	options = {
	}
}
ep3_dakar_convo:addScreen(ep3_dakar_convo_s_834)

addConversationTemplate("ep3_dakar_convo", ep3_dakar_convo)
