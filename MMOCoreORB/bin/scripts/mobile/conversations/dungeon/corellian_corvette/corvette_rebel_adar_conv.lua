corvetteTallonConvoTemplate = ConvoTemplate:new {
	initialScreen = "",
	templateType = "Lua",
	luaClassHandler = "ticketGiverTallonConvoHandler",
	screens = {}
}

no_faction = ConvoScreen:new {
	id = "no_faction",
	customDialogText = "I'm waiting for a private courier. If you have relief supplies, the port can tell you where to leave them.",
	stopConversation = "true",
	options = {}
}
corvetteTallonConvoTemplate:addScreen(no_faction);

already_busy = ConvoScreen:new {
	id = "already_busy",
	leftDialog = "@conversation/corvette_tallon_rebel1:s_2dd3860f", -- Ah, you're here, but I see that you're already busy. I could've used your help. Maybe come back when you've finished your current task.
	stopConversation = "true",
	options = {}
}
corvetteTallonConvoTemplate:addScreen(already_busy);

convo_start = ConvoScreen:new {
	id = "convo_start",
	customDialogText = "I used to serve the Republic. These days I help get relief cargo through inspections. Gabriel Ian saw Imperial officers seize civilian shipments and falsify their reports. They're moving him to Dathomir before he can testify. Help me get him out.",
	stopConversation = "false",
	options = {
		{"I'll look for the document.", "quest_start"},
		{"@conversation/corvette_tallon_rebel1:s_df8ea53","convo_exit"} -- Not interested.
	}
}
corvetteTallonConvoTemplate:addScreen(convo_start);

quest_start = ConvoScreen:new {
	id = "quest_start",
	customDialogText = "I have three leads for the Prisoner Transfer Override. Bring me the current copy and I'll clear you for boarding. Which lead do you want first?",
	stopConversation = "false",
	options = {	}
}
corvetteTallonConvoTemplate:addScreen(quest_start);

convo_exit = ConvoScreen:new {
	id = "convo_exit",
	leftDialog = "@conversation/corvette_tallon_rebel1:s_a24d8ba0", -- Your answer troubles me. Return if you change your mind. May the Force be with you.
	stopConversation = "true",
	options = {}
}
corvetteTallonConvoTemplate:addScreen(convo_exit);

which_planet = ConvoScreen:new {
	id = "which_planet",
	customDialogText = "Which lead for the Prisoner Transfer Override should I go over again?",
	stopConversation = "false",
	options = {	}
}
corvetteTallonConvoTemplate:addScreen(which_planet);

first_location = ConvoScreen:new {
	id = "first_location",
	customDialogText = "The Warren on Dantooine (-547, -3846) handled Ian's first detention. Search its records for the override attached to his transfer.",
	stopConversation = "false",
	options = {	}
}
corvetteTallonConvoTemplate:addScreen(first_location);

second_location = ConvoScreen:new {
	id = "second_location",
	customDialogText = "The receiving staff on Dathomir (-6354, 751) requested access credentials for Ian. Search the intake shed for their copy.",
	stopConversation = "false",
	options = {	}
}
corvetteTallonConvoTemplate:addScreen(second_location);

third_location = ConvoScreen:new {
	id = "third_location",
	customDialogText = "The Bloodrazors salvaged a dispatch recorder from a courier pod. Search the warehouse beside the wreck on Lok (3663, 2186).",
	stopConversation = "false",
	options = {	}
}
corvetteTallonConvoTemplate:addScreen(third_location);

go_get_intel = ConvoScreen:new {
	id = "go_get_intel",
	leftDialog = "@conversation/corvette_tallon_rebel1:s_90b2e0c5", --You're our only hope in this situation. You have your orders, soldier.
	stopConversation = "true",
	options = {}
}
corvetteTallonConvoTemplate:addScreen(go_get_intel);

hear_locations_quit = ConvoScreen:new {
	id = "hear_locations_quit",
	leftDialog = "@conversation/corvette_tallon_rebel1:s_93fcbaae", -- Your answer is unfortunate. But it is your choice. May the Force be with you.
	stopConversation = "true",
	options = {}
}
corvetteTallonConvoTemplate:addScreen(hear_locations_quit);

back_already = ConvoScreen:new {
	id = "back_already",
	leftDialog = "@conversation/corvette_tallon_rebel1:s_953e3f2c", --I see you have returned. Have you found the codes I'm looking for? Time is critical.
	stopConversation = "false",
	options = {	}
}
corvetteTallonConvoTemplate:addScreen(back_already);

back_already_reset = ConvoScreen:new {
	id = "back_already_reset",
	leftDialog = "@conversation/corvette_tallon_rebel1:s_abd76541", --I'm sorry to learn of this unexpected turn of events. I suppose I'll have to find someone else. Oh, I'll need to take any documents you've found while on this mission. May the Force be with you.
	stopConversation = "true",
	options = { }
}
corvetteTallonConvoTemplate:addScreen(back_already_reset);

has_intel = ConvoScreen:new {
	id = "has_intel",
	leftDialog = "@conversation/corvette_tallon_rebel1:s_75b09ea1", --Oh? What have you found?
	stopConversation = "false",
	options = {	}
}
corvetteTallonConvoTemplate:addScreen(has_intel);

bad_intel_1 = ConvoScreen:new {
	id = "bad_intel_1",
	customDialogText = "This copy was superseded before the ship left. I'll pay you for the lead. Keep looking for the current one.",
	stopConversation = "false",
	options = {	}
}
corvetteTallonConvoTemplate:addScreen(bad_intel_1);

bad_intel_2 = ConvoScreen:new {
	id = "bad_intel_2",
	customDialogText = "This belongs to the operation, but it won't get you aboard. I'll pay you for bringing it in.",
	stopConversation = "false",
	options = {}
}
corvetteTallonConvoTemplate:addScreen(bad_intel_2);

check_other_places = ConvoScreen:new {
	id = "check_other_places",
	leftDialog = "@conversation/corvette_tallon_rebel1:s_daf0c91a", --Indeed. We need those codes as soon as possible.
	stopConversation = "true",
	options = {}
}

corvetteTallonConvoTemplate:addScreen(check_other_places);

other_documents = ConvoScreen:new {
	id = "other_documents",
	leftDialog = "@conversation/corvette_tallon_rebel1:s_8b512dfa", -- I see. Which ones do you have?
	stopConversation = "false",
	options = {	}
}
corvetteTallonConvoTemplate:addScreen(other_documents);

good_intel = ConvoScreen:new {
	id = "good_intel",
	customDialogText = "This override identifies the corvette and tells us where they're holding Ian. Take this crew authorization to Lance at Tyrena Starport on Corellia. Get Ian to the extraction point. I've arranged a separate pickup for him.",
	stopConversation = "false",
	options = {	}
}
corvetteTallonConvoTemplate:addScreen(good_intel);

go_to_corvette = ConvoScreen:new {
	id = "go_to_corvette",
	customDialogText = "Bring the crew authorization to Lance at Tyrena Starport on Corellia. Find him seated in the second ticket room. Bring your whole crew.",
	stopConversation = "true",
	options = {}
}
corvetteTallonConvoTemplate:addScreen(go_to_corvette);

still_here = ConvoScreen:new {
	id = "still_here",
	leftDialog = "@conversation/corvette_tallon_rebel1:s_7860ffca", --I am curious as why you have returned. Is there some sort of problem?
	stopConversation = "false",
	options = {	}
}
corvetteTallonConvoTemplate:addScreen(still_here);

still_here_decline = ConvoScreen:new {
	id = "still_here_decline",
	leftDialog = "@conversation/corvette_tallon_rebel1:s_b0f80f89", -- Are you sure you wish to quit? I will have to revoke the travel authorization. It is for special operatives only. And I'll have to take any remaining documents you may have relating to this mission.
	stopConversation = "false",
	options = {
		{"@conversation/corvette_tallon_rebel1:s_b0da26cf","decline_quest_reset"}, --I'm sure.
		{"@conversation/corvette_tallon_rebel1:s_4440ce87","changed_mind"}, --I changed my mind.
	}
}
corvetteTallonConvoTemplate:addScreen(still_here_decline);

decline_quest_reset = ConvoScreen:new {
	id = "decline_quest_reset",
	leftDialog = "@conversation/corvette_tallon_rebel1:s_303462a1", -- I'm sorry to hear of this. I must find someone else to replace you. Good bye.
	stopConversation = "true",
	options = {}
}
corvetteTallonConvoTemplate:addScreen(decline_quest_reset);

changed_mind = ConvoScreen:new {
	id = "changed_mind",
	leftDialog = "@conversation/corvette_tallon_rebel1:s_d50be1f6", -- Good. Be swift in dealing with this situation.
	stopConversation = "true",
	options = {}
}
corvetteTallonConvoTemplate:addScreen(changed_mind);

launch_location = ConvoScreen:new {
	id = "launch_location",
	customDialogText = "Bring the crew authorization to Lance at Tyrena Starport on Corellia. Find him seated in the second ticket room. Bring your whole crew.",
	stopConversation = "true",
	options = {}
}
corvetteTallonConvoTemplate:addScreen(launch_location);

reward = ConvoScreen:new {
	id = "reward",
	customDialogText = "Ian is safe. He's agreed to put his name to what he saw. I'll see that his testimony reaches people who can act on it.",
	stopConversation = "false",
	options = {
		{"I'll take the payment.", "give_reward"},
		{"@conversation/corvette_tallon_rebel1:s_60bce77f","reward_notyet"} --Reward? Not now. I'll return later.
	}
}
corvetteTallonConvoTemplate:addScreen(reward);

reward_notyet = ConvoScreen:new {
	id = "reward_notyet",
	leftDialog = "@conversation/corvette_tallon_rebel1:s_80747fa2", --  I see. Later it shall be then. Return whenever you are ready.
	stopConversation = "true",
	options = {}
}
corvetteTallonConvoTemplate:addScreen(reward_notyet);

give_reward = ConvoScreen:new {
	id = "give_reward",
	customDialogText = "Take this. It comes from people who know what it costs to speak up.",
	stopConversation = "true",
	options = {}
}
corvetteTallonConvoTemplate:addScreen(give_reward);

cant_give_reward = ConvoScreen:new {
	id = "cant_give_reward",
	leftDialog = "@conversation/corvette_tallon_rebel1:s_5f449362", -- Ah. I'd like to give this reward to you, but you don't have room to carry it. You'll need to make some space and then speak with me again.
	stopConversation = "true",
	options = {}
}
corvetteTallonConvoTemplate:addScreen(cant_give_reward);

addConversationTemplate("corvetteTallonConvoTemplate", corvetteTallonConvoTemplate);

