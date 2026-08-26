nial_declann_convo = ConvoTemplate:new {
	initialScreen = "briefing",
	templateType = "Lua",
	luaClassHandler = "nialDeclannConvoHandler",
	screens = {}
}

local briefing = ConvoScreen:new {
	id = "briefing",
	leftDialog = "@conversation/imperial_master_trainer:s_b00fab2",
	stopConversation = "false",
	options = {
		{"@conversation/imperial_master_trainer:s_6b18cf1e", "assignment_intro"},
	}
}
nial_declann_convo:addScreen(briefing)

local assignmentIntro = ConvoScreen:new {
	id = "assignment_intro",
	leftDialog = "@conversation/imperial_master_trainer:s_8c202f75",
	stopConversation = "false",
	options = {
		{"@conversation/imperial_master_trainer:s_60d3f4f8", "assignment_details"},
	}
}
nial_declann_convo:addScreen(assignmentIntro)

local assignmentDetails = ConvoScreen:new {
	id = "assignment_details",
	leftDialog = "@conversation/imperial_master_trainer:s_47cf08a2",
	stopConversation = "false",
	options = {
		{"@conversation/imperial_master_trainer:s_5d519e4c", "accept_master_mission"},
	}
}
nial_declann_convo:addScreen(assignmentDetails)

local acceptMasterMission = ConvoScreen:new {
	id = "accept_master_mission",
	leftDialog = "@conversation/imperial_master_trainer:s_1ebf705e",
	stopConversation = "true",
	options = {}
}
nial_declann_convo:addScreen(acceptMasterMission)

local secondAssignmentIntro = ConvoScreen:new {
	id = "second_assignment_intro",
	leftDialog = "@conversation/imperial_master_trainer:s_b170039f",
	stopConversation = "false",
	options = {
		{"@conversation/imperial_master_trainer:s_78d92576", "second_assignment_target"},
	}
}
nial_declann_convo:addScreen(secondAssignmentIntro)

local secondAssignmentTarget = ConvoScreen:new {
	id = "second_assignment_target",
	leftDialog = "@conversation/imperial_master_trainer:s_36e64ebe",
	stopConversation = "false",
	options = {
		{"@conversation/imperial_master_trainer:s_b41b5772", "second_assignment_orders"},
	}
}
nial_declann_convo:addScreen(secondAssignmentTarget)

local secondAssignmentOrders = ConvoScreen:new {
	id = "second_assignment_orders",
	leftDialog = "@conversation/imperial_master_trainer:s_50e3a94f",
	stopConversation = "false",
	options = {
		{"@conversation/imperial_master_trainer:s_cd48bb84", "accept_second_master_mission"},
	}
}
nial_declann_convo:addScreen(secondAssignmentOrders)

local acceptSecondMasterMission = ConvoScreen:new {
	id = "accept_second_master_mission",
	leftDialog = "@conversation/imperial_master_trainer:s_36c3870b",
	stopConversation = "true",
	options = {}
}
nial_declann_convo:addScreen(acceptSecondMasterMission)

local onMission = ConvoScreen:new {
	id = "on_mission",
	leftDialog = "@conversation/imperial_master_trainer:s_faa7bc59",
	stopConversation = "true",
	options = {}
}
nial_declann_convo:addScreen(onMission)

local completed = ConvoScreen:new {
	id = "completed",
	leftDialog = "@conversation/imperial_master_trainer:s_c6be1c53",
	stopConversation = "true",
	options = {}
}
nial_declann_convo:addScreen(completed)

local notEligible = ConvoScreen:new {
	id = "not_eligible",
	leftDialog = "@conversation/imperial_master_trainer:s_cd392cb5",
	stopConversation = "true",
	options = {}
}
nial_declann_convo:addScreen(notEligible)

addConversationTemplate("nial_declann_convo", nial_declann_convo)
