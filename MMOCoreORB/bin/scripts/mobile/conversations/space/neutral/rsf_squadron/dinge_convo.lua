dinge_convo_template = ConvoTemplate:new {
	initialScreen = "",
	templateType = "Lua",
	luaClassHandler = "dingeConvoHandler",
	screens = {}
}

-- JTL Disabled
no_jtl = ConvoScreen:new {
	id = "no_jtl",
	leftDialog = "@conversation/naboo_privateer_trainer_1:s_7c1fe68f", -- Sorry, but I can't chit-chat with you. I'm busy doing important Royal Security work here.
	stopConversation = "true",
	options = {}
}
dinge_convo_template:addScreen(no_jtl);

-- Rebel Pilot
rebel_pilot = ConvoScreen:new {
	id = "rebel_pilot",
	leftDialog = "@conversation/naboo_privateer_trainer_1:s_72f94b8e", -- I think you're a pilot for the Rebel Alliance! Look, the Royal Security Forces don't have any use for the likes of you. I think you should leave now.
	stopConversation = "true",
	options = {}
}
dinge_convo_template:addScreen(rebel_pilot);

-- Imperial Pilot
imperial_pilot = ConvoScreen:new {
	id = "imperial_pilot",
	leftDialog = "@conversation/naboo_privateer_trainer_1:s_7217d77", -- Greetings officer! Nothing to worry about here, we've got everything under control.
	stopConversation = "true",
	options = {}
}
dinge_convo_template:addScreen(imperial_pilot);

-- Non-RSF Neutral Pilot
non_rsf_pilot = ConvoScreen:new {
	id = "non_rsf_pilot",
	leftDialog = "@conversation/naboo_privateer_trainer_1:s_6b25cc31", -- I've heard you're quite a pilot. What brings you to speak with the Royal Security Forces?
	stopConversation = "false",
	options = {
		{"@conversation/naboo_privateer_trainer_1:s_c1ff5062", "non_rsf_duty_missions"}, -- I'm looking for a mission. Do you have any?
	}
}
dinge_convo_template:addScreen(non_rsf_pilot);

non_rsf_duty_missions = ConvoScreen:new {
	id = "non_rsf_duty_missions",
	leftDialog = "@conversation/naboo_privateer_trainer_1:s_38d8b2c4", -- I appreciate your enthusiasm, but unless you're a member of the RSF, I'm afraid I cannot help you. Talk to your own contacts if you're looking for a mission.
	stopConversation = "true",
	options = {}
}
dinge_convo_template:addScreen(non_rsf_duty_missions);

-- Recruitment
recruitment = ConvoScreen:new {
	id = "recruitment",
	leftDialog = "@conversation/naboo_privateer_trainer_1:s_465e6eeb", -- Greetings citizen. Are you here to join the Royal Security Forces?
	stopConversation = "false",
	options = {
		{"@conversation/naboo_privateer_trainer_1:s_36a4e374", "yes_enlist"}, -- Yes, I am.
		{"@conversation/naboo_privateer_trainer_1:s_4c695dbd", "no_enlist"}, -- No.
	}
}
dinge_convo_template:addScreen(recruitment);

yes_enlist = ConvoScreen:new {
	id = "yes_enlist",
	leftDialog = "@conversation/naboo_privateer_trainer_1:s_c19e20c9", -- Excellent. Consider yourself enlisted. Do you have a starship suitable for service?
	stopConversation = "false",
	options = {
		-- Options added via handler
	}
}
dinge_convo_template:addScreen(yes_enlist);

no_enlist = ConvoScreen:new {
	id = "no_enlist",
	leftDialog = "@conversation/naboo_privateer_trainer_1:s_f5f16210", -- Very well. Come back and speak with me when you're ready.
	stopConversation = "true",
	options = {}
}
dinge_convo_template:addScreen(no_enlist);

-- No Ship
no_ship = ConvoScreen:new {
	id = "no_ship",
	leftDialog = "@conversation/naboo_privateer_trainer_1:s_b24af40a", -- You're going to need a ship, of course. I'll add these control codes for a basic one to your datapad. You should consider upgrading to a better ship soon, though.
	stopConversation = "false",
	options = {
		{"@conversation/naboo_privateer_trainer_1:s_b9b27823", "ready_first_assignment"}, -- Thank you.
		{"@conversation/naboo_privateer_trainer_1:s_4358efe9", "where_is_ship"}, -- Where is my ship?
	}
}
dinge_convo_template:addScreen(no_ship);

yes_ship = ConvoScreen:new {
	id = "yes_ship",
	leftDialog = "@conversation/naboo_privateer_trainer_1:s_5ed33504", -- Excellent. Sounds like you're all set then. Are you ready for your first assignment?
	stopConversation = "false",
	options = {
		{"@conversation/naboo_privateer_trainer_1:s_b3a9fd05", "yes_im_ready"}, -- Sure!
		{"@conversation/naboo_privateer_trainer_1:s_68660d24", "not_ready"}, -- I need to take care of some things first.
	}
}
dinge_convo_template:addScreen(yes_ship);

where_is_ship = ConvoScreen:new {
	id = "where_is_ship",
	leftDialog = "@conversation/naboo_privateer_trainer_1:s_41c478b2", -- Theed Hangar. Leave the palace the way you came. Take a left when you hit the plaza. Then follow the roads until you reach the power complex. Theed Hangar is on the opposite side of this building. Go inside the hangar and look for the 'starship terminals.' Use one of these terminals to launch your starship.
	stopConversation = "false",
	options = {
		{"@conversation/naboo_privateer_trainer_1:s_b3a9fd05", "yes_im_ready"}, -- Sure!
		{"@conversation/naboo_privateer_trainer_1:s_85dd7d6c", "how_get_back"}, -- How do I get back?
	}
}
dinge_convo_template:addScreen(where_is_ship);

how_get_back = ConvoScreen:new {
	id = "how_get_back",
	leftDialog = "@conversation/naboo_privateer_trainer_1:s_1664d807", -- You must communicate with the Naboo space station and request permission to land. Fortunately all of the new starship navicomputers automatically add a 'launch waypoint' to your datapad when you take off. Find your way back to this point, fly up to the space station, communicate with them, and ask for landing clearance.
	stopConversation = "false",
	options = {
		{"@conversation/naboo_privateer_trainer_1:s_b3a9fd05", "yes_im_ready"}, -- Sure!
	}
}
dinge_convo_template:addScreen(how_get_back);

ready_first_assignment = ConvoScreen:new {
	id = "ready_first_assignment",
	leftDialog = "@conversation/naboo_privateer_trainer_1:s_eed2fe3e", -- Think nothing of it. Are you ready for your first assignment?
	stopConversation = "false",
	options = {
		{"@conversation/naboo_privateer_trainer_1:s_b3a9fd05", "yes_im_ready"}, -- Sure!
		{"@conversation/naboo_privateer_trainer_1:s_68660d24", "not_ready"}, -- I need to take care of some things first.
	}
}
dinge_convo_template:addScreen(ready_first_assignment);

not_ready = ConvoScreen:new {
	id = "not_ready",
	leftDialog = "@conversation/naboo_privateer_trainer_1:s_792ad840", -- OK, OK. Come back when you're ready.
	stopConversation = "true",
	options = {}
}
dinge_convo_template:addScreen(not_ready);

-- First Mission
yes_im_ready = ConvoScreen:new {
	id = "yes_im_ready",
	leftDialog = "@conversation/naboo_privateer_trainer_1:s_904d71cf", -- Ok! Ready for an assignment already, eh? Well listen up! We've had reports of pirates in the system and we want you to run a patrol. Just make sure everything's on the up and up. This ought to be a piece of cake.
	stopConversation = "false",
	options = {
		{"@conversation/naboo_privateer_trainer_1:s_1db37a0f", "go_patrol"}, -- I'm off!
		{"@conversation/naboo_privateer_trainer_1:s_60c4f974", "where_go"}, -- Where do I go?
	}
}
dinge_convo_template:addScreen(yes_im_ready);

go_patrol = ConvoScreen:new {
	id = "go_patrol",
	leftDialog = "@conversation/naboo_privateer_trainer_1:s_b02e116", -- That's the spirit. Good luck!
	stopConversation = "true",
	options = {}
}
dinge_convo_template:addScreen(go_patrol);

where_go = ConvoScreen:new {
	id = "where_go",
	leftDialog = "@conversation/naboo_privateer_trainer_1:s_8853a92c", -- You've got your assignment, and the control device for your ship in your datapad. Go to Theed Hangar and access the terminal to launch into space.
	stopConversation = "true",
	options = {}
}
dinge_convo_template:addScreen(where_go);

-- Has Active Mission
has_mission = ConvoScreen:new {
	id = "has_mission",
	leftDialog = "@conversation/naboo_privateer_trainer_1:s_61036267", -- You've got your orders! Stop standing around and get back on the job.
	stopConversation = "true",
	options = {}
}
dinge_convo_template:addScreen(has_mission);

-- First Assignment In Progress
first_assignment = ConvoScreen:new {
	id = "first_assignment",
	leftDialog = "@conversation/naboo_privateer_trainer_1:s_443c036b", -- All I asked was for you to complete one simple patrol. What's the malfunction? Get back out there and secure the area!
	stopConversation = "false",
	options = {
		{"@conversation/naboo_privateer_trainer_1:s_aec5c3dd", "was_attacked"}, -- It wasn't my fault. I was attacked!
		{"@conversation/naboo_privateer_trainer_1:s_ea059f38", "will_do"}, -- Will do!
	}
}
dinge_convo_template:addScreen(first_assignment);

was_attacked = ConvoScreen:new {
	id = "was_attacked",
	leftDialog = "@conversation/naboo_privateer_trainer_1:s_73f727e7", -- Now hold on, there... there's no reason to fly off the handle. You've got a job to do, that's all. Now get out there and do it. And... good luck!
	stopConversation = "true",
	options = {}
}
dinge_convo_template:addScreen(was_attacked);

will_do = ConvoScreen:new {
	id = "will_do",
	leftDialog = "@conversation/naboo_privateer_trainer_1:s_b9c77549", -- That's what I want to hear. Now go!
	stopConversation = "true",
	options = {}
}
dinge_convo_template:addScreen(will_do);

-- Quest 1 Complete
excellent_work = ConvoScreen:new {
	id = "excellent_work",
	leftDialog = "@conversation/naboo_privateer_trainer_1:s_5df0371b", -- Excellent work! It's a good thing we sent you on that patrol. Take this as your payment. If you want another assignment, then just come talk to me.
	stopConversation = "false",
	options = {
		{"@conversation/naboo_privateer_trainer_1:s_3f49e786", "train_me2"}, -- Great!
		{"@conversation/naboo_privateer_trainer_1:s_9237617f", "no_training_yet"}, -- What about training?
	}
}
dinge_convo_template:addScreen(excellent_work);

no_training_yet = ConvoScreen:new {
	id = "no_training_yet",
	leftDialog = "@conversation/naboo_privateer_trainer_1:s_8fb73c4", -- I'll train you... AFTER you complete a few assignments for me. Now about that patrol...
	stopConversation = "false",
	options = {
		{"@conversation/naboo_privateer_trainer_1:s_3f49e786", "train_me2"}, -- Great!
	}
}
dinge_convo_template:addScreen(no_training_yet);

-- Quest 2 Start
train_me2 = ConvoScreen:new {
	id = "train_me2",
	leftDialog = "@conversation/naboo_privateer_trainer_1:s_bcdb501b", -- Ready for your next assignment? Good! Obviously we can't allow that random attack on you to stand, so now we need to send a message to those pirates. Go destroy four of the Black Sun pirates... That should send a clear message that we're not going to tolerate their activities.
	stopConversation = "false",
	options = {
		{"@conversation/naboo_privateer_trainer_1:s_7b3b28bf", "go_destroy"}, -- Go!
	}
}
dinge_convo_template:addScreen(train_me2);

go_destroy = ConvoScreen:new {
	id = "go_destroy",
	leftDialog = "@conversation/naboo_privateer_trainer_1:s_6575e5d0", -- Get up there and put those Black Sun in their place.
	stopConversation = "true",
	options = {}
}
dinge_convo_template:addScreen(go_destroy);

-- Quest 2 Complete
excellent_work2 = ConvoScreen:new {
	id = "excellent_work2",
	leftDialog = "@conversation/naboo_privateer_trainer_1:s_3d6c25c7", -- Good work, %NU. Here's your payment.
	stopConversation = "false",
	options = {
		{"@conversation/naboo_privateer_trainer_1:s_c4682ea6", "train_me3"}, -- Thanks!
	}
}
dinge_convo_template:addScreen(excellent_work2);

-- Quest 3 Start
train_me3 = ConvoScreen:new {
	id = "train_me3",
	leftDialog = "@conversation/naboo_privateer_trainer_1:s_c29502", -- Right, back to work! Now that you've eliminated some of the riffraff out there, we want you to run a patrol and make sure there are no more of these criminals in the area.
	stopConversation = "false",
	options = {
		{"@conversation/naboo_privateer_trainer_1:s_ea059f38", "go_patrol3"}, -- Will do!
	}
}
dinge_convo_template:addScreen(train_me3);

go_patrol3 = ConvoScreen:new {
	id = "go_patrol3",
	leftDialog = "@conversation/naboo_privateer_trainer_1:s_b02e116", -- That's the spirit. Good luck!
	stopConversation = "true",
	options = {}
}
dinge_convo_template:addScreen(go_patrol3);

-- Quest 3 Complete (with bandolier reward)
excellent_work3 = ConvoScreen:new {
	id = "excellent_work3",
	leftDialog = "@conversation/naboo_privateer_trainer_1:s_cd397d97", -- That was a quick reaction to pick up the escort. It is a good thing we sent you on that patrol. The pilot sent over some money for you to cover any repairs you might have, and here's something to help you organize your things.
	stopConversation = "false",
	options = {
		{"@conversation/naboo_privateer_trainer_1:s_1c8bddbb", "what_is_it"}, -- What is it?
		{"@conversation/naboo_privateer_trainer_1:s_e9c7c6bb", "train_me4"}, -- That will come in handy.
	}
}
dinge_convo_template:addScreen(excellent_work3);

what_is_it = ConvoScreen:new {
	id = "what_is_it",
	leftDialog = "@conversation/naboo_privateer_trainer_1:s_d05d7112", -- It's a mercenary bandolier. Pretty popular item among the freelance pilot crowd. Really handy to help you keep your things organized.
	stopConversation = "false",
	options = {
		{"@conversation/naboo_privateer_trainer_1:s_e9c7c6bb", "train_me4"}, -- That will come in handy.
	}
}
dinge_convo_template:addScreen(what_is_it);

-- Quest 4 Start (Assassinate)
train_me4 = ConvoScreen:new {
	id = "train_me4",
	leftDialog = "@conversation/naboo_privateer_trainer_1:s_966bc2b6", -- I don't know about you, but I've had about enough of these criminals operating in our system! We want you to take out their leader this time, and use all necessary force to defeat any wingmen that happen to be with him, too.
	stopConversation = "false",
	options = {
		{"@conversation/naboo_privateer_trainer_1:s_7736f08b", "go_assassinate"}, -- Now it's personal.
		{"@conversation/naboo_privateer_trainer_1:s_7478cd28", "will_train"}, -- Will you train me after this?
	}
}
dinge_convo_template:addScreen(train_me4);

will_train = ConvoScreen:new {
	id = "will_train",
	leftDialog = "@conversation/naboo_privateer_trainer_1:s_3175b359", -- Yes, yes, you have my word. Take out that leader and I will train you to be a better pilot.
	stopConversation = "false",
	options = {
		{"@conversation/naboo_privateer_trainer_1:s_7736f08b", "go_assassinate"}, -- Now it's personal.
	}
}
dinge_convo_template:addScreen(will_train);

go_assassinate = ConvoScreen:new {
	id = "go_assassinate",
	leftDialog = "@conversation/naboo_privateer_trainer_1:s_b02e116", -- That's the spirit. Good luck!
	stopConversation = "true",
	options = {}
}
dinge_convo_template:addScreen(go_assassinate);

-- All Missions Complete - Ready for training
missions_complete = ConvoScreen:new {
	id = "missions_complete",
	leftDialog = "@conversation/naboo_privateer_trainer_1:s_6ea4aa1e", -- That's great work! With their leader destroyed, they're sure to be on the run. Let 'em go to Tatooine if they want to be criminals, but they're not going to aggress merchants while the RSF is on the job. Take these credits and get your ship repaired, if it needs it.
	stopConversation = "false",
	options = {
		{"@conversation/naboo_privateer_trainer_1:s_db74ddc6", "more_training"}, -- How about some training?
		{"@conversation/naboo_privateer_trainer_1:s_c4682ea6", "thanks_bye"}, -- Thanks!
	}
}
dinge_convo_template:addScreen(missions_complete);

thanks_bye = ConvoScreen:new {
	id = "thanks_bye",
	leftDialog = "@conversation/naboo_privateer_trainer_1:s_cd72f93", -- Good choice.
	stopConversation = "true",
	options = {}
}
dinge_convo_template:addScreen(thanks_bye);

-- Training Menu
more_training = ConvoScreen:new {
	id = "more_training",
	leftDialog = "@conversation/naboo_privateer_trainer_1:s_122b0165", -- You're really coming along as a pilot, %TU. I think you're ready for some more training. What interests you?
	stopConversation = "false",
	options = {
		-- Options added dynamically via handler
	}
}
dinge_convo_template:addScreen(more_training);

train_player_fighters = ConvoScreen:new {
	id = "train_player_fighters",
	leftDialog = "@conversation/naboo_privateer_trainer_1:s_cd72f93", -- Good choice.
	stopConversation = "true",
	options = {}
}
dinge_convo_template:addScreen(train_player_fighters);

train_player_component = ConvoScreen:new {
	id = "train_player_component",
	leftDialog = "@conversation/naboo_privateer_trainer_1:s_cd72f93", -- Good choice.
	stopConversation = "true",
	options = {}
}
dinge_convo_template:addScreen(train_player_component);

train_player_basics = ConvoScreen:new {
	id = "train_player_basics",
	leftDialog = "@conversation/naboo_privateer_trainer_1:s_cd72f93", -- Good choice.
	stopConversation = "true",
	options = {}
}
dinge_convo_template:addScreen(train_player_basics);

train_player_droid = ConvoScreen:new {
	id = "train_player_droid",
	leftDialog = "@conversation/naboo_privateer_trainer_1:s_cd72f93", -- Good choice.
	stopConversation = "true",
	options = {}
}
dinge_convo_template:addScreen(train_player_droid);

-- Duty Missions
duty_missions = ConvoScreen:new {
	id = "duty_missions",
	leftDialog = "@conversation/naboo_privateer_trainer_1:s_63336624", -- Ready for an assignment? We have some duty missions available.
	stopConversation = "false",
	options = {
		{"@conversation/naboo_privateer_trainer_1:s_e814cf37", "duty_options"}, -- I would like a duty mission.
		{"@conversation/naboo_privateer_trainer_1:s_6106187c", "what_is_duty"}, -- What is a duty mission?
		{"@conversation/naboo_privateer_trainer_1:s_2883b989", "not_ready"}, -- Not right now, thanks.
	}
}
dinge_convo_template:addScreen(duty_missions);

what_is_duty = ConvoScreen:new {
	id = "what_is_duty",
	leftDialog = "@conversation/naboo_privateer_trainer_1:s_a8cdf3dc", -- A duty mission is an open-ended task. That means that there is no true end to it, you just finish whenever you're ready. It's a good way to earn experience to prepare yourself for training. So, what do you say?
	stopConversation = "false",
	options = {
		{"@conversation/naboo_privateer_trainer_1:s_e814cf37", "duty_options"}, -- I would like a duty mission.
		{"@conversation/naboo_privateer_trainer_1:s_2883b989", "not_ready"}, -- Not right now, thanks.
	}
}
dinge_convo_template:addScreen(what_is_duty);

duty_options = ConvoScreen:new {
	id = "duty_options",
	leftDialog = "@conversation/naboo_privateer_trainer_1:s_e38f886b", -- Good, good. We have a couple to choose from. You can either fight the Black Sun menace in a Destroy Duty, or you can assist the merchant freighters with an Escort Duty.
	stopConversation = "false",
	options = {
		{"@conversation/naboo_privateer_trainer_1:s_40759c25", "destroy_duty"}, -- I want Destroy Duty
		{"@conversation/naboo_privateer_trainer_1:s_629c7d23", "escort_duty"}, -- I want Escort Duty
	}
}
dinge_convo_template:addScreen(duty_options);

destroy_duty = ConvoScreen:new {
	id = "destroy_duty",
	leftDialog = "@conversation/naboo_privateer_trainer_1:s_6575e5d0", -- Get up there and put those Black Sun in their place.
	stopConversation = "true",
	options = {}
}
dinge_convo_template:addScreen(destroy_duty);

escort_duty = ConvoScreen:new {
	id = "escort_duty",
	leftDialog = "@conversation/naboo_privateer_trainer_1:s_90b16aa7", -- We'll pay for every transport that makes it through.
	stopConversation = "true",
	options = {}
}
dinge_convo_template:addScreen(escort_duty);

-- Completed Tier 1 - Go to Captain Kaydine
completed_tier1 = ConvoScreen:new {
	id = "completed_tier1",
	leftDialog = "@conversation/naboo_privateer_trainer_1:s_7c4368e", -- You have accomplished all the tasks I have set for you. Are you ready for some more advanced work?
	stopConversation = "false",
	options = {
		{"@conversation/naboo_privateer_trainer_1:s_5c522568", "go_to_tier2"}, -- Yes, of course.
		{"@conversation/naboo_privateer_trainer_1:s_2883b989", "not_ready"}, -- Not right now, thanks.
	}
}
dinge_convo_template:addScreen(completed_tier1);

go_to_tier2 = ConvoScreen:new {
	id = "go_to_tier2",
	leftDialog = "@conversation/naboo_privateer_trainer_1:s_919029b", -- Go see Captain Kaydine. He is in one of the large meeting rooms upstairs here in the palace. Should be easy to find, just follow the ego.
	stopConversation = "true",
	options = {}
}
dinge_convo_template:addScreen(go_to_tier2);

--[[

	Tier 4

]]

-- Tier 4 - Active Mission
tier4_on_mission = ConvoScreen:new {
	id = "tier4_on_mission",
	leftDialog = "@conversation/naboo_privateer_tier4:s_67b2bdc1", -- Hurry up. It's time to get back to work.
	stopConversation = "true",
	options = {}
}
dinge_convo_template:addScreen(tier4_on_mission);

-- Tier 4 - Initial Briefing
tier4_initial_briefing = ConvoScreen:new {
	id = "tier4_initial_briefing",
	leftDialog = "@conversation/naboo_privateer_tier4:s_cdffba3e", -- Tsk. You're late. That's not a good way to start your tour with me, pilot. Are you ready to begin? I have a briefing prepped for you.
	stopConversation = "false",
	options = {
		{"@conversation/naboo_privateer_tier4:s_c82e9a2f", "tier4_first_mission"}, -- Yes, please.
	}
}
dinge_convo_template:addScreen(tier4_initial_briefing);

-- Tier 4 - Mission 1 (Escort the deep space scan vessel - Endor)
tier4_first_mission = ConvoScreen:new {
	id = "tier4_first_mission",
	leftDialog = "@conversation/naboo_privateer_tier4:s_a82676b8", -- Royal Security Forces are using a deep space scan vessel in Endor space.
	stopConversation = "false",
	options = {
		{"@conversation/naboo_privateer_tier4:s_b2e340f6", "tier4_first_mission_details"}, -- What's that?
		{"@conversation/naboo_privateer_tier4:s_d55f2579", "accept_tier4_first_mission"}, -- I'm ready to go.
	}
}
dinge_convo_template:addScreen(tier4_first_mission);

tier4_first_mission_details = ConvoScreen:new {
	id = "tier4_first_mission_details",
	leftDialog = "@conversation/naboo_privateer_tier4:s_a224e8fe", -- A deep space scan vessel. It's an RSF ship. We're using it to investigate Endor space.
	stopConversation = "false",
	options = {
		{"@conversation/naboo_privateer_tier4:s_d55f2579", "accept_tier4_first_mission"}, -- I'm ready to go.
	}
}
dinge_convo_template:addScreen(tier4_first_mission_details);

accept_tier4_first_mission = ConvoScreen:new {
	id = "accept_tier4_first_mission",
	leftDialog = "@conversation/naboo_privateer_tier4:s_90422eb5", -- Good luck.
	stopConversation = "true",
	options = {}
}
dinge_convo_template:addScreen(accept_tier4_first_mission);

failed_tier4_first_mission = ConvoScreen:new {
	id = "failed_tier4_first_mission",
	leftDialog = "@conversation/naboo_privateer_tier4:s_d858532", -- Get out there and try again.
	stopConversation = "true",
	options = {}
}
dinge_convo_template:addScreen(failed_tier4_first_mission);

tier4_first_mission_success = ConvoScreen:new {
	id = "tier4_first_mission_success",
	leftDialog = "@conversation/naboo_privateer_tier4:s_bdc28bb4", -- You did a nice job protecting that scan vessel. We took a look at the tapes.
	stopConversation = "false",
	options = {
		{"@conversation/naboo_privateer_tier4:s_8289ab5b", "tier4_second_mission"}, -- I'm ready for my next mission.
	}
}
dinge_convo_template:addScreen(tier4_first_mission_success);

-- Tier 4 - Mission 2 (Inspect the heavy mining freighter - Endor)
tier4_second_mission = ConvoScreen:new {
	id = "tier4_second_mission",
	leftDialog = "@conversation/naboo_privateer_tier4:s_9145ef83", -- Listen. There's a heavy mining freighter passing through Endor space.
	stopConversation = "false",
	options = {
		{"@conversation/naboo_privateer_tier4:s_25f8ac14", "tier4_second_mission_details"}, -- What's it carrying?
		{"@conversation/naboo_privateer_tier4:s_d55f2579", "accept_tier4_second_mission"}, -- I'm ready to go.
	}
}
dinge_convo_template:addScreen(tier4_second_mission);

tier4_second_mission_details = ConvoScreen:new {
	id = "tier4_second_mission_details",
	leftDialog = "@conversation/naboo_privateer_tier4:s_88678c75", -- Supplies, a few passengers, nothing special.
	stopConversation = "false",
	options = {
		{"@conversation/naboo_privateer_tier4:s_8462774c", "tier4_second_mission_go"}, -- So I should inspect the ship.
	}
}
dinge_convo_template:addScreen(tier4_second_mission_details);

tier4_second_mission_go = ConvoScreen:new {
	id = "tier4_second_mission_go",
	leftDialog = "@conversation/naboo_privateer_tier4:s_87246f3e", -- You got it. Go check it out. And I don't mean one quick pass, either. Take a GOOD look...
	stopConversation = "false",
	options = {
		{"@conversation/naboo_privateer_tier4:s_d55f2579", "accept_tier4_second_mission"}, -- I'm ready to go.
	}
}
dinge_convo_template:addScreen(tier4_second_mission_go);

accept_tier4_second_mission = ConvoScreen:new {
	id = "accept_tier4_second_mission",
	leftDialog = "@conversation/naboo_privateer_tier4:s_9281abbb", -- Go get 'em, tiger.
	stopConversation = "true",
	options = {}
}
dinge_convo_template:addScreen(accept_tier4_second_mission);

failed_tier4_second_mission = ConvoScreen:new {
	id = "failed_tier4_second_mission",
	leftDialog = "@conversation/naboo_privateer_tier4:s_d858532", -- Get out there and try again.
	stopConversation = "true",
	options = {}
}
dinge_convo_template:addScreen(failed_tier4_second_mission);

tier4_second_mission_success = ConvoScreen:new {
	id = "tier4_second_mission_success",
	leftDialog = "@conversation/naboo_privateer_tier4:s_41799e3b", -- You did good. I have a new mission for you.
	stopConversation = "false",
	options = {
		{"@conversation/naboo_privateer_tier4:s_614d7ac4", "tier4_third_mission"}, -- What is the mission?
	}
}
dinge_convo_template:addScreen(tier4_second_mission_success);

-- Tier 4 - Mission 3 (Imperial freighter go-between - Yavin)
tier4_third_mission = ConvoScreen:new {
	id = "tier4_third_mission",
	leftDialog = "@conversation/naboo_privateer_tier4:s_b5ee61ed", -- A pair of Imperial freighters have entered Yavin space...
	stopConversation = "false",
	options = {
		{"@conversation/naboo_privateer_tier4:s_77e48d5b", "tier4_third_mission_details"}, -- What do you mean?
		{"@conversation/naboo_privateer_tier4:s_d55f2579", "accept_tier4_third_mission"}, -- I'm ready to go.
	}
}
dinge_convo_template:addScreen(tier4_third_mission);

tier4_third_mission_details = ConvoScreen:new {
	id = "tier4_third_mission_details",
	leftDialog = "@conversation/naboo_privateer_tier4:s_7378bc13", -- You know how testy Imperial freighter captains can be...
	stopConversation = "false",
	options = {
		{"@conversation/naboo_privateer_tier4:s_d55f2579", "accept_tier4_third_mission"}, -- I'm ready to go.
	}
}
dinge_convo_template:addScreen(tier4_third_mission_details);

accept_tier4_third_mission = ConvoScreen:new {
	id = "accept_tier4_third_mission",
	leftDialog = "@conversation/naboo_privateer_tier4:s_ff66ed8b", -- You don't have to love 'em. You just have to keep 'em happy. Get out there and take care of those captains.
	stopConversation = "true",
	options = {}
}
dinge_convo_template:addScreen(accept_tier4_third_mission);

failed_tier4_third_mission = ConvoScreen:new {
	id = "failed_tier4_third_mission",
	leftDialog = "@conversation/naboo_privateer_tier4:s_d858532", -- Get out there and try again.
	stopConversation = "true",
	options = {}
}
dinge_convo_template:addScreen(failed_tier4_third_mission);

tier4_third_mission_success = ConvoScreen:new {
	id = "tier4_third_mission_success",
	leftDialog = "@conversation/naboo_privateer_tier4:s_44b1cd3c", -- Mm. We'll see. Let's get you going on a new mission.
	stopConversation = "false",
	options = {
		{"@conversation/naboo_privateer_tier4:s_614d7ac4", "tier4_fourth_mission"}, -- What is the mission?
	}
}
dinge_convo_template:addScreen(tier4_third_mission_success);

-- Tier 4 - Mission 4 (Sortie against the Black Sun - Yavin)
tier4_fourth_mission = ConvoScreen:new {
	id = "tier4_fourth_mission",
	leftDialog = "@conversation/naboo_privateer_tier4:s_1cf9a0f6", -- I've saved the best for last. I need a pilot willing to fly sorties against Black Sun pirates...
	stopConversation = "false",
	options = {
		{"@conversation/naboo_privateer_tier4:s_e9ea6fec", "tier4_fourth_mission_details"}, -- Good. Because I want to go after them.
		{"@conversation/naboo_privateer_tier4:s_d55f2579", "accept_tier4_fourth_mission"}, -- I'm ready to go.
	}
}
dinge_convo_template:addScreen(tier4_fourth_mission);

tier4_fourth_mission_details = ConvoScreen:new {
	id = "tier4_fourth_mission_details",
	leftDialog = "@conversation/naboo_privateer_tier4:s_fd271a84", -- You read my mind. But this time, you're not going alone. We need a show of force. You'll be joining a fleet of RSF pilots in a sortie against the Black Sun.
	stopConversation = "false",
	options = {
		{"@conversation/naboo_privateer_tier4:s_d55f2579", "accept_tier4_fourth_mission"}, -- I'm ready to go.
	}
}
dinge_convo_template:addScreen(tier4_fourth_mission_details);

accept_tier4_fourth_mission = ConvoScreen:new {
	id = "accept_tier4_fourth_mission",
	leftDialog = "@conversation/naboo_privateer_tier4:s_9281abbb", -- Go get 'em, tiger.
	stopConversation = "true",
	options = {}
}
dinge_convo_template:addScreen(accept_tier4_fourth_mission);

failed_tier4_fourth_mission = ConvoScreen:new {
	id = "failed_tier4_fourth_mission",
	leftDialog = "@conversation/naboo_privateer_tier4:s_a9d8ef68", -- Give it another shot. Those Black Suns aren't so tough.
	stopConversation = "true",
	options = {}
}
dinge_convo_template:addScreen(failed_tier4_fourth_mission);

-- Tier 4 - Mission 4 Complete / Master hand-off (Grand Admiral Declann - Kessel)
tier4_fourth_mission_success = ConvoScreen:new {
	id = "tier4_fourth_mission_success",
	leftDialog = "@conversation/naboo_privateer_tier4:s_92fa7352", -- I have just been informed that Grand Admiral Nial Declann has ordered that you be transferred to his squadron, effective immediately...
	stopConversation = "false",
	options = {
		{"@conversation/naboo_privateer_tier4:s_9fe8c7e7", "master_what_want"}, -- Does it say what they want from me?
		{"@conversation/naboo_privateer_tier4:s_7177c3f2", "master_who_declann"}, -- Who is Grand Admiral Nial Declann?
		{"@conversation/naboo_privateer_tier4:s_50d4081c", "master_where_report"}, -- Where do I report?
		{"@conversation/naboo_privateer_tier4:s_57f232d6", "master_becoming_imperial"}, -- I am going to become an Imperial?
		{"@conversation/naboo_privateer_tier4:s_1adbadc4", "accept_master_mission"}, -- I'm ready.
	}
}
dinge_convo_template:addScreen(tier4_fourth_mission_success);

master_mission = ConvoScreen:new {
	id = "master_mission",
	leftDialog = "@conversation/naboo_privateer_tier4:s_92fa7352", -- I have just been informed that Grand Admiral Nial Declann has ordered that you be transferred to his squadron, effective immediately...
	stopConversation = "false",
	options = {
		{"@conversation/naboo_privateer_tier4:s_9fe8c7e7", "master_what_want"}, -- Does it say what they want from me?
		{"@conversation/naboo_privateer_tier4:s_7177c3f2", "master_who_declann"}, -- Who is Grand Admiral Nial Declann?
		{"@conversation/naboo_privateer_tier4:s_50d4081c", "master_where_report"}, -- Where do I report?
		{"@conversation/naboo_privateer_tier4:s_57f232d6", "master_becoming_imperial"}, -- I am going to become an Imperial?
		{"@conversation/naboo_privateer_tier4:s_1adbadc4", "accept_master_mission"}, -- I'm ready.
	}
}
dinge_convo_template:addScreen(master_mission);

master_what_want = ConvoScreen:new {
	id = "master_what_want",
	leftDialog = "@conversation/naboo_privateer_tier4:s_492a501d", -- I wish I knew! That's highly classified information. The Admiral will explain everything to you. Pack your bags! The Admiral is waiting.
	stopConversation = "false",
	options = {
		{"@conversation/naboo_privateer_tier4:s_1adbadc4", "accept_master_mission"}, -- I'm ready.
	}
}
dinge_convo_template:addScreen(master_what_want);

master_who_declann = ConvoScreen:new {
	id = "master_who_declann",
	leftDialog = "@conversation/naboo_privateer_tier4:s_cf0a01fd", -- Well, let me put it this way. In the Imperial Navy, power is held by only a few men...
	stopConversation = "false",
	options = {
		{"@conversation/naboo_privateer_tier4:s_1adbadc4", "accept_master_mission"}, -- I'm ready.
	}
}
dinge_convo_template:addScreen(master_who_declann);

master_where_report = ConvoScreen:new {
	id = "master_where_report",
	leftDialog = "@conversation/naboo_privateer_tier4:s_cd140a4", -- According to this, you are to report directly to the Grand Admiral at the Theed Palace...
	stopConversation = "false",
	options = {
		{"@conversation/naboo_privateer_tier4:s_1adbadc4", "accept_master_mission"}, -- I'm ready.
	}
}
dinge_convo_template:addScreen(master_where_report);

master_becoming_imperial = ConvoScreen:new {
	id = "master_becoming_imperial",
	leftDialog = "@conversation/naboo_privateer_tier4:s_5d72fdfa", -- Well, not officially. But this is a big opportunity for you. You will be working under them until they no longer are in need of your services. You will retain all of your RSF rankings and privileges.
	stopConversation = "false",
	options = {
		{"@conversation/naboo_privateer_tier4:s_1adbadc4", "accept_master_mission"}, -- I'm ready.
	}
}
dinge_convo_template:addScreen(master_becoming_imperial);

accept_master_mission = ConvoScreen:new {
	id = "accept_master_mission",
	leftDialog = "@conversation/naboo_privateer_tier4:s_42d6c3ee", -- Go on. Your ship is waiting.
	stopConversation = "true",
	options = {}
}
dinge_convo_template:addScreen(accept_master_mission);

-- Tier 4 - Post-master
tier4_completed = ConvoScreen:new {
	id = "tier4_completed",
	leftDialog = "@conversation/naboo_privateer_tier4:s_bd35f50b", -- I see you made it back from serving with the Empire in one piece. I am very glad of that. I have some jobs for you if you are interested.
	stopConversation = "false",
	options = {
		{"@conversation/naboo_privateer_tier4:s_85a73c8b", "tier4_duty_repeat"}, -- So do you have a mission for me?
	}
}
dinge_convo_template:addScreen(tier4_completed);

-- Tier 4 - Training
ready_train_tier4 = ConvoScreen:new {
	id = "ready_train_tier4",
	leftDialog = "@conversation/naboo_privateer_tier4:s_d91c04b2", -- I'm supposed to give you a skill. Hurry up. Let's get this over with.
	stopConversation = "false",
	options = {
		-- Options added dynamically via handler
	}
}
dinge_convo_template:addScreen(ready_train_tier4);

tier4_train_fighters = ConvoScreen:new {
	id = "tier4_train_fighters",
	leftDialog = "@conversation/naboo_privateer_trainer_1:s_cd72f93", -- Good choice.
	stopConversation = "true",
	options = {}
}
dinge_convo_template:addScreen(tier4_train_fighters);

tier4_train_component = ConvoScreen:new {
	id = "tier4_train_component",
	leftDialog = "@conversation/naboo_privateer_trainer_1:s_cd72f93", -- Good choice.
	stopConversation = "true",
	options = {}
}
dinge_convo_template:addScreen(tier4_train_component);

tier4_train_basics = ConvoScreen:new {
	id = "tier4_train_basics",
	leftDialog = "@conversation/naboo_privateer_trainer_1:s_cd72f93", -- Good choice.
	stopConversation = "true",
	options = {}
}
dinge_convo_template:addScreen(tier4_train_basics);

tier4_train_droid = ConvoScreen:new {
	id = "tier4_train_droid",
	leftDialog = "@conversation/naboo_privateer_trainer_1:s_cd72f93", -- Good choice.
	stopConversation = "true",
	options = {}
}
dinge_convo_template:addScreen(tier4_train_droid);

-- Tier 4 - Duty Missions
tier4_duty_missions = ConvoScreen:new {
	id = "tier4_duty_missions",
	leftDialog = "@conversation/naboo_privateer_tier4:s_24231574", -- That's a nice attitude for a pilot to have. Actually, I do have some duty missions to assign. Take a look at what there is. Shall I give you a briefing?
	stopConversation = "false",
	options = {
		{"@conversation/naboo_privateer_tier4:s_e1e40ead", "tier4_duty_brief_destroy"}, -- That would be nice.
	}
}
dinge_convo_template:addScreen(tier4_duty_missions);

tier4_duty_repeat = ConvoScreen:new {
	id = "tier4_duty_repeat",
	leftDialog = "@conversation/naboo_privateer_tier4:s_3f76a413", -- I like it when my pilots stay busy. Why don't you volunteer for something? Or I can give you the briefing again, if you like.
	stopConversation = "false",
	options = {
		{"@conversation/naboo_privateer_tier4:s_62c8be58", "accept_tier4_duty1"}, -- I can handle those Black Suns.
		{"@conversation/naboo_privateer_tier4:s_619658af", "accept_tier4_duty2"}, -- I'll escort that mining transport.
		{"@conversation/naboo_privateer_tier4:s_7869de8a", "accept_tier4_duty3"}, -- What's wrong with that Ay'Nat ship?
		{"@conversation/naboo_privateer_tier4:s_413ac49a", "accept_tier4_duty4"}, -- I want to help that mining craft.
		{"@conversation/naboo_privateer_tier4:s_70d61202", "tier4_duty_brief_destroy"}, -- Please, give me the briefing again.
	}
}
dinge_convo_template:addScreen(tier4_duty_repeat);

tier4_duty_brief_destroy = ConvoScreen:new {
	id = "tier4_duty_brief_destroy",
	leftDialog = "@conversation/naboo_privateer_tier4:s_1cf9a0f6", -- I've saved the best for last. I need a pilot willing to fly sorties against Black Sun pirates. Dangerous, but fun. Especially for a big strong pilot like you.
	stopConversation = "false",
	options = {
		{"@conversation/naboo_privateer_tier4:s_2836e6b5", "tier4_duty_brief_escort"}, -- OK.
	}
}
dinge_convo_template:addScreen(tier4_duty_brief_destroy);

tier4_duty_brief_escort = ConvoScreen:new {
	id = "tier4_duty_brief_escort",
	leftDialog = "@conversation/naboo_privateer_tier4:s_5603b2a1", -- Now listen up and pay attention. I hate repeating myself. I need a pilot to escort a Naboo mining transport through Endor space. I'll warn you, Borvo the Hutt's men will probably be interested in that transport.
	stopConversation = "false",
	options = {
		{"@conversation/naboo_privateer_tier4:s_2836e6b5", "tier4_duty_brief_recovery"}, -- OK.
	}
}
dinge_convo_template:addScreen(tier4_duty_brief_escort);

tier4_duty_brief_recovery = ConvoScreen:new {
	id = "tier4_duty_brief_recovery",
	leftDialog = "@conversation/naboo_privateer_tier4:s_8ca0b65b", -- If you have a thing against the Ay'Nat, you could help me out by capturing one of their private vessels.
	stopConversation = "false",
	options = {
		{"@conversation/naboo_privateer_tier4:s_2836e6b5", "tier4_duty_menu"}, -- OK.
	}
}
dinge_convo_template:addScreen(tier4_duty_brief_recovery);

tier4_duty_menu = ConvoScreen:new {
	id = "tier4_duty_menu",
	leftDialog = "@conversation/naboo_privateer_tier4:s_1993702c", -- If you're feeling like a hero today, you could rescue a Naboo mining craft from Ay'Nat pirates.
	stopConversation = "false",
	options = {
		{"@conversation/naboo_privateer_tier4:s_62c8be58", "accept_tier4_duty1"}, -- I can handle those Black Suns.
		{"@conversation/naboo_privateer_tier4:s_619658af", "accept_tier4_duty2"}, -- I'll escort that mining transport.
		{"@conversation/naboo_privateer_tier4:s_7869de8a", "accept_tier4_duty3"}, -- What's wrong with that Ay'Nat ship?
		{"@conversation/naboo_privateer_tier4:s_413ac49a", "accept_tier4_duty4"}, -- I want to help that mining craft.
		{"@conversation/naboo_privateer_tier4:s_70d61202", "tier4_duty_brief_destroy"}, -- Please, give me the briefing again.
	}
}
dinge_convo_template:addScreen(tier4_duty_menu);

accept_tier4_duty1 = ConvoScreen:new {
	id = "accept_tier4_duty1",
	leftDialog = "@conversation/naboo_privateer_tier4:s_9281abbb", -- Go get 'em, tiger.
	stopConversation = "true",
	options = {}
}
dinge_convo_template:addScreen(accept_tier4_duty1);

accept_tier4_duty2 = ConvoScreen:new {
	id = "accept_tier4_duty2",
	leftDialog = "@conversation/naboo_privateer_tier4:s_90422eb5", -- Good luck.
	stopConversation = "true",
	options = {}
}
dinge_convo_template:addScreen(accept_tier4_duty2);

accept_tier4_duty3 = ConvoScreen:new {
	id = "accept_tier4_duty3",
	leftDialog = "@conversation/naboo_privateer_tier4:s_42d6c3ee", -- Go on. Your ship is waiting.
	stopConversation = "true",
	options = {}
}
dinge_convo_template:addScreen(accept_tier4_duty3);

accept_tier4_duty4 = ConvoScreen:new {
	id = "accept_tier4_duty4",
	leftDialog = "@conversation/naboo_privateer_tier4:s_9750cd6f", -- Lucky miners! Have fun.
	stopConversation = "true",
	options = {}
}
dinge_convo_template:addScreen(accept_tier4_duty4);

addConversationTemplate("dinge_convo_template", dinge_convo_template);
