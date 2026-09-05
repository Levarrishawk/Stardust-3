-- mtp_corellia_times_contact
-- ruling 2026-09-04

mtp_corellia_times_contact_convo = ConvoTemplate:new {
	initialScreen = "s_76",
	templateType = "Lua",
	luaClassHandler = "mtp_corellia_times_contact_conv_handler",
	screens = {}
}

mtp_corellia_times_contact_convo_s_10 = ConvoScreen:new {
	id = "s_10",
	leftDialog = "@conversation/mtp_corellia_times_contact:s_10", -- pointer active: signal pointer_03
	stopConversation = true,
	options = {}
}
mtp_corellia_times_contact_convo:addScreen(mtp_corellia_times_contact_convo_s_10)

mtp_corellia_times_contact_convo_s_50 = ConvoScreen:new {
	id = "s_50",
	leftDialog = "@conversation/mtp_corellia_times_contact:s_50", -- collection tracking active; OPEN
	stopConversation = true,
	options = {}
}
mtp_corellia_times_contact_convo:addScreen(mtp_corellia_times_contact_convo_s_50)

mtp_corellia_times_contact_convo_s_19 = ConvoScreen:new {
	id = "s_19",
	leftDialog = "@conversation/mtp_corellia_times_contact:s_19", -- pointer done, offer collection OPEN
	stopConversation = false,
	options = {
		{"@conversation/mtp_corellia_times_contact:s_27", "s_31"},
	}
}
mtp_corellia_times_contact_convo:addScreen(mtp_corellia_times_contact_convo_s_19)

mtp_corellia_times_contact_convo_s_31 = ConvoScreen:new {
	id = "s_31",
	leftDialog = "@conversation/mtp_corellia_times_contact:s_31", -- grant collection_tracking OPEN
	stopConversation = true,
	options = {}
}
mtp_corellia_times_contact_convo:addScreen(mtp_corellia_times_contact_convo_s_31)

mtp_corellia_times_contact_convo_s_76 = ConvoScreen:new {
	id = "s_76",
	leftDialog = "@conversation/mtp_corellia_times_contact:s_76", -- default
	stopConversation = true,
	options = {}
}
mtp_corellia_times_contact_convo:addScreen(mtp_corellia_times_contact_convo_s_76)

addConversationTemplate("mtp_corellia_times_contact_convo", mtp_corellia_times_contact_convo)
