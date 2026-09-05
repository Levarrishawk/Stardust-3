-- mtp_hideout_infiltrator
-- ruling 2026-09-04

mtp_hideout_infiltrator_convo = ConvoTemplate:new {
	initialScreen = "s_36",
	templateType = "Lua",
	luaClassHandler = "mtp_hideout_infiltrator_conv_handler",
	screens = {}
}

mtp_hideout_infiltrator_convo_s_4 = ConvoScreen:new {
	id = "s_4",
	leftDialog = "@conversation/mtp_hideout_recon:s_4", -- found the infiltrator (recon key; no infiltrator stf)
	stopConversation = true,
	options = {}
}
mtp_hideout_infiltrator_convo:addScreen(mtp_hideout_infiltrator_convo_s_4)

mtp_hideout_infiltrator_convo_s_36 = ConvoScreen:new {
	id = "s_36",
	leftDialog = "@conversation/mtp_hideout_recon:s_36", -- default
	stopConversation = true,
	options = {}
}
mtp_hideout_infiltrator_convo:addScreen(mtp_hideout_infiltrator_convo_s_36)

addConversationTemplate("mtp_hideout_infiltrator_convo", mtp_hideout_infiltrator_convo)
