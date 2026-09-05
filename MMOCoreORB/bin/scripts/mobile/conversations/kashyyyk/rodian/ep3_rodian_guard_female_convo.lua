-- ep3_rodian_guard_female
-- ruling 2026-09-04
-- Transcribed from the giver's java branches. Strings are shipped keys.
-- NO JOURNAL: this branch has no managers/quest/journal.lua. The client ships
-- the .qst; the journal row comes from the integration branch later.

ep3_rodian_guard_female_convo = ConvoTemplate:new {
	initialScreen = "s_3c80890b",
	templateType = "Lua",
	luaClassHandler = "ep3_rodian_guard_female_conv_handler",
	screens = {}
}

ep3_rodian_guard_female_convo_s_3c80890b = ConvoScreen:new {
	id = "s_3c80890b",
	animation = "shake_head_no",
	leftDialog = "@conversation/ep3_rodian_guard_female:s_3c80890b", -- You must speak with Bazeedo first, my friend.
	stopConversation = "false",
	options = {
		{"@conversation/ep3_rodian_guard_female:s_b9b27823", "s_c8f2f3db"},
	}
}
ep3_rodian_guard_female_convo:addScreen(ep3_rodian_guard_female_convo_s_3c80890b)

ep3_rodian_guard_female_convo_s_eec83bd7 = ConvoScreen:new {
	id = "s_eec83bd7",
	animation = "greet",
	leftDialog = "@conversation/ep3_rodian_guard_female:s_eec83bd7", -- Bazeedo says you are befriending the wookiee.
	stopConversation = "false",
	options = {
		{"@conversation/ep3_rodian_guard_female:s_c8f39347", "s_4d850454"},
	}
}
ep3_rodian_guard_female_convo:addScreen(ep3_rodian_guard_female_convo_s_eec83bd7)

ep3_rodian_guard_female_convo_s_ad7f810c = ConvoScreen:new {
	id = "s_ad7f810c",
	animation = "smack_self",
	leftDialog = "@conversation/ep3_rodian_guard_female:s_ad7f810c", -- The rills are out of control!
	stopConversation = "false",
	options = {
		{"@conversation/ep3_rodian_guard_female:s_77e48d5b", "s_5bbf7644"},
	}
}
ep3_rodian_guard_female_convo:addScreen(ep3_rodian_guard_female_convo_s_ad7f810c)

ep3_rodian_guard_female_convo_s_ee40364b = ConvoScreen:new {
	id = "s_ee40364b",
	animation = "shake_head_disgust",
	leftDialog = "@conversation/ep3_rodian_guard_female:s_ee40364b", -- Trandoshan pigs!
	stopConversation = "false",
	options = {
		{"@conversation/ep3_rodian_guard_female:s_b84b366c", "s_3400e92e"},
	}
}
ep3_rodian_guard_female_convo:addScreen(ep3_rodian_guard_female_convo_s_ee40364b)

ep3_rodian_guard_female_convo_s_9c327f1a = ConvoScreen:new {
	id = "s_9c327f1a",
	animation = "bow",
	leftDialog = "@conversation/ep3_rodian_guard_female:s_9c327f1a", -- Greetings fellow hunter!
	stopConversation = "true",
	options = {}
}
ep3_rodian_guard_female_convo:addScreen(ep3_rodian_guard_female_convo_s_9c327f1a)

ep3_rodian_guard_female_convo_s_c8f2f3db = ConvoScreen:new {
	id = "s_c8f2f3db",
	animation = "goodbye",
	leftDialog = "@conversation/ep3_rodian_guard_female:s_c8f2f3db", -- Farewell.
	stopConversation = "true",
	options = {}
}
ep3_rodian_guard_female_convo:addScreen(ep3_rodian_guard_female_convo_s_c8f2f3db)

ep3_rodian_guard_female_convo_s_4d850454 = ConvoScreen:new {
	id = "s_4d850454",
	animation = "goodbye",
	leftDialog = "@conversation/ep3_rodian_guard_female:s_4d850454", -- We will hunt together when you are done!
	stopConversation = "true",
	options = {}
}
ep3_rodian_guard_female_convo:addScreen(ep3_rodian_guard_female_convo_s_4d850454)

ep3_rodian_guard_female_convo_s_5bbf7644 = ConvoScreen:new {
	id = "s_5bbf7644",
	animation = "point_left",
	leftDialog = "@conversation/ep3_rodian_guard_female:s_5bbf7644", -- Ask Bazeedo. He'll fill you in.
	stopConversation = "true",
	options = {}
}
ep3_rodian_guard_female_convo:addScreen(ep3_rodian_guard_female_convo_s_5bbf7644)

ep3_rodian_guard_female_convo_s_3400e92e = ConvoScreen:new {
	id = "s_3400e92e",
	animation = "pound_fist_palm",
	leftDialog = "@conversation/ep3_rodian_guard_female:s_3400e92e", -- Kill them all!
	stopConversation = "true",
	options = {}
}
ep3_rodian_guard_female_convo:addScreen(ep3_rodian_guard_female_convo_s_3400e92e)

addConversationTemplate("ep3_rodian_guard_female_convo", ep3_rodian_guard_female_convo)
