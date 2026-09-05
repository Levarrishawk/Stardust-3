-- mtp_hideout_access_crate_maker
-- ruling 2026-09-04
-- Transcribed from the giver's java branches. Strings are shipped keys.
-- The journal row comes from the integration branch later; do not call the journal module.

mtp_hideout_access_crate_maker_convo = ConvoTemplate:new {
	initialScreen = "s_26",
	templateType = "Lua",
	luaClassHandler = "mtp_hideout_access_crate_maker_conv_handler",
	screens = {}
}

mtp_hideout_access_crate_maker_convo_s_8 = ConvoScreen:new {
	id = "s_8",
	leftDialog = "@conversation/mtp_hideout_access_crate_maker:s_8", -- 01_07 active
	stopConversation = true,
	options = {}
}
mtp_hideout_access_crate_maker_convo:addScreen(mtp_hideout_access_crate_maker_convo_s_8)

mtp_hideout_access_crate_maker_convo_s_7 = ConvoScreen:new {
	id = "s_7",
	leftDialog = "@conversation/mtp_hideout_access_crate_maker:s_7", -- after bombs / before kill
	stopConversation = true,
	options = {}
}
mtp_hideout_access_crate_maker_convo:addScreen(mtp_hideout_access_crate_maker_convo_s_7)

mtp_hideout_access_crate_maker_convo_s_6 = ConvoScreen:new {
	id = "s_6",
	leftDialog = "@conversation/mtp_hideout_access_crate_maker:s_6", -- after datapad / before bombs done
	stopConversation = true,
	options = {}
}
mtp_hideout_access_crate_maker_convo:addScreen(mtp_hideout_access_crate_maker_convo_s_6)

mtp_hideout_access_crate_maker_convo_s_10 = ConvoScreen:new {
	id = "s_10",
	leftDialog = "@conversation/mtp_hideout_access_crate_maker:s_10", -- datapad active
	stopConversation = true,
	options = {}
}
mtp_hideout_access_crate_maker_convo:addScreen(mtp_hideout_access_crate_maker_convo_s_10)

mtp_hideout_access_crate_maker_convo_s_12 = ConvoScreen:new {
	id = "s_12",
	animation = "gesticulate_wildly",
	leftDialog = "@conversation/mtp_hideout_access_crate_maker:s_12", -- 01_01 active
	stopConversation = false,
	options = {
		{"@conversation/mtp_hideout_access_crate_maker:s_14", "s_16"},
	}
}
mtp_hideout_access_crate_maker_convo:addScreen(mtp_hideout_access_crate_maker_convo_s_12)

mtp_hideout_access_crate_maker_convo_s_16 = ConvoScreen:new {
	id = "s_16",
	leftDialog = "@conversation/mtp_hideout_access_crate_maker:s_16",
	stopConversation = false,
	options = {
		{"@conversation/mtp_hideout_access_crate_maker:s_18", "s_20"},
	}
}
mtp_hideout_access_crate_maker_convo:addScreen(mtp_hideout_access_crate_maker_convo_s_16)

mtp_hideout_access_crate_maker_convo_s_20 = ConvoScreen:new {
	id = "s_20",
	leftDialog = "@conversation/mtp_hideout_access_crate_maker:s_20",
	stopConversation = false,
	options = {
		{"@conversation/mtp_hideout_access_crate_maker:s_22", "s_24"},
	}
}
mtp_hideout_access_crate_maker_convo:addScreen(mtp_hideout_access_crate_maker_convo_s_20)

mtp_hideout_access_crate_maker_convo_s_24 = ConvoScreen:new {
	id = "s_24",
	leftDialog = "@conversation/mtp_hideout_access_crate_maker:s_24", -- signal 01_01
	stopConversation = true,
	options = {}
}
mtp_hideout_access_crate_maker_convo:addScreen(mtp_hideout_access_crate_maker_convo_s_24)

mtp_hideout_access_crate_maker_convo_s_26 = ConvoScreen:new {
	id = "s_26",
	leftDialog = "@conversation/mtp_hideout_access_crate_maker:s_26", -- default
	stopConversation = true,
	options = {}
}
mtp_hideout_access_crate_maker_convo:addScreen(mtp_hideout_access_crate_maker_convo_s_26)

addConversationTemplate("mtp_hideout_access_crate_maker_convo", mtp_hideout_access_crate_maker_convo)
