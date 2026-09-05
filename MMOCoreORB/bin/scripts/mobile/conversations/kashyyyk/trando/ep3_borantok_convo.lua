-- ep3_borantok -- ep3_trandoshan_borantok
-- ruling 2026-09-04
-- Transcribed from the giver's java branches. Strings are shipped keys.
-- The journal row for the .qst comes from the integration branch later; do not call the journal engine.

ep3_borantok_convo = ConvoTemplate:new {
	initialScreen = "s_555",
	templateType = "Lua",
	luaClassHandler = "ep3_borantok_conv_handler",
	screens = {}
}

ep3_borantok_convo_s_513 = ConvoScreen:new {
	id = "s_513",
	animation = "celebrate",
	leftDialog = "@conversation/ep3_trandoshan_borantok:s_513",
	stopConversation = "true",
	options = {
	}
}
ep3_borantok_convo:addScreen(ep3_borantok_convo_s_513)

ep3_borantok_convo_s_519 = ConvoScreen:new {
	id = "s_519",
	animation = "gesticulate_wildly",
	leftDialog = "@conversation/ep3_trandoshan_borantok:s_519",
	stopConversation = "true",
	options = {
	}
}
ep3_borantok_convo:addScreen(ep3_borantok_convo_s_519)

ep3_borantok_convo_s_525 = ConvoScreen:new {
	id = "s_525",
	animation = "laugh",
	leftDialog = "@conversation/ep3_trandoshan_borantok:s_525",
	stopConversation = "false",
	options = {
		{"@conversation/ep3_trandoshan_borantok:s_527", "s_529"},
		{"@conversation/ep3_trandoshan_borantok:s_543", "s_545"},
	}
}
ep3_borantok_convo:addScreen(ep3_borantok_convo_s_525)

ep3_borantok_convo_s_529 = ConvoScreen:new {
	id = "s_529",
	animation = "smack_self",
	leftDialog = "@conversation/ep3_trandoshan_borantok:s_529",
	stopConversation = "false",
	options = {
		{"@conversation/ep3_trandoshan_borantok:s_531", "s_533"},
	}
}
ep3_borantok_convo:addScreen(ep3_borantok_convo_s_529)

ep3_borantok_convo_s_545 = ConvoScreen:new {
	id = "s_545",
	animation = "point_accusingly",
	leftDialog = "@conversation/ep3_trandoshan_borantok:s_545",
	stopConversation = "false",
	options = {
		{"@conversation/ep3_trandoshan_borantok:s_547", "s_529"},
	}
}
ep3_borantok_convo:addScreen(ep3_borantok_convo_s_545)

ep3_borantok_convo_s_533 = ConvoScreen:new {
	id = "s_533",
	animation = "slow_down",
	leftDialog = "@conversation/ep3_trandoshan_borantok:s_533",
	stopConversation = "false",
	options = {
		{"@conversation/ep3_trandoshan_borantok:s_535", "s_537"},
	}
}
ep3_borantok_convo:addScreen(ep3_borantok_convo_s_533)

ep3_borantok_convo_s_537 = ConvoScreen:new {
	id = "s_537",
	animation = "snap_finger2",
	leftDialog = "@conversation/ep3_trandoshan_borantok:s_537",
	stopConversation = "false",
	options = {
		{"@conversation/ep3_trandoshan_borantok:s_539", "s_541"},
	}
}
ep3_borantok_convo:addScreen(ep3_borantok_convo_s_537)

ep3_borantok_convo_s_541 = ConvoScreen:new {
	id = "s_541",
	animation = "explain",
	leftDialog = "@conversation/ep3_trandoshan_borantok:s_541",
	stopConversation = "true",
	options = {
	}
}
ep3_borantok_convo:addScreen(ep3_borantok_convo_s_541)

ep3_borantok_convo_s_553 = ConvoScreen:new {
	id = "s_553",
	animation = "gesticulate_wildly",
	leftDialog = "@conversation/ep3_trandoshan_borantok:s_553",
	stopConversation = "true",
	options = {
	}
}
ep3_borantok_convo:addScreen(ep3_borantok_convo_s_553)

ep3_borantok_convo_s_559 = ConvoScreen:new {
	id = "s_559",
	animation = "explain",
	leftDialog = "@conversation/ep3_trandoshan_borantok:s_559",
	stopConversation = "false",
	options = {
		{"@conversation/ep3_trandoshan_borantok:s_561", "s_563"},
	}
}
ep3_borantok_convo:addScreen(ep3_borantok_convo_s_559)

ep3_borantok_convo_s_595 = ConvoScreen:new {
	id = "s_595",
	animation = "dismiss",
	leftDialog = "@conversation/ep3_trandoshan_borantok:s_595",
	stopConversation = "true",
	options = {
	}
}
ep3_borantok_convo:addScreen(ep3_borantok_convo_s_595)

ep3_borantok_convo_s_563 = ConvoScreen:new {
	id = "s_563",
	animation = "slow_down",
	leftDialog = "@conversation/ep3_trandoshan_borantok:s_563",
	stopConversation = "false",
	options = {
		{"@conversation/ep3_trandoshan_borantok:s_565", "s_567"},
		{"@conversation/ep3_trandoshan_borantok:s_591", "s_595"},
	}
}
ep3_borantok_convo:addScreen(ep3_borantok_convo_s_563)

ep3_borantok_convo_s_567 = ConvoScreen:new {
	id = "s_567",
	animation = "explain",
	leftDialog = "@conversation/ep3_trandoshan_borantok:s_567",
	stopConversation = "false",
	options = {
		{"@conversation/ep3_trandoshan_borantok:s_569", "s_571"},
	}
}
ep3_borantok_convo:addScreen(ep3_borantok_convo_s_567)

ep3_borantok_convo_s_571 = ConvoScreen:new {
	id = "s_571",
	animation = "standing_placate",
	leftDialog = "@conversation/ep3_trandoshan_borantok:s_571",
	stopConversation = "false",
	options = {
		{"@conversation/ep3_trandoshan_borantok:s_573", "s_575"},
	}
}
ep3_borantok_convo:addScreen(ep3_borantok_convo_s_571)

ep3_borantok_convo_s_575 = ConvoScreen:new {
	id = "s_575",
	animation = "explain",
	leftDialog = "@conversation/ep3_trandoshan_borantok:s_575",
	stopConversation = "false",
	options = {
		{"@conversation/ep3_trandoshan_borantok:s_577", "s_579"},
		{"@conversation/ep3_trandoshan_borantok:s_589", "s_595"},
	}
}
ep3_borantok_convo:addScreen(ep3_borantok_convo_s_575)

ep3_borantok_convo_s_579 = ConvoScreen:new {
	id = "s_579",
	animation = "explain",
	leftDialog = "@conversation/ep3_trandoshan_borantok:s_579",
	stopConversation = "false",
	options = {
		{"@conversation/ep3_trandoshan_borantok:s_581", "s_583"},
	}
}
ep3_borantok_convo:addScreen(ep3_borantok_convo_s_579)

ep3_borantok_convo_s_583 = ConvoScreen:new {
	id = "s_583",
	animation = "tap_head",
	leftDialog = "@conversation/ep3_trandoshan_borantok:s_583",
	stopConversation = "false",
	options = {
		{"@conversation/ep3_trandoshan_borantok:s_585", "s_587"},
	}
}
ep3_borantok_convo:addScreen(ep3_borantok_convo_s_583)

ep3_borantok_convo_s_587 = ConvoScreen:new {
	id = "s_587",
	animation = "nod_head_multiple",
	leftDialog = "@conversation/ep3_trandoshan_borantok:s_587",
	stopConversation = "true",
	options = {
	}
}
ep3_borantok_convo:addScreen(ep3_borantok_convo_s_587)

ep3_borantok_convo_s_507 = ConvoScreen:new {
	id = "s_507",
	animation = "dismiss",
	leftDialog = "@conversation/ep3_trandoshan_borantok:s_507",
	stopConversation = "true",
	options = {
	}
}
ep3_borantok_convo:addScreen(ep3_borantok_convo_s_507)

ep3_borantok_convo_s_509 = ConvoScreen:new {
	id = "s_509",
	animation = "whisper",
	leftDialog = "@conversation/ep3_trandoshan_borantok:s_509",
	stopConversation = "false",
	options = {
		{"@conversation/ep3_trandoshan_borantok:s_511", "s_513"},
	}
}
ep3_borantok_convo:addScreen(ep3_borantok_convo_s_509)

ep3_borantok_convo_s_515 = ConvoScreen:new {
	id = "s_515",
	animation = "rub_chin_thoughtful",
	leftDialog = "@conversation/ep3_trandoshan_borantok:s_515",
	stopConversation = "false",
	options = {
		{"@conversation/ep3_trandoshan_borantok:s_517", "s_519"},
	}
}
ep3_borantok_convo:addScreen(ep3_borantok_convo_s_515)

ep3_borantok_convo_s_521 = ConvoScreen:new {
	id = "s_521",
	animation = "whisper",
	leftDialog = "@conversation/ep3_trandoshan_borantok:s_521",
	stopConversation = "false",
	options = {
		{"@conversation/ep3_trandoshan_borantok:s_523", "s_525"},
	}
}
ep3_borantok_convo:addScreen(ep3_borantok_convo_s_521)

ep3_borantok_convo_s_549 = ConvoScreen:new {
	id = "s_549",
	animation = "whisper",
	leftDialog = "@conversation/ep3_trandoshan_borantok:s_549",
	stopConversation = "false",
	options = {
		{"@conversation/ep3_trandoshan_borantok:s_551", "s_553"},
	}
}
ep3_borantok_convo:addScreen(ep3_borantok_convo_s_549)

ep3_borantok_convo_s_555 = ConvoScreen:new {
	id = "s_555",
	animation = "beckon",
	leftDialog = "@conversation/ep3_trandoshan_borantok:s_555",
	stopConversation = "false",
	options = {
		{"@conversation/ep3_trandoshan_borantok:s_557", "s_559"},
		{"@conversation/ep3_trandoshan_borantok:s_593", "s_595"},
	}
}
ep3_borantok_convo:addScreen(ep3_borantok_convo_s_555)

addConversationTemplate("ep3_borantok_convo", ep3_borantok_convo)
