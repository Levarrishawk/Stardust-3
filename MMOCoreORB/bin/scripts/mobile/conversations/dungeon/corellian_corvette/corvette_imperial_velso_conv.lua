corvetteVelsoConvoTemplate = ConvoTemplate:new {
	initialScreen = "",
	templateType = "Lua",
	luaClassHandler = "ticketGiverVelsoConvoHandler",
	screens = {}
}

no_faction = ConvoScreen:new {
	id = "no_faction",
	leftDialog = "@conversation/corvette_velso_imperial_destroy:s_cc45dddf", --I do not have time to chat, citizen. Please move along.
	stopConversation = "true",
	options = {}
}
corvetteVelsoConvoTemplate:addScreen(no_faction);

already_busy = ConvoScreen:new {
	id = "already_busy",
	leftDialog = "@conversation/corvette_velso_imperial_destroy:s_3d6658e8",--Soldier, I appreciate your enthusiasm, but I can see that you're already busy. Come back when you've finished your current task, and I'll get you back into the action.
	stopConversation = "true",
	options = {}
}
corvetteVelsoConvoTemplate:addScreen(already_busy);

convo_start = ConvoScreen:new {
	id = "convo_start",
	customDialogText = "A corvette listed as a medical ship is carrying weapons to an armed cell. They're preparing to break an Imperial blockade. Shooting a registered medical ship would invite a hearing. You're going aboard to make sure we never have to attend one.",
	stopConversation = "false",
	options = {
		{"I'll look for the document.", "quest_start"},
		{"@conversation/corvette_velso_imperial_destroy:s_823dca3f","convo_exit"} --Sorry, too busy right now.
	}
}
corvetteVelsoConvoTemplate:addScreen(convo_start);

quest_start = ConvoScreen:new {
	id = "quest_start",
	customDialogText = "I have three leads for the Drive Service Packet. Bring me the current copy and I'll clear you for boarding. Which lead do you want first?",
	stopConversation = "false",
	options = {}
}
corvetteVelsoConvoTemplate:addScreen(quest_start);

convo_exit = ConvoScreen:new {
	id = "convo_exit",
	leftDialog = "@conversation/corvette_velso_imperial_destroy:s_27825c70", -- What?! That wasn't a question! Fine, I can't let this mission be handled by someone like you anyway, get out of here!
	stopConversation = "true",
	options = {}
}
corvetteVelsoConvoTemplate:addScreen(convo_exit);

which_planet = ConvoScreen:new {
	id = "which_planet",
	customDialogText = "Which lead for the Drive Service Packet should I go over again?",
	stopConversation = "false",
	options = {}
}
corvetteVelsoConvoTemplate:addScreen(which_planet);

first_location = ConvoScreen:new {
	id = "first_location",
	customDialogText = "Erran Sif dealt with the ship's engineer. Search the old service records in her bunker on Talus (2147, -5632).",
	stopConversation = "false",
	options = { }
}
corvetteVelsoConvoTemplate:addScreen(first_location);

second_location = ConvoScreen:new {
	id = "second_location",
	customDialogText = "The Afarathu seized a shipment of spares intended for the corvette. Search their storage chamber on Corellia (-2523, 2927) for the engineer's paperwork.",
	stopConversation = "false",
	options = {}
}
corvetteVelsoConvoTemplate:addScreen(second_location);

third_location = ConvoScreen:new {
	id = "third_location",
	customDialogText = "The crew cached spare components in the Janta cave on Dantooine (7106, -4093) to wait out an inspection. Search the cache for the service packet.",
	stopConversation = "false",
	options = {}
}
corvetteVelsoConvoTemplate:addScreen(third_location);

go_get_intel = ConvoScreen:new {
	id = "go_get_intel",
	leftDialog = "@conversation/corvette_velso_imperial_destroy:s_160e282",--Excellent, don't disappoint me soldier! Time is of the essence here. You can choose to return whenever you find something so that we can check the information as you find it. Or get them all at once, that's fine as well. Just make it quick. Dismissed!
	stopConversation = "true",
	options = {}
}
corvetteVelsoConvoTemplate:addScreen(go_get_intel);

hear_locations_quit = ConvoScreen:new {
	id = "hear_locations_quit",
	leftDialog = "@conversation/corvette_velso_imperial_destroy:s_d521e0c0", --Tea?! Get out of here soldier, you're lucky I'm not incarcerating you! Wait... first give me 50, now!
	stopConversation = "true",
	options = {}
}
corvetteVelsoConvoTemplate:addScreen(hear_locations_quit);

back_already = ConvoScreen:new {
	id = "back_already",
	leftDialog = "@conversation/corvette_velso_imperial_destroy:s_ce1a4a29", --Speak soldier, what are you doing here?!
	stopConversation = "false",
	options = {	}
}
corvetteVelsoConvoTemplate:addScreen(back_already);

back_already_reset = ConvoScreen:new {
	id = "back_already_reset",
	leftDialog = "@conversation/corvette_velso_imperial_destroy:s_640dac0a", -- What?! You are a disgrace soldier! I will have your name sent to the inquisition for this! You will be relieved of all mission data and any documents you've gathered. You disgust me. Get out of my sight!
	stopConversation = "true",
	options = { }
}
corvetteVelsoConvoTemplate:addScreen(back_already_reset);

has_intel = ConvoScreen:new {
	id = "has_intel",
	leftDialog = "@conversation/corvette_velso_imperial_destroy:s_52d6b1d", --Show it to me.
	stopConversation = "false",
	options = {}
}
corvetteVelsoConvoTemplate:addScreen(has_intel);

bad_intel_1 = ConvoScreen:new {
	id = "bad_intel_1",
	customDialogText = "This copy was superseded before the ship left. I'll pay you for the lead. Keep looking for the current one.",
	stopConversation = "false",
	options = {}
}
corvetteVelsoConvoTemplate:addScreen(bad_intel_1);

bad_intel_2 = ConvoScreen:new {
	id = "bad_intel_2",
	customDialogText = "This belongs to the operation, but it won't get you aboard. I'll pay you for bringing it in.",
	stopConversation = "false",
	options = {}
}
corvetteVelsoConvoTemplate:addScreen(bad_intel_2);

check_other_places = ConvoScreen:new {
	id = "check_other_places",
	leftDialog = "@conversation/corvette_velso_imperial_destroy:s_9ddd4bc7", --Why are you still here?! Go, go, go!
	stopConversation = "true",
	options = {}
}
corvetteVelsoConvoTemplate:addScreen(check_other_places);

other_documents = ConvoScreen:new {
	id = "other_documents",
	leftDialog = "@conversation/corvette_velso_imperial_destroy:s_65cd8f5e", --Fine, let me have a look.
	stopConversation = "false",
	options = { }
}
corvetteVelsoConvoTemplate:addScreen(other_documents);

good_intel = ConvoScreen:new {
	id = "good_intel",
	customDialogText = "This packet has the transponder and the drive overrides. DS-297 will fly you out from the Emperor's Retreat on Naboo. Destroy the drive from inside the ship and get yourself out.",
	stopConversation = "false",
	options = {}
}
corvetteVelsoConvoTemplate:addScreen(good_intel);

go_to_corvette = ConvoScreen:new {
	id = "go_to_corvette",
	customDialogText = "Present your authorization to DS-297 at the Emperor's Retreat on Naboo. Assemble your team before you speak to the pilot.",
	stopConversation = "true",
	options = {}
}
corvetteVelsoConvoTemplate:addScreen(go_to_corvette);

still_here = ConvoScreen:new {
	id = "still_here",
	leftDialog = "@conversation/corvette_velso_imperial_destroy:s_105e0ec6",--Why are you still here soldier?! Did you forget your weapon or are you just trying to upset me?!
	stopConversation = "false",
	options = {}
}
corvetteVelsoConvoTemplate:addScreen(still_here);

still_here_decline = ConvoScreen:new {
	id = "still_here_decline",
	leftDialog = "@conversation/corvette_velso_imperial_destroy:s_5b578f0d", --What?! You are a disgrace soldier! I will have your name sent to the inquisition for this! This will mean having to revoke your travel authorization and relieving you of all mission data and any documents you've gathered. And that means paperwork. I hate paperwork. So instead, you'll stay on this mission. Now get on that shuttle!
	stopConversation = "false",
	options = {
		{"@conversation/corvette_velso_imperial_destroy:s_31c5707e","decline_quest_reset"},--I..I'm sorry Sir, I can't do it.
		{"@conversation/corvette_velso_imperial_destroy:s_b99cf73b","changed_mind"},--Okay, okay Sir. I'll do it.
	}
}
corvetteVelsoConvoTemplate:addScreen(still_here_decline);

decline_quest_reset = ConvoScreen:new {
	id = "decline_quest_reset",
	leftDialog = "@conversation/corvette_velso_imperial_destroy:s_f0bafd8b", --You will wish our paths never crossed when I'm done with you. Now get out of my sight!
	stopConversation = "true",
	options = {}
}
corvetteVelsoConvoTemplate:addScreen(decline_quest_reset);

changed_mind = ConvoScreen:new {
	id = "changed_mind",
	leftDialog = "@conversation/corvette_velso_imperial_destroy:s_8d72ccd0", -- You better! Now get on that shuttle and do your duty soldier!
	stopConversation = "true",
	options = {}
}
corvetteVelsoConvoTemplate:addScreen(changed_mind);

launch_location = ConvoScreen:new {
	id = "launch_location",
	customDialogText = "Present your authorization to DS-297 at the Emperor's Retreat on Naboo. Assemble your team before you speak to the pilot.",
	stopConversation = "true",
	options = {}
}
corvetteVelsoConvoTemplate:addScreen(launch_location);

reward = ConvoScreen:new {
	id = "reward",
	customDialogText = "The registry now shows a mechanical failure. If anyone asks, you read it there. Here's your payment.",
	stopConversation = "false",
	options = {
		{"I'll take the payment.", "give_reward"},
		{"@conversation/corvette_velso_imperial_destroy:s_5aca4872","reward_notyet"} --Um... I think I'll come back later.
	}
}
corvetteVelsoConvoTemplate:addScreen(reward);

reward_notyet = ConvoScreen:new {
	id = "reward_notyet",
	leftDialog = "@conversation/corvette_velso_imperial_destroy:s_fc34951f", --Later? You should take what you can get. Might not be a later.Guess that's when you'll be a good soldier too. Later. Or more likely never.
	stopConversation = "true",
	options = {}
}
corvetteVelsoConvoTemplate:addScreen(reward_notyet);

give_reward = ConvoScreen:new {
	id = "give_reward",
	leftDialog = "@conversation/corvette_velso_imperial_destroy:s_2b546273", --Here's your reward, soldier. Take it. You earned it... I won't deny that.
	stopConversation = "true",
	options = {}
}
corvetteVelsoConvoTemplate:addScreen(give_reward);

cant_give_reward = ConvoScreen:new {
	id = "cant_give_reward",
	customDialogText = "Your inventory is full. Make room for the payment and come back.",
	stopConversation = "true",
	options = {}
}
corvetteVelsoConvoTemplate:addScreen(cant_give_reward);

addConversationTemplate("corvetteVelsoConvoTemplate", corvetteVelsoConvoTemplate);

