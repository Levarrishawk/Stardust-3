corvetteBronellConvoTemplate = ConvoTemplate:new {
	initialScreen = "",
	templateType = "Lua",
	luaClassHandler = "ticketGiverBronellConvoHandler",
	screens = {}
}

already_busy = ConvoScreen:new {
	id = "already_busy",
	leftDialog = "@conversation/corvette_bronell_neutral_assassin:s_dc53bb6d", -- Oh, well I could use your help, but I see that you're already busy. Come back when you've finished your current task and maybe we can do business.
	stopConversation = "true",
	options = {}
}
corvetteBronellConvoTemplate:addScreen(already_busy);

convo_start = ConvoScreen:new {
	id = "convo_start",
	leftDialog = "@conversation/corvette_bronell_neutral_assassin:s_8c30ea7c", -- You there. I must demand your assistance with this mission of utmost importance. You will help, yes? This mission is vital to Lord Jabba and I am only speaking on his behalf. I, of course, get nothing out of this myself. So you will help, yes yes?
	stopConversation = "false",
	options = {
		{"Tell me more.", "convo_start_2"},
		{"@conversation/corvette_bronell_neutral_assassin:s_bd40a944","convo_exit"} -- Sorry, I have other things to do.
	}
}
corvetteBronellConvoTemplate:addScreen(convo_start);

convo_exit = ConvoScreen:new {
	id = "convo_exit",
	leftDialog = "@conversation/corvette_bronell_neutral_assassin:s_7d29adc4", -- Then maybe you could leave, yes?
	stopConversation = "true",
	options = {}
}
corvetteBronellConvoTemplate:addScreen(convo_exit);

convo_start_2 = ConvoScreen:new {
	id = "convo_start_2",
	customDialogText = "A CorSec chief has been charging Lord Jabba's freight crews to get through Imperial inspections. I think he has mistaken whose business this is, yes?",
	stopConversation = "false",
	options = {
		{"Tell me more.", "convo_start_3"},
	}
}
corvetteBronellConvoTemplate:addScreen(convo_start_2);

convo_start_3 = ConvoScreen:new {
	id = "convo_start_3",
	customDialogText = "He owes debts all over the sector. He pays in favors and tells his collectors where he will be posted. Bring me a current Gambling Debt Ledger and I can tell you which ship he is on.",
	stopConversation = "false",
	options = {
		{"I'll look for the document.", "quest_start"},
	}
}
corvetteBronellConvoTemplate:addScreen(convo_start_3);

quest_start = ConvoScreen:new {
	id = "quest_start",
	customDialogText = "I have three leads for the Gambling Debt Ledger. Bring me the current copy and I'll clear you for boarding. Which lead do you want first?",
	stopConversation = "false",
	options = {}
}
corvetteBronellConvoTemplate:addScreen(quest_start);

which_planet = ConvoScreen:new {
	id = "which_planet",
	customDialogText = "Which lead for the Gambling Debt Ledger should I go over again?",
	stopConversation = "false",
	options = {}
}
corvetteBronellConvoTemplate:addScreen(which_planet);

first_location = ConvoScreen:new {
	id = "first_location",
	customDialogText = "The Binayre hold one of the chief's markers, yes? Search their accounts in the bunker on Talus (5584, -4080) for his promised payoff and the next rendezvous.",
	stopConversation = "false",
	options = {}
}
corvetteBronellConvoTemplate:addScreen(first_location);

second_location = ConvoScreen:new {
	id = "second_location",
	customDialogText = "He signed off a cargo release for pirates who held his debt. Search the bookkeeper's files in their bunker on Naboo (-1482, -1729).",
	stopConversation = "false",
	options = {	}
}
corvetteBronellConvoTemplate:addScreen(second_location);

third_location = ConvoScreen:new {
	id = "third_location",
	customDialogText = "A Corsair collector was due to meet him on his next rotation. Check the collector's outdoor stash at the stronghold on Lok (-3893, -3801).",
	stopConversation = "false",
	options = {	}
}
corvetteBronellConvoTemplate:addScreen(third_location);

go_get_intel = ConvoScreen:new {
	id = "go_get_intel",
	leftDialog = "@conversation/corvette_bronell_neutral_assassin:s_b1e7cb8c", -- Excellent! Now hurry my noble warrior, hurry for Bronell...I mean our magnificent Lord Hutt! Yes? Yes.
	stopConversation = "true",
	options = {}
}
corvetteBronellConvoTemplate:addScreen(go_get_intel);

hear_locations_quit = ConvoScreen:new {
	id = "hear_locations_quit",
	leftDialog = "@conversation/corvette_bronell_neutral_assassin:s_ecc1d177", -- Farewell, maybe I'll never see you again, yes?
	stopConversation = "true",
	options = {}
}
corvetteBronellConvoTemplate:addScreen(hear_locations_quit);

back_already = ConvoScreen:new {
	id = "back_already",
	leftDialog = "@conversation/corvette_bronell_neutral_assassin:s_491ecf2b", -- You are back already, yes? You have the documents, yes?
	stopConversation = "false",
	options = {}
}
corvetteBronellConvoTemplate:addScreen(back_already);

back_already_reset = ConvoScreen:new {
	id = "back_already_reset",
	leftDialog = "@conversation/corvette_bronell_neutral_assassin:s_88ef705e", -- Our bountiful Lord will be most disappointed by your response, yes? Also, I must take all documents from you that are connected to this business, yes? Yes.
	stopConversation = "true",
	options = {	}
}
corvetteBronellConvoTemplate:addScreen(back_already_reset);

decline_quest_reset = ConvoScreen:new {
	id = "decline_quest_reset",
	leftDialog = "@conversation/corvette_bronell_neutral_assassin:s_969790d9", -- Fine, get your smelly self out of here, yes?
	stopConversation = "true",
	options = {}
}
corvetteBronellConvoTemplate:addScreen(decline_quest_reset);

check_other_places = ConvoScreen:new {
	id = "check_other_places",
	leftDialog = "@conversation/corvette_bronell_neutral_assassin:s_502c2a8d", -- Splendid! but hurry, yes? Our magnificent Lord is not known for his patience, yes?
	stopConversation = "true",
	options = {}
}
corvetteBronellConvoTemplate:addScreen(check_other_places);

has_intel = ConvoScreen:new {
	id = "has_intel",
	leftDialog = "@conversation/corvette_bronell_neutral_assassin:s_6333f589", -- Let me see that, yes?
	stopConversation = "false",
	options = {	}
}
corvetteBronellConvoTemplate:addScreen(has_intel);

bad_intel_1 = ConvoScreen:new {
	id = "bad_intel_1",
	customDialogText = "This copy was superseded before the ship left. I'll pay you for the lead. Keep looking for the current one.",
	stopConversation = "false",
	options = {	}
}
corvetteBronellConvoTemplate:addScreen(bad_intel_1);

bad_intel_2 = ConvoScreen:new {
	id = "bad_intel_2",
	customDialogText = "This belongs to the operation, but it won't get you aboard. I'll pay you for bringing it in.",
	stopConversation = "false",
	options = {	}
}
corvetteBronellConvoTemplate:addScreen(bad_intel_2);

other_documents = ConvoScreen:new {
	id = "other_documents",
	leftDialog = "@conversation/corvette_bronell_neutral_assassin:s_dcf8e793", -- Oh? Let me see that, yes?
	stopConversation = "false",
	options = {	}
}
corvetteBronellConvoTemplate:addScreen(other_documents);

good_intel = ConvoScreen:new {
	id = "good_intel",
	customDialogText = "Here he is. The ledger names the corvette and his next posting. Give this authorization to Klaatu behind Jabba's Palace. Settle the account, then come back to me.",
	stopConversation = "false",
	options = {}
}
corvetteBronellConvoTemplate:addScreen(good_intel);

go_to_corvette = ConvoScreen:new {
	id = "go_to_corvette",
	customDialogText = "Show your authorization to Klaatu behind Jabba's Palace on Tatooine. Gather your crew before you talk to him.",
	stopConversation = "true",
	options = {}
}
corvetteBronellConvoTemplate:addScreen(go_to_corvette);

launch_location = ConvoScreen:new {
	id = "launch_location",
	customDialogText = "Show your authorization to Klaatu behind Jabba's Palace on Tatooine. Gather your crew before you talk to him.",
	stopConversation = "true",
	options = {}
}
corvetteBronellConvoTemplate:addScreen(launch_location);

still_here = ConvoScreen:new {
	id = "still_here",
	leftDialog = "@conversation/corvette_bronell_neutral_assassin:s_6f1692bf", -- Your still here? I thought I made clear time was not to be wasted looking at the dancers in the palace, yes?
	stopConversation = "false",
	options = {	}
}
corvetteBronellConvoTemplate:addScreen(still_here);

still_here_decline = ConvoScreen:new {
	id = "still_here_decline",
	leftDialog = "@conversation/corvette_bronell_neutral_assassin:s_f8c79456", -- Our bountiful Lord will be most disappointed by your attitude, maybe a bit too disappointed, yes? I'll be forced to take all documents from you that relate to this endeavor, yes?
	stopConversation = "false",
	options = {
		{"@conversation/corvette_bronell_neutral_assassin:s_79855d10","decline_quest_reset"}, --I'm sorry, I just can't right now. Please erase all records of my progress.
		{"@conversation/corvette_bronell_neutral_assassin:s_bdde1d3a","changed_mind"}, -- You might be right. Fine, I'll get back to it.
	}
}
corvetteBronellConvoTemplate:addScreen(still_here_decline);

changed_mind = ConvoScreen:new {
	id = "changed_mind",
	leftDialog = "@conversation/corvette_bronell_neutral_assassin:s_ce8f15d7", -- Good, now hurry, yes?
	stopConversation = "true",
	options = {}
}
corvetteBronellConvoTemplate:addScreen(changed_mind);

reward = ConvoScreen:new {
	id = "reward",
	customDialogText = "The chief's account is closed. Lord Jabba is pleased. I may be a little pleased myself, yes?",
	stopConversation = "false",
	options = {
		{"I'll take the payment.", "give_reward"},
		{"@conversation/corvette_bronell_neutral_assassin:s_ffc988c3","ill_be_back"} --  No, not just yet. I'll be back.
	}
}
corvetteBronellConvoTemplate:addScreen(reward);

ill_be_back = ConvoScreen:new {
	id = "ill_be_back",
	leftDialog = "@conversation/corvette_bronell_neutral_assassin:s_44fa5eb9", --As you wish. Though I do not understand why you'd want to delay, yes?
	stopConversation = "true",
	options = {	}
}
corvetteBronellConvoTemplate:addScreen(ill_be_back);

give_reward = ConvoScreen:new {
	id = "give_reward",
	leftDialog = "@conversation/corvette_bronell_neutral_assassin:s_249447d6", -- Very well. It has been well earned, yes? Yes.
	stopConversation = "true",
	options = {}
}
corvetteBronellConvoTemplate:addScreen(give_reward);

cant_give_reward = ConvoScreen:new {
	id = "cant_give_reward",
	leftDialog = "@conversation/corvette_bronell_neutral_assassin:s_73f00073", -- Hmm... you have truly earned your reward, but you do not have room for it in your inventory, yes? Please come back and speak with me after clearing some space, yes?
	stopConversation = "true",
	options = {}
}
corvetteBronellConvoTemplate:addScreen(cant_give_reward);

addConversationTemplate("corvetteBronellConvoTemplate", corvetteBronellConvoTemplate);
