-- Rryatt Trail Guide -- raise site for ep3_rryatt_trail_mastery signals
-- ruling 2026-09-04: "ensure kashyyyk is fully done"
-- Transcribed from rryatt_trail_guide.java (not in java-rryatt.json; found as the signal raise site).
-- OPEN: handleZoneTransitionRequest is not implemented. Signals fire only when zoneLine is set.
-- Do not call the journal engine.

rryatt_trail_guide_convo = ConvoTemplate:new {
	initialScreen = "s_61",
	templateType = "Lua",
	luaClassHandler = "rryatt_trail_guide_conv_handler",
	screens = {}
}

rryatt_trail_guide_convo_s_61 = ConvoScreen:new {
	id = "s_61",
	leftDialog = "@conversation/rryatt_trail_guide:s_61",
	stopConversation = "false",
	options = {
		{"@conversation/rryatt_trail_guide:s_63", "s_65"},
		{"@conversation/rryatt_trail_guide:s_67", "s_69"},
	}
}
rryatt_trail_guide_convo:addScreen(rryatt_trail_guide_convo_s_61)

rryatt_trail_guide_convo_s_65 = ConvoScreen:new {
	id = "s_65",
	leftDialog = "@conversation/rryatt_trail_guide:s_65",
	stopConversation = "true",
	options = {}
}
rryatt_trail_guide_convo:addScreen(rryatt_trail_guide_convo_s_65)

rryatt_trail_guide_convo_s_69 = ConvoScreen:new {
	id = "s_69",
	leftDialog = "@conversation/rryatt_trail_guide:s_69",
	stopConversation = "true",
	options = {}
}
rryatt_trail_guide_convo:addScreen(rryatt_trail_guide_convo_s_69)

addConversationTemplate("rryatt_trail_guide_convo", rryatt_trail_guide_convo)
