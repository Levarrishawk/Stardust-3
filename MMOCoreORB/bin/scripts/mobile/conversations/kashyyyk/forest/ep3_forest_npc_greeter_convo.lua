-- Kerritamba Greeter (NPC Greeter) -- no quests
-- ruling 2026-09-04: "ensure kashyyyk is fully done"
-- Transcribed from the giver's java branches. Strings are shipped keys.
-- The journal row for quest/ep3_forest_*.qst comes from the integration branch later; this arc does not call the Journal API.

ep3_forest_npc_greeter_convo = ConvoTemplate:new {
	initialScreen = "s_4",
	templateType = "Lua",
	luaClassHandler = "ep3_forest_npc_greeter_conv_handler",
	screens = {}
}

ep3_forest_npc_greeter_convo_s_4 = ConvoScreen:new {
	id = "s_4",
	leftDialog = "@conversation/ep3_forest_npc_greeter:s_4", -- [Shaey nods to you.] Looks like you're a little lost...
	stopConversation = "false",
	options = {
		{"@conversation/ep3_forest_npc_greeter:s_6", "s_8"},
	}
}
ep3_forest_npc_greeter_convo:addScreen(ep3_forest_npc_greeter_convo_s_4)

ep3_forest_npc_greeter_convo_s_8 = ConvoScreen:new {
	id = "s_8",
	leftDialog = "@conversation/ep3_forest_npc_greeter:s_8", -- Ah, I see. Let me introduce myself. [Shaey bows.] I am Shaey Kayr, Kashyyyk Explorer extraordinaire! I know...
	stopConversation = "false",
	options = {
		{"@conversation/ep3_forest_npc_greeter:s_10", "s_78"},
	}
}
ep3_forest_npc_greeter_convo:addScreen(ep3_forest_npc_greeter_convo_s_8)

ep3_forest_npc_greeter_convo_s_78 = ConvoScreen:new {
	id = "s_78",
	leftDialog = "@conversation/ep3_forest_npc_greeter:s_78", -- There's certain areas of the Kkowir Forest that make up its cold charm. Which area do you want to know abou...
	stopConversation = "false",
	options = {
		{"@conversation/ep3_forest_npc_greeter:s_79", "s_177"},
		{"@conversation/ep3_forest_npc_greeter:s_80", "s_108"},
		{"@conversation/ep3_forest_npc_greeter:s_81", "s_177"},
		{"@conversation/ep3_forest_npc_greeter:s_82", "s_111"},
		{"@conversation/ep3_forest_npc_greeter:s_83", "s_177"},
		{"@conversation/ep3_forest_npc_greeter:s_84", "s_105"},
		{"@conversation/ep3_forest_npc_greeter:s_176", "s_177"},
	}
}
ep3_forest_npc_greeter_convo:addScreen(ep3_forest_npc_greeter_convo_s_78)

ep3_forest_npc_greeter_convo_s_106 = ConvoScreen:new {
	id = "s_106",
	leftDialog = "@conversation/ep3_forest_npc_greeter:s_106", -- The Dead Forest is a dangerous place. I don't recommend going there. [Shaey shrugs.] The Sayormi live there...
	stopConversation = "false",
	options = {
		{"@conversation/ep3_forest_npc_greeter:s_107", "s_108"},
	}
}
ep3_forest_npc_greeter_convo:addScreen(ep3_forest_npc_greeter_convo_s_106)

ep3_forest_npc_greeter_convo_s_109 = ConvoScreen:new {
	id = "s_109",
	leftDialog = "@conversation/ep3_forest_npc_greeter:s_109", -- As expected, webweaver spiders live there, guarded by their Outcast friends. The Outcasts are people who ha...
	stopConversation = "false",
	options = {
		{"@conversation/ep3_forest_npc_greeter:s_110", "s_111"},
	}
}
ep3_forest_npc_greeter_convo:addScreen(ep3_forest_npc_greeter_convo_s_109)

ep3_forest_npc_greeter_convo_s_103 = ConvoScreen:new {
	id = "s_103",
	leftDialog = "@conversation/ep3_forest_npc_greeter:s_103", -- Ahh... the Kerritamba village. The Kerritamba village is led by Chief Kerritamba who comes from a long, str...
	stopConversation = "false",
	options = {
		{"@conversation/ep3_forest_npc_greeter:s_104", "s_105"},
	}
}
ep3_forest_npc_greeter_convo:addScreen(ep3_forest_npc_greeter_convo_s_103)

ep3_forest_npc_greeter_convo_s_112 = ConvoScreen:new {
	id = "s_112",
	leftDialog = "@conversation/ep3_forest_npc_greeter:s_112", -- The Great Tree, also known to the Kerritamba people as Nyenthi'Oris, lives on the island to the north, past...
	stopConversation = "false",
	options = {
		{"@conversation/ep3_forest_npc_greeter:s_168", "s_169"},
	}
}
ep3_forest_npc_greeter_convo:addScreen(ep3_forest_npc_greeter_convo_s_112)

ep3_forest_npc_greeter_convo_s_170 = ConvoScreen:new {
	id = "s_170",
	leftDialog = "@conversation/ep3_forest_npc_greeter:s_170", -- The Myyydril Caverns is a mystery to those not living within its cold, damp walls. You'll have to travel th...
	stopConversation = "false",
	options = {
		{"@conversation/ep3_forest_npc_greeter:s_171", "s_172"},
	}
}
ep3_forest_npc_greeter_convo:addScreen(ep3_forest_npc_greeter_convo_s_170)

ep3_forest_npc_greeter_convo_s_175 = ConvoScreen:new {
	id = "s_175",
	leftDialog = "@conversation/ep3_forest_npc_greeter:s_175", -- Well, you have several options. You can visit the Kerritamba village and speak with Chief Kerritamba or you...
	stopConversation = "false",
	options = {
		{"@conversation/ep3_forest_npc_greeter:s_79", "s_177"},
		{"@conversation/ep3_forest_npc_greeter:s_80", "s_108"},
		{"@conversation/ep3_forest_npc_greeter:s_81", "s_177"},
		{"@conversation/ep3_forest_npc_greeter:s_82", "s_111"},
		{"@conversation/ep3_forest_npc_greeter:s_83", "s_177"},
		{"@conversation/ep3_forest_npc_greeter:s_84", "s_105"},
		{"@conversation/ep3_forest_npc_greeter:s_176", "s_177"},
	}
}
ep3_forest_npc_greeter_convo:addScreen(ep3_forest_npc_greeter_convo_s_175)

ep3_forest_npc_greeter_convo_s_177 = ConvoScreen:new {
	id = "s_177",
	leftDialog = "@conversation/ep3_forest_npc_greeter:s_177", -- I hope you'll be safe. [Shaey bows and waves.]
	stopConversation = "true",
	options = {}
}
ep3_forest_npc_greeter_convo:addScreen(ep3_forest_npc_greeter_convo_s_177)

ep3_forest_npc_greeter_convo_s_108 = ConvoScreen:new {
	id = "s_108",
	leftDialog = "@conversation/ep3_forest_npc_greeter:s_108", -- What other area do you want to learn about?
	stopConversation = "false",
	options = {
		{"@conversation/ep3_forest_npc_greeter:s_79", "s_177"},
		{"@conversation/ep3_forest_npc_greeter:s_80", "s_108"},
		{"@conversation/ep3_forest_npc_greeter:s_81", "s_177"},
		{"@conversation/ep3_forest_npc_greeter:s_82", "s_111"},
		{"@conversation/ep3_forest_npc_greeter:s_83", "s_177"},
		{"@conversation/ep3_forest_npc_greeter:s_84", "s_105"},
		{"@conversation/ep3_forest_npc_greeter:s_176", "s_177"},
	}
}
ep3_forest_npc_greeter_convo:addScreen(ep3_forest_npc_greeter_convo_s_108)

ep3_forest_npc_greeter_convo_s_111 = ConvoScreen:new {
	id = "s_111",
	leftDialog = "@conversation/ep3_forest_npc_greeter:s_111", -- Not likely. What other area do you want to learn about?
	stopConversation = "false",
	options = {
		{"@conversation/ep3_forest_npc_greeter:s_79", "s_177"},
		{"@conversation/ep3_forest_npc_greeter:s_80", "s_108"},
		{"@conversation/ep3_forest_npc_greeter:s_81", "s_177"},
		{"@conversation/ep3_forest_npc_greeter:s_82", "s_111"},
		{"@conversation/ep3_forest_npc_greeter:s_83", "s_177"},
		{"@conversation/ep3_forest_npc_greeter:s_84", "s_105"},
		{"@conversation/ep3_forest_npc_greeter:s_176", "s_177"},
	}
}
ep3_forest_npc_greeter_convo:addScreen(ep3_forest_npc_greeter_convo_s_111)

ep3_forest_npc_greeter_convo_s_105 = ConvoScreen:new {
	id = "s_105",
	leftDialog = "@conversation/ep3_forest_npc_greeter:s_105", -- Indeed. What other area do you want to learn about?
	stopConversation = "false",
	options = {
		{"@conversation/ep3_forest_npc_greeter:s_79", "s_177"},
		{"@conversation/ep3_forest_npc_greeter:s_80", "s_108"},
		{"@conversation/ep3_forest_npc_greeter:s_81", "s_177"},
		{"@conversation/ep3_forest_npc_greeter:s_82", "s_111"},
		{"@conversation/ep3_forest_npc_greeter:s_83", "s_177"},
		{"@conversation/ep3_forest_npc_greeter:s_84", "s_105"},
		{"@conversation/ep3_forest_npc_greeter:s_176", "s_177"},
	}
}
ep3_forest_npc_greeter_convo:addScreen(ep3_forest_npc_greeter_convo_s_105)

ep3_forest_npc_greeter_convo_s_169 = ConvoScreen:new {
	id = "s_169",
	leftDialog = "@conversation/ep3_forest_npc_greeter:s_169", -- You'll have to speak with him about that. What other area do you want to learn about?
	stopConversation = "false",
	options = {
		{"@conversation/ep3_forest_npc_greeter:s_79", "s_177"},
		{"@conversation/ep3_forest_npc_greeter:s_80", "s_108"},
		{"@conversation/ep3_forest_npc_greeter:s_81", "s_177"},
		{"@conversation/ep3_forest_npc_greeter:s_82", "s_111"},
		{"@conversation/ep3_forest_npc_greeter:s_83", "s_177"},
		{"@conversation/ep3_forest_npc_greeter:s_84", "s_105"},
		{"@conversation/ep3_forest_npc_greeter:s_176", "s_177"},
	}
}
ep3_forest_npc_greeter_convo:addScreen(ep3_forest_npc_greeter_convo_s_169)

ep3_forest_npc_greeter_convo_s_172 = ConvoScreen:new {
	id = "s_172",
	leftDialog = "@conversation/ep3_forest_npc_greeter:s_172", -- You must go north, past the Kerritamba village, to the Chenataa river. Follow it west until you see a small...
	stopConversation = "false",
	options = {
		{"@conversation/ep3_forest_npc_greeter:s_173", "s_174"},
	}
}
ep3_forest_npc_greeter_convo:addScreen(ep3_forest_npc_greeter_convo_s_172)

ep3_forest_npc_greeter_convo_s_174 = ConvoScreen:new {
	id = "s_174",
	leftDialog = "@conversation/ep3_forest_npc_greeter:s_174", -- What other area do you want to learn about?
	stopConversation = "false",
	options = {
		{"@conversation/ep3_forest_npc_greeter:s_79", "s_177"},
		{"@conversation/ep3_forest_npc_greeter:s_80", "s_108"},
		{"@conversation/ep3_forest_npc_greeter:s_81", "s_177"},
		{"@conversation/ep3_forest_npc_greeter:s_82", "s_111"},
		{"@conversation/ep3_forest_npc_greeter:s_83", "s_177"},
		{"@conversation/ep3_forest_npc_greeter:s_84", "s_105"},
		{"@conversation/ep3_forest_npc_greeter:s_176", "s_177"},
	}
}
ep3_forest_npc_greeter_convo:addScreen(ep3_forest_npc_greeter_convo_s_174)

addConversationTemplate("ep3_forest_npc_greeter_convo", ep3_forest_npc_greeter_convo)
