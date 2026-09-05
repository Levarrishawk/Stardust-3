-- mtp_hideout_access_strilath_farles_01
-- ruling 2026-09-04
-- Transcribed from the giver's java branches. Strings are shipped keys.
-- The journal row comes from the integration branch later; do not call the journal module.

mtp_hideout_access_strilath_farles_01_convo = ConvoTemplate:new {
	initialScreen = "s_28",
	templateType = "Lua",
	luaClassHandler = "mtp_hideout_access_strilath_farles_01_conv_handler",
	screens = {}
}

mtp_hideout_access_strilath_farles_01_convo_s_4 = ConvoScreen:new {
	id = "s_4",
	leftDialog = "@conversation/mtp_hideout_access_strilath_farles_01:s_4", -- 04 already granted / regrant
	stopConversation = true,
	options = {}
}
mtp_hideout_access_strilath_farles_01_convo:addScreen(mtp_hideout_access_strilath_farles_01_convo_s_4)

mtp_hideout_access_strilath_farles_01_convo_s_29 = ConvoScreen:new {
	id = "s_29",
	leftDialog = "@conversation/mtp_hideout_access_strilath_farles_01:s_29", -- 03_04 active
	stopConversation = false,
	options = {
		{"@conversation/mtp_hideout_access_strilath_farles_01:s_23", "s_24"},
	}
}
mtp_hideout_access_strilath_farles_01_convo:addScreen(mtp_hideout_access_strilath_farles_01_convo_s_29)

mtp_hideout_access_strilath_farles_01_convo_s_24 = ConvoScreen:new {
	id = "s_24",
	leftDialog = "@conversation/mtp_hideout_access_strilath_farles_01:s_24",
	stopConversation = false,
	options = {
		{"@conversation/mtp_hideout_access_strilath_farles_01:s_25", "s_26"},
	}
}
mtp_hideout_access_strilath_farles_01_convo:addScreen(mtp_hideout_access_strilath_farles_01_convo_s_24)

mtp_hideout_access_strilath_farles_01_convo_s_26 = ConvoScreen:new {
	id = "s_26",
	leftDialog = "@conversation/mtp_hideout_access_strilath_farles_01:s_26",
	stopConversation = false,
	options = {
		{"@conversation/mtp_hideout_access_strilath_farles_01:s_27", "s_46"},
	}
}
mtp_hideout_access_strilath_farles_01_convo:addScreen(mtp_hideout_access_strilath_farles_01_convo_s_26)

mtp_hideout_access_strilath_farles_01_convo_s_46 = ConvoScreen:new {
	id = "s_46",
	leftDialog = "@conversation/mtp_hideout_access_strilath_farles_01:s_46", -- grant 04
	stopConversation = true,
	options = {}
}
mtp_hideout_access_strilath_farles_01_convo:addScreen(mtp_hideout_access_strilath_farles_01_convo_s_46)

mtp_hideout_access_strilath_farles_01_convo_s_28 = ConvoScreen:new {
	id = "s_28",
	leftDialog = "@conversation/mtp_hideout_access_strilath_farles_01:s_28", -- default
	stopConversation = true,
	options = {}
}
mtp_hideout_access_strilath_farles_01_convo:addScreen(mtp_hideout_access_strilath_farles_01_convo_s_28)

addConversationTemplate("mtp_hideout_access_strilath_farles_01_convo", mtp_hideout_access_strilath_farles_01_convo)
