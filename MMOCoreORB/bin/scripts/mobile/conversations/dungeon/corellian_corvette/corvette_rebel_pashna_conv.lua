corvettePashnaConvoTemplate = ConvoTemplate:new {
	initialScreen = "",
	templateType = "Lua",
	luaClassHandler = "ticketGiverPashnaConvoHandler",
	screens = {}
}

no_faction = ConvoScreen:new {
	id = "no_faction",
	customDialogText = "I have private business to attend to. Please excuse me.",
	stopConversation = "true",
	options = {}
}
corvettePashnaConvoTemplate:addScreen(no_faction);

already_busy = ConvoScreen:new {
	id = "already_busy",
	leftDialog = "@conversation/corvette_pashna_rebel1:s_ecc372ff",--Oh hmmm... I could really use your help, but I see that you're already busy. Come back when you've finished your current task and perhaps I'll still need your assistance.
	stopConversation = "true",
	options = {}
}
corvettePashnaConvoTemplate:addScreen(already_busy);

convo_start = ConvoScreen:new {
	id = "convo_start",
	customDialogText = "I have word of an Imperial prisoner ship. If you're free to help, I'd rather speak quietly.",
	stopConversation = "false",
	options = {
		{"Tell me more.", "convo_start_1"},
		{"@conversation/corvette_pashna_rebel1:s_b89af325","convo_exit"} --Be that as it may, good-bye.
	}
}
corvettePashnaConvoTemplate:addScreen(convo_start);

convo_start_1 = ConvoScreen:new {
	id = "convo_start_1",
	customDialogText = "An Inquisitor took over an impounded corvette and turned it into an interrogation post. He has names of households that hid a survivor of Order 66. Once his warrant reaches sector security, those families are gone.",
	stopConversation = "false",
	options = {
		{"Tell me more.", "convo_start_2"},
		{"@conversation/corvette_pashna_rebel1:s_f7e9bbb3","convo_exit_2"},--Good luck with that. I'm not interested in getting involved.
	}
}
corvettePashnaConvoTemplate:addScreen(convo_start_1);

convo_start_2 = ConvoScreen:new {
	id = "convo_start_2",
	customDialogText = "We need his Inquisitorial Transit Warrant. It identifies the ship and gives Lance an intercept. Bring me the current copy and I'll send you to stop the Inquisitor before the handoff.",
	stopConversation = "false",
	options = {
		{"I'll look for the document.", "quest_start"},
		{"@conversation/corvette_pashna_rebel1:s_436d636d","convo_exit_3"},--That sounds like a problem. I wish I could help, but really I don't care.
	}
}
corvettePashnaConvoTemplate:addScreen(convo_start_2);

convo_exit = ConvoScreen:new {
	id = "convo_exit",
	leftDialog = "@conversation/corvette_pashna_rebel1:s_fe450b8a",--It probably is best that you go. I must concentrate on the tasks at hand.
	stopConversation = "true",
	options = {	}
}
corvettePashnaConvoTemplate:addScreen(convo_exit);

convo_exit_2 = ConvoScreen:new {
	id = "convo_exit_2",
	leftDialog = "@conversation/corvette_pashna_rebel1:s_7384b0d4",--I see. Such apathy is what holds our efforts back from true success. But then, I suppose the idea of assassinating another person can be difficult to accept. I understand your reservations.
	stopConversation = "true",
	options = {	}
}
corvettePashnaConvoTemplate:addScreen(convo_exit_2);

convo_exit_3 = ConvoScreen:new {
	id = "convo_exit_3",
	leftDialog = "@conversation/corvette_pashna_rebel1:s_8f4b486e",--Indeed. Hopefully, someone will come along to help us with the situation.
	stopConversation = "true",
	options = {	}
}
corvettePashnaConvoTemplate:addScreen(convo_exit_3);

quest_start = ConvoScreen:new {
	id = "quest_start",
	customDialogText = "I have three leads for the Inquisitorial Transit Warrant. Bring me the current copy and I'll clear you for boarding. Which lead do you want first?",
	stopConversation = "false",
	options = {}
}
corvettePashnaConvoTemplate:addScreen(quest_start);

which_planet = ConvoScreen:new {
	id = "which_planet",
	customDialogText = "Which lead for the Inquisitorial Transit Warrant should I go over again?",
	stopConversation = "false",
	options = {}
}
corvettePashnaConvoTemplate:addScreen(which_planet);

first_location = ConvoScreen:new {
	id = "first_location",
	customDialogText = "At Fort Tusken on Tatooine (-3967, 6240), the Inquisitor's advance party withdrew under fire. Search the dispatch case they left inside the fort.",
	stopConversation = "false",
	options = {}
}
corvettePashnaConvoTemplate:addScreen(first_location);

second_location = ConvoScreen:new {
	id = "second_location",
	customDialogText = "The Nyax cult took a courier's satchel after ambushing a patrol on Corellia. Search their cache of seized gear in the bunker (1366, -340).",
	stopConversation = "false",
	options = {}
}
corvettePashnaConvoTemplate:addScreen(second_location);

third_location = ConvoScreen:new {
	id = "third_location",
	customDialogText = "The Geonosian laboratory on Yavin IV (-6449, -401) transferred confiscated effects to the Inquisitor. Search its outbound transfer records for the warrant.",
	stopConversation = "false",
	options = {}
}
corvettePashnaConvoTemplate:addScreen(third_location);

go_get_intel = ConvoScreen:new {
	id = "go_get_intel",
	leftDialog = "@conversation/corvette_pashna_rebel1:s_49437190",--My nerves have been eased. Please hurry and return safely.
	stopConversation = "true",
	options = {}
}
corvettePashnaConvoTemplate:addScreen(go_get_intel);

hear_locations_quit = ConvoScreen:new {
	id = "hear_locations_quit",
	leftDialog = "@conversation/corvette_pashna_rebel1:s_cc2ec42b", --I am disappointed. However, I wish you well on your endeavors.
	stopConversation = "true",
	options = {}
}
corvettePashnaConvoTemplate:addScreen(hear_locations_quit);

back_already = ConvoScreen:new {
	id = "back_already",
	leftDialog = "@conversation/corvette_pashna_rebel1:s_c26ad0e8", --You have returned! I am glad to see you well. Have you found the documents I sent you out to retrieve?
	stopConversation = "false",
	options = {	}
}
corvettePashnaConvoTemplate:addScreen(back_already);

back_already_reset = ConvoScreen:new {
	id = "back_already_reset",
	leftDialog = "@conversation/corvette_pashna_rebel1:s_29542d1b", -- That is very unfortunate to hear. I hope to find someone else to help us. I'll have to take all mission related documents from you. I'm sure you understand, of course.
	stopConversation = "true",
	options = { }
}
corvettePashnaConvoTemplate:addScreen(back_already_reset);

has_intel = ConvoScreen:new {
	id = "has_intel",
	leftDialog = "@conversation/corvette_pashna_rebel1:s_9463a903", --You found the documents?
	stopConversation = "false",
	options = {}
}
corvettePashnaConvoTemplate:addScreen(has_intel);

bad_intel_1 = ConvoScreen:new {
	id = "bad_intel_1",
	customDialogText = "This copy was superseded before the ship left. I'll pay you for the lead. Keep looking for the current one.",
	stopConversation = "false",
	options = {	}
}
corvettePashnaConvoTemplate:addScreen(bad_intel_1);

bad_intel_2 = ConvoScreen:new {
	id = "bad_intel_2",
	customDialogText = "This belongs to the operation, but it won't get you aboard. I'll pay you for bringing it in.",
	stopConversation = "false",
	options = {}
}
corvettePashnaConvoTemplate:addScreen(bad_intel_2);

check_other_places = ConvoScreen:new {
	id = "check_other_places",
	leftDialog = "@conversation/corvette_pashna_rebel1:s_697542b9", --Indeed. Try to find those documents as quickly as possible.
	stopConversation = "true",
	options = {}
}

corvettePashnaConvoTemplate:addScreen(check_other_places);

other_documents = ConvoScreen:new {
	id = "other_documents",
	leftDialog = "@conversation/corvette_pashna_rebel1:s_3bd032cd", --I see. Which documents do you have for me?
	stopConversation = "false",
	options = {}
}
corvettePashnaConvoTemplate:addScreen(other_documents);

good_intel = ConvoScreen:new {
	id = "good_intel",
	customDialogText = "This warrant is current. Take the crew authorization to Lance at Tyrena Starport on Corellia. Board the ship, stop the Inquisitor and get out.",
	stopConversation = "false",
	options = {	}
}
corvettePashnaConvoTemplate:addScreen(good_intel);

go_to_corvette = ConvoScreen:new {
	id = "go_to_corvette",
	customDialogText = "Bring the crew authorization to Lance at Tyrena Starport on Corellia. Find him seated in the second ticket room. Bring your whole crew.",
	stopConversation = "true",
	options = {}
}
corvettePashnaConvoTemplate:addScreen(go_to_corvette);

still_here = ConvoScreen:new {
	id = "still_here",
	leftDialog = "@conversation/corvette_pashna_rebel1:s_2f662226",--I see that you have returned. But why? My concern for our mission grows more by the day.
	stopConversation = "false",
	options = {}
}
corvettePashnaConvoTemplate:addScreen(still_here);

still_here_decline = ConvoScreen:new {
	id = "still_here_decline",
	leftDialog = "@conversation/corvette_pashna_rebel1:s_2d18a202", --Are you sure? I'll have to erase all progress you've made, take all remaining documents you've found, and revoke the travel authorization.
	stopConversation = "false",
	options = {
		{"@conversation/corvette_pashna_rebel1:s_ffef947e","decline_quest_reset"},--Go ahead. I still quit.
		{"@conversation/corvette_pashna_rebel1:s_7cd62c6d","changed_mind"},--In that case, I'll still continue.
	}
}
corvettePashnaConvoTemplate:addScreen(still_here_decline);

decline_quest_reset = ConvoScreen:new {
	id = "decline_quest_reset",
	leftDialog = "@conversation/corvette_pashna_rebel1:s_2be3fa16", --I am distressed. I hope to find a replacement.
	stopConversation = "true",
	options = {}
}
corvettePashnaConvoTemplate:addScreen(decline_quest_reset);

changed_mind = ConvoScreen:new {
	id = "changed_mind",
	leftDialog = "@conversation/corvette_pashna_rebel1:s_eccf8e31", -- Good. Return to your duties, soldier.
	stopConversation = "true",
	options = {}
}
corvettePashnaConvoTemplate:addScreen(changed_mind);

launch_location = ConvoScreen:new {
	id = "launch_location",
	customDialogText = "Bring the crew authorization to Lance at Tyrena Starport on Corellia. Find him seated in the second ticket room. Bring your whole crew.",
	stopConversation = "true",
	options = {}
}
corvettePashnaConvoTemplate:addScreen(launch_location);

reward = ConvoScreen:new {
	id = "reward",
	customDialogText = "The families are moving to new safehouses. What you did bought them the time. You've earned your payment.",
	stopConversation = "false",
	options = {
		{"I'll take the payment.", "give_reward"},
		{"@conversation/corvette_pashna_rebel1:s_615637f6","reward_notyet"} --No, not yet. Maybe later.
	}
}
corvettePashnaConvoTemplate:addScreen(reward);

reward_notyet = ConvoScreen:new {
	id = "reward_notyet",
	leftDialog = "@conversation/corvette_pashna_rebel1:s_8a5c56ae", --Whenever you're ready, let me know.
	stopConversation = "true",
	options = {}
}
corvettePashnaConvoTemplate:addScreen(reward_notyet);

give_reward = ConvoScreen:new {
	id = "give_reward",
	leftDialog = "@conversation/corvette_pashna_rebel1:s_5b812563", --Thank you again. Without your help, there would have been no end to the havoc that Imperial monster would have sown. Well done.
	stopConversation = "true",
	options = {}
}
corvettePashnaConvoTemplate:addScreen(give_reward);

cant_give_reward = ConvoScreen:new {
	id = "cant_give_reward",
	leftDialog = "@conversation/corvette_pashna_rebel1:s_2a4d0c46", --You reward is richly deserved, but you seem to have no room for it. Please clear some space and then speak with me again.
	stopConversation = "true",
	options = {}
}
corvettePashnaConvoTemplate:addScreen(cant_give_reward);

addConversationTemplate("corvettePashnaConvoTemplate", corvettePashnaConvoTemplate);

