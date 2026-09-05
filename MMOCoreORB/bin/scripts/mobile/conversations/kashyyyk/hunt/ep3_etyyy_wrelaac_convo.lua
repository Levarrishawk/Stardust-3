-- ep3_etyyy_wrelaac -- Etyyy hunting-grounds ground conversation
-- ruling 2026-09-04: "ensure kashyyyk is fully done"
-- Transcribed from the giver's java branches. Strings are shipped keys.
-- The journal row for quest/ep3_hunt_*.qst comes from the integration branch later; do not call the journal engine.

ep3_etyyy_wrelaac_convo = ConvoTemplate:new {
	initialScreen = "s_108",
	templateType = "Lua",
	luaClassHandler = "ep3_etyyy_wrelaac_conv_handler",
	screens = {}
}

ep3_etyyy_wrelaac_convo_s_48 = ConvoScreen:new {
	id = "s_48",
	leftDialog = "@conversation/ep3_etyyy_wrelaac:s_48", -- Good luck. I hope you find that boy. Brody was a strange man, but he seemed alright.
	stopConversation = "true",
	options = {}
}
ep3_etyyy_wrelaac_convo:addScreen(ep3_etyyy_wrelaac_convo_s_48)

ep3_etyyy_wrelaac_convo_s_74 = ConvoScreen:new {
	id = "s_74",
	leftDialog = "@conversation/ep3_etyyy_wrelaac:s_74", -- Brody came to me about a year ago. He had an idea of some sort. Involved training native creatures h...
	stopConversation = "true",
	options = {}
}
ep3_etyyy_wrelaac_convo:addScreen(ep3_etyyy_wrelaac_convo_s_74)

ep3_etyyy_wrelaac_convo_s_54 = ConvoScreen:new {
	id = "s_54",
	leftDialog = "@conversation/ep3_etyyy_wrelaac:s_54", -- I remember that pendant. Sort of. Sounds like you do know Mada after all. Very well, what would you ...
	stopConversation = "true",
	options = {}
}
ep3_etyyy_wrelaac_convo:addScreen(ep3_etyyy_wrelaac_convo_s_54)

ep3_etyyy_wrelaac_convo_s_58 = ConvoScreen:new {
	id = "s_58",
	leftDialog = "@conversation/ep3_etyyy_wrelaac:s_58", -- Suit yourself. I'm not going anywhere. I think.
	stopConversation = "true",
	options = {}
}
ep3_etyyy_wrelaac_convo:addScreen(ep3_etyyy_wrelaac_convo_s_58)

ep3_etyyy_wrelaac_convo_s_64 = ConvoScreen:new {
	id = "s_64",
	leftDialog = "@conversation/ep3_etyyy_wrelaac:s_64", -- Right. If you do know Mada, go talk to her then come back with proof. Otherwise leave me and her alo...
	stopConversation = "true",
	options = {}
}
ep3_etyyy_wrelaac_convo:addScreen(ep3_etyyy_wrelaac_convo_s_64)

ep3_etyyy_wrelaac_convo_s_70 = ConvoScreen:new {
	id = "s_70",
	leftDialog = "@conversation/ep3_etyyy_wrelaac:s_70", -- Hmm, that sounds right. Very well, what would you like to know?
	stopConversation = "true",
	options = {}
}
ep3_etyyy_wrelaac_convo:addScreen(ep3_etyyy_wrelaac_convo_s_70)

ep3_etyyy_wrelaac_convo_s_90 = ConvoScreen:new {
	id = "s_90",
	leftDialog = "@conversation/ep3_etyyy_wrelaac:s_90", -- I didn't think so. You should mind your own business. Leave people be.
	stopConversation = "true",
	options = {}
}
ep3_etyyy_wrelaac_convo:addScreen(ep3_etyyy_wrelaac_convo_s_90)

ep3_etyyy_wrelaac_convo_s_94 = ConvoScreen:new {
	id = "s_94",
	leftDialog = "@conversation/ep3_etyyy_wrelaac:s_94", -- I didn't think so. You should mind your own business. Leave people be.
	stopConversation = "true",
	options = {}
}
ep3_etyyy_wrelaac_convo:addScreen(ep3_etyyy_wrelaac_convo_s_94)

ep3_etyyy_wrelaac_convo_s_98 = ConvoScreen:new {
	id = "s_98",
	leftDialog = "@conversation/ep3_etyyy_wrelaac:s_98", -- I didn't think so. You should mind your own business. Leave people be.
	stopConversation = "true",
	options = {}
}
ep3_etyyy_wrelaac_convo:addScreen(ep3_etyyy_wrelaac_convo_s_98)

ep3_etyyy_wrelaac_convo_s_102 = ConvoScreen:new {
	id = "s_102",
	leftDialog = "@conversation/ep3_etyyy_wrelaac:s_102", -- I didn't think so. You should mind your own business. Leave people be.
	stopConversation = "true",
	options = {}
}
ep3_etyyy_wrelaac_convo:addScreen(ep3_etyyy_wrelaac_convo_s_102)

ep3_etyyy_wrelaac_convo_s_106 = ConvoScreen:new {
	id = "s_106",
	leftDialog = "@conversation/ep3_etyyy_wrelaac:s_106", -- I didn't think so. You should mind your own business. Leave people be.
	stopConversation = "true",
	options = {}
}
ep3_etyyy_wrelaac_convo:addScreen(ep3_etyyy_wrelaac_convo_s_106)

ep3_etyyy_wrelaac_convo_s_78 = ConvoScreen:new {
	id = "s_78",
	leftDialog = "@conversation/ep3_etyyy_wrelaac:s_78", -- Chrilooc was one of the elders in Kachirho at the time. I sent Brody to speak with him. Never heard ...
	stopConversation = "true",
	options = {}
}
ep3_etyyy_wrelaac_convo:addScreen(ep3_etyyy_wrelaac_convo_s_78)

ep3_etyyy_wrelaac_convo_s_82 = ConvoScreen:new {
	id = "s_82",
	leftDialog = "@conversation/ep3_etyyy_wrelaac:s_82", -- He's usually somewhere in the city. Never wanders far. You might try looking out on the bridge. Chri...
	stopConversation = "true",
	options = {}
}
ep3_etyyy_wrelaac_convo:addScreen(ep3_etyyy_wrelaac_convo_s_82)

ep3_etyyy_wrelaac_convo_s_86 = ConvoScreen:new {
	id = "s_86",
	leftDialog = "@conversation/ep3_etyyy_wrelaac:s_86", -- Right. Off with you then. It's time for my nap. Or is it time for my walk? Drat it all.
	stopConversation = "true",
	options = {}
}
ep3_etyyy_wrelaac_convo:addScreen(ep3_etyyy_wrelaac_convo_s_86)

ep3_etyyy_wrelaac_convo_s_37 = ConvoScreen:new {
	id = "s_37",
	leftDialog = "@conversation/ep3_etyyy_wrelaac:s_37", -- Anwos cwowo. Cacoohaanwa Ac acrahwo ra ccworaan? Oor ccrarrwo rroo wwoor ra oraanor? Woacsacwor orar...
	stopConversation = "true",
	options = {}
}
ep3_etyyy_wrelaac_convo:addScreen(ep3_etyyy_wrelaac_convo_s_37)

ep3_etyyy_wrelaac_convo_s_40 = ConvoScreen:new {
	id = "s_40",
	leftDialog = "@conversation/ep3_etyyy_wrelaac:s_40", -- I heard about Brody. Told you he was a strange man. I can't understand why he'd want his sister to t...
	stopConversation = "true",
	options = {}
}
ep3_etyyy_wrelaac_convo:addScreen(ep3_etyyy_wrelaac_convo_s_40)

ep3_etyyy_wrelaac_convo_s_42 = ConvoScreen:new {
	id = "s_42",
	leftDialog = "@conversation/ep3_etyyy_wrelaac:s_42", -- Good luck finding Brody. I hope he's okay.
	stopConversation = "true",
	options = {}
}
ep3_etyyy_wrelaac_convo:addScreen(ep3_etyyy_wrelaac_convo_s_42)

ep3_etyyy_wrelaac_convo_s_44 = ConvoScreen:new {
	id = "s_44",
	leftDialog = "@conversation/ep3_etyyy_wrelaac:s_44", -- Go speak with Chrilooc. You'll probably find him out on the bridge.
	stopConversation = "false",
	options = {
		{"@conversation/ep3_etyyy_wrelaac:s_46", "s_48"},
	}
}
ep3_etyyy_wrelaac_convo:addScreen(ep3_etyyy_wrelaac_convo_s_44)

ep3_etyyy_wrelaac_convo_s_41 = ConvoScreen:new {
	id = "s_41",
	leftDialog = "@conversation/ep3_etyyy_wrelaac:s_41", -- Oh, it's you. I suppose I shouldn't be surprised. Very well, what would you like to know?
	stopConversation = "false",
	options = {
		{"@conversation/ep3_etyyy_wrelaac:s_72", "s_74"},
	}
}
ep3_etyyy_wrelaac_convo:addScreen(ep3_etyyy_wrelaac_convo_s_41)

ep3_etyyy_wrelaac_convo_s_50 = ConvoScreen:new {
	id = "s_50",
	leftDialog = "@conversation/ep3_etyyy_wrelaac:s_50", -- You again. Did you talk to Mada? What did she say?
	stopConversation = "false",
	options = {
		{"@conversation/ep3_etyyy_wrelaac:s_52", "s_54"},
		{"@conversation/ep3_etyyy_wrelaac:s_56", "s_58"},
	}
}
ep3_etyyy_wrelaac_convo:addScreen(ep3_etyyy_wrelaac_convo_s_50)

ep3_etyyy_wrelaac_convo_s_60 = ConvoScreen:new {
	id = "s_60",
	leftDialog = "@conversation/ep3_etyyy_wrelaac:s_60", -- What? Do you think I'm simply going to let you guess until you stumble across Mada's description. No...
	stopConversation = "false",
	options = {
		{"@conversation/ep3_etyyy_wrelaac:s_62", "s_64"},
	}
}
ep3_etyyy_wrelaac_convo:addScreen(ep3_etyyy_wrelaac_convo_s_60)

ep3_etyyy_wrelaac_convo_s_66 = ConvoScreen:new {
	id = "s_66",
	animation = "greet",
	leftDialog = "@conversation/ep3_etyyy_wrelaac:s_66", -- Who are you? Brody Johnson? Why are you asking about Brody Johnson? Oh, Mada Johnson sent you, did s...
	stopConversation = "false",
	options = {
		{"@conversation/ep3_etyyy_wrelaac:s_68", "s_70"},
		{"@conversation/ep3_etyyy_wrelaac:s_88", "s_90"},
		{"@conversation/ep3_etyyy_wrelaac:s_92", "s_94"},
		{"@conversation/ep3_etyyy_wrelaac:s_96", "s_98"},
		{"@conversation/ep3_etyyy_wrelaac:s_100", "s_102"},
		{"@conversation/ep3_etyyy_wrelaac:s_104", "s_106"},
	}
}
ep3_etyyy_wrelaac_convo:addScreen(ep3_etyyy_wrelaac_convo_s_66)

ep3_etyyy_wrelaac_convo_s_108 = ConvoScreen:new {
	id = "s_108",
	leftDialog = "@conversation/ep3_etyyy_wrelaac:s_108", -- Let's see. Should I have a meal? Or maybe go for a walk? Either way, a nap would be nice.
	stopConversation = "true",
	options = {}
}
ep3_etyyy_wrelaac_convo:addScreen(ep3_etyyy_wrelaac_convo_s_108)

addConversationTemplate("ep3_etyyy_wrelaac_convo", ep3_etyyy_wrelaac_convo)
