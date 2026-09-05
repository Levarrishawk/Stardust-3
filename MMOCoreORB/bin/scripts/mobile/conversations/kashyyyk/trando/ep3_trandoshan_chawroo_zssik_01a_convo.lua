-- ep3_trandoshan_chawroo_zssik_01a -- ep3_trandoshan_chawroo_zssik_01a
-- ruling 2026-09-04
-- Transcribed from the giver's java branches. Strings are shipped keys.
-- The journal row for the .qst comes from the integration branch later; do not call the journal engine.

ep3_trandoshan_chawroo_zssik_01a_convo = ConvoTemplate:new {
	initialScreen = "s_793",
	templateType = "Lua",
	luaClassHandler = "ep3_trandoshan_chawroo_zssik_01a_conv_handler",
	screens = {}
}

ep3_trandoshan_chawroo_zssik_01a_convo_s_751 = ConvoScreen:new {
	id = "s_751",
	animation = "nod_head_once",
	leftDialog = "@conversation/ep3_trandoshan_chawroo_zssik_01a:s_751",
	stopConversation = "true",
	options = {
	}
}
ep3_trandoshan_chawroo_zssik_01a_convo:addScreen(ep3_trandoshan_chawroo_zssik_01a_convo_s_751)

ep3_trandoshan_chawroo_zssik_01a_convo_s_757 = ConvoScreen:new {
	id = "s_757",
	animation = "bow4",
	leftDialog = "@conversation/ep3_trandoshan_chawroo_zssik_01a:s_757",
	stopConversation = "false",
	options = {
		{"@conversation/ep3_trandoshan_chawroo_zssik_01a:s_759", "s_761"},
	}
}
ep3_trandoshan_chawroo_zssik_01a_convo:addScreen(ep3_trandoshan_chawroo_zssik_01a_convo_s_757)

ep3_trandoshan_chawroo_zssik_01a_convo_s_761 = ConvoScreen:new {
	id = "s_761",
	animation = "embarrassed",
	leftDialog = "@conversation/ep3_trandoshan_chawroo_zssik_01a:s_761",
	stopConversation = "false",
	options = {
		{"@conversation/ep3_trandoshan_chawroo_zssik_01a:s_763", "s_765"},
	}
}
ep3_trandoshan_chawroo_zssik_01a_convo:addScreen(ep3_trandoshan_chawroo_zssik_01a_convo_s_761)

ep3_trandoshan_chawroo_zssik_01a_convo_s_765 = ConvoScreen:new {
	id = "s_765",
	animation = "slump_head",
	leftDialog = "@conversation/ep3_trandoshan_chawroo_zssik_01a:s_765",
	stopConversation = "false",
	options = {
		{"@conversation/ep3_trandoshan_chawroo_zssik_01a:s_767", "s_769"},
	}
}
ep3_trandoshan_chawroo_zssik_01a_convo:addScreen(ep3_trandoshan_chawroo_zssik_01a_convo_s_765)

ep3_trandoshan_chawroo_zssik_01a_convo_s_769 = ConvoScreen:new {
	id = "s_769",
	animation = "embarrassed",
	leftDialog = "@conversation/ep3_trandoshan_chawroo_zssik_01a:s_769",
	stopConversation = "false",
	options = {
		{"@conversation/ep3_trandoshan_chawroo_zssik_01a:s_771", "s_773"},
	}
}
ep3_trandoshan_chawroo_zssik_01a_convo:addScreen(ep3_trandoshan_chawroo_zssik_01a_convo_s_769)

ep3_trandoshan_chawroo_zssik_01a_convo_s_773 = ConvoScreen:new {
	id = "s_773",
	animation = "sigh_deeply",
	leftDialog = "@conversation/ep3_trandoshan_chawroo_zssik_01a:s_773",
	stopConversation = "false",
	options = {
		{"@conversation/ep3_trandoshan_chawroo_zssik_01a:s_775", "s_777"},
	}
}
ep3_trandoshan_chawroo_zssik_01a_convo:addScreen(ep3_trandoshan_chawroo_zssik_01a_convo_s_773)

ep3_trandoshan_chawroo_zssik_01a_convo_s_777 = ConvoScreen:new {
	id = "s_777",
	animation = "point_accusingly",
	leftDialog = "@conversation/ep3_trandoshan_chawroo_zssik_01a:s_777",
	stopConversation = "false",
	options = {
		{"@conversation/ep3_trandoshan_chawroo_zssik_01a:s_779", "s_781"},
		{"@conversation/ep3_trandoshan_chawroo_zssik_01a:s_787", "s_789"},
	}
}
ep3_trandoshan_chawroo_zssik_01a_convo:addScreen(ep3_trandoshan_chawroo_zssik_01a_convo_s_777)

ep3_trandoshan_chawroo_zssik_01a_convo_s_781 = ConvoScreen:new {
	id = "s_781",
	animation = "shake_head_no",
	leftDialog = "@conversation/ep3_trandoshan_chawroo_zssik_01a:s_781",
	stopConversation = "false",
	options = {
		{"@conversation/ep3_trandoshan_chawroo_zssik_01a:s_783", "s_785"},
	}
}
ep3_trandoshan_chawroo_zssik_01a_convo:addScreen(ep3_trandoshan_chawroo_zssik_01a_convo_s_781)

ep3_trandoshan_chawroo_zssik_01a_convo_s_789 = ConvoScreen:new {
	id = "s_789",
	animation = "nod_head_multiple",
	leftDialog = "@conversation/ep3_trandoshan_chawroo_zssik_01a:s_789",
	stopConversation = "true",
	options = {
	}
}
ep3_trandoshan_chawroo_zssik_01a_convo:addScreen(ep3_trandoshan_chawroo_zssik_01a_convo_s_789)

ep3_trandoshan_chawroo_zssik_01a_convo_s_785 = ConvoScreen:new {
	id = "s_785",
	animation = "weeping",
	leftDialog = "@conversation/ep3_trandoshan_chawroo_zssik_01a:s_785",
	stopConversation = "true",
	options = {
	}
}
ep3_trandoshan_chawroo_zssik_01a_convo:addScreen(ep3_trandoshan_chawroo_zssik_01a_convo_s_785)

ep3_trandoshan_chawroo_zssik_01a_convo_s_70 = ConvoScreen:new {
	id = "s_70",
	leftDialog = "@conversation/ep3_trandoshan_chawroo_zssik_01a:s_70",
	stopConversation = "true",
	options = {
	}
}
ep3_trandoshan_chawroo_zssik_01a_convo:addScreen(ep3_trandoshan_chawroo_zssik_01a_convo_s_70)

ep3_trandoshan_chawroo_zssik_01a_convo_s_747 = ConvoScreen:new {
	id = "s_747",
	animation = "sigh_deeply",
	leftDialog = "@conversation/ep3_trandoshan_chawroo_zssik_01a:s_747",
	stopConversation = "true",
	options = {
	}
}
ep3_trandoshan_chawroo_zssik_01a_convo:addScreen(ep3_trandoshan_chawroo_zssik_01a_convo_s_747)

ep3_trandoshan_chawroo_zssik_01a_convo_s_753 = ConvoScreen:new {
	id = "s_753",
	animation = "embarrassed",
	leftDialog = "@conversation/ep3_trandoshan_chawroo_zssik_01a:s_753",
	stopConversation = "true",
	options = {
	}
}
ep3_trandoshan_chawroo_zssik_01a_convo:addScreen(ep3_trandoshan_chawroo_zssik_01a_convo_s_753)

ep3_trandoshan_chawroo_zssik_01a_convo_s_791 = ConvoScreen:new {
	id = "s_791",
	animation = "standing_raise_fist",
	leftDialog = "@conversation/ep3_trandoshan_chawroo_zssik_01a:s_791",
	stopConversation = "true",
	options = {
	}
}
ep3_trandoshan_chawroo_zssik_01a_convo:addScreen(ep3_trandoshan_chawroo_zssik_01a_convo_s_791)

ep3_trandoshan_chawroo_zssik_01a_convo_s_793 = ConvoScreen:new {
	id = "s_793",
	animation = "point_accusingly",
	leftDialog = "@conversation/ep3_trandoshan_chawroo_zssik_01a:s_793",
	stopConversation = "true",
	options = {
	}
}
ep3_trandoshan_chawroo_zssik_01a_convo:addScreen(ep3_trandoshan_chawroo_zssik_01a_convo_s_793)

addConversationTemplate("ep3_trandoshan_chawroo_zssik_01a_convo", ep3_trandoshan_chawroo_zssik_01a_convo)
