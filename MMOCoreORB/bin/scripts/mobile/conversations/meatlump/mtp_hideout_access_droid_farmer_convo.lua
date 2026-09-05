-- mtp_hideout_access_droid_farmer
-- ruling 2026-09-04
-- Transcribed from the giver's java branches. Strings are shipped keys.
-- The journal row comes from the integration branch later; do not call the journal module.

mtp_hideout_access_droid_farmer_convo = ConvoTemplate:new {
	initialScreen = "s_28",
	templateType = "Lua",
	luaClassHandler = "mtp_hideout_access_droid_farmer_conv_handler",
	screens = {}
}

mtp_hideout_access_droid_farmer_convo_s_4 = ConvoScreen:new {
	id = "s_4",
	leftDialog = "@conversation/mtp_hideout_access_droid_farmer:s_4", -- 02_03
	stopConversation = false,
	options = {
		{"@conversation/mtp_hideout_access_droid_farmer:s_36", "s_37"},
	}
}
mtp_hideout_access_droid_farmer_convo:addScreen(mtp_hideout_access_droid_farmer_convo_s_4)

mtp_hideout_access_droid_farmer_convo_s_37 = ConvoScreen:new {
	id = "s_37",
	leftDialog = "@conversation/mtp_hideout_access_droid_farmer:s_37",
	stopConversation = false,
	options = {
		{"@conversation/mtp_hideout_access_droid_farmer:s_38", "s_39"},
		{"@conversation/mtp_hideout_access_droid_farmer:s_40", "s_41"},
		{"@conversation/mtp_hideout_access_droid_farmer:s_44", "s_45"},
		{"@conversation/mtp_hideout_access_droid_farmer:s_42", "s_43"},
	}
}
mtp_hideout_access_droid_farmer_convo:addScreen(mtp_hideout_access_droid_farmer_convo_s_37)

mtp_hideout_access_droid_farmer_convo_s_39 = ConvoScreen:new {
	id = "s_39",
	leftDialog = "@conversation/mtp_hideout_access_droid_farmer:s_39", -- signal 02_03
	stopConversation = true,
	options = {}
}
mtp_hideout_access_droid_farmer_convo:addScreen(mtp_hideout_access_droid_farmer_convo_s_39)

mtp_hideout_access_droid_farmer_convo_s_41 = ConvoScreen:new {
	id = "s_41",
	leftDialog = "@conversation/mtp_hideout_access_droid_farmer:s_41", -- signal 02_03
	stopConversation = true,
	options = {}
}
mtp_hideout_access_droid_farmer_convo:addScreen(mtp_hideout_access_droid_farmer_convo_s_41)

mtp_hideout_access_droid_farmer_convo_s_45 = ConvoScreen:new {
	id = "s_45",
	leftDialog = "@conversation/mtp_hideout_access_droid_farmer:s_45", -- signal 02_03
	stopConversation = true,
	options = {}
}
mtp_hideout_access_droid_farmer_convo:addScreen(mtp_hideout_access_droid_farmer_convo_s_45)

mtp_hideout_access_droid_farmer_convo_s_43 = ConvoScreen:new {
	id = "s_43",
	leftDialog = "@conversation/mtp_hideout_access_droid_farmer:s_43", -- signal 02_03
	stopConversation = true,
	options = {}
}
mtp_hideout_access_droid_farmer_convo:addScreen(mtp_hideout_access_droid_farmer_convo_s_43)

mtp_hideout_access_droid_farmer_convo_s_29 = ConvoScreen:new {
	id = "s_29",
	leftDialog = "@conversation/mtp_hideout_access_droid_farmer:s_29", -- 02_01
	stopConversation = false,
	options = {
		{"@conversation/mtp_hideout_access_droid_farmer:s_30", "s_31"},
	}
}
mtp_hideout_access_droid_farmer_convo:addScreen(mtp_hideout_access_droid_farmer_convo_s_29)

mtp_hideout_access_droid_farmer_convo_s_31 = ConvoScreen:new {
	id = "s_31",
	leftDialog = "@conversation/mtp_hideout_access_droid_farmer:s_31",
	stopConversation = false,
	options = {
		{"@conversation/mtp_hideout_access_droid_farmer:s_32", "s_33"},
	}
}
mtp_hideout_access_droid_farmer_convo:addScreen(mtp_hideout_access_droid_farmer_convo_s_31)

mtp_hideout_access_droid_farmer_convo_s_33 = ConvoScreen:new {
	id = "s_33",
	leftDialog = "@conversation/mtp_hideout_access_droid_farmer:s_33",
	stopConversation = false,
	options = {
		{"@conversation/mtp_hideout_access_droid_farmer:s_34", "s_35"},
	}
}
mtp_hideout_access_droid_farmer_convo:addScreen(mtp_hideout_access_droid_farmer_convo_s_33)

mtp_hideout_access_droid_farmer_convo_s_35 = ConvoScreen:new {
	id = "s_35",
	leftDialog = "@conversation/mtp_hideout_access_droid_farmer:s_35", -- signal 02_01
	stopConversation = true,
	options = {}
}
mtp_hideout_access_droid_farmer_convo:addScreen(mtp_hideout_access_droid_farmer_convo_s_35)

mtp_hideout_access_droid_farmer_convo_s_28 = ConvoScreen:new {
	id = "s_28",
	leftDialog = "@conversation/mtp_hideout_access_droid_farmer:s_28", -- default
	stopConversation = true,
	options = {}
}
mtp_hideout_access_droid_farmer_convo:addScreen(mtp_hideout_access_droid_farmer_convo_s_28)

addConversationTemplate("mtp_hideout_access_droid_farmer_convo", mtp_hideout_access_droid_farmer_convo)
