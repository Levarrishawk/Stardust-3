-- mtp_angry_meatlump_giver
-- ruling 2026-09-04
-- Transcribed from the giver's java branches. Strings are shipped keys.
-- The journal row comes from the integration branch later; do not call the journal module.

mtp_angry_meatlump_giver_convo = ConvoTemplate:new {
	initialScreen = "s_10",
	templateType = "Lua",
	luaClassHandler = "mtp_angry_meatlump_giver_conv_handler",
	screens = {}
}

mtp_angry_meatlump_giver_convo_s_4 = ConvoScreen:new {
	id = "s_4",
	leftDialog = "@conversation/mtp_angry_meatlump_giver:s_4", -- Wow, you actually did it. Thanks!
	stopConversation = true,
	options = {}
}
mtp_angry_meatlump_giver_convo:addScreen(mtp_angry_meatlump_giver_convo_s_4)

mtp_angry_meatlump_giver_convo_s_6 = ConvoScreen:new {
	id = "s_6",
	leftDialog = "@conversation/mtp_angry_meatlump_giver:s_6", -- Well, those angry Meatlumps won't cheer themselves up. What 
	stopConversation = true,
	options = {}
}
mtp_angry_meatlump_giver_convo:addScreen(mtp_angry_meatlump_giver_convo_s_6)

mtp_angry_meatlump_giver_convo_s_8 = ConvoScreen:new {
	id = "s_8",
	leftDialog = "@conversation/mtp_angry_meatlump_giver:s_8", -- Oh hi. Sorry, too many of the Meatlumps might still remember
	stopConversation = true,
	options = {}
}
mtp_angry_meatlump_giver_convo:addScreen(mtp_angry_meatlump_giver_convo_s_8)

mtp_angry_meatlump_giver_convo_s_10 = ConvoScreen:new {
	id = "s_10",
	leftDialog = "@conversation/mtp_angry_meatlump_giver:s_10", -- Can you do something for me? I've noticed some of the Meatlu
	stopConversation = false,
	options = {
		{"@conversation/mtp_angry_meatlump_giver:s_12", "s_14"},
		{"@conversation/mtp_angry_meatlump_giver:s_16", "s_18"},
	}
}
mtp_angry_meatlump_giver_convo:addScreen(mtp_angry_meatlump_giver_convo_s_10)

mtp_angry_meatlump_giver_convo_s_14 = ConvoScreen:new {
	id = "s_14",
	leftDialog = "@conversation/mtp_angry_meatlump_giver:s_14", -- Excellent. You'll find them throughout the hideout. They jus
	stopConversation = true,
	options = {}
}
mtp_angry_meatlump_giver_convo:addScreen(mtp_angry_meatlump_giver_convo_s_14)

mtp_angry_meatlump_giver_convo_s_18 = ConvoScreen:new {
	id = "s_18",
	leftDialog = "@conversation/mtp_angry_meatlump_giver:s_18", -- Well now I think I might be angry...
	stopConversation = true,
	options = {}
}
mtp_angry_meatlump_giver_convo:addScreen(mtp_angry_meatlump_giver_convo_s_18)

addConversationTemplate("mtp_angry_meatlump_giver_convo", mtp_angry_meatlump_giver_convo)
