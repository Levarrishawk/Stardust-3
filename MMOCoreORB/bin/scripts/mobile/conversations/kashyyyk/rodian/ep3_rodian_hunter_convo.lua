-- ep3_rodian_hunter
-- ruling 2026-09-04
-- Transcribed from the giver's java branches. Strings are shipped keys.
-- NO JOURNAL: this branch has no managers/quest/journal.lua. The client ships
-- the .qst; the journal row comes from the integration branch later.

ep3_rodian_hunter_convo = ConvoTemplate:new {
	initialScreen = "s_31d7e474",
	templateType = "Lua",
	luaClassHandler = "ep3_rodian_hunter_conv_handler",
	screens = {}
}

ep3_rodian_hunter_convo_s_31d7e474 = ConvoScreen:new {
	id = "s_31d7e474",
	animation = "greet",
	leftDialog = "@conversation/ep3_rodian_hunter:s_31d7e474", -- Hello! I'm Bazeedo - chief hunter of this clan. Word of your coming has preceeded you. I am glad to see you've made it.
	stopConversation = "false",
	options = {
		{"@conversation/ep3_rodian_hunter:s_2f1410df", "s_fa986495"},
	}
}
ep3_rodian_hunter_convo:addScreen(ep3_rodian_hunter_convo_s_31d7e474)

ep3_rodian_hunter_convo_s_225d3518 = ConvoScreen:new {
	id = "s_225d3518",
	animation = "shrug_hands",
	leftDialog = "@conversation/ep3_rodian_hunter:s_225d3518", -- What are you waiting for?
	stopConversation = "false",
	options = {
		{"@conversation/ep3_rodian_hunter:s_ac3b13f5", "s_50c166a3"},
	}
}
ep3_rodian_hunter_convo:addScreen(ep3_rodian_hunter_convo_s_225d3518)

ep3_rodian_hunter_convo_s_b26194cb = ConvoScreen:new {
	id = "s_b26194cb",
	animation = "greet",
	leftDialog = "@conversation/ep3_rodian_hunter:s_b26194cb", -- What are you doing here?
	stopConversation = "false",
	options = {
		{"@conversation/ep3_rodian_hunter:s_ff3c855b", "s_4e4fe804"},
	}
}
ep3_rodian_hunter_convo:addScreen(ep3_rodian_hunter_convo_s_b26194cb)

ep3_rodian_hunter_convo_s_cf298387 = ConvoScreen:new {
	id = "s_cf298387",
	animation = "implore",
	leftDialog = "@conversation/ep3_rodian_hunter:s_cf298387", -- It's good to see you again! Look - we've got trouble! Would you do a favor for me?
	stopConversation = "false",
	options = {
		{"@conversation/ep3_rodian_hunter:s_8be640b8", "s_e3bd19bc"},
	}
}
ep3_rodian_hunter_convo:addScreen(ep3_rodian_hunter_convo_s_cf298387)

ep3_rodian_hunter_convo_s_d2849e62 = ConvoScreen:new {
	id = "s_d2849e62",
	animation = "rub_chin_thoughtful",
	leftDialog = "@conversation/ep3_rodian_hunter:s_d2849e62", -- What's the problem?
	stopConversation = "false",
	options = {
		{"@conversation/ep3_rodian_hunter:s_b1bd5fe2", "s_de3892ae"},
		{"@conversation/ep3_rodian_hunter:s_a4e70cc0", "s_fa2e7213"},
	}
}
ep3_rodian_hunter_convo:addScreen(ep3_rodian_hunter_convo_s_d2849e62)

ep3_rodian_hunter_convo_s_b21a191 = ConvoScreen:new {
	id = "s_b21a191",
	animation = "shake_head_disgust",
	leftDialog = "@conversation/ep3_rodian_hunter:s_b21a191",
	stopConversation = "false",
	options = {
		{"@conversation/ep3_rodian_hunter:s_b84b366c", "s_e9a0750f"},
	}
}
ep3_rodian_hunter_convo:addScreen(ep3_rodian_hunter_convo_s_b21a191)

ep3_rodian_hunter_convo_s_d0306922 = ConvoScreen:new {
	id = "s_d0306922",
	animation = "greet",
	leftDialog = "@conversation/ep3_rodian_hunter:s_d0306922", -- I hope you are well, my friend. How can I help you?
	stopConversation = "false",
	options = {
		{"@conversation/ep3_rodian_hunter:s_7e4fd412", "s_f20fccbf"},
	}
}
ep3_rodian_hunter_convo:addScreen(ep3_rodian_hunter_convo_s_d0306922)

ep3_rodian_hunter_convo_s_fa986495 = ConvoScreen:new {
	id = "s_fa986495",
	animation = "shake_head_no",
	leftDialog = "@conversation/ep3_rodian_hunter:s_fa986495", -- At the moment, this is impossible. Our benefactor has shut down the hunt. He is preoccupied by a clan of Trandoshans tha
	stopConversation = "false",
	options = {
		{"@conversation/ep3_rodian_hunter:s_2fac86c", "s_1a09ac5e"},
	}
}
ep3_rodian_hunter_convo:addScreen(ep3_rodian_hunter_convo_s_fa986495)

ep3_rodian_hunter_convo_s_1a09ac5e = ConvoScreen:new {
	id = "s_1a09ac5e",
	animation = "nod",
	leftDialog = "@conversation/ep3_rodian_hunter:s_1a09ac5e", -- Yes. You can ask him if you'd like. He's in a guard tower just outside of this camp.
	stopConversation = "false",
	options = {
		{"@conversation/ep3_rodian_hunter:s_cba7ab48", "s_a80d9308"},
	}
}
ep3_rodian_hunter_convo:addScreen(ep3_rodian_hunter_convo_s_1a09ac5e)

ep3_rodian_hunter_convo_s_a80d9308 = ConvoScreen:new {
	id = "s_a80d9308",
	animation = "goodbye",
	leftDialog = "@conversation/ep3_rodian_hunter:s_a80d9308", -- Good luck!
	stopConversation = "true",
	options = {}
}
ep3_rodian_hunter_convo:addScreen(ep3_rodian_hunter_convo_s_a80d9308)

ep3_rodian_hunter_convo_s_50c166a3 = ConvoScreen:new {
	id = "s_50c166a3",
	animation = "point_forward",
	leftDialog = "@conversation/ep3_rodian_hunter:s_50c166a3", -- It's easy. Just go outside this hut - walk straight for about a minute. You'll see a giant tree. Go up the tree ramp. Yo
	stopConversation = "false",
	options = {
		{"@conversation/ep3_rodian_hunter:s_4d5b8557", "s_d28436cd"},
	}
}
ep3_rodian_hunter_convo:addScreen(ep3_rodian_hunter_convo_s_50c166a3)

ep3_rodian_hunter_convo_s_d28436cd = ConvoScreen:new {
	id = "s_d28436cd",
	animation = "goodbye",
	leftDialog = "@conversation/ep3_rodian_hunter:s_d28436cd", -- Good bye!
	stopConversation = "true",
	options = {}
}
ep3_rodian_hunter_convo:addScreen(ep3_rodian_hunter_convo_s_d28436cd)

ep3_rodian_hunter_convo_s_4e4fe804 = ConvoScreen:new {
	id = "s_4e4fe804",
	animation = "apologize",
	leftDialog = "@conversation/ep3_rodian_hunter:s_4e4fe804", -- I know, but you can't until you have been given permission by our Wookiee benefactor. See him, talk to him, and do what 
	stopConversation = "false",
	options = {
		{"@conversation/ep3_rodian_hunter:s_9301eff1", "s_34824b35"},
	}
}
ep3_rodian_hunter_convo:addScreen(ep3_rodian_hunter_convo_s_4e4fe804)

ep3_rodian_hunter_convo_s_34824b35 = ConvoScreen:new {
	id = "s_34824b35",
	animation = "goodbye",
	leftDialog = "@conversation/ep3_rodian_hunter:s_34824b35", -- Once he is your friend, he will let you hunt here.
	stopConversation = "true",
	options = {}
}
ep3_rodian_hunter_convo:addScreen(ep3_rodian_hunter_convo_s_34824b35)

ep3_rodian_hunter_convo_s_e3bd19bc = ConvoScreen:new {
	id = "s_e3bd19bc",
	animation = "explain",
	leftDialog = "@conversation/ep3_rodian_hunter:s_e3bd19bc", -- My nephew brought a family of rill to this planet. His pets, you see. This was a bad idea. Turns out that the native flo
	stopConversation = "false",
	options = {
		{"@conversation/ep3_rodian_hunter:s_1d144f53", "s_fe77e31e"},
	}
}
ep3_rodian_hunter_convo:addScreen(ep3_rodian_hunter_convo_s_e3bd19bc)

ep3_rodian_hunter_convo_s_fe77e31e = ConvoScreen:new {
	id = "s_fe77e31e",
	animation = "slump_head",
	leftDialog = "@conversation/ep3_rodian_hunter:s_fe77e31e", -- Sad to say, but yes. Not much of a challenge for a hunter such as yourself - but it would be a great favor to me.
	stopConversation = "false",
	options = {
		{"@conversation/ep3_rodian_hunter:s_d24a2285", "s_81fdc59e"},
	}
}
ep3_rodian_hunter_convo:addScreen(ep3_rodian_hunter_convo_s_fe77e31e)

ep3_rodian_hunter_convo_s_81fdc59e = ConvoScreen:new {
	id = "s_81fdc59e",
	animation = "goodbye",
	leftDialog = "@conversation/ep3_rodian_hunter:s_81fdc59e", -- Thank you!
	stopConversation = "true",
	options = {}
}
ep3_rodian_hunter_convo:addScreen(ep3_rodian_hunter_convo_s_81fdc59e)

ep3_rodian_hunter_convo_s_de3892ae = ConvoScreen:new {
	id = "s_de3892ae",
	animation = "goodbye",
	leftDialog = "@conversation/ep3_rodian_hunter:s_de3892ae", -- Goodbye!
	stopConversation = "true",
	options = {}
}
ep3_rodian_hunter_convo:addScreen(ep3_rodian_hunter_convo_s_de3892ae)

ep3_rodian_hunter_convo_s_fa2e7213 = ConvoScreen:new {
	id = "s_fa2e7213",
	animation = "manipulate_medium",
	leftDialog = "@conversation/ep3_rodian_hunter:s_fa2e7213", -- No problem!
	stopConversation = "true",
	options = {}
}
ep3_rodian_hunter_convo:addScreen(ep3_rodian_hunter_convo_s_fa2e7213)

ep3_rodian_hunter_convo_s_e9a0750f = ConvoScreen:new {
	id = "s_e9a0750f",
	animation = "explain",
	leftDialog = "@conversation/ep3_rodian_hunter:s_e9a0750f", -- Some of these slavers will be carrying orders from the Slavemaster. Not all of them - but many of them. Would you be wil
	stopConversation = "false",
	options = {
		{"@conversation/ep3_rodian_hunter:s_34f24948", "s_88467f34"},
	}
}
ep3_rodian_hunter_convo:addScreen(ep3_rodian_hunter_convo_s_e9a0750f)

ep3_rodian_hunter_convo_s_88467f34 = ConvoScreen:new {
	id = "s_88467f34",
	animation = "pound_fist_palm",
	leftDialog = "@conversation/ep3_rodian_hunter:s_88467f34", -- Excellent! Collect at least five of the Trandoshan slavers' kidnap orders. That should teach them!
	stopConversation = "false",
	options = {
		{"@conversation/ep3_rodian_hunter:s_e42b260e", "s_fe631380"},
	}
}
ep3_rodian_hunter_convo:addScreen(ep3_rodian_hunter_convo_s_88467f34)

ep3_rodian_hunter_convo_s_fe631380 = ConvoScreen:new {
	id = "s_fe631380",
	animation = "belly_laugh",
	leftDialog = "@conversation/ep3_rodian_hunter:s_fe631380", -- Good luck, my friend!
	stopConversation = "true",
	options = {}
}
ep3_rodian_hunter_convo:addScreen(ep3_rodian_hunter_convo_s_fe631380)

ep3_rodian_hunter_convo_s_f20fccbf = ConvoScreen:new {
	id = "s_f20fccbf",
	leftDialog = "@conversation/ep3_rodian_hunter:s_f20fccbf", -- Would you take down one or two of them for me? One pays 500 but two pays 1500... for the difficulty.
	stopConversation = "false",
	options = {
		{"@conversation/ep3_rodian_hunter:s_583053f2", "s_f53e4c0c"},
		{"@conversation/ep3_rodian_hunter:s_78fecb0e", "s_7d09a75e"},
	}
}
ep3_rodian_hunter_convo:addScreen(ep3_rodian_hunter_convo_s_f20fccbf)

ep3_rodian_hunter_convo_s_f53e4c0c = ConvoScreen:new {
	id = "s_f53e4c0c",
	animation = "goodbye",
	leftDialog = "@conversation/ep3_rodian_hunter:s_f53e4c0c", -- One it shall be. See you soon!
	stopConversation = "true",
	options = {}
}
ep3_rodian_hunter_convo:addScreen(ep3_rodian_hunter_convo_s_f53e4c0c)

ep3_rodian_hunter_convo_s_7d09a75e = ConvoScreen:new {
	id = "s_7d09a75e",
	animation = "goodbye",
	leftDialog = "@conversation/ep3_rodian_hunter:s_7d09a75e", -- Superb! Good luck.
	stopConversation = "true",
	options = {}
}
ep3_rodian_hunter_convo:addScreen(ep3_rodian_hunter_convo_s_7d09a75e)

addConversationTemplate("ep3_rodian_hunter_convo", ep3_rodian_hunter_convo)
