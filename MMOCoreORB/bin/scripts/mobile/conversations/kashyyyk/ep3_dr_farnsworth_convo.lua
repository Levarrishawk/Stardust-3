-- Dr. Farnsworth -- ep3_kachirho_survey_data
-- ruling 2026-09-04: "ensure kashyyyk is done in full"
-- Transcribed from the giver's java branches. Strings are shipped keys.
-- The journal row for quest/ep3_kachirho_*.qst comes from the integration branch later; do not call Journal.*.

ep3_dr_farnsworth_convo = ConvoTemplate:new {
	initialScreen = "s_208",
	templateType = "Lua",
	luaClassHandler = "ep3_dr_farnsworth_conv_handler",
	screens = {}
}

ep3_dr_farnsworth_convo_s_194 = ConvoScreen:new {
	id = "s_194",
	animation = "goodbye",
	leftDialog = "@conversation/ep3_kachirho_dr_farnsworth:s_194", -- Thank you again for collecting my data for me. The things I am learning from this area are really quite extraordinary. Peace be with you.
	stopConversation = "true",
	options = {}
}
ep3_dr_farnsworth_convo:addScreen(ep3_dr_farnsworth_convo_s_194)

ep3_dr_farnsworth_convo_s_196 = ConvoScreen:new {
	id = "s_196",
	animation = "greet",
	leftDialog = "@conversation/ep3_kachirho_dr_farnsworth:s_196", -- You have returned. I am very pleased to see that nothing has happened to you. I was getting rather worried that you might have been injured recovering my dat...
	stopConversation = "false",
	options = {
		{"@conversation/ep3_kachirho_dr_farnsworth:s_198", "s_200"},
	}
}
ep3_dr_farnsworth_convo:addScreen(ep3_dr_farnsworth_convo_s_196)

ep3_dr_farnsworth_convo_s_202 = ConvoScreen:new {
	id = "s_202",
	animation = "greet",
	leftDialog = "@conversation/ep3_kachirho_dr_farnsworth:s_202", -- Hello again, traveler. Have you retrieved the data from all of the survey devices yet?
	stopConversation = "false",
	options = {
		{"@conversation/ep3_kachirho_dr_farnsworth:s_204", "s_206"},
	}
}
ep3_dr_farnsworth_convo:addScreen(ep3_dr_farnsworth_convo_s_202)

ep3_dr_farnsworth_convo_s_208 = ConvoScreen:new {
	id = "s_208",
	animation = "greet",
	leftDialog = "@conversation/ep3_kachirho_dr_farnsworth:s_208", -- Hello. I do not think I have ever seen you before. You must be new here on Kashyyyk. Welcome.
	stopConversation = "false",
	options = {
		{"@conversation/ep3_kachirho_dr_farnsworth:s_210", "s_212"},
	}
}
ep3_dr_farnsworth_convo:addScreen(ep3_dr_farnsworth_convo_s_208)

ep3_dr_farnsworth_convo_s_200 = ConvoScreen:new {
	id = "s_200",
	animation = "bow",
	leftDialog = "@conversation/ep3_kachirho_dr_farnsworth:s_200", -- What wonderful news. I hope you enjoyed your little tour of the areas around Kachirho. It is such nice country. I appreciate you helping a poor old doctor ou...
	stopConversation = "true",
	options = {}
}
ep3_dr_farnsworth_convo:addScreen(ep3_dr_farnsworth_convo_s_200)

ep3_dr_farnsworth_convo_s_206 = ConvoScreen:new {
	id = "s_206",
	animation = "bow",
	leftDialog = "@conversation/ep3_kachirho_dr_farnsworth:s_206", -- Thank you again for all of your help.
	stopConversation = "true",
	options = {}
}
ep3_dr_farnsworth_convo:addScreen(ep3_dr_farnsworth_convo_s_206)

ep3_dr_farnsworth_convo_s_212 = ConvoScreen:new {
	id = "s_212",
	animation = "embarrassed",
	leftDialog = "@conversation/ep3_kachirho_dr_farnsworth:s_212", -- Excuse me. I forgot my manners for a moment. I am Doctor Farnsworth and I am on Kashyyyk studying the local environment centered around Kachirho. A fascinati...
	stopConversation = "false",
	options = {
		{"@conversation/ep3_kachirho_dr_farnsworth:s_214", "s_216"},
	}
}
ep3_dr_farnsworth_convo:addScreen(ep3_dr_farnsworth_convo_s_212)

ep3_dr_farnsworth_convo_s_216 = ConvoScreen:new {
	id = "s_216",
	animation = "explain",
	leftDialog = "@conversation/ep3_kachirho_dr_farnsworth:s_216", -- I suspect that we are experiencing atmospheric interference. I would really like to get the data from my survey devices. Their memory banks are probably gett...
	stopConversation = "false",
	options = {
		{"@conversation/ep3_kachirho_dr_farnsworth:s_218", "s_220"},
		{"@conversation/ep3_kachirho_dr_farnsworth:s_226", "s_228"},
	}
}
ep3_dr_farnsworth_convo:addScreen(ep3_dr_farnsworth_convo_s_216)

ep3_dr_farnsworth_convo_s_220 = ConvoScreen:new {
	id = "s_220",
	animation = "clap_rousing",
	leftDialog = "@conversation/ep3_kachirho_dr_farnsworth:s_220", -- Would you really do that? I would be very grateful if you would. There are five different devices set up throughout the area. All you need to do is use these...
	stopConversation = "false",
	options = {
		{"@conversation/ep3_kachirho_dr_farnsworth:s_222", "s_224"},
	}
}
ep3_dr_farnsworth_convo:addScreen(ep3_dr_farnsworth_convo_s_220)

ep3_dr_farnsworth_convo_s_224 = ConvoScreen:new {
	id = "s_224",
	animation = "bow",
	leftDialog = "@conversation/ep3_kachirho_dr_farnsworth:s_224", -- Thank you. Just follow the instructions in your travel journal and all will be well.
	stopConversation = "true",
	options = {}
}
ep3_dr_farnsworth_convo:addScreen(ep3_dr_farnsworth_convo_s_224)

ep3_dr_farnsworth_convo_s_228 = ConvoScreen:new {
	id = "s_228",
	animation = "goodbye",
	leftDialog = "@conversation/ep3_kachirho_dr_farnsworth:s_228", -- Thank you. I will do my best. Peace be with you.
	stopConversation = "true",
	options = {}
}
ep3_dr_farnsworth_convo:addScreen(ep3_dr_farnsworth_convo_s_228)

addConversationTemplate("ep3_dr_farnsworth_convo", ep3_dr_farnsworth_convo)
