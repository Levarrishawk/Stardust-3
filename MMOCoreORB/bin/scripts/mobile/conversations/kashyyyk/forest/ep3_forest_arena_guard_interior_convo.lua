-- Rhylis (Arena Guard Interior) -- ep3_forest_kerritamba_epic_6, ep3_forest_wirartu_epic_1
-- ruling 2026-09-04: "ensure kashyyyk is fully done"
-- Transcribed from the giver's java branches. Strings are shipped keys.
-- The journal row for quest/ep3_forest_*.qst comes from the integration branch later; this arc does not call the Journal API.

ep3_forest_arena_guard_interior_convo = ConvoTemplate:new {
	initialScreen = "s_202",
	templateType = "Lua",
	luaClassHandler = "ep3_forest_arena_guard_interior_conv_handler",
	screens = {}
}

ep3_forest_arena_guard_interior_convo_s_6 = ConvoScreen:new {
	id = "s_6",
	leftDialog = "@conversation/ep3_forest_arena_guard_interior:s_6", -- If you leave now, you will fail the arena challenge. Are you sure you want to leave?
	stopConversation = "false",
	options = {
		{"@conversation/ep3_forest_arena_guard_interior:s_7", "s_9"},
		{"@conversation/ep3_forest_arena_guard_interior:s_8", "s_10"},
	}
}
ep3_forest_arena_guard_interior_convo:addScreen(ep3_forest_arena_guard_interior_convo_s_6)

ep3_forest_arena_guard_interior_convo_s_157 = ConvoScreen:new {
	id = "s_157",
	leftDialog = "@conversation/ep3_forest_arena_guard_interior:s_157", -- Ready to Exit?
	stopConversation = "false",
	options = {
		{"@conversation/ep3_forest_arena_guard_interior:s_158", "s_159"},
	}
}
ep3_forest_arena_guard_interior_convo:addScreen(ep3_forest_arena_guard_interior_convo_s_157)

ep3_forest_arena_guard_interior_convo_s_202 = ConvoScreen:new {
	id = "s_202",
	leftDialog = "@conversation/ep3_forest_arena_guard_interior:s_202", -- ... move along.
	stopConversation = "true",
	options = {}
}
ep3_forest_arena_guard_interior_convo:addScreen(ep3_forest_arena_guard_interior_convo_s_202)

ep3_forest_arena_guard_interior_convo_s_9 = ConvoScreen:new {
	id = "s_9",
	animation = "nod_head_multiple",
	leftDialog = "@conversation/ep3_forest_arena_guard_interior:s_9", -- Very well.
	stopConversation = "true",
	options = {}
}
ep3_forest_arena_guard_interior_convo:addScreen(ep3_forest_arena_guard_interior_convo_s_9)

ep3_forest_arena_guard_interior_convo_s_10 = ConvoScreen:new {
	id = "s_10",
	animation = "shake_head_no",
	leftDialog = "@conversation/ep3_forest_arena_guard_interior:s_10", -- May the forest spirits grant you blessings.
	stopConversation = "true",
	options = {}
}
ep3_forest_arena_guard_interior_convo:addScreen(ep3_forest_arena_guard_interior_convo_s_10)

ep3_forest_arena_guard_interior_convo_s_159 = ConvoScreen:new {
	id = "s_159",
	leftDialog = "@conversation/ep3_forest_arena_guard_interior:s_159", -- And away you go....
	stopConversation = "true",
	options = {}
}
ep3_forest_arena_guard_interior_convo:addScreen(ep3_forest_arena_guard_interior_convo_s_159)

addConversationTemplate("ep3_forest_arena_guard_interior_convo", ep3_forest_arena_guard_interior_convo)
