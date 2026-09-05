-- Zhadran (Outcast Informant) -- ep3_forest_outcast_contact, ep3_forest_cryl_quest_2, ep3_forest_kerritamba_epic_7, ep3_forest_outcast_assassin, ep3_forest_wirartu_epic_2, ep3_forest_wirartu_epic_3
-- ruling 2026-09-04: "ensure kashyyyk is fully done"
-- Transcribed from the giver's java branches. Strings are shipped keys.
-- The journal row for quest/ep3_forest_*.qst comes from the integration branch later; this arc does not call the Journal API.

ep3_forest_outcast_informant_convo = ConvoTemplate:new {
	initialScreen = "s_662",
	templateType = "Lua",
	luaClassHandler = "ep3_forest_outcast_informant_conv_handler",
	screens = {}
}

ep3_forest_outcast_informant_convo_s_583 = ConvoScreen:new {
	id = "s_583",
	leftDialog = "@conversation/ep3_forest_outcast_informant:s_583", -- What are you doing milling around out here? You should get back to the Society. I can't be seen talking to ...
	stopConversation = "false",
	options = {
		{"@conversation/ep3_forest_outcast_informant:s_586", "s_590"},
	}
}
ep3_forest_outcast_informant_convo:addScreen(ep3_forest_outcast_informant_convo_s_583)

ep3_forest_outcast_informant_convo_s_594 = ConvoScreen:new {
	id = "s_594",
	leftDialog = "@conversation/ep3_forest_outcast_informant:s_594", -- [Zhadran smirks.] I thought I'd never see you again. What are you now? Grunt? Merc? Surely, not Exemplar.
	stopConversation = "false",
	options = {
		{"@conversation/ep3_forest_outcast_informant:s_598", "s_602"},
	}
}
ep3_forest_outcast_informant_convo:addScreen(ep3_forest_outcast_informant_convo_s_594)

ep3_forest_outcast_informant_convo_s_616 = ConvoScreen:new {
	id = "s_616",
	leftDialog = "@conversation/ep3_forest_outcast_informant:s_616", -- Why have you returned?
	stopConversation = "false",
	options = {
		{"@conversation/ep3_forest_outcast_informant:s_618", "s_675"},
		{"@conversation/ep3_forest_outcast_informant:s_626", "s_624"},
	}
}
ep3_forest_outcast_informant_convo:addScreen(ep3_forest_outcast_informant_convo_s_616)

ep3_forest_outcast_informant_convo_s_628 = ConvoScreen:new {
	id = "s_628",
	leftDialog = "@conversation/ep3_forest_outcast_informant:s_628", -- [Zhadran looks you over briefly.] You survived..
	stopConversation = "false",
	options = {
		{"@conversation/ep3_forest_outcast_informant:s_630", "s_636"},
		{"@conversation/ep3_forest_outcast_informant:s_634", "s_636"},
	}
}
ep3_forest_outcast_informant_convo:addScreen(ep3_forest_outcast_informant_convo_s_628)

ep3_forest_outcast_informant_convo_s_638 = ConvoScreen:new {
	id = "s_638",
	leftDialog = "@conversation/ep3_forest_outcast_informant:s_638", -- [Zhadran nods.] Ahh, an intelligent one. Good. You have dodged your first trial effortlessly and have chose...
	stopConversation = "false",
	options = {
		{"@conversation/ep3_forest_outcast_informant:s_640", "s_642"},
	}
}
ep3_forest_outcast_informant_convo:addScreen(ep3_forest_outcast_informant_convo_s_638)

ep3_forest_outcast_informant_convo_s_652 = ConvoScreen:new {
	id = "s_652",
	leftDialog = "@conversation/ep3_forest_outcast_informant:s_652", -- I see the Kerritamba have yet again pierced the skin of the ignorant with their deceiving talons. You shoul...
	stopConversation = "false",
	options = {
		{"@conversation/ep3_forest_outcast_informant:s_654", "s_656"},
	}
}
ep3_forest_outcast_informant_convo:addScreen(ep3_forest_outcast_informant_convo_s_652)

ep3_forest_outcast_informant_convo_s_662 = ConvoScreen:new {
	id = "s_662",
	leftDialog = "@conversation/ep3_forest_outcast_informant:s_662", -- [Zhadran smiles knowingly.] Another Kerritamba puppet. Such a pity.
	stopConversation = "false",
	options = {
		{"@conversation/ep3_forest_outcast_informant:s_664", "s_666"},
	}
}
ep3_forest_outcast_informant_convo:addScreen(ep3_forest_outcast_informant_convo_s_662)

ep3_forest_outcast_informant_convo_s_590 = ConvoScreen:new {
	id = "s_590",
	leftDialog = "@conversation/ep3_forest_outcast_informant:s_590", -- [Zhadran laughs.] Always. Now, get along. I have work to do.
	stopConversation = "true",
	options = {}
}
ep3_forest_outcast_informant_convo:addScreen(ep3_forest_outcast_informant_convo_s_590)

ep3_forest_outcast_informant_convo_s_602 = ConvoScreen:new {
	id = "s_602",
	leftDialog = "@conversation/ep3_forest_outcast_informant:s_602", -- It's good to see you've moved up in the world, however small that may be. What do you have for me?
	stopConversation = "false",
	options = {
		{"@conversation/ep3_forest_outcast_informant:s_606", "s_610"},
	}
}
ep3_forest_outcast_informant_convo:addScreen(ep3_forest_outcast_informant_convo_s_602)

ep3_forest_outcast_informant_convo_s_610 = ConvoScreen:new {
	id = "s_610",
	leftDialog = "@conversation/ep3_forest_outcast_informant:s_610", -- Ahh. Well done. In return, give him this. He'll know you were successful if you show it to him.
	stopConversation = "false",
	options = {
		{"@conversation/ep3_forest_outcast_informant:s_612", "s_614"},
	}
}
ep3_forest_outcast_informant_convo:addScreen(ep3_forest_outcast_informant_convo_s_610)

ep3_forest_outcast_informant_convo_s_614 = ConvoScreen:new {
	id = "s_614",
	leftDialog = "@conversation/ep3_forest_outcast_informant:s_614", -- Good to see you again, merc. [Zhadran smiles slyly.]
	stopConversation = "true",
	options = {}
}
ep3_forest_outcast_informant_convo:addScreen(ep3_forest_outcast_informant_convo_s_614)

ep3_forest_outcast_informant_convo_s_620 = ConvoScreen:new {
	id = "s_620",
	leftDialog = "@conversation/ep3_forest_outcast_informant:s_620", -- Follow the river to the waterfall. There, you'll find a cave littered with Webweavers. Fight past them into...
	stopConversation = "false",
	options = {
		{"@conversation/ep3_forest_outcast_informant:s_622", "s_624"},
	}
}
ep3_forest_outcast_informant_convo:addScreen(ep3_forest_outcast_informant_convo_s_620)

ep3_forest_outcast_informant_convo_s_675 = ConvoScreen:new {
	id = "s_675",
	leftDialog = "@conversation/ep3_forest_outcast_informant:s_675", -- Then, I bid you away. The Kerritamba are watching.
	stopConversation = "true",
	options = {}
}
ep3_forest_outcast_informant_convo:addScreen(ep3_forest_outcast_informant_convo_s_675)

ep3_forest_outcast_informant_convo_s_624 = ConvoScreen:new {
	id = "s_624",
	leftDialog = "@conversation/ep3_forest_outcast_informant:s_624", -- Now hurry. I hve other things to which I must attend.
	stopConversation = "true",
	options = {}
}
ep3_forest_outcast_informant_convo:addScreen(ep3_forest_outcast_informant_convo_s_624)

ep3_forest_outcast_informant_convo_s_632 = ConvoScreen:new {
	id = "s_632",
	leftDialog = "@conversation/ep3_forest_outcast_informant:s_632", -- [Zhadran turns back to his work, only the trace of a smile left on his face.]
	stopConversation = "true",
	options = {}
}
ep3_forest_outcast_informant_convo:addScreen(ep3_forest_outcast_informant_convo_s_632)

ep3_forest_outcast_informant_convo_s_636 = ConvoScreen:new {
	id = "s_636",
	leftDialog = "@conversation/ep3_forest_outcast_informant:s_636", -- Me? I would do no such thing. You must be mistaken. [Zhadran chuckles.] Move along. I have work to do.
	stopConversation = "true",
	options = {}
}
ep3_forest_outcast_informant_convo:addScreen(ep3_forest_outcast_informant_convo_s_636)

ep3_forest_outcast_informant_convo_s_642 = ConvoScreen:new {
	id = "s_642",
	leftDialog = "@conversation/ep3_forest_outcast_informant:s_642", -- [Zhadran leans in closer.] We are the Outcasts and, fortunately enough for you, the Kerritamba has labeled ...
	stopConversation = "false",
	options = {
		{"@conversation/ep3_forest_outcast_informant:s_644", "s_646"},
	}
}
ep3_forest_outcast_informant_convo:addScreen(ep3_forest_outcast_informant_convo_s_642)

ep3_forest_outcast_informant_convo_s_646 = ConvoScreen:new {
	id = "s_646",
	leftDialog = "@conversation/ep3_forest_outcast_informant:s_646", -- [Zhadran arches a brow.] Yes... you'll fit in nicely. [Zhadran smiles slyly as if thinking to himself.] Hmm...
	stopConversation = "false",
	options = {
		{"@conversation/ep3_forest_outcast_informant:s_648", "s_650"},
	}
}
ep3_forest_outcast_informant_convo:addScreen(ep3_forest_outcast_informant_convo_s_646)

ep3_forest_outcast_informant_convo_s_650 = ConvoScreen:new {
	id = "s_650",
	leftDialog = "@conversation/ep3_forest_outcast_informant:s_650", -- Exactly. [Zhadran nods.]
	stopConversation = "true",
	options = {}
}
ep3_forest_outcast_informant_convo:addScreen(ep3_forest_outcast_informant_convo_s_650)

ep3_forest_outcast_informant_convo_s_656 = ConvoScreen:new {
	id = "s_656",
	leftDialog = "@conversation/ep3_forest_outcast_informant:s_656", -- That is of no concern to you now, now is it? You've already made your choice.
	stopConversation = "false",
	options = {
		{"@conversation/ep3_forest_outcast_informant:s_658", "s_660"},
	}
}
ep3_forest_outcast_informant_convo:addScreen(ep3_forest_outcast_informant_convo_s_656)

ep3_forest_outcast_informant_convo_s_660 = ConvoScreen:new {
	id = "s_660",
	leftDialog = "@conversation/ep3_forest_outcast_informant:s_660", -- [Zhadran just smiles.] So fierce, yet so naive. Fine then. Be gone. I have work to do.
	stopConversation = "true",
	options = {}
}
ep3_forest_outcast_informant_convo:addScreen(ep3_forest_outcast_informant_convo_s_660)

ep3_forest_outcast_informant_convo_s_666 = ConvoScreen:new {
	id = "s_666",
	leftDialog = "@conversation/ep3_forest_outcast_informant:s_666", -- You'll see in due time, my friend. When the time comes, you must make the choice... will you be a puppet? O...
	stopConversation = "false",
	options = {
		{"@conversation/ep3_forest_outcast_informant:s_668", "s_670"},
	}
}
ep3_forest_outcast_informant_convo:addScreen(ep3_forest_outcast_informant_convo_s_666)

ep3_forest_outcast_informant_convo_s_670 = ConvoScreen:new {
	id = "s_670",
	leftDialog = "@conversation/ep3_forest_outcast_informant:s_670", -- [Zhadran just smiles.] You'll see soon enough. Just keep my words in mind, won't you? Keep your eyes open t...
	stopConversation = "false",
	options = {
		{"@conversation/ep3_forest_outcast_informant:s_672", "s_674"},
	}
}
ep3_forest_outcast_informant_convo:addScreen(ep3_forest_outcast_informant_convo_s_670)

ep3_forest_outcast_informant_convo_s_674 = ConvoScreen:new {
	id = "s_674",
	leftDialog = "@conversation/ep3_forest_outcast_informant:s_674", -- [Zhadran returns to his work, but not without sending a knowing wink your way.]
	stopConversation = "true",
	options = {}
}
ep3_forest_outcast_informant_convo:addScreen(ep3_forest_outcast_informant_convo_s_674)

addConversationTemplate("ep3_forest_outcast_informant_convo", ep3_forest_outcast_informant_convo)
