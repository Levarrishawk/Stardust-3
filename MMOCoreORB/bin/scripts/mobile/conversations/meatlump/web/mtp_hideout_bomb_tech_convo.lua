-- mtp_hideout_bomb_tech
-- ruling 2026-09-04

mtp_hideout_bomb_tech_convo = ConvoTemplate:new {
	initialScreen = "s_100",
	templateType = "Lua",
	luaClassHandler = "mtp_hideout_bomb_tech_conv_handler",
	screens = {}
}

mtp_hideout_bomb_tech_convo_s_94 = ConvoScreen:new {
	id = "s_94",
	leftDialog = "@conversation/mtp_hideout_bomb_tech:s_94", -- lok camp thanks / done
	stopConversation = true,
	options = {}
}
mtp_hideout_bomb_tech_convo:addScreen(mtp_hideout_bomb_tech_convo_s_94)

mtp_hideout_bomb_tech_convo_s_58 = ConvoScreen:new {
	id = "s_58",
	leftDialog = "@conversation/mtp_hideout_bomb_tech:s_58", -- do you have all the parts
	stopConversation = false,
	options = {
		{"@conversation/mtp_hideout_bomb_tech:s_60", "s_62"},
	}
}
mtp_hideout_bomb_tech_convo:addScreen(mtp_hideout_bomb_tech_convo_s_58)

mtp_hideout_bomb_tech_convo_s_62 = ConvoScreen:new {
	id = "s_62",
	leftDialog = "@conversation/mtp_hideout_bomb_tech:s_62", -- signal technician / grant lok
	stopConversation = true,
	options = {}
}
mtp_hideout_bomb_tech_convo:addScreen(mtp_hideout_bomb_tech_convo_s_62)

mtp_hideout_bomb_tech_convo_s_68 = ConvoScreen:new {
	id = "s_68",
	leftDialog = "@conversation/mtp_hideout_bomb_tech:s_68", -- bomb items still active
	stopConversation = true,
	options = {}
}
mtp_hideout_bomb_tech_convo:addScreen(mtp_hideout_bomb_tech_convo_s_68)

mtp_hideout_bomb_tech_convo_s_4 = ConvoScreen:new {
	id = "s_4",
	leftDialog = "@conversation/mtp_hideout_bomb_tech:s_4", -- offer bomb parts
	stopConversation = false,
	options = {
		{"@conversation/mtp_hideout_bomb_tech:s_6", "s_23"},
	}
}
mtp_hideout_bomb_tech_convo:addScreen(mtp_hideout_bomb_tech_convo_s_4)

mtp_hideout_bomb_tech_convo_s_23 = ConvoScreen:new {
	id = "s_23",
	leftDialog = "@conversation/mtp_hideout_bomb_tech:s_23", -- need missing parts
	stopConversation = false,
	options = {
		{"@conversation/mtp_hideout_bomb_tech:s_24", "s_33"},
	}
}
mtp_hideout_bomb_tech_convo:addScreen(mtp_hideout_bomb_tech_convo_s_23)

mtp_hideout_bomb_tech_convo_s_33 = ConvoScreen:new {
	id = "s_33",
	leftDialog = "@conversation/mtp_hideout_bomb_tech:s_33", -- grant bomb items
	stopConversation = true,
	options = {}
}
mtp_hideout_bomb_tech_convo:addScreen(mtp_hideout_bomb_tech_convo_s_33)

mtp_hideout_bomb_tech_convo_s_100 = ConvoScreen:new {
	id = "s_100",
	leftDialog = "@conversation/mtp_hideout_bomb_tech:s_100", -- default
	stopConversation = true,
	options = {}
}
mtp_hideout_bomb_tech_convo:addScreen(mtp_hideout_bomb_tech_convo_s_100)

addConversationTemplate("mtp_hideout_bomb_tech_convo", mtp_hideout_bomb_tech_convo)
