-- mtp_hideout_access_lieutenant_kaiya
-- ruling 2026-09-04
-- Transcribed from the giver's java branches. Strings are shipped keys.
-- The journal row comes from the integration branch later; do not call the journal module.

mtp_hideout_access_lieutenant_kaiya_convo = ConvoTemplate:new {
	initialScreen = "s_48",
	templateType = "Lua",
	luaClassHandler = "mtp_hideout_access_lieutenant_kaiya_conv_handler",
	screens = {}
}

mtp_hideout_access_lieutenant_kaiya_convo_s_33 = ConvoScreen:new {
	id = "s_33",
	leftDialog = "@conversation/mtp_hideout_access_lieutenant_kaiya:s_33", -- done with kaiya
	stopConversation = true,
	options = {}
}
mtp_hideout_access_lieutenant_kaiya_convo:addScreen(mtp_hideout_access_lieutenant_kaiya_convo_s_33)

mtp_hideout_access_lieutenant_kaiya_convo_s_11 = ConvoScreen:new {
	id = "s_11",
	leftDialog = "@conversation/mtp_hideout_access_lieutenant_kaiya:s_11", -- return 07
	stopConversation = false,
	options = {
		{"@conversation/mtp_hideout_access_lieutenant_kaiya:s_27", "s_30"},
	}
}
mtp_hideout_access_lieutenant_kaiya_convo:addScreen(mtp_hideout_access_lieutenant_kaiya_convo_s_11)

mtp_hideout_access_lieutenant_kaiya_convo_s_30 = ConvoScreen:new {
	id = "s_30",
	leftDialog = "@conversation/mtp_hideout_access_lieutenant_kaiya:s_30",
	stopConversation = false,
	options = {
		{"@conversation/mtp_hideout_access_lieutenant_kaiya:s_31", "s_32"},
	}
}
mtp_hideout_access_lieutenant_kaiya_convo:addScreen(mtp_hideout_access_lieutenant_kaiya_convo_s_30)

mtp_hideout_access_lieutenant_kaiya_convo_s_32 = ConvoScreen:new {
	id = "s_32",
	leftDialog = "@conversation/mtp_hideout_access_lieutenant_kaiya:s_32", -- signal 07_03
	stopConversation = true,
	options = {}
}
mtp_hideout_access_lieutenant_kaiya_convo:addScreen(mtp_hideout_access_lieutenant_kaiya_convo_s_32)

mtp_hideout_access_lieutenant_kaiya_convo_s_10 = ConvoScreen:new {
	id = "s_10",
	leftDialog = "@conversation/mtp_hideout_access_lieutenant_kaiya:s_10", -- active 07
	stopConversation = true,
	options = {}
}
mtp_hideout_access_lieutenant_kaiya_convo:addScreen(mtp_hideout_access_lieutenant_kaiya_convo_s_10)

mtp_hideout_access_lieutenant_kaiya_convo_s_13 = ConvoScreen:new {
	id = "s_13",
	leftDialog = "@conversation/mtp_hideout_access_lieutenant_kaiya:s_13", -- return 06
	stopConversation = false,
	options = {
		{"@conversation/mtp_hideout_access_lieutenant_kaiya:s_19", "s_20"},
	}
}
mtp_hideout_access_lieutenant_kaiya_convo:addScreen(mtp_hideout_access_lieutenant_kaiya_convo_s_13)

mtp_hideout_access_lieutenant_kaiya_convo_s_20 = ConvoScreen:new {
	id = "s_20",
	leftDialog = "@conversation/mtp_hideout_access_lieutenant_kaiya:s_20",
	stopConversation = false,
	options = {
		{"@conversation/mtp_hideout_access_lieutenant_kaiya:s_21", "s_22"},
	}
}
mtp_hideout_access_lieutenant_kaiya_convo:addScreen(mtp_hideout_access_lieutenant_kaiya_convo_s_20)

mtp_hideout_access_lieutenant_kaiya_convo_s_22 = ConvoScreen:new {
	id = "s_22",
	leftDialog = "@conversation/mtp_hideout_access_lieutenant_kaiya:s_22",
	stopConversation = false,
	options = {
		{"@conversation/mtp_hideout_access_lieutenant_kaiya:s_25", "s_26"},
	}
}
mtp_hideout_access_lieutenant_kaiya_convo:addScreen(mtp_hideout_access_lieutenant_kaiya_convo_s_22)

mtp_hideout_access_lieutenant_kaiya_convo_s_26 = ConvoScreen:new {
	id = "s_26",
	leftDialog = "@conversation/mtp_hideout_access_lieutenant_kaiya:s_26", -- grant 07
	stopConversation = true,
	options = {}
}
mtp_hideout_access_lieutenant_kaiya_convo:addScreen(mtp_hideout_access_lieutenant_kaiya_convo_s_26)

mtp_hideout_access_lieutenant_kaiya_convo_s_28 = ConvoScreen:new {
	id = "s_28",
	leftDialog = "@conversation/mtp_hideout_access_lieutenant_kaiya:s_28", -- active 06
	stopConversation = true,
	options = {}
}
mtp_hideout_access_lieutenant_kaiya_convo:addScreen(mtp_hideout_access_lieutenant_kaiya_convo_s_28)

mtp_hideout_access_lieutenant_kaiya_convo_s_34 = ConvoScreen:new {
	id = "s_34",
	leftDialog = "@conversation/mtp_hideout_access_lieutenant_kaiya:s_34", -- 05_02
	stopConversation = false,
	options = {
		{"@conversation/mtp_hideout_access_lieutenant_kaiya:s_36", "s_38"},
	}
}
mtp_hideout_access_lieutenant_kaiya_convo:addScreen(mtp_hideout_access_lieutenant_kaiya_convo_s_34)

mtp_hideout_access_lieutenant_kaiya_convo_s_38 = ConvoScreen:new {
	id = "s_38",
	leftDialog = "@conversation/mtp_hideout_access_lieutenant_kaiya:s_38",
	stopConversation = false,
	options = {
		{"@conversation/mtp_hideout_access_lieutenant_kaiya:s_40", "s_42"},
	}
}
mtp_hideout_access_lieutenant_kaiya_convo:addScreen(mtp_hideout_access_lieutenant_kaiya_convo_s_38)

mtp_hideout_access_lieutenant_kaiya_convo_s_42 = ConvoScreen:new {
	id = "s_42",
	leftDialog = "@conversation/mtp_hideout_access_lieutenant_kaiya:s_42",
	stopConversation = false,
	options = {
		{"@conversation/mtp_hideout_access_lieutenant_kaiya:s_44", "s_46"},
	}
}
mtp_hideout_access_lieutenant_kaiya_convo:addScreen(mtp_hideout_access_lieutenant_kaiya_convo_s_42)

mtp_hideout_access_lieutenant_kaiya_convo_s_46 = ConvoScreen:new {
	id = "s_46",
	leftDialog = "@conversation/mtp_hideout_access_lieutenant_kaiya:s_46", -- grant 06
	stopConversation = true,
	options = {}
}
mtp_hideout_access_lieutenant_kaiya_convo:addScreen(mtp_hideout_access_lieutenant_kaiya_convo_s_46)

mtp_hideout_access_lieutenant_kaiya_convo_s_48 = ConvoScreen:new {
	id = "s_48",
	leftDialog = "@conversation/mtp_hideout_access_lieutenant_kaiya:s_48", -- default
	stopConversation = true,
	options = {}
}
mtp_hideout_access_lieutenant_kaiya_convo:addScreen(mtp_hideout_access_lieutenant_kaiya_convo_s_48)

addConversationTemplate("mtp_hideout_access_lieutenant_kaiya_convo", mtp_hideout_access_lieutenant_kaiya_convo)
