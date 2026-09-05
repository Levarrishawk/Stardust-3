-- mtp_hideout_safe_tech
-- ruling 2026-09-04

mtp_hideout_safe_tech_convo = ConvoTemplate:new {
	initialScreen = "s_48",
	templateType = "Lua",
	luaClassHandler = "mtp_hideout_safe_tech_conv_handler",
	screens = {}
}

mtp_hideout_safe_tech_convo_s_46 = ConvoScreen:new {
	id = "s_46",
	leftDialog = "@conversation/mtp_hideout_safe_tech:s_46", -- rori/talus thanks / done
	stopConversation = true,
	options = {}
}
mtp_hideout_safe_tech_convo:addScreen(mtp_hideout_safe_tech_convo_s_46)

mtp_hideout_safe_tech_convo_s_35 = ConvoScreen:new {
	id = "s_35",
	leftDialog = "@conversation/mtp_hideout_safe_tech:s_35", -- infiltrator return
	stopConversation = false,
	options = {
		{"@conversation/mtp_hideout_safe_tech:s_38", "s_42"},
	}
}
mtp_hideout_safe_tech_convo:addScreen(mtp_hideout_safe_tech_convo_s_35)

mtp_hideout_safe_tech_convo_s_42 = ConvoScreen:new {
	id = "s_42",
	leftDialog = "@conversation/mtp_hideout_safe_tech:s_42", -- signal locksmith / grant camp
	stopConversation = true,
	options = {}
}
mtp_hideout_safe_tech_convo:addScreen(mtp_hideout_safe_tech_convo_s_42)

mtp_hideout_safe_tech_convo_s_44 = ConvoScreen:new {
	id = "s_44",
	leftDialog = "@conversation/mtp_hideout_safe_tech:s_44", -- infiltrator still active
	stopConversation = true,
	options = {}
}
mtp_hideout_safe_tech_convo:addScreen(mtp_hideout_safe_tech_convo_s_44)

mtp_hideout_safe_tech_convo_s_4 = ConvoScreen:new {
	id = "s_4",
	leftDialog = "@conversation/mtp_hideout_safe_tech:s_4", -- offer infiltrator
	stopConversation = false,
	options = {
		{"@conversation/mtp_hideout_safe_tech:s_6", "s_12"},
	}
}
mtp_hideout_safe_tech_convo:addScreen(mtp_hideout_safe_tech_convo_s_4)

mtp_hideout_safe_tech_convo_s_12 = ConvoScreen:new {
	id = "s_12",
	leftDialog = "@conversation/mtp_hideout_safe_tech:s_12", -- noises in storage
	stopConversation = false,
	options = {
		{"@conversation/mtp_hideout_safe_tech:s_22", "s_24"},
	}
}
mtp_hideout_safe_tech_convo:addScreen(mtp_hideout_safe_tech_convo_s_12)

mtp_hideout_safe_tech_convo_s_24 = ConvoScreen:new {
	id = "s_24",
	leftDialog = "@conversation/mtp_hideout_safe_tech:s_24", -- make a sweep
	stopConversation = false,
	options = {
		{"@conversation/mtp_hideout_safe_tech:s_26", "s_28"},
	}
}
mtp_hideout_safe_tech_convo:addScreen(mtp_hideout_safe_tech_convo_s_24)

mtp_hideout_safe_tech_convo_s_28 = ConvoScreen:new {
	id = "s_28",
	leftDialog = "@conversation/mtp_hideout_safe_tech:s_28", -- grant random infiltrator 1-5
	stopConversation = true,
	options = {}
}
mtp_hideout_safe_tech_convo:addScreen(mtp_hideout_safe_tech_convo_s_28)

mtp_hideout_safe_tech_convo_s_48 = ConvoScreen:new {
	id = "s_48",
	leftDialog = "@conversation/mtp_hideout_safe_tech:s_48", -- default
	stopConversation = true,
	options = {}
}
mtp_hideout_safe_tech_convo:addScreen(mtp_hideout_safe_tech_convo_s_48)

addConversationTemplate("mtp_hideout_safe_tech_convo", mtp_hideout_safe_tech_convo)
