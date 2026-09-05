-- mtp_corsec_intelligence_officer
-- ruling 2026-09-04

mtp_corsec_intelligence_officer_convo = ConvoTemplate:new {
	initialScreen = "s_21",
	templateType = "Lua",
	luaClassHandler = "mtp_corsec_intelligence_officer_conv_handler",
	screens = {}
}

mtp_corsec_intelligence_officer_convo_s_3 = ConvoScreen:new {
	id = "s_3",
	leftDialog = "@conversation/mtp_corsec_intelligence_officer:s_3", -- OURS: grant intro if not started
	stopConversation = false,
	options = {
		{"@conversation/mtp_corsec_intelligence_officer:s_4", "s_5"},
	}
}
mtp_corsec_intelligence_officer_convo:addScreen(mtp_corsec_intelligence_officer_convo_s_3)

mtp_corsec_intelligence_officer_convo_s_5 = ConvoScreen:new {
	id = "s_5",
	leftDialog = "@conversation/mtp_corsec_intelligence_officer:s_5", -- chain
	stopConversation = false,
	options = {
		{"@conversation/mtp_corsec_intelligence_officer:s_6", "s_7"},
	}
}
mtp_corsec_intelligence_officer_convo:addScreen(mtp_corsec_intelligence_officer_convo_s_5)

mtp_corsec_intelligence_officer_convo_s_7 = ConvoScreen:new {
	id = "s_7",
	leftDialog = "@conversation/mtp_corsec_intelligence_officer:s_7", -- chain
	stopConversation = false,
	options = {
		{"@conversation/mtp_corsec_intelligence_officer:s_8", "s_9"},
	}
}
mtp_corsec_intelligence_officer_convo:addScreen(mtp_corsec_intelligence_officer_convo_s_7)

mtp_corsec_intelligence_officer_convo_s_9 = ConvoScreen:new {
	id = "s_9",
	leftDialog = "@conversation/mtp_corsec_intelligence_officer:s_9", -- chain
	stopConversation = false,
	options = {
		{"@conversation/mtp_corsec_intelligence_officer:s_10", "s_11"},
	}
}
mtp_corsec_intelligence_officer_convo:addScreen(mtp_corsec_intelligence_officer_convo_s_9)

mtp_corsec_intelligence_officer_convo_s_11 = ConvoScreen:new {
	id = "s_11",
	leftDialog = "@conversation/mtp_corsec_intelligence_officer:s_11", -- chain
	stopConversation = false,
	options = {
		{"@conversation/mtp_corsec_intelligence_officer:s_12", "s_13"},
	}
}
mtp_corsec_intelligence_officer_convo:addScreen(mtp_corsec_intelligence_officer_convo_s_11)

mtp_corsec_intelligence_officer_convo_s_13 = ConvoScreen:new {
	id = "s_13",
	leftDialog = "@conversation/mtp_corsec_intelligence_officer:s_13", -- chain
	stopConversation = false,
	options = {
		{"@conversation/mtp_corsec_intelligence_officer:s_14", "s_15"},
	}
}
mtp_corsec_intelligence_officer_convo:addScreen(mtp_corsec_intelligence_officer_convo_s_13)

mtp_corsec_intelligence_officer_convo_s_15 = ConvoScreen:new {
	id = "s_15",
	leftDialog = "@conversation/mtp_corsec_intelligence_officer:s_15", -- chain
	stopConversation = false,
	options = {
		{"@conversation/mtp_corsec_intelligence_officer:s_16", "s_17"},
	}
}
mtp_corsec_intelligence_officer_convo:addScreen(mtp_corsec_intelligence_officer_convo_s_15)

mtp_corsec_intelligence_officer_convo_s_17 = ConvoScreen:new {
	id = "s_17",
	leftDialog = "@conversation/mtp_corsec_intelligence_officer:s_17", -- OURS: signal met / grant safe OPEN
	stopConversation = true,
	options = {}
}
mtp_corsec_intelligence_officer_convo:addScreen(mtp_corsec_intelligence_officer_convo_s_17)

mtp_corsec_intelligence_officer_convo_s_19 = ConvoScreen:new {
	id = "s_19",
	leftDialog = "@conversation/mtp_corsec_intelligence_officer:s_19", -- already met
	stopConversation = true,
	options = {}
}
mtp_corsec_intelligence_officer_convo:addScreen(mtp_corsec_intelligence_officer_convo_s_19)

mtp_corsec_intelligence_officer_convo_s_21 = ConvoScreen:new {
	id = "s_21",
	leftDialog = "@conversation/mtp_corsec_intelligence_officer:s_21", -- default
	stopConversation = true,
	options = {}
}
mtp_corsec_intelligence_officer_convo:addScreen(mtp_corsec_intelligence_officer_convo_s_21)

addConversationTemplate("mtp_corsec_intelligence_officer_convo", mtp_corsec_intelligence_officer_convo)
