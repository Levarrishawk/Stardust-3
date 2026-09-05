-- ep3_myyydril_weaponsmith
-- ruling 2026-09-04
-- Transcribed from the giver's java branches. Strings are shipped keys.
-- The journal row for quest/ep3_myyydril_*.qst comes from the integration branch later; do not call the journal API.

ep3_myyydril_weaponsmith_convo = ConvoTemplate:new {
	initialScreen = "s_886",
	templateType = "Lua",
	luaClassHandler = "ep3_myyydril_weaponsmith_conv_handler",
	screens = {}
}

ep3_myyydril_weaponsmith_convo_s_36 = ConvoScreen:new {
	id = "s_36",
	leftDialog = "@conversation/ep3_myyydril_weaponsmith:s_36", -- What!? Here,  now, go away!
	stopConversation = "true",
	options = {}
}
ep3_myyydril_weaponsmith_convo:addScreen(ep3_myyydril_weaponsmith_convo_s_36)

ep3_myyydril_weaponsmith_convo_s_758 = ConvoScreen:new {
	id = "s_758",
	leftDialog = "@conversation/ep3_myyydril_weaponsmith:s_758", -- [Treesh snores.] Zzzz.
	stopConversation = "false",
	options = {
		{"@conversation/ep3_myyydril_weaponsmith:s_762", "s_766"},
	}
}
ep3_myyydril_weaponsmith_convo:addScreen(ep3_myyydril_weaponsmith_convo_s_758)

ep3_myyydril_weaponsmith_convo_s_766 = ConvoScreen:new {
	id = "s_766",
	leftDialog = "@conversation/ep3_myyydril_weaponsmith:s_766", -- Uh--huh? What? It's you, again? Why always when I'm sleeping?
	stopConversation = "false",
	options = {
		{"@conversation/ep3_myyydril_weaponsmith:s_770", "s_774"},
		{"@conversation/ep3_myyydril_weaponsmith:s_35", "s_36"},
	}
}
ep3_myyydril_weaponsmith_convo:addScreen(ep3_myyydril_weaponsmith_convo_s_766)

ep3_myyydril_weaponsmith_convo_s_766_has_schem = ConvoScreen:new {
	id = "s_766_has_schem",
	leftDialog = "@conversation/ep3_myyydril_weaponsmith:s_766", -- Uh--huh? What? It's you, again? Why always when I'm sleeping?
	stopConversation = "false",
	options = {
		{"@conversation/ep3_myyydril_weaponsmith:s_770", "s_774"},
	}
}
ep3_myyydril_weaponsmith_convo:addScreen(ep3_myyydril_weaponsmith_convo_s_766_has_schem)

ep3_myyydril_weaponsmith_convo_s_774 = ConvoScreen:new {
	id = "s_774",
	leftDialog = "@conversation/ep3_myyydril_weaponsmith:s_774", -- Yeah, yeah. Just don't tell the furry people.
	stopConversation = "true",
	options = {}
}
ep3_myyydril_weaponsmith_convo:addScreen(ep3_myyydril_weaponsmith_convo_s_774)

ep3_myyydril_weaponsmith_convo_s_778 = ConvoScreen:new {
	id = "s_778",
	leftDialog = "@conversation/ep3_myyydril_weaponsmith:s_778", -- Who's--
	stopConversation = "false",
	options = {
		{"@conversation/ep3_myyydril_weaponsmith:s_782", "s_786"},
	}
}
ep3_myyydril_weaponsmith_convo:addScreen(ep3_myyydril_weaponsmith_convo_s_778)

ep3_myyydril_weaponsmith_convo_s_786 = ConvoScreen:new {
	id = "s_786",
	leftDialog = "@conversation/ep3_myyydril_weaponsmith:s_786", -- Oh. You. Do you have the weapons I need?
	stopConversation = "false",
	options = {
		{"@conversation/ep3_myyydril_weaponsmith:s_790", "s_794"},
	}
}
ep3_myyydril_weaponsmith_convo:addScreen(ep3_myyydril_weaponsmith_convo_s_786)

ep3_myyydril_weaponsmith_convo_s_794 = ConvoScreen:new {
	id = "s_794",
	leftDialog = "@conversation/ep3_myyydril_weaponsmith:s_794", -- Wow. Aren't you direct. [Treesh grunts.] Okay, kid. Fine. You win. Here ya go. Oh and... thanks. Now, go away!
	stopConversation = "true",
	options = {}
}
ep3_myyydril_weaponsmith_convo:addScreen(ep3_myyydril_weaponsmith_convo_s_794)

ep3_myyydril_weaponsmith_convo_s_798 = ConvoScreen:new {
	id = "s_798",
	leftDialog = "@conversation/ep3_myyydril_weaponsmith:s_798", -- [Treesh stares blankly.] Who's there?
	stopConversation = "false",
	options = {
		{"@conversation/ep3_myyydril_weaponsmith:s_802", "s_806"},
	}
}
ep3_myyydril_weaponsmith_convo:addScreen(ep3_myyydril_weaponsmith_convo_s_798)

ep3_myyydril_weaponsmith_convo_s_806 = ConvoScreen:new {
	id = "s_806",
	leftDialog = "@conversation/ep3_myyydril_weaponsmith:s_806", -- Do I have Nak'tra Crystal Swords in my hand?
	stopConversation = "false",
	options = {
		{"@conversation/ep3_myyydril_weaponsmith:s_810", "s_814"},
	}
}
ep3_myyydril_weaponsmith_convo:addScreen(ep3_myyydril_weaponsmith_convo_s_806)

ep3_myyydril_weaponsmith_convo_s_814 = ConvoScreen:new {
	id = "s_814",
	leftDialog = "@conversation/ep3_myyydril_weaponsmith:s_814", -- Then, go away. I'm trying to sleep around here. Come back when you have them.
	stopConversation = "true",
	options = {}
}
ep3_myyydril_weaponsmith_convo:addScreen(ep3_myyydril_weaponsmith_convo_s_814)

ep3_myyydril_weaponsmith_convo_s_818 = ConvoScreen:new {
	id = "s_818",
	leftDialog = "@conversation/ep3_myyydril_weaponsmith:s_818", -- [Treesh peers blankly.] Who's there? I sense a familiar aura about you. Wait a second. No, that was definitely my lunch.
	stopConversation = "false",
	options = {
		{"@conversation/ep3_myyydril_weaponsmith:s_822", "s_826"},
	}
}
ep3_myyydril_weaponsmith_convo:addScreen(ep3_myyydril_weaponsmith_convo_s_818)

ep3_myyydril_weaponsmith_convo_s_826 = ConvoScreen:new {
	id = "s_826",
	leftDialog = "@conversation/ep3_myyydril_weaponsmith:s_826", -- [Treesh grunts.] What do you want? Are you a weaponsmith? I only talk to those who can appreciate my profession!
	stopConversation = "false",
	options = {
		{"@conversation/ep3_myyydril_weaponsmith:s_830", "s_834"},
	}
}
ep3_myyydril_weaponsmith_convo:addScreen(ep3_myyydril_weaponsmith_convo_s_826)

ep3_myyydril_weaponsmith_convo_s_834 = ConvoScreen:new {
	id = "s_834",
	leftDialog = "@conversation/ep3_myyydril_weaponsmith:s_834", -- I've got a job I need you to do. These darned Urnies keep attacking and the furry people need more weapons to defeat them.
	stopConversation = "false",
	options = {
		{"@conversation/ep3_myyydril_weaponsmith:s_838", "s_842"},
	}
}
ep3_myyydril_weaponsmith_convo:addScreen(ep3_myyydril_weaponsmith_convo_s_834)

ep3_myyydril_weaponsmith_convo_s_842 = ConvoScreen:new {
	id = "s_842",
	leftDialog = "@conversation/ep3_myyydril_weaponsmith:s_842", -- [Treesh narrows his eyes.] What--?! I can't believe you'd ask me such a thing! You insensitive kreetle lover! I'm blind! Can't you see th...
	stopConversation = "false",
	options = {
		{"@conversation/ep3_myyydril_weaponsmith:s_846", "s_850"},
	}
}
ep3_myyydril_weaponsmith_convo:addScreen(ep3_myyydril_weaponsmith_convo_s_842)

ep3_myyydril_weaponsmith_convo_s_850 = ConvoScreen:new {
	id = "s_850",
	leftDialog = "@conversation/ep3_myyydril_weaponsmith:s_850", -- [Treesh laughs.] You didn't. I was just pulling your leg. You want the job or not? You owe me, kid.
	stopConversation = "false",
	options = {
		{"@conversation/ep3_myyydril_weaponsmith:s_854", "s_858"},
		{"@conversation/ep3_myyydril_weaponsmith:s_878", "s_882"},
	}
}
ep3_myyydril_weaponsmith_convo:addScreen(ep3_myyydril_weaponsmith_convo_s_850)

ep3_myyydril_weaponsmith_convo_s_858 = ConvoScreen:new {
	id = "s_858",
	leftDialog = "@conversation/ep3_myyydril_weaponsmith:s_858", -- Make me some Nak'tra Crystal Swords. You need to collect Nak'tra crystals around here and fashion them into a pointed stick. Is that easy...
	stopConversation = "false",
	options = {
		{"@conversation/ep3_myyydril_weaponsmith:s_862", "s_866"},
		{"@conversation/ep3_myyydril_weaponsmith:s_872", "s_953"},
	}
}
ep3_myyydril_weaponsmith_convo:addScreen(ep3_myyydril_weaponsmith_convo_s_858)

ep3_myyydril_weaponsmith_convo_s_866 = ConvoScreen:new {
	id = "s_866",
	leftDialog = "@conversation/ep3_myyydril_weaponsmith:s_866", -- ... Well?! Why are you still here? Get a move on! If I get fired, it's your head, you know. Oh and--supposedly, Urnies eat the Crystals t...
	stopConversation = "true",
	options = {}
}
ep3_myyydril_weaponsmith_convo:addScreen(ep3_myyydril_weaponsmith_convo_s_866)

ep3_myyydril_weaponsmith_convo_s_882 = ConvoScreen:new {
	id = "s_882",
	leftDialog = "@conversation/ep3_myyydril_weaponsmith:s_882", -- Tpphht! Then, go away... kreetle lover!
	stopConversation = "true",
	options = {}
}
ep3_myyydril_weaponsmith_convo:addScreen(ep3_myyydril_weaponsmith_convo_s_882)

ep3_myyydril_weaponsmith_convo_s_886 = ConvoScreen:new {
	id = "s_886",
	leftDialog = "@conversation/ep3_myyydril_weaponsmith:s_886", -- [Treesh grunts.] Who are you? What do you want?  You got any skill in those hands? No? Go away. You're not a weaponsmith. You can't under...
	stopConversation = "true",
	options = {}
}
ep3_myyydril_weaponsmith_convo:addScreen(ep3_myyydril_weaponsmith_convo_s_886)

ep3_myyydril_weaponsmith_convo_s_953 = ConvoScreen:new {
	id = "s_953",
	leftDialog = "@conversation/ep3_myyydril_weaponsmith:s_953", -- [Treesh snorts.]
	stopConversation = "true",
	options = {}
}
ep3_myyydril_weaponsmith_convo:addScreen(ep3_myyydril_weaponsmith_convo_s_953)

addConversationTemplate("ep3_myyydril_weaponsmith_convo", ep3_myyydril_weaponsmith_convo)
