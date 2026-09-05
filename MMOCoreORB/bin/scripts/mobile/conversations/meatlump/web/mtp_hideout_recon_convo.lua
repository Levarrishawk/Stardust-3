-- mtp_hideout_recon
-- ruling 2026-09-04

mtp_hideout_recon_convo = ConvoTemplate:new {
	initialScreen = "s_8",
	templateType = "Lua",
	luaClassHandler = "mtp_hideout_recon_conv_handler",
	screens = {}
}

mtp_hideout_recon_convo_s_8 = ConvoScreen:new {
	id = "s_8",
	leftDialog = "@conversation/mtp_hideout_recon:s_8", -- recon offer; collection slot OPEN
	stopConversation = false,
	options = {
		{"@conversation/mtp_hideout_recon:s_6", "s_10"},
		{"@conversation/mtp_hideout_recon:s_26", "s_32"},
	}
}
mtp_hideout_recon_convo:addScreen(mtp_hideout_recon_convo_s_8)

mtp_hideout_recon_convo_s_10 = ConvoScreen:new {
	id = "s_10",
	leftDialog = "@conversation/mtp_hideout_recon:s_10", -- what did you have in mind
	stopConversation = false,
	options = {
		{"@conversation/mtp_hideout_recon:s_14", "s_16"},
	}
}
mtp_hideout_recon_convo:addScreen(mtp_hideout_recon_convo_s_10)

mtp_hideout_recon_convo_s_16 = ConvoScreen:new {
	id = "s_16",
	leftDialog = "@conversation/mtp_hideout_recon:s_16", -- take this camera
	stopConversation = false,
	options = {
		{"@conversation/mtp_hideout_recon:s_18", "s_20"},
	}
}
mtp_hideout_recon_convo:addScreen(mtp_hideout_recon_convo_s_16)

mtp_hideout_recon_convo_s_20 = ConvoScreen:new {
	id = "s_20",
	leftDialog = "@conversation/mtp_hideout_recon:s_20", -- accept; collection OPEN
	stopConversation = true,
	options = {}
}
mtp_hideout_recon_convo:addScreen(mtp_hideout_recon_convo_s_20)

mtp_hideout_recon_convo_s_32 = ConvoScreen:new {
	id = "s_32",
	leftDialog = "@conversation/mtp_hideout_recon:s_32", -- decline restroom
	stopConversation = true,
	options = {}
}
mtp_hideout_recon_convo:addScreen(mtp_hideout_recon_convo_s_32)

mtp_hideout_recon_convo_s_36 = ConvoScreen:new {
	id = "s_36",
	leftDialog = "@conversation/mtp_hideout_recon:s_36", -- still taking photos
	stopConversation = true,
	options = {}
}
mtp_hideout_recon_convo:addScreen(mtp_hideout_recon_convo_s_36)

addConversationTemplate("mtp_hideout_recon_convo", mtp_hideout_recon_convo)
