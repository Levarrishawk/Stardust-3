nial_declann_convo = ConvoTemplate:new {
	initialScreen = "briefing",
	templateType = "Lua",
	luaClassHandler = "nialDeclannConvoHandler",
	screens = {}
}

local briefing = ConvoScreen:new {
	id = "briefing",
	leftDialog = "Your squadron commander has transferred you to my command. I have an assignment for you in the Kessel system.",
	stopConversation = "false",
	options = {
		{"I am ready for the assignment, Grand Admiral.", "accept_master_mission"},
	}
}
nial_declann_convo:addScreen(briefing)

local acceptMasterMission = ConvoScreen:new {
	id = "accept_master_mission",
	leftDialog = "Proceed to the Kessel system and carry out your orders.",
	stopConversation = "true",
	options = {}
}
nial_declann_convo:addScreen(acceptMasterMission)

local onMission = ConvoScreen:new {
	id = "on_mission",
	leftDialog = "Your assignment in the Kessel system is still active. Complete your orders and report back when the operation is finished.",
	stopConversation = "true",
	options = {}
}
nial_declann_convo:addScreen(onMission)

local completed = ConvoScreen:new {
	id = "completed",
	leftDialog = "You have completed the operation assigned to you.",
	stopConversation = "true",
	options = {}
}
nial_declann_convo:addScreen(completed)

local notEligible = ConvoScreen:new {
	id = "not_eligible",
	leftDialog = "I have no assignment for you at this time.",
	stopConversation = "true",
	options = {}
}
nial_declann_convo:addScreen(notEligible)

addConversationTemplate("nial_declann_convo", nial_declann_convo)
