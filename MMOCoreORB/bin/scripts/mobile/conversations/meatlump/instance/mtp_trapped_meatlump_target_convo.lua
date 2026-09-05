-- mtp_trapped_meatlump_target
-- ruling 2026-09-04
-- Transcribed from the giver's java branches. Strings are shipped keys.
-- The journal row comes from the integration branch later; do not call the journal module.

mtp_trapped_meatlump_target_convo = ConvoTemplate:new {
	initialScreen = "s_16",
	templateType = "Lua",
	luaClassHandler = "mtp_trapped_meatlump_target_conv_handler",
	screens = {}
}

mtp_trapped_meatlump_target_convo_s_11 = ConvoScreen:new {
	id = "s_11",
	leftDialog = "@conversation/mtp_trapped_meatlump_target:s_11", -- help is it over
	stopConversation = false,
	options = {
		{"@conversation/mtp_trapped_meatlump_target:s_12", "s_13"},
		{"@conversation/mtp_trapped_meatlump_target:s_18", "s_20"},
	}
}
mtp_trapped_meatlump_target_convo:addScreen(mtp_trapped_meatlump_target_convo_s_11)

mtp_trapped_meatlump_target_convo_s_13 = ConvoScreen:new {
	id = "s_13",
	leftDialog = "@conversation/mtp_trapped_meatlump_target:s_13", -- follow me
	stopConversation = true,
	options = {}
}
mtp_trapped_meatlump_target_convo:addScreen(mtp_trapped_meatlump_target_convo_s_13)

mtp_trapped_meatlump_target_convo_s_20 = ConvoScreen:new {
	id = "s_20",
	leftDialog = "@conversation/mtp_trapped_meatlump_target:s_20", -- oh thank you
	stopConversation = false,
	options = {
		{"@conversation/mtp_trapped_meatlump_target:s_22", "s_24"},
		{"@conversation/mtp_trapped_meatlump_target:s_26", "s_28"},
	}
}
mtp_trapped_meatlump_target_convo:addScreen(mtp_trapped_meatlump_target_convo_s_20)

mtp_trapped_meatlump_target_convo_s_24 = ConvoScreen:new {
	id = "s_24",
	leftDialog = "@conversation/mtp_trapped_meatlump_target:s_24", -- will follow
	stopConversation = true,
	options = {}
}
mtp_trapped_meatlump_target_convo:addScreen(mtp_trapped_meatlump_target_convo_s_24)

mtp_trapped_meatlump_target_convo_s_28 = ConvoScreen:new {
	id = "s_28",
	leftDialog = "@conversation/mtp_trapped_meatlump_target:s_28", -- leave / cower
	stopConversation = true,
	options = {}
}
mtp_trapped_meatlump_target_convo:addScreen(mtp_trapped_meatlump_target_convo_s_28)

mtp_trapped_meatlump_target_convo_s_10 = ConvoScreen:new {
	id = "s_10",
	leftDialog = "@conversation/mtp_trapped_meatlump_target:s_10", -- already following
	stopConversation = true,
	options = {}
}
mtp_trapped_meatlump_target_convo:addScreen(mtp_trapped_meatlump_target_convo_s_10)

mtp_trapped_meatlump_target_convo_s_14 = ConvoScreen:new {
	id = "s_14",
	leftDialog = "@conversation/mtp_trapped_meatlump_target:s_14", -- too much violence
	stopConversation = true,
	options = {}
}
mtp_trapped_meatlump_target_convo:addScreen(mtp_trapped_meatlump_target_convo_s_14)

mtp_trapped_meatlump_target_convo_s_16 = ConvoScreen:new {
	id = "s_16",
	leftDialog = "@conversation/mtp_trapped_meatlump_target:s_16", -- stay away
	stopConversation = true,
	options = {}
}
mtp_trapped_meatlump_target_convo:addScreen(mtp_trapped_meatlump_target_convo_s_16)

addConversationTemplate("mtp_trapped_meatlump_target_convo", mtp_trapped_meatlump_target_convo)
