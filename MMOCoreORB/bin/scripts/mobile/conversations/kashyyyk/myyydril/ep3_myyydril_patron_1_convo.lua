-- ep3_myyydril_patron_1
-- ruling 2026-09-04
-- Transcribed from the giver's java branches. Strings are shipped keys.
-- The journal row for quest/ep3_myyydril_*.qst comes from the integration branch later; do not call the journal API.

ep3_myyydril_patron_1_convo = ConvoTemplate:new {
	initialScreen = "s_29",
	templateType = "Lua",
	luaClassHandler = "ep3_myyydril_patron_1_conv_handler",
	screens = {}
}

ep3_myyydril_patron_1_convo_s_29 = ConvoScreen:new {
	id = "s_29",
	leftDialog = "@conversation/ep3_myyydril_patron_1:s_29", -- I do not think we have anything to talk about. Good day.
	stopConversation = "true",
	options = {}
}
ep3_myyydril_patron_1_convo:addScreen(ep3_myyydril_patron_1_convo_s_29)

ep3_myyydril_patron_1_convo_s_586 = ConvoScreen:new {
	id = "s_586",
	leftDialog = "@conversation/ep3_myyydril_patron_1:s_586", -- How are you these days? My husband and I are doing pretty well. We plan to visit Kachirho in a few days. I've never been there. I hope th...
	stopConversation = "false",
	options = {
		{"@conversation/ep3_myyydril_patron_1:s_588", "s_590"},
	}
}
ep3_myyydril_patron_1_convo:addScreen(ep3_myyydril_patron_1_convo_s_586)

ep3_myyydril_patron_1_convo_s_590 = ConvoScreen:new {
	id = "s_590",
	leftDialog = "@conversation/ep3_myyydril_patron_1:s_590", -- Well... I better get back to planning. I need to cook dinner for tonight.
	stopConversation = "true",
	options = {}
}
ep3_myyydril_patron_1_convo:addScreen(ep3_myyydril_patron_1_convo_s_590)

ep3_myyydril_patron_1_convo_s_592 = ConvoScreen:new {
	id = "s_592",
	leftDialog = "@conversation/ep3_myyydril_patron_1:s_592", -- You know... You should speak with Chief Kallaarac. There's no doubt that he'll be wanting to speak with you after all you've done. You're...
	stopConversation = "false",
	options = {
		{"@conversation/ep3_myyydril_patron_1:s_594", "s_596"},
	}
}
ep3_myyydril_patron_1_convo:addScreen(ep3_myyydril_patron_1_convo_s_592)

ep3_myyydril_patron_1_convo_s_596 = ConvoScreen:new {
	id = "s_596",
	leftDialog = "@conversation/ep3_myyydril_patron_1:s_596", -- Be on your way. I hope he thinks favorably of you. Come back and visit sometime, will you?
	stopConversation = "true",
	options = {}
}
ep3_myyydril_patron_1_convo:addScreen(ep3_myyydril_patron_1_convo_s_596)

ep3_myyydril_patron_1_convo_s_598 = ConvoScreen:new {
	id = "s_598",
	leftDialog = "@conversation/ep3_myyydril_patron_1:s_598", -- [Nawika looks at you expectantly.] Did you find it?
	stopConversation = "false",
	options = {
		{"@conversation/ep3_myyydril_patron_1:s_600", "s_602"},
	}
}
ep3_myyydril_patron_1_convo:addScreen(ep3_myyydril_patron_1_convo_s_598)

ep3_myyydril_patron_1_convo_s_602 = ConvoScreen:new {
	id = "s_602",
	leftDialog = "@conversation/ep3_myyydril_patron_1:s_602", -- Oh, thank you! How ever did you find it!
	stopConversation = "false",
	options = {
		{"@conversation/ep3_myyydril_patron_1:s_604", "s_606"},
	}
}
ep3_myyydril_patron_1_convo:addScreen(ep3_myyydril_patron_1_convo_s_602)

ep3_myyydril_patron_1_convo_s_606 = ConvoScreen:new {
	id = "s_606",
	leftDialog = "@conversation/ep3_myyydril_patron_1:s_606", -- I believe you. Stay here while I put this away. I have something to tell you.
	stopConversation = "true",
	options = {}
}
ep3_myyydril_patron_1_convo:addScreen(ep3_myyydril_patron_1_convo_s_606)

ep3_myyydril_patron_1_convo_s_608 = ConvoScreen:new {
	id = "s_608",
	leftDialog = "@conversation/ep3_myyydril_patron_1:s_608", -- You're back so soon. Were you able to find my jewelry box?
	stopConversation = "false",
	options = {
		{"@conversation/ep3_myyydril_patron_1:s_610", "s_612"},
	}
}
ep3_myyydril_patron_1_convo:addScreen(ep3_myyydril_patron_1_convo_s_608)

ep3_myyydril_patron_1_convo_s_612 = ConvoScreen:new {
	id = "s_612",
	leftDialog = "@conversation/ep3_myyydril_patron_1:s_612", -- I know. I just wish I could remember! Be sure to check around the crystal gardens and beyond. I don't think I had made it as far as the D...
	stopConversation = "false",
	options = {
		{"@conversation/ep3_myyydril_patron_1:s_614", "s_616"},
	}
}
ep3_myyydril_patron_1_convo:addScreen(ep3_myyydril_patron_1_convo_s_612)

ep3_myyydril_patron_1_convo_s_616 = ConvoScreen:new {
	id = "s_616",
	leftDialog = "@conversation/ep3_myyydril_patron_1:s_616", -- [Nawika nods and returns to her duties.]
	stopConversation = "true",
	options = {}
}
ep3_myyydril_patron_1_convo:addScreen(ep3_myyydril_patron_1_convo_s_616)

ep3_myyydril_patron_1_convo_s_620 = ConvoScreen:new {
	id = "s_620",
	leftDialog = "@conversation/ep3_myyydril_patron_1:s_620", -- [Nawika seems startled.] Who are you and what do you want?
	stopConversation = "false",
	options = {
		{"@conversation/ep3_myyydril_patron_1:s_624", "s_634"},
	}
}
ep3_myyydril_patron_1_convo:addScreen(ep3_myyydril_patron_1_convo_s_620)

ep3_myyydril_patron_1_convo_s_634 = ConvoScreen:new {
	id = "s_634",
	leftDialog = "@conversation/ep3_myyydril_patron_1:s_634", -- Oh. Well... I doubt you can help me with my problem. [Nawika shrugs.]
	stopConversation = "false",
	options = {
		{"@conversation/ep3_myyydril_patron_1:s_638", "s_642"},
	}
}
ep3_myyydril_patron_1_convo:addScreen(ep3_myyydril_patron_1_convo_s_634)

ep3_myyydril_patron_1_convo_s_642 = ConvoScreen:new {
	id = "s_642",
	leftDialog = "@conversation/ep3_myyydril_patron_1:s_642", -- You seem nice, I guess. Fine. Telling you can't hurt, can it? One of my most prized possessions, my grandmother's jewelry box, went missi...
	stopConversation = "false",
	options = {
		{"@conversation/ep3_myyydril_patron_1:s_646", "s_656"},
		{"@conversation/ep3_myyydril_patron_1:s_660", "s_664"},
	}
}
ep3_myyydril_patron_1_convo:addScreen(ep3_myyydril_patron_1_convo_s_642)

ep3_myyydril_patron_1_convo_s_656 = ConvoScreen:new {
	id = "s_656",
	leftDialog = "@conversation/ep3_myyydril_patron_1:s_656", -- I really hope you can find it. I was hoping to pass it on to my children. Good luck!
	stopConversation = "true",
	options = {}
}
ep3_myyydril_patron_1_convo:addScreen(ep3_myyydril_patron_1_convo_s_656)

ep3_myyydril_patron_1_convo_s_664 = ConvoScreen:new {
	id = "s_664",
	leftDialog = "@conversation/ep3_myyydril_patron_1:s_664", -- Suit yourself.
	stopConversation = "true",
	options = {}
}
ep3_myyydril_patron_1_convo:addScreen(ep3_myyydril_patron_1_convo_s_664)

ep3_myyydril_patron_1_convo_s_670 = ConvoScreen:new {
	id = "s_670",
	leftDialog = "@conversation/ep3_myyydril_patron_1:s_670", -- Rrwwoorr!
	stopConversation = "true",
	options = {}
}
ep3_myyydril_patron_1_convo:addScreen(ep3_myyydril_patron_1_convo_s_670)

addConversationTemplate("ep3_myyydril_patron_1_convo", ep3_myyydril_patron_1_convo)
