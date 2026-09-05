-- Lolo -- ground tree for ep3_kachirho_trando_rifle_crafting. Mobile already carries ep3_wke_lolo_convotemplate (space inspect); this file is not attached.
-- ruling 2026-09-04: "ensure kashyyyk is done in full"
-- Transcribed from the giver's java branches. Strings are shipped keys.
-- The journal row for quest/ep3_kachirho_*.qst comes from the integration branch later; do not call Journal.*.

ep3_wke_lolo_ground_convo = ConvoTemplate:new {
	initialScreen = "s_100",
	templateType = "Lua",
	luaClassHandler = "ep3_wke_lolo_conv_handler",
	screens = {}
}

ep3_wke_lolo_ground_convo_s_87 = ConvoScreen:new {
	id = "s_87",
	leftDialog = "@conversation/ep3_kachirho_lolo:s_87", -- Rowarro. Grrrrllll. Roorroww.
	stopConversation = "true",
	options = {}
}
ep3_wke_lolo_ground_convo:addScreen(ep3_wke_lolo_ground_convo_s_87)

ep3_wke_lolo_ground_convo_s_254 = ConvoScreen:new {
	id = "s_254",
	leftDialog = "@conversation/ep3_kachirho_lolo:s_254", -- There is nothing more that I can do for you.
	stopConversation = "false",
	options = {
		{"@conversation/ep3_kachirho_lolo:s_255", "s_257"},
		{"@conversation/ep3_kachirho_lolo:s_256", "s_258"},
	}
}
ep3_wke_lolo_ground_convo:addScreen(ep3_wke_lolo_ground_convo_s_254)

ep3_wke_lolo_ground_convo_s_88 = ConvoScreen:new {
	id = "s_88",
	leftDialog = "@conversation/ep3_kachirho_lolo:s_88", -- Ah, you have the pieces. That is great. I will put them together for you and give you the correct part. Put this part together with the barrel and the power ...
	stopConversation = "true",
	options = {}
}
ep3_wke_lolo_ground_convo:addScreen(ep3_wke_lolo_ground_convo_s_88)

ep3_wke_lolo_ground_convo_s_89 = ConvoScreen:new {
	id = "s_89",
	leftDialog = "@conversation/ep3_kachirho_lolo:s_89", -- No luck with that pilot? No matter. He is still out there if you would like to give it another shot?
	stopConversation = "false",
	options = {
		{"@conversation/ep3_kachirho_lolo:s_105", "s_108"},
		{"@conversation/ep3_kachirho_lolo:s_106", "s_107"},
	}
}
ep3_wke_lolo_ground_convo:addScreen(ep3_wke_lolo_ground_convo_s_89)

ep3_wke_lolo_ground_convo_s_90 = ConvoScreen:new {
	id = "s_90",
	leftDialog = "@conversation/ep3_kachirho_lolo:s_90", -- I have told you everything I know. If you manage to get those parts for the feed mechanism I will happily put them together for you. Take care.
	stopConversation = "true",
	options = {}
}
ep3_wke_lolo_ground_convo:addScreen(ep3_wke_lolo_ground_convo_s_90)

ep3_wke_lolo_ground_convo_s_91 = ConvoScreen:new {
	id = "s_91",
	leftDialog = "@conversation/ep3_kachirho_lolo:s_91", -- Yes? What can I do for you on this fine day?
	stopConversation = "false",
	options = {
		{"@conversation/ep3_kachirho_lolo:s_101", "s_102"},
	}
}
ep3_wke_lolo_ground_convo:addScreen(ep3_wke_lolo_ground_convo_s_91)

ep3_wke_lolo_ground_convo_s_100 = ConvoScreen:new {
	id = "s_100",
	leftDialog = "@conversation/ep3_kachirho_lolo:s_100", -- Sorry...no time to talk. Work, work, work. I always have orders to fill and schedules to keep.
	stopConversation = "true",
	options = {}
}
ep3_wke_lolo_ground_convo:addScreen(ep3_wke_lolo_ground_convo_s_100)

ep3_wke_lolo_ground_convo_s_257 = ConvoScreen:new {
	id = "s_257",
	leftDialog = "@conversation/ep3_kachirho_lolo:s_257", -- Bye bye.
	stopConversation = "true",
	options = {}
}
ep3_wke_lolo_ground_convo:addScreen(ep3_wke_lolo_ground_convo_s_257)

ep3_wke_lolo_ground_convo_s_258 = ConvoScreen:new {
	id = "s_258",
	leftDialog = "@conversation/ep3_kachirho_lolo:s_258", -- Sure.
	stopConversation = "true",
	options = {}
}
ep3_wke_lolo_ground_convo:addScreen(ep3_wke_lolo_ground_convo_s_258)

ep3_wke_lolo_ground_convo_s_108 = ConvoScreen:new {
	id = "s_108",
	leftDialog = "@conversation/ep3_kachirho_lolo:s_108", -- Good luck to you.
	stopConversation = "true",
	options = {}
}
ep3_wke_lolo_ground_convo:addScreen(ep3_wke_lolo_ground_convo_s_108)

ep3_wke_lolo_ground_convo_s_107 = ConvoScreen:new {
	id = "s_107",
	leftDialog = "@conversation/ep3_kachirho_lolo:s_107", -- Take care then.
	stopConversation = "true",
	options = {}
}
ep3_wke_lolo_ground_convo:addScreen(ep3_wke_lolo_ground_convo_s_107)

ep3_wke_lolo_ground_convo_s_102 = ConvoScreen:new {
	id = "s_102",
	leftDialog = "@conversation/ep3_kachirho_lolo:s_102", -- A bowcaster eh? Well, I am afraid that you came to the wrong place. I do not have any in stock at this time. Maybe I could put you on a waiting list.
	stopConversation = "false",
	options = {
		{"@conversation/ep3_kachirho_lolo:s_19", "s_76"},
	}
}
ep3_wke_lolo_ground_convo:addScreen(ep3_wke_lolo_ground_convo_s_102)

ep3_wke_lolo_ground_convo_s_76 = ConvoScreen:new {
	id = "s_76",
	leftDialog = "@conversation/ep3_kachirho_lolo:s_76", -- This is just great. I am sorry that Jobarkko wasted your time. The bowcaster is gone. Well...I guess technically not gone. I still have the schematics for it...
	stopConversation = "false",
	options = {
		{"@conversation/ep3_kachirho_lolo:s_77", "s_78"},
	}
}
ep3_wke_lolo_ground_convo:addScreen(ep3_wke_lolo_ground_convo_s_76)

ep3_wke_lolo_ground_convo_s_78 = ConvoScreen:new {
	id = "s_78",
	leftDialog = "@conversation/ep3_kachirho_lolo:s_78", -- Everyone was so excited about this new bowcaster that no one would actually wait for me to put it together. The resistance shows up here before I could assem...
	stopConversation = "false",
	options = {
		{"@conversation/ep3_kachirho_lolo:s_79", "s_80"},
	}
}
ep3_wke_lolo_ground_convo:addScreen(ep3_wke_lolo_ground_convo_s_78)

ep3_wke_lolo_ground_convo_s_80 = ConvoScreen:new {
	id = "s_80",
	leftDialog = "@conversation/ep3_kachirho_lolo:s_80", -- That shouldn't surprise you. How else do you think a relatively small group of Trandoshans can control an entire population.
	stopConversation = "false",
	options = {
		{"@conversation/ep3_kachirho_lolo:s_81", "s_82"},
	}
}
ep3_wke_lolo_ground_convo:addScreen(ep3_wke_lolo_ground_convo_s_80)

ep3_wke_lolo_ground_convo_s_82 = ConvoScreen:new {
	id = "s_82",
	leftDialog = "@conversation/ep3_kachirho_lolo:s_82", -- Bah! The Empire hasn't had an effective military in this sector for many years now. They leave the operation to their loyal lap dogs. If they had to operate ...
	stopConversation = "false",
	options = {
		{"@conversation/ep3_kachirho_lolo:s_83", "s_84"},
	}
}
ep3_wke_lolo_ground_convo:addScreen(ep3_wke_lolo_ground_convo_s_82)

ep3_wke_lolo_ground_convo_s_84 = ConvoScreen:new {
	id = "s_84",
	leftDialog = "@conversation/ep3_kachirho_lolo:s_84", -- The resistance spends most of their time fighting each other rather then fighting the Trandoshans. Everyone wants to be in charge. Take something as simple a...
	stopConversation = "false",
	options = {
		{"@conversation/ep3_kachirho_lolo:s_85", "s_92"},
	}
}
ep3_wke_lolo_ground_convo:addScreen(ep3_wke_lolo_ground_convo_s_84)

ep3_wke_lolo_ground_convo_s_92 = ConvoScreen:new {
	id = "s_92",
	leftDialog = "@conversation/ep3_kachirho_lolo:s_92", -- Well they started fighting and made a complete mess out of my store. Both groups grabbed parts of it and made a run for it. Not that those parts will do them...
	stopConversation = "false",
	options = {
		{"@conversation/ep3_kachirho_lolo:s_93", "s_94"},
	}
}
ep3_wke_lolo_ground_convo:addScreen(ep3_wke_lolo_ground_convo_s_92)

ep3_wke_lolo_ground_convo_s_94 = ConvoScreen:new {
	id = "s_94",
	leftDialog = "@conversation/ep3_kachirho_lolo:s_94", -- I can give you the schematic for the barrel and the bowcaster. They are useless to me now. As for the other stuff you will have to recover them from the Wook...
	stopConversation = "false",
	options = {
		{"@conversation/ep3_kachirho_lolo:s_95", "s_97"},
	}
}
ep3_wke_lolo_ground_convo:addScreen(ep3_wke_lolo_ground_convo_s_94)

ep3_wke_lolo_ground_convo_s_97 = ConvoScreen:new {
	id = "s_97",
	leftDialog = "@conversation/ep3_kachirho_lolo:s_97", -- I heard that the Wookiee who took the parts for the feed mechanism had hyperdrive problems and is still in the system. You can probably get a lock on his dis...
	stopConversation = "false",
	options = {
		{"@conversation/ep3_kachirho_lolo:s_98", "s_99"},
	}
}
ep3_wke_lolo_ground_convo:addScreen(ep3_wke_lolo_ground_convo_s_97)

ep3_wke_lolo_ground_convo_s_99 = ConvoScreen:new {
	id = "s_99",
	leftDialog = "@conversation/ep3_kachirho_lolo:s_99", -- No. Those power handlers are specifically designed for the new bowcaster. But I would be willing to bet that any number of the resistance fighters in the are...
	stopConversation = "false",
	options = {
		{"@conversation/ep3_kachirho_lolo:s_103", "s_104"},
	}
}
ep3_wke_lolo_ground_convo:addScreen(ep3_wke_lolo_ground_convo_s_99)

ep3_wke_lolo_ground_convo_s_104 = ConvoScreen:new {
	id = "s_104",
	leftDialog = "@conversation/ep3_kachirho_lolo:s_104", -- Make a barrel. Add that in with the power handler and the feed mechanism and you will have a bowcaster. It is extremely simple...even a unskilled weaponsmith...
	stopConversation = "true",
	options = {}
}
ep3_wke_lolo_ground_convo:addScreen(ep3_wke_lolo_ground_convo_s_104)

addConversationTemplate("ep3_wke_lolo_ground_convo", ep3_wke_lolo_ground_convo)
