-- Marium Valmont -- ep3_avatar_return
-- ruling 2026-09-04: "ensure kashyyyk is fully done"
-- Transcribed from the giver's java. Strings are shipped keys.
-- NO JOURNAL: the journal engine is not in this tree. Do not call the journal API.

ep3_kachirho_avatar_return_convo = ConvoTemplate:new {
	initialScreen = "s_120",
	templateType = "Lua",
	luaClassHandler = "ep3_kachirho_avatar_return_conv_handler",
	screens = {}
}

ep3_kachirho_avatar_return_convo_s_76 = ConvoScreen:new {
	id = "s_76",
	animation = "greet",
	leftDialog = "@conversation/ep3_kachirho_avatar_return:s_76", -- %NU! Such a pleasure to see you again. I have another job if you are interested. That client of mine was so happy...
	stopConversation = "false",
	options = {
		{"@conversation/ep3_kachirho_avatar_return:s_78", "s_80"},
		{"@conversation/ep3_kachirho_avatar_return:s_82", "s_84"},
	}
}
ep3_kachirho_avatar_return_convo:addScreen(ep3_kachirho_avatar_return_convo_s_76)

ep3_kachirho_avatar_return_convo_s_80 = ConvoScreen:new {
	id = "s_80",
	animation = "explain",
	leftDialog = "@conversation/ep3_kachirho_avatar_return:s_80", -- Good. I will send the details to your journal again. Come back and see me when you have everything.
	stopConversation = "true",
	options = {}
}
ep3_kachirho_avatar_return_convo:addScreen(ep3_kachirho_avatar_return_convo_s_80)

ep3_kachirho_avatar_return_convo_s_84 = ConvoScreen:new {
	id = "s_84",
	animation = "goodbye",
	leftDialog = "@conversation/ep3_kachirho_avatar_return:s_84", -- Maybe later then.
	stopConversation = "true",
	options = {}
}
ep3_kachirho_avatar_return_convo:addScreen(ep3_kachirho_avatar_return_convo_s_84)

ep3_kachirho_avatar_return_convo_s_86 = ConvoScreen:new {
	id = "s_86",
	animation = "greet",
	leftDialog = "@conversation/ep3_kachirho_avatar_return:s_86", -- Well, look who is back? Nice to see you again, %NU. Did you manage to get all the stuff?
	stopConversation = "false",
	options = {
		{"@conversation/ep3_kachirho_avatar_return:s_88", "s_90"},
	}
}
ep3_kachirho_avatar_return_convo:addScreen(ep3_kachirho_avatar_return_convo_s_86)

ep3_kachirho_avatar_return_convo_s_90 = ConvoScreen:new {
	id = "s_90",
	animation = "shush",
	leftDialog = "@conversation/ep3_kachirho_avatar_return:s_90", -- I have this rule when dealing with my customers, don't ask too many questions. I don't know and I don't want to know...
	stopConversation = "true",
	options = {}
}
ep3_kachirho_avatar_return_convo:addScreen(ep3_kachirho_avatar_return_convo_s_90)

ep3_kachirho_avatar_return_convo_s_92 = ConvoScreen:new {
	id = "s_92",
	animation = "point_accusingly",
	leftDialog = "@conversation/ep3_kachirho_avatar_return:s_92", -- What are you doing back here without the stuff? I was hoping that your reputation wasn't all hype...
	stopConversation = "true",
	options = {}
}
ep3_kachirho_avatar_return_convo:addScreen(ep3_kachirho_avatar_return_convo_s_92)

ep3_kachirho_avatar_return_convo_s_94 = ConvoScreen:new {
	id = "s_94",
	animation = "laugh_titter",
	leftDialog = "@conversation/ep3_kachirho_avatar_return:s_94", -- Well, well, well. Look what just walked out of my dreams and into my life. I must say it is a pleasure...
	stopConversation = "false",
	options = {
		{"@conversation/ep3_kachirho_avatar_return:s_96", "s_98"},
	}
}
ep3_kachirho_avatar_return_convo:addScreen(ep3_kachirho_avatar_return_convo_s_94)

ep3_kachirho_avatar_return_convo_s_98 = ConvoScreen:new {
	id = "s_98",
	animation = "nod_head_once",
	leftDialog = "@conversation/ep3_kachirho_avatar_return:s_98", -- Then I will just assume that you are looking for work. That is good, because I just got an order...
	stopConversation = "false",
	options = {
		{"@conversation/ep3_kachirho_avatar_return:s_100", "s_102"},
	}
}
ep3_kachirho_avatar_return_convo:addScreen(ep3_kachirho_avatar_return_convo_s_98)

ep3_kachirho_avatar_return_convo_s_102 = ConvoScreen:new {
	id = "s_102",
	animation = "laugh_titter",
	leftDialog = "@conversation/ep3_kachirho_avatar_return:s_102", -- Really? So you actually think that you blew it up? How cute. Use your brain for just a moment...
	stopConversation = "false",
	options = {
		{"@conversation/ep3_kachirho_avatar_return:s_104", "s_106"},
	}
}
ep3_kachirho_avatar_return_convo:addScreen(ep3_kachirho_avatar_return_convo_s_102)

ep3_kachirho_avatar_return_convo_s_106 = ConvoScreen:new {
	id = "s_106",
	animation = "explain",
	leftDialog = "@conversation/ep3_kachirho_avatar_return:s_106", -- You made a lot of pretty explosions, load bangs, killed most people on the platform, but overall...
	stopConversation = "false",
	options = {
		{"@conversation/ep3_kachirho_avatar_return:s_108", "s_110"},
	}
}
ep3_kachirho_avatar_return_convo:addScreen(ep3_kachirho_avatar_return_convo_s_106)

ep3_kachirho_avatar_return_convo_s_110 = ConvoScreen:new {
	id = "s_110",
	animation = "explain",
	leftDialog = "@conversation/ep3_kachirho_avatar_return:s_110", -- No, sorry. But you did what the Zssik needed of you and now I am hoping that you do the same for me...
	stopConversation = "false",
	options = {
		{"@conversation/ep3_kachirho_avatar_return:s_112", "s_114"},
		{"@conversation/ep3_kachirho_avatar_return:s_116", "s_118"},
	}
}
ep3_kachirho_avatar_return_convo:addScreen(ep3_kachirho_avatar_return_convo_s_110)

ep3_kachirho_avatar_return_convo_s_114 = ConvoScreen:new {
	id = "s_114",
	animation = "explain",
	leftDialog = "@conversation/ep3_kachirho_avatar_return:s_114", -- The basics are there are five different substances stored around the station. My client has asked me...
	stopConversation = "true",
	options = {}
}
ep3_kachirho_avatar_return_convo:addScreen(ep3_kachirho_avatar_return_convo_s_114)

ep3_kachirho_avatar_return_convo_s_118 = ConvoScreen:new {
	id = "s_118",
	animation = "slump_head",
	leftDialog = "@conversation/ep3_kachirho_avatar_return:s_118", -- Ah, you make me so sad. Well if you change your mind, you know where to find me. Ta-ta.
	stopConversation = "true",
	options = {}
}
ep3_kachirho_avatar_return_convo:addScreen(ep3_kachirho_avatar_return_convo_s_118)

ep3_kachirho_avatar_return_convo_s_120 = ConvoScreen:new {
	id = "s_120",
	animation = "wave_on_dismissing",
	leftDialog = "@conversation/ep3_kachirho_avatar_return:s_120", -- You obviously don't know me. If you did, you would know that I don't just talk to anyone off the street...
	stopConversation = "true",
	options = {}
}
ep3_kachirho_avatar_return_convo:addScreen(ep3_kachirho_avatar_return_convo_s_120)

addConversationTemplate("ep3_kachirho_avatar_return_convo", ep3_kachirho_avatar_return_convo)
