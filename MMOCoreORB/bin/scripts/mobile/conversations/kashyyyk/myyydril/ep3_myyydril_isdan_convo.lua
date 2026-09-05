-- ep3_myyydril_isdan
-- ruling 2026-09-04
-- Transcribed from the giver's java branches. Strings are shipped keys.
-- The journal row for quest/ep3_myyydril_*.qst comes from the integration branch later; do not call the journal API.

ep3_myyydril_isdan_convo = ConvoTemplate:new {
	initialScreen = "s_3864",
	templateType = "Lua",
	luaClassHandler = "ep3_myyydril_isdan_conv_handler",
	screens = {}
}

ep3_myyydril_isdan_convo_s_3850 = ConvoScreen:new {
	id = "s_3850",
	leftDialog = "@conversation/ep3_myyydril_isdan:s_3850", -- Why back? No more things to do.
	stopConversation = "false",
	options = {
		{"@conversation/ep3_myyydril_isdan:s_3852", "s_3854"},
	}
}
ep3_myyydril_isdan_convo:addScreen(ep3_myyydril_isdan_convo_s_3850)

ep3_myyydril_isdan_convo_s_3854 = ConvoScreen:new {
	id = "s_3854",
	leftDialog = "@conversation/ep3_myyydril_isdan:s_3854", -- Good stone. Keep safe.
	stopConversation = "true",
	options = {}
}
ep3_myyydril_isdan_convo:addScreen(ep3_myyydril_isdan_convo_s_3854)

ep3_myyydril_isdan_convo_s_3856 = ConvoScreen:new {
	id = "s_3856",
	leftDialog = "@conversation/ep3_myyydril_isdan:s_3856", -- You bring 10 stones back! Surprised. Here stone I promised.
	stopConversation = "false",
	options = {
		{"@conversation/ep3_myyydril_isdan:s_3858", "s_3860"},
	}
}
ep3_myyydril_isdan_convo:addScreen(ep3_myyydril_isdan_convo_s_3856)

ep3_myyydril_isdan_convo_s_3860 = ConvoScreen:new {
	id = "s_3860",
	leftDialog = "@conversation/ep3_myyydril_isdan:s_3860", -- Okay. Bye!
	stopConversation = "true",
	options = {}
}
ep3_myyydril_isdan_convo:addScreen(ep3_myyydril_isdan_convo_s_3860)

ep3_myyydril_isdan_convo_s_3862 = ConvoScreen:new {
	id = "s_3862",
	leftDialog = "@conversation/ep3_myyydril_isdan:s_3862", -- Why here? Find 10 stones at river. Give to me.
	stopConversation = "true",
	options = {}
}
ep3_myyydril_isdan_convo:addScreen(ep3_myyydril_isdan_convo_s_3862)

ep3_myyydril_isdan_convo_s_3864 = ConvoScreen:new {
	id = "s_3864",
	leftDialog = "@conversation/ep3_myyydril_isdan:s_3864", -- You want stone?
	stopConversation = "false",
	options = {
		{"@conversation/ep3_myyydril_isdan:s_3866", "s_3868"},
	}
}
ep3_myyydril_isdan_convo:addScreen(ep3_myyydril_isdan_convo_s_3864)

ep3_myyydril_isdan_convo_s_3868 = ConvoScreen:new {
	id = "s_3868",
	leftDialog = "@conversation/ep3_myyydril_isdan:s_3868", -- You want stone? [Isdan holds out his hands. In it you can see a smooth stone. The stone begins to glow eerily.]
	stopConversation = "false",
	options = {
		{"@conversation/ep3_myyydril_isdan:s_3870", "s_3872"},
	}
}
ep3_myyydril_isdan_convo:addScreen(ep3_myyydril_isdan_convo_s_3868)

ep3_myyydril_isdan_convo_s_3872 = ConvoScreen:new {
	id = "s_3872",
	leftDialog = "@conversation/ep3_myyydril_isdan:s_3872", -- Myyydril Cave vast. Want quick way out sometime? You want stone.
	stopConversation = "false",
	options = {
		{"@conversation/ep3_myyydril_isdan:s_3874", "s_3876"},
	}
}
ep3_myyydril_isdan_convo:addScreen(ep3_myyydril_isdan_convo_s_3872)

ep3_myyydril_isdan_convo_s_3876 = ConvoScreen:new {
	id = "s_3876",
	leftDialog = "@conversation/ep3_myyydril_isdan:s_3876", -- Where furry people live.
	stopConversation = "false",
	options = {
		{"@conversation/ep3_myyydril_isdan:s_3878", "s_3880"},
	}
}
ep3_myyydril_isdan_convo:addScreen(ep3_myyydril_isdan_convo_s_3876)

ep3_myyydril_isdan_convo_s_3880 = ConvoScreen:new {
	id = "s_3880",
	leftDialog = "@conversation/ep3_myyydril_isdan:s_3880", -- Furry man home city. Kachirho.
	stopConversation = "false",
	options = {
		{"@conversation/ep3_myyydril_isdan:s_3882", "s_3884"},
	}
}
ep3_myyydril_isdan_convo:addScreen(ep3_myyydril_isdan_convo_s_3880)

ep3_myyydril_isdan_convo_s_3884 = ConvoScreen:new {
	id = "s_3884",
	leftDialog = "@conversation/ep3_myyydril_isdan:s_3884", -- You do task for me. In river, there be stones. Get them. Um.. 10. Yes. Get 10 stones. Give to me.
	stopConversation = "false",
	options = {
		{"@conversation/ep3_myyydril_isdan:s_3886", "s_3888"},
	}
}
ep3_myyydril_isdan_convo:addScreen(ep3_myyydril_isdan_convo_s_3884)

ep3_myyydril_isdan_convo_s_3888 = ConvoScreen:new {
	id = "s_3888",
	leftDialog = "@conversation/ep3_myyydril_isdan:s_3888", -- Go now. Why wait?
	stopConversation = "true",
	options = {}
}
ep3_myyydril_isdan_convo:addScreen(ep3_myyydril_isdan_convo_s_3888)

addConversationTemplate("ep3_myyydril_isdan_convo", ep3_myyydril_isdan_convo)
