-- Ortha Ledox -- ep3_kachirho_varactyl_hunt (journal names the turn-in Janno)
-- ruling 2026-09-04: "ensure kashyyyk is done in full"
-- Transcribed from the giver's java branches. Strings are shipped keys.
-- The journal row for quest/ep3_kachirho_*.qst comes from the integration branch later; do not call Journal.*.

ep3_ortha_ledox_convo = ConvoTemplate:new {
	initialScreen = "s_379",
	templateType = "Lua",
	luaClassHandler = "ep3_ortha_ledox_conv_handler",
	screens = {}
}

ep3_ortha_ledox_convo_s_357 = ConvoScreen:new {
	id = "s_357",
	animation = "rub_chin_thoughtful",
	leftDialog = "@conversation/ep3_kachirho_varactyl_hunter:s_357", -- I figured you would be back. My offer is still good if you are interested. Kill eight varactyl, bring me their plumes, and I will pay a bounty of two thousan...
	stopConversation = "false",
	options = {
		{"@conversation/ep3_kachirho_varactyl_hunter:s_359", "s_361"},
		{"@conversation/ep3_kachirho_varactyl_hunter:s_363", "s_365"},
	}
}
ep3_ortha_ledox_convo:addScreen(ep3_ortha_ledox_convo_s_357)

ep3_ortha_ledox_convo_s_367 = ConvoScreen:new {
	id = "s_367",
	animation = "search",
	leftDialog = "@conversation/ep3_kachirho_varactyl_hunter:s_367", -- Welcome back. I hope the hunt went well for you. Let me see here...yep that is all eight of them. Nice work. As promised, here is your payment. Listen if you...
	stopConversation = "false",
	options = {
		{"@conversation/ep3_kachirho_varactyl_hunter:s_369", "s_371"},
		{"@conversation/ep3_kachirho_varactyl_hunter:s_373", "s_375"},
	}
}
ep3_ortha_ledox_convo:addScreen(ep3_ortha_ledox_convo_s_367)

ep3_ortha_ledox_convo_s_377 = ConvoScreen:new {
	id = "s_377",
	animation = "refuse_offer_affection",
	leftDialog = "@conversation/ep3_kachirho_varactyl_hunter:s_377", -- Sorry, buddy. I don't see eight plumes there. I only pay out the bounty once all eight varactyl have been killed.
	stopConversation = "true",
	options = {}
}
ep3_ortha_ledox_convo:addScreen(ep3_ortha_ledox_convo_s_377)

ep3_ortha_ledox_convo_s_379 = ConvoScreen:new {
	id = "s_379",
	animation = "wave_finger_warning",
	leftDialog = "@conversation/ep3_kachirho_varactyl_hunter:s_379", -- Those things are a menace. They are ravenous and are destroying everything that they can sink their claws into. If something isn't done about them soon they ...
	stopConversation = "false",
	options = {
		{"@conversation/ep3_kachirho_varactyl_hunter:s_381", "s_383"},
	}
}
ep3_ortha_ledox_convo:addScreen(ep3_ortha_ledox_convo_s_379)

ep3_ortha_ledox_convo_s_361 = ConvoScreen:new {
	id = "s_361",
	animation = "nod_head_once",
	leftDialog = "@conversation/ep3_kachirho_varactyl_hunter:s_361", -- Yeah, I figured you would jump at the offer. Same deal as before. Kill me eight varactyl, bring back their plumes, and I will hand you the credits. Good hunt...
	stopConversation = "true",
	options = {}
}
ep3_ortha_ledox_convo:addScreen(ep3_ortha_ledox_convo_s_361)

ep3_ortha_ledox_convo_s_365 = ConvoScreen:new {
	id = "s_365",
	animation = "check_wrist_device",
	leftDialog = "@conversation/ep3_kachirho_varactyl_hunter:s_365", -- No problem. Just come back by and see me if you change your mind.
	stopConversation = "true",
	options = {}
}
ep3_ortha_ledox_convo:addScreen(ep3_ortha_ledox_convo_s_365)

ep3_ortha_ledox_convo_s_371 = ConvoScreen:new {
	id = "s_371",
	animation = "wave1",
	leftDialog = "@conversation/ep3_kachirho_varactyl_hunter:s_371", -- Yeah, I figured you would jump at the offer. Same deal as before. Kill me eight varactyl, bring back their plumes, and I will hand you the credits. Good hunt...
	stopConversation = "true",
	options = {}
}
ep3_ortha_ledox_convo:addScreen(ep3_ortha_ledox_convo_s_371)

ep3_ortha_ledox_convo_s_375 = ConvoScreen:new {
	id = "s_375",
	animation = "nod_head_once",
	leftDialog = "@conversation/ep3_kachirho_varactyl_hunter:s_375", -- No problem. Just come back by and see me if you change your mind.
	stopConversation = "true",
	options = {}
}
ep3_ortha_ledox_convo:addScreen(ep3_ortha_ledox_convo_s_375)

ep3_ortha_ledox_convo_s_383 = ConvoScreen:new {
	id = "s_383",
	animation = "explain",
	leftDialog = "@conversation/ep3_kachirho_varactyl_hunter:s_383", -- The varactyl, of course. They breed like wild fire and are twice as mean. I have been studying their habits for a while now and I have come to the opinion th...
	stopConversation = "false",
	options = {
		{"@conversation/ep3_kachirho_varactyl_hunter:s_385", "s_387"},
	}
}
ep3_ortha_ledox_convo:addScreen(ep3_ortha_ledox_convo_s_383)

ep3_ortha_ledox_convo_s_387 = ConvoScreen:new {
	id = "s_387",
	animation = "explain",
	leftDialog = "@conversation/ep3_kachirho_varactyl_hunter:s_387", -- Mainly because they are not supposed to be here. The varactyl are not native to this planet and have no natural predators here. And all of the native species...
	stopConversation = "false",
	options = {
		{"@conversation/ep3_kachirho_varactyl_hunter:s_389", "s_391"},
	}
}
ep3_ortha_ledox_convo:addScreen(ep3_ortha_ledox_convo_s_387)

ep3_ortha_ledox_convo_s_391 = ConvoScreen:new {
	id = "s_391",
	animation = "rub_chin_thoughtful",
	leftDialog = "@conversation/ep3_kachirho_varactyl_hunter:s_391", -- Honestly, I don't know. Most likely it started with someone's pet getting free. That pet lays a clutch of eggs, they hatch, and the cycle starts. All I know ...
	stopConversation = "false",
	options = {
		{"@conversation/ep3_kachirho_varactyl_hunter:s_393", "s_395"},
	}
}
ep3_ortha_ledox_convo:addScreen(ep3_ortha_ledox_convo_s_391)

ep3_ortha_ledox_convo_s_395 = ConvoScreen:new {
	id = "s_395",
	animation = "point_forward",
	leftDialog = "@conversation/ep3_kachirho_varactyl_hunter:s_395", -- I have been authorized to offer a bounty on the killing of varactyl. The deal is simple. For every eight varactyl plumes that are turned in, I pay two thousa...
	stopConversation = "false",
	options = {
		{"@conversation/ep3_kachirho_varactyl_hunter:s_397", "s_399"},
		{"@conversation/ep3_kachirho_varactyl_hunter:s_401", "s_403"},
	}
}
ep3_ortha_ledox_convo:addScreen(ep3_ortha_ledox_convo_s_395)

ep3_ortha_ledox_convo_s_399 = ConvoScreen:new {
	id = "s_399",
	leftDialog = "@conversation/ep3_kachirho_varactyl_hunter:s_399", -- Alright. You know the deal. Eight varactyl plumes for two thousand credits. The varactyl are swarming all over this area and have moved up north a bit along ...
	stopConversation = "true",
	options = {}
}
ep3_ortha_ledox_convo:addScreen(ep3_ortha_ledox_convo_s_399)

ep3_ortha_ledox_convo_s_403 = ConvoScreen:new {
	id = "s_403",
	animation = "nod_head_once",
	leftDialog = "@conversation/ep3_kachirho_varactyl_hunter:s_403", -- Yeah...maybe later.
	stopConversation = "true",
	options = {}
}
ep3_ortha_ledox_convo:addScreen(ep3_ortha_ledox_convo_s_403)

addConversationTemplate("ep3_ortha_ledox_convo", ep3_ortha_ledox_convo)
