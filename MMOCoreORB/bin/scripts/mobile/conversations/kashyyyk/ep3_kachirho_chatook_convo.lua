-- Chatook -- ep3_kachirho_missing_son
-- ruling 2026-09-04: "ensure kashyyyk is done in full"
-- Transcribed from the giver's java branches. Strings are shipped keys.
-- The journal row for quest/ep3_kachirho_*.qst comes from the integration branch later; do not call Journal.*.

ep3_kachirho_chatook_convo = ConvoTemplate:new {
	initialScreen = "s_262",
	templateType = "Lua",
	luaClassHandler = "ep3_kachirho_chatook_conv_handler",
	screens = {}
}

ep3_kachirho_chatook_convo_s_32 = ConvoScreen:new {
	id = "s_32",
	leftDialog = "@conversation/ep3_kachirho_missing_son:s_32", -- Rrowww. Grrrrr. Rorrorroww.
	stopConversation = "true",
	options = {}
}
ep3_kachirho_chatook_convo:addScreen(ep3_kachirho_chatook_convo_s_32)

ep3_kachirho_chatook_convo_s_236 = ConvoScreen:new {
	id = "s_236",
	animation = "weeping",
	leftDialog = "@conversation/ep3_kachirho_missing_son:s_236", -- Please leave me be. I just want to be left alone.
	stopConversation = "true",
	options = {}
}
ep3_kachirho_chatook_convo:addScreen(ep3_kachirho_chatook_convo_s_236)

ep3_kachirho_chatook_convo_s_238 = ConvoScreen:new {
	id = "s_238",
	animation = "slump_head",
	leftDialog = "@conversation/ep3_kachirho_missing_son:s_238", -- I am exhausted. I cannot find any evidence of where Takook is. Maybe you have better news for me.
	stopConversation = "false",
	options = {
		{"@conversation/ep3_kachirho_missing_son:s_240", "s_242"},
	}
}
ep3_kachirho_chatook_convo:addScreen(ep3_kachirho_chatook_convo_s_238)

ep3_kachirho_chatook_convo_s_260 = ConvoScreen:new {
	id = "s_260",
	animation = "implore",
	leftDialog = "@conversation/ep3_kachirho_missing_son:s_260", -- I still haven't been able to find Takook. We must continue the search because I am sure he is in great need of help.
	stopConversation = "true",
	options = {}
}
ep3_kachirho_chatook_convo:addScreen(ep3_kachirho_chatook_convo_s_260)

ep3_kachirho_chatook_convo_s_262 = ConvoScreen:new {
	id = "s_262",
	animation = "beckon",
	leftDialog = "@conversation/ep3_kachirho_missing_son:s_262", -- Offworlder! I do not wish to inconvenience you but I am in desperate need of help. My son, Takook, is missing. I beg you to please help me find him.
	stopConversation = "false",
	options = {
		{"@conversation/ep3_kachirho_missing_son:s_270", "s_272"},
		{"@conversation/ep3_kachirho_missing_son:s_291", "s_293"},
	}
}
ep3_kachirho_chatook_convo:addScreen(ep3_kachirho_chatook_convo_s_262)

ep3_kachirho_chatook_convo_s_242 = ConvoScreen:new {
	id = "s_242",
	animation = "cover_mouth",
	leftDialog = "@conversation/ep3_kachirho_missing_son:s_242", -- Oh, no! You have found my son...and...and...
	stopConversation = "false",
	options = {
		{"@conversation/ep3_kachirho_missing_son:s_244", "s_246"},
	}
}
ep3_kachirho_chatook_convo:addScreen(ep3_kachirho_chatook_convo_s_242)

ep3_kachirho_chatook_convo_s_246 = ConvoScreen:new {
	id = "s_246",
	animation = "weeping",
	leftDialog = "@conversation/ep3_kachirho_missing_son:s_246", -- ...How....how did this happen? He was a good hunter. I don't understand how this could happen. My poor Takook.
	stopConversation = "false",
	options = {
		{"@conversation/ep3_kachirho_missing_son:s_248", "s_250"},
	}
}
ep3_kachirho_chatook_convo:addScreen(ep3_kachirho_chatook_convo_s_246)

ep3_kachirho_chatook_convo_s_250 = ConvoScreen:new {
	id = "s_250",
	animation = "weeping",
	leftDialog = "@conversation/ep3_kachirho_missing_son:s_250", -- My spear? Takook was killed because of a spear? If it meant so much to Lobarorr I would have just given it to him. I always knew that Lobarorr was no good. N...
	stopConversation = "false",
	options = {
		{"@conversation/ep3_kachirho_missing_son:s_252", "s_254"},
	}
}
ep3_kachirho_chatook_convo:addScreen(ep3_kachirho_chatook_convo_s_250)

ep3_kachirho_chatook_convo_s_254 = ConvoScreen:new {
	id = "s_254",
	animation = "sigh_deeply",
	leftDialog = "@conversation/ep3_kachirho_missing_son:s_254", -- So, you tracked down and killed Lobarorr to recover my spear. I see. You have honored my son by completing his final request. You may be an offworlder but yo...
	stopConversation = "false",
	options = {
		{"@conversation/ep3_kachirho_missing_son:s_256", "s_258"},
	}
}
ep3_kachirho_chatook_convo:addScreen(ep3_kachirho_chatook_convo_s_254)

ep3_kachirho_chatook_convo_s_258 = ConvoScreen:new {
	id = "s_258",
	animation = "weeping",
	leftDialog = "@conversation/ep3_kachirho_missing_son:s_258", -- As am I. As am I. If you will please excuse me I need to be alone now.
	stopConversation = "true",
	options = {}
}
ep3_kachirho_chatook_convo:addScreen(ep3_kachirho_chatook_convo_s_258)

ep3_kachirho_chatook_convo_s_272 = ConvoScreen:new {
	id = "s_272",
	animation = "gesticulate_wildly",
	leftDialog = "@conversation/ep3_kachirho_missing_son:s_272", -- I saw him two days ago heading in the forest with his friend Lobarorr, who hasn't returned either. He said that they were going to do a little hunting and wo...
	stopConversation = "false",
	options = {
		{"@conversation/ep3_kachirho_missing_son:s_279", "s_281"},
	}
}
ep3_kachirho_chatook_convo:addScreen(ep3_kachirho_chatook_convo_s_272)

ep3_kachirho_chatook_convo_s_281 = ConvoScreen:new {
	id = "s_281",
	animation = "refuse_offer_affection",
	leftDialog = "@conversation/ep3_kachirho_missing_son:s_281", -- No! Of course, not. My son would never do something like that. He is out there somewhere, probably injured and unable to return home. Please, I am begging yo...
	stopConversation = "false",
	options = {
		{"@conversation/ep3_kachirho_missing_son:s_283", "s_285"},
		{"@conversation/ep3_kachirho_missing_son:s_287", "s_289"},
	}
}
ep3_kachirho_chatook_convo:addScreen(ep3_kachirho_chatook_convo_s_281)

ep3_kachirho_chatook_convo_s_285 = ConvoScreen:new {
	id = "s_285",
	animation = "bow2",
	leftDialog = "@conversation/ep3_kachirho_missing_son:s_285", -- Thank you so much. This means a lot to me. My son is the only family I have left since the slavers took his mother and the sickness swept through my kin.
	stopConversation = "true",
	options = {}
}
ep3_kachirho_chatook_convo:addScreen(ep3_kachirho_chatook_convo_s_285)

ep3_kachirho_chatook_convo_s_289 = ConvoScreen:new {
	id = "s_289",
	animation = "slump_head",
	leftDialog = "@conversation/ep3_kachirho_missing_son:s_289", -- I understand. I shall continue my search for Takook on my own.
	stopConversation = "true",
	options = {}
}
ep3_kachirho_chatook_convo:addScreen(ep3_kachirho_chatook_convo_s_289)

ep3_kachirho_chatook_convo_s_293 = ConvoScreen:new {
	id = "s_293",
	leftDialog = "@conversation/ep3_kachirho_missing_son:s_293", -- Of course. I am ashamed that I put my troubles on the shoulders of a complete stranger. Forget I said anything.
	stopConversation = "true",
	options = {}
}
ep3_kachirho_chatook_convo:addScreen(ep3_kachirho_chatook_convo_s_293)

addConversationTemplate("ep3_kachirho_chatook_convo", ep3_kachirho_chatook_convo)
