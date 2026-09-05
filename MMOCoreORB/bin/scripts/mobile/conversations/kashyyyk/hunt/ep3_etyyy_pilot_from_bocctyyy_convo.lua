-- ep3_etyyy_pilot_from_bocctyyy -- Etyyy hunting-grounds ground conversation
-- ruling 2026-09-04: "ensure kashyyyk is fully done"
-- Transcribed from the giver's java branches. Strings are shipped keys.
-- The journal row for quest/ep3_hunt_*.qst comes from the integration branch later; do not call the journal engine.

ep3_etyyy_pilot_from_bocctyyy_convo = ConvoTemplate:new {
	initialScreen = "s_738",
	templateType = "Lua",
	luaClassHandler = "ep3_etyyy_pilot_from_bocctyyy_conv_handler",
	screens = {}
}

ep3_etyyy_pilot_from_bocctyyy_convo_s_742 = ConvoScreen:new {
	id = "s_742",
	leftDialog = "@conversation/ep3_etyyy_pilot_bocctyyy_to_etyyy:s_742", -- You want to leave the Bocctyyy Path and return to the main hunting camp in Etyyy? Once you leave, yo...
	stopConversation = "false",
	options = {
		{"@conversation/ep3_etyyy_pilot_bocctyyy_to_etyyy:s_744", "s_746"},
		{"@conversation/ep3_etyyy_pilot_bocctyyy_to_etyyy:s_748", "s_750"},
	}
}
ep3_etyyy_pilot_from_bocctyyy_convo:addScreen(ep3_etyyy_pilot_from_bocctyyy_convo_s_742)

ep3_etyyy_pilot_from_bocctyyy_convo_s_754 = ConvoScreen:new {
	id = "s_754",
	leftDialog = "@conversation/ep3_etyyy_pilot_bocctyyy_to_etyyy:s_754", -- Not a problem. Good luck with your hunt.
	stopConversation = "true",
	options = {}
}
ep3_etyyy_pilot_from_bocctyyy_convo:addScreen(ep3_etyyy_pilot_from_bocctyyy_convo_s_754)

ep3_etyyy_pilot_from_bocctyyy_convo_s_746 = ConvoScreen:new {
	id = "s_746",
	leftDialog = "@conversation/ep3_etyyy_pilot_bocctyyy_to_etyyy:s_746", -- Very well. I can transport you back to the main hunting camp.
	stopConversation = "true",
	options = {}
}
ep3_etyyy_pilot_from_bocctyyy_convo:addScreen(ep3_etyyy_pilot_from_bocctyyy_convo_s_746)

ep3_etyyy_pilot_from_bocctyyy_convo_s_750 = ConvoScreen:new {
	id = "s_750",
	animation = "nod",
	leftDialog = "@conversation/ep3_etyyy_pilot_bocctyyy_to_etyyy:s_750", -- Of course. As you wish.
	stopConversation = "true",
	options = {}
}
ep3_etyyy_pilot_from_bocctyyy_convo:addScreen(ep3_etyyy_pilot_from_bocctyyy_convo_s_750)

ep3_etyyy_pilot_from_bocctyyy_convo_s_738 = ConvoScreen:new {
	id = "s_738",
	leftDialog = "@conversation/ep3_etyyy_pilot_bocctyyy_to_etyyy:s_738", -- Yes, can I help you?
	stopConversation = "false",
	options = {
		{"@conversation/ep3_etyyy_pilot_bocctyyy_to_etyyy:s_740", "s_742"},
		{"@conversation/ep3_etyyy_pilot_bocctyyy_to_etyyy:s_752", "s_754"},
	}
}
ep3_etyyy_pilot_from_bocctyyy_convo:addScreen(ep3_etyyy_pilot_from_bocctyyy_convo_s_738)

addConversationTemplate("ep3_etyyy_pilot_from_bocctyyy_convo", ep3_etyyy_pilot_from_bocctyyy_convo)
