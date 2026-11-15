corvetteDarkstoneConvoTemplate = ConvoTemplate:new {
	initialScreen = "",
	templateType = "Lua",
	luaClassHandler = "ticketGiverDarkstoneConvoHandler",
	screens = {}
}

no_faction = ConvoScreen:new {
	id = "no_faction",
	leftDialog = "@conversation/corvette_colonel_imperial1:s_684f9e1", --I cannot help you, citizen. Please try elsewhere.
	stopConversation = "true",
	options = {}
}
corvetteDarkstoneConvoTemplate:addScreen(no_faction);

already_busy = ConvoScreen:new {
	id = "already_busy",
	leftDialog = "@conversation/corvette_colonel_imperial1:s_33f4749f",--Ah, not now. I could use your help, but I see that you're already busy. Come back when you've finished your current task and maybe I'll have something for you.
	stopConversation = "true",
	options = {}
}
corvetteDarkstoneConvoTemplate:addScreen(already_busy);

convo_start = ConvoScreen:new {
	id = "convo_start",
	leftDialog = "@conversation/corvette_colonel_imperial1:s_d630c3b6",--I am nearing the end of my days serving as the main point of contact in regards to Imperial officers who find themselves in a hostage situation. Every mission is important. As possibly my last, this one proves to be most difficult.
	stopConversation = "false",
	options = {
		{"Tell me more.", "convo_start_1"},
		{"@conversation/corvette_colonel_imperial1:s_5200ce80","convo_exit"},--I'm not interested. Good-bye.
	}
}
corvetteDarkstoneConvoTemplate:addScreen(convo_start);

convo_start_1 = ConvoScreen:new {
	id = "convo_start_1",
	customDialogText = "An insurgent cell abducted Dr. Bledsoe. He signed quarantine orders under which several civilians were detained. His captors mean to put him before witnesses. Find their Detainee Movement Order and bring him back into Imperial custody.",
	stopConversation = "false",
	options = {
		{"I'll look for the document.", "quest_start"},
		{"@conversation/corvette_colonel_imperial1:s_157ef5eb","convo_exit"} --I... don't like this at all. I'll have to pass.
	}
}
corvetteDarkstoneConvoTemplate:addScreen(convo_start_1);

convo_exit = ConvoScreen:new {
	id = "convo_exit",
	leftDialog = "@conversation/corvette_colonel_imperial1:s_28586fd5",--Very well.
	stopConversation = "true",
	options = {}
}
corvetteDarkstoneConvoTemplate:addScreen(convo_exit);

quest_start = ConvoScreen:new {
	id = "quest_start",
	customDialogText = "I have three leads for the Detainee Movement Order. Bring me the current copy and I'll clear you for boarding. Which lead do you want first?",
	stopConversation = "false",
	options = {}
}
corvetteDarkstoneConvoTemplate:addScreen(quest_start);

which_planet = ConvoScreen:new {
	id = "which_planet",
	customDialogText = "Which lead for the Detainee Movement Order should I go over again?",
	stopConversation = "false",
	options = {}
}
corvetteDarkstoneConvoTemplate:addScreen(which_planet);

first_location = ConvoScreen:new {
	id = "first_location",
	customDialogText = "A runner used the Woolamander Temple on Yavin IV (549, -622) as a blind drop. Search the sealed dispatch cache inside the ruins.",
	stopConversation = "false",
	options = { }
}
corvetteDarkstoneConvoTemplate:addScreen(first_location);

second_location = ConvoScreen:new {
	id = "second_location",
	customDialogText = "A runner lost a field pack outside the Mokk stronghold on Dantooine (-7065, -3326). Search the outdoor cache on the approach.",
	stopConversation = "false",
	options = {}
}
corvetteDarkstoneConvoTemplate:addScreen(second_location);

third_location = ConvoScreen:new {
	id = "third_location",
	customDialogText = "A repair broker sold the kidnappers a transponder and kept their shipping instructions as collateral. Search the workshop in the Droid Engineer Cave on Lok (3302, -4890).",
	stopConversation = "false",
	options = {}
}
corvetteDarkstoneConvoTemplate:addScreen(third_location);

go_get_intel = ConvoScreen:new {
	id = "go_get_intel",
	leftDialog = "@conversation/corvette_colonel_imperial1:s_bd942cc0",--Excellent. Good luck to you.
	stopConversation = "true",
	options = {}
}
corvetteDarkstoneConvoTemplate:addScreen(go_get_intel);

hear_locations_quit = ConvoScreen:new {
	id = "hear_locations_quit",
	leftDialog = "@conversation/corvette_colonel_imperial1:s_74edd9cc", --And that is your choice. I am disappointed..
	stopConversation = "true",
	options = {}
}
corvetteDarkstoneConvoTemplate:addScreen(hear_locations_quit);

back_already = ConvoScreen:new {
	id = "back_already",
	leftDialog = "@conversation/corvette_colonel_imperial1:s_18d01770", --You have returned. I am glad to see you are still well. What have you discovered? Do you have any documents? Or do you need information?
	stopConversation = "false",
	options = {}
}
corvetteDarkstoneConvoTemplate:addScreen(back_already);

back_already_reset = ConvoScreen:new {
	id = "back_already_reset",
	leftDialog = "@conversation/corvette_colonel_imperial1:s_bcecb501", --Very well. You have been released from this mission. You understand that I must remove from you all documents and data connected to this mission. Stand operating procedure.
	stopConversation = "true",
	options = {}
}
corvetteDarkstoneConvoTemplate:addScreen(back_already_reset);

has_intel = ConvoScreen:new {
	id = "has_intel",
	leftDialog = "@conversation/corvette_colonel_imperial1:s_3c50285d", -- Excellent! What have you found on your mission?
	stopConversation = "false",
	options = {}
}
corvetteDarkstoneConvoTemplate:addScreen(has_intel);

bad_intel_1 = ConvoScreen:new {
	id = "bad_intel_1",
	customDialogText = "This copy was superseded before the ship left. I'll pay you for the lead. Keep looking for the current one.",
	stopConversation = "false",
	options = {}
}
corvetteDarkstoneConvoTemplate:addScreen(bad_intel_1);

bad_intel_2 = ConvoScreen:new {
	id = "bad_intel_2",
	customDialogText = "This belongs to the operation, but it won't get you aboard. I'll pay you for bringing it in.",
	stopConversation = "false",
	options = {}
}
corvetteDarkstoneConvoTemplate:addScreen(bad_intel_2);

check_other_places = ConvoScreen:new {
	id = "check_other_places",
	leftDialog = "@conversation/corvette_colonel_imperial1:s_33656cd3", --Indeed. I need those documents as soon as possible. Please find them quickly.
	stopConversation = "true",
	options = {}
}

corvetteDarkstoneConvoTemplate:addScreen(check_other_places);

other_documents = ConvoScreen:new {
	id = "other_documents",
	leftDialog = "@conversation/corvette_colonel_imperial1:s_ffa3808c", --Oh, show me the ones you still have.
	stopConversation = "false",
	options = { }
}
corvetteDarkstoneConvoTemplate:addScreen(other_documents);

good_intel = ConvoScreen:new {
	id = "good_intel",
	customDialogText = "We have the handoff coordinates. Take the authorization to DS-297 at the Emperor's Retreat on Naboo. Bring Bledsoe to extraction. Imperial Security will take custody from there.",
	stopConversation = "false",
	options = {}
}
corvetteDarkstoneConvoTemplate:addScreen(good_intel);

go_to_corvette = ConvoScreen:new {
	id = "go_to_corvette",
	customDialogText = "Present your authorization to DS-297 at the Emperor's Retreat on Naboo. Assemble your team before you speak to the pilot.",
	stopConversation = "true",
	options = {}
}
corvetteDarkstoneConvoTemplate:addScreen(go_to_corvette);

still_here = ConvoScreen:new {
	id = "still_here",
	leftDialog = "@conversation/corvette_colonel_imperial1:s_5c4b594c",--I see you have returned. Are you in need of additional assistance?
	stopConversation = "false",
	options = {	}
}
corvetteDarkstoneConvoTemplate:addScreen(still_here);

still_here_decline = ConvoScreen:new {
	id = "still_here_decline",
	leftDialog = "@conversation/corvette_colonel_imperial1:s_80d92f17", --Are you sure? Your progress will be erased from our database, all remaining documents will be taken from you, and the travel authorization will be revoked.
	stopConversation = "false",
	options = {
		{"@conversation/corvette_colonel_imperial1:s_dd109d64","decline_quest_reset"},--That's fine. I resign.
		{"@conversation/corvette_colonel_imperial1:s_7a2a05c4","changed_mind"},--In that case, I'll continue.
	}
}
corvetteDarkstoneConvoTemplate:addScreen(still_here_decline);

decline_quest_reset = ConvoScreen:new {
	id = "decline_quest_reset",
	leftDialog = "@conversation/corvette_colonel_imperial1:s_180bc00a", --Very well. It is sad to hear.
	stopConversation = "true",
	options = {}
}
corvetteDarkstoneConvoTemplate:addScreen(decline_quest_reset);

changed_mind = ConvoScreen:new {
	id = "changed_mind",
	leftDialog = "@conversation/corvette_colonel_imperial1:s_f769f479", -- I am glad to hear of it.
	stopConversation = "true",
	options = {}
}
corvetteDarkstoneConvoTemplate:addScreen(changed_mind);

launch_location = ConvoScreen:new {
	id = "launch_location",
	customDialogText = "Present your authorization to DS-297 at the Emperor's Retreat on Naboo. Assemble your team before you speak to the pilot.",
	stopConversation = "true",
	options = {}
}
corvetteDarkstoneConvoTemplate:addScreen(launch_location);

reward = ConvoScreen:new {
	id = "reward",
	customDialogText = "Bledsoe is in our custody. The quarantine files have been sealed. Your recovery is on record and your payment is ready.",
	stopConversation = "false",
	options = {
		{"I'll take the payment.", "give_reward"},
		{"@conversation/corvette_colonel_imperial1:s_a38773c1","reward_notyet"} --I'm not sure. Maybe I'll come back later.
	}
}
corvetteDarkstoneConvoTemplate:addScreen(reward);

reward_notyet = ConvoScreen:new {
	id = "reward_notyet",
	leftDialog = "@conversation/corvette_colonel_imperial1:s_dc4a40d6", --Exactly... your reward is serving the Empire. But should you change your mind, simply speak with me again.
	stopConversation = "true",
	options = {}
}
corvetteDarkstoneConvoTemplate:addScreen(reward_notyet);

give_reward = ConvoScreen:new {
	id = "give_reward",
	leftDialog = "@conversation/corvette_colonel_imperial1:s_81ff39a5", --I thought as much. Very well, take it. You did earn this, though I'd hoped the honor of serving the Empire would have been enough.
	stopConversation = "true",
	options = {}
}
corvetteDarkstoneConvoTemplate:addScreen(give_reward);

cant_give_reward = ConvoScreen:new {
	id = "cant_give_reward",
	leftDialog = "@conversation/corvette_colonel_imperial1:s_8e06b4e8", --Ah yes. I would hand it over, as you ask, but you don't have room to carry it. So you'll have to clear some space before you may take it.
	stopConversation = "true",
	options = {}
}
corvetteDarkstoneConvoTemplate:addScreen(cant_give_reward);

addConversationTemplate("corvetteDarkstoneConvoTemplate", corvetteDarkstoneConvoTemplate);

