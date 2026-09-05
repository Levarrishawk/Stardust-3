-- ep3_harwakokok_mighty -- ep3_trandoshan_harwakokok_zssik_05
-- ruling 2026-09-04
-- Transcribed from the giver's java branches. Strings are shipped keys.
-- The journal row for the .qst comes from the integration branch later; do not call the journal engine.

ep3_harwakokok_mighty_convo = ConvoTemplate:new {
	initialScreen = "s_930",
	templateType = "Lua",
	luaClassHandler = "ep3_harwakokok_mighty_conv_handler",
	screens = {}
}

ep3_harwakokok_mighty_convo_s_892 = ConvoScreen:new {
	id = "s_892",
	animation = "bow",
	leftDialog = "@conversation/ep3_trandoshan_harwakokok_zssik_05:s_892",
	stopConversation = "true",
	options = {
	}
}
ep3_harwakokok_mighty_convo:addScreen(ep3_harwakokok_mighty_convo_s_892)

ep3_harwakokok_mighty_convo_s_900 = ConvoScreen:new {
	id = "s_900",
	animation = "shake_head_no",
	leftDialog = "@conversation/ep3_trandoshan_harwakokok_zssik_05:s_900",
	stopConversation = "false",
	options = {
		{"@conversation/ep3_trandoshan_harwakokok_zssik_05:s_902", "s_904"},
	}
}
ep3_harwakokok_mighty_convo:addScreen(ep3_harwakokok_mighty_convo_s_900)

ep3_harwakokok_mighty_convo_s_904 = ConvoScreen:new {
	id = "s_904",
	animation = "point_accusingly",
	leftDialog = "@conversation/ep3_trandoshan_harwakokok_zssik_05:s_904",
	stopConversation = "false",
	options = {
		{"@conversation/ep3_trandoshan_harwakokok_zssik_05:s_906", "s_908"},
	}
}
ep3_harwakokok_mighty_convo:addScreen(ep3_harwakokok_mighty_convo_s_904)

ep3_harwakokok_mighty_convo_s_908 = ConvoScreen:new {
	id = "s_908",
	animation = "rub_chin_thoughtful",
	leftDialog = "@conversation/ep3_trandoshan_harwakokok_zssik_05:s_908",
	stopConversation = "false",
	options = {
		{"@conversation/ep3_trandoshan_harwakokok_zssik_05:s_910", "s_912"},
	}
}
ep3_harwakokok_mighty_convo:addScreen(ep3_harwakokok_mighty_convo_s_908)

ep3_harwakokok_mighty_convo_s_912 = ConvoScreen:new {
	id = "s_912",
	animation = "point_forward",
	leftDialog = "@conversation/ep3_trandoshan_harwakokok_zssik_05:s_912",
	stopConversation = "false",
	options = {
		{"@conversation/ep3_trandoshan_harwakokok_zssik_05:s_914", "s_916"},
	}
}
ep3_harwakokok_mighty_convo:addScreen(ep3_harwakokok_mighty_convo_s_912)

ep3_harwakokok_mighty_convo_s_916 = ConvoScreen:new {
	id = "s_916",
	animation = "explain",
	leftDialog = "@conversation/ep3_trandoshan_harwakokok_zssik_05:s_916",
	stopConversation = "false",
	options = {
		{"@conversation/ep3_trandoshan_harwakokok_zssik_05:s_918", "s_920"},
	}
}
ep3_harwakokok_mighty_convo:addScreen(ep3_harwakokok_mighty_convo_s_916)

ep3_harwakokok_mighty_convo_s_920 = ConvoScreen:new {
	id = "s_920",
	animation = "explain",
	leftDialog = "@conversation/ep3_trandoshan_harwakokok_zssik_05:s_920",
	stopConversation = "false",
	options = {
		{"@conversation/ep3_trandoshan_harwakokok_zssik_05:s_922", "s_924"},
		{"@conversation/ep3_trandoshan_harwakokok_zssik_05:s_926", "s_928"},
	}
}
ep3_harwakokok_mighty_convo:addScreen(ep3_harwakokok_mighty_convo_s_920)

ep3_harwakokok_mighty_convo_s_924 = ConvoScreen:new {
	id = "s_924",
	animation = "wave_on_dismissing",
	leftDialog = "@conversation/ep3_trandoshan_harwakokok_zssik_05:s_924",
	stopConversation = "true",
	options = {
	}
}
ep3_harwakokok_mighty_convo:addScreen(ep3_harwakokok_mighty_convo_s_924)

ep3_harwakokok_mighty_convo_s_928 = ConvoScreen:new {
	id = "s_928",
	animation = "wave_on_dismissing",
	leftDialog = "@conversation/ep3_trandoshan_harwakokok_zssik_05:s_928",
	stopConversation = "true",
	options = {
	}
}
ep3_harwakokok_mighty_convo:addScreen(ep3_harwakokok_mighty_convo_s_928)

ep3_harwakokok_mighty_convo_s_122 = ConvoScreen:new {
	id = "s_122",
	leftDialog = "@conversation/ep3_trandoshan_harwakokok_zssik_05:s_122",
	stopConversation = "true",
	options = {
	}
}
ep3_harwakokok_mighty_convo:addScreen(ep3_harwakokok_mighty_convo_s_122)

ep3_harwakokok_mighty_convo_s_886 = ConvoScreen:new {
	id = "s_886",
	animation = "bow",
	leftDialog = "@conversation/ep3_trandoshan_harwakokok_zssik_05:s_886",
	stopConversation = "true",
	options = {
	}
}
ep3_harwakokok_mighty_convo:addScreen(ep3_harwakokok_mighty_convo_s_886)

ep3_harwakokok_mighty_convo_s_888 = ConvoScreen:new {
	id = "s_888",
	animation = "pose_proudly",
	leftDialog = "@conversation/ep3_trandoshan_harwakokok_zssik_05:s_888",
	stopConversation = "true",
	options = {
	}
}
ep3_harwakokok_mighty_convo:addScreen(ep3_harwakokok_mighty_convo_s_888)

ep3_harwakokok_mighty_convo_s_894 = ConvoScreen:new {
	id = "s_894",
	animation = "wave_on_dismissing",
	leftDialog = "@conversation/ep3_trandoshan_harwakokok_zssik_05:s_894",
	stopConversation = "true",
	options = {
	}
}
ep3_harwakokok_mighty_convo:addScreen(ep3_harwakokok_mighty_convo_s_894)

ep3_harwakokok_mighty_convo_s_896 = ConvoScreen:new {
	id = "s_896",
	animation = "rub_chin_thoughtful",
	leftDialog = "@conversation/ep3_trandoshan_harwakokok_zssik_05:s_896",
	stopConversation = "true",
	options = {
	}
}
ep3_harwakokok_mighty_convo:addScreen(ep3_harwakokok_mighty_convo_s_896)

ep3_harwakokok_mighty_convo_s_930 = ConvoScreen:new {
	id = "s_930",
	animation = "wave_on_dismissing",
	leftDialog = "@conversation/ep3_trandoshan_harwakokok_zssik_05:s_930",
	stopConversation = "true",
	options = {
	}
}
ep3_harwakokok_mighty_convo:addScreen(ep3_harwakokok_mighty_convo_s_930)

addConversationTemplate("ep3_harwakokok_mighty_convo", ep3_harwakokok_mighty_convo)
