-- Vritol -- ep3_hunt_vritol_reward_mount (not one of the ten Rryatt .qst files)
-- ruling 2026-09-04: "ensure kashyyyk is fully done"
-- Transcribed from java-rryatt.json / ep3_rryatt_vritol.java. Strings are shipped keys.
-- OPEN: hunt_vritol_reward_mount is not this arc. Signal vritol_speakToVritol is
-- raised on s_218 when that hunt screenplay is loaded. Deed iff has no repo template.
-- Do not call the journal engine.

ep3_rryatt_vritol_convo = ConvoTemplate:new {
	initialScreen = "s_669",
	templateType = "Lua",
	luaClassHandler = "ep3_rryatt_vritol_conv_handler",
	screens = {}
}

ep3_rryatt_vritol_convo_s_226 = ConvoScreen:new {
	id = "s_226",
	leftDialog = "@conversation/ep3_rryatt_vritol:s_226", -- Ra oacanwa rawwacccraan acc anacorwo ra cccoooosac ccoohawwsraacww oarwowoor.
	stopConversation = "true",
	options = {}
}
ep3_rryatt_vritol_convo:addScreen(ep3_rryatt_vritol_convo_s_226)

ep3_rryatt_vritol_convo_s_218 = ConvoScreen:new {
	id = "s_218",
	leftDialog = "@conversation/ep3_rryatt_vritol:s_218", -- Brody told me to expect you. I have your Kashyyyk bantha ready.
	stopConversation = "false",
	options = {
		{"@conversation/ep3_rryatt_vritol:s_221", "s_224"},
	}
}
ep3_rryatt_vritol_convo:addScreen(ep3_rryatt_vritol_convo_s_218)

ep3_rryatt_vritol_convo_s_224 = ConvoScreen:new {
	id = "s_224",
	leftDialog = "@conversation/ep3_rryatt_vritol:s_224", -- You're welcome. Brody wished for me to thank you again for him as well.
	stopConversation = "true",
	options = {}
}
ep3_rryatt_vritol_convo:addScreen(ep3_rryatt_vritol_convo_s_224)

ep3_rryatt_vritol_convo_s_669 = ConvoScreen:new {
	id = "s_669",
	leftDialog = "@conversation/ep3_rryatt_vritol:s_669",
	stopConversation = "true",
	options = {}
}
ep3_rryatt_vritol_convo:addScreen(ep3_rryatt_vritol_convo_s_669)

addConversationTemplate("ep3_rryatt_vritol_convo", ep3_rryatt_vritol_convo)
