-- ep3_etyyy_manfred_carter -- Etyyy hunting-grounds ground conversation
-- ruling 2026-09-04: "ensure kashyyyk is fully done"
-- Transcribed from the giver's java branches. Strings are shipped keys.
-- The journal row for quest/ep3_hunt_*.qst comes from the integration branch later; do not call the journal engine.

ep3_etyyy_manfred_carter_convo = ConvoTemplate:new {
	initialScreen = "s_600",
	templateType = "Lua",
	luaClassHandler = "ep3_etyyy_manfred_carter_conv_handler",
	screens = {}
}

ep3_etyyy_manfred_carter_convo_s_670 = ConvoScreen:new {
	id = "s_670",
	leftDialog = "@conversation/ep3_etyyy_manfred_carter:s_670", -- Don't tell Sordaan I said this, but I think Tripp is probably the best hunter in Etyyy. She's the mo...
	stopConversation = "true",
	options = {}
}
ep3_etyyy_manfred_carter_convo:addScreen(ep3_etyyy_manfred_carter_convo_s_670)

ep3_etyyy_manfred_carter_convo_s_671 = ConvoScreen:new {
	id = "s_671",
	leftDialog = "@conversation/ep3_etyyy_manfred_carter:s_671", -- Whatever. Return to me when you're ready to go.
	stopConversation = "true",
	options = {}
}
ep3_etyyy_manfred_carter_convo:addScreen(ep3_etyyy_manfred_carter_convo_s_671)

ep3_etyyy_manfred_carter_convo_s_665 = ConvoScreen:new {
	id = "s_665",
	leftDialog = "@conversation/ep3_etyyy_manfred_carter:s_665", -- Of course you will. Any other response would be disrespectful. His name is Laen Pieweto. He won't go...
	stopConversation = "true",
	options = {}
}
ep3_etyyy_manfred_carter_convo:addScreen(ep3_etyyy_manfred_carter_convo_s_665)

ep3_etyyy_manfred_carter_convo_s_666 = ConvoScreen:new {
	id = "s_666",
	leftDialog = "@conversation/ep3_etyyy_manfred_carter:s_666", -- Watch it. Don't be disrespectful.
	stopConversation = "true",
	options = {}
}
ep3_etyyy_manfred_carter_convo:addScreen(ep3_etyyy_manfred_carter_convo_s_666)

ep3_etyyy_manfred_carter_convo_s_572 = ConvoScreen:new {
	id = "s_572",
	leftDialog = "@conversation/ep3_etyyy_manfred_carter:s_572", -- Return to me once you've gotten 16 samples of the chemicals they are using.
	stopConversation = "true",
	options = {}
}
ep3_etyyy_manfred_carter_convo:addScreen(ep3_etyyy_manfred_carter_convo_s_572)

ep3_etyyy_manfred_carter_convo_s_662 = ConvoScreen:new {
	id = "s_662",
	leftDialog = "@conversation/ep3_etyyy_manfred_carter:s_662", -- Watch it. Don't be disrespectful.
	stopConversation = "true",
	options = {}
}
ep3_etyyy_manfred_carter_convo:addScreen(ep3_etyyy_manfred_carter_convo_s_662)

ep3_etyyy_manfred_carter_convo_s_594 = ConvoScreen:new {
	id = "s_594",
	leftDialog = "@conversation/ep3_etyyy_manfred_carter:s_594", -- Well, let's see. How about you go to the Chiss camps on the west side of Etyyy and relieve those poa...
	stopConversation = "true",
	options = {}
}
ep3_etyyy_manfred_carter_convo:addScreen(ep3_etyyy_manfred_carter_convo_s_594)

ep3_etyyy_manfred_carter_convo_s_598 = ConvoScreen:new {
	id = "s_598",
	leftDialog = "@conversation/ep3_etyyy_manfred_carter:s_598", -- Watch it. Don't be disrespectful.
	stopConversation = "true",
	options = {}
}
ep3_etyyy_manfred_carter_convo:addScreen(ep3_etyyy_manfred_carter_convo_s_598)

ep3_etyyy_manfred_carter_convo_s_566 = ConvoScreen:new {
	id = "s_566",
	leftDialog = "@conversation/ep3_etyyy_manfred_carter:s_566", -- You did much better than I thought you would, but I'm still the authority around here. Don't be disr...
	stopConversation = "true",
	options = {}
}
ep3_etyyy_manfred_carter_convo:addScreen(ep3_etyyy_manfred_carter_convo_s_566)

ep3_etyyy_manfred_carter_convo_s_657 = ConvoScreen:new {
	id = "s_657",
	leftDialog = "@conversation/ep3_etyyy_manfred_carter:s_657", -- Unbelievable. You actually did it. You killed Laen Pieweto. Even I couldn't do that. Hmm, does that ...
	stopConversation = "false",
	options = {
		{"@conversation/ep3_etyyy_manfred_carter:s_667", "s_670"},
		{"@conversation/ep3_etyyy_manfred_carter:s_668", "s_671"},
	}
}
ep3_etyyy_manfred_carter_convo:addScreen(ep3_etyyy_manfred_carter_convo_s_657)

ep3_etyyy_manfred_carter_convo_s_658 = ConvoScreen:new {
	id = "s_658",
	leftDialog = "@conversation/ep3_etyyy_manfred_carter:s_658", -- Go kill the Chiss poacher leader, Laen Pieweto.
	stopConversation = "true",
	options = {}
}
ep3_etyyy_manfred_carter_convo:addScreen(ep3_etyyy_manfred_carter_convo_s_658)

ep3_etyyy_manfred_carter_convo_s_659 = ConvoScreen:new {
	id = "s_659",
	leftDialog = "@conversation/ep3_etyyy_manfred_carter:s_659", -- You're doing far better than I'd dare hope. I think you're possibly even ready for a much more impor...
	stopConversation = "false",
	options = {
		{"@conversation/ep3_etyyy_manfred_carter:s_663", "s_665"},
		{"@conversation/ep3_etyyy_manfred_carter:s_664", "s_666"},
	}
}
ep3_etyyy_manfred_carter_convo:addScreen(ep3_etyyy_manfred_carter_convo_s_659)

ep3_etyyy_manfred_carter_convo_s_660 = ConvoScreen:new {
	id = "s_660",
	leftDialog = "@conversation/ep3_etyyy_manfred_carter:s_660", -- The Chiss camps are in the same place as they were for the last assignment. Only the hunters there w...
	stopConversation = "true",
	options = {}
}
ep3_etyyy_manfred_carter_convo:addScreen(ep3_etyyy_manfred_carter_convo_s_660)

ep3_etyyy_manfred_carter_convo_s_568 = ConvoScreen:new {
	id = "s_568",
	leftDialog = "@conversation/ep3_etyyy_manfred_carter:s_568", -- I guess you handled that assignment okay, so maybe giving you another isn't out of the question. The...
	stopConversation = "false",
	options = {
		{"@conversation/ep3_etyyy_manfred_carter:s_570", "s_572"},
		{"@conversation/ep3_etyyy_manfred_carter:s_661", "s_662"},
	}
}
ep3_etyyy_manfred_carter_convo:addScreen(ep3_etyyy_manfred_carter_convo_s_568)

ep3_etyyy_manfred_carter_convo_s_574 = ConvoScreen:new {
	id = "s_574",
	leftDialog = "@conversation/ep3_etyyy_manfred_carter:s_574", -- Deliver those poached goods to Kerssoc. He's in the hunting camp in the Kachirho region. You'll have...
	stopConversation = "true",
	options = {}
}
ep3_etyyy_manfred_carter_convo:addScreen(ep3_etyyy_manfred_carter_convo_s_574)

ep3_etyyy_manfred_carter_convo_s_584 = ConvoScreen:new {
	id = "s_584",
	leftDialog = "@conversation/ep3_etyyy_manfred_carter:s_584", -- The Chiss camps are on the west side of Etyyy. Just keep going west, and you'll find them. A bit sou...
	stopConversation = "true",
	options = {}
}
ep3_etyyy_manfred_carter_convo:addScreen(ep3_etyyy_manfred_carter_convo_s_584)

ep3_etyyy_manfred_carter_convo_s_590 = ConvoScreen:new {
	id = "s_590",
	animation = "greet",
	leftDialog = "@conversation/ep3_etyyy_manfred_carter:s_590", -- Sordaan wants you to help me? Hmph. I don't need any help. I am the security authority around here. ...
	stopConversation = "false",
	options = {
		{"@conversation/ep3_etyyy_manfred_carter:s_592", "s_594"},
		{"@conversation/ep3_etyyy_manfred_carter:s_596", "s_598"},
	}
}
ep3_etyyy_manfred_carter_convo:addScreen(ep3_etyyy_manfred_carter_convo_s_590)

ep3_etyyy_manfred_carter_convo_s_600 = ConvoScreen:new {
	id = "s_600",
	leftDialog = "@conversation/ep3_etyyy_manfred_carter:s_600", -- Do not disrespect my authority. Not now. Not ever.
	stopConversation = "true",
	options = {}
}
ep3_etyyy_manfred_carter_convo:addScreen(ep3_etyyy_manfred_carter_convo_s_600)

addConversationTemplate("ep3_etyyy_manfred_carter_convo", ep3_etyyy_manfred_carter_convo)
