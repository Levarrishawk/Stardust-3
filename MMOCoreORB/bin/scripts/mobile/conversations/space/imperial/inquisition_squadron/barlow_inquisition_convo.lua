barlow_inquisition_convo = ConvoTemplate:new {
	initialScreen = "",
	templateType = "Lua",
	luaClassHandler = "barlowInquisitionConvoHandler",
	screens = {}
}

barlow_inquisition_unavailable = ConvoScreen:new {
	id = "unavailable",
	leftDialog = "@conversation/naboo_imperial_tier3_barlow:s_127f71ad",
	stopConversation = "true",
	options = {}
}
barlow_inquisition_convo:addScreen(barlow_inquisition_unavailable)

barlow_inquisition_mission = ConvoScreen:new {
	id = "tier3_second_mission",
	leftDialog = "@conversation/naboo_imperial_tier3_barlow:s_a72db7d9",
	stopConversation = "false",
	options = {
		{"@conversation/naboo_imperial_tier3_barlow:s_40f102e4", "vrke_introduction"},
	}
}
barlow_inquisition_convo:addScreen(barlow_inquisition_mission)

barlow_inquisition_vrke_introduction = ConvoScreen:new {
	id = "vrke_introduction",
	leftDialog = "@conversation/naboo_imperial_tier3_barlow:s_d8cce866",
	stopConversation = "false",
	options = {
		{"@conversation/naboo_imperial_tier3_barlow:s_f9e3a71b", "barlow_cooperates"},
	}
}
barlow_inquisition_convo:addScreen(barlow_inquisition_vrke_introduction)

barlow_inquisition_cooperates = ConvoScreen:new {
	id = "barlow_cooperates",
	leftDialog = "@conversation/naboo_imperial_tier3_barlow:s_7e952afa",
	stopConversation = "false",
	options = {
		{"@conversation/naboo_imperial_tier3_barlow:s_15fccf52", "hend_contacts"},
	}
}
barlow_inquisition_convo:addScreen(barlow_inquisition_cooperates)

barlow_inquisition_hend_contacts = ConvoScreen:new {
	id = "hend_contacts",
	leftDialog = "@conversation/naboo_imperial_tier3_barlow:s_45363db1",
	stopConversation = "false",
	options = {
		{"@conversation/naboo_imperial_tier3_barlow:s_18782a4b", "shinss_contact"},
	}
}
barlow_inquisition_convo:addScreen(barlow_inquisition_hend_contacts)

barlow_inquisition_shinss_contact = ConvoScreen:new {
	id = "shinss_contact",
	leftDialog = "@conversation/naboo_imperial_tier3_barlow:s_6773e97b",
	stopConversation = "false",
	options = {
		{"@conversation/naboo_imperial_tier3_barlow:s_3c8f00ed", "meeting_frequency"},
	}
}
barlow_inquisition_convo:addScreen(barlow_inquisition_shinss_contact)

barlow_inquisition_meeting_frequency = ConvoScreen:new {
	id = "meeting_frequency",
	leftDialog = "@conversation/naboo_imperial_tier3_barlow:s_760db2a",
	stopConversation = "false",
	options = {
		{"@conversation/naboo_imperial_tier3_barlow:s_14c38c33", "shinss_character"},
	}
}
barlow_inquisition_convo:addScreen(barlow_inquisition_meeting_frequency)

barlow_inquisition_shinss_character = ConvoScreen:new {
	id = "shinss_character",
	leftDialog = "@conversation/naboo_imperial_tier3_barlow:s_e6ae8de",
	stopConversation = "false",
	options = {
		{"@conversation/naboo_imperial_tier3_barlow:s_110ac144", "complete_interview"},
	}
}
barlow_inquisition_convo:addScreen(barlow_inquisition_shinss_character)

barlow_inquisition_complete_interview = ConvoScreen:new {
	id = "complete_interview",
	leftDialog = "@conversation/naboo_imperial_tier3_barlow:s_2b71207d",
	stopConversation = "true",
	options = {}
}
barlow_inquisition_convo:addScreen(barlow_inquisition_complete_interview)

barlow_inquisition_active = ConvoScreen:new {
	id = "tier3_on_mission",
	leftDialog = "@conversation/naboo_imperial_tier3_barlow:s_f813490a",
	stopConversation = "true",
	options = {}
}
barlow_inquisition_convo:addScreen(barlow_inquisition_active)

barlow_inquisition_complete = ConvoScreen:new {
	id = "return_to_vyrke",
	leftDialog = "@conversation/naboo_imperial_tier3_barlow:s_f813490a",
	stopConversation = "true",
	options = {}
}
barlow_inquisition_convo:addScreen(barlow_inquisition_complete)

addConversationTemplate("barlow_inquisition_convo", barlow_inquisition_convo)
