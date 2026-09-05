-- ep3_etyyy_kint_zsam -- Etyyy hunting-grounds ground conversation
-- ruling 2026-09-04: "ensure kashyyyk is fully done"
-- Transcribed from the giver's java branches. Strings are shipped keys.
-- The journal row for quest/ep3_hunt_*.qst comes from the integration branch later; do not call the journal engine.

ep3_etyyy_kint_zsam_convo = ConvoTemplate:new {
	initialScreen = "s_203",
	templateType = "Lua",
	luaClassHandler = "ep3_etyyy_kint_zsam_conv_handler",
	screens = {}
}

ep3_etyyy_kint_zsam_convo_s_187 = ConvoScreen:new {
	id = "s_187",
	leftDialog = "@conversation/ep3_etyyy_kint_zsam:s_187", -- Okay, just... wait. I mentioned this before, but it looks like you didn't understand. You can only h...
	stopConversation = "true",
	options = {}
}
ep3_etyyy_kint_zsam_convo:addScreen(ep3_etyyy_kint_zsam_convo_s_187)

ep3_etyyy_kint_zsam_convo_s_189 = ConvoScreen:new {
	id = "s_189",
	leftDialog = "@conversation/ep3_etyyy_kint_zsam:s_189", -- Very well. Remember, you'll have to rid the glade of Chiss poachers before the kkorrwrot will return...
	stopConversation = "false",
	options = {
		{"@conversation/ep3_etyyy_kint_zsam:s_257", "s_259"},
	}
}
ep3_etyyy_kint_zsam_convo:addScreen(ep3_etyyy_kint_zsam_convo_s_189)

ep3_etyyy_kint_zsam_convo_s_380 = ConvoScreen:new {
	id = "s_380",
	leftDialog = "@conversation/ep3_etyyy_kint_zsam:s_380", -- Ah yes. Sordaan was being stubborn about awarding those. Seems he was reluctant to acknowledge that ...
	stopConversation = "false",
	options = {
		{"@conversation/ep3_etyyy_kint_zsam:s_381", "s_382"},
		{"@conversation/ep3_etyyy_kint_zsam:s_383", "s_384"},
	}
}
ep3_etyyy_kint_zsam_convo:addScreen(ep3_etyyy_kint_zsam_convo_s_380)

ep3_etyyy_kint_zsam_convo_s_193 = ConvoScreen:new {
	id = "s_193",
	leftDialog = "@conversation/ep3_etyyy_kint_zsam:s_193", -- I'm impressed. Seriously. You're a much better hunter than I thought you were. Well done.
	stopConversation = "true",
	options = {}
}
ep3_etyyy_kint_zsam_convo:addScreen(ep3_etyyy_kint_zsam_convo_s_193)

ep3_etyyy_kint_zsam_convo_s_197 = ConvoScreen:new {
	id = "s_197",
	leftDialog = "@conversation/ep3_etyyy_kint_zsam:s_197", -- Okay, here's another gate pass. Talk to me again when you're ready to enter.
	stopConversation = "true",
	options = {}
}
ep3_etyyy_kint_zsam_convo:addScreen(ep3_etyyy_kint_zsam_convo_s_197)

ep3_etyyy_kint_zsam_convo_s_201 = ConvoScreen:new {
	id = "s_201",
	leftDialog = "@conversation/ep3_etyyy_kint_zsam:s_201", -- Ah, good. Don't let me stop you from continuing to wander.
	stopConversation = "true",
	options = {}
}
ep3_etyyy_kint_zsam_convo:addScreen(ep3_etyyy_kint_zsam_convo_s_201)

ep3_etyyy_kint_zsam_convo_s_259 = ConvoScreen:new {
	id = "s_259",
	leftDialog = "@conversation/ep3_etyyy_kint_zsam:s_259", -- Right. Away you go. Oh, and good hunting to you.
	stopConversation = "true",
	options = {}
}
ep3_etyyy_kint_zsam_convo:addScreen(ep3_etyyy_kint_zsam_convo_s_259)

ep3_etyyy_kint_zsam_convo_s_382 = ConvoScreen:new {
	id = "s_382",
	leftDialog = "@conversation/ep3_etyyy_kint_zsam:s_382", -- You're welcome.
	stopConversation = "true",
	options = {}
}
ep3_etyyy_kint_zsam_convo:addScreen(ep3_etyyy_kint_zsam_convo_s_382)

ep3_etyyy_kint_zsam_convo_s_384 = ConvoScreen:new {
	id = "s_384",
	leftDialog = "@conversation/ep3_etyyy_kint_zsam:s_384", -- It's about... Oh, look at that. Your badge fell off. What a shame.
	stopConversation = "true",
	options = {}
}
ep3_etyyy_kint_zsam_convo:addScreen(ep3_etyyy_kint_zsam_convo_s_384)

ep3_etyyy_kint_zsam_convo_s_208 = ConvoScreen:new {
	id = "s_208",
	leftDialog = "@conversation/ep3_etyyy_kint_zsam:s_208", -- Good luck with that, because you can't enter the glade.
	stopConversation = "true",
	options = {}
}
ep3_etyyy_kint_zsam_convo:addScreen(ep3_etyyy_kint_zsam_convo_s_208)

ep3_etyyy_kint_zsam_convo_s_212 = ConvoScreen:new {
	id = "s_212",
	leftDialog = "@conversation/ep3_etyyy_kint_zsam:s_212", -- Johnson Smith sent you?
	stopConversation = "false",
	options = {
		{"@conversation/ep3_etyyy_kint_zsam:s_215", "s_217"},
	}
}
ep3_etyyy_kint_zsam_convo:addScreen(ep3_etyyy_kint_zsam_convo_s_212)

ep3_etyyy_kint_zsam_convo_s_284 = ConvoScreen:new {
	id = "s_284",
	leftDialog = "@conversation/ep3_etyyy_kint_zsam:s_284", -- No. Go away.
	stopConversation = "true",
	options = {}
}
ep3_etyyy_kint_zsam_convo:addScreen(ep3_etyyy_kint_zsam_convo_s_284)

ep3_etyyy_kint_zsam_convo_s_290 = ConvoScreen:new {
	id = "s_290",
	leftDialog = "@conversation/ep3_etyyy_kint_zsam:s_290", -- Good, because you can't.
	stopConversation = "false",
	options = {
		{"@conversation/ep3_etyyy_kint_zsam:s_293", "s_295"},
	}
}
ep3_etyyy_kint_zsam_convo:addScreen(ep3_etyyy_kint_zsam_convo_s_290)

ep3_etyyy_kint_zsam_convo_s_303 = ConvoScreen:new {
	id = "s_303",
	leftDialog = "@conversation/ep3_etyyy_kint_zsam:s_303", -- Thank you for understanding. Farewell.
	stopConversation = "true",
	options = {}
}
ep3_etyyy_kint_zsam_convo:addScreen(ep3_etyyy_kint_zsam_convo_s_303)

ep3_etyyy_kint_zsam_convo_s_217 = ConvoScreen:new {
	id = "s_217",
	leftDialog = "@conversation/ep3_etyyy_kint_zsam:s_217", -- Where were the two of you when you spoke with him?
	stopConversation = "false",
	options = {
		{"@conversation/ep3_etyyy_kint_zsam:s_219", "s_221"},
		{"@conversation/ep3_etyyy_kint_zsam:s_223", "s_225"},
		{"@conversation/ep3_etyyy_kint_zsam:s_268", "s_270"},
		{"@conversation/ep3_etyyy_kint_zsam:s_273", "s_275"},
		{"@conversation/ep3_etyyy_kint_zsam:s_277", "s_279"},
	}
}
ep3_etyyy_kint_zsam_convo:addScreen(ep3_etyyy_kint_zsam_convo_s_217)

ep3_etyyy_kint_zsam_convo_s_221 = ConvoScreen:new {
	id = "s_221",
	leftDialog = "@conversation/ep3_etyyy_kint_zsam:s_221", -- Nice try, but I know for a fact that he's avoiding Kachirho because of his... wait. Almost said too ...
	stopConversation = "true",
	options = {}
}
ep3_etyyy_kint_zsam_convo:addScreen(ep3_etyyy_kint_zsam_convo_s_221)

ep3_etyyy_kint_zsam_convo_s_225 = ConvoScreen:new {
	id = "s_225",
	leftDialog = "@conversation/ep3_etyyy_kint_zsam:s_225", -- Hmmm. Fair enough. And what did he have you doing for the Chiss poacher, Lara Corlon?
	stopConversation = "false",
	options = {
		{"@conversation/ep3_etyyy_kint_zsam:s_227", "s_229"},
		{"@conversation/ep3_etyyy_kint_zsam:s_231", "s_233"},
		{"@conversation/ep3_etyyy_kint_zsam:s_235", "s_237"},
	}
}
ep3_etyyy_kint_zsam_convo:addScreen(ep3_etyyy_kint_zsam_convo_s_225)

ep3_etyyy_kint_zsam_convo_s_270 = ConvoScreen:new {
	id = "s_270",
	animation = "belly_laugh",
	leftDialog = "@conversation/ep3_etyyy_kint_zsam:s_270", -- Oh yeah, Sordaan and Smith are old friends. I'll bet they were talking about the good old days and j...
	stopConversation = "true",
	options = {}
}
ep3_etyyy_kint_zsam_convo:addScreen(ep3_etyyy_kint_zsam_convo_s_270)

ep3_etyyy_kint_zsam_convo_s_275 = ConvoScreen:new {
	id = "s_275",
	leftDialog = "@conversation/ep3_etyyy_kint_zsam:s_275", -- You should go back and finish your drink.
	stopConversation = "true",
	options = {}
}
ep3_etyyy_kint_zsam_convo:addScreen(ep3_etyyy_kint_zsam_convo_s_275)

ep3_etyyy_kint_zsam_convo_s_279 = ConvoScreen:new {
	id = "s_279",
	leftDialog = "@conversation/ep3_etyyy_kint_zsam:s_279", -- That's funny, because I don't remember how to help you. Imagine.
	stopConversation = "true",
	options = {}
}
ep3_etyyy_kint_zsam_convo:addScreen(ep3_etyyy_kint_zsam_convo_s_279)

ep3_etyyy_kint_zsam_convo_s_229 = ConvoScreen:new {
	id = "s_229",
	leftDialog = "@conversation/ep3_etyyy_kint_zsam:s_229", -- Whoa! I hope not. Er, oops. What I mean is what do I care what happens to a poacher. Good riddance.
	stopConversation = "true",
	options = {}
}
ep3_etyyy_kint_zsam_convo:addScreen(ep3_etyyy_kint_zsam_convo_s_229)

ep3_etyyy_kint_zsam_convo_s_233 = ConvoScreen:new {
	id = "s_233",
	leftDialog = "@conversation/ep3_etyyy_kint_zsam:s_233", -- How nice. Never heard of her personally, but I'm sure you two will have a nice future working togeth...
	stopConversation = "true",
	options = {}
}
ep3_etyyy_kint_zsam_convo:addScreen(ep3_etyyy_kint_zsam_convo_s_233)

ep3_etyyy_kint_zsam_convo_s_237 = ConvoScreen:new {
	id = "s_237",
	leftDialog = "@conversation/ep3_etyyy_kint_zsam:s_237", -- Yeah, okay. Good enough. I can help you enter the Hracca Glade and hunt a kkorrwrot. But you should ...
	stopConversation = "false",
	options = {
		{"@conversation/ep3_etyyy_kint_zsam:s_239", "s_241"},
	}
}
ep3_etyyy_kint_zsam_convo:addScreen(ep3_etyyy_kint_zsam_convo_s_237)

ep3_etyyy_kint_zsam_convo_s_241 = ConvoScreen:new {
	id = "s_241",
	leftDialog = "@conversation/ep3_etyyy_kint_zsam:s_241", -- Correct. After you do that, the contaminated air should dissipate, and it shouldn't take long for a ...
	stopConversation = "false",
	options = {
		{"@conversation/ep3_etyyy_kint_zsam:s_243", "s_246"},
	}
}
ep3_etyyy_kint_zsam_convo:addScreen(ep3_etyyy_kint_zsam_convo_s_241)

ep3_etyyy_kint_zsam_convo_s_246 = ConvoScreen:new {
	id = "s_246",
	leftDialog = "@conversation/ep3_etyyy_kint_zsam:s_246", -- Good. There are two other things you'll need to know. First of all, you can only have up to 8 hunter...
	stopConversation = "false",
	options = {
		{"@conversation/ep3_etyyy_kint_zsam:s_250", "s_258"},
		{"@conversation/ep3_etyyy_kint_zsam:s_262", "s_266"},
	}
}
ep3_etyyy_kint_zsam_convo:addScreen(ep3_etyyy_kint_zsam_convo_s_246)

ep3_etyyy_kint_zsam_convo_s_254 = ConvoScreen:new {
	id = "s_254",
	leftDialog = "@conversation/ep3_etyyy_kint_zsam:s_254", -- You'll need to give your gate pass to me when you're ready to enter the glade. It's a forged pass, b...
	stopConversation = "true",
	options = {}
}
ep3_etyyy_kint_zsam_convo:addScreen(ep3_etyyy_kint_zsam_convo_s_254)

ep3_etyyy_kint_zsam_convo_s_258 = ConvoScreen:new {
	id = "s_258",
	leftDialog = "@conversation/ep3_etyyy_kint_zsam:s_258", -- Just one. Here's a gate pass. You'll need to give this to me when you're ready to enter the glade. I...
	stopConversation = "true",
	options = {}
}
ep3_etyyy_kint_zsam_convo:addScreen(ep3_etyyy_kint_zsam_convo_s_258)

ep3_etyyy_kint_zsam_convo_s_266 = ConvoScreen:new {
	id = "s_266",
	leftDialog = "@conversation/ep3_etyyy_kint_zsam:s_266", -- Yeah. Sure. Whatever.
	stopConversation = "true",
	options = {}
}
ep3_etyyy_kint_zsam_convo:addScreen(ep3_etyyy_kint_zsam_convo_s_266)

ep3_etyyy_kint_zsam_convo_s_295 = ConvoScreen:new {
	id = "s_295",
	leftDialog = "@conversation/ep3_etyyy_kint_zsam:s_295", -- Good.
	stopConversation = "false",
	options = {
		{"@conversation/ep3_etyyy_kint_zsam:s_297", "s_299"},
	}
}
ep3_etyyy_kint_zsam_convo:addScreen(ep3_etyyy_kint_zsam_convo_s_295)

ep3_etyyy_kint_zsam_convo_s_299 = ConvoScreen:new {
	id = "s_299",
	leftDialog = "@conversation/ep3_etyyy_kint_zsam:s_299", -- Stop. Now.
	stopConversation = "true",
	options = {}
}
ep3_etyyy_kint_zsam_convo:addScreen(ep3_etyyy_kint_zsam_convo_s_299)

ep3_etyyy_kint_zsam_convo_s_183 = ConvoScreen:new {
	id = "s_183",
	leftDialog = "@conversation/ep3_etyyy_kint_zsam:s_183", -- Ah yes, I remember you. %TO wasn't it? What can I do for you?
	stopConversation = "false",
	options = {
		{"@conversation/ep3_etyyy_kint_zsam:s_185", "s_189"},
		{"@conversation/ep3_etyyy_kint_zsam:s_379", "s_380"},
		{"@conversation/ep3_etyyy_kint_zsam:s_191", "s_193"},
		{"@conversation/ep3_etyyy_kint_zsam:s_195", "s_197"},
		{"@conversation/ep3_etyyy_kint_zsam:s_199", "s_201"},
	}
}
ep3_etyyy_kint_zsam_convo:addScreen(ep3_etyyy_kint_zsam_convo_s_183)

ep3_etyyy_kint_zsam_convo_s_203 = ConvoScreen:new {
	id = "s_203",
	leftDialog = "@conversation/ep3_etyyy_kint_zsam:s_203", -- This is the gate into the Hracca Glade. No one is allowed entrance without Sordaan's permission. And...
	stopConversation = "false",
	options = {
		{"@conversation/ep3_etyyy_kint_zsam:s_205", "s_208"},
		{"@conversation/ep3_etyyy_kint_zsam:s_210", "s_212"},
		{"@conversation/ep3_etyyy_kint_zsam:s_282", "s_284"},
		{"@conversation/ep3_etyyy_kint_zsam:s_287", "s_290"},
		{"@conversation/ep3_etyyy_kint_zsam:s_301", "s_303"},
	}
}
ep3_etyyy_kint_zsam_convo:addScreen(ep3_etyyy_kint_zsam_convo_s_203)

addConversationTemplate("ep3_etyyy_kint_zsam_convo", ep3_etyyy_kint_zsam_convo)
