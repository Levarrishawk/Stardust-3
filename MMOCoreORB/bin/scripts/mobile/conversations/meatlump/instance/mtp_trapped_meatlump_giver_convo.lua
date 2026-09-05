-- mtp_trapped_meatlump_giver
-- ruling 2026-09-04
-- Transcribed from the giver's java branches. Strings are shipped keys.
-- The journal row comes from the integration branch later; do not call the journal module.

mtp_trapped_meatlump_giver_convo = ConvoTemplate:new {
	initialScreen = "s_11",
	templateType = "Lua",
	luaClassHandler = "mtp_trapped_meatlump_giver_conv_handler",
	screens = {}
}

mtp_trapped_meatlump_giver_convo_s_4 = ConvoScreen:new {
	id = "s_4",
	leftDialog = "@conversation/mtp_trapped_meatlump_giver:s_4", -- You rescued him! What a relief. Thank you!!
	stopConversation = true,
	options = {}
}
mtp_trapped_meatlump_giver_convo:addScreen(mtp_trapped_meatlump_giver_convo_s_4)

mtp_trapped_meatlump_giver_convo_s_19 = ConvoScreen:new {
	id = "s_19",
	leftDialog = "@conversation/mtp_trapped_meatlump_giver:s_19", -- Couldn't rescue him in time, eh? I knew security would be cl
	stopConversation = true,
	options = {}
}
mtp_trapped_meatlump_giver_convo:addScreen(mtp_trapped_meatlump_giver_convo_s_19)

mtp_trapped_meatlump_giver_convo_s_7 = ConvoScreen:new {
	id = "s_7",
	leftDialog = "@conversation/mtp_trapped_meatlump_giver:s_7", -- Go find that lost Meatlump. He's somewhere in the lower main
	stopConversation = true,
	options = {}
}
mtp_trapped_meatlump_giver_convo:addScreen(mtp_trapped_meatlump_giver_convo_s_7)

mtp_trapped_meatlump_giver_convo_s_9 = ConvoScreen:new {
	id = "s_9",
	leftDialog = "@conversation/mtp_trapped_meatlump_giver:s_9", -- No one else has gotten trapped lately, but it seems to happe
	stopConversation = true,
	options = {}
}
mtp_trapped_meatlump_giver_convo:addScreen(mtp_trapped_meatlump_giver_convo_s_9)

mtp_trapped_meatlump_giver_convo_s_11 = ConvoScreen:new {
	id = "s_11",
	leftDialog = "@conversation/mtp_trapped_meatlump_giver:s_11", -- Hey, hey! One of the Meatlumps never made it out of the lowe
	stopConversation = false,
	options = {
		{"@conversation/mtp_trapped_meatlump_giver:s_13", "s_15"},
		{"@conversation/mtp_trapped_meatlump_giver:s_17", "s_20"},
	}
}
mtp_trapped_meatlump_giver_convo:addScreen(mtp_trapped_meatlump_giver_convo_s_11)

mtp_trapped_meatlump_giver_convo_s_15 = ConvoScreen:new {
	id = "s_15",
	leftDialog = "@conversation/mtp_trapped_meatlump_giver:s_15", -- Oh good. You'll have to be fast, though. He's probably raise
	stopConversation = true,
	options = {}
}
mtp_trapped_meatlump_giver_convo:addScreen(mtp_trapped_meatlump_giver_convo_s_15)

mtp_trapped_meatlump_giver_convo_s_20 = ConvoScreen:new {
	id = "s_20",
	leftDialog = "@conversation/mtp_trapped_meatlump_giver:s_20", -- Yeah, we probably shouldn't risk anyone else getting lost do
	stopConversation = true,
	options = {}
}
mtp_trapped_meatlump_giver_convo:addScreen(mtp_trapped_meatlump_giver_convo_s_20)

addConversationTemplate("mtp_trapped_meatlump_giver_convo", mtp_trapped_meatlump_giver_convo)
