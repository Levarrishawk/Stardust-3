--[[
	Hakasha Sireen -- Black Epsilon Squadron (Imperial) Tier 1 recruiter/trainer conversation.

	Structural port of the proven Inquisition recruiter template, driven by the
	authentic Live Imperial trainer string file extracted from the client TRE:
		string/en/conversation/corellia_imperial_trainer_1.stf
	Every leftDialog / option below references a real @conversation/corellia_imperial_trainer_1:s_<hash>
	string from that table (English text shown in the trailing comment, verified against the
	extracted STF). Screen-flow control lives in hakasshaSireenConvoHandler.lua.

	Quest ladder follows the real Black Epsilon storyline told by the STF:
		Q1 patrol (fly a lone TIE near Coronet, bait and eliminate the Rebel patrol) ->
		Q2 destroy (find and destroy the B-Wing prototype) ->
		Q3 escort (escort the explosives transport safely to Coronet orbit) ->
		Q4 destroy the Rebel X-Wing trainees ->
		training -> promotion -> go see Prisk.

	Every option link target below is a defined screen (the base conv_handler falls back to
	the initial screen when a link target is missing, which presents as "clicking does nothing").
]]

hakassha_sireen_convo = ConvoTemplate:new {
	initialScreen = "",
	templateType = "Lua",
	luaClassHandler = "hakasshaSireenConvoHandler",
	screens = {}
}

-- JTL Disabled / No Space Expansion
hakassha_sireen_convo_no_jtl = ConvoScreen:new {
	id = "no_jtl",
	leftDialog = "@conversation/corellia_imperial_trainer_1:s_12d7f011", -- This is a serious operation, hon. Get a drink and chill out. Come back when you want to try this thing again.
	stopConversation = "true",
	options = {}
}
hakassha_sireen_convo:addScreen(hakassha_sireen_convo_no_jtl)

-- Rebel Pilot (turned away)
hakassha_sireen_convo_rebel_pilot = ConvoScreen:new {
	id = "rebel_pilot",
	leftDialog = "@conversation/corellia_imperial_trainer_1:s_bf5586b8", -- Sorry, I don't deal with Rebels.
	stopConversation = "true",
	animation = "point_accusingly",
	options = {}
}
hakassha_sireen_convo:addScreen(hakassha_sireen_convo_rebel_pilot)

-- Neutral/Privateer Pilot (turned away)
hakassha_sireen_convo_neutral_pilot = ConvoScreen:new {
	id = "neutral_pilot",
	leftDialog = "@conversation/corellia_imperial_trainer_1:s_9e6137e3", -- I think I recognize you. You're on a wanted list I think... I can't work with known members of criminal organizations.
	stopConversation = "true",
	animation = "shrug_shoulders",
	options = {}
}
hakassha_sireen_convo:addScreen(hakassha_sireen_convo_neutral_pilot)

-- Imperial pilot, different squadron
hakassha_sireen_convo_non_inquisition_pilot = ConvoScreen:new {
	id = "non_inquisition_pilot",
	leftDialog = "@conversation/corellia_imperial_trainer_1:s_2efb24e9", -- You're an Imperial pilot? Too bad you're already assigned to another unit. I'd be sure you'd make a fine addition to the Epsilon. What brings you here?
	stopConversation = "false",
	options = {
		{"@conversation/corellia_imperial_trainer_1:s_29e5ec7", "duty_missions"}, -- I'd like to request a mission.
	}
}
hakassha_sireen_convo:addScreen(hakassha_sireen_convo_non_inquisition_pilot)

--[[ Recruitment flow ]]
hakassha_sireen_convo_recruitment = ConvoScreen:new {
	id = "recruitment",
	leftDialog = "@conversation/corellia_imperial_trainer_1:s_f93af369", -- You're a pilot? Interesting... Yes, I'm looking to hire a pilot. The job isn't easy and you'll have to work with minimal information. You'll be shot at. Probably have to kill some people, too. Sure you want this kind of work?
	stopConversation = "false",
	options = {
		{"@conversation/corellia_imperial_trainer_1:s_4b5d9495", "yes_join"}, -- Alright. What's the job?
		{"@conversation/corellia_imperial_trainer_1:s_92a51c16", "why_volunteers"}, -- Does this job pay?
		{"@conversation/corellia_imperial_trainer_1:s_7f96a397", "decline_join"}, -- On second thought. No thanks.
	}
}
hakassha_sireen_convo:addScreen(hakassha_sireen_convo_recruitment)

hakassha_sireen_convo_why_volunteers = ConvoScreen:new {
	id = "why_volunteers",
	leftDialog = "@conversation/corellia_imperial_trainer_1:s_c7c75ec4", -- Right to the point. I like that. Yeah, it pays. Imperial credits and the opportunity for our relationship to get... closer. Of course, all of this depends upon your discretion. Tell someone about the job and you'll be paid with a different kind of currency.
	stopConversation = "false",
	options = {
		{"@conversation/corellia_imperial_trainer_1:s_4b5d9495", "yes_join"}, -- Alright. What's the job?
		{"@conversation/corellia_imperial_trainer_1:s_7f96a397", "decline_join"}, -- On second thought. No thanks.
	}
}
hakassha_sireen_convo:addScreen(hakassha_sireen_convo_why_volunteers)

hakassha_sireen_convo_decline_join = ConvoScreen:new {
	id = "decline_join",
	leftDialog = "@conversation/corellia_imperial_trainer_1:s_3e935b51", -- Suit yourself, hon. Come and visit again sometime.
	stopConversation = "true",
	animation = "goodbye",
	options = {}
}
hakassha_sireen_convo:addScreen(hakassha_sireen_convo_decline_join)

-- Player asked to join; the handler redirects this to "join_confirm". Defined with the
-- same content as join_confirm so the flow is intact even without the handler redirect.
hakassha_sireen_convo_yes_join = ConvoScreen:new {
	id = "yes_join",
	leftDialog = "@conversation/corellia_imperial_trainer_1:s_f0fc751b", -- Being a supporter is commendable, but for this job I need to know you're loyal. You must swear obedience to the Emperor. Do it now, or walk away.
	stopConversation = "false",
	options = {
		{"@conversation/corellia_imperial_trainer_1:s_845e6ef5", "yes_i_am"}, -- I swear to serve the Emperor, to uphold his law, and to do his will without fail.
		{"@conversation/corellia_imperial_trainer_1:s_54328ce3", "decline_join"}, -- I won't swear to serve the Emperor.
	}
}
hakassha_sireen_convo:addScreen(hakassha_sireen_convo_yes_join)

-- Sign-up confirmation (handler routes "yes_join" here)
hakassha_sireen_convo_join_confirm = ConvoScreen:new {
	id = "join_confirm",
	leftDialog = "@conversation/corellia_imperial_trainer_1:s_f0fc751b", -- Being a supporter is commendable, but for this job I need to know you're loyal. You must swear obedience to the Emperor. Do it now, or walk away.
	stopConversation = "false",
	options = {
		{"@conversation/corellia_imperial_trainer_1:s_845e6ef5", "yes_i_am"}, -- I swear to serve the Emperor, to uphold his law, and to do his will without fail.
		{"@conversation/corellia_imperial_trainer_1:s_54328ce3", "decline_join"}, -- I won't swear to serve the Emperor.
	}
}
hakassha_sireen_convo:addScreen(hakassha_sireen_convo_join_confirm)

-- Enlistment/welcome (handler grants novice box + squadron + tier here, then adds the ship option)
hakassha_sireen_convo_yes_i_am = ConvoScreen:new {
	id = "yes_i_am",
	leftDialog = "@conversation/corellia_imperial_trainer_1:s_d537ac2e", -- So witnessed. Congratulations, hon, you've made a very wise decision. For this operation, you'll need legitimate credentials. From now on, your ID will indicate your status as a Pilot Initiate in the Imperial Navy. My agency will ensure that the Navy records reflect this...half truth.
	stopConversation = "false",
	options = {}
}
hakassha_sireen_convo:addScreen(hakassha_sireen_convo_yes_i_am)

-- No Ship - grants ship
hakassha_sireen_convo_no_ship = ConvoScreen:new {
	id = "no_ship",
	leftDialog = "@conversation/corellia_imperial_trainer_1:s_4bb6ea28", -- Your ship is parked at a starport. I've given you the control codes for a basic TIE fighter by uploading them to your personal datapad. Check your datapad to review your ship status whenever you'd like, sweetie.
	stopConversation = "false",
	animation = "nod_head_multiple",
	options = {
		{"@conversation/corellia_imperial_trainer_1:s_1adbadc4", "yes_im_ready"}, -- I'm ready.
	}
}
hakassha_sireen_convo:addScreen(hakassha_sireen_convo_no_ship)

hakassha_sireen_convo_yes_ship = ConvoScreen:new {
	id = "yes_ship",
	leftDialog = "@conversation/corellia_imperial_trainer_1:s_5a48897a", -- Hey there, hon. Ready to talk business?
	stopConversation = "false",
	options = {
		{"@conversation/corellia_imperial_trainer_1:s_1adbadc4", "yes_im_ready"}, -- I'm ready.
	}
}
hakassha_sireen_convo:addScreen(hakassha_sireen_convo_yes_ship)

--[[ Tier 1 -- Mission 1: Patrol (handler starts patrol_corellia_imperial_1) ]]
hakassha_sireen_convo_yes_im_ready = ConvoScreen:new {
	id = "yes_im_ready",
	leftDialog = "@conversation/corellia_imperial_trainer_1:s_82040511", -- After a fashion. There's plenty of me to reveal later. I want you to fly a patrol in low orbit near Coronet. Use an Imperial TIE fighter. Show the flag. Most importantly, attract the attention of the Rebels. The Rebellion is a violent terrorist organization. They won't be able to resist a lone TIE strutting about in enemy territory. When they move in to shoot you down, eliminate them.
	stopConversation = "true",
	options = {}
}
hakassha_sireen_convo:addScreen(hakassha_sireen_convo_yes_im_ready)

-- Player is on quest 1 and returns before completing it
hakassha_sireen_convo_first_quest_active = ConvoScreen:new {
	id = "first_quest_active",
	leftDialog = "@conversation/corellia_imperial_trainer_1:s_c006779f", -- What do you need, hon? You've got your assignment, and the control device for your ship is set up in your datapad.  You need to go to the Starport and access the starship terminal to launch into space.
	stopConversation = "true",
	options = {}
}
hakassha_sireen_convo:addScreen(hakassha_sireen_convo_first_quest_active)

-- Quest 1 complete, player reports in (handler rewards on "patrol_complete")
hakassha_sireen_convo_excellent_work = ConvoScreen:new {
	id = "excellent_work",
	leftDialog = "@conversation/corellia_imperial_trainer_1:s_2559ccf6", -- Welcome back, babe. Glad to see you're still with us.
	stopConversation = "false",
	options = {
		{"@conversation/corellia_imperial_trainer_1:s_dd5ca133", "patrol_complete"}, -- I was attacked by a CorSec patrol during the mission.
		{"@conversation/corellia_imperial_trainer_1:s_b224e12", "patrol_complete"}, -- It was a close fight, but I came out on top.
	}
}
hakassha_sireen_convo:addScreen(hakassha_sireen_convo_excellent_work)

hakassha_sireen_convo_patrol_complete = ConvoScreen:new {
	id = "patrol_complete",
	leftDialog = "@conversation/corellia_imperial_trainer_1:s_1345d43f", -- Excellent. You seem to understand what it takes to work with Black Epsilon. Our superiors will be pleased. Here's a little payment for the operation.
	stopConversation = "true",
	options = {}
}
hakassha_sireen_convo:addScreen(hakassha_sireen_convo_patrol_complete)

-- Quest 1 failed/aborted
hakassha_sireen_convo_failed_quest1 = ConvoScreen:new {
	id = "failed_quest1",
	leftDialog = "@conversation/corellia_imperial_trainer_1:s_d742dc00", -- Now, hon... just what sort of trouble have you gotten yourself into?
	stopConversation = "false",
	options = {
		{"@conversation/corellia_imperial_trainer_1:s_28490f70", "retry_quest1"}, -- I ran into some trouble, but I'm ready to try again.
	}
}
hakassha_sireen_convo:addScreen(hakassha_sireen_convo_failed_quest1)

-- Quest 1 retry acknowledged (handler restarts patrol_corellia_imperial_1)
hakassha_sireen_convo_retry_quest1 = ConvoScreen:new {
	id = "retry_quest1",
	leftDialog = "@conversation/corellia_imperial_trainer_1:s_6f5dc45e", -- Good to hear it. Let me know when the job is done.
	stopConversation = "true",
	options = {}
}
hakassha_sireen_convo:addScreen(hakassha_sireen_convo_retry_quest1)

--[[ Tier 1 -- Mission 2: Destroy the Rebel cadets (handler starts destroy_corellia_imperial_2 on "quest2_accepted") ]]
hakassha_sireen_convo_grant_quest2 = ConvoScreen:new {
	id = "grant_quest2",
	leftDialog = "@conversation/corellia_imperial_trainer_1:s_11c38900", -- I have discovered that the Rebels are training X-Wing cadets in Corellian space. Destroying the cadets will cripple that effort.
	stopConversation = "false",
	options = {
		{"@conversation/corellia_imperial_trainer_1:s_96682689", "quest2_accepted"}, -- Tell me about the job.
	}
}
hakassha_sireen_convo:addScreen(hakassha_sireen_convo_grant_quest2)

hakassha_sireen_convo_quest2_accepted = ConvoScreen:new {
	id = "quest2_accepted",
	leftDialog = "@conversation/corellia_imperial_trainer_1:s_a074ac18", -- The trainees should not be a match for you, but their instructors might. Hunt them down in the Corellian system.
	stopConversation = "true",
	options = {}
}
hakassha_sireen_convo:addScreen(hakassha_sireen_convo_quest2_accepted)

-- Quest 2 rewarded. The next conversation offers training or duty before Mission 3.
hakassha_sireen_convo_excellent_work2 = ConvoScreen:new {
	id = "excellent_work2",
	leftDialog = "@conversation/corellia_imperial_trainer_1:s_1345d43f", -- Excellent work. Here is your payment for a successful operation.
	stopConversation = "true",
	options = {}
}
hakassha_sireen_convo:addScreen(hakassha_sireen_convo_excellent_work2)

-- Mission 3 accepted (handler starts patrol_corellia_imperial_3 on "train_me3")
hakassha_sireen_convo_train_me3 = ConvoScreen:new {
	id = "train_me3",
	leftDialog = "@conversation/corellia_imperial_trainer_1:s_8dec57cb", -- Glad to see you came with your game face on, because we're going to up the ante. We've got a transport coming into the system soon carrying some delicate cargo. I need you to meet this transport and escort it safely to near Coronet orbit.
	stopConversation = "true",
	options = {}
}
hakassha_sireen_convo:addScreen(hakassha_sireen_convo_train_me3)

hakassha_sireen_convo_failed_quest2 = ConvoScreen:new {
	id = "failed_quest2",
	leftDialog = "@conversation/corellia_imperial_trainer_1:s_da237511", -- I take my job seriously, babe. Get back out there and do it right this time.
	stopConversation = "false",
	options = {
		{"@conversation/corellia_imperial_trainer_1:s_1adbadc4", "retry_quest2"}, -- I'm ready.
	}
}
hakassha_sireen_convo:addScreen(hakassha_sireen_convo_failed_quest2)

-- Quest 2 retry acknowledged (handler restarts destroy_corellia_imperial_2)
hakassha_sireen_convo_retry_quest2 = ConvoScreen:new {
	id = "retry_quest2",
	leftDialog = "@conversation/corellia_imperial_trainer_1:s_a074ac18", -- Hunt down the trainees and their instructors in the Corellian system.
	stopConversation = "true",
	options = {}
}
hakassha_sireen_convo:addScreen(hakassha_sireen_convo_retry_quest2)

--[[ Tier 1 -- Mission 3 report (handler grants the reward on "quest3_rewarded") ]]
hakassha_sireen_convo_excellent_work3 = ConvoScreen:new {
	id = "excellent_work3",
	leftDialog = "@conversation/corellia_imperial_trainer_1:s_cc282429", -- Nice to see you again hon. Are you here for business or pleasure?
	stopConversation = "false",
	options = {
		{"@conversation/corellia_imperial_trainer_1:s_334f003c", "quest3_rewarded"}, -- Nothing to it. Now, you owe me some answers.
		{"@conversation/corellia_imperial_trainer_1:s_659a2365", "quest3_rewarded"}, -- My pay?
	}
}
hakassha_sireen_convo:addScreen(hakassha_sireen_convo_excellent_work3)

hakassha_sireen_convo_quest3_rewarded = ConvoScreen:new {
	id = "quest3_rewarded",
	leftDialog = "@conversation/corellia_imperial_trainer_1:s_885decf4", -- My boys in ground ops say they received the package. Good work. They're going to be moving forward with the dirtier side of the plan soon.
	stopConversation = "true",
	options = {}
}
hakassha_sireen_convo:addScreen(hakassha_sireen_convo_quest3_rewarded)

hakassha_sireen_convo_failed_quest3 = ConvoScreen:new {
	id = "failed_quest3",
	leftDialog = "@conversation/corellia_imperial_trainer_1:s_c890222b", -- I can't believe you failed the escort. This operation is crucial. We don't have much of the explosive to spare!
	stopConversation = "false",
	options = {
		{"@conversation/corellia_imperial_trainer_1:s_88da6887", "retry_quest3"}, -- I ran into some trouble.
	}
}
hakassha_sireen_convo:addScreen(hakassha_sireen_convo_failed_quest3)

-- Quest 3 retry acknowledged (handler restarts patrol_corellia_imperial_3)
hakassha_sireen_convo_retry_quest3 = ConvoScreen:new {
	id = "retry_quest3",
	leftDialog = "@conversation/corellia_imperial_trainer_1:s_8cf0a3be", -- I don't want to hear it. This operation is critical, so we have another transport coming in. Make sure this one arrives.
	stopConversation = "true",
	options = {}
}
hakassha_sireen_convo:addScreen(hakassha_sireen_convo_retry_quest3)

--[[ Tier 1 -- Mission 4: Destroy the ARC-170 prototype (handler starts assassinate_corellia_imperial_4 on "quest4_accepted") ]]
hakassha_sireen_convo_grant_quest4 = ConvoScreen:new {
	id = "grant_quest4",
	leftDialog = "@conversation/corellia_imperial_trainer_1:s_fbd7d1ba", -- Test your mettle against some heavily modified Insurgent technology.
	stopConversation = "false",
	options = {
		{"@conversation/corellia_imperial_trainer_1:s_86c66182", "quest4_accepted"}, -- What's the next step?
	}
}
hakassha_sireen_convo:addScreen(hakassha_sireen_convo_grant_quest4)

hakassha_sireen_convo_quest4_accepted = ConvoScreen:new {
	id = "quest4_accepted",
	leftDialog = "@conversation/corellia_imperial_trainer_1:s_540bd789", -- The Insurgents are testing a heavily armed and armored ARC-170 prototype in the Corellian system. Find it and destroy it.
	stopConversation = "true",
	options = {}
}
hakassha_sireen_convo:addScreen(hakassha_sireen_convo_quest4_accepted)

hakassha_sireen_convo_failed_quest4 = ConvoScreen:new {
	id = "failed_quest4",
	leftDialog = "@conversation/corellia_imperial_trainer_1:s_3ac44381", -- Failure will encourage more investment in experimental ships. Get back up there and bag the ARC-170.
	stopConversation = "false",
	options = {
		{"@conversation/corellia_imperial_trainer_1:s_1adbadc4", "retry_quest4"}, -- I'm ready.
	}
}
hakassha_sireen_convo:addScreen(hakassha_sireen_convo_failed_quest4)

-- Quest 4 retry acknowledged (handler restarts assassinate_corellia_imperial_4)
hakassha_sireen_convo_retry_quest4 = ConvoScreen:new {
	id = "retry_quest4",
	leftDialog = "@conversation/corellia_imperial_trainer_1:s_5dd3c672", -- Report back when you have destroyed the prototype ship.
	stopConversation = "true",
	options = {}
}
hakassha_sireen_convo:addScreen(hakassha_sireen_convo_retry_quest4)

--[[ Player has an active (non-first) mission ]]
hakassha_sireen_convo_has_mission = ConvoScreen:new {
	id = "has_mission",
	leftDialog = "@conversation/corellia_imperial_trainer_1:s_4b074298", -- Come back when you're done with your mission. You can abort your mission if you want to start over.
	stopConversation = "true",
	options = {}
}
hakassha_sireen_convo:addScreen(hakassha_sireen_convo_has_mission)

--[[ All four Tier-1 missions complete -> free training choices (handler builds options) ]]
hakassha_sireen_convo_missions_complete = ConvoScreen:new {
	id = "missions_complete",
	leftDialog = "@conversation/corellia_imperial_trainer_1:s_56b5e7e6", -- Black Epsilon has authorized me to give you special instruction. Field training that will make you a more effective agent.
	stopConversation = "false",
	options = {}
}
hakassha_sireen_convo:addScreen(hakassha_sireen_convo_missions_complete)

--[[ Additional (XP-gated) training (handler builds options) ]]
hakassha_sireen_convo_more_training = ConvoScreen:new {
	id = "more_training",
	leftDialog = "@conversation/corellia_imperial_trainer_1:s_444df4b9", -- You can learn about Imperial technology, TIE weapons, Imperial operations, or astromech management.
	stopConversation = "false",
	options = {}
}
hakassha_sireen_convo:addScreen(hakassha_sireen_convo_more_training)

-- training acknowledgement screens (handler grants the skill then returns the cloned screen)
hakassha_sireen_convo_train_player_fighters = ConvoScreen:new {
	id = "train_player_fighters",
	leftDialog = "@conversation/corellia_imperial_trainer_1:s_7c8aca1b", -- Good choice.  Report back when you are ready for an assignment.
	stopConversation = "true",
	options = {}
}
hakassha_sireen_convo:addScreen(hakassha_sireen_convo_train_player_fighters)

hakassha_sireen_convo_train_player_component = ConvoScreen:new {
	id = "train_player_component",
	leftDialog = "@conversation/corellia_imperial_trainer_1:s_7c8aca1b", -- Good choice.  Report back when you are ready for an assignment.
	stopConversation = "true",
	options = {}
}
hakassha_sireen_convo:addScreen(hakassha_sireen_convo_train_player_component)

hakassha_sireen_convo_train_player_basics = ConvoScreen:new {
	id = "train_player_basics",
	leftDialog = "@conversation/corellia_imperial_trainer_1:s_7c8aca1b", -- Good choice.  Report back when you are ready for an assignment.
	stopConversation = "true",
	options = {}
}
hakassha_sireen_convo:addScreen(hakassha_sireen_convo_train_player_basics)

hakassha_sireen_convo_train_player_droid = ConvoScreen:new {
	id = "train_player_droid",
	leftDialog = "@conversation/corellia_imperial_trainer_1:s_7c8aca1b", -- Good choice.  Report back when you are ready for an assignment.
	stopConversation = "true",
	options = {}
}
hakassha_sireen_convo:addScreen(hakassha_sireen_convo_train_player_droid)

-- free-training variants (same acknowledgement string)
hakassha_sireen_convo_train_player_fighters_free = ConvoScreen:new {
	id = "train_player_fighters_free",
	leftDialog = "@conversation/corellia_imperial_trainer_1:s_7c8aca1b", -- Good choice.  Report back when you are ready for an assignment.
	stopConversation = "true",
	options = {}
}
hakassha_sireen_convo:addScreen(hakassha_sireen_convo_train_player_fighters_free)

hakassha_sireen_convo_train_player_component_free = ConvoScreen:new {
	id = "train_player_component_free",
	leftDialog = "@conversation/corellia_imperial_trainer_1:s_7c8aca1b", -- Good choice.  Report back when you are ready for an assignment.
	stopConversation = "true",
	options = {}
}
hakassha_sireen_convo:addScreen(hakassha_sireen_convo_train_player_component_free)

hakassha_sireen_convo_train_player_basics_free = ConvoScreen:new {
	id = "train_player_basics_free",
	leftDialog = "@conversation/corellia_imperial_trainer_1:s_7c8aca1b", -- Good choice.  Report back when you are ready for an assignment.
	stopConversation = "true",
	options = {}
}
hakassha_sireen_convo:addScreen(hakassha_sireen_convo_train_player_basics_free)

hakassha_sireen_convo_train_player_droid_free = ConvoScreen:new {
	id = "train_player_droid_free",
	leftDialog = "@conversation/corellia_imperial_trainer_1:s_7c8aca1b", -- Good choice.  Report back when you are ready for an assignment.
	stopConversation = "true",
	options = {}
}
hakassha_sireen_convo:addScreen(hakassha_sireen_convo_train_player_droid_free)

--[[ Duty missions (Tier-1 grind: destroy / escort duty) ]]
hakassha_sireen_convo_duty_missions = ConvoScreen:new {
	id = "duty_missions",
	leftDialog = "@conversation/corellia_imperial_trainer_1:s_c1024ba1", -- I'm sure you would, hon. As it so happens, I do have some elective duty missions, if you're interested.
	stopConversation = "false",
	options = {
		{"@conversation/corellia_imperial_trainer_1:s_13e807c3", "destroy_duty"}, -- [Destroy Duty] I'm interested in hunting more B-Wing Prototypes.
		{"@conversation/corellia_imperial_trainer_1:s_79ab4bbe", "escort_duty"}, -- [Escort Duty] I'm interested in escorting transports.
		{"@conversation/corellia_imperial_trainer_1:s_6a128385", "what_is_duty"}, -- What is a duty?
	}
}
hakassha_sireen_convo:addScreen(hakassha_sireen_convo_duty_missions)

hakassha_sireen_convo_what_is_duty = ConvoScreen:new {
	id = "what_is_duty",
	leftDialog = "@conversation/corellia_imperial_trainer_1:s_2ea86030", -- Duty missions are open ended assignments. They end when you choose to end them. For example, if I assign you the task of hunting B-Wing prototypes, you can destroy as many as you want. You can end the duty any time from the mission entry in your datapad. Perform duties to earn additional pay and experience.  Once you've received enough experience, I can teach you new skills.
	stopConversation = "false",
	options = {
		{"@conversation/corellia_imperial_trainer_1:s_13e807c3", "destroy_duty"}, -- [Destroy Duty] I'm interested in hunting more B-Wing Prototypes.
		{"@conversation/corellia_imperial_trainer_1:s_79ab4bbe", "escort_duty"}, -- [Escort Duty] I'm interested in escorting transports.
	}
}
hakassha_sireen_convo:addScreen(hakassha_sireen_convo_what_is_duty)

-- Duty accepted (handler starts destroy_duty_corellia_imperial_6)
hakassha_sireen_convo_destroy_duty = ConvoScreen:new {
	id = "destroy_duty",
	leftDialog = "@conversation/corellia_imperial_trainer_1:s_e3bb98c5", -- The Rebels still have prototype B-Wings in the system. Black Epsilon is paying agents a bounty for any that are destroyed. It helps our cause and it's a good way to hone your combat skills.
	stopConversation = "true",
	options = {}
}
hakassha_sireen_convo:addScreen(hakassha_sireen_convo_destroy_duty)

-- Duty accepted (handler starts escort_duty_corellia_imperial_7)
hakassha_sireen_convo_escort_duty = ConvoScreen:new {
	id = "escort_duty",
	leftDialog = "@conversation/corellia_imperial_trainer_1:s_fb5547eb", -- We still have several key transports moving through the region on a regular basis. Most are ferrying operational supplies for us, but some are carrying equipment for other Imperial agencies. Black Epsilon will pay for every transport you escort safely.
	stopConversation = "true",
	options = {}
}
hakassha_sireen_convo:addScreen(hakassha_sireen_convo_escort_duty)

-- recruitment_not_imperial (Black Epsilon pilot who has left the Imperial faction; must re-commit before continuing)
hakassha_sireen_convo_recruitment_not_imperial = ConvoScreen:new {
	id = "recruitment_not_imperial",
	leftDialog = "@conversation/corellia_imperial_trainer_1:s_683cce3a", -- It is about time you sought a greater commitment to the Empire.  Seek out an Imperial Recruiter to join.  Keep in mind - even as a covert operative - you could be opening yourself to attack when you least expect it.
	stopConversation = "true",
	options = {}
}
hakassha_sireen_convo:addScreen(hakassha_sireen_convo_recruitment_not_imperial)

--[[ Tier 1 complete -> promotion, hand-off to the next trainer ]]
hakassha_sireen_convo_completed_sinkko = ConvoScreen:new {
	id = "completed_sinkko",
	leftDialog = "@conversation/corellia_imperial_trainer_1:s_3599ff41", -- Pilot, you've exceeded my expectations. Black Epsilon was right to recruit you. With any luck, the Emperor's plans for this system will be fulfilled within the year. Come back when you are ready for more work.
	stopConversation = "false",
	options = {
		{"@conversation/corellia_imperial_trainer_1:s_dd67013", "what_is_inquisition"}, -- What does that mean?
		{"@conversation/corellia_imperial_trainer_1:s_32c46e00", "report_to_fazoll"}, -- Where should I go?
	}
}
hakassha_sireen_convo:addScreen(hakassha_sireen_convo_completed_sinkko)

hakassha_sireen_convo_what_is_inquisition = ConvoScreen:new {
	id = "what_is_inquisition",
	leftDialog = "@conversation/corellia_imperial_trainer_1:s_fb05d4a4", -- It's a promotion. Black Epsilon feels you've shown sufficient loyalty and skill to be elevated in rank. You'll be in charge of flying mission critical operations in this region. You may work directly with other agents of the Emperor.
	stopConversation = "false",
	options = {
		{"@conversation/corellia_imperial_trainer_1:s_32c46e00", "report_to_fazoll"}, -- Where should I go?
	}
}
hakassha_sireen_convo:addScreen(hakassha_sireen_convo_what_is_inquisition)

-- Reassignment: grant waypoint to the next trainer (handler sets sireen_finished + waypoint)
hakassha_sireen_convo_report_to_fazoll = ConvoScreen:new {
	id = "report_to_fazoll",
	leftDialog = "@conversation/corellia_imperial_trainer_1:s_f85e6621", -- There is nothing more that I can teach you hon. You need to move on in order to grow.
	stopConversation = "true",
	options = {}
}
hakassha_sireen_convo:addScreen(hakassha_sireen_convo_report_to_fazoll)

-- Player already reassigned, returns to Sireen
hakassha_sireen_convo_go_to_next = ConvoScreen:new {
	id = "go_to_next",
	leftDialog = "@conversation/corellia_imperial_trainer_1:s_62ce5e6e", -- Hiya hon. It's very sweet of you to come back for a visit but you no longer work for me. You should go see Prisk.
	stopConversation = "true",
	options = {}
}
hakassha_sireen_convo:addScreen(hakassha_sireen_convo_go_to_next)

--[[

	Tier 2

]]

-- Tier 2 - Active Mission
hakassha_sireen_convo_tier2_on_mission = ConvoScreen:new {
	id = "tier2_on_mission",
	leftDialog = "@conversation/corellia_imperial_trainer_2:s_ae8492d2",
	stopConversation = "true",
	options = {}
}
hakassha_sireen_convo:addScreen(hakassha_sireen_convo_tier2_on_mission)

-- Tier 2 - Initial Briefing
hakassha_sireen_convo_tier2_initial_briefing = ConvoScreen:new {
	id = "tier2_initial_briefing",
	leftDialog = "@conversation/corellia_imperial_trainer_2:s_74f9775d",
	stopConversation = "false",
	options = {
		{"@conversation/corellia_imperial_trainer_2:s_9edd30bf", "tier2_first_mission"},
	}
}
hakassha_sireen_convo:addScreen(hakassha_sireen_convo_tier2_initial_briefing)

-- Tier 2 - Mission 1
hakassha_sireen_convo_tier2_first_mission = ConvoScreen:new {
	id = "tier2_first_mission",
	leftDialog = "@conversation/corellia_imperial_trainer_2:s_2ee19e18",
	stopConversation = "false",
	options = {
		{"@conversation/corellia_imperial_trainer_2:s_e7f16de3", "tier2_first_mission_details"},
		{"@conversation/corellia_imperial_trainer_2:s_8bf01045", "accept_tier2_first_mission"},
	}
}
hakassha_sireen_convo:addScreen(hakassha_sireen_convo_tier2_first_mission)

hakassha_sireen_convo_tier2_first_mission_details = ConvoScreen:new {
	id = "tier2_first_mission_details",
	leftDialog = "@conversation/corellia_imperial_trainer_2:s_683cbf70",
	stopConversation = "false",
	options = {
		{"@conversation/corellia_imperial_trainer_2:s_8bf01045", "accept_tier2_first_mission"},
	}
}
hakassha_sireen_convo:addScreen(hakassha_sireen_convo_tier2_first_mission_details)

hakassha_sireen_convo_accept_tier2_first_mission = ConvoScreen:new {
	id = "accept_tier2_first_mission",
	leftDialog = "@conversation/corellia_imperial_trainer_2:s_52841755",
	stopConversation = "true",
	options = {}
}
hakassha_sireen_convo:addScreen(hakassha_sireen_convo_accept_tier2_first_mission)

hakassha_sireen_convo_failed_tier2_first_mission = ConvoScreen:new {
	id = "failed_tier2_first_mission",
	leftDialog = "@conversation/corellia_imperial_trainer_2:s_5bfd4371", -- Capture that Hidden Dagger freighter.
	stopConversation = "true",
	options = {}
}
hakassha_sireen_convo:addScreen(hakassha_sireen_convo_failed_tier2_first_mission)

hakassha_sireen_convo_tier2_first_mission_success = ConvoScreen:new {
	id = "tier2_first_mission_success",
	leftDialog = "@conversation/corellia_imperial_trainer_2:s_392fc531",
	stopConversation = "true",
	options = {}
}
hakassha_sireen_convo:addScreen(hakassha_sireen_convo_tier2_first_mission_success)

-- Tier 2 - Mission 2
hakassha_sireen_convo_tier2_second_mission = ConvoScreen:new {
	id = "tier2_second_mission",
	leftDialog = "@conversation/corellia_imperial_trainer_2:s_9a117462", -- I have an assignment for you and it cannot wait.
	stopConversation = "false",
	options = {
		{"@conversation/corellia_imperial_trainer_2:s_6d3be6aa", "accept_tier2_second_mission"}, -- What is the task?
	}
}
hakassha_sireen_convo:addScreen(hakassha_sireen_convo_tier2_second_mission)

hakassha_sireen_convo_accept_tier2_second_mission = ConvoScreen:new {
	id = "accept_tier2_second_mission",
	leftDialog = "@conversation/corellia_imperial_trainer_2:s_8db61bfa", -- Eliminate the Rebel diplomat Darmin Lerspri before he reaches Corellia.
	stopConversation = "true",
	options = {}
}
hakassha_sireen_convo:addScreen(hakassha_sireen_convo_accept_tier2_second_mission)

hakassha_sireen_convo_failed_tier2_second_mission = ConvoScreen:new {
	id = "failed_tier2_second_mission",
	leftDialog = "@conversation/corellia_imperial_trainer_2:s_bae9fe80", -- You failed to dispose of Darmin. Get back up there.
	stopConversation = "true",
	options = {}
}
hakassha_sireen_convo:addScreen(hakassha_sireen_convo_failed_tier2_second_mission)

hakassha_sireen_convo_tier2_second_mission_success = ConvoScreen:new {
	id = "tier2_second_mission_success",
	leftDialog = "@conversation/corellia_imperial_trainer_2:s_e67a0734", -- Darmin will no longer be a thorn in the Empire's side.
	stopConversation = "true",
	options = {}
}
hakassha_sireen_convo:addScreen(hakassha_sireen_convo_tier2_second_mission_success)

-- Tier 2 - Mission 3
hakassha_sireen_convo_tier2_third_mission = ConvoScreen:new {
	id = "tier2_third_mission",
	leftDialog = "@conversation/corellia_imperial_trainer_2:s_98840984", -- A Rebel bomber squadron has been sighted in the system.
	stopConversation = "false",
	options = {
		{"@conversation/corellia_imperial_trainer_2:s_d6dfa36e", "tier2_third_mission_details"}, -- Shouldn't the Navy handle a direct assault?
		{"@conversation/corellia_imperial_trainer_2:s_1ff4247a", "accept_tier2_third_mission"}, -- I will not fail.
	}
}
hakassha_sireen_convo:addScreen(hakassha_sireen_convo_tier2_third_mission)

hakassha_sireen_convo_tier2_third_mission_details = ConvoScreen:new {
	id = "tier2_third_mission_details",
	leftDialog = "@conversation/corellia_imperial_trainer_2:s_2517a327", -- Black Epsilon can do with one craft what takes the Navy ten.
	stopConversation = "false",
	options = {
		{"@conversation/corellia_imperial_trainer_2:s_1ff4247a", "accept_tier2_third_mission"}, -- I will not fail.
	}
}
hakassha_sireen_convo:addScreen(hakassha_sireen_convo_tier2_third_mission_details)

hakassha_sireen_convo_accept_tier2_third_mission = ConvoScreen:new {
	id = "accept_tier2_third_mission",
	leftDialog = "@conversation/corellia_imperial_trainer_2:s_b5a3714a", -- Do not let the bombers reach their objective.
	stopConversation = "true",
	options = {}
}
hakassha_sireen_convo:addScreen(hakassha_sireen_convo_accept_tier2_third_mission)

hakassha_sireen_convo_failed_tier2_third_mission = ConvoScreen:new {
	id = "failed_tier2_third_mission",
	leftDialog = "@conversation/corellia_imperial_trainer_2:s_fe284208", -- Get back up there and finish the Rebels.
	stopConversation = "true",
	options = {}
}
hakassha_sireen_convo:addScreen(hakassha_sireen_convo_failed_tier2_third_mission)

hakassha_sireen_convo_tier2_third_mission_success = ConvoScreen:new {
	id = "tier2_third_mission_success",
	leftDialog = "@conversation/corellia_imperial_trainer_2:s_b69b5bf4", -- The bomber squadron has been destroyed.
	stopConversation = "true",
	options = {}
}
hakassha_sireen_convo:addScreen(hakassha_sireen_convo_tier2_third_mission_success)

-- Tier 2 - Mission 4
hakassha_sireen_convo_tier2_fourth_mission = ConvoScreen:new {
	id = "tier2_fourth_mission",
	leftDialog = "@conversation/corellia_imperial_trainer_2:s_9a117462", -- I have an assignment for you and it cannot wait.
	stopConversation = "false",
	options = {
		{"@conversation/corellia_imperial_trainer_2:s_6d3be6aa", "tier2_fourth_mission_details"},
		{"@conversation/corellia_imperial_trainer_2:s_8bf01045", "accept_tier2_fourth_mission"},
	}
}
hakassha_sireen_convo:addScreen(hakassha_sireen_convo_tier2_fourth_mission)

hakassha_sireen_convo_tier2_fourth_mission_details = ConvoScreen:new {
	id = "tier2_fourth_mission_details",
	leftDialog = "@conversation/corellia_imperial_trainer_2:s_1946850", -- A scanning vessel detected possible Rebel craft in a nebula.
	stopConversation = "false",
	options = {
		{"@conversation/corellia_imperial_trainer_2:s_8bf01045", "accept_tier2_fourth_mission"},
	}
}
hakassha_sireen_convo:addScreen(hakassha_sireen_convo_tier2_fourth_mission_details)

hakassha_sireen_convo_accept_tier2_fourth_mission = ConvoScreen:new {
	id = "accept_tier2_fourth_mission",
	leftDialog = "@conversation/corellia_imperial_trainer_2:s_f4fd144d", -- They will not resist attacking; show them what it means to cross Black Epsilon.
	stopConversation = "true",
	options = {}
}
hakassha_sireen_convo:addScreen(hakassha_sireen_convo_accept_tier2_fourth_mission)

hakassha_sireen_convo_failed_tier2_fourth_mission = ConvoScreen:new {
	id = "failed_tier2_fourth_mission",
	leftDialog = "@conversation/corellia_imperial_trainer_2:s_4cc1cf3b", -- The operation must proceed as planned.
	stopConversation = "true",
	options = {}
}
hakassha_sireen_convo:addScreen(hakassha_sireen_convo_failed_tier2_fourth_mission)

hakassha_sireen_convo_tier2_fourth_mission_success = ConvoScreen:new {
	id = "tier2_fourth_mission_success",
	leftDialog = "@conversation/corellia_imperial_trainer_2:s_9d96ae32", -- You handled the Rebel attack with skill and ruthlessness.
	stopConversation = "true",
	options = {}
}
hakassha_sireen_convo:addScreen(hakassha_sireen_convo_tier2_fourth_mission_success)

-- Tier 2 - Mission 5: recover the personnel dossier
hakassha_sireen_convo_tier2_fifth_mission = ConvoScreen:new {
	id = "tier2_fifth_mission",
	leftDialog = "@conversation/corellia_imperial_trainer_2:s_9a117462", -- I have an assignment for you and it cannot wait.
	stopConversation = "false",
	options = {
		{"@conversation/corellia_imperial_trainer_2:s_6d3be6aa", "accept_tier2_fifth_mission"}, -- What is the task?
	}
}
hakassha_sireen_convo:addScreen(hakassha_sireen_convo_tier2_fifth_mission)

hakassha_sireen_convo_accept_tier2_fifth_mission = ConvoScreen:new {
	id = "accept_tier2_fifth_mission",
	leftDialog = "@conversation/corellia_imperial_trainer_2:s_79813bfb", -- Intercept the freighter and recover the personnel dossier.
	stopConversation = "true",
	options = {}
}
hakassha_sireen_convo:addScreen(hakassha_sireen_convo_accept_tier2_fifth_mission)

hakassha_sireen_convo_failed_tier2_fifth_mission = ConvoScreen:new {
	id = "failed_tier2_fifth_mission",
	leftDialog = "@conversation/corellia_imperial_trainer_2:s_63e01bb7", -- Get back into space and complete your mission.
	stopConversation = "true",
	options = {}
}
hakassha_sireen_convo:addScreen(hakassha_sireen_convo_failed_tier2_fifth_mission)

hakassha_sireen_convo_tier2_fifth_mission_success = ConvoScreen:new {
	id = "tier2_fifth_mission_success",
	leftDialog = "@conversation/corellia_imperial_trainer_2:s_9f952cc3", -- The dossier will be useful to the Inquisition. Here is your payment.
	stopConversation = "true",
	options = {}
}
hakassha_sireen_convo:addScreen(hakassha_sireen_convo_tier2_fifth_mission_success)

-- Tier 2 - Mission 6: eliminate the X-Wing drone and jam the Rebel response
hakassha_sireen_convo_tier2_sixth_mission = ConvoScreen:new {
	id = "tier2_sixth_mission",
	leftDialog = "@conversation/corellia_imperial_trainer_2:s_d9391d4a", -- Your tour is nearly finished; I have one final task.
	stopConversation = "false",
	options = {
		{"@conversation/corellia_imperial_trainer_2:s_9d2c9b0a", "tier2_sixth_mission_details"}, -- More enemy fighter squads?
	}
}
hakassha_sireen_convo:addScreen(hakassha_sireen_convo_tier2_sixth_mission)

hakassha_sireen_convo_tier2_sixth_mission_details = ConvoScreen:new {
	id = "tier2_sixth_mission_details",
	leftDialog = "@conversation/corellia_imperial_trainer_2:s_e978ca6b", -- The Rebels are setting a trap specifically for you.
	stopConversation = "false",
	options = {
		{"@conversation/corellia_imperial_trainer_2:s_7ca4fcb8", "accept_tier2_sixth_mission"}, -- What sort of surprise?
	}
}
hakassha_sireen_convo:addScreen(hakassha_sireen_convo_tier2_sixth_mission_details)

hakassha_sireen_convo_accept_tier2_sixth_mission = ConvoScreen:new {
	id = "accept_tier2_sixth_mission",
	leftDialog = "@conversation/corellia_imperial_trainer_2:s_25edc644", -- Destroy the unmanned fighter near the outer asteroid belts.
	stopConversation = "true",
	options = {}
}
hakassha_sireen_convo:addScreen(hakassha_sireen_convo_accept_tier2_sixth_mission)

hakassha_sireen_convo_failed_tier2_sixth_mission = ConvoScreen:new {
	id = "failed_tier2_sixth_mission",
	leftDialog = "@conversation/corellia_imperial_trainer_2:s_4cc1cf3b", -- The attack and communications disruption must proceed.
	stopConversation = "true",
	options = {}
}
hakassha_sireen_convo:addScreen(hakassha_sireen_convo_failed_tier2_sixth_mission)

hakassha_sireen_convo_tier2_sixth_mission_success = ConvoScreen:new {
	id = "tier2_sixth_mission_success",
	leftDialog = "@conversation/corellia_imperial_trainer_2:s_25457635", -- Good, that is all.
	stopConversation = "true",
	options = {}
}
hakassha_sireen_convo:addScreen(hakassha_sireen_convo_tier2_sixth_mission_success)

-- Tier 2 - Training
hakassha_sireen_convo_ready_train_tier2 = ConvoScreen:new {
	id = "ready_train_tier2",
	leftDialog = "@conversation/corellia_imperial_trainer_2:s_584a90f8",
	stopConversation = "false",
	options = {
		-- Options added dynamically via handler
	}
}
hakassha_sireen_convo:addScreen(hakassha_sireen_convo_ready_train_tier2)

hakassha_sireen_convo_tier2_train_fighters = ConvoScreen:new {
	id = "tier2_train_fighters",
	leftDialog = "@conversation/corellia_imperial_trainer_2:s_3f764ef1",
	stopConversation = "true",
	options = {}
}
hakassha_sireen_convo:addScreen(hakassha_sireen_convo_tier2_train_fighters)

hakassha_sireen_convo_tier2_train_component = ConvoScreen:new {
	id = "tier2_train_component",
	leftDialog = "@conversation/corellia_imperial_trainer_2:s_cc4d7ea",
	stopConversation = "true",
	options = {}
}
hakassha_sireen_convo:addScreen(hakassha_sireen_convo_tier2_train_component)

hakassha_sireen_convo_tier2_train_basics = ConvoScreen:new {
	id = "tier2_train_basics",
	leftDialog = "@conversation/corellia_imperial_trainer_2:s_2517a327",
	stopConversation = "true",
	options = {}
}
hakassha_sireen_convo:addScreen(hakassha_sireen_convo_tier2_train_basics)

hakassha_sireen_convo_tier2_train_droid = ConvoScreen:new {
	id = "tier2_train_droid",
	leftDialog = "@conversation/corellia_imperial_trainer_2:s_c914798f",
	stopConversation = "true",
	options = {}
}
hakassha_sireen_convo:addScreen(hakassha_sireen_convo_tier2_train_droid)

-- Tier 2 - Completed
hakassha_sireen_convo_tier2_completed = ConvoScreen:new {
	id = "tier2_completed",
	leftDialog = "@conversation/corellia_imperial_trainer_2:s_be3a7e31",
	stopConversation = "true",
	options = {}
}
hakassha_sireen_convo:addScreen(hakassha_sireen_convo_tier2_completed)

-- Tier 2 - Duty missions
hakassha_sireen_convo_tier2_duty_repeat = ConvoScreen:new {
	id = "tier2_duty_repeat",
	leftDialog = "@conversation/corellia_imperial_trainer_2:s_ee11d13c",
	stopConversation = "false",
	options = {
		{"@spacequest/destroy_duty/corellia_imperial_8:title", "accept_tier2_duty1"},
		{"@spacequest/escort_duty/corellia_imperial_9:title", "accept_tier2_duty2"},
		{"@spacequest/destroy_duty/corellia_imperial_10:title", "accept_tier2_duty3"},
		{"@spacequest/escort_duty/corellia_imperial_11:title", "accept_tier2_duty4"},
		{"@conversation/corellia_imperial_trainer_2:s_116d8b3b", "tier2_duty_brief1"},
	}
}
hakassha_sireen_convo:addScreen(hakassha_sireen_convo_tier2_duty_repeat)

hakassha_sireen_convo_tier2_duty_brief1 = ConvoScreen:new {
	id = "tier2_duty_brief1",
	leftDialog = "@conversation/corellia_imperial_trainer_2:s_60a52374",
	stopConversation = "false",
	options = {
		{"@conversation/corellia_imperial_trainer_2:s_2c4789b", "tier2_duty_brief2"},
	}
}
hakassha_sireen_convo:addScreen(hakassha_sireen_convo_tier2_duty_brief1)

hakassha_sireen_convo_tier2_duty_brief2 = ConvoScreen:new {
	id = "tier2_duty_brief2",
	leftDialog = "@conversation/corellia_imperial_trainer_2:s_dc33e486",
	stopConversation = "false",
	options = {
		{"@conversation/corellia_imperial_trainer_2:s_2c4789b", "tier2_duty_brief3"},
	}
}
hakassha_sireen_convo:addScreen(hakassha_sireen_convo_tier2_duty_brief2)

hakassha_sireen_convo_tier2_duty_brief3 = ConvoScreen:new {
	id = "tier2_duty_brief3",
	leftDialog = "@conversation/corellia_imperial_trainer_2:s_e8db34a5",
	stopConversation = "false",
	options = {
		{"@conversation/corellia_imperial_trainer_2:s_2c4789b", "tier2_duty_menu"},
	}
}
hakassha_sireen_convo:addScreen(hakassha_sireen_convo_tier2_duty_brief3)

hakassha_sireen_convo_tier2_duty_menu = ConvoScreen:new {
	id = "tier2_duty_menu",
	leftDialog = "@conversation/corellia_imperial_trainer_2:s_60a52374",
	stopConversation = "false",
	options = {
		{"@spacequest/destroy_duty/corellia_imperial_8:title", "accept_tier2_duty1"},
		{"@spacequest/escort_duty/corellia_imperial_9:title", "accept_tier2_duty2"},
		{"@spacequest/destroy_duty/corellia_imperial_10:title", "accept_tier2_duty3"},
		{"@spacequest/escort_duty/corellia_imperial_11:title", "accept_tier2_duty4"},
		{"@conversation/corellia_imperial_trainer_2:s_116d8b3b", "tier2_duty_brief1"},
	}
}
hakassha_sireen_convo:addScreen(hakassha_sireen_convo_tier2_duty_menu)

hakassha_sireen_convo_accept_tier2_duty1 = ConvoScreen:new {
	id = "accept_tier2_duty1",
	leftDialog = "@spacequest/destroy_duty/corellia_imperial_8:title",
	stopConversation = "true",
	options = {}
}
hakassha_sireen_convo:addScreen(hakassha_sireen_convo_accept_tier2_duty1)

hakassha_sireen_convo_accept_tier2_duty2 = ConvoScreen:new {
	id = "accept_tier2_duty2",
	leftDialog = "@spacequest/escort_duty/corellia_imperial_9:title",
	stopConversation = "true",
	options = {}
}
hakassha_sireen_convo:addScreen(hakassha_sireen_convo_accept_tier2_duty2)

hakassha_sireen_convo_accept_tier2_duty3 = ConvoScreen:new {
	id = "accept_tier2_duty3",
	leftDialog = "@spacequest/destroy_duty/corellia_imperial_10:title",
	stopConversation = "true",
	options = {}
}
hakassha_sireen_convo:addScreen(hakassha_sireen_convo_accept_tier2_duty3)

hakassha_sireen_convo_accept_tier2_duty4 = ConvoScreen:new {
	id = "accept_tier2_duty4",
	leftDialog = "@spacequest/escort_duty/corellia_imperial_11:title",
	stopConversation = "true",
	options = {}
}
hakassha_sireen_convo:addScreen(hakassha_sireen_convo_accept_tier2_duty4)

--[[

	Tier 3

]]

-- Tier 3 - Active Mission
hakassha_sireen_convo_tier3_on_mission = ConvoScreen:new {
	id = "tier3_on_mission",
	leftDialog = "@conversation/corellia_imperial_tier3:s_2e69b8ed",
	stopConversation = "true",
	options = {}
}
hakassha_sireen_convo:addScreen(hakassha_sireen_convo_tier3_on_mission)

-- Tier 3 - Mission 1
hakassha_sireen_convo_tier3_first_mission = ConvoScreen:new {
	id = "tier3_first_mission",
	leftDialog = "@conversation/corellia_imperial_tier3:s_1c0f4063",
	stopConversation = "false",
	options = {
		{"@conversation/corellia_imperial_tier3:s_fd236a42", "tier3_first_mission_details"},
	}
}
hakassha_sireen_convo:addScreen(hakassha_sireen_convo_tier3_first_mission)

hakassha_sireen_convo_tier3_first_mission_details = ConvoScreen:new {
	id = "tier3_first_mission_details",
	leftDialog = "@conversation/corellia_imperial_tier3:s_b622a494",
	stopConversation = "false",
	options = {
		{"@conversation/corellia_imperial_tier3:s_d547e29b", "tier3_first_mission_briefing"},
	}
}
hakassha_sireen_convo:addScreen(hakassha_sireen_convo_tier3_first_mission_details)

hakassha_sireen_convo_tier3_first_mission_briefing = ConvoScreen:new {
	id = "tier3_first_mission_briefing",
	leftDialog = "@conversation/corellia_imperial_tier3:s_ecfe85ae",
	stopConversation = "false",
	options = {
		{"@conversation/corellia_imperial_tier3:s_7af5dab4", "tier3_first_mission_security"},
	}
}
hakassha_sireen_convo:addScreen(hakassha_sireen_convo_tier3_first_mission_briefing)

hakassha_sireen_convo_tier3_first_mission_security = ConvoScreen:new {
	id = "tier3_first_mission_security",
	leftDialog = "@conversation/corellia_imperial_tier3:s_7bef2106",
	stopConversation = "false",
	options = {
		{"@conversation/corellia_imperial_tier3:s_1969477d", "tier3_first_mission_threat"},
	}
}
hakassha_sireen_convo:addScreen(hakassha_sireen_convo_tier3_first_mission_security)

hakassha_sireen_convo_tier3_first_mission_threat = ConvoScreen:new {
	id = "tier3_first_mission_threat",
	leftDialog = "@conversation/corellia_imperial_tier3:s_53126084",
	stopConversation = "false",
	options = {
		{"@conversation/corellia_imperial_tier3:s_f2993921", "tier3_first_mission_nym"},
	}
}
hakassha_sireen_convo:addScreen(hakassha_sireen_convo_tier3_first_mission_threat)

hakassha_sireen_convo_tier3_first_mission_nym = ConvoScreen:new {
	id = "tier3_first_mission_nym",
	leftDialog = "@conversation/corellia_imperial_tier3:s_586a7d64",
	stopConversation = "false",
	options = {
		{"@conversation/corellia_imperial_tier3:s_12c769cf", "tier3_first_mission_orders"},
	}
}
hakassha_sireen_convo:addScreen(hakassha_sireen_convo_tier3_first_mission_nym)

hakassha_sireen_convo_tier3_first_mission_orders = ConvoScreen:new {
	id = "tier3_first_mission_orders",
	leftDialog = "@conversation/corellia_imperial_tier3:s_daab08d3",
	stopConversation = "false",
	options = {
		{"@conversation/corellia_imperial_tier3:s_b6b25f13", "accept_tier3_first_mission"},
	}
}
hakassha_sireen_convo:addScreen(hakassha_sireen_convo_tier3_first_mission_orders)

hakassha_sireen_convo_accept_tier3_first_mission = ConvoScreen:new {
	id = "accept_tier3_first_mission",
	leftDialog = "@conversation/corellia_imperial_tier3:s_e3bbe83c",
	stopConversation = "true",
	options = {}
}
hakassha_sireen_convo:addScreen(hakassha_sireen_convo_accept_tier3_first_mission)

hakassha_sireen_convo_failed_tier3_first_mission = ConvoScreen:new {
	id = "failed_tier3_first_mission",
	leftDialog = "@conversation/corellia_imperial_tier3:s_1f1da1b8",
	stopConversation = "true",
	options = {}
}
hakassha_sireen_convo:addScreen(hakassha_sireen_convo_failed_tier3_first_mission)

hakassha_sireen_convo_tier3_first_mission_success = ConvoScreen:new {
	id = "tier3_first_mission_success",
	leftDialog = "@conversation/corellia_imperial_tier3:s_14060a1c",
	stopConversation = "false",
	options = {
		{"@conversation/corellia_imperial_tier3:s_b200234c", "tier3_first_mission_success_report"},
	}
}
hakassha_sireen_convo:addScreen(hakassha_sireen_convo_tier3_first_mission_success)

hakassha_sireen_convo_tier3_first_mission_success_report = ConvoScreen:new {
	id = "tier3_first_mission_success_report",
	leftDialog = "@conversation/corellia_imperial_tier3:s_b695af6b",
	stopConversation = "false",
	options = {
		{"@conversation/corellia_imperial_tier3:s_2c7b60e", "tier3_first_mission_success_alliance"},
	}
}
hakassha_sireen_convo:addScreen(hakassha_sireen_convo_tier3_first_mission_success_report)

hakassha_sireen_convo_tier3_first_mission_success_alliance = ConvoScreen:new {
	id = "tier3_first_mission_success_alliance",
	leftDialog = "@conversation/corellia_imperial_tier3:s_2b261439",
	stopConversation = "false",
	options = {
		{"@conversation/corellia_imperial_tier3:s_72418db3", "tier3_first_mission_success_losses"},
	}
}
hakassha_sireen_convo:addScreen(hakassha_sireen_convo_tier3_first_mission_success_alliance)

hakassha_sireen_convo_tier3_first_mission_success_losses = ConvoScreen:new {
	id = "tier3_first_mission_success_losses",
	leftDialog = "@conversation/corellia_imperial_tier3:s_a1b009ed",
	stopConversation = "false",
	options = {
		{"@conversation/corellia_imperial_tier3:s_8c751827", "tier3_first_mission_success_strategy"},
	}
}
hakassha_sireen_convo:addScreen(hakassha_sireen_convo_tier3_first_mission_success_losses)

hakassha_sireen_convo_tier3_first_mission_success_strategy = ConvoScreen:new {
	id = "tier3_first_mission_success_strategy",
	leftDialog = "@conversation/corellia_imperial_tier3:s_a4f70dc9",
	stopConversation = "false",
	options = {
		{"@conversation/corellia_imperial_tier3:s_b6b25f13", "tier3_first_mission_training"},
	}
}
hakassha_sireen_convo:addScreen(hakassha_sireen_convo_tier3_first_mission_success_strategy)

hakassha_sireen_convo_tier3_first_mission_training = ConvoScreen:new {
	id = "tier3_first_mission_training",
	leftDialog = "@conversation/corellia_imperial_tier3:s_8dcf50f",
	stopConversation = "false",
	options = {
		-- Training option added dynamically via handler
	}
}
hakassha_sireen_convo:addScreen(hakassha_sireen_convo_tier3_first_mission_training)

-- Tier 3 - Mission 2
hakassha_sireen_convo_tier3_second_mission = ConvoScreen:new {
	id = "tier3_second_mission",
	leftDialog = "@conversation/corellia_imperial_tier3:s_fdda16c7",
	stopConversation = "false",
	options = {
		{"@conversation/corellia_imperial_tier3:s_7c05dd60", "tier3_second_mission_details"},
		{"@conversation/corellia_imperial_tier3:s_5eb7a1e3", "accept_tier3_second_mission"},
	}
}
hakassha_sireen_convo:addScreen(hakassha_sireen_convo_tier3_second_mission)

hakassha_sireen_convo_tier3_second_mission_details = ConvoScreen:new {
	id = "tier3_second_mission_details",
	leftDialog = "@conversation/corellia_imperial_tier3:s_22f895e3",
	stopConversation = "false",
	options = {
		{"@conversation/corellia_imperial_tier3:s_5eb7a1e3", "accept_tier3_second_mission"},
	}
}
hakassha_sireen_convo:addScreen(hakassha_sireen_convo_tier3_second_mission_details)

hakassha_sireen_convo_accept_tier3_second_mission = ConvoScreen:new {
	id = "accept_tier3_second_mission",
	leftDialog = "@conversation/corellia_imperial_tier3:s_1e26f934",
	stopConversation = "true",
	options = {}
}
hakassha_sireen_convo:addScreen(hakassha_sireen_convo_accept_tier3_second_mission)

hakassha_sireen_convo_failed_tier3_second_mission = ConvoScreen:new {
	id = "failed_tier3_second_mission",
	leftDialog = "@conversation/corellia_imperial_tier3:s_d32315a8",
	stopConversation = "true",
	options = {}
}
hakassha_sireen_convo:addScreen(hakassha_sireen_convo_failed_tier3_second_mission)

hakassha_sireen_convo_tier3_second_mission_success = ConvoScreen:new {
	id = "tier3_second_mission_success",
	leftDialog = "@conversation/corellia_imperial_tier3:s_6cef5164",
	stopConversation = "false",
	options = {
		-- Training options added dynamically via handler
	}
}
hakassha_sireen_convo:addScreen(hakassha_sireen_convo_tier3_second_mission_success)

-- Tier 3 - Mission 3
hakassha_sireen_convo_tier3_third_mission = ConvoScreen:new {
	id = "tier3_third_mission",
	leftDialog = "@conversation/corellia_imperial_tier3:s_424f249d",
	stopConversation = "false",
	options = {
		{"@conversation/corellia_imperial_tier3:s_d0f9703", "tier3_third_mission_details"},
		{"@conversation/corellia_imperial_tier3:s_5eb7a1e3", "accept_tier3_third_mission"},
	}
}
hakassha_sireen_convo:addScreen(hakassha_sireen_convo_tier3_third_mission)

hakassha_sireen_convo_tier3_third_mission_details = ConvoScreen:new {
	id = "tier3_third_mission_details",
	leftDialog = "@conversation/corellia_imperial_tier3:s_85e02cc1",
	stopConversation = "false",
	options = {
		{"@conversation/corellia_imperial_tier3:s_5eb7a1e3", "accept_tier3_third_mission"},
	}
}
hakassha_sireen_convo:addScreen(hakassha_sireen_convo_tier3_third_mission_details)

hakassha_sireen_convo_accept_tier3_third_mission = ConvoScreen:new {
	id = "accept_tier3_third_mission",
	leftDialog = "@conversation/corellia_imperial_tier3:s_66ebf9d3",
	stopConversation = "true",
	options = {}
}
hakassha_sireen_convo:addScreen(hakassha_sireen_convo_accept_tier3_third_mission)

hakassha_sireen_convo_failed_tier3_third_mission = ConvoScreen:new {
	id = "failed_tier3_third_mission",
	leftDialog = "@conversation/corellia_imperial_tier3:s_cf274903",
	stopConversation = "true",
	options = {}
}
hakassha_sireen_convo:addScreen(hakassha_sireen_convo_failed_tier3_third_mission)

hakassha_sireen_convo_tier3_third_mission_success = ConvoScreen:new {
	id = "tier3_third_mission_success",
	leftDialog = "@conversation/corellia_imperial_tier3:s_799d2952",
	stopConversation = "false",
	options = {
		-- Training options added dynamically via handler
	}
}
hakassha_sireen_convo:addScreen(hakassha_sireen_convo_tier3_third_mission_success)

-- Tier 3 - Mission 4
hakassha_sireen_convo_tier3_fourth_mission = ConvoScreen:new {
	id = "tier3_fourth_mission",
	leftDialog = "@conversation/corellia_imperial_tier3:s_27e5eff7",
	stopConversation = "false",
	options = {
		{"@conversation/corellia_imperial_tier3:s_c9015929", "tier3_fourth_mission_details"},
		{"@conversation/corellia_imperial_tier3:s_5eb7a1e3", "accept_tier3_fourth_mission"},
	}
}
hakassha_sireen_convo:addScreen(hakassha_sireen_convo_tier3_fourth_mission)

hakassha_sireen_convo_tier3_fourth_mission_details = ConvoScreen:new {
	id = "tier3_fourth_mission_details",
	leftDialog = "@conversation/corellia_imperial_tier3:s_36900273",
	stopConversation = "false",
	options = {
		{"@conversation/corellia_imperial_tier3:s_5eb7a1e3", "accept_tier3_fourth_mission"},
	}
}
hakassha_sireen_convo:addScreen(hakassha_sireen_convo_tier3_fourth_mission_details)

hakassha_sireen_convo_accept_tier3_fourth_mission = ConvoScreen:new {
	id = "accept_tier3_fourth_mission",
	leftDialog = "@conversation/corellia_imperial_tier3:s_271e95b3",
	stopConversation = "true",
	options = {}
}
hakassha_sireen_convo:addScreen(hakassha_sireen_convo_accept_tier3_fourth_mission)

hakassha_sireen_convo_failed_tier3_fourth_mission = ConvoScreen:new {
	id = "failed_tier3_fourth_mission",
	leftDialog = "@conversation/corellia_imperial_tier3:s_73c4833",
	stopConversation = "true",
	options = {}
}
hakassha_sireen_convo:addScreen(hakassha_sireen_convo_failed_tier3_fourth_mission)

hakassha_sireen_convo_tier3_fourth_mission_success = ConvoScreen:new {
	id = "tier3_fourth_mission_success",
	leftDialog = "@conversation/corellia_imperial_tier3:s_dd4ea40c",
	stopConversation = "false",
	options = {
		-- Training options added dynamically via handler
	}
}
hakassha_sireen_convo:addScreen(hakassha_sireen_convo_tier3_fourth_mission_success)

-- Tier 3 - Training
hakassha_sireen_convo_tier3_train_fighters = ConvoScreen:new {
	id = "tier3_train_fighters",
	leftDialog = "@conversation/corellia_imperial_tier3:s_84ce496b",
	stopConversation = "true",
	options = {}
}
hakassha_sireen_convo:addScreen(hakassha_sireen_convo_tier3_train_fighters)

hakassha_sireen_convo_tier3_train_component = ConvoScreen:new {
	id = "tier3_train_component",
	leftDialog = "@conversation/corellia_imperial_tier3:s_7fe8c9bb",
	stopConversation = "true",
	options = {}
}
hakassha_sireen_convo:addScreen(hakassha_sireen_convo_tier3_train_component)

hakassha_sireen_convo_tier3_train_procedures = ConvoScreen:new {
	id = "tier3_train_procedures",
	leftDialog = "@conversation/corellia_imperial_tier3:s_726bfa38",
	stopConversation = "true",
	options = {}
}
hakassha_sireen_convo:addScreen(hakassha_sireen_convo_tier3_train_procedures)

hakassha_sireen_convo_tier3_train_droid = ConvoScreen:new {
	id = "tier3_train_droid",
	leftDialog = "@conversation/corellia_imperial_tier3:s_f00894a4",
	stopConversation = "true",
	options = {}
}
hakassha_sireen_convo:addScreen(hakassha_sireen_convo_tier3_train_droid)

-- Tier 3 - Completed
hakassha_sireen_convo_tier3_completed = ConvoScreen:new {
	id = "tier3_completed",
	leftDialog = "@conversation/corellia_imperial_tier3:s_91cf92a7", -- From now on, you'll be reporting to someone named Insurgent.
	stopConversation = "false",
	options = {
		{"@conversation/corellia_imperial_tier3:s_900f01d1", "tier3_transfer_orders"}, -- What?
	}
}
hakassha_sireen_convo:addScreen(hakassha_sireen_convo_tier3_completed)

hakassha_sireen_convo_tier3_transfer_orders = ConvoScreen:new {
	id = "tier3_transfer_orders",
	leftDialog = "@conversation/corellia_imperial_tier3:s_c18b617e", -- The transfer order was signed by the Emperor.
	stopConversation = "false",
	options = {
		{"@conversation/corellia_imperial_tier3:s_1474f13c", "tier3_transfer_command"}, -- What did the order say?
	}
}
hakassha_sireen_convo:addScreen(hakassha_sireen_convo_tier3_transfer_orders)

hakassha_sireen_convo_tier3_transfer_command = ConvoScreen:new {
	id = "tier3_transfer_command",
	leftDialog = "@conversation/corellia_imperial_tier3:s_6d0b02b", -- Insurgent ordered Haymir to transfer the pilot immediately.
	stopConversation = "false",
	options = {
		{"@conversation/corellia_imperial_tier3:s_9b5a6b23", "tier3_transfer_destination"}, -- He asked for me by name?
	}
}
hakassha_sireen_convo:addScreen(hakassha_sireen_convo_tier3_transfer_command)

hakassha_sireen_convo_tier3_transfer_destination = ConvoScreen:new {
	id = "tier3_transfer_destination",
	leftDialog = "@conversation/corellia_imperial_tier3:s_c65e1fa7", -- Meet Insurgent at the Imperial Outpost on Dantooine.
	stopConversation = "true",
	options = {}
}
hakassha_sireen_convo:addScreen(hakassha_sireen_convo_tier3_transfer_destination)

--[[

	Tier 4

]]

-- Tier 4 - Active Mission
hakassha_sireen_convo_tier4_on_mission = ConvoScreen:new {
	id = "tier4_on_mission",
	leftDialog = "@conversation/corellia_imperial_tier4:s_b94e3a35",
	stopConversation = "true",
	options = {}
}
hakassha_sireen_convo:addScreen(hakassha_sireen_convo_tier4_on_mission)

-- Tier 4 - Initial Briefing
hakassha_sireen_convo_tier4_initial_briefing = ConvoScreen:new {
	id = "tier4_initial_briefing",
	leftDialog = "@conversation/corellia_imperial_tier4:s_735e94f9",
	stopConversation = "false",
	options = {
		{"@conversation/corellia_imperial_tier4:s_c06cf370", "tier4_intro_zeal"},
	}
}
hakassha_sireen_convo:addScreen(hakassha_sireen_convo_tier4_initial_briefing)

hakassha_sireen_convo_tier4_intro_zeal = ConvoScreen:new {
	id = "tier4_intro_zeal",
	leftDialog = "@conversation/corellia_imperial_tier4:s_fd2777e5",
	stopConversation = "false",
	options = {
		{"@conversation/corellia_imperial_tier4:s_ca776e30", "tier4_intro_identity"},
	}
}
hakassha_sireen_convo:addScreen(hakassha_sireen_convo_tier4_intro_zeal)

hakassha_sireen_convo_tier4_intro_identity = ConvoScreen:new {
	id = "tier4_intro_identity",
	leftDialog = "@conversation/corellia_imperial_tier4:s_d1579156",
	stopConversation = "false",
	options = {
		{"@conversation/corellia_imperial_tier4:s_4e718340", "tier4_intro_complete"},
	}
}
hakassha_sireen_convo:addScreen(hakassha_sireen_convo_tier4_intro_identity)

hakassha_sireen_convo_tier4_intro_complete = ConvoScreen:new {
	id = "tier4_intro_complete",
	leftDialog = "@conversation/corellia_imperial_tier4:s_beec51b5",
	stopConversation = "true",
	options = {}
}
hakassha_sireen_convo:addScreen(hakassha_sireen_convo_tier4_intro_complete)

-- Tier 4 - Mission 1
hakassha_sireen_convo_tier4_first_mission = ConvoScreen:new {
	id = "tier4_first_mission",
	leftDialog = "@conversation/corellia_imperial_tier4:s_b52941c3",
	stopConversation = "false",
	options = {
		{"@conversation/corellia_imperial_tier4:s_3bdff7cb", "tier4_first_mission_details"},
		{"@conversation/corellia_imperial_tier4:s_7017e938", "accept_tier4_first_mission"},
	}
}
hakassha_sireen_convo:addScreen(hakassha_sireen_convo_tier4_first_mission)

hakassha_sireen_convo_tier4_first_mission_details = ConvoScreen:new {
	id = "tier4_first_mission_details",
	leftDialog = "@conversation/corellia_imperial_tier4:s_74052171",
	stopConversation = "false",
	options = {
		{"@conversation/corellia_imperial_tier4:s_7017e938", "accept_tier4_first_mission"},
	}
}
hakassha_sireen_convo:addScreen(hakassha_sireen_convo_tier4_first_mission_details)

hakassha_sireen_convo_accept_tier4_first_mission = ConvoScreen:new {
	id = "accept_tier4_first_mission",
	leftDialog = "@conversation/corellia_imperial_tier4:s_bde3268d",
	stopConversation = "true",
	options = {}
}
hakassha_sireen_convo:addScreen(hakassha_sireen_convo_accept_tier4_first_mission)

hakassha_sireen_convo_failed_tier4_first_mission = ConvoScreen:new {
	id = "failed_tier4_first_mission",
	leftDialog = "@conversation/corellia_imperial_tier4:s_edc55445",
	stopConversation = "true",
	options = {}
}
hakassha_sireen_convo:addScreen(hakassha_sireen_convo_failed_tier4_first_mission)

hakassha_sireen_convo_tier4_first_mission_success = ConvoScreen:new {
	id = "tier4_first_mission_success",
	leftDialog = "@conversation/corellia_imperial_tier4:s_e705e25f",
	stopConversation = "true",
	options = {}
}
hakassha_sireen_convo:addScreen(hakassha_sireen_convo_tier4_first_mission_success)

-- Tier 4 - Mission 2
hakassha_sireen_convo_tier4_second_mission = ConvoScreen:new {
	id = "tier4_second_mission",
	leftDialog = "@conversation/corellia_imperial_tier4:s_5f1f6bbe",
	stopConversation = "false",
	options = {
		{"@conversation/corellia_imperial_tier4:s_5a23ab6f", "tier4_second_mission_details"},
		{"@conversation/corellia_imperial_tier4:s_7ef4aae8", "accept_tier4_second_mission"},
	}
}
hakassha_sireen_convo:addScreen(hakassha_sireen_convo_tier4_second_mission)

hakassha_sireen_convo_tier4_second_mission_details = ConvoScreen:new {
	id = "tier4_second_mission_details",
	leftDialog = "@conversation/corellia_imperial_tier4:s_707841db",
	stopConversation = "false",
	options = {
		{"@conversation/corellia_imperial_tier4:s_7ef4aae8", "accept_tier4_second_mission"},
	}
}
hakassha_sireen_convo:addScreen(hakassha_sireen_convo_tier4_second_mission_details)

hakassha_sireen_convo_accept_tier4_second_mission = ConvoScreen:new {
	id = "accept_tier4_second_mission",
	leftDialog = "@conversation/corellia_imperial_tier4:s_da6d3376",
	stopConversation = "true",
	options = {}
}
hakassha_sireen_convo:addScreen(hakassha_sireen_convo_accept_tier4_second_mission)

hakassha_sireen_convo_failed_tier4_second_mission = ConvoScreen:new {
	id = "failed_tier4_second_mission",
	leftDialog = "@conversation/corellia_imperial_tier4:s_edc55445",
	stopConversation = "true",
	options = {}
}
hakassha_sireen_convo:addScreen(hakassha_sireen_convo_failed_tier4_second_mission)

hakassha_sireen_convo_tier4_second_mission_success = ConvoScreen:new {
	id = "tier4_second_mission_success",
	leftDialog = "@conversation/corellia_imperial_tier4:s_f8880079",
	stopConversation = "true",
	options = {}
}
hakassha_sireen_convo:addScreen(hakassha_sireen_convo_tier4_second_mission_success)

-- Tier 4 - Mission 3
hakassha_sireen_convo_tier4_third_mission = ConvoScreen:new {
	id = "tier4_third_mission",
	leftDialog = "@conversation/corellia_imperial_tier4:s_4faccfdf",
	stopConversation = "false",
	options = {
		{"@conversation/corellia_imperial_tier4:s_5babb29c", "tier4_third_mission_details"},
		{"@conversation/corellia_imperial_tier4:s_b9c73c6d", "accept_tier4_third_mission"},
	}
}
hakassha_sireen_convo:addScreen(hakassha_sireen_convo_tier4_third_mission)

hakassha_sireen_convo_tier4_third_mission_details = ConvoScreen:new {
	id = "tier4_third_mission_details",
	leftDialog = "@conversation/corellia_imperial_tier4:s_9f2ab4a0",
	stopConversation = "false",
	options = {
		{"@conversation/corellia_imperial_tier4:s_b9c73c6d", "accept_tier4_third_mission"},
	}
}
hakassha_sireen_convo:addScreen(hakassha_sireen_convo_tier4_third_mission_details)

hakassha_sireen_convo_accept_tier4_third_mission = ConvoScreen:new {
	id = "accept_tier4_third_mission",
	leftDialog = "@conversation/corellia_imperial_tier4:s_622b4f74",
	stopConversation = "true",
	options = {}
}
hakassha_sireen_convo:addScreen(hakassha_sireen_convo_accept_tier4_third_mission)

hakassha_sireen_convo_failed_tier4_third_mission = ConvoScreen:new {
	id = "failed_tier4_third_mission",
	leftDialog = "@conversation/corellia_imperial_tier4:s_edc55445",
	stopConversation = "true",
	options = {}
}
hakassha_sireen_convo:addScreen(hakassha_sireen_convo_failed_tier4_third_mission)

hakassha_sireen_convo_tier4_third_mission_success = ConvoScreen:new {
	id = "tier4_third_mission_success",
	leftDialog = "@conversation/corellia_imperial_tier4:s_3f2bae5b",
	stopConversation = "true",
	options = {}
}
hakassha_sireen_convo:addScreen(hakassha_sireen_convo_tier4_third_mission_success)

-- Tier 4 - Mission 4
hakassha_sireen_convo_tier4_fourth_mission = ConvoScreen:new {
	id = "tier4_fourth_mission",
	leftDialog = "@conversation/corellia_imperial_tier4:s_690701a5",
	stopConversation = "false",
	options = {
		{"@conversation/corellia_imperial_tier4:s_fc7e0cf7", "tier4_fourth_mission_details"},
		{"@conversation/corellia_imperial_tier4:s_7017e938", "accept_tier4_fourth_mission"},
	}
}
hakassha_sireen_convo:addScreen(hakassha_sireen_convo_tier4_fourth_mission)

hakassha_sireen_convo_tier4_fourth_mission_details = ConvoScreen:new {
	id = "tier4_fourth_mission_details",
	leftDialog = "@conversation/corellia_imperial_tier4:s_1b4ddba3",
	stopConversation = "false",
	options = {
		{"@conversation/corellia_imperial_tier4:s_7017e938", "accept_tier4_fourth_mission"},
	}
}
hakassha_sireen_convo:addScreen(hakassha_sireen_convo_tier4_fourth_mission_details)

hakassha_sireen_convo_accept_tier4_fourth_mission = ConvoScreen:new {
	id = "accept_tier4_fourth_mission",
	leftDialog = "@conversation/corellia_imperial_tier4:s_9a8ac7e9",
	stopConversation = "true",
	options = {}
}
hakassha_sireen_convo:addScreen(hakassha_sireen_convo_accept_tier4_fourth_mission)

hakassha_sireen_convo_failed_tier4_fourth_mission = ConvoScreen:new {
	id = "failed_tier4_fourth_mission",
	leftDialog = "@conversation/corellia_imperial_tier4:s_edc55445",
	stopConversation = "true",
	options = {}
}
hakassha_sireen_convo:addScreen(hakassha_sireen_convo_failed_tier4_fourth_mission)

hakassha_sireen_convo_tier4_fourth_mission_success = ConvoScreen:new {
	id = "tier4_fourth_mission_success",
	leftDialog = "@conversation/corellia_imperial_tier4:s_d4500734",
	stopConversation = "true",
	options = {}
}
hakassha_sireen_convo:addScreen(hakassha_sireen_convo_tier4_fourth_mission_success)

-- Master mission
hakassha_sireen_convo_master_mission = ConvoScreen:new {
	id = "master_mission",
	leftDialog = "@conversation/corellia_imperial_tier4:s_d4500734",
	stopConversation = "false",
	options = {
		{"@conversation/corellia_imperial_tier4:s_817cf33", "master_who_declann"},
		{"@conversation/corellia_imperial_tier4:s_6d9530c5", "master_where_report"},
		{"@conversation/corellia_imperial_tier4:s_11c1ca52", "master_what_want"},
		{"@conversation/corellia_imperial_tier4:s_9ec3be5d", "master_becoming_imperial"},
		{"@conversation/corellia_imperial_tier4:s_ea248fbf", "accept_master_mission"},
	}
}
hakassha_sireen_convo:addScreen(hakassha_sireen_convo_master_mission)

hakassha_sireen_convo_master_who_declann = ConvoScreen:new {
	id = "master_who_declann",
	leftDialog = "@conversation/corellia_imperial_tier4:s_d2794755",
	stopConversation = "false",
	options = {
		{"@conversation/corellia_imperial_tier4:s_ea248fbf", "accept_master_mission"},
	}
}
hakassha_sireen_convo:addScreen(hakassha_sireen_convo_master_who_declann)

hakassha_sireen_convo_master_where_report = ConvoScreen:new {
	id = "master_where_report",
	leftDialog = "@conversation/corellia_imperial_tier4:s_c610ccb7",
	stopConversation = "false",
	options = {
		{"@conversation/corellia_imperial_tier4:s_ea248fbf", "accept_master_mission"},
	}
}
hakassha_sireen_convo:addScreen(hakassha_sireen_convo_master_where_report)

hakassha_sireen_convo_master_what_want = ConvoScreen:new {
	id = "master_what_want",
	leftDialog = "@conversation/corellia_imperial_tier4:s_69231042",
	stopConversation = "false",
	options = {
		{"@conversation/corellia_imperial_tier4:s_ea248fbf", "accept_master_mission"},
	}
}
hakassha_sireen_convo:addScreen(hakassha_sireen_convo_master_what_want)

hakassha_sireen_convo_master_becoming_imperial = ConvoScreen:new {
	id = "master_becoming_imperial",
	leftDialog = "@conversation/corellia_imperial_tier4:s_fde2347a",
	stopConversation = "false",
	options = {
		{"@conversation/corellia_imperial_tier4:s_ea248fbf", "accept_master_mission"},
	}
}
hakassha_sireen_convo:addScreen(hakassha_sireen_convo_master_becoming_imperial)

hakassha_sireen_convo_accept_master_mission = ConvoScreen:new {
	id = "accept_master_mission",
	leftDialog = "@conversation/corellia_imperial_tier4:s_d7e41231",
	stopConversation = "true",
	options = {}
}
hakassha_sireen_convo:addScreen(hakassha_sireen_convo_accept_master_mission)

-- Tier 4 - Completed
hakassha_sireen_convo_tier4_completed = ConvoScreen:new {
	id = "tier4_completed",
	leftDialog = "@conversation/corellia_imperial_tier4:s_a74ee1d8",
	stopConversation = "false",
	options = {
		{"@conversation/corellia_imperial_tier4:s_4854758d", "tier4_duty_repeat"},
	}
}
hakassha_sireen_convo:addScreen(hakassha_sireen_convo_tier4_completed)

-- Tier 4 - Training
hakassha_sireen_convo_ready_train_tier4 = ConvoScreen:new {
	id = "ready_train_tier4",
	leftDialog = "@conversation/corellia_imperial_tier4:s_2afc3f27",
	stopConversation = "false",
	options = {
		-- Options added dynamically via handler
	}
}
hakassha_sireen_convo:addScreen(hakassha_sireen_convo_ready_train_tier4)

hakassha_sireen_convo_tier4_train_fighters = ConvoScreen:new {
	id = "tier4_train_fighters",
	leftDialog = "@conversation/corellia_imperial_tier4:s_1c6fdb34",
	stopConversation = "true",
	options = {}
}
hakassha_sireen_convo:addScreen(hakassha_sireen_convo_tier4_train_fighters)

hakassha_sireen_convo_tier4_train_component = ConvoScreen:new {
	id = "tier4_train_component",
	leftDialog = "@conversation/corellia_imperial_tier4:s_1c6fdb34",
	stopConversation = "true",
	options = {}
}
hakassha_sireen_convo:addScreen(hakassha_sireen_convo_tier4_train_component)

hakassha_sireen_convo_tier4_train_basics = ConvoScreen:new {
	id = "tier4_train_basics",
	leftDialog = "@conversation/corellia_imperial_tier4:s_1c6fdb34",
	stopConversation = "true",
	options = {}
}
hakassha_sireen_convo:addScreen(hakassha_sireen_convo_tier4_train_basics)

hakassha_sireen_convo_tier4_train_droid = ConvoScreen:new {
	id = "tier4_train_droid",
	leftDialog = "@conversation/corellia_imperial_tier4:s_1c6fdb34",
	stopConversation = "true",
	options = {}
}
hakassha_sireen_convo:addScreen(hakassha_sireen_convo_tier4_train_droid)

-- Tier 4 - Duty missions
hakassha_sireen_convo_tier4_duty_repeat = ConvoScreen:new {
	id = "tier4_duty_repeat",
	leftDialog = "@conversation/corellia_imperial_tier4:s_81995254",
	stopConversation = "false",
	options = {
		{"@spacequest/destroy_duty/corellia_imperial_tier4_1:title", "accept_tier4_duty1"},
		{"@spacequest/escort_duty/corellia_imperial_tier4_2:title", "accept_tier4_duty2"},
		{"@spacequest/recovery_duty/corellia_imperial_tier4_3:title", "accept_tier4_duty3"},
		{"@spacequest/rescue_duty/corellia_imperial_tier4_4:title", "accept_tier4_duty4"},
		{"@conversation/corellia_imperial_tier4:s_c82e9a2f", "tier4_duty_brief1"},
	}
}
hakassha_sireen_convo:addScreen(hakassha_sireen_convo_tier4_duty_repeat)

hakassha_sireen_convo_tier4_duty_brief1 = ConvoScreen:new {
	id = "tier4_duty_brief1",
	leftDialog = "@conversation/corellia_imperial_tier4:s_b3155267",
	stopConversation = "false",
	options = {
		{"@conversation/corellia_imperial_tier4:s_362a48e0", "tier4_duty_brief2"},
	}
}
hakassha_sireen_convo:addScreen(hakassha_sireen_convo_tier4_duty_brief1)

hakassha_sireen_convo_tier4_duty_brief2 = ConvoScreen:new {
	id = "tier4_duty_brief2",
	leftDialog = "@conversation/corellia_imperial_tier4:s_5e4d41df",
	stopConversation = "false",
	options = {
		{"@conversation/corellia_imperial_tier4:s_362a48e0", "tier4_duty_brief3"},
	}
}
hakassha_sireen_convo:addScreen(hakassha_sireen_convo_tier4_duty_brief2)

hakassha_sireen_convo_tier4_duty_brief3 = ConvoScreen:new {
	id = "tier4_duty_brief3",
	leftDialog = "@conversation/corellia_imperial_tier4:s_34120baf",
	stopConversation = "false",
	options = {
		{"@conversation/corellia_imperial_tier4:s_362a48e0", "tier4_duty_menu"},
	}
}
hakassha_sireen_convo:addScreen(hakassha_sireen_convo_tier4_duty_brief3)

hakassha_sireen_convo_tier4_duty_menu = ConvoScreen:new {
	id = "tier4_duty_menu",
	leftDialog = "@conversation/corellia_imperial_tier4:s_beb66be",
	stopConversation = "false",
	options = {
		{"@spacequest/destroy_duty/corellia_imperial_tier4_1:title", "accept_tier4_duty1"},
		{"@spacequest/escort_duty/corellia_imperial_tier4_2:title", "accept_tier4_duty2"},
		{"@spacequest/recovery_duty/corellia_imperial_tier4_3:title", "accept_tier4_duty3"},
		{"@spacequest/rescue_duty/corellia_imperial_tier4_4:title", "accept_tier4_duty4"},
		{"@conversation/corellia_imperial_tier4:s_c82e9a2f", "tier4_duty_brief1"},
	}
}
hakassha_sireen_convo:addScreen(hakassha_sireen_convo_tier4_duty_menu)

hakassha_sireen_convo_accept_tier4_duty1 = ConvoScreen:new {
	id = "accept_tier4_duty1",
	leftDialog = "@spacequest/destroy_duty/corellia_imperial_tier4_1:title",
	stopConversation = "true",
	options = {}
}
hakassha_sireen_convo:addScreen(hakassha_sireen_convo_accept_tier4_duty1)

hakassha_sireen_convo_accept_tier4_duty2 = ConvoScreen:new {
	id = "accept_tier4_duty2",
	leftDialog = "@spacequest/escort_duty/corellia_imperial_tier4_2:title",
	stopConversation = "true",
	options = {}
}
hakassha_sireen_convo:addScreen(hakassha_sireen_convo_accept_tier4_duty2)

hakassha_sireen_convo_accept_tier4_duty3 = ConvoScreen:new {
	id = "accept_tier4_duty3",
	leftDialog = "@spacequest/recovery_duty/corellia_imperial_tier4_3:title",
	stopConversation = "true",
	options = {}
}
hakassha_sireen_convo:addScreen(hakassha_sireen_convo_accept_tier4_duty3)

hakassha_sireen_convo_accept_tier4_duty4 = ConvoScreen:new {
	id = "accept_tier4_duty4",
	leftDialog = "@spacequest/rescue_duty/corellia_imperial_tier4_4:title",
	stopConversation = "true",
	options = {}
}
hakassha_sireen_convo:addScreen(hakassha_sireen_convo_accept_tier4_duty4)


addConversationTemplate("hakassha_sireen_convo", hakassha_sireen_convo);
