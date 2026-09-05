-- Wirartu (Arena Champion - Pre-Combat) -- ep3_forest_kerritamba_epic_6, ep3_forest_wirartu_epic_1
-- ruling 2026-09-04: "ensure kashyyyk is fully done"
-- Transcribed from the giver's java branches. Strings are shipped keys.
-- The journal row for quest/ep3_forest_*.qst comes from the integration branch later; this arc does not call the Journal API.

ep3_forest_wirartu_arena_convo = ConvoTemplate:new {
	initialScreen = "s_555",
	templateType = "Lua",
	luaClassHandler = "ep3_forest_wirartu_arena_conv_handler",
	screens = {}
}

ep3_forest_wirartu_arena_convo_s_541 = ConvoScreen:new {
	id = "s_541",
	leftDialog = "@conversation/ep3_forest_wirartu_arena:s_541", -- Finally, you come... [Wirartu crosses his arms over his chest.] Are you ready to face me?
	stopConversation = "false",
	options = {
		{"@conversation/ep3_forest_wirartu_arena:s_543", "s_545"},
	}
}
ep3_forest_wirartu_arena_convo:addScreen(ep3_forest_wirartu_arena_convo_s_541)

ep3_forest_wirartu_arena_convo_s_555 = ConvoScreen:new {
	id = "s_555",
	leftDialog = "@conversation/ep3_forest_wirartu_arena:s_555", -- ..
	stopConversation = "true",
	options = {}
}
ep3_forest_wirartu_arena_convo:addScreen(ep3_forest_wirartu_arena_convo_s_555)

ep3_forest_wirartu_arena_convo_s_545 = ConvoScreen:new {
	id = "s_545",
	leftDialog = "@conversation/ep3_forest_wirartu_arena:s_545", -- I don't want to hear your drivel! Face me now or you'll be recognized as a coward and a fake!
	stopConversation = "false",
	options = {
		{"@conversation/ep3_forest_wirartu_arena:s_547", "s_553"},
		{"@conversation/ep3_forest_wirartu_arena:s_551", "s_553"},
	}
}
ep3_forest_wirartu_arena_convo:addScreen(ep3_forest_wirartu_arena_convo_s_545)

ep3_forest_wirartu_arena_convo_s_549 = ConvoScreen:new {
	id = "s_549",
	leftDialog = "@conversation/ep3_forest_wirartu_arena:s_549", -- Then, let it begin...
	stopConversation = "true",
	options = {}
}
ep3_forest_wirartu_arena_convo:addScreen(ep3_forest_wirartu_arena_convo_s_549)

ep3_forest_wirartu_arena_convo_s_553 = ConvoScreen:new {
	id = "s_553",
	leftDialog = "@conversation/ep3_forest_wirartu_arena:s_553", -- This will be an honorable battle. I will not attack unless you are ready.
	stopConversation = "true",
	options = {}
}
ep3_forest_wirartu_arena_convo:addScreen(ep3_forest_wirartu_arena_convo_s_553)

addConversationTemplate("ep3_forest_wirartu_arena_convo", ep3_forest_wirartu_arena_convo)
