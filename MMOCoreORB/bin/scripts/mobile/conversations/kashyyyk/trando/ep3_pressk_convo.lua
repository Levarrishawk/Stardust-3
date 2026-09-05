-- ep3_pressk -- ep3_trando_pressk
-- ruling 2026-09-04
-- Transcribed from the giver's java branches. Strings are shipped keys.
-- The journal row for the .qst comes from the integration branch later; do not call the journal engine.

ep3_pressk_convo = ConvoTemplate:new {
	initialScreen = "s_503",
	templateType = "Lua",
	luaClassHandler = "ep3_pressk_conv_handler",
	screens = {}
}

ep3_pressk_convo_s_497 = ConvoScreen:new {
	id = "s_497",
	animation = "rub_chin_thoughtful",
	leftDialog = "@conversation/ep3_trando_pressk:s_497", -- So Ssiksik got my last message. I was worried that the Wookiees had blocked the signal. Well I hope your re...
	stopConversation = "false",
	options = {
		{"@conversation/ep3_trando_pressk:s_499", "s_501"}, -- How many Wookiees are out there?
	}
}
ep3_pressk_convo:addScreen(ep3_pressk_convo_s_497)

ep3_pressk_convo_s_501 = ConvoScreen:new {
	id = "s_501",
	animation = "shrug_hands",
	leftDialog = "@conversation/ep3_trando_pressk:s_501", -- I am not really certain. I get the feeling that they have not yet been willing to commit their entire force...
	stopConversation = "true",
	options = {
	}
}
ep3_pressk_convo:addScreen(ep3_pressk_convo_s_501)

ep3_pressk_convo_s_487 = ConvoScreen:new {
	id = "s_487",
	animation = "nod_head_once",
	leftDialog = "@conversation/ep3_trando_pressk:s_487", -- We are just going to take care of our wounded and then be moving on. Thanks again for the help killing thos...
	stopConversation = "true",
	options = {
	}
}
ep3_pressk_convo:addScreen(ep3_pressk_convo_s_487)

ep3_pressk_convo_s_489 = ConvoScreen:new {
	id = "s_489",
	animation = "salute2",
	leftDialog = "@conversation/ep3_trando_pressk:s_489", -- It looks like we are in the clear now. You have really proven yourself against those furballs today. We wil...
	stopConversation = "true",
	options = {
	}
}
ep3_pressk_convo:addScreen(ep3_pressk_convo_s_489)

ep3_pressk_convo_s_491 = ConvoScreen:new {
	id = "s_491",
	animation = "smell_air",
	leftDialog = "@conversation/ep3_trando_pressk:s_491", -- We are not out of the woods yet. Keep alert.
	stopConversation = "true",
	options = {
	}
}
ep3_pressk_convo:addScreen(ep3_pressk_convo_s_491)

ep3_pressk_convo_s_493 = ConvoScreen:new {
	id = "s_493",
	animation = "pound_fist_palm",
	leftDialog = "@conversation/ep3_trando_pressk:s_493", -- You nearly got yourself killed walking in here like that! How did you get by all those furballs that have u...
	stopConversation = "false",
	options = {
		{"@conversation/ep3_trando_pressk:s_495", "s_497"}, -- Ssiksik sent me to offer you support.
	}
}
ep3_pressk_convo:addScreen(ep3_pressk_convo_s_493)

ep3_pressk_convo_s_503 = ConvoScreen:new {
	id = "s_503",
	animation = "wave_on_dismissing",
	leftDialog = "@conversation/ep3_trando_pressk:s_503", -- Not now...I don't have time to deal with the likes of you. Beat it, pal.
	stopConversation = "true",
	options = {
	}
}
ep3_pressk_convo:addScreen(ep3_pressk_convo_s_503)

addConversationTemplate("ep3_pressk_convo", ep3_pressk_convo)
