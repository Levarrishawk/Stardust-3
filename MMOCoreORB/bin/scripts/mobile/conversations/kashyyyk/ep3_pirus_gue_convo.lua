-- Pirus Gue -- ep3_kachirho_varactyl_egg. Live isPreOrder gated the pitch; this port treats every player as eligible so the quest can play (ruling 2026-09-04).
-- ruling 2026-09-04: "ensure kashyyyk is done in full"
-- Transcribed from the giver's java branches. Strings are shipped keys.
-- The journal row for quest/ep3_kachirho_*.qst comes from the integration branch later; do not call Journal.*.

ep3_pirus_gue_convo = ConvoTemplate:new {
	initialScreen = "s_19",
	templateType = "Lua",
	luaClassHandler = "ep3_pirus_gue_conv_handler",
	screens = {}
}

ep3_pirus_gue_convo_s_16 = ConvoScreen:new {
	id = "s_16",
	leftDialog = "@conversation/ep3_kachirho_varactyl_egg:s_16", -- Hello there. stranger. Sorry I cannot talk right now. I am busy planning my next expedition into the wilds. Take care and safe journeys to ya.
	stopConversation = "true",
	options = {}
}
ep3_pirus_gue_convo:addScreen(ep3_pirus_gue_convo_s_16)

ep3_pirus_gue_convo_s_327 = ConvoScreen:new {
	id = "s_327",
	animation = "greet",
	leftDialog = "@conversation/ep3_kachirho_varactyl_egg:s_327", -- Hello again, stranger. I told ya everything I know about Jagged Fang and the egg. Sorry I can't be of any more help to ya. Safe travels.
	stopConversation = "true",
	options = {}
}
ep3_pirus_gue_convo:addScreen(ep3_pirus_gue_convo_s_327)

ep3_pirus_gue_convo_s_329 = ConvoScreen:new {
	id = "s_329",
	animation = "greet",
	leftDialog = "@conversation/ep3_kachirho_varactyl_egg:s_329", -- Ho, there traveler. Long way from home, aren't ya? No matter, none of my business any ways. I see yer admiring Clarissa here. Fine mount she is. Strong, fast...
	stopConversation = "false",
	options = {
		{"@conversation/ep3_kachirho_varactyl_egg:s_331", "s_333"},
	}
}
ep3_pirus_gue_convo:addScreen(ep3_pirus_gue_convo_s_329)

ep3_pirus_gue_convo_s_19 = ConvoScreen:new {
	id = "s_19",
	leftDialog = "@conversation/ep3_kachirho_varactyl_egg:s_19", -- Good day to ya. I must say, it is days like this that make me glad that I am on Kashyyyk and not someplace cold...like Hoth. Well, time is money and so forth...
	stopConversation = "true",
	options = {}
}
ep3_pirus_gue_convo:addScreen(ep3_pirus_gue_convo_s_19)

ep3_pirus_gue_convo_s_333 = ConvoScreen:new {
	id = "s_333",
	animation = "explain",
	leftDialog = "@conversation/ep3_kachirho_varactyl_egg:s_333", -- Well, she ain't no test tube critter like most of the varactyl ya see around these days. She is the real deal. Hatched from an egg, just like nature intended...
	stopConversation = "false",
	options = {
		{"@conversation/ep3_kachirho_varactyl_egg:s_335", "s_337"},
	}
}
ep3_pirus_gue_convo:addScreen(ep3_pirus_gue_convo_s_333)

ep3_pirus_gue_convo_s_337 = ConvoScreen:new {
	id = "s_337",
	animation = "explain",
	leftDialog = "@conversation/ep3_kachirho_varactyl_egg:s_337", -- Like I said, ya have to get an egg and be there when it hatches. Now that I think of it there is only one place in these parts where ya can get a varactyl eg...
	stopConversation = "false",
	options = {
		{"@conversation/ep3_kachirho_varactyl_egg:s_339", "s_341"},
	}
}
ep3_pirus_gue_convo:addScreen(ep3_pirus_gue_convo_s_337)

ep3_pirus_gue_convo_s_341 = ConvoScreen:new {
	id = "s_341",
	animation = "explain",
	leftDialog = "@conversation/ep3_kachirho_varactyl_egg:s_341", -- I haven't seen this ya understand but Jagged Fang is supposed to have a nest in the region. I would imagine any offspring of hers would really be something s...
	stopConversation = "false",
	options = {
		{"@conversation/ep3_kachirho_varactyl_egg:s_343", "s_345"},
	}
}
ep3_pirus_gue_convo:addScreen(ep3_pirus_gue_convo_s_341)

ep3_pirus_gue_convo_s_345 = ConvoScreen:new {
	id = "s_345",
	animation = "standing_placate",
	leftDialog = "@conversation/ep3_kachirho_varactyl_egg:s_345", -- Not a Jagged Fang...the Jagged Fang. She is the matriarch of all the varactyl in the area. A mean spirited lizard if there ever was. If I know anything about...
	stopConversation = "false",
	options = {
		{"@conversation/ep3_kachirho_varactyl_egg:s_347", "s_349"},
		{"@conversation/ep3_kachirho_varactyl_egg:s_351", "s_353"},
	}
}
ep3_pirus_gue_convo:addScreen(ep3_pirus_gue_convo_s_345)

ep3_pirus_gue_convo_s_349 = ConvoScreen:new {
	id = "s_349",
	animation = "explain",
	leftDialog = "@conversation/ep3_kachirho_varactyl_egg:s_349", -- Like I said I have never seen it but if I had to guess I would imagine she would set up a nest site somewhere to the north. Probably near the river. But that...
	stopConversation = "true",
	options = {}
}
ep3_pirus_gue_convo:addScreen(ep3_pirus_gue_convo_s_349)

ep3_pirus_gue_convo_s_353 = ConvoScreen:new {
	id = "s_353",
	animation = "nod_head_once",
	leftDialog = "@conversation/ep3_kachirho_varactyl_egg:s_353", -- Can't say that I blame ya. Good luck on yer travels there, stranger.
	stopConversation = "true",
	options = {}
}
ep3_pirus_gue_convo:addScreen(ep3_pirus_gue_convo_s_353)

addConversationTemplate("ep3_pirus_gue_convo", ep3_pirus_gue_convo)
