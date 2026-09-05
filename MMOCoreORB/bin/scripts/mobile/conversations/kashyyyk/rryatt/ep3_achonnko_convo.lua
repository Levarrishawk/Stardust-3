-- Achonnko -- grant site for ep3_rryatt_trail_mastery
-- ruling 2026-09-04: "ensure kashyyyk is fully done"
-- Transcribed from ep3_achonnko.java (not in java-rryatt.json; found as the grant site).
-- OPEN: camo-kit quest and zone warps are not this arc. Warp options are listed and idle.
-- OPEN: no Creature:new for ep3_achonnko; convo cannot be attached on this branch.
-- Do not call the journal engine.

ep3_achonnko_convo = ConvoTemplate:new {
	initialScreen = "s_171",
	templateType = "Lua",
	luaClassHandler = "ep3_achonnko_conv_handler",
	screens = {}
}

ep3_achonnko_convo_s_169 = ConvoScreen:new {
	id = "s_169",
	leftDialog = "@conversation/ep3_achonnko:s_169",
	stopConversation = "true",
	options = {}
}
ep3_achonnko_convo:addScreen(ep3_achonnko_convo_s_169)

ep3_achonnko_convo_s_171 = ConvoScreen:new {
	id = "s_171",
	leftDialog = "@conversation/ep3_achonnko:s_171",
	stopConversation = "false",
	options = {
		{"@conversation/ep3_achonnko:s_173", "s_175"},
	}
}
ep3_achonnko_convo:addScreen(ep3_achonnko_convo_s_171)

ep3_achonnko_convo_s_175 = ConvoScreen:new {
	id = "s_175",
	leftDialog = "@conversation/ep3_achonnko:s_175",
	stopConversation = "false",
	options = {
		{"@conversation/ep3_achonnko:s_177", "s_179"},
	}
}
ep3_achonnko_convo:addScreen(ep3_achonnko_convo_s_175)

ep3_achonnko_convo_s_179 = ConvoScreen:new {
	id = "s_179",
	leftDialog = "@conversation/ep3_achonnko:s_179",
	stopConversation = "false",
	options = {
		{"@conversation/ep3_achonnko:s_181", "s_183"},
	}
}
ep3_achonnko_convo:addScreen(ep3_achonnko_convo_s_179)

ep3_achonnko_convo_s_183 = ConvoScreen:new {
	id = "s_183",
	leftDialog = "@conversation/ep3_achonnko:s_183",
	stopConversation = "true",
	options = {}
}
ep3_achonnko_convo:addScreen(ep3_achonnko_convo_s_183)

ep3_achonnko_convo_s_185 = ConvoScreen:new {
	id = "s_185",
	leftDialog = "@conversation/ep3_achonnko:s_185",
	stopConversation = "false",
	options = {
		{"@conversation/ep3_achonnko:s_187", "s_189"},
		{"@conversation/ep3_achonnko:s_191", "s_193"},
		{"@conversation/ep3_achonnko:s_195", "s_197"},
		{"@conversation/ep3_achonnko:s_199", "s_201"},
		{"@conversation/ep3_achonnko:s_203", "s_205"},
	}
}
ep3_achonnko_convo:addScreen(ep3_achonnko_convo_s_185)

ep3_achonnko_convo_s_189 = ConvoScreen:new {
	id = "s_189",
	leftDialog = "@conversation/ep3_achonnko:s_189",
	stopConversation = "true",
	options = {}
}
ep3_achonnko_convo:addScreen(ep3_achonnko_convo_s_189)

ep3_achonnko_convo_s_193 = ConvoScreen:new {
	id = "s_193",
	leftDialog = "@conversation/ep3_achonnko:s_193",
	stopConversation = "true",
	options = {}
}
ep3_achonnko_convo:addScreen(ep3_achonnko_convo_s_193)

ep3_achonnko_convo_s_197 = ConvoScreen:new {
	id = "s_197",
	leftDialog = "@conversation/ep3_achonnko:s_197",
	stopConversation = "true",
	options = {}
}
ep3_achonnko_convo:addScreen(ep3_achonnko_convo_s_197)

ep3_achonnko_convo_s_201 = ConvoScreen:new {
	id = "s_201",
	leftDialog = "@conversation/ep3_achonnko:s_201",
	stopConversation = "true",
	options = {}
}
ep3_achonnko_convo:addScreen(ep3_achonnko_convo_s_201)

ep3_achonnko_convo_s_205 = ConvoScreen:new {
	id = "s_205",
	leftDialog = "@conversation/ep3_achonnko:s_205",
	stopConversation = "true",
	options = {}
}
ep3_achonnko_convo:addScreen(ep3_achonnko_convo_s_205)

addConversationTemplate("ep3_achonnko_convo", ep3_achonnko_convo)
