-- mtp_hideout_access_crate_breaker
-- ruling 2026-09-04
-- Transcribed from the giver's java branches. Strings are shipped keys.
-- The journal row comes from the integration branch later; do not call the journal module.

mtp_hideout_access_crate_breaker_convo = ConvoTemplate:new {
	initialScreen = "s_28",
	templateType = "Lua",
	luaClassHandler = "mtp_hideout_access_crate_breaker_conv_handler",
	screens = {}
}

mtp_hideout_access_crate_breaker_convo_s_4 = ConvoScreen:new {
	id = "s_4",
	leftDialog = "@conversation/mtp_hideout_access_crate_breaker:s_4", -- 01_06 active
	stopConversation = false,
	options = {
		{"@conversation/mtp_hideout_access_crate_breaker:s_18", "s_20"},
		{"@conversation/mtp_hideout_access_crate_breaker:s_11", "s_13"},
	}
}
mtp_hideout_access_crate_breaker_convo:addScreen(mtp_hideout_access_crate_breaker_convo_s_4)

mtp_hideout_access_crate_breaker_convo_s_20 = ConvoScreen:new {
	id = "s_20",
	leftDialog = "@conversation/mtp_hideout_access_crate_breaker:s_20",
	stopConversation = false,
	options = {
		{"@conversation/mtp_hideout_access_crate_breaker:s_22", "s_24"},
	}
}
mtp_hideout_access_crate_breaker_convo:addScreen(mtp_hideout_access_crate_breaker_convo_s_20)

mtp_hideout_access_crate_breaker_convo_s_24 = ConvoScreen:new {
	id = "s_24",
	leftDialog = "@conversation/mtp_hideout_access_crate_breaker:s_24",
	stopConversation = false,
	options = {
		{"@conversation/mtp_hideout_access_crate_breaker:s_26", "s_13"},
	}
}
mtp_hideout_access_crate_breaker_convo:addScreen(mtp_hideout_access_crate_breaker_convo_s_24)

mtp_hideout_access_crate_breaker_convo_s_13 = ConvoScreen:new {
	id = "s_13",
	animation = "point_accusingly",
	leftDialog = "@conversation/mtp_hideout_access_crate_breaker:s_13",
	stopConversation = false,
	options = {
		{"@conversation/mtp_hideout_access_crate_breaker:s_15", "s_17"},
	}
}
mtp_hideout_access_crate_breaker_convo:addScreen(mtp_hideout_access_crate_breaker_convo_s_13)

mtp_hideout_access_crate_breaker_convo_s_17 = ConvoScreen:new {
	id = "s_17",
	animation = "laugh_cackle",
	leftDialog = "@conversation/mtp_hideout_access_crate_breaker:s_17",
	stopConversation = false,
	options = {
		{"@conversation/mtp_hideout_access_crate_breaker:s_21", "s_25"},
	}
}
mtp_hideout_access_crate_breaker_convo:addScreen(mtp_hideout_access_crate_breaker_convo_s_17)

mtp_hideout_access_crate_breaker_convo_s_25 = ConvoScreen:new {
	id = "s_25",
	leftDialog = "@conversation/mtp_hideout_access_crate_breaker:s_25", -- attack
	stopConversation = true,
	options = {}
}
mtp_hideout_access_crate_breaker_convo:addScreen(mtp_hideout_access_crate_breaker_convo_s_25)

mtp_hideout_access_crate_breaker_convo_s_28 = ConvoScreen:new {
	id = "s_28",
	leftDialog = "@conversation/mtp_hideout_access_crate_breaker:s_28", -- default
	stopConversation = true,
	options = {}
}
mtp_hideout_access_crate_breaker_convo:addScreen(mtp_hideout_access_crate_breaker_convo_s_28)

addConversationTemplate("mtp_hideout_access_crate_breaker_convo", mtp_hideout_access_crate_breaker_convo)
