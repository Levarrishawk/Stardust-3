-- mtp_meatlump_king
-- ruling 2026-09-04

mtp_meatlump_king_convo = ConvoTemplate:new {
	initialScreen = "s_25",
	templateType = "Lua",
	luaClassHandler = "mtp_meatlump_king_conv_handler",
	screens = {}
}

mtp_meatlump_king_convo_s_4 = ConvoScreen:new {
	id = "s_4",
	leftDialog = "@conversation/mtp_meatlump_king:s_4", -- grant king story (pointer done)
	stopConversation = false,
	options = {
		{"@conversation/mtp_meatlump_king:s_6", "s_8"},
	}
}
mtp_meatlump_king_convo:addScreen(mtp_meatlump_king_convo_s_4)

mtp_meatlump_king_convo_s_8 = ConvoScreen:new {
	id = "s_8",
	leftDialog = "@conversation/mtp_meatlump_king:s_8", -- how did you become king
	stopConversation = false,
	options = {
		{"@conversation/mtp_meatlump_king:s_11", "s_12"},
		{"@conversation/mtp_meatlump_king:s_14", "s_16"},
	}
}
mtp_meatlump_king_convo:addScreen(mtp_meatlump_king_convo_s_8)

mtp_meatlump_king_convo_s_12 = ConvoScreen:new {
	id = "s_12",
	leftDialog = "@conversation/mtp_meatlump_king:s_12", -- accept / make yourself at home
	stopConversation = true,
	options = {}
}
mtp_meatlump_king_convo:addScreen(mtp_meatlump_king_convo_s_12)

mtp_meatlump_king_convo_s_16 = ConvoScreen:new {
	id = "s_16",
	leftDialog = "@conversation/mtp_meatlump_king:s_16", -- decline / begone
	stopConversation = true,
	options = {}
}
mtp_meatlump_king_convo:addScreen(mtp_meatlump_king_convo_s_16)

mtp_meatlump_king_convo_s_43 = ConvoScreen:new {
	id = "s_43",
	leftDialog = "@conversation/mtp_meatlump_king:s_43", -- story active: sanctuary; offerings SUI
	stopConversation = true,
	options = {}
}
mtp_meatlump_king_convo:addScreen(mtp_meatlump_king_convo_s_43)

mtp_meatlump_king_convo_s_41 = ConvoScreen:new {
	id = "s_41",
	leftDialog = "@conversation/mtp_meatlump_king:s_41", -- story complete flavor
	stopConversation = true,
	options = {}
}
mtp_meatlump_king_convo:addScreen(mtp_meatlump_king_convo_s_41)

mtp_meatlump_king_convo_s_25 = ConvoScreen:new {
	id = "s_25",
	leftDialog = "@conversation/mtp_meatlump_king:s_25", -- default flavor
	stopConversation = true,
	options = {}
}
mtp_meatlump_king_convo:addScreen(mtp_meatlump_king_convo_s_25)

mtp_meatlump_king_convo_s_26 = ConvoScreen:new {
	id = "s_26",
	leftDialog = "@conversation/mtp_meatlump_king:s_26", -- default flavor
	stopConversation = true,
	options = {}
}
mtp_meatlump_king_convo:addScreen(mtp_meatlump_king_convo_s_26)

mtp_meatlump_king_convo_s_27 = ConvoScreen:new {
	id = "s_27",
	leftDialog = "@conversation/mtp_meatlump_king:s_27", -- default flavor
	stopConversation = true,
	options = {}
}
mtp_meatlump_king_convo:addScreen(mtp_meatlump_king_convo_s_27)

mtp_meatlump_king_convo_s_28 = ConvoScreen:new {
	id = "s_28",
	leftDialog = "@conversation/mtp_meatlump_king:s_28", -- default flavor
	stopConversation = true,
	options = {}
}
mtp_meatlump_king_convo:addScreen(mtp_meatlump_king_convo_s_28)

mtp_meatlump_king_convo_s_29 = ConvoScreen:new {
	id = "s_29",
	leftDialog = "@conversation/mtp_meatlump_king:s_29", -- default flavor
	stopConversation = true,
	options = {}
}
mtp_meatlump_king_convo:addScreen(mtp_meatlump_king_convo_s_29)

mtp_meatlump_king_convo_s_30 = ConvoScreen:new {
	id = "s_30",
	leftDialog = "@conversation/mtp_meatlump_king:s_30", -- default flavor
	stopConversation = true,
	options = {}
}
mtp_meatlump_king_convo:addScreen(mtp_meatlump_king_convo_s_30)

mtp_meatlump_king_convo_s_31 = ConvoScreen:new {
	id = "s_31",
	leftDialog = "@conversation/mtp_meatlump_king:s_31", -- default flavor
	stopConversation = true,
	options = {}
}
mtp_meatlump_king_convo:addScreen(mtp_meatlump_king_convo_s_31)

mtp_meatlump_king_convo_s_33 = ConvoScreen:new {
	id = "s_33",
	leftDialog = "@conversation/mtp_meatlump_king:s_33", -- default flavor
	stopConversation = true,
	options = {}
}
mtp_meatlump_king_convo:addScreen(mtp_meatlump_king_convo_s_33)

mtp_meatlump_king_convo_s_35 = ConvoScreen:new {
	id = "s_35",
	leftDialog = "@conversation/mtp_meatlump_king:s_35", -- default flavor
	stopConversation = true,
	options = {}
}
mtp_meatlump_king_convo:addScreen(mtp_meatlump_king_convo_s_35)

mtp_meatlump_king_convo_s_37 = ConvoScreen:new {
	id = "s_37",
	leftDialog = "@conversation/mtp_meatlump_king:s_37", -- default flavor
	stopConversation = true,
	options = {}
}
mtp_meatlump_king_convo:addScreen(mtp_meatlump_king_convo_s_37)

mtp_meatlump_king_convo_s_39 = ConvoScreen:new {
	id = "s_39",
	leftDialog = "@conversation/mtp_meatlump_king:s_39", -- default flavor
	stopConversation = true,
	options = {}
}
mtp_meatlump_king_convo:addScreen(mtp_meatlump_king_convo_s_39)

mtp_meatlump_king_convo_s_44 = ConvoScreen:new {
	id = "s_44",
	leftDialog = "@conversation/mtp_meatlump_king:s_44", -- default flavor
	stopConversation = true,
	options = {}
}
mtp_meatlump_king_convo:addScreen(mtp_meatlump_king_convo_s_44)

addConversationTemplate("mtp_meatlump_king_convo", mtp_meatlump_king_convo)
