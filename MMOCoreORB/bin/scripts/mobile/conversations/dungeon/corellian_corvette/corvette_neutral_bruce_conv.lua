corvetteBruceConvoTemplate = ConvoTemplate:new {
	initialScreen = "",
	templateType = "Lua",
	luaClassHandler = "ticketGiverBruceConvoHandler",
	screens = {}
}

already_busy = ConvoScreen:new {
	id = "already_busy",
	leftDialog = "@conversation/corvette_bruce_neutral_destroy:s_1ffa4e4b", -- Hmmm... I could use yer help, but I can see that ye are already busy. Come back when ye have finished yer current task and maybe we can do business.
	stopConversation = "true",
	options = {}
}
corvetteBruceConvoTemplate:addScreen(already_busy);

convo_start = ConvoScreen:new {
	id = "convo_start",
	leftDialog = "@conversation/corvette_bruce_neutral_destroy:s_f7dab98e", -- G'day! Jabba has me do a most urgent mission and me need yer help! I heard yer name whispered in the palace so me think, dis here fellow wuld be perfect fer dis kinda job.
	stopConversation = "false",
	options = {
		{"Tell me more.", "convo_start_1"},
		{"@conversation/corvette_bruce_neutral_destroy:s_b6988a9c","convo_exit"} -- Sorry, in a rush. Maybe next time.
	}
}
corvetteBruceConvoTemplate:addScreen(convo_start);

convo_start_1 = ConvoScreen:new {
	id = "convo_start_1",
	customDialogText = "CorSec took freight records off one of Jabba's crews. The paperwork names the inspectors he pays, and an Imperial auditor is waiting for it. I need the CorSec Destruct Sequence Codes so you can stop the ship before it delivers the evidence.",
	stopConversation = "false",
	options = {
		{"I'll look for the document.", "quest_start"}
	}
}
corvetteBruceConvoTemplate:addScreen(convo_start_1);

quest_start = ConvoScreen:new {
	id = "quest_start",
	customDialogText = "I have three leads for the CorSec Destruct Sequence Codes. Bring me the current copy and I'll clear you for boarding. Which lead do you want first?",
	stopConversation = "false",
	options = {}
}
corvetteBruceConvoTemplate:addScreen(quest_start);

convo_exit = ConvoScreen:new {
	id = "convo_exit",
	leftDialog = "@conversation/corvette_bruce_neutral_destroy:s_a5cbd64e", -- Durnit! Dis not be good.
	stopConversation = "true",
	options = {}
}
corvetteBruceConvoTemplate:addScreen(convo_exit);

which_planet = ConvoScreen:new {
	id = "which_planet",
	customDialogText = "Which lead for the CorSec Destruct Sequence Codes should I go over again?",
	stopConversation = "false",
	options = {}
}
corvetteBruceConvoTemplate:addScreen(which_planet);

first_location = ConvoScreen:new {
	id = "first_location",
	customDialogText = "The Maulers were planning to raid the same ship for the seized cargo. Search the house where they kept the raid papers on Naboo (2912, 1106).",
	stopConversation = "false",
	options = {}
}
corvetteBruceConvoTemplate:addScreen(first_location);

second_location = ConvoScreen:new {
	id = "second_location",
	customDialogText = "An ex-technician kept a copy of the cutter's override packet. Search the technical cache in the Rogue CorSec bunker on Corellia (5238, 1600).",
	stopConversation = "false",
	options = {}
}
corvetteBruceConvoTemplate:addScreen(second_location);

third_location = ConvoScreen:new {
	id = "third_location",
	customDialogText = "A former Hutt courier hid a copy of the codes in the mine at the Nightsister labor camp on Dathomir (2528, -1589). Search for the courier's stash.",
	stopConversation = "false",
	options = {}
}
corvetteBruceConvoTemplate:addScreen(third_location);

go_get_intel = ConvoScreen:new {
	id = "go_get_intel",
	leftDialog = "@conversation/corvette_bruce_neutral_destroy:s_c58b6642", -- Marvellous! Time is of essence here so if ye wunt, ye can check back after ye found one of the documents to see if dat be it. Or wait until ye have all three, as long as yer fast.
	stopConversation = "true",
	options = {}
}
corvetteBruceConvoTemplate:addScreen(go_get_intel);

hear_locations_quit = ConvoScreen:new {
	id = "hear_locations_quit",
	leftDialog = "@conversation/corvette_bruce_neutral_destroy:s_a5cbd64e", -- Durnit! Dis not be good.
	stopConversation = "true",
	options = {}
}
corvetteBruceConvoTemplate:addScreen(hear_locations_quit);

back_already = ConvoScreen:new {
	id = "back_already",
	leftDialog = "@conversation/corvette_bruce_neutral_destroy:s_cfec2ce3", -- Ah, yer back! Any luck?
	stopConversation = "false",
	options = {}
}
corvetteBruceConvoTemplate:addScreen(back_already);

back_already_reset = ConvoScreen:new {
	id = "back_already_reset",
	leftDialog = "@conversation/corvette_bruce_neutral_destroy:s_ed430e90", -- Didn't take ye fer a quitter, guess I wus wrong. Dis not good news, not at all. I'm gonna take all everything about dis from ye. Ye keep nuthin.
	stopConversation = "true",
	options = {}
}
corvetteBruceConvoTemplate:addScreen(back_already_reset);

has_intel = ConvoScreen:new {
	id = "has_intel",
	leftDialog = "@conversation/corvette_bruce_neutral_destroy:s_68f1fe27", --  Well fork dem over!
	stopConversation = "false",
	options = {}
}
corvetteBruceConvoTemplate:addScreen(has_intel);

bad_intel_1 = ConvoScreen:new {
	id = "bad_intel_1",
	customDialogText = "This copy was superseded before the ship left. I'll pay you for the lead. Keep looking for the current one.",
	stopConversation = "false",
	options = {}
}
corvetteBruceConvoTemplate:addScreen(bad_intel_1);

bad_intel_2 = ConvoScreen:new {
	id = "bad_intel_2",
	customDialogText = "This belongs to the operation, but it won't get you aboard. I'll pay you for bringing it in.",
	stopConversation = "false",
	options = {}
}
corvetteBruceConvoTemplate:addScreen(bad_intel_2);

check_other_places = ConvoScreen:new {
	id = "check_other_places",
	leftDialog = "@conversation/corvette_bruce_neutral_destroy:s_7a77d96c", --  Yes and hurry, we're running out of time here!
	stopConversation = "true",
	options = {}
}

corvetteBruceConvoTemplate:addScreen(check_other_places);

other_documents = ConvoScreen:new {
	id = "other_documents",
	leftDialog = "@conversation/corvette_bruce_neutral_destroy:s_14963f17", -- Let me take a look.
	stopConversation = "false",
	options = {}
}
corvetteBruceConvoTemplate:addScreen(other_documents);

good_intel = ConvoScreen:new {
	id = "good_intel",
	customDialogText = "These codes identify the cutter and get you into its drive controls. Take the authorization to Klaatu behind the palace. Destroy the drive and leave the evidence aboard.",
	stopConversation = "false",
	options = {}
}
corvetteBruceConvoTemplate:addScreen(good_intel);

go_to_corvette = ConvoScreen:new {
	id = "go_to_corvette",
	customDialogText = "Show your authorization to Klaatu behind Jabba's Palace on Tatooine. Gather your crew before you talk to him.",
	stopConversation = "true",
	options = {}
}
corvetteBruceConvoTemplate:addScreen(go_to_corvette);

still_here = ConvoScreen:new {
	id = "still_here",
	leftDialog = "@conversation/corvette_bruce_neutral_destroy:s_28c81b92", --  Ye haven't left yet? Whut ye still doing here?
	stopConversation = "false",
	options = {}
}
corvetteBruceConvoTemplate:addScreen(still_here);

still_here_decline = ConvoScreen:new {
	id = "still_here_decline",
	leftDialog = "@conversation/corvette_bruce_neutral_destroy:s_21328697", -- Whut the?! Ye giving up now, we almost done! If yer quit, I have ta take everything ye gotten up to dis time from ye.
	stopConversation = "false",
	options = {
		{"@conversation/corvette_bruce_neutral_destroy:s_77455336","decline_quest_reset"}, --Yeah I'm sorry, I can't do this.
		{"@conversation/corvette_bruce_neutral_destroy:s_d036761d","changed_mind"}, -- Fine, I'll do it.
	}
}
corvetteBruceConvoTemplate:addScreen(still_here_decline);

decline_quest_reset = ConvoScreen:new {
	id = "decline_quest_reset",
	leftDialog = "@conversation/corvette_bruce_neutral_destroy:s_d725eac", -- Fine! Get outta here and don't come back, ye here?
	stopConversation = "true",
	options = {}
}
corvetteBruceConvoTemplate:addScreen(decline_quest_reset);

changed_mind = ConvoScreen:new {
	id = "changed_mind",
	leftDialog = "@conversation/corvette_bruce_neutral_destroy:s_20f0bac1", -- Knew ye wuld come around. Now hurry!
	stopConversation = "true",
	options = {}
}
corvetteBruceConvoTemplate:addScreen(changed_mind);

launch_location = ConvoScreen:new {
	id = "launch_location",
	customDialogText = "Show your authorization to Klaatu behind Jabba's Palace on Tatooine. Gather your crew before you talk to him.",
	stopConversation = "true",
	options = {}
}
corvetteBruceConvoTemplate:addScreen(launch_location);

reward = ConvoScreen:new {
	id = "reward",
	customDialogText = "The cutter and the original records are gone. Our friends in customs can breathe again. Jabba sends your payment.",
	stopConversation = "false",
	options = {
		{"I'll take the payment.", "give_reward"},
		{"@conversation/corvette_bruce_neutral_destroy:s_a2329c74","reward_notyet"} --Not just yet. I'll come back.
	}
}
corvetteBruceConvoTemplate:addScreen(reward);

reward_notyet = ConvoScreen:new {
	id = "reward_notyet",
	leftDialog = "@conversation/corvette_bruce_neutral_destroy:s_557298a9", -- Not yet? Ye be a strange one. Why not take dis reward sooner rather den later? Stange one.
	stopConversation = "true",
	options = {}
}
corvetteBruceConvoTemplate:addScreen(reward_notyet);

give_reward = ConvoScreen:new {
	id = "give_reward",
	leftDialog = "@conversation/corvette_bruce_neutral_destroy:s_40e26fa7", --Yea. Okay. Dis here be your reward. Ye like?
	stopConversation = "true",
	options = {}
}
corvetteBruceConvoTemplate:addScreen(give_reward);

cant_give_reward = ConvoScreen:new {
	id = "cant_give_reward",
	leftDialog = "@conversation/corvette_bruce_neutral_destroy:s_4af1600f", -- Yea. Only ye no have room to take it. Best that ye make some room and den come back.
	stopConversation = "true",
	options = {}
}
corvetteBruceConvoTemplate:addScreen(cant_give_reward);

addConversationTemplate("corvetteBruceConvoTemplate", corvetteBruceConvoTemplate);

