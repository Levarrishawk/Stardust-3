-- mtp_hideout_map_tech
-- ruling 2026-09-04

mtp_hideout_map_tech_convo = ConvoTemplate:new {
	initialScreen = "s_58",
	templateType = "Lua",
	luaClassHandler = "mtp_hideout_map_tech_conv_handler",
	screens = {}
}

mtp_hideout_map_tech_convo_s_56 = ConvoScreen:new {
	id = "s_56",
	leftDialog = "@conversation/mtp_hideout_map_tech:s_56", -- corellia camps attacked / done
	stopConversation = true,
	options = {}
}
mtp_hideout_map_tech_convo:addScreen(mtp_hideout_map_tech_convo_s_56)

mtp_hideout_map_tech_convo_s_42 = ConvoScreen:new {
	id = "s_42",
	leftDialog = "@conversation/mtp_hideout_map_tech:s_42", -- so do you have my lunch
	stopConversation = false,
	options = {
		{"@conversation/mtp_hideout_map_tech:s_44", "s_46"},
	}
}
mtp_hideout_map_tech_convo:addScreen(mtp_hideout_map_tech_convo_s_42)

mtp_hideout_map_tech_convo_s_46 = ConvoScreen:new {
	id = "s_46",
	leftDialog = "@conversation/mtp_hideout_map_tech:s_46", -- favorite actually
	stopConversation = false,
	options = {
		{"@conversation/mtp_hideout_map_tech:s_48", "s_50"},
	}
}
mtp_hideout_map_tech_convo:addScreen(mtp_hideout_map_tech_convo_s_46)

mtp_hideout_map_tech_convo_s_50 = ConvoScreen:new {
	id = "s_50",
	leftDialog = "@conversation/mtp_hideout_map_tech:s_50", -- here is the map; grant camp corellia
	stopConversation = true,
	options = {}
}
mtp_hideout_map_tech_convo:addScreen(mtp_hideout_map_tech_convo_s_50)

mtp_hideout_map_tech_convo_s_4 = ConvoScreen:new {
	id = "s_4",
	leftDialog = "@conversation/mtp_hideout_map_tech:s_4", -- offer lunch via Coptszt
	stopConversation = false,
	options = {
		{"@conversation/mtp_hideout_map_tech:s_30", "s_32"},
	}
}
mtp_hideout_map_tech_convo:addScreen(mtp_hideout_map_tech_convo_s_4)

mtp_hideout_map_tech_convo_s_32 = ConvoScreen:new {
	id = "s_32",
	leftDialog = "@conversation/mtp_hideout_map_tech:s_32", -- knows Coptszt
	stopConversation = false,
	options = {
		{"@conversation/mtp_hideout_map_tech:s_34", "s_36"},
	}
}
mtp_hideout_map_tech_convo:addScreen(mtp_hideout_map_tech_convo_s_32)

mtp_hideout_map_tech_convo_s_36 = ConvoScreen:new {
	id = "s_36",
	leftDialog = "@conversation/mtp_hideout_map_tech:s_36", -- grant lunch
	stopConversation = true,
	options = {}
}
mtp_hideout_map_tech_convo:addScreen(mtp_hideout_map_tech_convo_s_36)

mtp_hideout_map_tech_convo_s_58 = ConvoScreen:new {
	id = "s_58",
	leftDialog = "@conversation/mtp_hideout_map_tech:s_58", -- default waiting for an officer
	stopConversation = true,
	options = {}
}
mtp_hideout_map_tech_convo:addScreen(mtp_hideout_map_tech_convo_s_58)

addConversationTemplate("mtp_hideout_map_tech_convo", mtp_hideout_map_tech_convo)
