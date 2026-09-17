talon_karrde_pilot_convo = ConvoTemplate:new {
	initialScreen = "initial",
	templateType = "Lua",
	luaClassHandler = "talonKarrdePilotConvoHandler",
	screens = {}
}

local initial = ConvoScreen:new {
	id = "initial",
	leftDialog = "@conversation/tatooine_privateer_trainer_2:s_89b061e3",
	stopConversation = "false",
	options = {
		{"@conversation/tatooine_privateer_trainer_2:s_3f10da9d", "important_job"},
	}
}
talon_karrde_pilot_convo:addScreen(initial)

local importantJob = ConvoScreen:new {
	id = "important_job",
	leftDialog = "@conversation/tatooine_privateer_trainer_2:s_7a2ca8fc",
	stopConversation = "false",
	options = {
		{"@conversation/tatooine_privateer_trainer_2:s_1c8bddbb", "nym_briefing"},
	}
}
talon_karrde_pilot_convo:addScreen(importantJob)

local nymBriefing = ConvoScreen:new {
	id = "nym_briefing",
	leftDialog = "@conversation/tatooine_privateer_trainer_2:s_810a7e7",
	stopConversation = "false",
	options = {
		{"@conversation/tatooine_privateer_trainer_2:s_365a729a", "knows_nym"},
		{"@conversation/tatooine_privateer_trainer_2:s_e70a45c9", "does_not_know_nym"},
	}
}
talon_karrde_pilot_convo:addScreen(nymBriefing)

local knowsNym = ConvoScreen:new {
	id = "knows_nym",
	leftDialog = "@conversation/tatooine_privateer_trainer_2:s_4963bef6",
	stopConversation = "false",
	options = {
		{"@conversation/tatooine_privateer_trainer_2:s_db4bd0fd", "assign_mission"},
	}
}
talon_karrde_pilot_convo:addScreen(knowsNym)

local doesNotKnowNym = ConvoScreen:new {
	id = "does_not_know_nym",
	leftDialog = "@conversation/tatooine_privateer_trainer_2:s_4312ff91",
	stopConversation = "false",
	options = {
		{"@conversation/tatooine_privateer_trainer_2:s_db4bd0fd", "assign_mission"},
	}
}
talon_karrde_pilot_convo:addScreen(doesNotKnowNym)

local assignMission = ConvoScreen:new {
	id = "assign_mission",
	leftDialog = "@conversation/tatooine_privateer_trainer_2:s_bb6309e6",
	stopConversation = "true",
	options = {}
}
talon_karrde_pilot_convo:addScreen(assignMission)

local onMission = ConvoScreen:new {
	id = "on_mission",
	leftDialog = "@conversation/tatooine_privateer_trainer_2:s_983a902c",
	stopConversation = "true",
	options = {}
}
talon_karrde_pilot_convo:addScreen(onMission)

local missionComplete = ConvoScreen:new {
	id = "mission_complete",
	leftDialog = "@conversation/tatooine_privateer_trainer_2:s_9571c1b4",
	stopConversation = "true",
	options = {}
}
talon_karrde_pilot_convo:addScreen(missionComplete)

local alreadyComplete = ConvoScreen:new {
	id = "already_complete",
	leftDialog = "@conversation/tatooine_privateer_trainer_2:s_1169dea4",
	stopConversation = "true",
	options = {}
}
talon_karrde_pilot_convo:addScreen(alreadyComplete)

local tier2HandoffIntro = ConvoScreen:new {
	id = "tier2_handoff_intro",
	leftDialog = "@conversation/tatooine_privateer_trainer_2:s_9a287fb8", -- What? Why? What did you do?
	stopConversation = "false",
	options = {
		{"@conversation/tatooine_privateer_trainer_2:s_9cf1e4c3", "tier2_handoff_jabba"}, -- Say no more.
	}
}
talon_karrde_pilot_convo:addScreen(tier2HandoffIntro)

local tier2HandoffJabba = ConvoScreen:new {
	id = "tier2_handoff_jabba",
	leftDialog = "@conversation/tatooine_privateer_trainer_2:s_fa31c92f", -- Jabba has asked for your services. Speak with Beissa in Jabba's Palace.
	stopConversation = "false",
	options = {
		{"@conversation/tatooine_privateer_trainer_2:s_de9b68cd", "tier2_handoff_explanation"}, -- Jabba wants me to work for him after what I did?
	}
}
talon_karrde_pilot_convo:addScreen(tier2HandoffJabba)

local tier2HandoffExplanation = ConvoScreen:new {
	id = "tier2_handoff_explanation",
	leftDialog = "@conversation/tatooine_privateer_trainer_2:s_7642f4a4", -- Jabba respects strength, and you showed backbone.
	stopConversation = "false",
	options = {
		{"@conversation/tatooine_privateer_trainer_2:s_805cb6f3", "tier2_handoff_final"}, -- Alright I will report to Jabba.
	}
}
talon_karrde_pilot_convo:addScreen(tier2HandoffExplanation)

local tier2HandoffFinal = ConvoScreen:new {
	id = "tier2_handoff_final",
	leftDialog = "@conversation/tatooine_privateer_trainer_2:s_9504aca1", -- Go talk to Beissa in Jabba's Palace.
	stopConversation = "true",
	options = {}
}
talon_karrde_pilot_convo:addScreen(tier2HandoffFinal)

local tier2HandoffComplete = ConvoScreen:new {
	id = "tier2_handoff_complete",
	leftDialog = "@conversation/tatooine_privateer_trainer_2:s_9504aca1",
	stopConversation = "true",
	options = {}
}
talon_karrde_pilot_convo:addScreen(tier2HandoffComplete)

local notReady = ConvoScreen:new {
	id = "not_ready",
	leftDialog = "@conversation/tatooine_privateer_trainer_2:s_ff6979b6",
	stopConversation = "true",
	options = {}
}
talon_karrde_pilot_convo:addScreen(notReady)

addConversationTemplate("talon_karrde_pilot_convo", talon_karrde_pilot_convo)
