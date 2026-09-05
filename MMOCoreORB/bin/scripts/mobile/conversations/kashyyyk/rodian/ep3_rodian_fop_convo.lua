-- ep3_rodian_fop
-- ruling 2026-09-04
-- Transcribed from the giver's java branches. Strings are shipped keys.
-- NO JOURNAL: this branch has no managers/quest/journal.lua. The client ships
-- the .qst; the journal row comes from the integration branch later.

ep3_rodian_fop_convo = ConvoTemplate:new {
	initialScreen = "s_c8fc6f31",
	templateType = "Lua",
	luaClassHandler = "ep3_rodian_fop_conv_handler",
	screens = {}
}

ep3_rodian_fop_convo_s_c8fc6f31 = ConvoScreen:new {
	id = "s_c8fc6f31",
	animation = "greet",
	leftDialog = "@conversation/ep3_rodian_fop:s_c8fc6f31", -- DEFAULT CONVO. Which quest in my series do you want to talk about?
	stopConversation = "false",
	options = {
		{"@conversation/ep3_rodian_fop:s_ce7e4cd9", "s_1af1928c"},
		{"@conversation/ep3_rodian_fop:s_4b16bcf", "s_9d3e4637"},
		{"@conversation/ep3_rodian_fop:s_faa659eb", "s_21fea0de"},
		{"@conversation/ep3_rodian_fop:s_24d697f1", "s_1f2267dd"},
	}
}
ep3_rodian_fop_convo:addScreen(ep3_rodian_fop_convo_s_c8fc6f31)

ep3_rodian_fop_convo_s_c8fc6f31_q1 = ConvoScreen:new {
	id = "s_c8fc6f31_q1",
	animation = "greet",
	leftDialog = "@conversation/ep3_rodian_fop:s_c8fc6f31", -- DEFAULT CONVO. Which quest in my series do you want to talk about?
	stopConversation = "false",
	options = {
		{"@conversation/ep3_rodian_fop:s_4b16bcf", "s_9d3e4637"},
		{"@conversation/ep3_rodian_fop:s_faa659eb", "s_21fea0de"},
		{"@conversation/ep3_rodian_fop:s_24d697f1", "s_1f2267dd"},
	}
}
ep3_rodian_fop_convo:addScreen(ep3_rodian_fop_convo_s_c8fc6f31_q1)

ep3_rodian_fop_convo_s_c8fc6f31_q2 = ConvoScreen:new {
	id = "s_c8fc6f31_q2",
	animation = "greet",
	leftDialog = "@conversation/ep3_rodian_fop:s_c8fc6f31", -- DEFAULT CONVO. Which quest in my series do you want to talk about?
	stopConversation = "false",
	options = {
		{"@conversation/ep3_rodian_fop:s_ce7e4cd9", "s_1af1928c"},
		{"@conversation/ep3_rodian_fop:s_faa659eb", "s_21fea0de"},
		{"@conversation/ep3_rodian_fop:s_24d697f1", "s_1f2267dd"},
	}
}
ep3_rodian_fop_convo:addScreen(ep3_rodian_fop_convo_s_c8fc6f31_q2)

ep3_rodian_fop_convo_s_c8fc6f31_both = ConvoScreen:new {
	id = "s_c8fc6f31_both",
	animation = "greet",
	leftDialog = "@conversation/ep3_rodian_fop:s_c8fc6f31", -- DEFAULT CONVO. Which quest in my series do you want to talk about?
	stopConversation = "false",
	options = {
		{"@conversation/ep3_rodian_fop:s_faa659eb", "s_21fea0de"},
		{"@conversation/ep3_rodian_fop:s_24d697f1", "s_1f2267dd"},
	}
}
ep3_rodian_fop_convo:addScreen(ep3_rodian_fop_convo_s_c8fc6f31_both)

ep3_rodian_fop_convo_s_d628eb2d = ConvoScreen:new {
	id = "s_d628eb2d",
	animation = "greet",
	leftDialog = "@conversation/ep3_rodian_fop:s_d628eb2d", -- Salutations, poor traveler. Are you here to take part in the hunt?
	stopConversation = "false",
	options = {
		{"@conversation/ep3_rodian_fop:s_d335136f", "s_b0e55a4a"},
		{"@conversation/ep3_rodian_fop:s_d6695e83", "s_258b522b"},
	}
}
ep3_rodian_fop_convo:addScreen(ep3_rodian_fop_convo_s_d628eb2d)

ep3_rodian_fop_convo_s_affc3808 = ConvoScreen:new {
	id = "s_affc3808",
	leftDialog = "@conversation/ep3_rodian_fop:s_affc3808", -- Good job with the rill, my friend. Are you ready for a greater challenge?
	stopConversation = "false",
	options = {
		{"@conversation/ep3_rodian_fop:s_d335136f", "s_2551a79"},
		{"@conversation/ep3_rodian_fop:s_d6695e83", "s_258b522b"},
	}
}
ep3_rodian_fop_convo:addScreen(ep3_rodian_fop_convo_s_affc3808)

ep3_rodian_fop_convo_s_f3acc17c = ConvoScreen:new {
	id = "s_f3acc17c",
	animation = "bow",
	leftDialog = "@conversation/ep3_rodian_fop:s_f3acc17c", -- Thank you for recovering our paystubs! Seems those Trandoshans didn't want to give them up!
	stopConversation = "false",
	options = {
		{"@conversation/ep3_rodian_fop:s_74505020", "s_5a51ce2b"},
	}
}
ep3_rodian_fop_convo:addScreen(ep3_rodian_fop_convo_s_f3acc17c)

ep3_rodian_fop_convo_s_ef75f1bd = ConvoScreen:new {
	id = "s_ef75f1bd",
	animation = "bow",
	leftDialog = "@conversation/ep3_rodian_fop:s_ef75f1bd", -- Ah yes! You have completed all three of the quests that I have to assign. Would you like them cleared so we can do this 
	stopConversation = "false",
	options = {
		{"@conversation/ep3_rodian_fop:s_24d697f1", "s_da6e65ae"},
	}
}
ep3_rodian_fop_convo:addScreen(ep3_rodian_fop_convo_s_ef75f1bd)

ep3_rodian_fop_convo_s_1af1928c = ConvoScreen:new {
	id = "s_1af1928c",
	animation = "explain",
	leftDialog = "@conversation/ep3_rodian_fop:s_1af1928c", -- You know these Rills are really a pain in my ass. They said something to me. I want you to get revenge. Sound good?
	stopConversation = "false",
	options = {
		{"@conversation/ep3_rodian_fop:s_a9504589", "s_b4a2635a"},
	}
}
ep3_rodian_fop_convo:addScreen(ep3_rodian_fop_convo_s_1af1928c)

ep3_rodian_fop_convo_s_9d3e4637 = ConvoScreen:new {
	id = "s_9d3e4637",
	animation = "shrug_hands",
	leftDialog = "@conversation/ep3_rodian_fop:s_9d3e4637", -- Did you hear what happened to your paystubs?
	stopConversation = "false",
	options = {
		{"@conversation/ep3_rodian_fop:s_8aaad6", "s_5788ca33"},
		{"@conversation/ep3_rodian_fop:s_7c997a0f", "s_3fa4f0ff"},
	}
}
ep3_rodian_fop_convo:addScreen(ep3_rodian_fop_convo_s_9d3e4637)

ep3_rodian_fop_convo_s_21fea0de = ConvoScreen:new {
	id = "s_21fea0de",
	animation = "shrug_shoulders",
	leftDialog = "@conversation/ep3_rodian_fop:s_21fea0de", -- What sort of stuff do you want to talk about?
	stopConversation = "false",
	options = {
		{"@conversation/ep3_rodian_fop:s_5c203304", "s_350e80d0"},
		{"@conversation/ep3_rodian_fop:s_17afa2c1", "s_1f9504f1"},
		{"@conversation/ep3_rodian_fop:s_239d72a7", "s_31d5e344"},
		{"@conversation/ep3_rodian_fop:s_6a4b471a", "s_59a3429f"},
	}
}
ep3_rodian_fop_convo:addScreen(ep3_rodian_fop_convo_s_21fea0de)

ep3_rodian_fop_convo_s_1f2267dd = ConvoScreen:new {
	id = "s_1f2267dd",
	animation = "manipulate_medium",
	leftDialog = "@conversation/ep3_rodian_fop:s_1f2267dd", -- All cleared.
	stopConversation = "true",
	options = {}
}
ep3_rodian_fop_convo:addScreen(ep3_rodian_fop_convo_s_1f2267dd)

ep3_rodian_fop_convo_s_b4a2635a = ConvoScreen:new {
	id = "s_b4a2635a",
	animation = "gesticulate_wildly",
	leftDialog = "@conversation/ep3_rodian_fop:s_b4a2635a", -- Kid? Who you calling kid? Look there's fifty bucks in this for you. You want it or not?
	stopConversation = "false",
	options = {
		{"@conversation/ep3_rodian_fop:s_e8b238c6", "s_98f012fb"},
		{"@conversation/ep3_rodian_fop:s_d6695e83", "s_a5f02cb6"},
	}
}
ep3_rodian_fop_convo:addScreen(ep3_rodian_fop_convo_s_b4a2635a)

ep3_rodian_fop_convo_s_98f012fb = ConvoScreen:new {
	id = "s_98f012fb",
	animation = "goodbye",
	leftDialog = "@conversation/ep3_rodian_fop:s_98f012fb", -- Sounds great! Come back when you're finished.
	stopConversation = "true",
	options = {}
}
ep3_rodian_fop_convo:addScreen(ep3_rodian_fop_convo_s_98f012fb)

ep3_rodian_fop_convo_s_a5f02cb6 = ConvoScreen:new {
	id = "s_a5f02cb6",
	animation = "wave_on_dismissing",
	leftDialog = "@conversation/ep3_rodian_fop:s_a5f02cb6", -- Then fine.
	stopConversation = "true",
	options = {}
}
ep3_rodian_fop_convo:addScreen(ep3_rodian_fop_convo_s_a5f02cb6)

ep3_rodian_fop_convo_s_5788ca33 = ConvoScreen:new {
	id = "s_5788ca33",
	animation = "pound_fist_palm",
	leftDialog = "@conversation/ep3_rodian_fop:s_5788ca33", -- Those Trandoshan Slavers took em! What say you teach them a lesson in... dying?
	stopConversation = "false",
	options = {
		{"@conversation/ep3_rodian_fop:s_638a7a62", "s_add1e6bf"},
	}
}
ep3_rodian_fop_convo:addScreen(ep3_rodian_fop_convo_s_5788ca33)

ep3_rodian_fop_convo_s_3fa4f0ff = ConvoScreen:new {
	id = "s_3fa4f0ff",
	animation = "wave_on_dismissing",
	leftDialog = "@conversation/ep3_rodian_fop:s_3fa4f0ff", -- Fine!
	stopConversation = "true",
	options = {}
}
ep3_rodian_fop_convo:addScreen(ep3_rodian_fop_convo_s_3fa4f0ff)

ep3_rodian_fop_convo_s_add1e6bf = ConvoScreen:new {
	id = "s_add1e6bf",
	animation = "goodbye",
	leftDialog = "@conversation/ep3_rodian_fop:s_add1e6bf", -- I'll pay you a thousand. Get back three paystubs.
	stopConversation = "true",
	options = {}
}
ep3_rodian_fop_convo:addScreen(ep3_rodian_fop_convo_s_add1e6bf)

ep3_rodian_fop_convo_s_350e80d0 = ConvoScreen:new {
	id = "s_350e80d0",
	leftDialog = "@conversation/ep3_rodian_fop:s_350e80d0", -- Not much to tell. What do you want to know?
	stopConversation = "false",
	options = {
		{"@conversation/ep3_rodian_fop:s_8d19943f", "s_97a6b800"},
		{"@conversation/ep3_rodian_fop:s_8aaea660", "s_41bfc9bc"},
		{"@conversation/ep3_rodian_fop:s_ca932c28", "s_6942f23"},
	}
}
ep3_rodian_fop_convo:addScreen(ep3_rodian_fop_convo_s_350e80d0)

ep3_rodian_fop_convo_s_1f9504f1 = ConvoScreen:new {
	id = "s_1f9504f1",
	leftDialog = "@conversation/ep3_rodian_fop:s_1f9504f1", -- Yeah. What about them! They really do a lot of slaving. Figure it's big money?
	stopConversation = "false",
	options = {
		{"@conversation/ep3_rodian_fop:s_5c203304", "s_350e80d0"},
		{"@conversation/ep3_rodian_fop:s_17afa2c1", "s_1f9504f1"},
		{"@conversation/ep3_rodian_fop:s_239d72a7", "s_31d5e344"},
		{"@conversation/ep3_rodian_fop:s_6a4b471a", "s_59a3429f"},
	}
}
ep3_rodian_fop_convo:addScreen(ep3_rodian_fop_convo_s_1f9504f1)

ep3_rodian_fop_convo_s_31d5e344 = ConvoScreen:new {
	id = "s_31d5e344",
	leftDialog = "@conversation/ep3_rodian_fop:s_31d5e344", -- Yes. Are you crazy? I'm from Rodia. You see the Rodian all over me? Get out of here!
	stopConversation = "false",
	options = {
		{"@conversation/ep3_rodian_fop:s_5c203304", "s_350e80d0"},
		{"@conversation/ep3_rodian_fop:s_17afa2c1", "s_1f9504f1"},
		{"@conversation/ep3_rodian_fop:s_239d72a7", "s_31d5e344"},
		{"@conversation/ep3_rodian_fop:s_6a4b471a", "s_59a3429f"},
	}
}
ep3_rodian_fop_convo:addScreen(ep3_rodian_fop_convo_s_31d5e344)

ep3_rodian_fop_convo_s_59a3429f = ConvoScreen:new {
	id = "s_59a3429f",
	leftDialog = "@conversation/ep3_rodian_fop:s_59a3429f", -- Sounds good. Which of my quests do you want to take?
	stopConversation = "false",
	options = {
		{"@conversation/ep3_rodian_fop:s_ce7e4cd9", "s_1af1928c"},
		{"@conversation/ep3_rodian_fop:s_4b16bcf", "s_9d3e4637"},
		{"@conversation/ep3_rodian_fop:s_faa659eb", "s_21fea0de"},
		{"@conversation/ep3_rodian_fop:s_24d697f1", "s_1f2267dd"},
	}
}
ep3_rodian_fop_convo:addScreen(ep3_rodian_fop_convo_s_59a3429f)

ep3_rodian_fop_convo_s_59a3429f_q1 = ConvoScreen:new {
	id = "s_59a3429f_q1",
	leftDialog = "@conversation/ep3_rodian_fop:s_59a3429f", -- Sounds good. Which of my quests do you want to take?
	stopConversation = "false",
	options = {
		{"@conversation/ep3_rodian_fop:s_4b16bcf", "s_9d3e4637"},
		{"@conversation/ep3_rodian_fop:s_faa659eb", "s_21fea0de"},
		{"@conversation/ep3_rodian_fop:s_24d697f1", "s_1f2267dd"},
	}
}
ep3_rodian_fop_convo:addScreen(ep3_rodian_fop_convo_s_59a3429f_q1)

ep3_rodian_fop_convo_s_59a3429f_q2 = ConvoScreen:new {
	id = "s_59a3429f_q2",
	leftDialog = "@conversation/ep3_rodian_fop:s_59a3429f", -- Sounds good. Which of my quests do you want to take?
	stopConversation = "false",
	options = {
		{"@conversation/ep3_rodian_fop:s_ce7e4cd9", "s_1af1928c"},
		{"@conversation/ep3_rodian_fop:s_faa659eb", "s_21fea0de"},
		{"@conversation/ep3_rodian_fop:s_24d697f1", "s_1f2267dd"},
	}
}
ep3_rodian_fop_convo:addScreen(ep3_rodian_fop_convo_s_59a3429f_q2)

ep3_rodian_fop_convo_s_59a3429f_both = ConvoScreen:new {
	id = "s_59a3429f_both",
	leftDialog = "@conversation/ep3_rodian_fop:s_59a3429f", -- Sounds good. Which of my quests do you want to take?
	stopConversation = "false",
	options = {
		{"@conversation/ep3_rodian_fop:s_faa659eb", "s_21fea0de"},
		{"@conversation/ep3_rodian_fop:s_24d697f1", "s_1f2267dd"},
	}
}
ep3_rodian_fop_convo:addScreen(ep3_rodian_fop_convo_s_59a3429f_both)

ep3_rodian_fop_convo_s_97a6b800 = ConvoScreen:new {
	id = "s_97a6b800",
	leftDialog = "@conversation/ep3_rodian_fop:s_97a6b800", -- There was a guy name of Chewbacca - but he left.
	stopConversation = "false",
	options = {
		{"@conversation/ep3_rodian_fop:s_8d19943f", "s_97a6b800"},
		{"@conversation/ep3_rodian_fop:s_8aaea660", "s_41bfc9bc"},
		{"@conversation/ep3_rodian_fop:s_ca932c28", "s_6942f23"},
	}
}
ep3_rodian_fop_convo:addScreen(ep3_rodian_fop_convo_s_97a6b800)

ep3_rodian_fop_convo_s_41bfc9bc = ConvoScreen:new {
	id = "s_41bfc9bc",
	leftDialog = "@conversation/ep3_rodian_fop:s_41bfc9bc", -- Don't get me started. 
	stopConversation = "false",
	options = {
		{"@conversation/ep3_rodian_fop:s_8d19943f", "s_97a6b800"},
		{"@conversation/ep3_rodian_fop:s_8aaea660", "s_41bfc9bc"},
		{"@conversation/ep3_rodian_fop:s_ca932c28", "s_6942f23"},
	}
}
ep3_rodian_fop_convo:addScreen(ep3_rodian_fop_convo_s_41bfc9bc)

ep3_rodian_fop_convo_s_6942f23 = ConvoScreen:new {
	id = "s_6942f23",
	leftDialog = "@conversation/ep3_rodian_fop:s_6942f23", -- That's cool.
	stopConversation = "false",
	options = {
		{"@conversation/ep3_rodian_fop:s_5c203304", "s_350e80d0"},
		{"@conversation/ep3_rodian_fop:s_17afa2c1", "s_1f9504f1"},
		{"@conversation/ep3_rodian_fop:s_239d72a7", "s_31d5e344"},
		{"@conversation/ep3_rodian_fop:s_6a4b471a", "s_59a3429f"},
	}
}
ep3_rodian_fop_convo:addScreen(ep3_rodian_fop_convo_s_6942f23)

ep3_rodian_fop_convo_s_b0e55a4a = ConvoScreen:new {
	id = "s_b0e55a4a",
	animation = "point_forward",
	leftDialog = "@conversation/ep3_rodian_fop:s_b0e55a4a", -- Then it is a lucky day for you! We have an opening at the lowest level of the hunt. If you are interested, I will sign y
	stopConversation = "false",
	options = {
		{"@conversation/ep3_rodian_fop:s_d324732", "s_2fed2a17"},
		{"@conversation/ep3_rodian_fop:s_d6695e83", "s_258b522b"},
	}
}
ep3_rodian_fop_convo:addScreen(ep3_rodian_fop_convo_s_b0e55a4a)

ep3_rodian_fop_convo_s_258b522b = ConvoScreen:new {
	id = "s_258b522b",
	animation = "goodbye",
	leftDialog = "@conversation/ep3_rodian_fop:s_258b522b", -- In that case, farewell.
	stopConversation = "true",
	options = {}
}
ep3_rodian_fop_convo:addScreen(ep3_rodian_fop_convo_s_258b522b)

ep3_rodian_fop_convo_s_2fed2a17 = ConvoScreen:new {
	id = "s_2fed2a17",
	animation = "goodbye",
	leftDialog = "@conversation/ep3_rodian_fop:s_2fed2a17", -- The task is to eliminate four rill creatures. Should be simple. Many rill can be found just outside the gate. Good luck!
	stopConversation = "true",
	options = {}
}
ep3_rodian_fop_convo:addScreen(ep3_rodian_fop_convo_s_2fed2a17)

ep3_rodian_fop_convo_s_2551a79 = ConvoScreen:new {
	id = "s_2551a79",
	animation = "explain",
	leftDialog = "@conversation/ep3_rodian_fop:s_2551a79", -- Several Trandoshan slavers have invaded our camp. We suspect that they have stolen our pay vouchers. I need you to make 
	stopConversation = "false",
	options = {
		{"@conversation/ep3_rodian_fop:s_5e2a2bb1", "s_6488c3cb"},
	}
}
ep3_rodian_fop_convo:addScreen(ep3_rodian_fop_convo_s_2551a79)

ep3_rodian_fop_convo_s_6488c3cb = ConvoScreen:new {
	id = "s_6488c3cb",
	animation = "goodbye",
	leftDialog = "@conversation/ep3_rodian_fop:s_6488c3cb", -- Excellent! Do battle with the nearby Trandoshan slavers. Recover at least three pay vouchers and return to me.
	stopConversation = "true",
	options = {}
}
ep3_rodian_fop_convo:addScreen(ep3_rodian_fop_convo_s_6488c3cb)

ep3_rodian_fop_convo_s_5a51ce2b = ConvoScreen:new {
	id = "s_5a51ce2b",
	animation = "rub_chin_thoughtful",
	leftDialog = "@conversation/ep3_rodian_fop:s_5a51ce2b", -- Good job! Say - would you be interested in running one more errand for me?
	stopConversation = "false",
	options = {
		{"@conversation/ep3_rodian_fop:s_81fdc173", "s_2962225f"},
	}
}
ep3_rodian_fop_convo:addScreen(ep3_rodian_fop_convo_s_5a51ce2b)

ep3_rodian_fop_convo_s_2962225f = ConvoScreen:new {
	id = "s_2962225f",
	animation = "explain",
	leftDialog = "@conversation/ep3_rodian_fop:s_2962225f", -- One of my old business associates... a wookiee... has gone missing. I am concerned that he was picked up by the Trandosh
	stopConversation = "false",
	options = {
		{"@conversation/ep3_rodian_fop:s_c261cfae", "s_bdf6c22c"},
	}
}
ep3_rodian_fop_convo:addScreen(ep3_rodian_fop_convo_s_2962225f)

ep3_rodian_fop_convo_s_bdf6c22c = ConvoScreen:new {
	id = "s_bdf6c22c",
	animation = "pound_fist_palm",
	leftDialog = "@conversation/ep3_rodian_fop:s_bdf6c22c", -- Excellent! You'll find the Trando's prison yard just south of here.
	stopConversation = "true",
	options = {}
}
ep3_rodian_fop_convo:addScreen(ep3_rodian_fop_convo_s_bdf6c22c)

ep3_rodian_fop_convo_s_da6e65ae = ConvoScreen:new {
	id = "s_da6e65ae",
	animation = "manipulate_medium",
	leftDialog = "@conversation/ep3_rodian_fop:s_da6e65ae", -- There you go! All cleared up, now.
	stopConversation = "true",
	options = {}
}
ep3_rodian_fop_convo:addScreen(ep3_rodian_fop_convo_s_da6e65ae)

addConversationTemplate("ep3_rodian_fop_convo", ep3_rodian_fop_convo)
