-- ep3_etyyy_mada_johnson -- Etyyy hunting-grounds ground conversation
-- ruling 2026-09-04: "ensure kashyyyk is fully done"
-- Transcribed from the giver's java branches. Strings are shipped keys.
-- The journal row for quest/ep3_hunt_*.qst comes from the integration branch later; do not call the journal engine.

ep3_etyyy_mada_johnson_convo = ConvoTemplate:new {
	initialScreen = "s_282",
	templateType = "Lua",
	luaClassHandler = "ep3_etyyy_mada_johnson_conv_handler",
	screens = {}
}

ep3_etyyy_mada_johnson_convo_s_664 = ConvoScreen:new {
	id = "s_664",
	animation = "shake_head_disgust",
	leftDialog = "@conversation/ep3_etyyy_mada_johnson:s_664", -- I'll probably need it. Believe it or not, this isn't even in the top 5 stupid things he's done. I th...
	stopConversation = "true",
	options = {}
}
ep3_etyyy_mada_johnson_convo:addScreen(ep3_etyyy_mada_johnson_convo_s_664)

ep3_etyyy_mada_johnson_convo_s_476 = ConvoScreen:new {
	id = "s_476",
	leftDialog = "@conversation/ep3_etyyy_mada_johnson:s_476", -- Thank you, I appreciate you saying that. Brody has always been a bit eccentric, but this one was str...
	stopConversation = "true",
	options = {}
}
ep3_etyyy_mada_johnson_convo:addScreen(ep3_etyyy_mada_johnson_convo_s_476)

ep3_etyyy_mada_johnson_convo_s_260 = ConvoScreen:new {
	id = "s_260",
	leftDialog = "@conversation/ep3_etyyy_mada_johnson:s_260", -- No! It can't be! Wait. That's not Brody's pendant. It's very similar, but it's not Brody's. I'm sure...
	stopConversation = "true",
	options = {}
}
ep3_etyyy_mada_johnson_convo:addScreen(ep3_etyyy_mada_johnson_convo_s_260)

ep3_etyyy_mada_johnson_convo_s_268 = ConvoScreen:new {
	id = "s_268",
	leftDialog = "@conversation/ep3_etyyy_mada_johnson:s_268", -- Whoo. That was quite a shock. Please be more careful.
	stopConversation = "true",
	options = {}
}
ep3_etyyy_mada_johnson_convo:addScreen(ep3_etyyy_mada_johnson_convo_s_268)

ep3_etyyy_mada_johnson_convo_s_264 = ConvoScreen:new {
	id = "s_264",
	leftDialog = "@conversation/ep3_etyyy_mada_johnson:s_264", -- Really? Well, go back and tell him that it's not Brody's pendant. Please find out what's going on.
	stopConversation = "true",
	options = {}
}
ep3_etyyy_mada_johnson_convo:addScreen(ep3_etyyy_mada_johnson_convo_s_264)

ep3_etyyy_mada_johnson_convo_s_278 = ConvoScreen:new {
	id = "s_278",
	leftDialog = "@conversation/ep3_etyyy_mada_johnson:s_278", -- My pleasure.
	stopConversation = "true",
	options = {}
}
ep3_etyyy_mada_johnson_convo:addScreen(ep3_etyyy_mada_johnson_convo_s_278)

ep3_etyyy_mada_johnson_convo_s_286 = ConvoScreen:new {
	id = "s_286",
	leftDialog = "@conversation/ep3_etyyy_mada_johnson:s_286", -- He's disappeared. His name is Brody. Brody Johnson. I haven't heard from him in 8 months. Brody came...
	stopConversation = "true",
	options = {}
}
ep3_etyyy_mada_johnson_convo:addScreen(ep3_etyyy_mada_johnson_convo_s_286)

ep3_etyyy_mada_johnson_convo_s_298 = ConvoScreen:new {
	id = "s_298",
	leftDialog = "@conversation/ep3_etyyy_mada_johnson:s_298", -- I understand. Farewell.
	stopConversation = "true",
	options = {}
}
ep3_etyyy_mada_johnson_convo:addScreen(ep3_etyyy_mada_johnson_convo_s_298)

ep3_etyyy_mada_johnson_convo_s_290 = ConvoScreen:new {
	id = "s_290",
	leftDialog = "@conversation/ep3_etyyy_mada_johnson:s_290", -- Not really. But you should talk to Wrelaac. Wrelaac is a Wookiee living here in the Kachirho. He's a...
	stopConversation = "true",
	options = {}
}
ep3_etyyy_mada_johnson_convo:addScreen(ep3_etyyy_mada_johnson_convo_s_290)

ep3_etyyy_mada_johnson_convo_s_294 = ConvoScreen:new {
	id = "s_294",
	leftDialog = "@conversation/ep3_etyyy_mada_johnson:s_294", -- I understand. Farewell.
	stopConversation = "true",
	options = {}
}
ep3_etyyy_mada_johnson_convo:addScreen(ep3_etyyy_mada_johnson_convo_s_294)

ep3_etyyy_mada_johnson_convo_s_252 = ConvoScreen:new {
	id = "s_252",
	leftDialog = "@conversation/ep3_etyyy_mada_johnson:s_252", -- Thank you so much for your help! Brody, or Johnson, or whatever he wants to be called has always bee...
	stopConversation = "false",
	options = {
		{"@conversation/ep3_etyyy_mada_johnson:s_475", "s_664"},
		{"@conversation/ep3_etyyy_mada_johnson:s_474", "s_476"},
	}
}
ep3_etyyy_mada_johnson_convo:addScreen(ep3_etyyy_mada_johnson_convo_s_252)

ep3_etyyy_mada_johnson_convo_s_254 = ConvoScreen:new {
	id = "s_254",
	leftDialog = "@conversation/ep3_etyyy_mada_johnson:s_254", -- What are you waiting for? Have you spoken to Jonhson Smith about that pendant? Please go do so.
	stopConversation = "true",
	options = {}
}
ep3_etyyy_mada_johnson_convo:addScreen(ep3_etyyy_mada_johnson_convo_s_254)

ep3_etyyy_mada_johnson_convo_s_256 = ConvoScreen:new {
	id = "s_256",
	leftDialog = "@conversation/ep3_etyyy_mada_johnson:s_256", -- What? You found Brody's corpse? Oh my, no! Are you sure?
	stopConversation = "false",
	options = {
		{"@conversation/ep3_etyyy_mada_johnson:s_258", "s_260"},
		{"@conversation/ep3_etyyy_mada_johnson:s_266", "s_268"},
	}
}
ep3_etyyy_mada_johnson_convo:addScreen(ep3_etyyy_mada_johnson_convo_s_256)

ep3_etyyy_mada_johnson_convo_s_270 = ConvoScreen:new {
	id = "s_270",
	leftDialog = "@conversation/ep3_etyyy_mada_johnson:s_270", -- Please continue looking for Brody. I am very concerned about him.
	stopConversation = "true",
	options = {}
}
ep3_etyyy_mada_johnson_convo:addScreen(ep3_etyyy_mada_johnson_convo_s_270)

ep3_etyyy_mada_johnson_convo_s_272 = ConvoScreen:new {
	id = "s_272",
	leftDialog = "@conversation/ep3_etyyy_mada_johnson:s_272", -- Go tell Wrelaac about Brody's pendant. That should prove to him that you know me.
	stopConversation = "true",
	options = {}
}
ep3_etyyy_mada_johnson_convo:addScreen(ep3_etyyy_mada_johnson_convo_s_272)

ep3_etyyy_mada_johnson_convo_s_274 = ConvoScreen:new {
	id = "s_274",
	leftDialog = "@conversation/ep3_etyyy_mada_johnson:s_274", -- Wrelaac wants proof that you know me? Hmm... okay. Tell him that Brody wore a pendant. He was pretty...
	stopConversation = "false",
	options = {
		{"@conversation/ep3_etyyy_mada_johnson:s_276", "s_278"},
	}
}
ep3_etyyy_mada_johnson_convo:addScreen(ep3_etyyy_mada_johnson_convo_s_274)

ep3_etyyy_mada_johnson_convo_s_280 = ConvoScreen:new {
	id = "s_280",
	leftDialog = "@conversation/ep3_etyyy_mada_johnson:s_280", -- Please speak to Wrelaac. He might know more about Brody than he's admitted to me.
	stopConversation = "true",
	options = {}
}
ep3_etyyy_mada_johnson_convo:addScreen(ep3_etyyy_mada_johnson_convo_s_280)

ep3_etyyy_mada_johnson_convo_s_282 = ConvoScreen:new {
	id = "s_282",
	animation = "greet",
	leftDialog = "@conversation/ep3_etyyy_mada_johnson:s_282", -- Could you help me? I'm trying to find my brother, but I can't really manage this on my own. Can you ...
	stopConversation = "false",
	options = {
		{"@conversation/ep3_etyyy_mada_johnson:s_284", "s_286"},
		{"@conversation/ep3_etyyy_mada_johnson:s_296", "s_298"},
	}
}
ep3_etyyy_mada_johnson_convo:addScreen(ep3_etyyy_mada_johnson_convo_s_282)

addConversationTemplate("ep3_etyyy_mada_johnson_convo", ep3_etyyy_mada_johnson_convo)
