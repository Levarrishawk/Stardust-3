-- Outcast Dealer -- no quests
-- ruling 2026-09-04: "ensure kashyyyk is fully done"
-- Transcribed from the giver's java branches. Strings are shipped keys.
-- The journal row for quest/ep3_forest_*.qst comes from the integration branch later; this arc does not call the Journal API.

ep3_forest_outcast_dealer_convo = ConvoTemplate:new {
	initialScreen = "s_5ceff11f",
	templateType = "Lua",
	luaClassHandler = "ep3_forest_outcast_dealer_conv_handler",
	screens = {}
}

ep3_forest_outcast_dealer_convo_s_5ceff11f = ConvoScreen:new {
	id = "s_5ceff11f",
	leftDialog = "@conversation/ep3_forest_outcast_dealer:s_5ceff11f", -- [Rhuiw looks you over.] Looks like you could know a thing or two about good junk. Got any?
	stopConversation = "false",
	options = {
		{"@conversation/ep3_forest_outcast_dealer:s_c20cb2b0", "s_47a68e94"},
	}
}
ep3_forest_outcast_dealer_convo:addScreen(ep3_forest_outcast_dealer_convo_s_5ceff11f)

ep3_forest_outcast_dealer_convo_s_47a68e94 = ConvoScreen:new {
	id = "s_47a68e94",
	leftDialog = "@conversation/ep3_forest_outcast_dealer:s_47a68e94", -- You know.. [Rhuiw shrugs.] Stuff off the Sayormi, maybe. Mystical tomes... anything really. Bring the stuff...
	stopConversation = "false",
	options = {
		{"@conversation/ep3_forest_outcast_dealer:s_e022ccee", "s_428"},
		{"@conversation/ep3_forest_outcast_dealer:s_426", "s_428"},
	}
}
ep3_forest_outcast_dealer_convo:addScreen(ep3_forest_outcast_dealer_convo_s_47a68e94)

ep3_forest_outcast_dealer_convo_s_427 = ConvoScreen:new {
	id = "s_427",
	leftDialog = "@conversation/ep3_forest_outcast_dealer:s_427", -- Oh yeah? [Rhuiw peers closer.]
	stopConversation = "true",
	options = {}
}
ep3_forest_outcast_dealer_convo:addScreen(ep3_forest_outcast_dealer_convo_s_427)

ep3_forest_outcast_dealer_convo_s_428 = ConvoScreen:new {
	id = "s_428",
	leftDialog = "@conversation/ep3_forest_outcast_dealer:s_428", -- [Rhuiw nods.] Remember. We never had this conversation.
	stopConversation = "true",
	options = {}
}
ep3_forest_outcast_dealer_convo:addScreen(ep3_forest_outcast_dealer_convo_s_428)

addConversationTemplate("ep3_forest_outcast_dealer_convo", ep3_forest_outcast_dealer_convo)
