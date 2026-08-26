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
