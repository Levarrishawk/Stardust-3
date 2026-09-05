-- ep3_myyydril_attiera
-- ruling 2026-09-04
-- Transcribed from the giver's java branches. Strings are shipped keys.
-- The journal row for quest/ep3_myyydril_*.qst comes from the integration branch later; do not call the journal API.

ep3_myyydril_attiera_convo = ConvoTemplate:new {
	initialScreen = "s_488",
	templateType = "Lua",
	luaClassHandler = "ep3_myyydril_attiera_conv_handler",
	screens = {}
}

ep3_myyydril_attiera_convo_s_488 = ConvoScreen:new {
	id = "s_488",
	leftDialog = "@conversation/ep3_myyydril_attiera:s_488", -- Who are you? What are you doing here? We, the Myyydril, do not like strangers. I have to wait for my daughter to return. [Attiera turns a...
	stopConversation = "true",
	options = {}
}
ep3_myyydril_attiera_convo:addScreen(ep3_myyydril_attiera_convo_s_488)

ep3_myyydril_attiera_convo_s_489 = ConvoScreen:new {
	id = "s_489",
	leftDialog = "@conversation/ep3_myyydril_attiera:s_489", -- Have you seen my daughter? She hasn't come back yet! I fear for the worst. Please... [Attiera begins to cry.]
	stopConversation = "false",
	options = {
		{"@conversation/ep3_myyydril_attiera:s_515", "s_516"},
	}
}
ep3_myyydril_attiera_convo:addScreen(ep3_myyydril_attiera_convo_s_489)

ep3_myyydril_attiera_convo_s_516 = ConvoScreen:new {
	id = "s_516",
	leftDialog = "@conversation/ep3_myyydril_attiera:s_516", -- Yes. She just went out to play. I'm such a horrible mother. She said she wouldn't go far! [Attiera sobs.]
	stopConversation = "false",
	options = {
		{"@conversation/ep3_myyydril_attiera:s_517", "s_519"},
		{"@conversation/ep3_myyydril_attiera:s_518", "s_520"},
	}
}
ep3_myyydril_attiera_convo:addScreen(ep3_myyydril_attiera_convo_s_516)

ep3_myyydril_attiera_convo_s_519 = ConvoScreen:new {
	id = "s_519",
	leftDialog = "@conversation/ep3_myyydril_attiera:s_519", -- You will? I'd be.. you have no idea how grateful I'd be. Please look for her. I don't know where she could be.
	stopConversation = "true",
	options = {}
}
ep3_myyydril_attiera_convo:addScreen(ep3_myyydril_attiera_convo_s_519)

ep3_myyydril_attiera_convo_s_520 = ConvoScreen:new {
	id = "s_520",
	leftDialog = "@conversation/ep3_myyydril_attiera:s_520", -- So do I... so do I. [Attiera wipes her watery eyes.]
	stopConversation = "true",
	options = {}
}
ep3_myyydril_attiera_convo:addScreen(ep3_myyydril_attiera_convo_s_520)

ep3_myyydril_attiera_convo_s_521 = ConvoScreen:new {
	id = "s_521",
	leftDialog = "@conversation/ep3_myyydril_attiera:s_521", -- Have you found my daughter yet? [Attiera looks hopeful.]
	stopConversation = "false",
	options = {
		{"@conversation/ep3_myyydril_attiera:s_522", "s_523"},
	}
}
ep3_myyydril_attiera_convo:addScreen(ep3_myyydril_attiera_convo_s_521)

ep3_myyydril_attiera_convo_s_523 = ConvoScreen:new {
	id = "s_523",
	leftDialog = "@conversation/ep3_myyydril_attiera:s_523", -- [Attiera nods sadly.] I trust you'll find her and bring her home. I have heard so many great things about you.
	stopConversation = "true",
	options = {}
}
ep3_myyydril_attiera_convo:addScreen(ep3_myyydril_attiera_convo_s_523)

ep3_myyydril_attiera_convo_s_524 = ConvoScreen:new {
	id = "s_524",
	leftDialog = "@conversation/ep3_myyydril_attiera:s_524", -- My daughter!! Oh, thank you!! I'm so grateful. I had almost lost hope, but you've brought the light back into my life! Please take this.
	stopConversation = "false",
	options = {
		{"@conversation/ep3_myyydril_attiera:s_525", "s_526"},
	}
}
ep3_myyydril_attiera_convo:addScreen(ep3_myyydril_attiera_convo_s_524)

ep3_myyydril_attiera_convo_s_526 = ConvoScreen:new {
	id = "s_526",
	leftDialog = "@conversation/ep3_myyydril_attiera:s_526", -- Please, I insist. You've done so much for our people lately.
	stopConversation = "true",
	options = {}
}
ep3_myyydril_attiera_convo:addScreen(ep3_myyydril_attiera_convo_s_526)

ep3_myyydril_attiera_convo_s_527 = ConvoScreen:new {
	id = "s_527",
	leftDialog = "@conversation/ep3_myyydril_attiera:s_527", -- [Attiera nods with respect.] Things have returned to normal. Froera is enjoying her Luilris Pies again. Everything seems to be going well...
	stopConversation = "false",
	options = {
		{"@conversation/ep3_myyydril_attiera:s_528", "s_529"},
	}
}
ep3_myyydril_attiera_convo:addScreen(ep3_myyydril_attiera_convo_s_527)

ep3_myyydril_attiera_convo_s_529 = ConvoScreen:new {
	id = "s_529",
	leftDialog = "@conversation/ep3_myyydril_attiera:s_529", -- I almost wish I had another problem for you to help me with, but I don't. If I do in the future, you'll be the first one I seek out.
	stopConversation = "true",
	options = {}
}
ep3_myyydril_attiera_convo:addScreen(ep3_myyydril_attiera_convo_s_529)

addConversationTemplate("ep3_myyydril_attiera_convo", ep3_myyydril_attiera_convo)
