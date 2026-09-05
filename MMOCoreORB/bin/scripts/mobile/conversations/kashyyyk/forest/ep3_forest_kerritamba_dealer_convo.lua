-- Kerritamba Junk Dealer -- no quests
-- ruling 2026-09-04: "ensure kashyyyk is fully done"
-- Transcribed from the giver's java branches. Strings are shipped keys.
-- The journal row for quest/ep3_forest_*.qst comes from the integration branch later; this arc does not call the Journal API.

ep3_forest_kerritamba_dealer_convo = ConvoTemplate:new {
	initialScreen = "s_5ceff11f",
	templateType = "Lua",
	luaClassHandler = "ep3_forest_kerritamba_dealer_conv_handler",
	screens = {}
}

ep3_forest_kerritamba_dealer_convo_s_5ceff11f = ConvoScreen:new {
	id = "s_5ceff11f",
	leftDialog = "@conversation/ep3_forest_kerritamba_dealer:s_5ceff11f", -- Greetings. [Kinaugha nods.] I deal in all things mystical; things you might find on your adventures. Bring ...
	stopConversation = "false",
	options = {
		{"@conversation/ep3_forest_kerritamba_dealer:s_c20cb2b0", "s_47a68e94"},
	}
}
ep3_forest_kerritamba_dealer_convo:addScreen(ep3_forest_kerritamba_dealer_convo_s_5ceff11f)

ep3_forest_kerritamba_dealer_convo_s_47a68e94 = ConvoScreen:new {
	id = "s_47a68e94",
	leftDialog = "@conversation/ep3_forest_kerritamba_dealer:s_47a68e94", -- For instance, I pay dearly for the mystical tomes found off the Sayormi in the Dead Forest. Bring them to m...
	stopConversation = "false",
	options = {
		{"@conversation/ep3_forest_kerritamba_dealer:s_e022ccee", "s_428"},
		{"@conversation/ep3_forest_kerritamba_dealer:s_426", "s_428"},
	}
}
ep3_forest_kerritamba_dealer_convo:addScreen(ep3_forest_kerritamba_dealer_convo_s_47a68e94)

ep3_forest_kerritamba_dealer_convo_s_427 = ConvoScreen:new {
	id = "s_427",
	leftDialog = "@conversation/ep3_forest_kerritamba_dealer:s_427", -- Let me take a look.
	stopConversation = "true",
	options = {}
}
ep3_forest_kerritamba_dealer_convo:addScreen(ep3_forest_kerritamba_dealer_convo_s_427)

ep3_forest_kerritamba_dealer_convo_s_428 = ConvoScreen:new {
	id = "s_428",
	leftDialog = "@conversation/ep3_forest_kerritamba_dealer:s_428", -- Very well. Return when you do.
	stopConversation = "true",
	options = {}
}
ep3_forest_kerritamba_dealer_convo:addScreen(ep3_forest_kerritamba_dealer_convo_s_428)

addConversationTemplate("ep3_forest_kerritamba_dealer_convo", ep3_forest_kerritamba_dealer_convo)
