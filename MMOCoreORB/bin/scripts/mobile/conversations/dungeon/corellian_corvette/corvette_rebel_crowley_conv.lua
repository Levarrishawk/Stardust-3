corvetteCrowleyConvoTemplate = ConvoTemplate:new {
	initialScreen = "",
	templateType = "Lua",
	luaClassHandler = "ticketGiverCrowleyConvoHandler",
	screens = {}
}

no_faction = ConvoScreen:new {
	id = "no_faction",
	customDialogText = "This is dock business. If you need freight work, ask at the port.",
	stopConversation = "true",
	options = {}
}
corvetteCrowleyConvoTemplate:addScreen(no_faction);

already_busy = ConvoScreen:new {
	id = "already_busy",
	leftDialog = "@conversation/corvette_crowley_rebel1:s_2c449c28",--I suppose I could use your help, but I see that you're already busy. Come back when you've finished your current task and maybe you can still help.
	stopConversation = "true",
	options = {}
}
corvetteCrowleyConvoTemplate:addScreen(already_busy);

convo_start = ConvoScreen:new {
	id = "convo_start",
	customDialogText = "The Empire is going to crash an impounded corvette into a Corellian repair yard at shift change. They've already drafted a statement blaming the dockworkers. My people are on that shift.",
	stopConversation = "false",
	options = {
		{"I'll look for the document.", "quest_start"},
		{"@conversation/corvette_crowley_rebel1:s_df8ea53","convo_exit"} --Not interested.
	}
}
corvetteCrowleyConvoTemplate:addScreen(convo_start);

quest_start = ConvoScreen:new {
	id = "quest_start",
	customDialogText = "I have three leads for the Impound Flight Order. Bring me the current copy and I'll clear you for boarding. Which lead do you want first?",
	stopConversation = "false",
	options = {	}
}
corvetteCrowleyConvoTemplate:addScreen(quest_start);

convo_exit = ConvoScreen:new {
	id = "convo_exit",
	leftDialog = "@conversation/corvette_crowley_rebel1:s_f26df06d", -- I'm sorry to hear that. Very well, we'll continue on without you.
	stopConversation = "true",
	options = {}
}
corvetteCrowleyConvoTemplate:addScreen(convo_exit);

which_planet = ConvoScreen:new {
	id = "which_planet",
	customDialogText = "Which lead for the Impound Flight Order should I go over again?",
	stopConversation = "false",
	options = {}
}
corvetteCrowleyConvoTemplate:addScreen(which_planet);

first_location = ConvoScreen:new {
	id = "first_location",
	customDialogText = "The Imperial outpost on Lok issued equipment for a so-called navigation trial. Check the outdoor freight crate at (-1891, -3034) for the dispatch packet.",
	stopConversation = "false",
	options = {}
}
corvetteCrowleyConvoTemplate:addScreen(first_location);

second_location = ConvoScreen:new {
	id = "second_location",
	customDialogText = "Former CorSec agents copied the order while looking into the impound. Search their records in the bunker on Corellia (5238, 1600).",
	stopConversation = "false",
	options = {}
}
corvetteCrowleyConvoTemplate:addScreen(second_location);

third_location = ConvoScreen:new {
	id = "third_location",
	customDialogText = "The original crew refused to sign off on the flight and wound up in prison. Search the custody shed on Dathomir (-6309, 752) for the order filed with their case.",
	stopConversation = "false",
	options = {	}
}
corvetteCrowleyConvoTemplate:addScreen(third_location);

go_get_intel = ConvoScreen:new {
	id = "go_get_intel",
	leftDialog = "@conversation/corvette_crowley_rebel1:s_71aabcdc",--Hope has been uplifted in me by you. Be swift and come back safely with the information we need.
	stopConversation = "true",
	options = {}
}
corvetteCrowleyConvoTemplate:addScreen(go_get_intel);

hear_locations_quit = ConvoScreen:new {
	id = "hear_locations_quit",
	leftDialog = "@conversation/corvette_crowley_rebel1:s_762ce016", --A pity. I am disappointed but will find another to replace you.
	stopConversation = "true",
	options = {}
}
corvetteCrowleyConvoTemplate:addScreen(hear_locations_quit);

back_already = ConvoScreen:new {
	id = "back_already",
	leftDialog = "@conversation/corvette_crowley_rebel1:s_a4965b23", --I see you have returned. Have you found what we're looking for?
	stopConversation = "false",
	options = {}
}
corvetteCrowleyConvoTemplate:addScreen(back_already);

back_already_reset = ConvoScreen:new {
	id = "back_already_reset",
	leftDialog = "@conversation/corvette_crowley_rebel1:s_cb6caf3", -- That is sad news, but I will do so. It will be difficult to replace you. I'll have to retrieve all documents and data gathered for this mission from you. Sorry, but it's required.
	stopConversation = "true",
	options = { }
}
corvetteCrowleyConvoTemplate:addScreen(back_already_reset);

has_intel = ConvoScreen:new {
	id = "has_intel",
	leftDialog = "@conversation/corvette_crowley_rebel1:s_16205aba", --What exactly have you found?
	stopConversation = "false",
	options = {}
}
corvetteCrowleyConvoTemplate:addScreen(has_intel);

bad_intel_1 = ConvoScreen:new {
	id = "bad_intel_1",
	customDialogText = "This copy was superseded before the ship left. I'll pay you for the lead. Keep looking for the current one.",
	stopConversation = "false",
	options = {}
}
corvetteCrowleyConvoTemplate:addScreen(bad_intel_1);

bad_intel_2 = ConvoScreen:new {
	id = "bad_intel_2",
	customDialogText = "This belongs to the operation, but it won't get you aboard. I'll pay you for bringing it in.",
	stopConversation = "false",
	options = {	}
}
corvetteCrowleyConvoTemplate:addScreen(bad_intel_2);

check_other_places = ConvoScreen:new {
	id = "check_other_places",
	leftDialog = "@conversation/corvette_crowley_rebel1:s_da09e61c", --Indeed. You'll need to find the information as quickly as possible.
	stopConversation = "true",
	options = {}
}

corvetteCrowleyConvoTemplate:addScreen(check_other_places);

other_documents = ConvoScreen:new {
	id = "other_documents",
	leftDialog = "@conversation/corvette_crowley_rebel1:s_3bd032cd", --I see. Which documents do you have for me?
	stopConversation = "false",
	options = {	}
}
corvetteCrowleyConvoTemplate:addScreen(other_documents);

good_intel = ConvoScreen:new {
	id = "good_intel",
	customDialogText = "That's the signed flight order. Take the crew authorization to Lance at Tyrena Starport on Corellia. Take the drive out before it reaches the yard, then get to an escape pod.",
	stopConversation = "false",
	options = { }
}
corvetteCrowleyConvoTemplate:addScreen(good_intel);

go_to_corvette = ConvoScreen:new {
	id = "go_to_corvette",
	customDialogText = "Bring the crew authorization to Lance at Tyrena Starport on Corellia. Find him seated in the second ticket room. Bring your whole crew.",
	stopConversation = "true",
	options = {}
}
corvetteCrowleyConvoTemplate:addScreen(go_to_corvette);

still_here = ConvoScreen:new {
	id = "still_here",
	leftDialog = "@conversation/corvette_crowley_rebel1:s_bcc53c45",--I am surprised to see you here. Are you in need of more information?
	stopConversation = "false",
	options = {	}
}
corvetteCrowleyConvoTemplate:addScreen(still_here);

still_here_decline = ConvoScreen:new {
	id = "still_here_decline",
	leftDialog = "@conversation/corvette_crowley_rebel1:s_fb051f63", --Are you certain? Very well. But your progress will be erased, any remaining documents will be confiscated, and the travel authorization will be revoked. If you change you mind and decide to try again, you'll have to start from the beginning.
	stopConversation = "false",
	options = {
		{"@conversation/corvette_crowley_rebel1:s_b4b735ef","decline_quest_reset"},--That's okay. I cannot continue.
		{"@conversation/corvette_crowley_rebel1:s_b6a784f4","changed_mind"},--Er... maybe I'll do it. Or at least think about it.
	}
}
corvetteCrowleyConvoTemplate:addScreen(still_here_decline);

decline_quest_reset = ConvoScreen:new {
	id = "decline_quest_reset",
	leftDialog = "@conversation/corvette_crowley_rebel1:s_c03449c4", --A pity, indeed. You have been released from the mission.
	stopConversation = "true",
	options = {}
}
corvetteCrowleyConvoTemplate:addScreen(decline_quest_reset);

changed_mind = ConvoScreen:new {
	id = "changed_mind",
	leftDialog = "@conversation/corvette_crowley_rebel1:s_1b28b4c", -- There is hope yet. Good luck on your mission.
	stopConversation = "true",
	options = {}
}
corvetteCrowleyConvoTemplate:addScreen(changed_mind);

launch_location = ConvoScreen:new {
	id = "launch_location",
	customDialogText = "Bring the crew authorization to Lance at Tyrena Starport on Corellia. Find him seated in the second ticket room. Bring your whole crew.",
	stopConversation = "true",
	options = {}
}
corvetteCrowleyConvoTemplate:addScreen(launch_location);

reward = ConvoScreen:new {
	id = "reward",
	customDialogText = "The repair yard is still standing. The crews made it home. Here, take what we put together for you.",
	stopConversation = "false",
	options = {
		{"I'll take the payment.", "give_reward"},
		{"@conversation/corvette_crowley_rebel1:s_823e1fa","reward_notyet"} --No, I'm not yet ready for it.
	}
}
corvetteCrowleyConvoTemplate:addScreen(reward);

reward_notyet = ConvoScreen:new {
	id = "reward_notyet",
	leftDialog = "@conversation/corvette_crowley_rebel1:s_a539245b", --I see. Well, whenever you're ready, just come talk to me.
	stopConversation = "true",
	options = {}
}
corvetteCrowleyConvoTemplate:addScreen(reward_notyet);

give_reward = ConvoScreen:new {
	id = "give_reward",
	leftDialog = "@conversation/corvette_crowley_rebel1:s_44a0326c", --It is a pleasure to reward you for such a triumphant mission.
	stopConversation = "true",
	options = {}
}
corvetteCrowleyConvoTemplate:addScreen(give_reward);

cant_give_reward = ConvoScreen:new {
	id = "cant_give_reward",
	leftDialog = "@conversation/corvette_crowley_rebel1:s_d3c9d7bc", --Um... while I'd like nothing more than to give you your reward, you do not have room for it at the moment. Please make some space and then talk to me again.
	stopConversation = "true",
	options = {}
}
corvetteCrowleyConvoTemplate:addScreen(cant_give_reward);

addConversationTemplate("corvetteCrowleyConvoTemplate", corvetteCrowleyConvoTemplate);

