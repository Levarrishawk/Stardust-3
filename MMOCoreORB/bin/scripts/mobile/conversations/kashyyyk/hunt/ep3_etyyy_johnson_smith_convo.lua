-- ep3_etyyy_johnson_smith -- Etyyy hunting-grounds ground conversation
-- ruling 2026-09-04: "ensure kashyyyk is fully done"
-- Transcribed from the giver's java branches. Strings are shipped keys.
-- The journal row for quest/ep3_hunt_*.qst comes from the integration branch later; do not call the journal engine.

ep3_etyyy_johnson_smith_convo = ConvoTemplate:new {
	initialScreen = "s_239",
	templateType = "Lua",
	luaClassHandler = "ep3_etyyy_johnson_smith_conv_handler",
	screens = {}
}

ep3_etyyy_johnson_smith_convo_s_112 = ConvoScreen:new {
	id = "s_112",
	leftDialog = "@conversation/ep3_etyyy_johnson_smith:s_112", -- Right. Speak with Kint Szam at the Hracca glade gate camp. He'll help you. Tell him that I sent you ...
	stopConversation = "true",
	options = {}
}
ep3_etyyy_johnson_smith_convo:addScreen(ep3_etyyy_johnson_smith_convo_s_112)

ep3_etyyy_johnson_smith_convo_s_84 = ConvoScreen:new {
	id = "s_84",
	leftDialog = "@conversation/ep3_etyyy_johnson_smith:s_84", -- Yes, Sordaan has been trying to hunt a kkorrwrot but has been unsuccessful. The kkorrwrot is one of ...
	stopConversation = "false",
	options = {
		{"@conversation/ep3_etyyy_johnson_smith:s_122", "s_124"},
	}
}
ep3_etyyy_johnson_smith_convo:addScreen(ep3_etyyy_johnson_smith_convo_s_84)

ep3_etyyy_johnson_smith_convo_s_116 = ConvoScreen:new {
	id = "s_116",
	leftDialog = "@conversation/ep3_etyyy_johnson_smith:s_116", -- Excellent. Helping Kara has been a tremendous service. Thank you. I have one last task to ask of you...
	stopConversation = "false",
	options = {
		{"@conversation/ep3_etyyy_johnson_smith:s_118", "s_120"},
		{"@conversation/ep3_etyyy_johnson_smith:s_134", "s_136"},
	}
}
ep3_etyyy_johnson_smith_convo:addScreen(ep3_etyyy_johnson_smith_convo_s_116)

ep3_etyyy_johnson_smith_convo_s_138 = ConvoScreen:new {
	id = "s_138",
	leftDialog = "@conversation/ep3_etyyy_johnson_smith:s_138", -- Make the deliveries Kara needs. All of the deliveries. Speak to Kara if you need a reminder of where...
	stopConversation = "true",
	options = {}
}
ep3_etyyy_johnson_smith_convo:addScreen(ep3_etyyy_johnson_smith_convo_s_138)

ep3_etyyy_johnson_smith_convo_s_140 = ConvoScreen:new {
	id = "s_140",
	leftDialog = "@conversation/ep3_etyyy_johnson_smith:s_140", -- Kara is in one of the tents just here behind me. Go speak with her.
	stopConversation = "true",
	options = {}
}
ep3_etyyy_johnson_smith_convo:addScreen(ep3_etyyy_johnson_smith_convo_s_140)

ep3_etyyy_johnson_smith_convo_s_142 = ConvoScreen:new {
	id = "s_142",
	leftDialog = "@conversation/ep3_etyyy_johnson_smith:s_142", -- Oh la la la.
	stopConversation = "true",
	options = {}
}
ep3_etyyy_johnson_smith_convo:addScreen(ep3_etyyy_johnson_smith_convo_s_142)

ep3_etyyy_johnson_smith_convo_s_146 = ConvoScreen:new {
	id = "s_146",
	leftDialog = "@conversation/ep3_etyyy_johnson_smith:s_146", -- Ah, you retrieved his stash of salt. It was a good idea to come to me with this instead of going bac...
	stopConversation = "false",
	options = {
		{"@conversation/ep3_etyyy_johnson_smith:s_148", "s_150"},
		{"@conversation/ep3_etyyy_johnson_smith:s_152", "s_154"},
	}
}
ep3_etyyy_johnson_smith_convo:addScreen(ep3_etyyy_johnson_smith_convo_s_146)

ep3_etyyy_johnson_smith_convo_s_156 = ConvoScreen:new {
	id = "s_156",
	leftDialog = "@conversation/ep3_etyyy_johnson_smith:s_156", -- Ryoo Finn is down at the main Arcona camp area. Look for the Arcona in a blue shirt and red short pa...
	stopConversation = "true",
	options = {}
}
ep3_etyyy_johnson_smith_convo:addScreen(ep3_etyyy_johnson_smith_convo_s_156)

ep3_etyyy_johnson_smith_convo_s_158 = ConvoScreen:new {
	id = "s_158",
	leftDialog = "@conversation/ep3_etyyy_johnson_smith:s_158", -- Do be do be do.
	stopConversation = "true",
	options = {}
}
ep3_etyyy_johnson_smith_convo:addScreen(ep3_etyyy_johnson_smith_convo_s_158)

ep3_etyyy_johnson_smith_convo_s_162 = ConvoScreen:new {
	id = "s_162",
	leftDialog = "@conversation/ep3_etyyy_johnson_smith:s_162", -- Oh, you're back. I hope Mada wasn't too distraught. Must have been rough news for her to hear.
	stopConversation = "false",
	options = {
		{"@conversation/ep3_etyyy_johnson_smith:s_164", "s_166"},
	}
}
ep3_etyyy_johnson_smith_convo:addScreen(ep3_etyyy_johnson_smith_convo_s_162)

ep3_etyyy_johnson_smith_convo_s_210 = ConvoScreen:new {
	id = "s_210",
	leftDialog = "@conversation/ep3_etyyy_johnson_smith:s_210", -- Mada Johnson is probably still in Kachirho. That's where you first spoke with her, right? Go tell he...
	stopConversation = "true",
	options = {}
}
ep3_etyyy_johnson_smith_convo:addScreen(ep3_etyyy_johnson_smith_convo_s_210)

ep3_etyyy_johnson_smith_convo_s_212 = ConvoScreen:new {
	id = "s_212",
	leftDialog = "@conversation/ep3_etyyy_johnson_smith:s_212", -- Any luck at the campsite?
	stopConversation = "false",
	options = {
		{"@conversation/ep3_etyyy_johnson_smith:s_214", "s_216"},
		{"@conversation/ep3_etyyy_johnson_smith:s_218", "s_220"},
	}
}
ep3_etyyy_johnson_smith_convo:addScreen(ep3_etyyy_johnson_smith_convo_s_212)

ep3_etyyy_johnson_smith_convo_s_223 = ConvoScreen:new {
	id = "s_223",
	animation = "greet",
	leftDialog = "@conversation/ep3_etyyy_johnson_smith:s_223", -- Brody's campsite is south of here near the river.
	stopConversation = "true",
	options = {}
}
ep3_etyyy_johnson_smith_convo:addScreen(ep3_etyyy_johnson_smith_convo_s_223)

ep3_etyyy_johnson_smith_convo_s_227 = ConvoScreen:new {
	id = "s_227",
	leftDialog = "@conversation/ep3_etyyy_johnson_smith:s_227", -- Okee oodle eh.
	stopConversation = "true",
	options = {}
}
ep3_etyyy_johnson_smith_convo:addScreen(ep3_etyyy_johnson_smith_convo_s_227)

ep3_etyyy_johnson_smith_convo_s_267 = ConvoScreen:new {
	id = "s_267",
	leftDialog = "@conversation/ep3_etyyy_johnson_smith:s_267", -- Ah, good. There are some things you could help with. Um, but actually, I could use some help with an...
	stopConversation = "false",
	options = {
		{"@conversation/ep3_etyyy_johnson_smith:s_269", "s_271"},
		{"@conversation/ep3_etyyy_johnson_smith:s_273", "s_275"},
	}
}
ep3_etyyy_johnson_smith_convo:addScreen(ep3_etyyy_johnson_smith_convo_s_267)

ep3_etyyy_johnson_smith_convo_s_251 = ConvoScreen:new {
	id = "s_251",
	leftDialog = "@conversation/ep3_etyyy_johnson_smith:s_251", -- Brody Johnson? I remember him. Haven't seen him in a while though. Why are you looking for Brody? Is...
	stopConversation = "false",
	options = {
		{"@conversation/ep3_etyyy_johnson_smith:s_253", "s_255"},
	}
}
ep3_etyyy_johnson_smith_convo:addScreen(ep3_etyyy_johnson_smith_convo_s_251)

ep3_etyyy_johnson_smith_convo_s_124 = ConvoScreen:new {
	id = "s_124",
	leftDialog = "@conversation/ep3_etyyy_johnson_smith:s_124", -- Here in Etyyy actually, in the Hracca glade. I have a contact in the Hracca glade gate camp that can...
	stopConversation = "false",
	options = {
		{"@conversation/ep3_etyyy_johnson_smith:s_126", "s_128"},
		{"@conversation/ep3_etyyy_johnson_smith:s_130", "s_132"},
	}
}
ep3_etyyy_johnson_smith_convo:addScreen(ep3_etyyy_johnson_smith_convo_s_124)

ep3_etyyy_johnson_smith_convo_s_120 = ConvoScreen:new {
	id = "s_120",
	leftDialog = "@conversation/ep3_etyyy_johnson_smith:s_120", -- Sordaan has been trying to hunt a kkorrwrot but has been unsuccessful. The kkorrwrot is one of the m...
	stopConversation = "false",
	options = {
		{"@conversation/ep3_etyyy_johnson_smith:s_122", "s_124"},
	}
}
ep3_etyyy_johnson_smith_convo:addScreen(ep3_etyyy_johnson_smith_convo_s_120)

ep3_etyyy_johnson_smith_convo_s_136 = ConvoScreen:new {
	id = "s_136",
	leftDialog = "@conversation/ep3_etyyy_johnson_smith:s_136", -- Very well. Return when you're ready.
	stopConversation = "true",
	options = {}
}
ep3_etyyy_johnson_smith_convo:addScreen(ep3_etyyy_johnson_smith_convo_s_136)

ep3_etyyy_johnson_smith_convo_s_128 = ConvoScreen:new {
	id = "s_128",
	leftDialog = "@conversation/ep3_etyyy_johnson_smith:s_128", -- Good. Speak with Kint. He'll not only tell you more about hunting the kkorrwrot, but he can also get...
	stopConversation = "true",
	options = {}
}
ep3_etyyy_johnson_smith_convo:addScreen(ep3_etyyy_johnson_smith_convo_s_128)

ep3_etyyy_johnson_smith_convo_s_132 = ConvoScreen:new {
	id = "s_132",
	leftDialog = "@conversation/ep3_etyyy_johnson_smith:s_132", -- Very well. Return when you're ready.
	stopConversation = "true",
	options = {}
}
ep3_etyyy_johnson_smith_convo:addScreen(ep3_etyyy_johnson_smith_convo_s_132)

ep3_etyyy_johnson_smith_convo_s_150 = ConvoScreen:new {
	id = "s_150",
	leftDialog = "@conversation/ep3_etyyy_johnson_smith:s_150", -- Great! She's in the tent behind me. Go speak with her.
	stopConversation = "true",
	options = {}
}
ep3_etyyy_johnson_smith_convo:addScreen(ep3_etyyy_johnson_smith_convo_s_150)

ep3_etyyy_johnson_smith_convo_s_154 = ConvoScreen:new {
	id = "s_154",
	leftDialog = "@conversation/ep3_etyyy_johnson_smith:s_154", -- Okay, return when you can.
	stopConversation = "true",
	options = {}
}
ep3_etyyy_johnson_smith_convo:addScreen(ep3_etyyy_johnson_smith_convo_s_154)

ep3_etyyy_johnson_smith_convo_s_166 = ConvoScreen:new {
	id = "s_166",
	leftDialog = "@conversation/ep3_etyyy_johnson_smith:s_166", -- What? No, she's mistaken. Go show it to her again.
	stopConversation = "false",
	options = {
		{"@conversation/ep3_etyyy_johnson_smith:s_168", "s_170"},
	}
}
ep3_etyyy_johnson_smith_convo:addScreen(ep3_etyyy_johnson_smith_convo_s_166)

ep3_etyyy_johnson_smith_convo_s_170 = ConvoScreen:new {
	id = "s_170",
	leftDialog = "@conversation/ep3_etyyy_johnson_smith:s_170", -- This old thing? No, it's nothing really. It's just something I picked up somewhere. Cheap. Not even ...
	stopConversation = "false",
	options = {
		{"@conversation/ep3_etyyy_johnson_smith:s_172", "s_174"},
		{"@conversation/ep3_etyyy_johnson_smith:s_176", "s_178"},
	}
}
ep3_etyyy_johnson_smith_convo:addScreen(ep3_etyyy_johnson_smith_convo_s_170)

ep3_etyyy_johnson_smith_convo_s_174 = ConvoScreen:new {
	id = "s_174",
	leftDialog = "@conversation/ep3_etyyy_johnson_smith:s_174", -- Right. Good. Of course you do. Why wouldn't you? Good.
	stopConversation = "true",
	options = {}
}
ep3_etyyy_johnson_smith_convo:addScreen(ep3_etyyy_johnson_smith_convo_s_174)

ep3_etyyy_johnson_smith_convo_s_178 = ConvoScreen:new {
	id = "s_178",
	leftDialog = "@conversation/ep3_etyyy_johnson_smith:s_178", -- Okay, okay. I can't believe Mada could tell that other pendant was a fake. The truth is... I'm Brody...
	stopConversation = "false",
	options = {
		{"@conversation/ep3_etyyy_johnson_smith:s_180", "s_182"},
		{"@conversation/ep3_etyyy_johnson_smith:s_200", "s_202"},
	}
}
ep3_etyyy_johnson_smith_convo:addScreen(ep3_etyyy_johnson_smith_convo_s_178)

ep3_etyyy_johnson_smith_convo_s_182 = ConvoScreen:new {
	id = "s_182",
	leftDialog = "@conversation/ep3_etyyy_johnson_smith:s_182", -- I came here originally to try and tame creatures here and sell them as pets on other planets. But cr...
	stopConversation = "false",
	options = {
		{"@conversation/ep3_etyyy_johnson_smith:s_184", "s_186"},
	}
}
ep3_etyyy_johnson_smith_convo:addScreen(ep3_etyyy_johnson_smith_convo_s_182)

ep3_etyyy_johnson_smith_convo_s_202 = ConvoScreen:new {
	id = "s_202",
	leftDialog = "@conversation/ep3_etyyy_johnson_smith:s_202", -- Really, you have?
	stopConversation = "false",
	options = {
		{"@conversation/ep3_etyyy_johnson_smith:s_204", "s_206"},
	}
}
ep3_etyyy_johnson_smith_convo:addScreen(ep3_etyyy_johnson_smith_convo_s_202)

ep3_etyyy_johnson_smith_convo_s_186 = ConvoScreen:new {
	id = "s_186",
	leftDialog = "@conversation/ep3_etyyy_johnson_smith:s_186", -- Right. So with the pet idea not working out, I was once again a failure. This kind of thing has happ...
	stopConversation = "false",
	options = {
		{"@conversation/ep3_etyyy_johnson_smith:s_188", "s_190"},
	}
}
ep3_etyyy_johnson_smith_convo:addScreen(ep3_etyyy_johnson_smith_convo_s_186)

ep3_etyyy_johnson_smith_convo_s_190 = ConvoScreen:new {
	id = "s_190",
	leftDialog = "@conversation/ep3_etyyy_johnson_smith:s_190", -- I admit that was a bad idea. I just kind of reacted and didn't really think things through all the w...
	stopConversation = "false",
	options = {
		{"@conversation/ep3_etyyy_johnson_smith:s_192", "s_194"},
	}
}
ep3_etyyy_johnson_smith_convo:addScreen(ep3_etyyy_johnson_smith_convo_s_190)

ep3_etyyy_johnson_smith_convo_s_194 = ConvoScreen:new {
	id = "s_194",
	leftDialog = "@conversation/ep3_etyyy_johnson_smith:s_194", -- Right. If you go to the Trail and travel a little way from the gate, you'll find his house. It's nea...
	stopConversation = "false",
	options = {
		{"@conversation/ep3_etyyy_johnson_smith:s_196", "s_198"},
	}
}
ep3_etyyy_johnson_smith_convo:addScreen(ep3_etyyy_johnson_smith_convo_s_194)

ep3_etyyy_johnson_smith_convo_s_198 = ConvoScreen:new {
	id = "s_198",
	leftDialog = "@conversation/ep3_etyyy_johnson_smith:s_198", -- Farewell.
	stopConversation = "true",
	options = {}
}
ep3_etyyy_johnson_smith_convo:addScreen(ep3_etyyy_johnson_smith_convo_s_198)

ep3_etyyy_johnson_smith_convo_s_206 = ConvoScreen:new {
	id = "s_206",
	leftDialog = "@conversation/ep3_etyyy_johnson_smith:s_206", -- Oh. I see. But it was easier for me to remember than something like Merrick Chi'thiac.
	stopConversation = "false",
	options = {
		{"@conversation/ep3_etyyy_johnson_smith:s_208", "s_182"},
	}
}
ep3_etyyy_johnson_smith_convo:addScreen(ep3_etyyy_johnson_smith_convo_s_206)

ep3_etyyy_johnson_smith_convo_s_216 = ConvoScreen:new {
	id = "s_216",
	leftDialog = "@conversation/ep3_etyyy_johnson_smith:s_216", -- You found this on a corpse at the campsite? Hmm, that's bad news. This was definitely Brody's pendan...
	stopConversation = "true",
	options = {}
}
ep3_etyyy_johnson_smith_convo:addScreen(ep3_etyyy_johnson_smith_convo_s_216)

ep3_etyyy_johnson_smith_convo_s_220 = ConvoScreen:new {
	id = "s_220",
	leftDialog = "@conversation/ep3_etyyy_johnson_smith:s_220", -- That's too bad. You should have tried harder.
	stopConversation = "true",
	options = {}
}
ep3_etyyy_johnson_smith_convo:addScreen(ep3_etyyy_johnson_smith_convo_s_220)

ep3_etyyy_johnson_smith_convo_s_245 = ConvoScreen:new {
	id = "s_245",
	leftDialog = "@conversation/ep3_etyyy_johnson_smith:s_245", -- I see. Why did he send you to me exactly?
	stopConversation = "false",
	options = {
		{"@conversation/ep3_etyyy_johnson_smith:s_249", "s_251"},
		{"@conversation/ep3_etyyy_johnson_smith:s_265", "s_267"},
	}
}
ep3_etyyy_johnson_smith_convo:addScreen(ep3_etyyy_johnson_smith_convo_s_245)

ep3_etyyy_johnson_smith_convo_s_281 = ConvoScreen:new {
	id = "s_281",
	leftDialog = "@conversation/ep3_etyyy_johnson_smith:s_281", -- Yeah, good bye.
	stopConversation = "true",
	options = {}
}
ep3_etyyy_johnson_smith_convo:addScreen(ep3_etyyy_johnson_smith_convo_s_281)

ep3_etyyy_johnson_smith_convo_s_255 = ConvoScreen:new {
	id = "s_255",
	leftDialog = "@conversation/ep3_etyyy_johnson_smith:s_255", -- I think he had a small campsite not far from here. I haven't seen him in a while though. Been a few ...
	stopConversation = "false",
	options = {
		{"@conversation/ep3_etyyy_johnson_smith:s_257", "s_259"},
		{"@conversation/ep3_etyyy_johnson_smith:s_261", "s_263"},
	}
}
ep3_etyyy_johnson_smith_convo:addScreen(ep3_etyyy_johnson_smith_convo_s_255)

ep3_etyyy_johnson_smith_convo_s_259 = ConvoScreen:new {
	id = "s_259",
	leftDialog = "@conversation/ep3_etyyy_johnson_smith:s_259", -- Okay. And if you don't mind, please come back here and let me know if you find any sign of him.
	stopConversation = "true",
	options = {}
}
ep3_etyyy_johnson_smith_convo:addScreen(ep3_etyyy_johnson_smith_convo_s_259)

ep3_etyyy_johnson_smith_convo_s_263 = ConvoScreen:new {
	id = "s_263",
	leftDialog = "@conversation/ep3_etyyy_johnson_smith:s_263", -- Whatever you want.
	stopConversation = "true",
	options = {}
}
ep3_etyyy_johnson_smith_convo:addScreen(ep3_etyyy_johnson_smith_convo_s_263)

ep3_etyyy_johnson_smith_convo_s_271 = ConvoScreen:new {
	id = "s_271",
	leftDialog = "@conversation/ep3_etyyy_johnson_smith:s_271", -- Great! Ryoo is down in the main camp. He should be easy to find; Ryoo is the only Arcona not wearing...
	stopConversation = "true",
	options = {}
}
ep3_etyyy_johnson_smith_convo:addScreen(ep3_etyyy_johnson_smith_convo_s_271)

ep3_etyyy_johnson_smith_convo_s_275 = ConvoScreen:new {
	id = "s_275",
	leftDialog = "@conversation/ep3_etyyy_johnson_smith:s_275", -- I thought you were here to help? Oh well, return if you change your mind.
	stopConversation = "true",
	options = {}
}
ep3_etyyy_johnson_smith_convo:addScreen(ep3_etyyy_johnson_smith_convo_s_275)

ep3_etyyy_johnson_smith_convo_s_106 = ConvoScreen:new {
	id = "s_106",
	leftDialog = "@conversation/ep3_etyyy_johnson_smith:s_106", -- Thanks for your help, especially with Mada. It's good to have her to talk with. I don't know what I ...
	stopConversation = "true",
	options = {}
}
ep3_etyyy_johnson_smith_convo:addScreen(ep3_etyyy_johnson_smith_convo_s_106)

ep3_etyyy_johnson_smith_convo_s_108 = ConvoScreen:new {
	id = "s_108",
	leftDialog = "@conversation/ep3_etyyy_johnson_smith:s_108", -- You're back again. What can I help you with?
	stopConversation = "false",
	options = {
		{"@conversation/ep3_etyyy_johnson_smith:s_110", "s_112"},
		{"@conversation/ep3_etyyy_johnson_smith:s_83", "s_84"},
		{"@conversation/ep3_etyyy_johnson_smith:s_114", "s_142"},
		{"@conversation/ep3_etyyy_johnson_smith:s_144", "s_158"},
		{"@conversation/ep3_etyyy_johnson_smith:s_160", "s_227"},
		{"@conversation/ep3_etyyy_johnson_smith:s_231", "s_267"},
		{"@conversation/ep3_etyyy_johnson_smith:s_235", "s_251"},
	}
}
ep3_etyyy_johnson_smith_convo:addScreen(ep3_etyyy_johnson_smith_convo_s_108)

ep3_etyyy_johnson_smith_convo_s_239 = ConvoScreen:new {
	id = "s_239",
	leftDialog = "@conversation/ep3_etyyy_johnson_smith:s_239", -- I'm busy right now. These people need a lot of attention to get through their tough battle against s...
	stopConversation = "false",
	options = {
		{"@conversation/ep3_etyyy_johnson_smith:s_243", "s_245"},
		{"@conversation/ep3_etyyy_johnson_smith:s_279", "s_281"},
	}
}
ep3_etyyy_johnson_smith_convo:addScreen(ep3_etyyy_johnson_smith_convo_s_239)

addConversationTemplate("ep3_etyyy_johnson_smith_convo", ep3_etyyy_johnson_smith_convo)
