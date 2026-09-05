-- mtp_destroy_some_droids_giver
-- ruling 2026-09-04
-- Transcribed from the giver's java branches. Strings are shipped keys.
-- The journal row comes from the integration branch later; do not call the journal module.

mtp_destroy_some_droids_giver_convo = ConvoTemplate:new {
	initialScreen = "s_11",
	templateType = "Lua",
	luaClassHandler = "mtp_destroy_some_droids_giver_conv_handler",
	screens = {}
}

mtp_destroy_some_droids_giver_convo_s_4 = ConvoScreen:new {
	id = "s_4",
	leftDialog = "@conversation/mtp_destroy_some_droids_giver:s_4", -- You got rid of all those droids? What a relief! Thank you!!
	stopConversation = true,
	options = {}
}
mtp_destroy_some_droids_giver_convo:addScreen(mtp_destroy_some_droids_giver_convo_s_4)

mtp_destroy_some_droids_giver_convo_s_19 = ConvoScreen:new {
	id = "s_19",
	leftDialog = "@conversation/mtp_destroy_some_droids_giver:s_19", -- Couldn't manage it? Don't worry. Not many Meatlumps can mana
	stopConversation = true,
	options = {}
}
mtp_destroy_some_droids_giver_convo:addScreen(mtp_destroy_some_droids_giver_convo_s_19)

mtp_destroy_some_droids_giver_convo_s_7 = ConvoScreen:new {
	id = "s_7",
	leftDialog = "@conversation/mtp_destroy_some_droids_giver:s_7", -- Go get rid of those droids. The lower levels are full of the
	stopConversation = true,
	options = {}
}
mtp_destroy_some_droids_giver_convo:addScreen(mtp_destroy_some_droids_giver_convo_s_7)

mtp_destroy_some_droids_giver_convo_s_9 = ConvoScreen:new {
	id = "s_9",
	leftDialog = "@conversation/mtp_destroy_some_droids_giver:s_9", -- It's not yet safe to go back and get rid of more droids. The
	stopConversation = true,
	options = {}
}
mtp_destroy_some_droids_giver_convo:addScreen(mtp_destroy_some_droids_giver_convo_s_9)

mtp_destroy_some_droids_giver_convo_s_11 = ConvoScreen:new {
	id = "s_11",
	leftDialog = "@conversation/mtp_destroy_some_droids_giver:s_11", -- Can you help me? The lower maintenance areas are full of dro
	stopConversation = false,
	options = {
		{"@conversation/mtp_destroy_some_droids_giver:s_13", "s_15"},
		{"@conversation/mtp_destroy_some_droids_giver:s_17", "s_20"},
	}
}
mtp_destroy_some_droids_giver_convo:addScreen(mtp_destroy_some_droids_giver_convo_s_11)

mtp_destroy_some_droids_giver_convo_s_15 = ConvoScreen:new {
	id = "s_15",
	leftDialog = "@conversation/mtp_destroy_some_droids_giver:s_15", -- Oh good. You'll have to be fast though. You'll only have abo
	stopConversation = true,
	options = {}
}
mtp_destroy_some_droids_giver_convo:addScreen(mtp_destroy_some_droids_giver_convo_s_15)

mtp_destroy_some_droids_giver_convo_s_20 = ConvoScreen:new {
	id = "s_20",
	leftDialog = "@conversation/mtp_destroy_some_droids_giver:s_20", -- I understand. If you're looking for something else to do, yo
	stopConversation = true,
	options = {}
}
mtp_destroy_some_droids_giver_convo:addScreen(mtp_destroy_some_droids_giver_convo_s_20)

addConversationTemplate("mtp_destroy_some_droids_giver_convo", mtp_destroy_some_droids_giver_convo)
