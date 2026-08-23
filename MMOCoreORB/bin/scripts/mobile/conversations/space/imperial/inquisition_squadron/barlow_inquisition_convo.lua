barlow_inquisition_convo = ConvoTemplate:new {
	initialScreen = "",
	templateType = "Lua",
	luaClassHandler = "barlowInquisitionConvoHandler",
	screens = {}
}

barlow_inquisition_unavailable = ConvoScreen:new {
	id = "unavailable",
	leftDialog = "I have no orders for you. Report to your squadron commander.",
	stopConversation = "true",
	options = {}
}
barlow_inquisition_convo:addScreen(barlow_inquisition_unavailable)

barlow_inquisition_mission = ConvoScreen:new {
	id = "tier3_second_mission",
	leftDialog = "@conversation/naboo_imperial_tier3:s_47424e40",
	stopConversation = "false",
	options = {
		{"@conversation/naboo_imperial_tier3:s_d70dba34", "tier3_second_mission_details"},
		{"@conversation/naboo_imperial_tier3:s_f8e71988", "accept_tier3_second_mission"},
	}
}
barlow_inquisition_convo:addScreen(barlow_inquisition_mission)

barlow_inquisition_details = ConvoScreen:new {
	id = "tier3_second_mission_details",
	leftDialog = "@conversation/naboo_imperial_tier3:s_b49d8273",
	stopConversation = "false",
	options = {
		{"@conversation/naboo_imperial_tier3:s_f8e71988", "accept_tier3_second_mission"},
	}
}
barlow_inquisition_convo:addScreen(barlow_inquisition_details)

barlow_inquisition_accept = ConvoScreen:new {
	id = "accept_tier3_second_mission",
	leftDialog = "@conversation/naboo_imperial_tier3:s_6ffd0979",
	stopConversation = "true",
	options = {}
}
barlow_inquisition_convo:addScreen(barlow_inquisition_accept)

barlow_inquisition_retry = ConvoScreen:new {
	id = "failed_tier3_second_mission",
	leftDialog = "@conversation/naboo_imperial_tier3:s_53d34239",
	stopConversation = "true",
	options = {}
}
barlow_inquisition_convo:addScreen(barlow_inquisition_retry)

barlow_inquisition_active = ConvoScreen:new {
	id = "tier3_on_mission",
	leftDialog = "@conversation/naboo_imperial_tier3:s_c9911c0f",
	stopConversation = "true",
	options = {}
}
barlow_inquisition_convo:addScreen(barlow_inquisition_active)

barlow_inquisition_complete = ConvoScreen:new {
	id = "return_to_vyrke",
	leftDialog = "Your assignment is complete. Return to Inquisitor Vyrke for further orders.",
	stopConversation = "true",
	options = {}
}
barlow_inquisition_convo:addScreen(barlow_inquisition_complete)

addConversationTemplate("barlow_inquisition_convo", barlow_inquisition_convo)
