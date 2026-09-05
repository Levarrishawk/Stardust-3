-- ep3_myyydril_lorn_servant
-- ruling 2026-09-04
-- Transcribed from the giver's java branches. Strings are shipped keys.
-- The journal row for quest/ep3_myyydril_*.qst comes from the integration branch later; do not call the journal API.

ep3_myyydril_lorn_servant_convo = ConvoTemplate:new {
	initialScreen = "s_442",
	templateType = "Lua",
	luaClassHandler = "ep3_myyydril_lorn_servant_conv_handler",
	screens = {}
}

ep3_myyydril_lorn_servant_convo_s_418 = ConvoScreen:new {
	id = "s_418",
	leftDialog = "@conversation/ep3_myyydril_lorn_servant:s_418", -- [The servant of Lorn does not respond. Perhaps you should try again later].
	stopConversation = "true",
	options = {}
}
ep3_myyydril_lorn_servant_convo:addScreen(ep3_myyydril_lorn_servant_convo_s_418)

ep3_myyydril_lorn_servant_convo_s_430 = ConvoScreen:new {
	id = "s_430",
	leftDialog = "@conversation/ep3_myyydril_lorn_servant:s_430", -- noob. lol!!!111
	stopConversation = "true",
	options = {}
}
ep3_myyydril_lorn_servant_convo:addScreen(ep3_myyydril_lorn_servant_convo_s_430)

ep3_myyydril_lorn_servant_convo_s_434 = ConvoScreen:new {
	id = "s_434",
	leftDialog = "@conversation/ep3_myyydril_lorn_servant:s_434", -- The messenger has come. You may enter.
	stopConversation = "true",
	options = {}
}
ep3_myyydril_lorn_servant_convo:addScreen(ep3_myyydril_lorn_servant_convo_s_434)

ep3_myyydril_lorn_servant_convo_s_438 = ConvoScreen:new {
	id = "s_438",
	leftDialog = "@conversation/ep3_myyydril_lorn_servant:s_438", -- [The droid doesn't answer.]
	stopConversation = "true",
	options = {}
}
ep3_myyydril_lorn_servant_convo:addScreen(ep3_myyydril_lorn_servant_convo_s_438)

ep3_myyydril_lorn_servant_convo_s_442 = ConvoScreen:new {
	id = "s_442",
	leftDialog = "@conversation/ep3_myyydril_lorn_servant:s_442", -- [As soon as you approach, the once-lifeless droid springs into working condition.] I am a servant of Lorn, model 3-NIi. Are you the messe...
	stopConversation = "false",
	options = {
		{"@conversation/ep3_myyydril_lorn_servant:s_446", "s_450"},
		{"@conversation/ep3_myyydril_lorn_servant:s_492", "s_496"},
	}
}
ep3_myyydril_lorn_servant_convo:addScreen(ep3_myyydril_lorn_servant_convo_s_442)

ep3_myyydril_lorn_servant_convo_s_450 = ConvoScreen:new {
	id = "s_450",
	leftDialog = "@conversation/ep3_myyydril_lorn_servant:s_450", -- [The droid takes a moment to process the information.] You are not the messenger. Please leave immediately.
	stopConversation = "false",
	options = {
		{"@conversation/ep3_myyydril_lorn_servant:s_454", "s_460"},
	}
}
ep3_myyydril_lorn_servant_convo:addScreen(ep3_myyydril_lorn_servant_convo_s_450)

ep3_myyydril_lorn_servant_convo_s_460 = ConvoScreen:new {
	id = "s_460",
	leftDialog = "@conversation/ep3_myyydril_lorn_servant:s_460", -- Termination in 5.. 4..
	stopConversation = "false",
	options = {
		{"@conversation/ep3_myyydril_lorn_servant:s_468", "s_473"},
	}
}
ep3_myyydril_lorn_servant_convo:addScreen(ep3_myyydril_lorn_servant_convo_s_460)

ep3_myyydril_lorn_servant_convo_s_473 = ConvoScreen:new {
	id = "s_473",
	leftDialog = "@conversation/ep3_myyydril_lorn_servant:s_473", -- [The droid stops advancing toward you.] Termination process canceled. Processing information... [A hologram of a man appears.] I am Treun...
	stopConversation = "false",
	options = {
		{"@conversation/ep3_myyydril_lorn_servant:s_476", "s_480"},
	}
}
ep3_myyydril_lorn_servant_convo:addScreen(ep3_myyydril_lorn_servant_convo_s_473)

ep3_myyydril_lorn_servant_convo_s_480 = ConvoScreen:new {
	id = "s_480",
	leftDialog = "@conversation/ep3_myyydril_lorn_servant:s_480", -- [Treun Lorn continues to speak.] I need a crystal... one that contains a large amount of unnatural energy. Find it and you will see my cr...
	stopConversation = "false",
	options = {
		{"@conversation/ep3_myyydril_lorn_servant:s_484", "s_488"},
	}
}
ep3_myyydril_lorn_servant_convo:addScreen(ep3_myyydril_lorn_servant_convo_s_480)

ep3_myyydril_lorn_servant_convo_s_488 = ConvoScreen:new {
	id = "s_488",
	leftDialog = "@conversation/ep3_myyydril_lorn_servant:s_488", -- [Treun Lorn's image starts to fade.] Just beyond this room.. *static* red..
	stopConversation = "true",
	options = {}
}
ep3_myyydril_lorn_servant_convo:addScreen(ep3_myyydril_lorn_servant_convo_s_488)

ep3_myyydril_lorn_servant_convo_s_496 = ConvoScreen:new {
	id = "s_496",
	leftDialog = "@conversation/ep3_myyydril_lorn_servant:s_496", -- Let it begin.
	stopConversation = "true",
	options = {}
}
ep3_myyydril_lorn_servant_convo:addScreen(ep3_myyydril_lorn_servant_convo_s_496)

addConversationTemplate("ep3_myyydril_lorn_servant_convo", ep3_myyydril_lorn_servant_convo)
