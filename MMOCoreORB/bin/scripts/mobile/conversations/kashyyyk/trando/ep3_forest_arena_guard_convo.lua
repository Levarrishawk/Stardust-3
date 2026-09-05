-- arena_guard_outer -- ep3_forest_arena_guard
-- ruling 2026-09-04
-- Transcribed from the giver's java branches. Strings are shipped keys.
-- The journal row for the .qst comes from the integration branch later; do not call the journal engine.

ep3_forest_arena_guard_convo = ConvoTemplate:new {
	initialScreen = "s_581",
	templateType = "Lua",
	luaClassHandler = "ep3_forest_arena_guard_conv_handler",
	screens = {}
}

ep3_forest_arena_guard_convo_s_579 = ConvoScreen:new {
	id = "s_579",
	leftDialog = "@conversation/ep3_forest_arena_guard:s_579",
	stopConversation = "true",
	options = {
	}
}
ep3_forest_arena_guard_convo:addScreen(ep3_forest_arena_guard_convo_s_579)

ep3_forest_arena_guard_convo_s_575 = ConvoScreen:new {
	id = "s_575",
	leftDialog = "@conversation/ep3_forest_arena_guard:s_575",
	stopConversation = "true",
	options = {
	}
}
ep3_forest_arena_guard_convo:addScreen(ep3_forest_arena_guard_convo_s_575)

ep3_forest_arena_guard_convo_s_581 = ConvoScreen:new {
	id = "s_581",
	leftDialog = "@conversation/ep3_forest_arena_guard:s_581",
	stopConversation = "true",
	options = {
	}
}
ep3_forest_arena_guard_convo:addScreen(ep3_forest_arena_guard_convo_s_581)

addConversationTemplate("ep3_forest_arena_guard_convo", ep3_forest_arena_guard_convo)
