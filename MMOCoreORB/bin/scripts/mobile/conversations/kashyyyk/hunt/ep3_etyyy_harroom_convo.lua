-- ep3_etyyy_harroom -- Etyyy hunting-grounds ground conversation
-- ruling 2026-09-04: "ensure kashyyyk is fully done"
-- Transcribed from the giver's java branches. Strings are shipped keys.
-- The journal row for quest/ep3_hunt_*.qst comes from the integration branch later; do not call the journal engine.

ep3_etyyy_harroom_convo = ConvoTemplate:new {
	initialScreen = "s_294",
	templateType = "Lua",
	luaClassHandler = "ep3_etyyy_harroom_conv_handler",
	screens = {}
}

ep3_etyyy_harroom_convo_s_183 = ConvoScreen:new {
	id = "s_183",
	leftDialog = "@conversation/ep3_etyyy_harroom:s_183", -- Sordaan asked me to give you this Tchotchee Pistol. It's much nicer than most other flare pistols.
	stopConversation = "true",
	options = {}
}
ep3_etyyy_harroom_convo:addScreen(ep3_etyyy_harroom_convo_s_183)

ep3_etyyy_harroom_convo_s_185 = ConvoScreen:new {
	id = "s_185",
	leftDialog = "@conversation/ep3_etyyy_harroom:s_185", -- Sordaan asked me to give you this Kalranoos Carbine. I hope it serves you well as you continue hunti...
	stopConversation = "true",
	options = {}
}
ep3_etyyy_harroom_convo:addScreen(ep3_etyyy_harroom_convo_s_185)

ep3_etyyy_harroom_convo_s_187 = ConvoScreen:new {
	id = "s_187",
	leftDialog = "@conversation/ep3_etyyy_harroom:s_187", -- Sordaan asked me to give you this Xris Acid Sword. I designed the modifications to these myself, tho...
	stopConversation = "true",
	options = {}
}
ep3_etyyy_harroom_convo:addScreen(ep3_etyyy_harroom_convo_s_187)

ep3_etyyy_harroom_convo_s_189 = ConvoScreen:new {
	id = "s_189",
	leftDialog = "@conversation/ep3_etyyy_harroom:s_189", -- Sordaan asked me to give you this Fallann Hyper-Rifle. He must be quite impressed with your hunting ...
	stopConversation = "true",
	options = {}
}
ep3_etyyy_harroom_convo:addScreen(ep3_etyyy_harroom_convo_s_189)

ep3_etyyy_harroom_convo_s_294 = ConvoScreen:new {
	id = "s_294",
	leftDialog = "@conversation/ep3_etyyy_harroom:s_294", -- Hello, honorable hunter. Your presence here speaks well for your skills, but do be careful to be res...
	stopConversation = "true",
	options = {}
}
ep3_etyyy_harroom_convo:addScreen(ep3_etyyy_harroom_convo_s_294)

addConversationTemplate("ep3_etyyy_harroom_convo", ep3_etyyy_harroom_convo)
