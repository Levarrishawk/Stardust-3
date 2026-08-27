willham_burke_convo = ConvoTemplate:new {
	initialScreen = "",
	templateType = "Lua",
	luaClassHandler = "willhamBurkeConvoHandler",
	screens = {}
}

local function burkeScreen(id, dialog, stopConversation, options)
	local screen = ConvoScreen:new {
		id = id,
		leftDialog = dialog,
		stopConversation = stopConversation and "true" or "false",
		options = options or {}
	}

	willham_burke_convo:addScreen(screen)
end

burkeScreen("not_eligible", "@conversation/rebel_master_trainer:s_7cbd5de5", true)
burkeScreen("briefing", "@conversation/rebel_master_trainer:s_46b27b0c", false, {
	{"@conversation/rebel_master_trainer:s_81f189ef", "mission_details"}
})
burkeScreen("mission_details", "@conversation/rebel_master_trainer:s_5919485e", false, {
	{"@conversation/rebel_master_trainer:s_32062da9", "accept_master_mission"}
})
burkeScreen("accept_master_mission", "@conversation/rebel_master_trainer:s_5bdc459b", true)
burkeScreen("on_mission", "@conversation/rebel_master_trainer:s_21d9c824", true)
burkeScreen("second_assignment_intro", "@conversation/rebel_master_trainer:s_1c9d33ed", false, {
	{"@conversation/rebel_master_trainer:s_22d87576", "second_assignment"}
})
burkeScreen("second_assignment", "@conversation/rebel_master_trainer:s_837c0670", false, {
	{"@conversation/rebel_master_trainer:s_46ecd1ec", "accept_second_master_mission"}
})
burkeScreen("accept_second_master_mission", "@conversation/rebel_master_trainer:s_3924b90e", true)
burkeScreen("final_report", "@conversation/rebel_master_trainer:s_28d79ee3", false, {
	{"@conversation/rebel_master_trainer:s_377d1a96", "claim_master_rewards"}
})
burkeScreen("claim_master_rewards", "@conversation/rebel_master_trainer:s_3e83f2ea", true)
burkeScreen("completed", "@conversation/rebel_master_trainer:s_6daab4e1", true)

addConversationTemplate("willham_burke_convo", willham_burke_convo)
