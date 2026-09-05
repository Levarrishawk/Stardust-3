-- ep3_etyyy_pilot_to_bocctyyy -- Etyyy to Bocctyyy shuttle
-- ruling 2026-09-04: "ensure kashyyyk is fully done"
-- Transcribed from conversation/ep3_etyyy_pilot_etyyy_to_bocctyyy.java. Strings are shipped keys.
-- No journal engine: this branch has no managers/quest/journal.lua.
-- OPEN: KashyyykIslands / BocctyyyTheBet are loaded by the dungeons branch; this branch does not include them.
-- OPEN: Bocctyyy path ticket / space_dungeon.KASH_THE_BET is not in this tree.
-- OPEN: god-mode ticket create is not implemented.

ep3_etyyy_pilot_to_bocctyyy_convo = ConvoTemplate:new {
	initialScreen = "s_706",
	templateType = "Lua",
	luaClassHandler = "ep3_etyyy_pilot_to_bocctyyy_conv_handler",
	screens = {}
}

ep3_etyyy_pilot_to_bocctyyy_convo_s_688 = ConvoScreen:new {
	id = "s_688",
	leftDialog = "@conversation/ep3_etyyy_pilot_etyyy_to_bocctyyy:s_688",
	stopConversation = "false",
	options = {
		{"@conversation/ep3_etyyy_pilot_etyyy_to_bocctyyy:s_690", "s_690"},
		{"@conversation/ep3_etyyy_pilot_etyyy_to_bocctyyy:s_696", "s_698"},
	}
}
ep3_etyyy_pilot_to_bocctyyy_convo:addScreen(ep3_etyyy_pilot_to_bocctyyy_convo_s_688)

ep3_etyyy_pilot_to_bocctyyy_convo_s_690 = ConvoScreen:new {
	id = "s_690",
	leftDialog = "@conversation/ep3_etyyy_pilot_etyyy_to_bocctyyy:s_690",
	stopConversation = "true",
	options = {}
}
ep3_etyyy_pilot_to_bocctyyy_convo:addScreen(ep3_etyyy_pilot_to_bocctyyy_convo_s_690)

ep3_etyyy_pilot_to_bocctyyy_convo_s_692 = ConvoScreen:new {
	id = "s_692",
	leftDialog = "@conversation/ep3_etyyy_pilot_etyyy_to_bocctyyy:s_692",
	stopConversation = "true",
	options = {}
}
ep3_etyyy_pilot_to_bocctyyy_convo:addScreen(ep3_etyyy_pilot_to_bocctyyy_convo_s_692)

ep3_etyyy_pilot_to_bocctyyy_convo_s_116 = ConvoScreen:new {
	id = "s_116",
	leftDialog = "@conversation/ep3_etyyy_pilot_etyyy_to_bocctyyy:s_116",
	stopConversation = "true",
	options = {}
}
ep3_etyyy_pilot_to_bocctyyy_convo:addScreen(ep3_etyyy_pilot_to_bocctyyy_convo_s_116)

ep3_etyyy_pilot_to_bocctyyy_convo_s_694 = ConvoScreen:new {
	id = "s_694",
	leftDialog = "@conversation/ep3_etyyy_pilot_etyyy_to_bocctyyy:s_694",
	stopConversation = "true",
	options = {}
}
ep3_etyyy_pilot_to_bocctyyy_convo:addScreen(ep3_etyyy_pilot_to_bocctyyy_convo_s_694)

ep3_etyyy_pilot_to_bocctyyy_convo_s_698 = ConvoScreen:new {
	id = "s_698",
	leftDialog = "@conversation/ep3_etyyy_pilot_etyyy_to_bocctyyy:s_698",
	stopConversation = "true",
	options = {}
}
ep3_etyyy_pilot_to_bocctyyy_convo:addScreen(ep3_etyyy_pilot_to_bocctyyy_convo_s_698)

ep3_etyyy_pilot_to_bocctyyy_convo_s_700 = ConvoScreen:new {
	id = "s_700",
	leftDialog = "@conversation/ep3_etyyy_pilot_etyyy_to_bocctyyy:s_700",
	stopConversation = "true",
	options = {}
}
ep3_etyyy_pilot_to_bocctyyy_convo:addScreen(ep3_etyyy_pilot_to_bocctyyy_convo_s_700)

ep3_etyyy_pilot_to_bocctyyy_convo_s_706 = ConvoScreen:new {
	id = "s_706",
	leftDialog = "@conversation/ep3_etyyy_pilot_etyyy_to_bocctyyy:s_706",
	stopConversation = "true",
	options = {}
}
ep3_etyyy_pilot_to_bocctyyy_convo:addScreen(ep3_etyyy_pilot_to_bocctyyy_convo_s_706)

addConversationTemplate("ep3_etyyy_pilot_to_bocctyyy_convo", ep3_etyyy_pilot_to_bocctyyy_convo)
