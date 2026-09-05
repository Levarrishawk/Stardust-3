-- mtp_corellia_times_contact
-- ruling 2026-09-05

mtp_corellia_times_contact_convo = ConvoTemplate:new {
	initialScreen = "s_76",
	templateType = "Lua",
	luaClassHandler = "mtp_corellia_times_contact_conv_handler",
	screens = {}
}

mtp_corellia_times_contact_convo_s_37 = ConvoScreen:new {
	id = "s_37",
	leftDialog = "@conversation/mtp_corellia_times_contact:s_37",
	stopConversation = false,
	options = {
		{"@conversation/mtp_corellia_times_contact:s_39", "s_41"},
		{"@conversation/mtp_corellia_times_contact:s_43", "s_45"},
	}
}
mtp_corellia_times_contact_convo:addScreen(mtp_corellia_times_contact_convo_s_37)

mtp_corellia_times_contact_convo_s_41 = ConvoScreen:new {
	id = "s_41",
	leftDialog = "@conversation/mtp_corellia_times_contact:s_41",
	stopConversation = true,
	options = {}
}
mtp_corellia_times_contact_convo:addScreen(mtp_corellia_times_contact_convo_s_41)

mtp_corellia_times_contact_convo_s_45 = ConvoScreen:new {
	id = "s_45",
	leftDialog = "@conversation/mtp_corellia_times_contact:s_45",
	stopConversation = true,
	options = {}
}
mtp_corellia_times_contact_convo:addScreen(mtp_corellia_times_contact_convo_s_45)

mtp_corellia_times_contact_convo_s_19 = ConvoScreen:new {
	id = "s_19",
	leftDialog = "@conversation/mtp_corellia_times_contact:s_19",
	stopConversation = true,
	options = {}
}
mtp_corellia_times_contact_convo:addScreen(mtp_corellia_times_contact_convo_s_19)

mtp_corellia_times_contact_convo_s_10 = ConvoScreen:new {
	id = "s_10",
	leftDialog = "@conversation/mtp_corellia_times_contact:s_10",
	stopConversation = false,
	options = {
		{"@conversation/mtp_corellia_times_contact:s_12", "s_14"},
	}
}
mtp_corellia_times_contact_convo:addScreen(mtp_corellia_times_contact_convo_s_10)

mtp_corellia_times_contact_convo_s_14 = ConvoScreen:new {
	id = "s_14",
	leftDialog = "@conversation/mtp_corellia_times_contact:s_14",
	stopConversation = false,
	options = {
		{"@conversation/mtp_corellia_times_contact:s_16", "s_18"},
	}
}
mtp_corellia_times_contact_convo:addScreen(mtp_corellia_times_contact_convo_s_14)

mtp_corellia_times_contact_convo_s_18 = ConvoScreen:new {
	id = "s_18",
	leftDialog = "@conversation/mtp_corellia_times_contact:s_18",
	stopConversation = false,
	options = {
		{"@conversation/mtp_corellia_times_contact:s_21", "s_23"},
	}
}
mtp_corellia_times_contact_convo:addScreen(mtp_corellia_times_contact_convo_s_18)

mtp_corellia_times_contact_convo_s_23 = ConvoScreen:new {
	id = "s_23",
	leftDialog = "@conversation/mtp_corellia_times_contact:s_23",
	stopConversation = false,
	options = {
		{"@conversation/mtp_corellia_times_contact:s_25", "s_27"},
	}
}
mtp_corellia_times_contact_convo:addScreen(mtp_corellia_times_contact_convo_s_23)

mtp_corellia_times_contact_convo_s_27 = ConvoScreen:new {
	id = "s_27",
	leftDialog = "@conversation/mtp_corellia_times_contact:s_27",
	stopConversation = false,
	options = {
		{"@conversation/mtp_corellia_times_contact:s_29", "s_31"},
	}
}
mtp_corellia_times_contact_convo:addScreen(mtp_corellia_times_contact_convo_s_27)

mtp_corellia_times_contact_convo_s_31 = ConvoScreen:new {
	id = "s_31",
	leftDialog = "@conversation/mtp_corellia_times_contact:s_31",
	stopConversation = false,
	options = {
		{"@conversation/mtp_corellia_times_contact:s_33", "s_35"},
	}
}
mtp_corellia_times_contact_convo:addScreen(mtp_corellia_times_contact_convo_s_31)

mtp_corellia_times_contact_convo_s_35 = ConvoScreen:new {
	id = "s_35",
	leftDialog = "@conversation/mtp_corellia_times_contact:s_35",
	stopConversation = false,
	options = {
		{"@conversation/mtp_corellia_times_contact:s_38", "s_42"},
	}
}
mtp_corellia_times_contact_convo:addScreen(mtp_corellia_times_contact_convo_s_35)

mtp_corellia_times_contact_convo_s_42 = ConvoScreen:new {
	id = "s_42",
	leftDialog = "@conversation/mtp_corellia_times_contact:s_42",
	stopConversation = false,
	options = {
		{"@conversation/mtp_corellia_times_contact:s_46", "s_48"},
	}
}
mtp_corellia_times_contact_convo:addScreen(mtp_corellia_times_contact_convo_s_42)

mtp_corellia_times_contact_convo_s_48 = ConvoScreen:new {
	id = "s_48",
	leftDialog = "@conversation/mtp_corellia_times_contact:s_48",
	stopConversation = true,
	options = {}
}
mtp_corellia_times_contact_convo:addScreen(mtp_corellia_times_contact_convo_s_48)

mtp_corellia_times_contact_convo_s_50 = ConvoScreen:new {
	id = "s_50",
	leftDialog = "@conversation/mtp_corellia_times_contact:s_50",
	stopConversation = true,
	options = {}
}
mtp_corellia_times_contact_convo:addScreen(mtp_corellia_times_contact_convo_s_50)

mtp_corellia_times_contact_convo_s_54 = ConvoScreen:new {
	id = "s_54",
	leftDialog = "@conversation/mtp_corellia_times_contact:s_54",
	stopConversation = true,
	options = {}
}
mtp_corellia_times_contact_convo:addScreen(mtp_corellia_times_contact_convo_s_54)

mtp_corellia_times_contact_convo_s_58 = ConvoScreen:new {
	id = "s_58",
	leftDialog = "@conversation/mtp_corellia_times_contact:s_58",
	stopConversation = true,
	options = {}
}
mtp_corellia_times_contact_convo:addScreen(mtp_corellia_times_contact_convo_s_58)

mtp_corellia_times_contact_convo_s_62 = ConvoScreen:new {
	id = "s_62",
	leftDialog = "@conversation/mtp_corellia_times_contact:s_62",
	stopConversation = true,
	options = {}
}
mtp_corellia_times_contact_convo:addScreen(mtp_corellia_times_contact_convo_s_62)

mtp_corellia_times_contact_convo_s_66 = ConvoScreen:new {
	id = "s_66",
	leftDialog = "@conversation/mtp_corellia_times_contact:s_66",
	stopConversation = true,
	options = {}
}
mtp_corellia_times_contact_convo:addScreen(mtp_corellia_times_contact_convo_s_66)

mtp_corellia_times_contact_convo_s_70 = ConvoScreen:new {
	id = "s_70",
	leftDialog = "@conversation/mtp_corellia_times_contact:s_70",
	stopConversation = true,
	options = {}
}
mtp_corellia_times_contact_convo:addScreen(mtp_corellia_times_contact_convo_s_70)

mtp_corellia_times_contact_convo_s_74 = ConvoScreen:new {
	id = "s_74",
	leftDialog = "@conversation/mtp_corellia_times_contact:s_74",
	stopConversation = true,
	options = {}
}
mtp_corellia_times_contact_convo:addScreen(mtp_corellia_times_contact_convo_s_74)

mtp_corellia_times_contact_convo_s_76 = ConvoScreen:new {
	id = "s_76",
	leftDialog = "@conversation/mtp_corellia_times_contact:s_76",
	stopConversation = true,
	options = {}
}
mtp_corellia_times_contact_convo:addScreen(mtp_corellia_times_contact_convo_s_76)

addConversationTemplate("mtp_corellia_times_contact_convo", mtp_corellia_times_contact_convo)
