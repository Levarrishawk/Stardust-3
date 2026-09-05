-- ep3_myyydril_refugee
-- ruling 2026-09-04
-- Transcribed from the giver's java branches. Strings are shipped keys.
-- The journal row for quest/ep3_myyydril_*.qst comes from the integration branch later; do not call the journal API.

ep3_myyydril_refugee_convo = ConvoTemplate:new {
	initialScreen = "s_739",
	templateType = "Lua",
	luaClassHandler = "ep3_myyydril_refugee_conv_handler",
	screens = {}
}

ep3_myyydril_refugee_convo_s_716 = ConvoScreen:new {
	id = "s_716",
	leftDialog = "@conversation/ep3_myyydril_refugee:s_716", -- You're back? I thought we made it clear that you should leave before you get hurt?
	stopConversation = "false",
	options = {
		{"@conversation/ep3_myyydril_refugee:s_720", "s_723"},
	}
}
ep3_myyydril_refugee_convo:addScreen(ep3_myyydril_refugee_convo_s_716)

ep3_myyydril_refugee_convo_s_723 = ConvoScreen:new {
	id = "s_723",
	leftDialog = "@conversation/ep3_myyydril_refugee:s_723", -- Want to try me, kid? Now, get out of here!
	stopConversation = "true",
	options = {}
}
ep3_myyydril_refugee_convo:addScreen(ep3_myyydril_refugee_convo_s_723)

ep3_myyydril_refugee_convo_s_726 = ConvoScreen:new {
	id = "s_726",
	leftDialog = "@conversation/ep3_myyydril_refugee:s_726", -- What do you want? [Ren'Salla starts accusingly.]
	stopConversation = "false",
	options = {
		{"@conversation/ep3_myyydril_refugee:s_728", "s_731"},
	}
}
ep3_myyydril_refugee_convo:addScreen(ep3_myyydril_refugee_convo_s_726)

ep3_myyydril_refugee_convo_s_731 = ConvoScreen:new {
	id = "s_731",
	leftDialog = "@conversation/ep3_myyydril_refugee:s_731", -- This old thing? Pfft. I threw that at a Urnsor'is a long time ago. [Ren'Salla stares you down.] It's the thought that counts, though, rig...
	stopConversation = "false",
	options = {
		{"@conversation/ep3_myyydril_refugee:s_734", "s_737"},
	}
}
ep3_myyydril_refugee_convo:addScreen(ep3_myyydril_refugee_convo_s_731)

ep3_myyydril_refugee_convo_s_737 = ConvoScreen:new {
	id = "s_737",
	leftDialog = "@conversation/ep3_myyydril_refugee:s_737", -- Yeah. [Ren'Salla scoffs.] Now, get out of here.
	stopConversation = "true",
	options = {}
}
ep3_myyydril_refugee_convo:addScreen(ep3_myyydril_refugee_convo_s_737)

ep3_myyydril_refugee_convo_s_739 = ConvoScreen:new {
	id = "s_739",
	leftDialog = "@conversation/ep3_myyydril_refugee:s_739", -- What do you want?
	stopConversation = "false",
	options = {
		{"@conversation/ep3_myyydril_refugee:s_742", "s_745"},
	}
}
ep3_myyydril_refugee_convo:addScreen(ep3_myyydril_refugee_convo_s_739)

ep3_myyydril_refugee_convo_s_745 = ConvoScreen:new {
	id = "s_745",
	leftDialog = "@conversation/ep3_myyydril_refugee:s_745", -- Ren'Salla. What's it to you?
	stopConversation = "false",
	options = {
		{"@conversation/ep3_myyydril_refugee:s_747", "s_750"},
	}
}
ep3_myyydril_refugee_convo:addScreen(ep3_myyydril_refugee_convo_s_745)

ep3_myyydril_refugee_convo_s_750 = ConvoScreen:new {
	id = "s_750",
	leftDialog = "@conversation/ep3_myyydril_refugee:s_750", -- We have our reasons. [Ren'Salla looks you over.] You should probably leave before my boys get antsy. We don't like strangers.
	stopConversation = "true",
	options = {}
}
ep3_myyydril_refugee_convo:addScreen(ep3_myyydril_refugee_convo_s_750)

addConversationTemplate("ep3_myyydril_refugee_convo", ep3_myyydril_refugee_convo)
