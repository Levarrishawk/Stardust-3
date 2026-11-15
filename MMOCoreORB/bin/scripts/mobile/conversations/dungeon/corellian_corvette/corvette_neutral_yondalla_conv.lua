corvetteYondallaConvoTemplate = ConvoTemplate:new {
	initialScreen = "",
	templateType = "Lua",
	luaClassHandler = "ticketGiverYondallaConvoHandler",
	screens = {}
}

already_busy = ConvoScreen:new {
	id = "already_busy",
	leftDialog = "@conversation/corvette_yondalla_neutral_rescue:s_310d2ff3", -- Something's come up. I can see that you're busy now, but come talk to me when you finish with that. I could use your help.
	stopConversation = "true",
	options = {}
}
corvetteYondallaConvoTemplate:addScreen(already_busy);

convo_start = ConvoScreen:new {
	id = "convo_start",
	customDialogText = "CorSec caught Imo Vledmo. They're trading him to Imperial Security at Dathomir, and he knows exactly which officials Jabba pays. Find the CorSec Transfer Order so we can board the corvette while he's still on it.",
	stopConversation = "false",
	options = {
		{"I'll look for the document.", "quest_start"},
		{"@conversation/corvette_yondalla_neutral_rescue:s_259d132f","convo_exit"} -- Sorry, no, not me.
	}
}
corvetteYondallaConvoTemplate:addScreen(convo_start);

quest_start = ConvoScreen:new {
	id = "quest_start",
	customDialogText = "I have three leads for the CorSec Transfer Order. Bring me the current copy and I'll clear you for boarding. Which lead do you want first?",
	stopConversation = "false",
	options = {	}
}
corvetteYondallaConvoTemplate:addScreen(quest_start);

convo_exit = ConvoScreen:new {
	id = "convo_exit",
	leftDialog = "@conversation/corvette_yondalla_neutral_rescue:s_839794f9", -- Argh, solving this by myself is going to take forever!
	stopConversation = "true",
	options = {}
}
corvetteYondallaConvoTemplate:addScreen(convo_exit);

which_planet = ConvoScreen:new {
	id = "which_planet",
	customDialogText = "Which lead for the CorSec Transfer Order should I go over again?",
	stopConversation = "false",
	options = {}
}
corvetteYondallaConvoTemplate:addScreen(which_planet);

first_location = ConvoScreen:new {
	id = "first_location",
	customDialogText = "CorSec picked Vledmo up at the Kahmurra research station on Talus (-4821, -4751). Search the security room for the arrest team's copy of his transport paperwork.",
	stopConversation = "false",
	options = {}
}
corvetteYondallaConvoTemplate:addScreen(first_location);

second_location = ConvoScreen:new {
	id = "second_location",
	customDialogText = "The Cobral took a dispatch pouch from a courier carrying the handoff terms. Search their stash on Rori (5446, 5016).",
	stopConversation = "false",
	options = {	}
}
corvetteYondallaConvoTemplate:addScreen(second_location);

third_location = ConvoScreen:new {
	id = "third_location",
	customDialogText = "A smuggler was selling the transfer details and left a copy in the Korga cave on Endor (2244, 3553). Search the smuggler's cache.",
	stopConversation = "false",
	options = {	}
}
corvetteYondallaConvoTemplate:addScreen(third_location);

go_get_intel = ConvoScreen:new {
	id = "go_get_intel",
	leftDialog = "@conversation/corvette_yondalla_neutral_rescue:s_541c41dc", -- Excellent. Make haste and don't disappoint me. Return with one of the documents, or all three at once. It's up to you, as long as you do it fast.
	stopConversation = "true",
	options = {}
}
corvetteYondallaConvoTemplate:addScreen(go_get_intel);

hear_locations_quit = ConvoScreen:new {
	id = "hear_locations_quit",
	leftDialog = "@conversation/corvette_yondalla_neutral_rescue:s_fa7bc000", -- --Bah! Consider yourself fortunate that I haven't time to report your insolence to Jabba!
	stopConversation = "true",
	options = {}
}
corvetteYondallaConvoTemplate:addScreen(hear_locations_quit);

back_already = ConvoScreen:new {
	id = "back_already",
	leftDialog = "@conversation/corvette_yondalla_neutral_rescue:s_e248445b", -- What's your progress?
	stopConversation = "false",
	options = {	}
}
corvetteYondallaConvoTemplate:addScreen(back_already);

back_already_reset = ConvoScreen:new {
	id = "back_already_reset",
	leftDialog = "@conversation/corvette_yondalla_neutral_rescue:s_2b741d06", -- For crying out loud! This is why I always work solo... sigh. I'll take all information you gathered so far. Thank you very little.
	stopConversation = "true",
	options = { }
}
corvetteYondallaConvoTemplate:addScreen(back_already_reset);

has_intel = ConvoScreen:new {
	id = "has_intel",
	leftDialog = "@conversation/corvette_yondalla_neutral_rescue:s_7bf4c415", --  Good, let me see.
	stopConversation = "false",
	options = {}
}
corvetteYondallaConvoTemplate:addScreen(has_intel);

bad_intel_1 = ConvoScreen:new {
	id = "bad_intel_1",
	customDialogText = "This copy was superseded before the ship left. I'll pay you for the lead. Keep looking for the current one.",
	stopConversation = "false",
	options = {}
}
corvetteYondallaConvoTemplate:addScreen(bad_intel_1);

bad_intel_2 = ConvoScreen:new {
	id = "bad_intel_2",
	customDialogText = "This belongs to the operation, but it won't get you aboard. I'll pay you for bringing it in.",
	stopConversation = "false",
	options = {	}
}
corvetteYondallaConvoTemplate:addScreen(bad_intel_2);

check_other_places = ConvoScreen:new {
	id = "check_other_places",
	leftDialog = "@conversation/corvette_yondalla_neutral_rescue:s_fdc18de4", --  Yes and hurry, we're running out of time here!Yes, check the other places and hurry.
	stopConversation = "true",
	options = {}
}
corvetteYondallaConvoTemplate:addScreen(check_other_places);

other_documents = ConvoScreen:new {
	id = "other_documents",
	leftDialog = "@conversation/corvette_yondalla_neutral_rescue:s_c2bb14db", -- Oh, let me have a look at them.
	stopConversation = "false",
	options = {	}
}
corvetteYondallaConvoTemplate:addScreen(other_documents);

good_intel = ConvoScreen:new {
	id = "good_intel",
	customDialogText = "The transfer is still pending. Take this authorization to Klaatu behind Jabba's Palace. He'll put you aboard the cutter. Get Vledmo to extraction before they hand him over.",
	stopConversation = "false",
	options = {	}
}
corvetteYondallaConvoTemplate:addScreen(good_intel);

go_to_corvette = ConvoScreen:new {
	id = "go_to_corvette",
	customDialogText = "Show your authorization to Klaatu behind Jabba's Palace on Tatooine. Gather your crew before you talk to him.",
	stopConversation = "true",
	options = {}
}
corvetteYondallaConvoTemplate:addScreen(go_to_corvette);

still_here = ConvoScreen:new {
	id = "still_here",
	leftDialog = "@conversation/corvette_yondalla_neutral_rescue:s_9fe2c46a", --You still here? Didn't I say that you had to get on that ship fast?
	stopConversation = "false",
	options = {	}
}
corvetteYondallaConvoTemplate:addScreen(still_here);

still_here_decline = ConvoScreen:new {
	id = "still_here_decline",
	leftDialog = "@conversation/corvette_yondalla_neutral_rescue:s_49b0321c", -- What?! I can't, I have something else on my plate right now. I trusted you with this! If you quit, I'll have to revoke your travel authorization and take all mission documents you've gathered. Not to mention erasing all knowledge of your progress so far. That means starting completely over!
	stopConversation = "false",
	options = {
		{"@conversation/corvette_yondalla_neutral_rescue:s_998ee768","decline_quest_reset"}, --I'm sorry, I just can't do this right now.
		{"@conversation/corvette_yondalla_neutral_rescue:s_3e2c6672","changed_mind"}, --  Alright, I suppose I owe it to you.
	}
}
corvetteYondallaConvoTemplate:addScreen(still_here_decline);

decline_quest_reset = ConvoScreen:new {
	id = "decline_quest_reset",
	leftDialog = "@conversation/corvette_yondalla_neutral_rescue:s_54c95fe4", -- I'll be...just get out of here!
	stopConversation = "true",
	options = {}
}
corvetteYondallaConvoTemplate:addScreen(decline_quest_reset);

changed_mind = ConvoScreen:new {
	id = "changed_mind",
	leftDialog = "@conversation/corvette_yondalla_neutral_rescue:s_4d118a1d", -- Thank you, now hurry please.
	stopConversation = "true",
	options = {}
}
corvetteYondallaConvoTemplate:addScreen(changed_mind);

launch_location = ConvoScreen:new {
	id = "launch_location",
	customDialogText = "Show your authorization to Klaatu behind Jabba's Palace on Tatooine. Gather your crew before you talk to him.",
	stopConversation = "true",
	options = {}
}
corvetteYondallaConvoTemplate:addScreen(launch_location);

reward = ConvoScreen:new {
	id = "reward",
	customDialogText = "Vledmo says he escaped on his own. I'm paying you anyway. He's back and Imperial Security won't be questioning him.",
	stopConversation = "false",
	options = {
		{"I'll take the payment.", "give_reward"},
		{"@conversation/corvette_yondalla_neutral_rescue:s_c8d78390","reward_notyet"} --Not yet. I'll come back for it.
	}
}
corvetteYondallaConvoTemplate:addScreen(reward);

reward_notyet = ConvoScreen:new {
	id = "reward_notyet",
	leftDialog = "@conversation/corvette_yondalla_neutral_rescue:s_fe8eb1aa", -- Ah... very well. If that is what you want, come back when you're ready for it.
	stopConversation = "true",
	options = {}
}
corvetteYondallaConvoTemplate:addScreen(reward_notyet);

give_reward = ConvoScreen:new {
	id = "give_reward",
	leftDialog = "@conversation/corvette_yondalla_neutral_rescue:s_7e1ef500", --No, allow me to thank you. Here is your reward. I hope it serves you well.
	stopConversation = "true",
	options = {}
}
corvetteYondallaConvoTemplate:addScreen(give_reward);

cant_give_reward = ConvoScreen:new {
	id = "cant_give_reward",
	leftDialog = "@conversation/corvette_yondalla_neutral_rescue:s_7604ad47", -- Ah... it would appear that you have no space to carry your reward. I'll have to ask that you make room and then come speak to me again.
	stopConversation = "true",
	options = {}
}
corvetteYondallaConvoTemplate:addScreen(cant_give_reward);

addConversationTemplate("corvetteYondallaConvoTemplate", corvetteYondallaConvoTemplate);
