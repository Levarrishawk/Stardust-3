-- Krepauk -- ep3_rryatt_krepauk_* trials
-- ruling 2026-09-04: "ensure kashyyyk is fully done"
-- Transcribed from the giver's java branches. Strings are shipped keys.
-- NO JOURNAL: this branch has no managers/quest/journal.lua. Do not call the journal engine.

ep3_rryatt_krepauk_convo = ConvoTemplate:new {
	initialScreen = "s_361",
	templateType = "Lua",
	luaClassHandler = "ep3_rryatt_krepauk_conv_handler",
	screens = {}
}

ep3_rryatt_krepauk_convo_s_307 = ConvoScreen:new {
	id = "s_307",
	leftDialog = "@conversation/ep3_rryatt_krepauk:s_307", -- Rrrwowosacwwrrc rawwwa owoanoaooccwo soo sacwo Rrrrass Srraacan.
	stopConversation = "true",
	options = {}
}
ep3_rryatt_krepauk_convo:addScreen(ep3_rryatt_krepauk_convo_s_307)

ep3_rryatt_krepauk_convo_s_309 = ConvoScreen:new {
	id = "s_309",
	leftDialog = "@conversation/ep3_rryatt_krepauk:s_309", -- Honored hunter, you have bested the worst that the Rryatt Trail can send against you.
	stopConversation = "true",
	options = {}
}
ep3_rryatt_krepauk_convo:addScreen(ep3_rryatt_krepauk_convo_s_309)

ep3_rryatt_krepauk_convo_s_311 = ConvoScreen:new {
	id = "s_311",
	leftDialog = "@conversation/ep3_rryatt_krepauk:s_311", -- You will find the katarn in the darkest depths of the Rryatt Trail.
	stopConversation = "true",
	options = {}
}
ep3_rryatt_krepauk_convo:addScreen(ep3_rryatt_krepauk_convo_s_311)

ep3_rryatt_krepauk_convo_s_313 = ConvoScreen:new {
	id = "s_313",
	leftDialog = "@conversation/ep3_rryatt_krepauk:s_313", -- You are truly a masterful hunter to have successfully killed a prey such as those minstyngar.
	stopConversation = "false",
	options = {
		{"@conversation/ep3_rryatt_krepauk:s_315", "s_317"},
		{"@conversation/ep3_rryatt_krepauk:s_319", "s_321"},
	}
}
ep3_rryatt_krepauk_convo:addScreen(ep3_rryatt_krepauk_convo_s_313)

ep3_rryatt_krepauk_convo_s_317 = ConvoScreen:new {
	id = "s_317",
	leftDialog = "@conversation/ep3_rryatt_krepauk:s_317", -- You will find the katarn in the darkest depths of the Rryatt Trail. Have courage.
	stopConversation = "true",
	options = {}
}
ep3_rryatt_krepauk_convo:addScreen(ep3_rryatt_krepauk_convo_s_317)

ep3_rryatt_krepauk_convo_s_321 = ConvoScreen:new {
	id = "s_321",
	leftDialog = "@conversation/ep3_rryatt_krepauk:s_321", -- Many before you have refused to hunt the katarn.
	stopConversation = "true",
	options = {}
}
ep3_rryatt_krepauk_convo:addScreen(ep3_rryatt_krepauk_convo_s_321)

ep3_rryatt_krepauk_convo_s_323 = ConvoScreen:new {
	id = "s_323",
	leftDialog = "@conversation/ep3_rryatt_krepauk:s_323", -- You will find these minstyngar on the lowest level of the Rryatt Trail.
	stopConversation = "true",
	options = {}
}
ep3_rryatt_krepauk_convo:addScreen(ep3_rryatt_krepauk_convo_s_323)

ep3_rryatt_krepauk_convo_s_325 = ConvoScreen:new {
	id = "s_325",
	leftDialog = "@conversation/ep3_rryatt_krepauk:s_325", -- Thank you. Bringing peace to those feral Wookiees was a painful, but necessary task.
	stopConversation = "false",
	options = {
		{"@conversation/ep3_rryatt_krepauk:s_327", "s_329"},
		{"@conversation/ep3_rryatt_krepauk:s_331", "s_333"},
	}
}
ep3_rryatt_krepauk_convo:addScreen(ep3_rryatt_krepauk_convo_s_325)

ep3_rryatt_krepauk_convo_s_329 = ConvoScreen:new {
	id = "s_329",
	leftDialog = "@conversation/ep3_rryatt_krepauk:s_329", -- You will find these minstyngar on the lowest level of the Rryatt Trail.
	stopConversation = "true",
	options = {}
}
ep3_rryatt_krepauk_convo:addScreen(ep3_rryatt_krepauk_convo_s_329)

ep3_rryatt_krepauk_convo_s_333 = ConvoScreen:new {
	id = "s_333",
	leftDialog = "@conversation/ep3_rryatt_krepauk:s_333", -- A wise hunter knows when to walk away from a challenge that is beyond their strengths.
	stopConversation = "true",
	options = {}
}
ep3_rryatt_krepauk_convo:addScreen(ep3_rryatt_krepauk_convo_s_333)

ep3_rryatt_krepauk_convo_s_335 = ConvoScreen:new {
	id = "s_335",
	leftDialog = "@conversation/ep3_rryatt_krepauk:s_335", -- Please send 24 feral Wookiees to the peaceful slumber of their final rest.
	stopConversation = "true",
	options = {}
}
ep3_rryatt_krepauk_convo:addScreen(ep3_rryatt_krepauk_convo_s_335)

ep3_rryatt_krepauk_convo_s_337 = ConvoScreen:new {
	id = "s_337",
	leftDialog = "@conversation/ep3_rryatt_krepauk:s_337", -- Urootar was a powerful foe. You have done well to defeat him.
	stopConversation = "false",
	options = {
		{"@conversation/ep3_rryatt_krepauk:s_339", "s_341"},
		{"@conversation/ep3_rryatt_krepauk:s_343", "s_345"},
	}
}
ep3_rryatt_krepauk_convo:addScreen(ep3_rryatt_krepauk_convo_s_337)

ep3_rryatt_krepauk_convo_s_341 = ConvoScreen:new {
	id = "s_341",
	leftDialog = "@conversation/ep3_rryatt_krepauk:s_341", -- Thank you. Please send 24 feral Wookiees to the peaceful slumber of their final rest.
	stopConversation = "true",
	options = {}
}
ep3_rryatt_krepauk_convo:addScreen(ep3_rryatt_krepauk_convo_s_341)

ep3_rryatt_krepauk_convo_s_345 = ConvoScreen:new {
	id = "s_345",
	leftDialog = "@conversation/ep3_rryatt_krepauk:s_345", -- As you wish. Please speak with me again if you reconsider.
	stopConversation = "true",
	options = {}
}
ep3_rryatt_krepauk_convo:addScreen(ep3_rryatt_krepauk_convo_s_345)

ep3_rryatt_krepauk_convo_s_347 = ConvoScreen:new {
	id = "s_347",
	leftDialog = "@conversation/ep3_rryatt_krepauk:s_347", -- You will find Urootar on the second level of the Rryatt trail.
	stopConversation = "true",
	options = {}
}
ep3_rryatt_krepauk_convo:addScreen(ep3_rryatt_krepauk_convo_s_347)

ep3_rryatt_krepauk_convo_s_349 = ConvoScreen:new {
	id = "s_349",
	leftDialog = "@conversation/ep3_rryatt_krepauk:s_349", -- Very good. You have completed the walluga skullsmasher hunt.
	stopConversation = "false",
	options = {
		{"@conversation/ep3_rryatt_krepauk:s_351", "s_353"},
		{"@conversation/ep3_rryatt_krepauk:s_355", "s_357"},
	}
}
ep3_rryatt_krepauk_convo:addScreen(ep3_rryatt_krepauk_convo_s_349)

ep3_rryatt_krepauk_convo_s_353 = ConvoScreen:new {
	id = "s_353",
	leftDialog = "@conversation/ep3_rryatt_krepauk:s_353", -- You will find Urootar somewhere on the second level of the Rryatt Trail.
	stopConversation = "true",
	options = {}
}
ep3_rryatt_krepauk_convo:addScreen(ep3_rryatt_krepauk_convo_s_353)

ep3_rryatt_krepauk_convo_s_357 = ConvoScreen:new {
	id = "s_357",
	leftDialog = "@conversation/ep3_rryatt_krepauk:s_357", -- Very well. speak with me again if you change your mind.
	stopConversation = "true",
	options = {}
}
ep3_rryatt_krepauk_convo:addScreen(ep3_rryatt_krepauk_convo_s_357)

ep3_rryatt_krepauk_convo_s_359 = ConvoScreen:new {
	id = "s_359",
	leftDialog = "@conversation/ep3_rryatt_krepauk:s_359", -- You will find walluga skullsmashers further along the trail on this level.
	stopConversation = "true",
	options = {}
}
ep3_rryatt_krepauk_convo:addScreen(ep3_rryatt_krepauk_convo_s_359)

ep3_rryatt_krepauk_convo_s_361 = ConvoScreen:new {
	id = "s_361",
	leftDialog = "@conversation/ep3_rryatt_krepauk:s_361", -- Greetings and welcome to the Rryatt Trail.
	stopConversation = "false",
	options = {
		{"@conversation/ep3_rryatt_krepauk:s_363", "s_365"},
		{"@conversation/ep3_rryatt_krepauk:s_376", "s_378"},
	}
}
ep3_rryatt_krepauk_convo:addScreen(ep3_rryatt_krepauk_convo_s_361)

ep3_rryatt_krepauk_convo_s_365 = ConvoScreen:new {
	id = "s_365",
	leftDialog = "@conversation/ep3_rryatt_krepauk:s_365", -- To show that you are an accomplished warrior, you must defeat some of the fierce denizens.
	stopConversation = "false",
	options = {
		{"@conversation/ep3_rryatt_krepauk:s_368", "s_370"},
		{"@conversation/ep3_rryatt_krepauk:s_372", "s_374"},
	}
}
ep3_rryatt_krepauk_convo:addScreen(ep3_rryatt_krepauk_convo_s_365)

ep3_rryatt_krepauk_convo_s_370 = ConvoScreen:new {
	id = "s_370",
	leftDialog = "@conversation/ep3_rryatt_krepauk:s_370", -- You will not have to descend any deeper into the Rryatt Trail to find walluga skullsmashers.
	stopConversation = "true",
	options = {}
}
ep3_rryatt_krepauk_convo:addScreen(ep3_rryatt_krepauk_convo_s_370)

ep3_rryatt_krepauk_convo_s_374 = ConvoScreen:new {
	id = "s_374",
	leftDialog = "@conversation/ep3_rryatt_krepauk:s_374", -- If you change your mind, come speak with me again.
	stopConversation = "true",
	options = {}
}
ep3_rryatt_krepauk_convo:addScreen(ep3_rryatt_krepauk_convo_s_374)

ep3_rryatt_krepauk_convo_s_378 = ConvoScreen:new {
	id = "s_378",
	leftDialog = "@conversation/ep3_rryatt_krepauk:s_378", -- Be careful if you intend to explore. There are many dangers on the trail.
	stopConversation = "true",
	options = {}
}
ep3_rryatt_krepauk_convo:addScreen(ep3_rryatt_krepauk_convo_s_378)

addConversationTemplate("ep3_rryatt_krepauk_convo", ep3_rryatt_krepauk_convo)
