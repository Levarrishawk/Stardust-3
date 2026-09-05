-- ep3_trando_herald -- ep3_trando_herald
-- ruling 2026-09-04
-- Transcribed from the giver's java branches. Strings are shipped keys.
-- The journal row for the .qst comes from the integration branch later; do not call the journal engine.

ep3_trando_herald_convo = ConvoTemplate:new {
	initialScreen = "s_224",
	templateType = "Lua",
	luaClassHandler = "ep3_trando_herald_conv_handler",
	screens = {}
}

ep3_trando_herald_convo_s_286 = ConvoScreen:new {
	id = "s_286",
	leftDialog = "@conversation/ep3_trando_herald:s_286", -- Incompetence! Here's the location of another, now hurry up this time.
	stopConversation = "true",
	options = {
	}
}
ep3_trando_herald_convo:addScreen(ep3_trando_herald_convo_s_286)

ep3_trando_herald_convo_s_228 = ConvoScreen:new {
	id = "s_228",
	leftDialog = "@conversation/ep3_trando_herald:s_228", -- They are property of the Blackscale Clan. I was to deliver the cargo to an Imperial facility that is in des...
	stopConversation = "false",
	options = {
		{"@conversation/ep3_trando_herald:s_230", "s_232"}, -- How can you consider sentient beings property? There's no way I'm getting inv...
		{"@conversation/ep3_trando_herald:s_234", "s_236"}, -- If the price is right, I'll do what it takes.
	}
}
ep3_trando_herald_convo:addScreen(ep3_trando_herald_convo_s_228)

ep3_trando_herald_convo_s_256 = ConvoScreen:new {
	id = "s_256",
	leftDialog = "@conversation/ep3_trando_herald:s_256", -- As a matter of fact, I do. These wookiees are property of the Blackscale clan. I was to deliver the cargo t...
	stopConversation = "false",
	options = {
		{"@conversation/ep3_trando_herald:s_258", "s_260"}, -- If the price is right, I'll do whatever it takes.
		{"@conversation/ep3_trando_herald:s_278", "s_280"}, -- On second though, I don't think I want to be involved with this.
	}
}
ep3_trando_herald_convo:addScreen(ep3_trando_herald_convo_s_256)

ep3_trando_herald_convo_s_284 = ConvoScreen:new {
	id = "s_284",
	leftDialog = "@conversation/ep3_trando_herald:s_284", -- Then quit wasting my time and get out of my face!
	stopConversation = "true",
	options = {
	}
}
ep3_trando_herald_convo:addScreen(ep3_trando_herald_convo_s_284)

ep3_trando_herald_convo_s_232 = ConvoScreen:new {
	id = "s_232",
	leftDialog = "@conversation/ep3_trando_herald:s_232", -- Fine, get lost then! I'm sure there's plenty of people here that are looking for a quick pay day.
	stopConversation = "true",
	options = {
	}
}
ep3_trando_herald_convo:addScreen(ep3_trando_herald_convo_s_232)

ep3_trando_herald_convo_s_236 = ConvoScreen:new {
	id = "s_236",
	leftDialog = "@conversation/ep3_trando_herald:s_236", -- I knew you looked like a reasonable type. This shipment is ruined and unusuable, therefore they must all be...
	stopConversation = "false",
	options = {
		{"@conversation/ep3_trando_herald:s_238", "s_240"}, -- How do I find them?
		{"@conversation/ep3_trando_herald:s_250", "s_252"}, -- On second though, I don't think I want to be involved with this.
	}
}
ep3_trando_herald_convo:addScreen(ep3_trando_herald_convo_s_236)

ep3_trando_herald_convo_s_240 = ConvoScreen:new {
	id = "s_240",
	leftDialog = "@conversation/ep3_trando_herald:s_240", -- Each piece of cargo is outfitted with a transponder to track their location so finding them isn't a problem...
	stopConversation = "false",
	options = {
		{"@conversation/ep3_trando_herald:s_242", "s_244"}, -- Sounds good.
		{"@conversation/ep3_trando_herald:s_246", "s_248"}, -- On second thought, no. This doesn't sound good.
	}
}
ep3_trando_herald_convo:addScreen(ep3_trando_herald_convo_s_240)

ep3_trando_herald_convo_s_252 = ConvoScreen:new {
	id = "s_252",
	leftDialog = "@conversation/ep3_trando_herald:s_252", -- You've wasted enough of my time then. Take a hike!
	stopConversation = "true",
	options = {
	}
}
ep3_trando_herald_convo:addScreen(ep3_trando_herald_convo_s_252)

ep3_trando_herald_convo_s_244 = ConvoScreen:new {
	id = "s_244",
	leftDialog = "@conversation/ep3_trando_herald:s_244", -- Great, I've uploaded the location of one of them to your datapad. Get going and be quick about it! If they ...
	stopConversation = "true",
	options = {
	}
}
ep3_trando_herald_convo:addScreen(ep3_trando_herald_convo_s_244)

ep3_trando_herald_convo_s_248 = ConvoScreen:new {
	id = "s_248",
	leftDialog = "@conversation/ep3_trando_herald:s_248", -- You've wasted enough of my time then. Take a hike!
	stopConversation = "true",
	options = {
	}
}
ep3_trando_herald_convo:addScreen(ep3_trando_herald_convo_s_248)

ep3_trando_herald_convo_s_260 = ConvoScreen:new {
	id = "s_260",
	leftDialog = "@conversation/ep3_trando_herald:s_260", -- I knew you looked like a reasonable type. This shipment is ruined and unusuable, therefore they must all be...
	stopConversation = "false",
	options = {
		{"@conversation/ep3_trando_herald:s_262", "s_264"}, -- How do I find them?
		{"@conversation/ep3_trando_herald:s_274", "s_276"}, -- On second though, I don't think I want to be involved with this.
	}
}
ep3_trando_herald_convo:addScreen(ep3_trando_herald_convo_s_260)

ep3_trando_herald_convo_s_280 = ConvoScreen:new {
	id = "s_280",
	leftDialog = "@conversation/ep3_trando_herald:s_280", -- You've wasted enough of my time then. Take a hike!
	stopConversation = "true",
	options = {
	}
}
ep3_trando_herald_convo:addScreen(ep3_trando_herald_convo_s_280)

ep3_trando_herald_convo_s_264 = ConvoScreen:new {
	id = "s_264",
	leftDialog = "@conversation/ep3_trando_herald:s_264", -- Each piece of cargo is outfitted with a transponder to track their location so finding them isn't a problem...
	stopConversation = "false",
	options = {
		{"@conversation/ep3_trando_herald:s_266", "s_268"}, -- Sounds good.
		{"@conversation/ep3_trando_herald:s_270", "s_272"}, -- On second thought, no. This doesn't sound good.
	}
}
ep3_trando_herald_convo:addScreen(ep3_trando_herald_convo_s_264)

ep3_trando_herald_convo_s_276 = ConvoScreen:new {
	id = "s_276",
	leftDialog = "@conversation/ep3_trando_herald:s_276", -- You've wasted enough of my time then. Take a hike!
	stopConversation = "true",
	options = {
	}
}
ep3_trando_herald_convo:addScreen(ep3_trando_herald_convo_s_276)

ep3_trando_herald_convo_s_268 = ConvoScreen:new {
	id = "s_268",
	leftDialog = "@conversation/ep3_trando_herald:s_268", -- Great, I've uploaded the location of one of them to your datapad. Get going and be quick about it! If they ...
	stopConversation = "true",
	options = {
	}
}
ep3_trando_herald_convo:addScreen(ep3_trando_herald_convo_s_268)

ep3_trando_herald_convo_s_272 = ConvoScreen:new {
	id = "s_272",
	leftDialog = "@conversation/ep3_trando_herald:s_272", -- You've wasted enough of my time then. Take a hike!
	stopConversation = "true",
	options = {
	}
}
ep3_trando_herald_convo:addScreen(ep3_trando_herald_convo_s_272)

ep3_trando_herald_convo_s_35 = ConvoScreen:new {
	id = "s_35",
	leftDialog = "@conversation/ep3_trando_herald:s_35", -- I've heard you're good at what you do. I can't afford your fee so I won't insult you by asking you for help.
	stopConversation = "true",
	options = {
	}
}
ep3_trando_herald_convo:addScreen(ep3_trando_herald_convo_s_35)

ep3_trando_herald_convo_s_222 = ConvoScreen:new {
	id = "s_222",
	leftDialog = "@conversation/ep3_trando_herald:s_222", -- You again! What do you want?
	stopConversation = "false",
	options = {
		{"@conversation/ep3_trando_herald:s_285", "s_286"}, -- Can you give me another location?
	}
}
ep3_trando_herald_convo:addScreen(ep3_trando_herald_convo_s_222)

ep3_trando_herald_convo_s_224 = ConvoScreen:new {
	id = "s_224",
	leftDialog = "@conversation/ep3_trando_herald:s_224", -- I can't believe this happened! Somehow those wookiees escaped their bonds and sabotaged my ship. I had no c...
	stopConversation = "false",
	options = {
		{"@conversation/ep3_trando_herald:s_226", "s_228"}, -- Are these escaped wookiees criminals?
		{"@conversation/ep3_trando_herald:s_254", "s_256"}, -- Need any help?
		{"@conversation/ep3_trando_herald:s_282", "s_284"}, -- Sounds like a personal problem.
	}
}
ep3_trando_herald_convo:addScreen(ep3_trando_herald_convo_s_224)

addConversationTemplate("ep3_trando_herald_convo", ep3_trando_herald_convo)
