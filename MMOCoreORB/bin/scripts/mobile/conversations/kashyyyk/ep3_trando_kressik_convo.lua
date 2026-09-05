-- Kressik -- ep3_kachirho_trando_rifle_crafting
-- ruling 2026-09-04: "ensure kashyyyk is done in full"
-- Transcribed from the giver's java branches. Strings are shipped keys.
-- The journal row for quest/ep3_kachirho_*.qst comes from the integration branch later; do not call Journal.*.

ep3_trando_kressik_convo = ConvoTemplate:new {
	initialScreen = "s_60",
	templateType = "Lua",
	luaClassHandler = "ep3_trando_kressik_conv_handler",
	screens = {}
}

ep3_trando_kressik_convo_s_4 = ConvoScreen:new {
	id = "s_4",
	leftDialog = "@conversation/ep3_kachirho_trando_rifle:s_4", -- Hope you are putting that schematic I gave you to good use. I heard that there is trouble brewing on the platform...and I was just wondering if you had anyth...
	stopConversation = "true",
	options = {}
}
ep3_trando_kressik_convo:addScreen(ep3_trando_kressik_convo_s_4)

ep3_trando_kressik_convo_s_6 = ConvoScreen:new {
	id = "s_6",
	leftDialog = "@conversation/ep3_kachirho_trando_rifle:s_6", -- You were gone for a while. Did you have any trouble getting your hands on one of those bowcasters for me?
	stopConversation = "false",
	options = {
		{"@conversation/ep3_kachirho_trando_rifle:s_25", "s_26"},
	}
}
ep3_trando_kressik_convo:addScreen(ep3_trando_kressik_convo_s_6)

ep3_trando_kressik_convo_s_16 = ConvoScreen:new {
	id = "s_16",
	leftDialog = "@conversation/ep3_kachirho_trando_rifle:s_16", -- Welcome back. Do you have that bowcaster I need to look at?
	stopConversation = "false",
	options = {
		{"@conversation/ep3_kachirho_trando_rifle:s_23", "s_24"},
	}
}
ep3_trando_kressik_convo:addScreen(ep3_trando_kressik_convo_s_16)

ep3_trando_kressik_convo_s_20 = ConvoScreen:new {
	id = "s_20",
	leftDialog = "@conversation/ep3_kachirho_trando_rifle:s_20", -- You have the look of a fine weaponsmith about you. I always could tell another weaponsmith when I saw them...something about the hands I think. Maybe you wou...
	stopConversation = "false",
	options = {
		{"@conversation/ep3_kachirho_trando_rifle:s_22", "s_34"},
		{"@conversation/ep3_kachirho_trando_rifle:s_56", "s_58"},
	}
}
ep3_trando_kressik_convo:addScreen(ep3_trando_kressik_convo_s_20)

ep3_trando_kressik_convo_s_60 = ConvoScreen:new {
	id = "s_60",
	leftDialog = "@conversation/ep3_kachirho_trando_rifle:s_60", -- Sorry, my firend. I am afraid that I am a bit busy putting together a new rifle for my chief. I could use a hand though if you happen to know any weaponsmith...
	stopConversation = "true",
	options = {}
}
ep3_trando_kressik_convo:addScreen(ep3_trando_kressik_convo_s_60)

ep3_trando_kressik_convo_s_26 = ConvoScreen:new {
	id = "s_26",
	leftDialog = "@conversation/ep3_kachirho_trando_rifle:s_26", -- Glad to hear it. Well, let me take a look at that gun...Wow..what a piece of junk! I cannot believe that the higher ups were worried that the reistance might...
	stopConversation = "false",
	options = {
		{"@conversation/ep3_kachirho_trando_rifle:s_27", "s_28"},
	}
}
ep3_trando_kressik_convo:addScreen(ep3_trando_kressik_convo_s_26)

ep3_trando_kressik_convo_s_28 = ConvoScreen:new {
	id = "s_28",
	leftDialog = "@conversation/ep3_kachirho_trando_rifle:s_28", -- That is too bad. Oh, well. Now I promised to show you how to make a hunter's rifle. I will transfer the schematic to your datapad...it is pretty straight for...
	stopConversation = "false",
	options = {
		{"@conversation/ep3_kachirho_trando_rifle:s_29", "s_30"},
	}
}
ep3_trando_kressik_convo:addScreen(ep3_trando_kressik_convo_s_28)

ep3_trando_kressik_convo_s_30 = ConvoScreen:new {
	id = "s_30",
	leftDialog = "@conversation/ep3_kachirho_trando_rifle:s_30", -- You can only get them from the Avatar Space Platform. We have to order ours but I am not sure how you are going to get yours. The Blackscales are certainly n...
	stopConversation = "false",
	options = {
		{"@conversation/ep3_kachirho_trando_rifle:s_31", "s_32"},
	}
}
ep3_trando_kressik_convo:addScreen(ep3_trando_kressik_convo_s_30)

ep3_trando_kressik_convo_s_32 = ConvoScreen:new {
	id = "s_32",
	leftDialog = "@conversation/ep3_kachirho_trando_rifle:s_32", -- Hey now! I didn't say any such thing. I just gave you some information and what you do with it is your business. Of course, I wouldn't mind it if the Blacksc...
	stopConversation = "true",
	options = {}
}
ep3_trando_kressik_convo:addScreen(ep3_trando_kressik_convo_s_32)

ep3_trando_kressik_convo_s_24 = ConvoScreen:new {
	id = "s_24",
	leftDialog = "@conversation/ep3_kachirho_trando_rifle:s_24", -- I see. Well do whatever you have to do to get me one of those guns to take a look at. Good luck.
	stopConversation = "true",
	options = {}
}
ep3_trando_kressik_convo:addScreen(ep3_trando_kressik_convo_s_24)

ep3_trando_kressik_convo_s_34 = ConvoScreen:new {
	id = "s_34",
	leftDialog = "@conversation/ep3_kachirho_trando_rifle:s_34", -- Well, my chief has me putting together a new rifle for him and he wants it yesterday...you know how it is. And on top of that, I was just told to find out ab...
	stopConversation = "false",
	options = {
		{"@conversation/ep3_kachirho_trando_rifle:s_36", "s_38"},
	}
}
ep3_trando_kressik_convo:addScreen(ep3_trando_kressik_convo_s_34)

ep3_trando_kressik_convo_s_38 = ConvoScreen:new {
	id = "s_38",
	leftDialog = "@conversation/ep3_kachirho_trando_rifle:s_38", -- All you need to do is speak to Lolo. She is a Wookiee weaponsmith, who has a little shop in Kachihro. She is pretty good but I am afraid way to trusting. Jus...
	stopConversation = "false",
	options = {
		{"@conversation/ep3_kachirho_trando_rifle:s_40", "s_42"},
	}
}
ep3_trando_kressik_convo:addScreen(ep3_trando_kressik_convo_s_38)

ep3_trando_kressik_convo_s_42 = ConvoScreen:new {
	id = "s_42",
	leftDialog = "@conversation/ep3_kachirho_trando_rifle:s_42", -- To be honest, I really don't know. I heard his name once or twice...supposed to be some big wig in the Wookiee resistance. Like I said, Lolo isn't the sharpe...
	stopConversation = "false",
	options = {
		{"@conversation/ep3_kachirho_trando_rifle:s_44", "s_46"},
	}
}
ep3_trando_kressik_convo:addScreen(ep3_trando_kressik_convo_s_42)

ep3_trando_kressik_convo_s_46 = ConvoScreen:new {
	id = "s_46",
	leftDialog = "@conversation/ep3_kachirho_trando_rifle:s_46", -- Spoken like a true businessman. Tell you what...if you get me one of those new bowcasters, I will show you how to make a Trandoshan Hunter's Rifle. Do we hav...
	stopConversation = "false",
	options = {
		{"@conversation/ep3_kachirho_trando_rifle:s_48", "s_50"},
		{"@conversation/ep3_kachirho_trando_rifle:s_52", "s_54"},
	}
}
ep3_trando_kressik_convo:addScreen(ep3_trando_kressik_convo_s_46)

ep3_trando_kressik_convo_s_50 = ConvoScreen:new {
	id = "s_50",
	leftDialog = "@conversation/ep3_kachirho_trando_rifle:s_50", -- Great. You go get me one of those bowcasters and I will show you how to make the rifle. See you when you get back with one of those bowcasters.
	stopConversation = "true",
	options = {}
}
ep3_trando_kressik_convo:addScreen(ep3_trando_kressik_convo_s_50)

ep3_trando_kressik_convo_s_54 = ConvoScreen:new {
	id = "s_54",
	leftDialog = "@conversation/ep3_kachirho_trando_rifle:s_54", -- Sorry to hear that. Well, if you change your mind I will be hear for a while.
	stopConversation = "true",
	options = {}
}
ep3_trando_kressik_convo:addScreen(ep3_trando_kressik_convo_s_54)

ep3_trando_kressik_convo_s_58 = ConvoScreen:new {
	id = "s_58",
	leftDialog = "@conversation/ep3_kachirho_trando_rifle:s_58", -- Alright. Maybe later, as you say.
	stopConversation = "true",
	options = {}
}
ep3_trando_kressik_convo:addScreen(ep3_trando_kressik_convo_s_58)

addConversationTemplate("ep3_trando_kressik_convo", ep3_trando_kressik_convo)
