-- ep3_myyydril_lorn
-- ruling 2026-09-04
-- Transcribed from the giver's java branches. Strings are shipped keys.
-- The journal row for quest/ep3_myyydril_*.qst comes from the integration branch later; do not call the journal API.

ep3_myyydril_lorn_convo = ConvoTemplate:new {
	initialScreen = "s_54",
	templateType = "Lua",
	luaClassHandler = "ep3_myyydril_lorn_conv_handler",
	screens = {}
}

ep3_myyydril_lorn_convo_s_11 = ConvoScreen:new {
	id = "s_11",
	leftDialog = "@conversation/ep3_myyydril_lorn:s_11", -- [Lorn hisses.] No more talking! [Lorn turns away, whispering.] .. for you, my master! For you!
	stopConversation = "true",
	options = {}
}
ep3_myyydril_lorn_convo:addScreen(ep3_myyydril_lorn_convo_s_11)

ep3_myyydril_lorn_convo_s_54 = ConvoScreen:new {
	id = "s_54",
	leftDialog = "@conversation/ep3_myyydril_lorn:s_54", -- My crystal? My crystal?! Do you have it..?
	stopConversation = "false",
	options = {
		{"@conversation/ep3_myyydril_lorn:s_56", "s_58"},
		{"@conversation/ep3_myyydril_lorn:s_68", "s_70"},
	}
}
ep3_myyydril_lorn_convo:addScreen(ep3_myyydril_lorn_convo_s_54)

ep3_myyydril_lorn_convo_s_58 = ConvoScreen:new {
	id = "s_58",
	leftDialog = "@conversation/ep3_myyydril_lorn:s_58", -- My crystal! [Lorn takes it in his hands.] ... for you alone, my master. For you!
	stopConversation = "false",
	options = {
		{"@conversation/ep3_myyydril_lorn:s_60", "s_62"},
	}
}
ep3_myyydril_lorn_convo:addScreen(ep3_myyydril_lorn_convo_s_58)

ep3_myyydril_lorn_convo_s_62 = ConvoScreen:new {
	id = "s_62",
	leftDialog = "@conversation/ep3_myyydril_lorn:s_62", -- [Lorn points to the lifeless form.] My master. I have named him N-K 'Necrosis'. I must awaken him. I have spent many years trying to wake...
	stopConversation = "false",
	options = {
		{"@conversation/ep3_myyydril_lorn:s_64", "s_66"},
	}
}
ep3_myyydril_lorn_convo:addScreen(ep3_myyydril_lorn_convo_s_62)

ep3_myyydril_lorn_convo_s_66 = ConvoScreen:new {
	id = "s_66",
	leftDialog = "@conversation/ep3_myyydril_lorn:s_66", -- [Lorn hisses.] No more talking! [Lorn turns away, whispering.] .. for you, my master! For you!
	stopConversation = "true",
	options = {}
}
ep3_myyydril_lorn_convo:addScreen(ep3_myyydril_lorn_convo_s_66)

ep3_myyydril_lorn_convo_s_70 = ConvoScreen:new {
	id = "s_70",
	leftDialog = "@conversation/ep3_myyydril_lorn:s_70", -- Why do you waste my time! Away with you! I would have my opus if you would only bring me my crystal!
	stopConversation = "true",
	options = {}
}
ep3_myyydril_lorn_convo:addScreen(ep3_myyydril_lorn_convo_s_70)

addConversationTemplate("ep3_myyydril_lorn_convo", ep3_myyydril_lorn_convo)
