-- mtp_hideout_col_eavesdrop
-- ruling 2026-09-05

mtp_hideout_col_eavesdrop_convo = ConvoTemplate:new {
	initialScreen = "s_4",
	templateType = "Lua",
	luaClassHandler = "mtp_hideout_col_eavesdrop_conv_handler",
	screens = {}
}

mtp_hideout_col_eavesdrop_convo_s_4 = ConvoScreen:new {
	id = "s_4",
	leftDialog = "@conversation/mtp_hideout_col_eavesdrop:s_4",
	stopConversation = false,
	options = {}
}
mtp_hideout_col_eavesdrop_convo:addScreen(mtp_hideout_col_eavesdrop_convo_s_4)

mtp_hideout_col_eavesdrop_convo_s_27 = ConvoScreen:new {
	id = "s_27",
	leftDialog = "@conversation/mtp_hideout_col_eavesdrop:s_27",
	stopConversation = false,
	options = {
		{"@conversation/mtp_hideout_col_eavesdrop:s_28", "s_29"},
	}
}
mtp_hideout_col_eavesdrop_convo:addScreen(mtp_hideout_col_eavesdrop_convo_s_27)

mtp_hideout_col_eavesdrop_convo_s_29 = ConvoScreen:new {
	id = "s_29",
	leftDialog = "@conversation/mtp_hideout_col_eavesdrop:s_29",
	stopConversation = false,
	options = {
		{"@conversation/mtp_hideout_col_eavesdrop:s_31", "s_33"},
	}
}
mtp_hideout_col_eavesdrop_convo:addScreen(mtp_hideout_col_eavesdrop_convo_s_29)

mtp_hideout_col_eavesdrop_convo_s_33 = ConvoScreen:new {
	id = "s_33",
	leftDialog = "@conversation/mtp_hideout_col_eavesdrop:s_33",
	stopConversation = false,
	options = {
		{"@conversation/mtp_hideout_col_eavesdrop:s_34", "s_35"},
	}
}
mtp_hideout_col_eavesdrop_convo:addScreen(mtp_hideout_col_eavesdrop_convo_s_33)

mtp_hideout_col_eavesdrop_convo_s_35 = ConvoScreen:new {
	id = "s_35",
	leftDialog = "@conversation/mtp_hideout_col_eavesdrop:s_35",
	stopConversation = false,
	options = {
		{"@conversation/mtp_hideout_col_eavesdrop:s_36", "s_37"},
	}
}
mtp_hideout_col_eavesdrop_convo:addScreen(mtp_hideout_col_eavesdrop_convo_s_35)

mtp_hideout_col_eavesdrop_convo_s_37 = ConvoScreen:new {
	id = "s_37",
	leftDialog = "@conversation/mtp_hideout_col_eavesdrop:s_37",
	stopConversation = false,
	options = {
		{"@conversation/mtp_hideout_col_eavesdrop:s_38", "s_49"},
	}
}
mtp_hideout_col_eavesdrop_convo:addScreen(mtp_hideout_col_eavesdrop_convo_s_37)

mtp_hideout_col_eavesdrop_convo_s_49 = ConvoScreen:new {
	id = "s_49",
	leftDialog = "@conversation/mtp_hideout_col_eavesdrop:s_49",
	stopConversation = true,
	options = {}
}
mtp_hideout_col_eavesdrop_convo:addScreen(mtp_hideout_col_eavesdrop_convo_s_49)

mtp_hideout_col_eavesdrop_convo_s_41 = ConvoScreen:new {
	id = "s_41",
	leftDialog = "@conversation/mtp_hideout_col_eavesdrop:s_41",
	stopConversation = true,
	options = {}
}
mtp_hideout_col_eavesdrop_convo:addScreen(mtp_hideout_col_eavesdrop_convo_s_41)

mtp_hideout_col_eavesdrop_convo_s_43 = ConvoScreen:new {
	id = "s_43",
	leftDialog = "@conversation/mtp_hideout_col_eavesdrop:s_43",
	stopConversation = true,
	options = {}
}
mtp_hideout_col_eavesdrop_convo:addScreen(mtp_hideout_col_eavesdrop_convo_s_43)

mtp_hideout_col_eavesdrop_convo_s_45 = ConvoScreen:new {
	id = "s_45",
	leftDialog = "@conversation/mtp_hideout_col_eavesdrop:s_45",
	stopConversation = false,
	options = {
		{"@conversation/mtp_hideout_col_eavesdrop:s_46", "s_50"},
	}
}
mtp_hideout_col_eavesdrop_convo:addScreen(mtp_hideout_col_eavesdrop_convo_s_45)

mtp_hideout_col_eavesdrop_convo_s_50 = ConvoScreen:new {
	id = "s_50",
	leftDialog = "@conversation/mtp_hideout_col_eavesdrop:s_50",
	stopConversation = true,
	options = {}
}
mtp_hideout_col_eavesdrop_convo:addScreen(mtp_hideout_col_eavesdrop_convo_s_50)

mtp_hideout_col_eavesdrop_convo_s_51 = ConvoScreen:new {
	id = "s_51",
	leftDialog = "@conversation/mtp_hideout_col_eavesdrop:s_51",
	stopConversation = true,
	options = {}
}
mtp_hideout_col_eavesdrop_convo:addScreen(mtp_hideout_col_eavesdrop_convo_s_51)

addConversationTemplate("mtp_hideout_col_eavesdrop_convo", mtp_hideout_col_eavesdrop_convo)
