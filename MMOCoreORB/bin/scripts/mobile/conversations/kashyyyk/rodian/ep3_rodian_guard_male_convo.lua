-- ep3_rodian_guard_male
-- ruling 2026-09-04
-- Transcribed from the giver's java branches. Strings are shipped keys.
-- NO JOURNAL: this branch has no managers/quest/journal.lua. The client ships
-- the .qst; the journal row comes from the integration branch later.

ep3_rodian_guard_male_convo = ConvoTemplate:new {
	initialScreen = "s_eb018d3d",
	templateType = "Lua",
	luaClassHandler = "ep3_rodian_guard_male_conv_handler",
	screens = {}
}

ep3_rodian_guard_male_convo_s_eb018d3d = ConvoScreen:new {
	id = "s_eb018d3d",
	animation = "shake_head_no",
	leftDialog = "@conversation/ep3_rodian_guard_male:s_eb018d3d", -- I cannot help you, but Bazeedo can.
	stopConversation = "false",
	options = {
		{"@conversation/ep3_rodian_guard_male:s_b9b27823", "s_c8f2f3db"},
	}
}
ep3_rodian_guard_male_convo:addScreen(ep3_rodian_guard_male_convo_s_eb018d3d)

ep3_rodian_guard_male_convo_s_56dc37ee = ConvoScreen:new {
	id = "s_56dc37ee",
	animation = "rub_chin_thoughtful",
	leftDialog = "@conversation/ep3_rodian_guard_male:s_56dc37ee", -- I hear you want to hunt in this area.
	stopConversation = "false",
	options = {
		{"@conversation/ep3_rodian_guard_male:s_d70dba34", "s_d8c12a4e"},
	}
}
ep3_rodian_guard_male_convo:addScreen(ep3_rodian_guard_male_convo_s_56dc37ee)

ep3_rodian_guard_male_convo_s_ad7f810c = ConvoScreen:new {
	id = "s_ad7f810c",
	animation = "smack_self",
	leftDialog = "@conversation/ep3_rodian_guard_male:s_ad7f810c", -- The rills are out of control!
	stopConversation = "false",
	options = {
		{"@conversation/ep3_rodian_guard_male:s_77e48d5b", "s_5bbf7644"},
	}
}
ep3_rodian_guard_male_convo:addScreen(ep3_rodian_guard_male_convo_s_ad7f810c)

ep3_rodian_guard_male_convo_s_ee40364b = ConvoScreen:new {
	id = "s_ee40364b",
	animation = "shake_head_disgust",
	leftDialog = "@conversation/ep3_rodian_guard_male:s_ee40364b", -- Trandoshan pigs!
	stopConversation = "false",
	options = {
		{"@conversation/ep3_rodian_guard_male:s_b84b366c", "s_3400e92e"},
	}
}
ep3_rodian_guard_male_convo:addScreen(ep3_rodian_guard_male_convo_s_ee40364b)

ep3_rodian_guard_male_convo_s_aca8a41d = ConvoScreen:new {
	id = "s_aca8a41d",
	animation = "bow",
	leftDialog = "@conversation/ep3_rodian_guard_male:s_aca8a41d", -- You honor us with your hunting skill.
	stopConversation = "true",
	options = {}
}
ep3_rodian_guard_male_convo:addScreen(ep3_rodian_guard_male_convo_s_aca8a41d)

ep3_rodian_guard_male_convo_s_c8f2f3db = ConvoScreen:new {
	id = "s_c8f2f3db",
	animation = "goodbye",
	leftDialog = "@conversation/ep3_rodian_guard_male:s_c8f2f3db", -- Farewell.
	stopConversation = "true",
	options = {}
}
ep3_rodian_guard_male_convo:addScreen(ep3_rodian_guard_male_convo_s_c8f2f3db)

ep3_rodian_guard_male_convo_s_d8c12a4e = ConvoScreen:new {
	id = "s_d8c12a4e",
	animation = "point_left",
	leftDialog = "@conversation/ep3_rodian_guard_male:s_d8c12a4e", -- Before you can do that - become friends with our wookiee benefactor.
	stopConversation = "true",
	options = {}
}
ep3_rodian_guard_male_convo:addScreen(ep3_rodian_guard_male_convo_s_d8c12a4e)

ep3_rodian_guard_male_convo_s_5bbf7644 = ConvoScreen:new {
	id = "s_5bbf7644",
	animation = "point_right",
	leftDialog = "@conversation/ep3_rodian_guard_male:s_5bbf7644", -- Ask Bazeedo. He'll fill you in.
	stopConversation = "true",
	options = {}
}
ep3_rodian_guard_male_convo:addScreen(ep3_rodian_guard_male_convo_s_5bbf7644)

ep3_rodian_guard_male_convo_s_3400e92e = ConvoScreen:new {
	id = "s_3400e92e",
	animation = "pound_fist_palm",
	leftDialog = "@conversation/ep3_rodian_guard_male:s_3400e92e", -- Kill them all!
	stopConversation = "true",
	options = {}
}
ep3_rodian_guard_male_convo:addScreen(ep3_rodian_guard_male_convo_s_3400e92e)

addConversationTemplate("ep3_rodian_guard_male_convo", ep3_rodian_guard_male_convo)
