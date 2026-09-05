-- ep3_myyydril_patrol_leader
-- ruling 2026-09-04
-- Transcribed from the giver's java branches. Strings are shipped keys.
-- The journal row for quest/ep3_myyydril_*.qst comes from the integration branch later; do not call the journal API.

ep3_myyydril_patrol_leader_convo = ConvoTemplate:new {
	initialScreen = "s_529",
	templateType = "Lua",
	luaClassHandler = "ep3_myyydril_patrol_leader_conv_handler",
	screens = {}
}

ep3_myyydril_patrol_leader_convo_s_523 = ConvoScreen:new {
	id = "s_523",
	leftDialog = "@conversation/ep3_myyydril_patrol_leader:s_523", -- Rrowwrr!
	stopConversation = "true",
	options = {}
}
ep3_myyydril_patrol_leader_convo:addScreen(ep3_myyydril_patrol_leader_convo_s_523)

ep3_myyydril_patrol_leader_convo_s_525 = ConvoScreen:new {
	id = "s_525",
	leftDialog = "@conversation/ep3_myyydril_patrol_leader:s_525", -- I see you're still around. Keep moving. If I come across anything that will need additional attention, I'll let you know.
	stopConversation = "true",
	options = {}
}
ep3_myyydril_patrol_leader_convo:addScreen(ep3_myyydril_patrol_leader_convo_s_525)

ep3_myyydril_patrol_leader_convo_s_527 = ConvoScreen:new {
	id = "s_527",
	leftDialog = "@conversation/ep3_myyydril_patrol_leader:s_527", -- Are you lost? It would be wise to speak with our chief, Kallaarac. Our village is small. It won't be hard to find him.
	stopConversation = "true",
	options = {}
}
ep3_myyydril_patrol_leader_convo:addScreen(ep3_myyydril_patrol_leader_convo_s_527)

ep3_myyydril_patrol_leader_convo_s_529 = ConvoScreen:new {
	id = "s_529",
	leftDialog = "@conversation/ep3_myyydril_patrol_leader:s_529", -- Stop! What are you doing down here?
	stopConversation = "false",
	options = {
		{"@conversation/ep3_myyydril_patrol_leader:s_531", "s_533"},
	}
}
ep3_myyydril_patrol_leader_convo:addScreen(ep3_myyydril_patrol_leader_convo_s_529)

ep3_myyydril_patrol_leader_convo_s_533 = ConvoScreen:new {
	id = "s_533",
	leftDialog = "@conversation/ep3_myyydril_patrol_leader:s_533", -- You understand us. I find that odd, but welcoming nonetheless. Even if you're not a threat, you haven't answered my question. What are yo...
	stopConversation = "false",
	options = {
		{"@conversation/ep3_myyydril_patrol_leader:s_535", "s_537"},
	}
}
ep3_myyydril_patrol_leader_convo:addScreen(ep3_myyydril_patrol_leader_convo_s_533)

ep3_myyydril_patrol_leader_convo_s_537 = ConvoScreen:new {
	id = "s_537",
	leftDialog = "@conversation/ep3_myyydril_patrol_leader:s_537", -- This cavern isn't a place to be explored so carelessly! Do you know what's out there?
	stopConversation = "false",
	options = {
		{"@conversation/ep3_myyydril_patrol_leader:s_539", "s_541"},
	}
}
ep3_myyydril_patrol_leader_convo:addScreen(ep3_myyydril_patrol_leader_convo_s_537)

ep3_myyydril_patrol_leader_convo_s_541 = ConvoScreen:new {
	id = "s_541",
	leftDialog = "@conversation/ep3_myyydril_patrol_leader:s_541", -- I'm sorry, it's just that... I don't want to see another young one perish so needlessly.
	stopConversation = "false",
	options = {
		{"@conversation/ep3_myyydril_patrol_leader:s_543", "s_545"},
	}
}
ep3_myyydril_patrol_leader_convo:addScreen(ep3_myyydril_patrol_leader_convo_s_541)

ep3_myyydril_patrol_leader_convo_s_545 = ConvoScreen:new {
	id = "s_545",
	leftDialog = "@conversation/ep3_myyydril_patrol_leader:s_545", -- The Urnsor'is... they've been destroying our village, the cavern itself, for many years. Many have died... many young Myyydril.
	stopConversation = "false",
	options = {
		{"@conversation/ep3_myyydril_patrol_leader:s_547", "s_549"},
		{"@conversation/ep3_myyydril_patrol_leader:s_563", "s_565"},
		{"@conversation/ep3_myyydril_patrol_leader:s_575", "s_577"},
	}
}
ep3_myyydril_patrol_leader_convo:addScreen(ep3_myyydril_patrol_leader_convo_s_545)

ep3_myyydril_patrol_leader_convo_s_549 = ConvoScreen:new {
	id = "s_549",
	leftDialog = "@conversation/ep3_myyydril_patrol_leader:s_549", -- The Myyydril are a tribe of Wookiee, shunned by society and destined to live in this cavern. We are friendly to those who earn our trust....
	stopConversation = "false",
	options = {
		{"@conversation/ep3_myyydril_patrol_leader:s_551", "s_553"},
	}
}
ep3_myyydril_patrol_leader_convo:addScreen(ep3_myyydril_patrol_leader_convo_s_549)

ep3_myyydril_patrol_leader_convo_s_553 = ConvoScreen:new {
	id = "s_553",
	leftDialog = "@conversation/ep3_myyydril_patrol_leader:s_553", -- You're so naive. When you see them, you'll know.
	stopConversation = "false",
	options = {
		{"@conversation/ep3_myyydril_patrol_leader:s_555", "s_557"},
	}
}
ep3_myyydril_patrol_leader_convo:addScreen(ep3_myyydril_patrol_leader_convo_s_553)

ep3_myyydril_patrol_leader_convo_s_557 = ConvoScreen:new {
	id = "s_557",
	leftDialog = "@conversation/ep3_myyydril_patrol_leader:s_557", -- [Kivvaaa nods.] We usually don't accept others so willingly. However, we are in dire need... [Kivvaaa shrugs.] You can go speak with our ...
	stopConversation = "false",
	options = {
		{"@conversation/ep3_myyydril_patrol_leader:s_559", "s_561"},
	}
}
ep3_myyydril_patrol_leader_convo:addScreen(ep3_myyydril_patrol_leader_convo_s_557)

ep3_myyydril_patrol_leader_convo_s_561 = ConvoScreen:new {
	id = "s_561",
	leftDialog = "@conversation/ep3_myyydril_patrol_leader:s_561", -- [Kivvaaa nods.]
	stopConversation = "true",
	options = {}
}
ep3_myyydril_patrol_leader_convo:addScreen(ep3_myyydril_patrol_leader_convo_s_561)

ep3_myyydril_patrol_leader_convo_s_565 = ConvoScreen:new {
	id = "s_565",
	leftDialog = "@conversation/ep3_myyydril_patrol_leader:s_565", -- You're so naive. When you see them, you'll know.
	stopConversation = "false",
	options = {
		{"@conversation/ep3_myyydril_patrol_leader:s_567", "s_569"},
	}
}
ep3_myyydril_patrol_leader_convo:addScreen(ep3_myyydril_patrol_leader_convo_s_565)

ep3_myyydril_patrol_leader_convo_s_569 = ConvoScreen:new {
	id = "s_569",
	leftDialog = "@conversation/ep3_myyydril_patrol_leader:s_569", -- The Myyydril are a tribe of Wookiee, shunned by society and destined to live in this cavern. We are friendly to those who earn our trust....
	stopConversation = "false",
	options = {
		{"@conversation/ep3_myyydril_patrol_leader:s_571", "s_573"},
	}
}
ep3_myyydril_patrol_leader_convo:addScreen(ep3_myyydril_patrol_leader_convo_s_569)

ep3_myyydril_patrol_leader_convo_s_573 = ConvoScreen:new {
	id = "s_573",
	leftDialog = "@conversation/ep3_myyydril_patrol_leader:s_573", -- [Kivvaaa nods.] We are. However, we can admit to our failures and short-comings. We could always use more allies and help. You can go spe...
	stopConversation = "true",
	options = {}
}
ep3_myyydril_patrol_leader_convo:addScreen(ep3_myyydril_patrol_leader_convo_s_573)

ep3_myyydril_patrol_leader_convo_s_577 = ConvoScreen:new {
	id = "s_577",
	leftDialog = "@conversation/ep3_myyydril_patrol_leader:s_577", -- Indeed. And we could always use more allies and help. You can go speak with our chief, Kallaarac. Perhaps he will entrust you to help us.
	stopConversation = "false",
	options = {
		{"@conversation/ep3_myyydril_patrol_leader:s_579", "s_581"},
	}
}
ep3_myyydril_patrol_leader_convo:addScreen(ep3_myyydril_patrol_leader_convo_s_577)

ep3_myyydril_patrol_leader_convo_s_581 = ConvoScreen:new {
	id = "s_581",
	leftDialog = "@conversation/ep3_myyydril_patrol_leader:s_581", -- [Kivvaaa nods.]
	stopConversation = "true",
	options = {}
}
ep3_myyydril_patrol_leader_convo:addScreen(ep3_myyydril_patrol_leader_convo_s_581)

addConversationTemplate("ep3_myyydril_patrol_leader_convo", ep3_myyydril_patrol_leader_convo)
