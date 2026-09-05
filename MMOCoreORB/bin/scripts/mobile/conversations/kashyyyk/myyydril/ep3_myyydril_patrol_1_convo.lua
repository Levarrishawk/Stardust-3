-- ep3_myyydril_patrol_1
-- ruling 2026-09-04
-- Transcribed from the giver's java branches. Strings are shipped keys.
-- The journal row for quest/ep3_myyydril_*.qst comes from the integration branch later; do not call the journal API.

ep3_myyydril_patrol_1_convo = ConvoTemplate:new {
	initialScreen = "s_519",
	templateType = "Lua",
	luaClassHandler = "ep3_myyydril_patrol_1_conv_handler",
	screens = {}
}

ep3_myyydril_patrol_1_convo_s_479 = ConvoScreen:new {
	id = "s_479",
	leftDialog = "@conversation/ep3_myyydril_patrol_1:s_479", -- [nod] Seems like you're making a name for yourself. That's good. It was nice seeing you again. I need to get back to my patrol.
	stopConversation = "true",
	options = {}
}
ep3_myyydril_patrol_1_convo:addScreen(ep3_myyydril_patrol_1_convo_s_479)

ep3_myyydril_patrol_1_convo_s_481 = ConvoScreen:new {
	id = "s_481",
	leftDialog = "@conversation/ep3_myyydril_patrol_1:s_481", -- Kirrir is waiting on you. I already told her to expect you. Why don't you go over to the cantina and find her.
	stopConversation = "true",
	options = {}
}
ep3_myyydril_patrol_1_convo:addScreen(ep3_myyydril_patrol_1_convo_s_481)

ep3_myyydril_patrol_1_convo_s_483 = ConvoScreen:new {
	id = "s_483",
	leftDialog = "@conversation/ep3_myyydril_patrol_1:s_483", -- Oh, hey. You're back. You know... luckily it hadn't been another Urnsor'is. I probably would have had to save you. Be glad.
	stopConversation = "false",
	options = {
		{"@conversation/ep3_myyydril_patrol_1:s_485", "s_487"},
	}
}
ep3_myyydril_patrol_1_convo:addScreen(ep3_myyydril_patrol_1_convo_s_483)

ep3_myyydril_patrol_1_convo_s_487 = ConvoScreen:new {
	id = "s_487",
	leftDialog = "@conversation/ep3_myyydril_patrol_1:s_487", -- Come to think of it I know Kirrir has some things she needs to be done. She's in the cantina. She makes the best 'Warl Surprise!'. You sh...
	stopConversation = "false",
	options = {
		{"@conversation/ep3_myyydril_patrol_1:s_489", "s_491"},
	}
}
ep3_myyydril_patrol_1_convo:addScreen(ep3_myyydril_patrol_1_convo_s_487)

ep3_myyydril_patrol_1_convo_s_491 = ConvoScreen:new {
	id = "s_491",
	leftDialog = "@conversation/ep3_myyydril_patrol_1:s_491", -- [Tala'oree shrugs.] All in a day's work.
	stopConversation = "true",
	options = {}
}
ep3_myyydril_patrol_1_convo:addScreen(ep3_myyydril_patrol_1_convo_s_491)

ep3_myyydril_patrol_1_convo_s_493 = ConvoScreen:new {
	id = "s_493",
	leftDialog = "@conversation/ep3_myyydril_patrol_1:s_493", -- The hostile Uwari Beetle infestation has calmed somewhat. Looks like you've done a good job.
	stopConversation = "false",
	options = {
		{"@conversation/ep3_myyydril_patrol_1:s_495", "s_497"},
	}
}
ep3_myyydril_patrol_1_convo:addScreen(ep3_myyydril_patrol_1_convo_s_493)

ep3_myyydril_patrol_1_convo_s_497 = ConvoScreen:new {
	id = "s_497",
	leftDialog = "@conversation/ep3_myyydril_patrol_1:s_497", -- Come talk to me in a few seconds. I'm getting a signal. I hope it isn't another Urnsor'is attack. They've been on the rise lately.
	stopConversation = "false",
	options = {
		{"@conversation/ep3_myyydril_patrol_1:s_499", "s_501"},
	}
}
ep3_myyydril_patrol_1_convo:addScreen(ep3_myyydril_patrol_1_convo_s_497)

ep3_myyydril_patrol_1_convo_s_501 = ConvoScreen:new {
	id = "s_501",
	leftDialog = "@conversation/ep3_myyydril_patrol_1:s_501", -- [Tala'oree turns away.]
	stopConversation = "true",
	options = {}
}
ep3_myyydril_patrol_1_convo:addScreen(ep3_myyydril_patrol_1_convo_s_501)

ep3_myyydril_patrol_1_convo_s_503 = ConvoScreen:new {
	id = "s_503",
	leftDialog = "@conversation/ep3_myyydril_patrol_1:s_503", -- Not in the mood to go beetle killing? You should really get a move on, you know.
	stopConversation = "true",
	options = {}
}
ep3_myyydril_patrol_1_convo:addScreen(ep3_myyydril_patrol_1_convo_s_503)

ep3_myyydril_patrol_1_convo_s_505 = ConvoScreen:new {
	id = "s_505",
	leftDialog = "@conversation/ep3_myyydril_patrol_1:s_505", -- Kallaarac told you to talk to me, hm? He's so noble. Yeah, I have a task for you to do. Let's see... We have been having issues with host...
	stopConversation = "false",
	options = {
		{"@conversation/ep3_myyydril_patrol_1:s_507", "s_509"},
		{"@conversation/ep3_myyydril_patrol_1:s_515", "s_517"},
	}
}
ep3_myyydril_patrol_1_convo:addScreen(ep3_myyydril_patrol_1_convo_s_505)

ep3_myyydril_patrol_1_convo_s_509 = ConvoScreen:new {
	id = "s_509",
	leftDialog = "@conversation/ep3_myyydril_patrol_1:s_509", -- You can find them at the entrance of the cave itself. I have no doubt you've seen them as you came in.
	stopConversation = "false",
	options = {
		{"@conversation/ep3_myyydril_patrol_1:s_511", "s_513"},
	}
}
ep3_myyydril_patrol_1_convo:addScreen(ep3_myyydril_patrol_1_convo_s_509)

ep3_myyydril_patrol_1_convo_s_513 = ConvoScreen:new {
	id = "s_513",
	leftDialog = "@conversation/ep3_myyydril_patrol_1:s_513", -- Good Come back when you're done. And be careful!
	stopConversation = "true",
	options = {}
}
ep3_myyydril_patrol_1_convo:addScreen(ep3_myyydril_patrol_1_convo_s_513)

ep3_myyydril_patrol_1_convo_s_517 = ConvoScreen:new {
	id = "s_517",
	leftDialog = "@conversation/ep3_myyydril_patrol_1:s_517", -- All right. Let me know.
	stopConversation = "true",
	options = {}
}
ep3_myyydril_patrol_1_convo:addScreen(ep3_myyydril_patrol_1_convo_s_517)

ep3_myyydril_patrol_1_convo_s_519 = ConvoScreen:new {
	id = "s_519",
	leftDialog = "@conversation/ep3_myyydril_patrol_1:s_519", -- Just doing my job here. Nothing else to report.
	stopConversation = "true",
	options = {}
}
ep3_myyydril_patrol_1_convo:addScreen(ep3_myyydril_patrol_1_convo_s_519)

addConversationTemplate("ep3_myyydril_patrol_1_convo", ep3_myyydril_patrol_1_convo)
