corvetteSabolConvoTemplate = ConvoTemplate:new {
	initialScreen = "",
	templateType = "Lua",
	luaClassHandler = "ticketGiverSabolConvoHandler",
	screens = {}
}

no_faction = ConvoScreen:new {
	id = "no_faction",
	leftDialog = "@conversation/corvette_sabol_imperial1:s_69693bca", --Must you interrupt me? I cannot make time for those unwilling to declare allegiance to the Empire. Please leave me be until your loyalties become clearer.
	stopConversation = "true",
	options = {}
}
corvetteSabolConvoTemplate:addScreen(no_faction);

already_busy = ConvoScreen:new {
	id = "already_busy",
	leftDialog = "@conversation/corvette_sabol_imperial1:s_74947555", --Typical... I actually need some assistance, and they send me someone who can't help me. You're already busy. What was the point. Come back when you've finished your current task and maybe, assuming it's not too late, you could still be of use.
	stopConversation = "true",
	options = {}
}
corvetteSabolConvoTemplate:addScreen(already_busy);

convo_start = ConvoScreen:new {
	id = "convo_start",
	leftDialog = "@conversation/corvette_sabol_imperial1:s_145e07df", --Idiots! Complete and utter idiots! How can I complete my tasks when my commanding officers are nothing but fools! I... Excuse me. I didn't see you standing there. Well... what do you want? I'm very busy as you can see.
	stopConversation = "false",
	options = {
		{"Tell me more.", "convo_start_2"},
		{"@conversation/corvette_sabol_imperial1:s_4c16d4f","convo_exit"} --Ah, nothing. My apologies for disturbing you.
	}
}
corvetteSabolConvoTemplate:addScreen(convo_start);

convo_exit = ConvoScreen:new {
	id = "convo_exit",
	leftDialog = "@conversation/corvette_sabol_imperial1:s_229f193e", -- Indeed. And please do not make a habit of doing so. I have responsibilities to the Empire that must not be delayed.
	stopConversation = "true",
	options = {}
}
corvetteSabolConvoTemplate:addScreen(convo_exit);

convo_start_2 = ConvoScreen:new {
	id = "convo_start_2",
	leftDialog = "@conversation/corvette_sabol_imperial1:s_1e7ac1df", --So? Are you looking for work? Are you that desperate? I suppose I might be thankful but, as a lieutenant of the Empire, I am more suspicious than grateful. Oh fine! I'll tell you but only because I need someone to help me with some... field work. Do you wish to hear me out?
	stopConversation = "false",
	options = {
		{"Tell me more.", "convo_start_3"},
		{"@conversation/corvette_sabol_imperial1:s_d143f357","convo_exit_2"} --No thanks. I'm going now. Good-bye.
	}
}
corvetteSabolConvoTemplate:addScreen(convo_start_2);

convo_exit_2 = ConvoScreen:new {
	id = "convo_exit_2",
	leftDialog = "@conversation/corvette_sabol_imperial1:s_fdcee9b7", --The standard for those allowed into our Imperial ranks has obviously declined. Greatly. I regret the day someone like you was called to server. Leave now.
	stopConversation = "true",
	options = {}
}
corvetteSabolConvoTemplate:addScreen(convo_exit_2);

convo_start_3 = ConvoScreen:new {
	id = "convo_start_3",
	customDialogText = "A former Republic captain is using a civilian corvette to coordinate evacuation corridors for several insurgent cells. My orders are to close those routes. Yours are to find the man and eliminate him before he briefs his next convoy.",
	stopConversation = "false",
	options = {
		{"Tell me more.", "convo_start_4"},
		{"@conversation/corvette_sabol_imperial1:s_df8ea53","convo_exit_3"} --Not interested.
	}
}
corvetteSabolConvoTemplate:addScreen(convo_start_3);

convo_exit_3 = ConvoScreen:new {
	id = "convo_exit_3",
	leftDialog = "@conversation/corvette_sabol_imperial1:s_1dcd7b46", -- Disgusting peon. Breathing your air makes my intelligence dwindle into nothingness. Be gone!
	stopConversation = "true",
	options = {}
}
corvetteSabolConvoTemplate:addScreen(convo_exit_3);

convo_start_4 = ConvoScreen:new {
	id = "convo_start_4",
	customDialogText = "Find the Outbound Freight Manifest. It identifies the corvette's civilian registration and places the captain aboard. I have three leads. I expect results.",
	stopConversation = "false",
	options = {
		{"I'll look for the document.", "quest_start"},
		{"@conversation/corvette_sabol_imperial1:s_a11b6dbf","convo_exit_4"} --No, that would be a little too hard.
	}
}
corvetteSabolConvoTemplate:addScreen(convo_start_4);

convo_exit_4 = ConvoScreen:new {
	id = "convo_exit_4",
	leftDialog = "@conversation/corvette_sabol_imperial1:s_f60e408a", -- I see now that you are a coward. Such a pity.
	stopConversation = "true",
	options = {}
}
corvetteSabolConvoTemplate:addScreen(convo_exit_4);

quest_start = ConvoScreen:new {
	id = "quest_start",
	customDialogText = "I have three leads for the Outbound Freight Manifest. Bring me the current copy and I'll clear you for boarding. Which lead do you want first?",
	stopConversation = "false",
	options = {	}
}
corvetteSabolConvoTemplate:addScreen(quest_start);

which_planet = ConvoScreen:new {
	id = "which_planet",
	customDialogText = "Which lead for the Outbound Freight Manifest should I go over again?",
	stopConversation = "false",
	options = {	}
}
corvetteSabolConvoTemplate:addScreen(which_planet);

first_location = ConvoScreen:new {
	id = "first_location",
	customDialogText = "A courier traveling under a passenger alias carried a duplicate in a sealed case. Search the Tzarina debris field on Dathomir (5694, 1935).",
	stopConversation = "false",
	options = {	}
}
corvetteSabolConvoTemplate:addScreen(first_location);

second_location = ConvoScreen:new {
	id = "second_location",
	customDialogText = "The captain registered the ship through a broker in Anchorhead, Tatooine (132, -5356). Search the broker's house for the filed manifest.",
	stopConversation = "false",
	options = {	}
}
corvetteSabolConvoTemplate:addScreen(second_location);

third_location = ConvoScreen:new {
	id = "third_location",
	customDialogText = "The captain's runners use a shed at an abandoned Dantooine outpost (-6678, 5561) as a dead drop. Search it for the next convoy packet.",
	stopConversation = "false",
	options = {	}
}
corvetteSabolConvoTemplate:addScreen(third_location);

go_get_intel = ConvoScreen:new {
	id = "go_get_intel",
	leftDialog = "@conversation/corvette_sabol_imperial1:s_7fdf3bed", --Good. I am satisfied to know you are not a coward and are willing to risk your life for the greater good of the Empire. Now, leave.
	stopConversation = "true",
	options = {}
}
corvetteSabolConvoTemplate:addScreen(go_get_intel);

hear_locations_quit = ConvoScreen:new {
	id = "hear_locations_quit",
	leftDialog = "@conversation/corvette_sabol_imperial1:s_6289b734", --Leave here before you anger me further. Do not waste my time again!
	stopConversation = "true",
	options = {}
}
corvetteSabolConvoTemplate:addScreen(hear_locations_quit);

back_already = ConvoScreen:new {
	id = "back_already",
	leftDialog = "@conversation/corvette_sabol_imperial1:s_214dc2b7", --I see that you've returned. I do not tolerate failure. Please tell me you've succeeded. I do not wish to terminate another Imperial soldier this day. Did you find my documents?
	stopConversation = "false",
	options = {	}
}
corvetteSabolConvoTemplate:addScreen(back_already);

back_already_reset = ConvoScreen:new {
	id = "back_already_reset",
	leftDialog = "@conversation/corvette_sabol_imperial1:s_1bb4597", --I will gladly clear the records of your progress and confiscate all documents pertaining to this mission. I will also immediately report this to my superiors. Run, run far away or I will have my troopers arrest you for treason.
	stopConversation = "true",
	options = { }
}
corvetteSabolConvoTemplate:addScreen(back_already_reset);

has_intel = ConvoScreen:new {
	id = "has_intel",
	leftDialog = "@conversation/corvette_sabol_imperial1:s_e139d89b", --The only document I'm interested in is the one I commanded you to find! Now where is it?! Fine--I'll humor you. What did you find on your travels?
	stopConversation = "false",
	options = {	}
}
corvetteSabolConvoTemplate:addScreen(has_intel);

bad_intel_1 = ConvoScreen:new {
	id = "bad_intel_1",
	customDialogText = "This copy was superseded before the ship left. I'll pay you for the lead. Keep looking for the current one.",
	stopConversation = "false",
	options = {	}
}
corvetteSabolConvoTemplate:addScreen(bad_intel_1);

bad_intel_2 = ConvoScreen:new {
	id = "bad_intel_2",
	customDialogText = "This belongs to the operation, but it won't get you aboard. I'll pay you for bringing it in.",
	stopConversation = "false",
	options = {}
}
corvetteSabolConvoTemplate:addScreen(bad_intel_2);

check_other_places = ConvoScreen:new {
	id = "check_other_places",
	leftDialog = "@conversation/corvette_sabol_imperial1:s_424889c8", --Yes and you're wasting my time just standing there. Find those documents!
	stopConversation = "true",
	options = {}
}
corvetteSabolConvoTemplate:addScreen(check_other_places);

other_documents = ConvoScreen:new {
	id = "other_documents",
	leftDialog = "@conversation/corvette_sabol_imperial1:s_a33382c5", --Let me see them.
	stopConversation = "false",
	options = {	}
}
corvetteSabolConvoTemplate:addScreen(other_documents);

good_intel = ConvoScreen:new {
	id = "good_intel",
	customDialogText = "The registration checks out. Take this authorization to DS-297 at the Emperor's Retreat on Naboo. Get aboard, eliminate the captain and report directly to me.",
	stopConversation = "false",
	options = {	}
}
corvetteSabolConvoTemplate:addScreen(good_intel);

go_to_corvette = ConvoScreen:new {
	id = "go_to_corvette",
	customDialogText = "Present your authorization to DS-297 at the Emperor's Retreat on Naboo. Assemble your team before you speak to the pilot.",
	stopConversation = "true",
	options = {}
}
corvetteSabolConvoTemplate:addScreen(go_to_corvette);

still_here = ConvoScreen:new {
	id = "still_here",
	leftDialog = "@conversation/corvette_sabol_imperial1:s_eeb7ec64", --You're back?
	stopConversation = "false",
	options = {	}
}
corvetteSabolConvoTemplate:addScreen(still_here);

still_here_decline = ConvoScreen:new {
	id = "still_here_decline",
	leftDialog = "@conversation/corvette_sabol_imperial1:s_4142af45", --Oh? You realize if you quit I must eradicate all records of your progress, confiscate all remaining mission documents, and revoke the travel authorization. You do realize that, correct?
	stopConversation = "false",
	options = {
		{"@conversation/corvette_sabol_imperial1:s_c8e527a1","decline_quest_reset"}, --That's fine. I still want to quit.
		{"@conversation/corvette_sabol_imperial1:s_c36f888","changed_mind"}, --Oh. Nevermind. I'll continue.
	}
}
corvetteSabolConvoTemplate:addScreen(still_here_decline);

decline_quest_reset = ConvoScreen:new {
	id = "decline_quest_reset",
	leftDialog = "@conversation/corvette_sabol_imperial1:s_e24b66e7", --I was tired of seeing your face, anyway. I will find someone else who possesses more direction in life.
	stopConversation = "true",
	options = {}
}
corvetteSabolConvoTemplate:addScreen(decline_quest_reset);

changed_mind = ConvoScreen:new {
	id = "changed_mind",
	leftDialog = "@conversation/corvette_sabol_imperial1:s_a7150449", --That's what I thought.
	stopConversation = "true",
	options = {}
}
corvetteSabolConvoTemplate:addScreen(changed_mind);

launch_location = ConvoScreen:new {
	id = "launch_location",
	customDialogText = "Present your authorization to DS-297 at the Emperor's Retreat on Naboo. Assemble your team before you speak to the pilot.",
	stopConversation = "true",
	options = {}
}
corvetteSabolConvoTemplate:addScreen(launch_location);

reward = ConvoScreen:new {
	id = "reward",
	customDialogText = "The captain is dead and the corridor is closed. Local patrols will deal with the remaining ships. Collect your payment.",
	stopConversation = "false",
	options = {
		{"I'll take the payment.", "give_reward"},
		{"@conversation/corvette_sabol_imperial1:s_be293abc","reward_notyet"} -- No, not yet. I'll return.
	}
}
corvetteSabolConvoTemplate:addScreen(reward);

reward_notyet = ConvoScreen:new {
	id = "reward_notyet",
	leftDialog = "@conversation/corvette_sabol_imperial1:s_1accfb99", --Whatever. Makes no difference to me. Just let me know when you're ready.
	stopConversation = "true",
	options = {}
}
corvetteSabolConvoTemplate:addScreen(reward_notyet);

give_reward = ConvoScreen:new {
	id = "give_reward",
	leftDialog = "@conversation/corvette_sabol_imperial1:s_ed80aff5", --Take it. I'll... um... I'll be sure my commanders know your part in this. Don't you worry about that. Now go away.
	stopConversation = "true",
	options = {}
}
corvetteSabolConvoTemplate:addScreen(give_reward);

cant_give_reward = ConvoScreen:new {
	id = "cant_give_reward",
	leftDialog = "@conversation/corvette_sabol_imperial1:s_759b9766", -- As much as I'd like to conclude our business, I'm afraid I cannot. You do not have room to carry this reward. Make room and then speak with me again.
	stopConversation = "true",
	options = {}
}
corvetteSabolConvoTemplate:addScreen(cant_give_reward);

addConversationTemplate("corvetteSabolConvoTemplate", corvetteSabolConvoTemplate);

