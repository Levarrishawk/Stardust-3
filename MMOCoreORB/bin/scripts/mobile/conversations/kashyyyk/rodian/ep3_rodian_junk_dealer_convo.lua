-- ep3_rodian_junk_dealer
-- ruling 2026-09-04
-- Transcribed from the giver's java branches. Strings are shipped keys.
-- NO JOURNAL: this branch has no managers/quest/journal.lua. The client ships
-- the .qst; the journal row comes from the integration branch later.
-- s_54fab04f is on s_bef51e38 only; s_bef51e38_no_inv is the check_inv miss.

ep3_rodian_junk_dealer_convo = ConvoTemplate:new {
	initialScreen = "s_bef51e38",
	templateType = "Lua",
	luaClassHandler = "ep3_rodian_junk_dealer_conv_handler",
	screens = {}
}

ep3_rodian_junk_dealer_convo_s_bef51e38 = ConvoScreen:new {
	id = "s_bef51e38",
	leftDialog = "@conversation/ep3_rodian_junk_dealer:s_bef51e38", -- Welcome. Perhaps you have something on your person that you wish to sell. My company is interested in all sorts of goods
	stopConversation = "false",
	options = {
		{"@conversation/ep3_rodian_junk_dealer:s_54fab04f", "s_84a67771"},
		{"@conversation/ep3_rodian_junk_dealer:s_cd7a3f41", "s_4bd9d15e"},
	}
}
ep3_rodian_junk_dealer_convo:addScreen(ep3_rodian_junk_dealer_convo_s_bef51e38)

ep3_rodian_junk_dealer_convo_s_bef51e38_no_inv = ConvoScreen:new {
	id = "s_bef51e38_no_inv",
	leftDialog = "@conversation/ep3_rodian_junk_dealer:s_bef51e38", -- Welcome. Perhaps you have something on your person that you wish to sell. My company is interested in all sorts of goods
	stopConversation = "false",
	options = {
		{"@conversation/ep3_rodian_junk_dealer:s_cd7a3f41", "s_4bd9d15e"},
	}
}
ep3_rodian_junk_dealer_convo:addScreen(ep3_rodian_junk_dealer_convo_s_bef51e38_no_inv)

ep3_rodian_junk_dealer_convo_s_84a67771 = ConvoScreen:new {
	id = "s_84a67771",
	leftDialog = "@conversation/ep3_rodian_junk_dealer:s_84a67771", -- Alright, let me see what you are offering.
	stopConversation = "true",
	options = {}
}
ep3_rodian_junk_dealer_convo:addScreen(ep3_rodian_junk_dealer_convo_s_84a67771)

ep3_rodian_junk_dealer_convo_s_4bd9d15e = ConvoScreen:new {
	id = "s_4bd9d15e",
	leftDialog = "@conversation/ep3_rodian_junk_dealer:s_4bd9d15e", -- That is too bad. Remember to come visit me in the future if you happen to come across anything I would be interested in.
	stopConversation = "true",
	options = {}
}
ep3_rodian_junk_dealer_convo:addScreen(ep3_rodian_junk_dealer_convo_s_4bd9d15e)

addConversationTemplate("ep3_rodian_junk_dealer_convo", ep3_rodian_junk_dealer_convo)
