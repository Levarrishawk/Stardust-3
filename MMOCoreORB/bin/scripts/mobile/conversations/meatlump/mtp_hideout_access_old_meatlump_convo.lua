-- mtp_hideout_access_old_meatlump
-- ruling 2026-09-04
-- Transcribed from the giver's java branches. Strings are shipped keys.
-- The journal row comes from the integration branch later; do not call the journal module.

mtp_hideout_access_old_meatlump_convo = ConvoTemplate:new {
	initialScreen = "s_28",
	templateType = "Lua",
	luaClassHandler = "mtp_hideout_access_old_meatlump_conv_handler",
	screens = {}
}

mtp_hideout_access_old_meatlump_convo_s_4 = ConvoScreen:new {
	id = "s_4",
	leftDialog = "@conversation/mtp_hideout_access_old_meatlump:s_4", -- 05_01 done
	stopConversation = true,
	options = {}
}
mtp_hideout_access_old_meatlump_convo:addScreen(mtp_hideout_access_old_meatlump_convo_s_4)

mtp_hideout_access_old_meatlump_convo_s_29 = ConvoScreen:new {
	id = "s_29",
	leftDialog = "@conversation/mtp_hideout_access_old_meatlump:s_29", -- 05_01 active
	stopConversation = false,
	options = {
		{"@conversation/mtp_hideout_access_old_meatlump:s_23", "s_24"},
	}
}
mtp_hideout_access_old_meatlump_convo:addScreen(mtp_hideout_access_old_meatlump_convo_s_29)

mtp_hideout_access_old_meatlump_convo_s_24 = ConvoScreen:new {
	id = "s_24",
	leftDialog = "@conversation/mtp_hideout_access_old_meatlump:s_24",
	stopConversation = false,
	options = {
		{"@conversation/mtp_hideout_access_old_meatlump:s_9", "s_11"},
	}
}
mtp_hideout_access_old_meatlump_convo:addScreen(mtp_hideout_access_old_meatlump_convo_s_24)

mtp_hideout_access_old_meatlump_convo_s_11 = ConvoScreen:new {
	id = "s_11",
	leftDialog = "@conversation/mtp_hideout_access_old_meatlump:s_11",
	stopConversation = false,
	options = {
		{"@conversation/mtp_hideout_access_old_meatlump:s_13", "s_15"},
	}
}
mtp_hideout_access_old_meatlump_convo:addScreen(mtp_hideout_access_old_meatlump_convo_s_11)

mtp_hideout_access_old_meatlump_convo_s_15 = ConvoScreen:new {
	id = "s_15",
	leftDialog = "@conversation/mtp_hideout_access_old_meatlump:s_15", -- signal 05_01
	stopConversation = true,
	options = {}
}
mtp_hideout_access_old_meatlump_convo:addScreen(mtp_hideout_access_old_meatlump_convo_s_15)

mtp_hideout_access_old_meatlump_convo_s_28 = ConvoScreen:new {
	id = "s_28",
	leftDialog = "@conversation/mtp_hideout_access_old_meatlump:s_28", -- default
	stopConversation = true,
	options = {}
}
mtp_hideout_access_old_meatlump_convo:addScreen(mtp_hideout_access_old_meatlump_convo_s_28)

addConversationTemplate("mtp_hideout_access_old_meatlump_convo", mtp_hideout_access_old_meatlump_convo)
