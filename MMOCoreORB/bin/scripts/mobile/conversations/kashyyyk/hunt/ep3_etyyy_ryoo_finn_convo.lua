-- ep3_etyyy_ryoo_finn -- Etyyy hunting-grounds ground conversation
-- ruling 2026-09-04: "ensure kashyyyk is fully done"
-- Transcribed from the giver's java branches. Strings are shipped keys.
-- The journal row for quest/ep3_hunt_*.qst comes from the integration branch later; do not call the journal engine.

ep3_etyyy_ryoo_finn_convo = ConvoTemplate:new {
	initialScreen = "s_1213",
	templateType = "Lua",
	luaClassHandler = "ep3_etyyy_ryoo_finn_conv_handler",
	screens = {}
}

ep3_etyyy_ryoo_finn_convo_s_1207 = ConvoScreen:new {
	id = "s_1207",
	leftDialog = "@conversation/ep3_etyyy_ryoo_finn:s_1207", -- Oh man. I lost my stash. Why am I telling you this? Oh wait. Maybe you can help me. Would you go get...
	stopConversation = "false",
	options = {
		{"@conversation/ep3_etyyy_ryoo_finn:s_1214", "s_1216"},
		{"@conversation/ep3_etyyy_ryoo_finn:s_1215", "s_1217"},
	}
}
ep3_etyyy_ryoo_finn_convo:addScreen(ep3_etyyy_ryoo_finn_convo_s_1207)

ep3_etyyy_ryoo_finn_convo_s_1211 = ConvoScreen:new {
	id = "s_1211",
	leftDialog = "@conversation/ep3_etyyy_ryoo_finn:s_1211", -- No bother. No bother. Bye.
	stopConversation = "true",
	options = {}
}
ep3_etyyy_ryoo_finn_convo:addScreen(ep3_etyyy_ryoo_finn_convo_s_1211)

ep3_etyyy_ryoo_finn_convo_s_1216 = ConvoScreen:new {
	id = "s_1216",
	leftDialog = "@conversation/ep3_etyyy_ryoo_finn:s_1216", -- I was wandering outside of camp. I mean, I couldn't let Jerrol see me with salt. He'd all yell at me...
	stopConversation = "false",
	options = {
		{"@conversation/ep3_etyyy_ryoo_finn:s_1218", "s_1221"},
		{"@conversation/ep3_etyyy_ryoo_finn:s_1219", "s_1220"},
	}
}
ep3_etyyy_ryoo_finn_convo:addScreen(ep3_etyyy_ryoo_finn_convo_s_1216)

ep3_etyyy_ryoo_finn_convo_s_1217 = ConvoScreen:new {
	id = "s_1217",
	leftDialog = "@conversation/ep3_etyyy_ryoo_finn:s_1217", -- Okay. Okay. Come back if you change you're mind. I could sure use that salt.
	stopConversation = "true",
	options = {}
}
ep3_etyyy_ryoo_finn_convo:addScreen(ep3_etyyy_ryoo_finn_convo_s_1217)

ep3_etyyy_ryoo_finn_convo_s_1221 = ConvoScreen:new {
	id = "s_1221",
	leftDialog = "@conversation/ep3_etyyy_ryoo_finn:s_1221", -- Oh really good. It should be somewhere among the mouf dens to the west. I was running all over the p...
	stopConversation = "true",
	options = {}
}
ep3_etyyy_ryoo_finn_convo:addScreen(ep3_etyyy_ryoo_finn_convo_s_1221)

ep3_etyyy_ryoo_finn_convo_s_1220 = ConvoScreen:new {
	id = "s_1220",
	leftDialog = "@conversation/ep3_etyyy_ryoo_finn:s_1220", -- Okay. Okay. Come back if you change you're mind. I could sure use that salt.
	stopConversation = "true",
	options = {}
}
ep3_etyyy_ryoo_finn_convo:addScreen(ep3_etyyy_ryoo_finn_convo_s_1220)

ep3_etyyy_ryoo_finn_convo_s_1179 = ConvoScreen:new {
	id = "s_1179",
	leftDialog = "@conversation/ep3_etyyy_ryoo_finn:s_1179", -- Johnson Smith has my salt. I wish I had it, but at least he gives me some now and then.
	stopConversation = "true",
	options = {}
}
ep3_etyyy_ryoo_finn_convo:addScreen(ep3_etyyy_ryoo_finn_convo_s_1179)

ep3_etyyy_ryoo_finn_convo_s_1222 = ConvoScreen:new {
	id = "s_1222",
	leftDialog = "@conversation/ep3_etyyy_ryoo_finn:s_1222", -- Please find my salt. Please. Oh please.
	stopConversation = "true",
	options = {}
}
ep3_etyyy_ryoo_finn_convo:addScreen(ep3_etyyy_ryoo_finn_convo_s_1222)

ep3_etyyy_ryoo_finn_convo_s_1197 = ConvoScreen:new {
	id = "s_1197",
	leftDialog = "@conversation/ep3_etyyy_ryoo_finn:s_1197", -- Please find my salt. Please.
	stopConversation = "true",
	options = {}
}
ep3_etyyy_ryoo_finn_convo:addScreen(ep3_etyyy_ryoo_finn_convo_s_1197)

ep3_etyyy_ryoo_finn_convo_s_1203 = ConvoScreen:new {
	id = "s_1203",
	animation = "greet",
	leftDialog = "@conversation/ep3_etyyy_ryoo_finn:s_1203", -- Argh. Who are you? What? Who? Oh man. I really need some salt. Johnson sent you? Good. No wait, that...
	stopConversation = "false",
	options = {
		{"@conversation/ep3_etyyy_ryoo_finn:s_1205", "s_1207"},
		{"@conversation/ep3_etyyy_ryoo_finn:s_1209", "s_1211"},
	}
}
ep3_etyyy_ryoo_finn_convo:addScreen(ep3_etyyy_ryoo_finn_convo_s_1203)

ep3_etyyy_ryoo_finn_convo_s_1213 = ConvoScreen:new {
	id = "s_1213",
	leftDialog = "@conversation/ep3_etyyy_ryoo_finn:s_1213", -- I don't know why I agreed to come here. I don't have a problem with salt. Really, I don't. Okay, may...
	stopConversation = "true",
	options = {}
}
ep3_etyyy_ryoo_finn_convo:addScreen(ep3_etyyy_ryoo_finn_convo_s_1213)

addConversationTemplate("ep3_etyyy_ryoo_finn_convo", ep3_etyyy_ryoo_finn_convo)
