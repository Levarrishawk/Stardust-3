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

--[[ Tier 1 -- Mission 2: Destroy the B-Wing prototype (handler starts destroy_corellia_imperial_2 on "quest2_accepted") ]]
hakassha_sireen_convo_grant_quest2 = ConvoScreen:new {
	id = "grant_quest2",
	leftDialog = "@conversation/corellia_imperial_trainer_1:s_fbd7d1ba", -- I think you'll like this mission, hon. You get to test your mettle against some new Rebel technology. Real cutting edge stuff, too.
	stopConversation = "false",
	options = {
		{"@conversation/corellia_imperial_trainer_1:s_96682689", "quest2_accepted"}, -- Tell me about the job.
	}
}
hakassha_sireen_convo:addScreen(hakassha_sireen_convo_grant_quest2)

hakassha_sireen_convo_quest2_accepted = ConvoScreen:new {
	id = "quest2_accepted",
	leftDialog = "@conversation/corellia_imperial_trainer_1:s_540bd789", -- Apparently the Rebels are testing a new prototype starfighter called the B-Wing. It's a heavy assault fighter, loaded with weapons and layered in armor. B-Wing prototypes have been spotted in the Corellian system. We want you to find one and destroy it.
	stopConversation = "true",
	options = {}
}
hakassha_sireen_convo:addScreen(hakassha_sireen_convo_quest2_accepted)

-- Quest 2 rewarded; leads into Mission 3 (the escort). The handler starts quest 3 on "train_me3".
hakassha_sireen_convo_excellent_work2 = ConvoScreen:new {
	id = "excellent_work2",
	leftDialog = "@conversation/corellia_imperial_trainer_1:s_83dc5be7", -- Here is your pay for the B-Wing mission. I've also gotten a hold of a TIE pilot helmet. It looks pretty menacing, should make you feel more the part for these operations.
	stopConversation = "false",
	options = {
		{"@conversation/corellia_imperial_trainer_1:s_7a80cd06", "train_me3"}, -- I'm ready for the next step in the operation.
		{"@conversation/corellia_imperial_trainer_1:s_192ddc14", "train_me3"}, -- Are you going to train me?
	}
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
	leftDialog = "@conversation/corellia_imperial_trainer_1:s_3ac44381", -- Failure at this point is only going to encourage the Rebels to invest further in experimental ship designs. You need to get back up there and bag a B-Wing. Show the Rebels that technology isn't going to be their salvation.
	stopConversation = "false",
	options = {
		{"@conversation/corellia_imperial_trainer_1:s_1adbadc4", "retry_quest2"}, -- I'm ready.
	}
}
hakassha_sireen_convo:addScreen(hakassha_sireen_convo_failed_quest2)

-- Quest 2 retry acknowledged (handler restarts destroy_corellia_imperial_2)
hakassha_sireen_convo_retry_quest2 = ConvoScreen:new {
	id = "retry_quest2",
	leftDialog = "@conversation/corellia_imperial_trainer_1:s_5dd3c672", -- Report back to me when you've taken out the prototype ship. Good luck, hon.
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

--[[ Tier 1 -- Mission 4: Destroy the Rebel X-Wing trainees (handler starts assassinate_corellia_imperial_4 on "quest4_accepted") ]]
hakassha_sireen_convo_grant_quest4 = ConvoScreen:new {
	id = "grant_quest4",
	leftDialog = "@conversation/corellia_imperial_trainer_1:s_6942389e", -- And you've earned it!  I'll make a deal with you, %NU.  Do just one more assignment for me, and I'll train you to be a better starfighter pilot.  Are you up for a challenge?
	stopConversation = "false",
	options = {
		{"@conversation/corellia_imperial_trainer_1:s_86c66182", "quest4_accepted"}, -- What's the next step?
	}
}
hakassha_sireen_convo:addScreen(hakassha_sireen_convo_grant_quest4)

hakassha_sireen_convo_quest4_accepted = ConvoScreen:new {
	id = "quest4_accepted",
	leftDialog = "@conversation/corellia_imperial_trainer_1:s_11c38900", -- I have discovered that the Rebels are training X-Wing cadets in Corellian space. The Rebels are quickly working to recruit new pilots to their cause. Destroying the cadets will cripple that effort. Corellian citizens will think twice about signing up if the Rebels can't even protect their young and inexperienced.
	stopConversation = "true",
	options = {}
}
hakassha_sireen_convo:addScreen(hakassha_sireen_convo_quest4_accepted)

hakassha_sireen_convo_failed_quest4 = ConvoScreen:new {
	id = "failed_quest4",
	leftDialog = "@conversation/corellia_imperial_trainer_1:s_da237511", -- I take my job seriously, babe. Get back out there and do it right this time.
	stopConversation = "false",
	options = {
		{"@conversation/corellia_imperial_trainer_1:s_1adbadc4", "retry_quest4"}, -- I'm ready.
	}
}
hakassha_sireen_convo:addScreen(hakassha_sireen_convo_failed_quest4)

-- Quest 4 retry acknowledged (handler restarts assassinate_corellia_imperial_4)
hakassha_sireen_convo_retry_quest4 = ConvoScreen:new {
	id = "retry_quest4",
	leftDialog = "@conversation/corellia_imperial_trainer_1:s_a074ac18", -- The trainees shouldn't be a match for you, but their instructors might. You are going to have to hunt them down in the Corellian system. Intelligence has not yet been able to locate their training grounds but there are reports of a Rebel station somewhere in the system. Might be a good start. Be on guard and don't worry if one escapes and reports you. The Empire is fully justified in destroying terrorist training grounds found within its jurisdiction.
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
	leftDialog = "@conversation/naboo_imperial_trainer_2:s_a59c7bd7",
	stopConversation = "true",
	options = {}
}
hakassha_sireen_convo:addScreen(hakassha_sireen_convo_tier2_on_mission)

-- Tier 2 - Initial Briefing
hakassha_sireen_convo_tier2_initial_briefing = ConvoScreen:new {
	id = "tier2_initial_briefing",
	leftDialog = "@conversation/naboo_imperial_trainer_2:s_41786376",
	stopConversation = "false",
	options = {
		{"@conversation/naboo_imperial_trainer_2:s_fa3398f3", "tier2_first_mission"},
	}
}
hakassha_sireen_convo:addScreen(hakassha_sireen_convo_tier2_initial_briefing)

-- Tier 2 - Mission 1
hakassha_sireen_convo_tier2_first_mission = ConvoScreen:new {
	id = "tier2_first_mission",
	leftDialog = "@conversation/naboo_imperial_trainer_2:s_199bd27f",
	stopConversation = "false",
	options = {
		{"@conversation/naboo_imperial_trainer_2:s_f1be3213", "tier2_first_mission_details"},
		{"@conversation/naboo_imperial_trainer_2:s_91223b5c", "accept_tier2_first_mission"},
	}
}
hakassha_sireen_convo:addScreen(hakassha_sireen_convo_tier2_first_mission)

hakassha_sireen_convo_tier2_first_mission_details = ConvoScreen:new {
	id = "tier2_first_mission_details",
	leftDialog = "@conversation/naboo_imperial_trainer_2:s_d2fa677d",
	stopConversation = "false",
	options = {
		{"@conversation/naboo_imperial_trainer_2:s_91223b5c", "accept_tier2_first_mission"},
	}
}
hakassha_sireen_convo:addScreen(hakassha_sireen_convo_tier2_first_mission_details)

hakassha_sireen_convo_accept_tier2_first_mission = ConvoScreen:new {
	id = "accept_tier2_first_mission",
	leftDialog = "@conversation/naboo_imperial_trainer_2:s_aceff31e",
	stopConversation = "true",
	options = {}
}
hakassha_sireen_convo:addScreen(hakassha_sireen_convo_accept_tier2_first_mission)

hakassha_sireen_convo_failed_tier2_first_mission = ConvoScreen:new {
	id = "failed_tier2_first_mission",
	leftDialog = "@conversation/naboo_imperial_trainer_2:s_825fac62",
	stopConversation = "true",
	options = {}
}
hakassha_sireen_convo:addScreen(hakassha_sireen_convo_failed_tier2_first_mission)

hakassha_sireen_convo_tier2_first_mission_success = ConvoScreen:new {
	id = "tier2_first_mission_success",
	leftDialog = "@conversation/naboo_imperial_trainer_2:s_ad754",
	stopConversation = "false",
	options = {
		{"@conversation/naboo_imperial_trainer_2:s_daf7bb7d", "tier2_second_mission"},
	}
}
hakassha_sireen_convo:addScreen(hakassha_sireen_convo_tier2_first_mission_success)

-- Tier 2 - Mission 2
hakassha_sireen_convo_tier2_second_mission = ConvoScreen:new {
	id = "tier2_second_mission",
	leftDialog = "@conversation/naboo_imperial_trainer_2:s_b8791e16",
	stopConversation = "false",
	options = {
		{"@conversation/naboo_imperial_trainer_2:s_e6765c30", "accept_tier2_second_mission"},
	}
}
hakassha_sireen_convo:addScreen(hakassha_sireen_convo_tier2_second_mission)

hakassha_sireen_convo_accept_tier2_second_mission = ConvoScreen:new {
	id = "accept_tier2_second_mission",
	leftDialog = "@conversation/naboo_imperial_trainer_2:s_dfdec194",
	stopConversation = "true",
	options = {}
}
hakassha_sireen_convo:addScreen(hakassha_sireen_convo_accept_tier2_second_mission)

hakassha_sireen_convo_failed_tier2_second_mission = ConvoScreen:new {
	id = "failed_tier2_second_mission",
	leftDialog = "@conversation/naboo_imperial_trainer_2:s_825fac62",
	stopConversation = "true",
	options = {}
}
hakassha_sireen_convo:addScreen(hakassha_sireen_convo_failed_tier2_second_mission)

hakassha_sireen_convo_tier2_second_mission_success = ConvoScreen:new {
	id = "tier2_second_mission_success",
	leftDialog = "@conversation/naboo_imperial_trainer_2:s_de870f1",
	stopConversation = "false",
	options = {
		{"@conversation/naboo_imperial_trainer_2:s_3c9b80ee", "tier2_third_mission"},
	}
}
hakassha_sireen_convo:addScreen(hakassha_sireen_convo_tier2_second_mission_success)

-- Tier 2 - Mission 3
hakassha_sireen_convo_tier2_third_mission = ConvoScreen:new {
	id = "tier2_third_mission",
	leftDialog = "@conversation/naboo_imperial_trainer_2:s_26408ea",
	stopConversation = "false",
	options = {
		{"@conversation/naboo_imperial_trainer_2:s_6e39f51b", "tier2_third_mission_details"},
		{"@conversation/naboo_imperial_trainer_2:s_51fe08f5", "accept_tier2_third_mission"},
	}
}
hakassha_sireen_convo:addScreen(hakassha_sireen_convo_tier2_third_mission)

hakassha_sireen_convo_tier2_third_mission_details = ConvoScreen:new {
	id = "tier2_third_mission_details",
	leftDialog = "@conversation/naboo_imperial_trainer_2:s_b257ddf8",
	stopConversation = "false",
	options = {
		{"@conversation/naboo_imperial_trainer_2:s_51fe08f5", "accept_tier2_third_mission"},
	}
}
hakassha_sireen_convo:addScreen(hakassha_sireen_convo_tier2_third_mission_details)

hakassha_sireen_convo_accept_tier2_third_mission = ConvoScreen:new {
	id = "accept_tier2_third_mission",
	leftDialog = "@conversation/naboo_imperial_trainer_2:s_1d63bf5d",
	stopConversation = "true",
	options = {}
}
hakassha_sireen_convo:addScreen(hakassha_sireen_convo_accept_tier2_third_mission)

hakassha_sireen_convo_failed_tier2_third_mission = ConvoScreen:new {
	id = "failed_tier2_third_mission",
	leftDialog = "@conversation/naboo_imperial_trainer_2:s_825fac62",
	stopConversation = "true",
	options = {}
}
hakassha_sireen_convo:addScreen(hakassha_sireen_convo_failed_tier2_third_mission)

hakassha_sireen_convo_tier2_third_mission_success = ConvoScreen:new {
	id = "tier2_third_mission_success",
	leftDialog = "@conversation/naboo_imperial_trainer_2:s_2ccef947",
	stopConversation = "false",
	options = {
		{"@conversation/naboo_imperial_trainer_2:s_96db4fc7", "tier2_fourth_mission"},
	}
}
hakassha_sireen_convo:addScreen(hakassha_sireen_convo_tier2_third_mission_success)

-- Tier 2 - Mission 4
hakassha_sireen_convo_tier2_fourth_mission = ConvoScreen:new {
	id = "tier2_fourth_mission",
	leftDialog = "@conversation/naboo_imperial_trainer_2:s_196d2fe6",
	stopConversation = "false",
	options = {
		{"@conversation/naboo_imperial_trainer_2:s_20b3aa70", "tier2_fourth_mission_details"},
		{"@conversation/naboo_imperial_trainer_2:s_1f033c46", "accept_tier2_fourth_mission"},
	}
}
hakassha_sireen_convo:addScreen(hakassha_sireen_convo_tier2_fourth_mission)

hakassha_sireen_convo_tier2_fourth_mission_details = ConvoScreen:new {
	id = "tier2_fourth_mission_details",
	leftDialog = "@conversation/naboo_imperial_trainer_2:s_e17af774",
	stopConversation = "false",
	options = {
		{"@conversation/naboo_imperial_trainer_2:s_1f033c46", "accept_tier2_fourth_mission"},
	}
}
hakassha_sireen_convo:addScreen(hakassha_sireen_convo_tier2_fourth_mission_details)

hakassha_sireen_convo_accept_tier2_fourth_mission = ConvoScreen:new {
	id = "accept_tier2_fourth_mission",
	leftDialog = "@conversation/naboo_imperial_trainer_2:s_d1fa21c",
	stopConversation = "true",
	options = {}
}
hakassha_sireen_convo:addScreen(hakassha_sireen_convo_accept_tier2_fourth_mission)

hakassha_sireen_convo_failed_tier2_fourth_mission = ConvoScreen:new {
	id = "failed_tier2_fourth_mission",
	leftDialog = "@conversation/naboo_imperial_trainer_2:s_306da215",
	stopConversation = "true",
	options = {}
}
hakassha_sireen_convo:addScreen(hakassha_sireen_convo_failed_tier2_fourth_mission)

hakassha_sireen_convo_tier2_fourth_mission_success = ConvoScreen:new {
	id = "tier2_fourth_mission_success",
	leftDialog = "@conversation/naboo_imperial_trainer_2:s_78c7dc33",
	stopConversation = "true",
	options = {}
}
hakassha_sireen_convo:addScreen(hakassha_sireen_convo_tier2_fourth_mission_success)

-- Tier 2 - Training
hakassha_sireen_convo_ready_train_tier2 = ConvoScreen:new {
	id = "ready_train_tier2",
	leftDialog = "@conversation/naboo_imperial_trainer_2:s_9ac35c60",
	stopConversation = "false",
	options = {
		-- Options added dynamically via handler
	}
}
hakassha_sireen_convo:addScreen(hakassha_sireen_convo_ready_train_tier2)

hakassha_sireen_convo_tier2_train_fighters = ConvoScreen:new {
	id = "tier2_train_fighters",
	leftDialog = "@conversation/naboo_imperial_trainer_2:s_c4880407",
	stopConversation = "true",
	options = {}
}
hakassha_sireen_convo:addScreen(hakassha_sireen_convo_tier2_train_fighters)

hakassha_sireen_convo_tier2_train_component = ConvoScreen:new {
	id = "tier2_train_component",
	leftDialog = "@conversation/naboo_imperial_trainer_2:s_241a34a1",
	stopConversation = "true",
	options = {}
}
hakassha_sireen_convo:addScreen(hakassha_sireen_convo_tier2_train_component)

hakassha_sireen_convo_tier2_train_basics = ConvoScreen:new {
	id = "tier2_train_basics",
	leftDialog = "@conversation/naboo_imperial_trainer_2:s_486da900",
	stopConversation = "true",
	options = {}
}
hakassha_sireen_convo:addScreen(hakassha_sireen_convo_tier2_train_basics)

hakassha_sireen_convo_tier2_train_droid = ConvoScreen:new {
	id = "tier2_train_droid",
	leftDialog = "@conversation/naboo_imperial_trainer_2:s_31804e15",
	stopConversation = "true",
	options = {}
}
hakassha_sireen_convo:addScreen(hakassha_sireen_convo_tier2_train_droid)

-- Tier 2 - Completed
hakassha_sireen_convo_tier2_completed = ConvoScreen:new {
	id = "tier2_completed",
	leftDialog = "@conversation/naboo_imperial_trainer_2:s_49be19d2",
	stopConversation = "true",
	options = {}
}
hakassha_sireen_convo:addScreen(hakassha_sireen_convo_tier2_completed)

-- Tier 2 - Duty missions
hakassha_sireen_convo_tier2_duty_repeat = ConvoScreen:new {
	id = "tier2_duty_repeat",
	leftDialog = "@conversation/naboo_imperial_trainer_2:s_be89481",
	stopConversation = "false",
	options = {
		{"@conversation/naboo_imperial_trainer_2:s_f0a7a4ef", "accept_tier2_duty1"},
		{"@conversation/naboo_imperial_trainer_2:s_e84f3a62", "accept_tier2_duty2"},
		{"@conversation/naboo_imperial_trainer_2:s_e6765c30", "accept_tier2_duty3"},
		{"@conversation/naboo_imperial_trainer_2:s_b2a924ab", "tier2_duty_brief1"},
	}
}
hakassha_sireen_convo:addScreen(hakassha_sireen_convo_tier2_duty_repeat)

hakassha_sireen_convo_tier2_duty_brief1 = ConvoScreen:new {
	id = "tier2_duty_brief1",
	leftDialog = "@conversation/naboo_imperial_trainer_2:s_6a6fe80",
	stopConversation = "false",
	options = {
		{"@conversation/naboo_imperial_trainer_2:s_8efde2ae", "tier2_duty_brief2"},
	}
}
hakassha_sireen_convo:addScreen(hakassha_sireen_convo_tier2_duty_brief1)

hakassha_sireen_convo_tier2_duty_brief2 = ConvoScreen:new {
	id = "tier2_duty_brief2",
	leftDialog = "@conversation/naboo_imperial_trainer_2:s_9962665d",
	stopConversation = "false",
	options = {
		{"@conversation/naboo_imperial_trainer_2:s_8efde2ae", "tier2_duty_brief3"},
	}
}
hakassha_sireen_convo:addScreen(hakassha_sireen_convo_tier2_duty_brief2)

hakassha_sireen_convo_tier2_duty_brief3 = ConvoScreen:new {
	id = "tier2_duty_brief3",
	leftDialog = "@conversation/naboo_imperial_trainer_2:s_b2634e3d",
	stopConversation = "false",
	options = {
		{"@conversation/naboo_imperial_trainer_2:s_8efde2ae", "tier2_duty_menu"},
	}
}
hakassha_sireen_convo:addScreen(hakassha_sireen_convo_tier2_duty_brief3)

hakassha_sireen_convo_tier2_duty_menu = ConvoScreen:new {
	id = "tier2_duty_menu",
	leftDialog = "@conversation/naboo_imperial_trainer_2:s_5b4ccb84",
	stopConversation = "false",
	options = {
		{"@conversation/naboo_imperial_trainer_2:s_f0a7a4ef", "accept_tier2_duty1"},
		{"@conversation/naboo_imperial_trainer_2:s_e84f3a62", "accept_tier2_duty2"},
		{"@conversation/naboo_imperial_trainer_2:s_e6765c30", "accept_tier2_duty3"},
		{"@conversation/naboo_imperial_trainer_2:s_b2a924ab", "tier2_duty_brief1"},
	}
}
hakassha_sireen_convo:addScreen(hakassha_sireen_convo_tier2_duty_menu)

hakassha_sireen_convo_accept_tier2_duty1 = ConvoScreen:new {
	id = "accept_tier2_duty1",
	leftDialog = "@conversation/naboo_imperial_trainer_2:s_aceff31e",
	stopConversation = "true",
	options = {}
}
hakassha_sireen_convo:addScreen(hakassha_sireen_convo_accept_tier2_duty1)

hakassha_sireen_convo_accept_tier2_duty2 = ConvoScreen:new {
	id = "accept_tier2_duty2",
	leftDialog = "@conversation/naboo_imperial_trainer_2:s_205f33ca",
	stopConversation = "true",
	options = {}
}
hakassha_sireen_convo:addScreen(hakassha_sireen_convo_accept_tier2_duty2)

hakassha_sireen_convo_accept_tier2_duty3 = ConvoScreen:new {
	id = "accept_tier2_duty3",
	leftDialog = "@conversation/naboo_imperial_trainer_2:s_4682fc3c",
	stopConversation = "true",
	options = {}
}
hakassha_sireen_convo:addScreen(hakassha_sireen_convo_accept_tier2_duty3)

--[[

	Tier 3

]]

-- Tier 3 - Active Mission
hakassha_sireen_convo_tier3_on_mission = ConvoScreen:new {
	id = "tier3_on_mission",
	leftDialog = "@conversation/naboo_imperial_tier3:s_c9911c0f",
	stopConversation = "true",
	options = {}
}
hakassha_sireen_convo:addScreen(hakassha_sireen_convo_tier3_on_mission)

-- Tier 3 - Mission 1
hakassha_sireen_convo_tier3_first_mission = ConvoScreen:new {
	id = "tier3_first_mission",
	leftDialog = "@conversation/naboo_imperial_tier3:s_51edad38",
	stopConversation = "false",
	options = {
		{"@conversation/naboo_imperial_tier3:s_d70dba34", "tier3_first_mission_details"},
		{"@conversation/naboo_imperial_tier3:s_f8e71988", "accept_tier3_first_mission"},
	}
}
hakassha_sireen_convo:addScreen(hakassha_sireen_convo_tier3_first_mission)

hakassha_sireen_convo_tier3_first_mission_details = ConvoScreen:new {
	id = "tier3_first_mission_details",
	leftDialog = "@conversation/naboo_imperial_tier3:s_d2a2c5a9",
	stopConversation = "false",
	options = {
		{"@conversation/naboo_imperial_tier3:s_f8e71988", "accept_tier3_first_mission"},
	}
}
hakassha_sireen_convo:addScreen(hakassha_sireen_convo_tier3_first_mission_details)

hakassha_sireen_convo_accept_tier3_first_mission = ConvoScreen:new {
	id = "accept_tier3_first_mission",
	leftDialog = "@conversation/naboo_imperial_tier3:s_f64e0998",
	stopConversation = "true",
	options = {}
}
hakassha_sireen_convo:addScreen(hakassha_sireen_convo_accept_tier3_first_mission)

hakassha_sireen_convo_failed_tier3_first_mission = ConvoScreen:new {
	id = "failed_tier3_first_mission",
	leftDialog = "@conversation/naboo_imperial_tier3:s_5a9c71e2",
	stopConversation = "true",
	options = {}
}
hakassha_sireen_convo:addScreen(hakassha_sireen_convo_failed_tier3_first_mission)

hakassha_sireen_convo_tier3_first_mission_success = ConvoScreen:new {
	id = "tier3_first_mission_success",
	leftDialog = "@conversation/naboo_imperial_tier3:s_4b5066f2",
	stopConversation = "false",
	options = {
		-- Training options added dynamically via handler
	}
}
hakassha_sireen_convo:addScreen(hakassha_sireen_convo_tier3_first_mission_success)

-- Tier 3 - Mission 2
hakassha_sireen_convo_tier3_second_mission = ConvoScreen:new {
	id = "tier3_second_mission",
	leftDialog = "@conversation/naboo_imperial_tier3:s_47424e40",
	stopConversation = "false",
	options = {
		{"@conversation/naboo_imperial_tier3:s_d70dba34", "tier3_second_mission_details"},
		{"@conversation/naboo_imperial_tier3:s_f8e71988", "accept_tier3_second_mission"},
	}
}
hakassha_sireen_convo:addScreen(hakassha_sireen_convo_tier3_second_mission)

hakassha_sireen_convo_tier3_second_mission_details = ConvoScreen:new {
	id = "tier3_second_mission_details",
	leftDialog = "@conversation/naboo_imperial_tier3:s_b49d8273",
	stopConversation = "false",
	options = {
		{"@conversation/naboo_imperial_tier3:s_f8e71988", "accept_tier3_second_mission"},
	}
}
hakassha_sireen_convo:addScreen(hakassha_sireen_convo_tier3_second_mission_details)

hakassha_sireen_convo_accept_tier3_second_mission = ConvoScreen:new {
	id = "accept_tier3_second_mission",
	leftDialog = "@conversation/naboo_imperial_tier3:s_6ffd0979",
	stopConversation = "true",
	options = {}
}
hakassha_sireen_convo:addScreen(hakassha_sireen_convo_accept_tier3_second_mission)

hakassha_sireen_convo_failed_tier3_second_mission = ConvoScreen:new {
	id = "failed_tier3_second_mission",
	leftDialog = "@conversation/naboo_imperial_tier3:s_53d34239",
	stopConversation = "true",
	options = {}
}
hakassha_sireen_convo:addScreen(hakassha_sireen_convo_failed_tier3_second_mission)

hakassha_sireen_convo_tier3_second_mission_success = ConvoScreen:new {
	id = "tier3_second_mission_success",
	leftDialog = "@conversation/naboo_imperial_tier3:s_89772a9c",
	stopConversation = "false",
	options = {
		-- Training options added dynamically via handler
	}
}
hakassha_sireen_convo:addScreen(hakassha_sireen_convo_tier3_second_mission_success)

-- Tier 3 - Mission 3
hakassha_sireen_convo_tier3_third_mission = ConvoScreen:new {
	id = "tier3_third_mission",
	leftDialog = "@conversation/naboo_imperial_tier3:s_5400c2b8",
	stopConversation = "false",
	options = {
		{"@conversation/naboo_imperial_tier3:s_d70dba34", "tier3_third_mission_details"},
		{"@conversation/naboo_imperial_tier3:s_f8e71988", "accept_tier3_third_mission"},
	}
}
hakassha_sireen_convo:addScreen(hakassha_sireen_convo_tier3_third_mission)

hakassha_sireen_convo_tier3_third_mission_details = ConvoScreen:new {
	id = "tier3_third_mission_details",
	leftDialog = "@conversation/naboo_imperial_tier3:s_28876e4d",
	stopConversation = "false",
	options = {
		{"@conversation/naboo_imperial_tier3:s_f8e71988", "accept_tier3_third_mission"},
	}
}
hakassha_sireen_convo:addScreen(hakassha_sireen_convo_tier3_third_mission_details)

hakassha_sireen_convo_accept_tier3_third_mission = ConvoScreen:new {
	id = "accept_tier3_third_mission",
	leftDialog = "@conversation/naboo_imperial_tier3:s_b8302127",
	stopConversation = "true",
	options = {}
}
hakassha_sireen_convo:addScreen(hakassha_sireen_convo_accept_tier3_third_mission)

hakassha_sireen_convo_failed_tier3_third_mission = ConvoScreen:new {
	id = "failed_tier3_third_mission",
	leftDialog = "@conversation/naboo_imperial_tier3:s_a425b892",
	stopConversation = "true",
	options = {}
}
hakassha_sireen_convo:addScreen(hakassha_sireen_convo_failed_tier3_third_mission)

hakassha_sireen_convo_tier3_third_mission_success = ConvoScreen:new {
	id = "tier3_third_mission_success",
	leftDialog = "@conversation/naboo_imperial_tier3:s_596a67f0",
	stopConversation = "false",
	options = {
		-- Training options added dynamically via handler
	}
}
hakassha_sireen_convo:addScreen(hakassha_sireen_convo_tier3_third_mission_success)

-- Tier 3 - Mission 4
hakassha_sireen_convo_tier3_fourth_mission = ConvoScreen:new {
	id = "tier3_fourth_mission",
	leftDialog = "@conversation/naboo_imperial_tier3:s_ee64b80a",
	stopConversation = "false",
	options = {
		{"@conversation/naboo_imperial_tier3:s_c142d50f", "tier3_fourth_mission_details"},
		{"@conversation/naboo_imperial_tier3:s_180340a", "accept_tier3_fourth_mission"},
	}
}
hakassha_sireen_convo:addScreen(hakassha_sireen_convo_tier3_fourth_mission)

hakassha_sireen_convo_tier3_fourth_mission_details = ConvoScreen:new {
	id = "tier3_fourth_mission_details",
	leftDialog = "@conversation/naboo_imperial_tier3:s_3bd0f63e",
	stopConversation = "false",
	options = {
		{"@conversation/naboo_imperial_tier3:s_180340a", "accept_tier3_fourth_mission"},
	}
}
hakassha_sireen_convo:addScreen(hakassha_sireen_convo_tier3_fourth_mission_details)

hakassha_sireen_convo_accept_tier3_fourth_mission = ConvoScreen:new {
	id = "accept_tier3_fourth_mission",
	leftDialog = "@conversation/naboo_imperial_tier3:s_6905c6b2",
	stopConversation = "true",
	options = {}
}
hakassha_sireen_convo:addScreen(hakassha_sireen_convo_accept_tier3_fourth_mission)

hakassha_sireen_convo_failed_tier3_fourth_mission = ConvoScreen:new {
	id = "failed_tier3_fourth_mission",
	leftDialog = "@conversation/naboo_imperial_tier3:s_1530dc31",
	stopConversation = "true",
	options = {}
}
hakassha_sireen_convo:addScreen(hakassha_sireen_convo_failed_tier3_fourth_mission)

hakassha_sireen_convo_tier3_fourth_mission_success = ConvoScreen:new {
	id = "tier3_fourth_mission_success",
	leftDialog = "@conversation/naboo_imperial_tier3:s_5df75ba2",
	stopConversation = "false",
	options = {
		-- Training options added dynamically via handler
	}
}
hakassha_sireen_convo:addScreen(hakassha_sireen_convo_tier3_fourth_mission_success)

-- Tier 3 - Training
hakassha_sireen_convo_tier3_train_fighters = ConvoScreen:new {
	id = "tier3_train_fighters",
	leftDialog = "@conversation/naboo_imperial_tier3:s_4c42a50e",
	stopConversation = "true",
	options = {}
}
hakassha_sireen_convo:addScreen(hakassha_sireen_convo_tier3_train_fighters)

hakassha_sireen_convo_tier3_train_component = ConvoScreen:new {
	id = "tier3_train_component",
	leftDialog = "@conversation/naboo_imperial_tier3:s_4c42a50e",
	stopConversation = "true",
	options = {}
}
hakassha_sireen_convo:addScreen(hakassha_sireen_convo_tier3_train_component)

hakassha_sireen_convo_tier3_train_procedures = ConvoScreen:new {
	id = "tier3_train_procedures",
	leftDialog = "@conversation/naboo_imperial_tier3:s_4c42a50e",
	stopConversation = "true",
	options = {}
}
hakassha_sireen_convo:addScreen(hakassha_sireen_convo_tier3_train_procedures)

hakassha_sireen_convo_tier3_train_droid = ConvoScreen:new {
	id = "tier3_train_droid",
	leftDialog = "@conversation/naboo_imperial_tier3:s_4c42a50e",
	stopConversation = "true",
	options = {}
}
hakassha_sireen_convo:addScreen(hakassha_sireen_convo_tier3_train_droid)

-- Tier 3 - Completed
hakassha_sireen_convo_tier3_completed = ConvoScreen:new {
	id = "tier3_completed",
	leftDialog = "@conversation/naboo_imperial_tier3:s_f50e2248",
	stopConversation = "true",
	options = {}
}
hakassha_sireen_convo:addScreen(hakassha_sireen_convo_tier3_completed)

--[[

	Tier 4

]]

-- Tier 4 - Active Mission
hakassha_sireen_convo_tier4_on_mission = ConvoScreen:new {
	id = "tier4_on_mission",
	leftDialog = "@conversation/naboo_imperial_tier4:s_fcbb92d0",
	stopConversation = "true",
	options = {}
}
hakassha_sireen_convo:addScreen(hakassha_sireen_convo_tier4_on_mission)

-- Tier 4 - Initial Briefing
hakassha_sireen_convo_tier4_initial_briefing = ConvoScreen:new {
	id = "tier4_initial_briefing",
	leftDialog = "@conversation/naboo_imperial_tier4:s_59da8c80",
	stopConversation = "false",
	options = {
		{"@conversation/naboo_imperial_tier4:s_c82e9a2f", "tier4_first_mission"},
	}
}
hakassha_sireen_convo:addScreen(hakassha_sireen_convo_tier4_initial_briefing)

-- Tier 4 - Mission 1
hakassha_sireen_convo_tier4_first_mission = ConvoScreen:new {
	id = "tier4_first_mission",
	leftDialog = "@conversation/naboo_imperial_tier4:s_47b7d709",
	stopConversation = "false",
	options = {
		{"@conversation/naboo_imperial_tier4:s_488aa777", "tier4_first_mission_details"},
		{"@conversation/naboo_imperial_tier4:s_e69b471b", "accept_tier4_first_mission"},
	}
}
hakassha_sireen_convo:addScreen(hakassha_sireen_convo_tier4_first_mission)

hakassha_sireen_convo_tier4_first_mission_details = ConvoScreen:new {
	id = "tier4_first_mission_details",
	leftDialog = "@conversation/naboo_imperial_tier4:s_e89ef227",
	stopConversation = "false",
	options = {
		{"@conversation/naboo_imperial_tier4:s_e69b471b", "accept_tier4_first_mission"},
	}
}
hakassha_sireen_convo:addScreen(hakassha_sireen_convo_tier4_first_mission_details)

hakassha_sireen_convo_accept_tier4_first_mission = ConvoScreen:new {
	id = "accept_tier4_first_mission",
	leftDialog = "@conversation/naboo_imperial_tier4:s_6387b3e9",
	stopConversation = "true",
	options = {}
}
hakassha_sireen_convo:addScreen(hakassha_sireen_convo_accept_tier4_first_mission)

hakassha_sireen_convo_failed_tier4_first_mission = ConvoScreen:new {
	id = "failed_tier4_first_mission",
	leftDialog = "@conversation/naboo_imperial_tier4:s_91d10a84",
	stopConversation = "true",
	options = {}
}
hakassha_sireen_convo:addScreen(hakassha_sireen_convo_failed_tier4_first_mission)

hakassha_sireen_convo_tier4_first_mission_success = ConvoScreen:new {
	id = "tier4_first_mission_success",
	leftDialog = "@conversation/naboo_imperial_tier4:s_725be20b",
	stopConversation = "false",
	options = {
		{"@conversation/naboo_imperial_tier4:s_bdebb4cc", "tier4_second_mission"},
	}
}
hakassha_sireen_convo:addScreen(hakassha_sireen_convo_tier4_first_mission_success)

-- Tier 4 - Mission 2
hakassha_sireen_convo_tier4_second_mission = ConvoScreen:new {
	id = "tier4_second_mission",
	leftDialog = "@conversation/naboo_imperial_tier4:s_1e39a0ae",
	stopConversation = "false",
	options = {
		{"@conversation/naboo_imperial_tier4:s_8a38a5ed", "tier4_second_mission_details"},
		{"@conversation/naboo_imperial_tier4:s_6d741d67", "accept_tier4_second_mission"},
	}
}
hakassha_sireen_convo:addScreen(hakassha_sireen_convo_tier4_second_mission)

hakassha_sireen_convo_tier4_second_mission_details = ConvoScreen:new {
	id = "tier4_second_mission_details",
	leftDialog = "@conversation/naboo_imperial_tier4:s_4ee43f47",
	stopConversation = "false",
	options = {
		{"@conversation/naboo_imperial_tier4:s_6d741d67", "accept_tier4_second_mission"},
	}
}
hakassha_sireen_convo:addScreen(hakassha_sireen_convo_tier4_second_mission_details)

hakassha_sireen_convo_accept_tier4_second_mission = ConvoScreen:new {
	id = "accept_tier4_second_mission",
	leftDialog = "@conversation/naboo_imperial_tier4:s_9a9518f8",
	stopConversation = "true",
	options = {}
}
hakassha_sireen_convo:addScreen(hakassha_sireen_convo_accept_tier4_second_mission)

hakassha_sireen_convo_failed_tier4_second_mission = ConvoScreen:new {
	id = "failed_tier4_second_mission",
	leftDialog = "@conversation/naboo_imperial_tier4:s_91d10a84",
	stopConversation = "true",
	options = {}
}
hakassha_sireen_convo:addScreen(hakassha_sireen_convo_failed_tier4_second_mission)

hakassha_sireen_convo_tier4_second_mission_success = ConvoScreen:new {
	id = "tier4_second_mission_success",
	leftDialog = "@conversation/naboo_imperial_tier4:s_417ab2a4",
	stopConversation = "false",
	options = {
		{"@conversation/naboo_imperial_tier4:s_834bed59", "tier4_third_mission"},
	}
}
hakassha_sireen_convo:addScreen(hakassha_sireen_convo_tier4_second_mission_success)

-- Tier 4 - Mission 3
hakassha_sireen_convo_tier4_third_mission = ConvoScreen:new {
	id = "tier4_third_mission",
	leftDialog = "@conversation/naboo_imperial_tier4:s_dafddb17",
	stopConversation = "false",
	options = {
		{"@conversation/naboo_imperial_tier4:s_362a48e0", "tier4_third_mission_details"},
		{"@conversation/naboo_imperial_tier4:s_c17d2691", "accept_tier4_third_mission"},
	}
}
hakassha_sireen_convo:addScreen(hakassha_sireen_convo_tier4_third_mission)

hakassha_sireen_convo_tier4_third_mission_details = ConvoScreen:new {
	id = "tier4_third_mission_details",
	leftDialog = "@conversation/naboo_imperial_tier4:s_4bcaf756",
	stopConversation = "false",
	options = {
		{"@conversation/naboo_imperial_tier4:s_c17d2691", "accept_tier4_third_mission"},
	}
}
hakassha_sireen_convo:addScreen(hakassha_sireen_convo_tier4_third_mission_details)

hakassha_sireen_convo_accept_tier4_third_mission = ConvoScreen:new {
	id = "accept_tier4_third_mission",
	leftDialog = "@conversation/naboo_imperial_tier4:s_db35e23",
	stopConversation = "true",
	options = {}
}
hakassha_sireen_convo:addScreen(hakassha_sireen_convo_accept_tier4_third_mission)

hakassha_sireen_convo_failed_tier4_third_mission = ConvoScreen:new {
	id = "failed_tier4_third_mission",
	leftDialog = "@conversation/naboo_imperial_tier4:s_91d10a84",
	stopConversation = "true",
	options = {}
}
hakassha_sireen_convo:addScreen(hakassha_sireen_convo_failed_tier4_third_mission)

hakassha_sireen_convo_tier4_third_mission_success = ConvoScreen:new {
	id = "tier4_third_mission_success",
	leftDialog = "@conversation/naboo_imperial_tier4:s_aa21cdc1",
	stopConversation = "false",
	options = {
		{"@conversation/naboo_imperial_tier4:s_938d7337", "tier4_fourth_mission"},
	}
}
hakassha_sireen_convo:addScreen(hakassha_sireen_convo_tier4_third_mission_success)

-- Tier 4 - Mission 4
hakassha_sireen_convo_tier4_fourth_mission = ConvoScreen:new {
	id = "tier4_fourth_mission",
	leftDialog = "@conversation/naboo_imperial_tier4:s_1899241d",
	stopConversation = "false",
	options = {
		{"@conversation/naboo_imperial_tier4:s_e07a0513", "tier4_fourth_mission_details"},
		{"@conversation/naboo_imperial_tier4:s_e69b471b", "accept_tier4_fourth_mission"},
	}
}
hakassha_sireen_convo:addScreen(hakassha_sireen_convo_tier4_fourth_mission)

hakassha_sireen_convo_tier4_fourth_mission_details = ConvoScreen:new {
	id = "tier4_fourth_mission_details",
	leftDialog = "@conversation/naboo_imperial_tier4:s_c25d28ef",
	stopConversation = "false",
	options = {
		{"@conversation/naboo_imperial_tier4:s_e69b471b", "accept_tier4_fourth_mission"},
	}
}
hakassha_sireen_convo:addScreen(hakassha_sireen_convo_tier4_fourth_mission_details)

hakassha_sireen_convo_accept_tier4_fourth_mission = ConvoScreen:new {
	id = "accept_tier4_fourth_mission",
	leftDialog = "@conversation/naboo_imperial_tier4:s_320b2029",
	stopConversation = "true",
	options = {}
}
hakassha_sireen_convo:addScreen(hakassha_sireen_convo_accept_tier4_fourth_mission)

hakassha_sireen_convo_failed_tier4_fourth_mission = ConvoScreen:new {
	id = "failed_tier4_fourth_mission",
	leftDialog = "@conversation/naboo_imperial_tier4:s_91d10a84",
	stopConversation = "true",
	options = {}
}
hakassha_sireen_convo:addScreen(hakassha_sireen_convo_failed_tier4_fourth_mission)

hakassha_sireen_convo_tier4_fourth_mission_success = ConvoScreen:new {
	id = "tier4_fourth_mission_success",
	leftDialog = "@conversation/naboo_imperial_tier4:s_6fb4f06a",
	stopConversation = "false",
	options = {
		{"@conversation/naboo_imperial_tier4:s_7177c3f2", "master_who_declann"},
		{"@conversation/naboo_imperial_tier4:s_58edcac7", "master_where_report"},
		{"@conversation/naboo_imperial_tier4:s_fae9dc1b", "master_what_want"},
		{"@conversation/naboo_imperial_tier4:s_a3aef707", "master_becoming_imperial"},
		{"@conversation/naboo_imperial_tier4:s_17fa0de9", "accept_master_mission"},
	}
}
hakassha_sireen_convo:addScreen(hakassha_sireen_convo_tier4_fourth_mission_success)

-- Master mission
hakassha_sireen_convo_master_mission = ConvoScreen:new {
	id = "master_mission",
	leftDialog = "@conversation/naboo_imperial_tier4:s_6fb4f06a",
	stopConversation = "false",
	options = {
		{"@conversation/naboo_imperial_tier4:s_7177c3f2", "master_who_declann"},
		{"@conversation/naboo_imperial_tier4:s_58edcac7", "master_where_report"},
		{"@conversation/naboo_imperial_tier4:s_fae9dc1b", "master_what_want"},
		{"@conversation/naboo_imperial_tier4:s_a3aef707", "master_becoming_imperial"},
		{"@conversation/naboo_imperial_tier4:s_17fa0de9", "accept_master_mission"},
	}
}
hakassha_sireen_convo:addScreen(hakassha_sireen_convo_master_mission)

hakassha_sireen_convo_master_who_declann = ConvoScreen:new {
	id = "master_who_declann",
	leftDialog = "@conversation/naboo_imperial_tier4:s_55905a28",
	stopConversation = "false",
	options = {
		{"@conversation/naboo_imperial_tier4:s_17fa0de9", "accept_master_mission"},
	}
}
hakassha_sireen_convo:addScreen(hakassha_sireen_convo_master_who_declann)

hakassha_sireen_convo_master_where_report = ConvoScreen:new {
	id = "master_where_report",
	leftDialog = "@conversation/naboo_imperial_tier4:s_a0d28eb",
	stopConversation = "false",
	options = {
		{"@conversation/naboo_imperial_tier4:s_17fa0de9", "accept_master_mission"},
	}
}
hakassha_sireen_convo:addScreen(hakassha_sireen_convo_master_where_report)

hakassha_sireen_convo_master_what_want = ConvoScreen:new {
	id = "master_what_want",
	leftDialog = "@conversation/naboo_imperial_tier4:s_cd04b926",
	stopConversation = "false",
	options = {
		{"@conversation/naboo_imperial_tier4:s_17fa0de9", "accept_master_mission"},
	}
}
hakassha_sireen_convo:addScreen(hakassha_sireen_convo_master_what_want)

hakassha_sireen_convo_master_becoming_imperial = ConvoScreen:new {
	id = "master_becoming_imperial",
	leftDialog = "@conversation/naboo_imperial_tier4:s_c33416a7",
	stopConversation = "false",
	options = {
		{"@conversation/naboo_imperial_tier4:s_17fa0de9", "accept_master_mission"},
	}
}
hakassha_sireen_convo:addScreen(hakassha_sireen_convo_master_becoming_imperial)

hakassha_sireen_convo_accept_master_mission = ConvoScreen:new {
	id = "accept_master_mission",
	leftDialog = "@conversation/naboo_imperial_tier4:s_c28f20f3",
	stopConversation = "true",
	options = {}
}
hakassha_sireen_convo:addScreen(hakassha_sireen_convo_accept_master_mission)

-- Tier 4 - Completed
hakassha_sireen_convo_tier4_completed = ConvoScreen:new {
	id = "tier4_completed",
	leftDialog = "@conversation/naboo_imperial_tier4:s_145d7cc3",
	stopConversation = "false",
	options = {
		{"@conversation/naboo_imperial_tier4:s_4854758d", "tier4_duty_repeat"},
	}
}
hakassha_sireen_convo:addScreen(hakassha_sireen_convo_tier4_completed)

-- Tier 4 - Training
hakassha_sireen_convo_ready_train_tier4 = ConvoScreen:new {
	id = "ready_train_tier4",
	leftDialog = "@conversation/naboo_imperial_tier4:s_5dce257f",
	stopConversation = "false",
	options = {
		-- Options added dynamically via handler
	}
}
hakassha_sireen_convo:addScreen(hakassha_sireen_convo_ready_train_tier4)

hakassha_sireen_convo_tier4_train_fighters = ConvoScreen:new {
	id = "tier4_train_fighters",
	leftDialog = "@conversation/naboo_imperial_tier4:s_490da0e3",
	stopConversation = "true",
	options = {}
}
hakassha_sireen_convo:addScreen(hakassha_sireen_convo_tier4_train_fighters)

hakassha_sireen_convo_tier4_train_component = ConvoScreen:new {
	id = "tier4_train_component",
	leftDialog = "@conversation/naboo_imperial_tier4:s_490da0e3",
	stopConversation = "true",
	options = {}
}
hakassha_sireen_convo:addScreen(hakassha_sireen_convo_tier4_train_component)

hakassha_sireen_convo_tier4_train_basics = ConvoScreen:new {
	id = "tier4_train_basics",
	leftDialog = "@conversation/naboo_imperial_tier4:s_490da0e3",
	stopConversation = "true",
	options = {}
}
hakassha_sireen_convo:addScreen(hakassha_sireen_convo_tier4_train_basics)

hakassha_sireen_convo_tier4_train_droid = ConvoScreen:new {
	id = "tier4_train_droid",
	leftDialog = "@conversation/naboo_imperial_tier4:s_490da0e3",
	stopConversation = "true",
	options = {}
}
hakassha_sireen_convo:addScreen(hakassha_sireen_convo_tier4_train_droid)

-- Tier 4 - Duty missions
hakassha_sireen_convo_tier4_duty_repeat = ConvoScreen:new {
	id = "tier4_duty_repeat",
	leftDialog = "@conversation/naboo_imperial_tier4:s_ace49d41",
	stopConversation = "false",
	options = {
		{"@conversation/naboo_imperial_tier4:s_82095b20", "accept_tier4_duty1"},
		{"@conversation/naboo_imperial_tier4:s_be7e95c", "accept_tier4_duty2"},
		{"@conversation/naboo_imperial_tier4:s_60a8bfcb", "accept_tier4_duty3"},
		{"@conversation/naboo_imperial_tier4:s_851406fb", "accept_tier4_duty4"},
		{"@conversation/naboo_imperial_tier4:s_49805f81", "tier4_duty_brief1"},
	}
}
hakassha_sireen_convo:addScreen(hakassha_sireen_convo_tier4_duty_repeat)

hakassha_sireen_convo_tier4_duty_brief1 = ConvoScreen:new {
	id = "tier4_duty_brief1",
	leftDialog = "@conversation/naboo_imperial_tier4:s_85c9e37e",
	stopConversation = "false",
	options = {
		{"@conversation/naboo_imperial_tier4:s_61657d0f", "tier4_duty_brief2"},
	}
}
hakassha_sireen_convo:addScreen(hakassha_sireen_convo_tier4_duty_brief1)

hakassha_sireen_convo_tier4_duty_brief2 = ConvoScreen:new {
	id = "tier4_duty_brief2",
	leftDialog = "@conversation/naboo_imperial_tier4:s_52708145",
	stopConversation = "false",
	options = {
		{"@conversation/naboo_imperial_tier4:s_61657d0f", "tier4_duty_brief3"},
	}
}
hakassha_sireen_convo:addScreen(hakassha_sireen_convo_tier4_duty_brief2)

hakassha_sireen_convo_tier4_duty_brief3 = ConvoScreen:new {
	id = "tier4_duty_brief3",
	leftDialog = "@conversation/naboo_imperial_tier4:s_f76cec26",
	stopConversation = "false",
	options = {
		{"@conversation/naboo_imperial_tier4:s_61657d0f", "tier4_duty_menu"},
	}
}
hakassha_sireen_convo:addScreen(hakassha_sireen_convo_tier4_duty_brief3)

hakassha_sireen_convo_tier4_duty_menu = ConvoScreen:new {
	id = "tier4_duty_menu",
	leftDialog = "@conversation/naboo_imperial_tier4:s_ee9d18a3",
	stopConversation = "false",
	options = {
		{"@conversation/naboo_imperial_tier4:s_82095b20", "accept_tier4_duty1"},
		{"@conversation/naboo_imperial_tier4:s_be7e95c", "accept_tier4_duty2"},
		{"@conversation/naboo_imperial_tier4:s_60a8bfcb", "accept_tier4_duty3"},
		{"@conversation/naboo_imperial_tier4:s_851406fb", "accept_tier4_duty4"},
		{"@conversation/naboo_imperial_tier4:s_49805f81", "tier4_duty_brief1"},
	}
}
hakassha_sireen_convo:addScreen(hakassha_sireen_convo_tier4_duty_menu)

hakassha_sireen_convo_accept_tier4_duty1 = ConvoScreen:new {
	id = "accept_tier4_duty1",
	leftDialog = "@conversation/naboo_imperial_tier4:s_ee5488a5",
	stopConversation = "true",
	options = {}
}
hakassha_sireen_convo:addScreen(hakassha_sireen_convo_accept_tier4_duty1)

hakassha_sireen_convo_accept_tier4_duty2 = ConvoScreen:new {
	id = "accept_tier4_duty2",
	leftDialog = "@conversation/naboo_imperial_tier4:s_ee5488a5",
	stopConversation = "true",
	options = {}
}
hakassha_sireen_convo:addScreen(hakassha_sireen_convo_accept_tier4_duty2)

hakassha_sireen_convo_accept_tier4_duty3 = ConvoScreen:new {
	id = "accept_tier4_duty3",
	leftDialog = "@conversation/naboo_imperial_tier4:s_ee5488a5",
	stopConversation = "true",
	options = {}
}
hakassha_sireen_convo:addScreen(hakassha_sireen_convo_accept_tier4_duty3)

hakassha_sireen_convo_accept_tier4_duty4 = ConvoScreen:new {
	id = "accept_tier4_duty4",
	leftDialog = "@conversation/naboo_imperial_tier4:s_ee5488a5",
	stopConversation = "true",
	options = {}
}
hakassha_sireen_convo:addScreen(hakassha_sireen_convo_accept_tier4_duty4)


addConversationTemplate("hakassha_sireen_convo", hakassha_sireen_convo);
