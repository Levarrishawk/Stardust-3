-- mtp_meatlumps_supplies_giver
-- ruling 2026-09-04
-- Transcribed from the giver's java branches. Strings are shipped keys.
-- The journal row comes from the integration branch later; do not call the journal module.

mtp_meatlumps_supplies_giver_convo = ConvoTemplate:new {
	initialScreen = "s_11",
	templateType = "Lua",
	luaClassHandler = "mtp_meatlumps_supplies_giver_conv_handler",
	screens = {}
}

mtp_meatlumps_supplies_giver_convo_s_4 = ConvoScreen:new {
	id = "s_4",
	leftDialog = "@conversation/mtp_meatlumps_supplies_giver:s_4", -- These supplies will really help! Thank you!!
	stopConversation = true,
	options = {}
}
mtp_meatlumps_supplies_giver_convo:addScreen(mtp_meatlumps_supplies_giver_convo_s_4)

mtp_meatlumps_supplies_giver_convo_s_19 = ConvoScreen:new {
	id = "s_19",
	leftDialog = "@conversation/mtp_meatlumps_supplies_giver:s_19", -- Could find all of the supplies before having to clear out? W
	stopConversation = true,
	options = {}
}
mtp_meatlumps_supplies_giver_convo:addScreen(mtp_meatlumps_supplies_giver_convo_s_19)

mtp_meatlumps_supplies_giver_convo_s_7 = ConvoScreen:new {
	id = "s_7",
	leftDialog = "@conversation/mtp_meatlumps_supplies_giver:s_7", -- We really need those supplies.
	stopConversation = true,
	options = {}
}
mtp_meatlumps_supplies_giver_convo:addScreen(mtp_meatlumps_supplies_giver_convo_s_7)

mtp_meatlumps_supplies_giver_convo_s_9 = ConvoScreen:new {
	id = "s_9",
	leftDialog = "@conversation/mtp_meatlumps_supplies_giver:s_9", -- We're looking good at the moment, but ya never know when we 
	stopConversation = true,
	options = {}
}
mtp_meatlumps_supplies_giver_convo:addScreen(mtp_meatlumps_supplies_giver_convo_s_9)

mtp_meatlumps_supplies_giver_convo_s_11 = ConvoScreen:new {
	id = "s_11",
	leftDialog = "@conversation/mtp_meatlumps_supplies_giver:s_11", -- Can you help me recover some supplies we lost in the lower l
	stopConversation = false,
	options = {
		{"@conversation/mtp_meatlumps_supplies_giver:s_13", "s_15"},
		{"@conversation/mtp_meatlumps_supplies_giver:s_17", "s_20"},
	}
}
mtp_meatlumps_supplies_giver_convo:addScreen(mtp_meatlumps_supplies_giver_convo_s_11)

mtp_meatlumps_supplies_giver_convo_s_15 = ConvoScreen:new {
	id = "s_15",
	leftDialog = "@conversation/mtp_meatlumps_supplies_giver:s_15", -- Oh good. You'll have to be fast though. Security droids will
	stopConversation = true,
	options = {}
}
mtp_meatlumps_supplies_giver_convo:addScreen(mtp_meatlumps_supplies_giver_convo_s_15)

mtp_meatlumps_supplies_giver_convo_s_20 = ConvoScreen:new {
	id = "s_20",
	leftDialog = "@conversation/mtp_meatlumps_supplies_giver:s_20", -- Ah, okay. I think I get it. I'll find someone else.
	stopConversation = true,
	options = {}
}
mtp_meatlumps_supplies_giver_convo:addScreen(mtp_meatlumps_supplies_giver_convo_s_20)

addConversationTemplate("mtp_meatlumps_supplies_giver_convo", mtp_meatlumps_supplies_giver_convo)
