-- mtp_ragtag_ames_missd
-- ruling 2026-09-04

mtp_ragtag_ames_missd_convo = ConvoTemplate:new {
	initialScreen = "s_35",
	templateType = "Lua",
	luaClassHandler = "mtp_ragtag_ames_missd_conv_handler",
	screens = {}
}

mtp_ragtag_ames_missd_convo_s_6 = ConvoScreen:new {
	id = "s_6",
	leftDialog = "@conversation/mtp_ragtag_ames_missd:s_6", -- whatta you want
	stopConversation = false,
	options = {
		{"@conversation/mtp_ragtag_ames_missd:s_8", "s_54"},
	}
}
mtp_ragtag_ames_missd_convo:addScreen(mtp_ragtag_ames_missd_convo_s_6)

mtp_ragtag_ames_missd_convo_s_54 = ConvoScreen:new {
	id = "s_54",
	leftDialog = "@conversation/mtp_ragtag_ames_missd:s_54", -- beat up a friend
	stopConversation = false,
	options = {
		{"@conversation/mtp_ragtag_ames_missd:s_56", "s_62"},
	}
}
mtp_ragtag_ames_missd_convo:addScreen(mtp_ragtag_ames_missd_convo_s_54)

mtp_ragtag_ames_missd_convo_s_62 = ConvoScreen:new {
	id = "s_62",
	leftDialog = "@conversation/mtp_ragtag_ames_missd:s_62", -- signal fightAnita
	stopConversation = true,
	options = {}
}
mtp_ragtag_ames_missd_convo:addScreen(mtp_ragtag_ames_missd_convo_s_62)

mtp_ragtag_ames_missd_convo_s_72 = ConvoScreen:new {
	id = "s_72",
	leftDialog = "@conversation/mtp_ragtag_ames_missd:s_72", -- anita done
	stopConversation = false,
	options = {
		{"@conversation/mtp_ragtag_ames_missd:s_73", "s_74"},
	}
}
mtp_ragtag_ames_missd_convo:addScreen(mtp_ragtag_ames_missd_convo_s_72)

mtp_ragtag_ames_missd_convo_s_74 = ConvoScreen:new {
	id = "s_74",
	leftDialog = "@conversation/mtp_ragtag_ames_missd:s_74", -- signal fightBox
	stopConversation = true,
	options = {}
}
mtp_ragtag_ames_missd_convo:addScreen(mtp_ragtag_ames_missd_convo_s_74)

mtp_ragtag_ames_missd_convo_s_75 = ConvoScreen:new {
	id = "s_75",
	leftDialog = "@conversation/mtp_ragtag_ames_missd:s_75", -- box done
	stopConversation = false,
	options = {
		{"@conversation/mtp_ragtag_ames_missd:s_76", "s_77"},
	}
}
mtp_ragtag_ames_missd_convo:addScreen(mtp_ragtag_ames_missd_convo_s_75)

mtp_ragtag_ames_missd_convo_s_77 = ConvoScreen:new {
	id = "s_77",
	leftDialog = "@conversation/mtp_ragtag_ames_missd:s_77", -- signal spokenAmes
	stopConversation = true,
	options = {}
}
mtp_ragtag_ames_missd_convo:addScreen(mtp_ragtag_ames_missd_convo_s_77)

mtp_ragtag_ames_missd_convo_s_35 = ConvoScreen:new {
	id = "s_35",
	leftDialog = "@conversation/mtp_ragtag_ames_missd:s_35", -- default busy
	stopConversation = true,
	options = {}
}
mtp_ragtag_ames_missd_convo:addScreen(mtp_ragtag_ames_missd_convo_s_35)

addConversationTemplate("mtp_ragtag_ames_missd_convo", mtp_ragtag_ames_missd_convo)
