-- ep3_myyydril_pers
-- ruling 2026-09-04
-- Transcribed from the giver's java branches. Strings are shipped keys.
-- The journal row for quest/ep3_myyydril_*.qst comes from the integration branch later; do not call the journal API.

ep3_myyydril_pers_convo = ConvoTemplate:new {
	initialScreen = "s_719",
	templateType = "Lua",
	luaClassHandler = "ep3_myyydril_pers_conv_handler",
	screens = {}
}

ep3_myyydril_pers_convo_s_632 = ConvoScreen:new {
	id = "s_632",
	leftDialog = "@conversation/ep3_myyydril_pers:s_632", -- [Pers nods.] Friend. I hope things are going well for you. I'm doing another one of my projects again. Gotta get back to it.
	stopConversation = "true",
	options = {}
}
ep3_myyydril_pers_convo:addScreen(ep3_myyydril_pers_convo_s_632)

ep3_myyydril_pers_convo_s_635 = ConvoScreen:new {
	id = "s_635",
	leftDialog = "@conversation/ep3_myyydril_pers:s_635", -- Look who it is. And look who has my crate of stuff. I knew I could count on you. You're just like me in a way; smart and quick.
	stopConversation = "false",
	options = {
		{"@conversation/ep3_myyydril_pers:s_637", "s_640"},
	}
}
ep3_myyydril_pers_convo:addScreen(ep3_myyydril_pers_convo_s_635)

ep3_myyydril_pers_convo_s_640 = ConvoScreen:new {
	id = "s_640",
	leftDialog = "@conversation/ep3_myyydril_pers:s_640", -- Direct too. I don't blame you. Our work can yield very little at times. Besides... [ Pers shrugs.] You deserve a little something. Here. ...
	stopConversation = "false",
	options = {
		{"@conversation/ep3_myyydril_pers:s_643", "s_645"},
	}
}
ep3_myyydril_pers_convo:addScreen(ep3_myyydril_pers_convo_s_640)

ep3_myyydril_pers_convo_s_645 = ConvoScreen:new {
	id = "s_645",
	leftDialog = "@conversation/ep3_myyydril_pers:s_645", -- And you. [Pers nods.]
	stopConversation = "true",
	options = {}
}
ep3_myyydril_pers_convo:addScreen(ep3_myyydril_pers_convo_s_645)

ep3_myyydril_pers_convo_s_648 = ConvoScreen:new {
	id = "s_648",
	leftDialog = "@conversation/ep3_myyydril_pers:s_648", -- Is anyone following you? [Pers looks around for a moment.] Doesn't seem like it. Good. You're better than I thought. What do ya got for me?
	stopConversation = "false",
	options = {
		{"@conversation/ep3_myyydril_pers:s_650", "s_685"},
	}
}
ep3_myyydril_pers_convo:addScreen(ep3_myyydril_pers_convo_s_648)

ep3_myyydril_pers_convo_s_673 = ConvoScreen:new {
	id = "s_673",
	leftDialog = "@conversation/ep3_myyydril_pers:s_673", -- Go then and hurry back.
	stopConversation = "true",
	options = {}
}
ep3_myyydril_pers_convo:addScreen(ep3_myyydril_pers_convo_s_673)

ep3_myyydril_pers_convo_s_679 = ConvoScreen:new {
	id = "s_679",
	leftDialog = "@conversation/ep3_myyydril_pers:s_679", -- You probably shouldn't say that around here.
	stopConversation = "true",
	options = {}
}
ep3_myyydril_pers_convo:addScreen(ep3_myyydril_pers_convo_s_679)

ep3_myyydril_pers_convo_s_685 = ConvoScreen:new {
	id = "s_685",
	leftDialog = "@conversation/ep3_myyydril_pers:s_685", -- That's a problem. I need them, fast. Supposedly, the Urnies are acting up again. Go out there and show me what you're made of.
	stopConversation = "false",
	options = {
		{"@conversation/ep3_myyydril_pers:s_687", "s_689"},
	}
}
ep3_myyydril_pers_convo:addScreen(ep3_myyydril_pers_convo_s_685)

ep3_myyydril_pers_convo_s_689 = ConvoScreen:new {
	id = "s_689",
	leftDialog = "@conversation/ep3_myyydril_pers:s_689", -- [Pers slinks into the shadows.]
	stopConversation = "true",
	options = {}
}
ep3_myyydril_pers_convo:addScreen(ep3_myyydril_pers_convo_s_689)

ep3_myyydril_pers_convo_s_691 = ConvoScreen:new {
	id = "s_691",
	leftDialog = "@conversation/ep3_myyydril_pers:s_691", -- Your subtly astounds me. Yes. [Pers nods slowly.] You'd be perfect for my plans.
	stopConversation = "false",
	options = {
		{"@conversation/ep3_myyydril_pers:s_693", "s_695"},
	}
}
ep3_myyydril_pers_convo:addScreen(ep3_myyydril_pers_convo_s_691)

ep3_myyydril_pers_convo_s_695 = ConvoScreen:new {
	id = "s_695",
	leftDialog = "@conversation/ep3_myyydril_pers:s_695", -- Shh. You needn't know. You and I... We share the same... [Pers looks around, whispering.] profession. I need your help.
	stopConversation = "false",
	options = {
		{"@conversation/ep3_myyydril_pers:s_697", "s_699"},
	}
}
ep3_myyydril_pers_convo:addScreen(ep3_myyydril_pers_convo_s_695)

ep3_myyydril_pers_convo_s_699 = ConvoScreen:new {
	id = "s_699",
	leftDialog = "@conversation/ep3_myyydril_pers:s_699", -- Shh! The Myyydril musn't know. They think I'm a chef! HA! Come closer, friend, we have much to discuss.
	stopConversation = "false",
	options = {
		{"@conversation/ep3_myyydril_pers:s_701", "s_703"},
	}
}
ep3_myyydril_pers_convo:addScreen(ep3_myyydril_pers_convo_s_699)

ep3_myyydril_pers_convo_s_703 = ConvoScreen:new {
	id = "s_703",
	leftDialog = "@conversation/ep3_myyydril_pers:s_703", -- I, let us say, 'supply' the Myyydril with specific weapons made from the tough, priceless Nak'tra Crystals. I manipulate the gemstone and...
	stopConversation = "false",
	options = {
		{"@conversation/ep3_myyydril_pers:s_705", "s_707"},
	}
}
ep3_myyydril_pers_convo:addScreen(ep3_myyydril_pers_convo_s_703)

ep3_myyydril_pers_convo_s_707 = ConvoScreen:new {
	id = "s_707",
	leftDialog = "@conversation/ep3_myyydril_pers:s_707", -- No! The bloody bastards took my finished crate of Nak'tra Crystal Rifles! I just need them back now. And that's where you, my fellow smug...
	stopConversation = "false",
	options = {
		{"@conversation/ep3_myyydril_pers:s_709", "s_711"},
		{"@conversation/ep3_myyydril_pers:s_715", "s_679"},
	}
}
ep3_myyydril_pers_convo:addScreen(ep3_myyydril_pers_convo_s_707)

ep3_myyydril_pers_convo_s_711 = ConvoScreen:new {
	id = "s_711",
	leftDialog = "@conversation/ep3_myyydril_pers:s_711", -- And that's exactly what I was hoping for. There's an Imperial camp nearby. At least, in the forest. Find it, steal--I mean 'smuggle'--the...
	stopConversation = "false",
	options = {
		{"@conversation/ep3_myyydril_pers:s_868", "s_673"},
	}
}
ep3_myyydril_pers_convo:addScreen(ep3_myyydril_pers_convo_s_711)

ep3_myyydril_pers_convo_s_719 = ConvoScreen:new {
	id = "s_719",
	leftDialog = "@conversation/ep3_myyydril_pers:s_719", -- You're not the one I am looking for. The chosen must be able to infiltrate the most secure of places and retrieve what it is that I need.
	stopConversation = "true",
	options = {}
}
ep3_myyydril_pers_convo:addScreen(ep3_myyydril_pers_convo_s_719)

addConversationTemplate("ep3_myyydril_pers_convo", ep3_myyydril_pers_convo)
