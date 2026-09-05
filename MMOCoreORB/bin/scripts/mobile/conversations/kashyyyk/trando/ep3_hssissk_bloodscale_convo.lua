-- ep3_hssissk_bloodscale -- ep3_trandoshan_hssissk_zssik_06
-- ruling 2026-09-04
-- Transcribed from the giver's java branches. Strings are shipped keys.
-- The journal row for the .qst comes from the integration branch later; do not call the journal engine.

ep3_hssissk_bloodscale_convo = ConvoTemplate:new {
	initialScreen = "s_980",
	templateType = "Lua",
	luaClassHandler = "ep3_hssissk_bloodscale_conv_handler",
	screens = {}
}

ep3_hssissk_bloodscale_convo_s_940 = ConvoScreen:new {
	id = "s_940",
	animation = "wave_on_dismissing",
	leftDialog = "@conversation/ep3_trandoshan_hssissk_zssik_06:s_940",
	stopConversation = "true",
	options = {
	}
}
ep3_hssissk_bloodscale_convo:addScreen(ep3_hssissk_bloodscale_convo_s_940)

ep3_hssissk_bloodscale_convo_s_948 = ConvoScreen:new {
	id = "s_948",
	animation = "explain",
	leftDialog = "@conversation/ep3_trandoshan_hssissk_zssik_06:s_948",
	stopConversation = "false",
	options = {
		{"@conversation/ep3_trandoshan_hssissk_zssik_06:s_950", "s_952"},
	}
}
ep3_hssissk_bloodscale_convo:addScreen(ep3_hssissk_bloodscale_convo_s_948)

ep3_hssissk_bloodscale_convo_s_976 = ConvoScreen:new {
	id = "s_976",
	animation = "rub_chin_thoughtful",
	leftDialog = "@conversation/ep3_trandoshan_hssissk_zssik_06:s_976",
	stopConversation = "false",
	options = {
		{"@conversation/ep3_trandoshan_hssissk_zssik_06:s_978", "s_948"},
	}
}
ep3_hssissk_bloodscale_convo:addScreen(ep3_hssissk_bloodscale_convo_s_976)

ep3_hssissk_bloodscale_convo_s_952 = ConvoScreen:new {
	id = "s_952",
	animation = "pound_fist_palm",
	leftDialog = "@conversation/ep3_trandoshan_hssissk_zssik_06:s_952",
	stopConversation = "false",
	options = {
		{"@conversation/ep3_trandoshan_hssissk_zssik_06:s_954", "s_956"},
	}
}
ep3_hssissk_bloodscale_convo:addScreen(ep3_hssissk_bloodscale_convo_s_952)

ep3_hssissk_bloodscale_convo_s_956 = ConvoScreen:new {
	id = "s_956",
	animation = "shake_head_disgust",
	leftDialog = "@conversation/ep3_trandoshan_hssissk_zssik_06:s_956",
	stopConversation = "false",
	options = {
		{"@conversation/ep3_trandoshan_hssissk_zssik_06:s_958", "s_960"},
	}
}
ep3_hssissk_bloodscale_convo:addScreen(ep3_hssissk_bloodscale_convo_s_956)

ep3_hssissk_bloodscale_convo_s_960 = ConvoScreen:new {
	id = "s_960",
	animation = "explain",
	leftDialog = "@conversation/ep3_trandoshan_hssissk_zssik_06:s_960",
	stopConversation = "false",
	options = {
		{"@conversation/ep3_trandoshan_hssissk_zssik_06:s_962", "s_964"},
	}
}
ep3_hssissk_bloodscale_convo:addScreen(ep3_hssissk_bloodscale_convo_s_960)

ep3_hssissk_bloodscale_convo_s_964 = ConvoScreen:new {
	id = "s_964",
	animation = "explain",
	leftDialog = "@conversation/ep3_trandoshan_hssissk_zssik_06:s_964",
	stopConversation = "false",
	options = {
		{"@conversation/ep3_trandoshan_hssissk_zssik_06:s_966", "s_968"},
		{"@conversation/ep3_trandoshan_hssissk_zssik_06:s_970", "s_972"},
	}
}
ep3_hssissk_bloodscale_convo:addScreen(ep3_hssissk_bloodscale_convo_s_964)

ep3_hssissk_bloodscale_convo_s_968 = ConvoScreen:new {
	id = "s_968",
	animation = "dismiss",
	leftDialog = "@conversation/ep3_trandoshan_hssissk_zssik_06:s_968",
	stopConversation = "true",
	options = {
	}
}
ep3_hssissk_bloodscale_convo:addScreen(ep3_hssissk_bloodscale_convo_s_968)

ep3_hssissk_bloodscale_convo_s_972 = ConvoScreen:new {
	id = "s_972",
	animation = "dismiss",
	leftDialog = "@conversation/ep3_trandoshan_hssissk_zssik_06:s_972",
	stopConversation = "true",
	options = {
	}
}
ep3_hssissk_bloodscale_convo:addScreen(ep3_hssissk_bloodscale_convo_s_972)

ep3_hssissk_bloodscale_convo_s_934 = ConvoScreen:new {
	id = "s_934",
	animation = "dismiss",
	leftDialog = "@conversation/ep3_trandoshan_hssissk_zssik_06:s_934",
	stopConversation = "true",
	options = {
	}
}
ep3_hssissk_bloodscale_convo:addScreen(ep3_hssissk_bloodscale_convo_s_934)

ep3_hssissk_bloodscale_convo_s_936 = ConvoScreen:new {
	id = "s_936",
	animation = "applause_polite",
	leftDialog = "@conversation/ep3_trandoshan_hssissk_zssik_06:s_936",
	stopConversation = "true",
	options = {
	}
}
ep3_hssissk_bloodscale_convo:addScreen(ep3_hssissk_bloodscale_convo_s_936)

ep3_hssissk_bloodscale_convo_s_942 = ConvoScreen:new {
	id = "s_942",
	animation = "point_accusingly",
	leftDialog = "@conversation/ep3_trandoshan_hssissk_zssik_06:s_942",
	stopConversation = "true",
	options = {
	}
}
ep3_hssissk_bloodscale_convo:addScreen(ep3_hssissk_bloodscale_convo_s_942)

ep3_hssissk_bloodscale_convo_s_944 = ConvoScreen:new {
	id = "s_944",
	animation = "greet",
	leftDialog = "@conversation/ep3_trandoshan_hssissk_zssik_06:s_944",
	stopConversation = "true",
	options = {
	}
}
ep3_hssissk_bloodscale_convo:addScreen(ep3_hssissk_bloodscale_convo_s_944)

ep3_hssissk_bloodscale_convo_s_212 = ConvoScreen:new {
	id = "s_212",
	leftDialog = "@conversation/ep3_trandoshan_hssissk_zssik_06:s_212",
	stopConversation = "true",
	options = {
	}
}
ep3_hssissk_bloodscale_convo:addScreen(ep3_hssissk_bloodscale_convo_s_212)

ep3_hssissk_bloodscale_convo_s_980 = ConvoScreen:new {
	id = "s_980",
	animation = "dismiss",
	leftDialog = "@conversation/ep3_trandoshan_hssissk_zssik_06:s_980",
	stopConversation = "true",
	options = {
	}
}
ep3_hssissk_bloodscale_convo:addScreen(ep3_hssissk_bloodscale_convo_s_980)

addConversationTemplate("ep3_hssissk_bloodscale_convo", ep3_hssissk_bloodscale_convo)
