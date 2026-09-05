-- ep3_etyyy_ehartt_brihnt -- Etyyy hunting-grounds ground conversation
-- ruling 2026-09-04: "ensure kashyyyk is fully done"
-- Transcribed from the giver's java branches. Strings are shipped keys.
-- The journal row for quest/ep3_hunt_*.qst comes from the integration branch later; do not call the journal engine.

ep3_etyyy_ehartt_brihnt_convo = ConvoTemplate:new {
	initialScreen = "s_1835",
	templateType = "Lua",
	luaClassHandler = "ep3_etyyy_ehartt_brihnt_conv_handler",
	screens = {}
}

ep3_etyyy_ehartt_brihnt_convo_s_1839 = ConvoScreen:new {
	id = "s_1839",
	leftDialog = "@conversation/ep3_etyyy_ehartt_brihnt:s_1839", -- Oh my, what is that disgusting thing?!!? Stoneleg's heart? The walluga named Stoneleg... that's its ...
	stopConversation = "true",
	options = {}
}
ep3_etyyy_ehartt_brihnt_convo:addScreen(ep3_etyyy_ehartt_brihnt_convo_s_1839)

ep3_etyyy_ehartt_brihnt_convo_s_1845 = ConvoScreen:new {
	id = "s_1845",
	leftDialog = "@conversation/ep3_etyyy_ehartt_brihnt:s_1845", -- Oh my, what is that disgusting thing?!!? Stoneleg's heart? The walluga named Stoneleg... that's its ...
	stopConversation = "true",
	options = {}
}
ep3_etyyy_ehartt_brihnt_convo:addScreen(ep3_etyyy_ehartt_brihnt_convo_s_1845)

ep3_etyyy_ehartt_brihnt_convo_s_1803 = ConvoScreen:new {
	id = "s_1803",
	leftDialog = "@conversation/ep3_etyyy_ehartt_brihnt:s_1803", -- Whatever. I need to ship these claws off to my buyer, so goodbye.
	stopConversation = "true",
	options = {}
}
ep3_etyyy_ehartt_brihnt_convo:addScreen(ep3_etyyy_ehartt_brihnt_convo_s_1803)

ep3_etyyy_ehartt_brihnt_convo_s_1807 = ConvoScreen:new {
	id = "s_1807",
	leftDialog = "@conversation/ep3_etyyy_ehartt_brihnt:s_1807", -- Fine. Goodbye!
	stopConversation = "true",
	options = {}
}
ep3_etyyy_ehartt_brihnt_convo:addScreen(ep3_etyyy_ehartt_brihnt_convo_s_1807)

ep3_etyyy_ehartt_brihnt_convo_s_1819 = ConvoScreen:new {
	id = "s_1819",
	leftDialog = "@conversation/ep3_etyyy_ehartt_brihnt:s_1819", -- Happy to help? Keep your flowery attitude to yourself, please. I find it difficult enough to trust y...
	stopConversation = "true",
	options = {}
}
ep3_etyyy_ehartt_brihnt_convo:addScreen(ep3_etyyy_ehartt_brihnt_convo_s_1819)

ep3_etyyy_ehartt_brihnt_convo_s_1831 = ConvoScreen:new {
	id = "s_1831",
	leftDialog = "@conversation/ep3_etyyy_ehartt_brihnt:s_1831", -- Fine. Goodbye!
	stopConversation = "true",
	options = {}
}
ep3_etyyy_ehartt_brihnt_convo:addScreen(ep3_etyyy_ehartt_brihnt_convo_s_1831)

ep3_etyyy_ehartt_brihnt_convo_s_1823 = ConvoScreen:new {
	id = "s_1823",
	leftDialog = "@conversation/ep3_etyyy_ehartt_brihnt:s_1823", -- Right. Be quick about it, won't you. I don't want to keep my buyer waiting any longer than necessary...
	stopConversation = "true",
	options = {}
}
ep3_etyyy_ehartt_brihnt_convo:addScreen(ep3_etyyy_ehartt_brihnt_convo_s_1823)

ep3_etyyy_ehartt_brihnt_convo_s_1827 = ConvoScreen:new {
	id = "s_1827",
	leftDialog = "@conversation/ep3_etyyy_ehartt_brihnt:s_1827", -- Fine. Goodbye!
	stopConversation = "true",
	options = {}
}
ep3_etyyy_ehartt_brihnt_convo:addScreen(ep3_etyyy_ehartt_brihnt_convo_s_1827)

ep3_etyyy_ehartt_brihnt_convo_s_1843 = ConvoScreen:new {
	id = "s_1843",
	leftDialog = "@conversation/ep3_etyyy_ehartt_brihnt:s_1843", -- Excellent. And take that awful heart thing with you. Or get rid of it. Or... oh, you're leaving it w...
	stopConversation = "true",
	options = {}
}
ep3_etyyy_ehartt_brihnt_convo:addScreen(ep3_etyyy_ehartt_brihnt_convo_s_1843)

ep3_etyyy_ehartt_brihnt_convo_s_1795 = ConvoScreen:new {
	id = "s_1795",
	leftDialog = "@conversation/ep3_etyyy_ehartt_brihnt:s_1795", -- Why are you back exactly? I've got things to do, and I think my stomach valve is acting up again. Ye...
	stopConversation = "false",
	options = {
		{"@conversation/ep3_etyyy_ehartt_brihnt:s_1797", "s_1845"},
	}
}
ep3_etyyy_ehartt_brihnt_convo:addScreen(ep3_etyyy_ehartt_brihnt_convo_s_1795)

ep3_etyyy_ehartt_brihnt_convo_s_1799 = ConvoScreen:new {
	id = "s_1799",
	leftDialog = "@conversation/ep3_etyyy_ehartt_brihnt:s_1799", -- You actually did it. 21 perfect walluga claws. Frankly, I never expected to see you again. Speaking ...
	stopConversation = "false",
	options = {
		{"@conversation/ep3_etyyy_ehartt_brihnt:s_1801", "s_1803"},
		{"@conversation/ep3_etyyy_ehartt_brihnt:s_1805", "s_1807"},
		{"@conversation/ep3_etyyy_ehartt_brihnt:s_1809", "s_1845"},
	}
}
ep3_etyyy_ehartt_brihnt_convo:addScreen(ep3_etyyy_ehartt_brihnt_convo_s_1799)

ep3_etyyy_ehartt_brihnt_convo_s_1811 = ConvoScreen:new {
	id = "s_1811",
	leftDialog = "@conversation/ep3_etyyy_ehartt_brihnt:s_1811", -- I don't see 21 perfect walluga claws. Don't waste time chatting with me. Go hunt.
	stopConversation = "false",
	options = {
		{"@conversation/ep3_etyyy_ehartt_brihnt:s_1813", "s_1845"},
	}
}
ep3_etyyy_ehartt_brihnt_convo:addScreen(ep3_etyyy_ehartt_brihnt_convo_s_1811)

ep3_etyyy_ehartt_brihnt_convo_s_1815 = ConvoScreen:new {
	id = "s_1815",
	animation = "greet",
	leftDialog = "@conversation/ep3_etyyy_ehartt_brihnt:s_1815", -- So you wanna be a hunter, eh? Right. Now i've seen everything. Impressing Tuwezz means nothing. He's...
	stopConversation = "false",
	options = {
		{"@conversation/ep3_etyyy_ehartt_brihnt:s_1817", "s_1819"},
		{"@conversation/ep3_etyyy_ehartt_brihnt:s_1829", "s_1831"},
		{"@conversation/ep3_etyyy_ehartt_brihnt:s_1833", "s_1845"},
	}
}
ep3_etyyy_ehartt_brihnt_convo:addScreen(ep3_etyyy_ehartt_brihnt_convo_s_1815)

ep3_etyyy_ehartt_brihnt_convo_s_1835 = ConvoScreen:new {
	id = "s_1835",
	leftDialog = "@conversation/ep3_etyyy_ehartt_brihnt:s_1835", -- Bah. They'll let anyone into Etyyy these days. I should complain to Sordaan about this. Or maybe jus...
	stopConversation = "false",
	options = {
		{"@conversation/ep3_etyyy_ehartt_brihnt:s_1837", "s_1845"},
	}
}
ep3_etyyy_ehartt_brihnt_convo:addScreen(ep3_etyyy_ehartt_brihnt_convo_s_1835)

addConversationTemplate("ep3_etyyy_ehartt_brihnt_convo", ep3_etyyy_ehartt_brihnt_convo)
