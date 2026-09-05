-- Wirartu (Arena Champion - Post-Combat Submission) -- ep3_forest_wirartu_epic_1, ep3_forest_wirartu_epic_2, ep3_forest_wirartu_epic_3, ep3_forest_on_hold
-- ruling 2026-09-04: "ensure kashyyyk is fully done"
-- Transcribed from the giver's java branches. Strings are shipped keys.
-- The journal row for quest/ep3_forest_*.qst comes from the integration branch later; this arc does not call the Journal API.

ep3_forest_wirartu_attack_convo = ConvoTemplate:new {
	initialScreen = "s_867",
	templateType = "Lua",
	luaClassHandler = "ep3_forest_wirartu_attack_conv_handler",
	screens = {}
}

ep3_forest_wirartu_attack_convo_s_865 = ConvoScreen:new {
	id = "s_865",
	leftDialog = "@conversation/ep3_forest_wirartu_attack:s_865", -- [Wirartu bows.] Now you are the Arena Champion.. and rightfully so.
	stopConversation = "true",
	options = {}
}
ep3_forest_wirartu_attack_convo:addScreen(ep3_forest_wirartu_attack_convo_s_865)

ep3_forest_wirartu_attack_convo_s_867 = ConvoScreen:new {
	id = "s_867",
	leftDialog = "@conversation/ep3_forest_wirartu_attack:s_867", -- I--I can't believe I have been defeated. You are a mighty warrior. Please... spare me. Let me live.
	stopConversation = "false",
	options = {
		{"@conversation/ep3_forest_wirartu_attack:s_869", "s_871"},
		{"@conversation/ep3_forest_wirartu_attack:s_873", "s_875"},
	}
}
ep3_forest_wirartu_attack_convo:addScreen(ep3_forest_wirartu_attack_convo_s_867)

ep3_forest_wirartu_attack_convo_s_871 = ConvoScreen:new {
	id = "s_871",
	leftDialog = "@conversation/ep3_forest_wirartu_attack:s_871", -- [Wirartu bows in reverence.] You truly deserve the title of Arena Champion. You could have easily destroyed...
	stopConversation = "true",
	options = {}
}
ep3_forest_wirartu_attack_convo:addScreen(ep3_forest_wirartu_attack_convo_s_871)

ep3_forest_wirartu_attack_convo_s_875 = ConvoScreen:new {
	id = "s_875",
	leftDialog = "@conversation/ep3_forest_wirartu_attack:s_875", -- Ahh! You heartless fiend!
	stopConversation = "true",
	options = {}
}
ep3_forest_wirartu_attack_convo:addScreen(ep3_forest_wirartu_attack_convo_s_875)

addConversationTemplate("ep3_forest_wirartu_attack_convo", ep3_forest_wirartu_attack_convo)
