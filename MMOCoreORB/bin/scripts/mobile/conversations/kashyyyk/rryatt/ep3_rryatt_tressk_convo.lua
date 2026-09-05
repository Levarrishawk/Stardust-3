-- Tressk -- ep3_rryatt_tressk_* hunts
-- ruling 2026-09-04: "ensure kashyyyk is fully done"
-- Transcribed from the giver's java branches. Strings are shipped keys.
-- NO JOURNAL: this branch has no managers/quest/journal.lua. Do not call the journal engine.

ep3_rryatt_tressk_convo = ConvoTemplate:new {
	initialScreen = "s_1366",
	templateType = "Lua",
	luaClassHandler = "ep3_rryatt_tressk_conv_handler",
	screens = {}
}

ep3_rryatt_tressk_convo_s_31 = ConvoScreen:new {
	id = "s_31",
	leftDialog = "@conversation/ep3_rryatt_tressk:s_31", -- It is always an honor to speak with a skilled hunter such as yourself.
	stopConversation = "true",
	options = {}
}
ep3_rryatt_tressk_convo:addScreen(ep3_rryatt_tressk_convo_s_31)

ep3_rryatt_tressk_convo_s_1367 = ConvoScreen:new {
	id = "s_1367",
	leftDialog = "@conversation/ep3_rryatt_tressk:s_1367", -- Well done. If it was up to me, I'd make you an honorary member of Ziven's clan.
	stopConversation = "false",
	options = {
		{"@conversation/ep3_rryatt_tressk:s_25", "s_27"},
		{"@conversation/ep3_rryatt_tressk:s_26", "s_28"},
		{"@conversation/ep3_rryatt_tressk:s_29", "s_30"},
	}
}
ep3_rryatt_tressk_convo:addScreen(ep3_rryatt_tressk_convo_s_1367)

ep3_rryatt_tressk_convo_s_27 = ConvoScreen:new {
	id = "s_27",
	leftDialog = "@conversation/ep3_rryatt_tressk:s_27", -- Well chosen! May this mace strike true against any worthy prey.
	stopConversation = "true",
	options = {}
}
ep3_rryatt_tressk_convo:addScreen(ep3_rryatt_tressk_convo_s_27)

ep3_rryatt_tressk_convo_s_28 = ConvoScreen:new {
	id = "s_28",
	leftDialog = "@conversation/ep3_rryatt_tressk:s_28", -- Excellent choice! May this pistol never fail to answer your call on a hunt.
	stopConversation = "true",
	options = {}
}
ep3_rryatt_tressk_convo:addScreen(ep3_rryatt_tressk_convo_s_28)

ep3_rryatt_tressk_convo_s_30 = ConvoScreen:new {
	id = "s_30",
	leftDialog = "@conversation/ep3_rryatt_tressk:s_30", -- Take your time. Whenever you're ready, we can restart this conversation, and you can make your choice.
	stopConversation = "true",
	options = {}
}
ep3_rryatt_tressk_convo:addScreen(ep3_rryatt_tressk_convo_s_30)

ep3_rryatt_tressk_convo_s_1368 = ConvoScreen:new {
	id = "s_1368",
	leftDialog = "@conversation/ep3_rryatt_tressk:s_1368", -- You'll find the Gotal hunter camp on the lowest level of the Rryatt Trail.
	stopConversation = "true",
	options = {}
}
ep3_rryatt_tressk_convo:addScreen(ep3_rryatt_tressk_convo_s_1368)

ep3_rryatt_tressk_convo_s_1369 = ConvoScreen:new {
	id = "s_1369",
	leftDialog = "@conversation/ep3_rryatt_tressk:s_1369", -- That should show those poachers not to mess with Rodians.
	stopConversation = "false",
	options = {
		{"@conversation/ep3_rryatt_tressk:s_1385", "s_1387"},
		{"@conversation/ep3_rryatt_tressk:s_1386", "s_1388"},
	}
}
ep3_rryatt_tressk_convo:addScreen(ep3_rryatt_tressk_convo_s_1369)

ep3_rryatt_tressk_convo_s_1387 = ConvoScreen:new {
	id = "s_1387",
	leftDialog = "@conversation/ep3_rryatt_tressk:s_1387", -- Perfect. You'll find the Gotal hunter camp on the lowest level of the Rryatt Trail.
	stopConversation = "true",
	options = {}
}
ep3_rryatt_tressk_convo:addScreen(ep3_rryatt_tressk_convo_s_1387)

ep3_rryatt_tressk_convo_s_1388 = ConvoScreen:new {
	id = "s_1388",
	leftDialog = "@conversation/ep3_rryatt_tressk:s_1388", -- Yeah, okay. Scared of the Gotals. I guess I can understand that.
	stopConversation = "true",
	options = {}
}
ep3_rryatt_tressk_convo:addScreen(ep3_rryatt_tressk_convo_s_1388)

ep3_rryatt_tressk_convo_s_1370 = ConvoScreen:new {
	id = "s_1370",
	leftDialog = "@conversation/ep3_rryatt_tressk:s_1370", -- The Deep Woods Poachers were last reported as being on the third level of the trail.
	stopConversation = "true",
	options = {}
}
ep3_rryatt_tressk_convo:addScreen(ep3_rryatt_tressk_convo_s_1370)

ep3_rryatt_tressk_convo_s_1371 = ConvoScreen:new {
	id = "s_1371",
	leftDialog = "@conversation/ep3_rryatt_tressk:s_1371", -- Thank you for your help with that situation. That's one less thing to worry about.
	stopConversation = "false",
	options = {
		{"@conversation/ep3_rryatt_tressk:s_1381", "s_1383"},
		{"@conversation/ep3_rryatt_tressk:s_1382", "s_1384"},
	}
}
ep3_rryatt_tressk_convo:addScreen(ep3_rryatt_tressk_convo_s_1371)

ep3_rryatt_tressk_convo_s_1383 = ConvoScreen:new {
	id = "s_1383",
	leftDialog = "@conversation/ep3_rryatt_tressk:s_1383", -- The Deep Woods Poachers were last reported as being on the third level of the trail.
	stopConversation = "true",
	options = {}
}
ep3_rryatt_tressk_convo:addScreen(ep3_rryatt_tressk_convo_s_1383)

ep3_rryatt_tressk_convo_s_1384 = ConvoScreen:new {
	id = "s_1384",
	leftDialog = "@conversation/ep3_rryatt_tressk:s_1384", -- That's too bad. You showed real promise. Oh well.
	stopConversation = "true",
	options = {}
}
ep3_rryatt_tressk_convo:addScreen(ep3_rryatt_tressk_convo_s_1384)

ep3_rryatt_tressk_convo_s_1372 = ConvoScreen:new {
	id = "s_1372",
	leftDialog = "@conversation/ep3_rryatt_tressk:s_1372", -- Last I heard, they were seen on the third level of the trail.
	stopConversation = "true",
	options = {}
}
ep3_rryatt_tressk_convo:addScreen(ep3_rryatt_tressk_convo_s_1372)

ep3_rryatt_tressk_convo_s_1366 = ConvoScreen:new {
	id = "s_1366",
	leftDialog = "@conversation/ep3_rryatt_tressk:s_1366", -- I'm surprised to see someone like you this deep into the Rryatt Trail.
	stopConversation = "false",
	options = {
		{"@conversation/ep3_rryatt_tressk:s_1373", "s_1375"},
		{"@conversation/ep3_rryatt_tressk:s_1374", "s_1376"},
	}
}
ep3_rryatt_tressk_convo:addScreen(ep3_rryatt_tressk_convo_s_1366)

ep3_rryatt_tressk_convo_s_1375 = ConvoScreen:new {
	id = "s_1375",
	leftDialog = "@conversation/ep3_rryatt_tressk:s_1375", -- A few things actually. First and foremost, I need your help to clean up an embarrassing situation.
	stopConversation = "false",
	options = {
		{"@conversation/ep3_rryatt_tressk:s_1377", "s_1379"},
		{"@conversation/ep3_rryatt_tressk:s_1378", "s_1380"},
	}
}
ep3_rryatt_tressk_convo:addScreen(ep3_rryatt_tressk_convo_s_1375)

ep3_rryatt_tressk_convo_s_1376 = ConvoScreen:new {
	id = "s_1376",
	leftDialog = "@conversation/ep3_rryatt_tressk:s_1376", -- I see. Not willing to get involved. Can't say I blame you.
	stopConversation = "true",
	options = {}
}
ep3_rryatt_tressk_convo:addScreen(ep3_rryatt_tressk_convo_s_1376)

ep3_rryatt_tressk_convo_s_1379 = ConvoScreen:new {
	id = "s_1379",
	leftDialog = "@conversation/ep3_rryatt_tressk:s_1379", -- Last I heard, they were seen on the third level of the trail. Go find them.
	stopConversation = "true",
	options = {}
}
ep3_rryatt_tressk_convo:addScreen(ep3_rryatt_tressk_convo_s_1379)

ep3_rryatt_tressk_convo_s_1380 = ConvoScreen:new {
	id = "s_1380",
	leftDialog = "@conversation/ep3_rryatt_tressk:s_1380", -- Sure, no problem. It's my problem. I'll deal with it.
	stopConversation = "true",
	options = {}
}
ep3_rryatt_tressk_convo:addScreen(ep3_rryatt_tressk_convo_s_1380)

addConversationTemplate("ep3_rryatt_tressk_convo", ep3_rryatt_tressk_convo)
