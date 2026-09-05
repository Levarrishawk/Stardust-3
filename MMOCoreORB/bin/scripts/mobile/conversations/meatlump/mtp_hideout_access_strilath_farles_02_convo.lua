-- mtp_hideout_access_strilath_farles_02
-- ruling 2026-09-04
-- Transcribed from the giver's java branches. Strings are shipped keys.
-- The journal row comes from the integration branch later; do not call the journal module.

mtp_hideout_access_strilath_farles_02_convo = ConvoTemplate:new {
	initialScreen = "s_28",
	templateType = "Lua",
	luaClassHandler = "mtp_hideout_access_strilath_farles_02_conv_handler",
	screens = {}
}

mtp_hideout_access_strilath_farles_02_convo_s_4 = ConvoScreen:new {
	id = "s_4",
	leftDialog = "@conversation/mtp_hideout_access_strilath_farles_02:s_4", -- 04_03 done
	stopConversation = true,
	options = {}
}
mtp_hideout_access_strilath_farles_02_convo:addScreen(mtp_hideout_access_strilath_farles_02_convo_s_4)

mtp_hideout_access_strilath_farles_02_convo_s_29 = ConvoScreen:new {
	id = "s_29",
	leftDialog = "@conversation/mtp_hideout_access_strilath_farles_02:s_29", -- 04_03 active
	stopConversation = false,
	options = {
		{"@conversation/mtp_hideout_access_strilath_farles_02:s_47", "s_48"},
	}
}
mtp_hideout_access_strilath_farles_02_convo:addScreen(mtp_hideout_access_strilath_farles_02_convo_s_29)

mtp_hideout_access_strilath_farles_02_convo_s_48 = ConvoScreen:new {
	id = "s_48",
	leftDialog = "@conversation/mtp_hideout_access_strilath_farles_02:s_48",
	stopConversation = false,
	options = {
		{"@conversation/mtp_hideout_access_strilath_farles_02:s_9", "s_11"},
	}
}
mtp_hideout_access_strilath_farles_02_convo:addScreen(mtp_hideout_access_strilath_farles_02_convo_s_48)

mtp_hideout_access_strilath_farles_02_convo_s_11 = ConvoScreen:new {
	id = "s_11",
	leftDialog = "@conversation/mtp_hideout_access_strilath_farles_02:s_11",
	stopConversation = false,
	options = {
		{"@conversation/mtp_hideout_access_strilath_farles_02:s_13", "s_15"},
	}
}
mtp_hideout_access_strilath_farles_02_convo:addScreen(mtp_hideout_access_strilath_farles_02_convo_s_11)

mtp_hideout_access_strilath_farles_02_convo_s_15 = ConvoScreen:new {
	id = "s_15",
	leftDialog = "@conversation/mtp_hideout_access_strilath_farles_02:s_15",
	stopConversation = false,
	options = {
		{"@conversation/mtp_hideout_access_strilath_farles_02:s_17", "s_19"},
		{"@conversation/mtp_hideout_access_strilath_farles_02:s_21", "s_23"},
	}
}
mtp_hideout_access_strilath_farles_02_convo:addScreen(mtp_hideout_access_strilath_farles_02_convo_s_15)

mtp_hideout_access_strilath_farles_02_convo_s_19 = ConvoScreen:new {
	id = "s_19",
	leftDialog = "@conversation/mtp_hideout_access_strilath_farles_02:s_19", -- smoke / leave
	stopConversation = true,
	options = {}
}
mtp_hideout_access_strilath_farles_02_convo:addScreen(mtp_hideout_access_strilath_farles_02_convo_s_19)

mtp_hideout_access_strilath_farles_02_convo_s_23 = ConvoScreen:new {
	id = "s_23",
	leftDialog = "@conversation/mtp_hideout_access_strilath_farles_02:s_23", -- smoke / leave
	stopConversation = true,
	options = {}
}
mtp_hideout_access_strilath_farles_02_convo:addScreen(mtp_hideout_access_strilath_farles_02_convo_s_23)

mtp_hideout_access_strilath_farles_02_convo_s_25 = ConvoScreen:new {
	id = "s_25",
	leftDialog = "@conversation/mtp_hideout_access_strilath_farles_02:s_25", -- needs 04 / pointer regrant
	stopConversation = true,
	options = {}
}
mtp_hideout_access_strilath_farles_02_convo:addScreen(mtp_hideout_access_strilath_farles_02_convo_s_25)

mtp_hideout_access_strilath_farles_02_convo_s_28 = ConvoScreen:new {
	id = "s_28",
	leftDialog = "@conversation/mtp_hideout_access_strilath_farles_02:s_28", -- default
	stopConversation = true,
	options = {}
}
mtp_hideout_access_strilath_farles_02_convo:addScreen(mtp_hideout_access_strilath_farles_02_convo_s_28)

addConversationTemplate("mtp_hideout_access_strilath_farles_02_convo", mtp_hideout_access_strilath_farles_02_convo)
