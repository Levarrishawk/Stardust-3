-- ep3_etyyy_iluna_mystuk -- Etyyy hunting-grounds ground conversation
-- ruling 2026-09-04: "ensure kashyyyk is fully done"
-- Transcribed from the giver's java branches. Strings are shipped keys.
-- The journal row for quest/ep3_hunt_*.qst comes from the integration branch later; do not call the journal engine.

ep3_etyyy_iluna_mystuk_convo = ConvoTemplate:new {
	initialScreen = "s_1773",
	templateType = "Lua",
	luaClassHandler = "ep3_etyyy_iluna_mystuk_conv_handler",
	screens = {}
}

ep3_etyyy_iluna_mystuk_convo_s_1777 = ConvoScreen:new {
	id = "s_1777",
	leftDialog = "@conversation/ep3_etyyy_iluna_mystuk:s_1777", -- That name sounds familiar. I think a Zabrak with that name went to the Arcona compound to the west. ...
	stopConversation = "true",
	options = {}
}
ep3_etyyy_iluna_mystuk_convo:addScreen(ep3_etyyy_iluna_mystuk_convo_s_1777)

ep3_etyyy_iluna_mystuk_convo_s_1781 = ConvoScreen:new {
	id = "s_1781",
	leftDialog = "@conversation/ep3_etyyy_iluna_mystuk:s_1781", -- And farewell to you also.
	stopConversation = "true",
	options = {}
}
ep3_etyyy_iluna_mystuk_convo:addScreen(ep3_etyyy_iluna_mystuk_convo_s_1781)

ep3_etyyy_iluna_mystuk_convo_s_1785 = ConvoScreen:new {
	id = "s_1785",
	leftDialog = "@conversation/ep3_etyyy_iluna_mystuk:s_1785", -- It's good that you came to me instead of Sordaan. He has an odd soft spot for the Kashyyyk bantha an...
	stopConversation = "false",
	options = {
		{"@conversation/ep3_etyyy_iluna_mystuk:s_1787", "s_1789"},
	}
}
ep3_etyyy_iluna_mystuk_convo:addScreen(ep3_etyyy_iluna_mystuk_convo_s_1785)

ep3_etyyy_iluna_mystuk_convo_s_1791 = ConvoScreen:new {
	id = "s_1791",
	leftDialog = "@conversation/ep3_etyyy_iluna_mystuk:s_1791", -- It's good that you came to me instead of Sordaan. He has an odd soft spot for the Kashyyyk bantha an...
	stopConversation = "true",
	options = {}
}
ep3_etyyy_iluna_mystuk_convo:addScreen(ep3_etyyy_iluna_mystuk_convo_s_1791)

ep3_etyyy_iluna_mystuk_convo_s_1789 = ConvoScreen:new {
	id = "s_1789",
	leftDialog = "@conversation/ep3_etyyy_iluna_mystuk:s_1789", -- Good. Go on then.
	stopConversation = "true",
	options = {}
}
ep3_etyyy_iluna_mystuk_convo:addScreen(ep3_etyyy_iluna_mystuk_convo_s_1789)

ep3_etyyy_iluna_mystuk_convo_s_1773 = ConvoScreen:new {
	id = "s_1773",
	leftDialog = "@conversation/ep3_etyyy_iluna_mystuk:s_1773", -- Welcome to the main Rodian hunting camp.
	stopConversation = "false",
	options = {
		{"@conversation/ep3_etyyy_iluna_mystuk:s_1775", "s_1777"},
		{"@conversation/ep3_etyyy_iluna_mystuk:s_1779", "s_1781"},
		{"@conversation/ep3_etyyy_iluna_mystuk:s_1783", "s_1791"},
	}
}
ep3_etyyy_iluna_mystuk_convo:addScreen(ep3_etyyy_iluna_mystuk_convo_s_1773)

addConversationTemplate("ep3_etyyy_iluna_mystuk_convo", ep3_etyyy_iluna_mystuk_convo)
