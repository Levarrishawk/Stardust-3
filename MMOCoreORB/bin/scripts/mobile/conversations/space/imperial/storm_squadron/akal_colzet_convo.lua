--[[
	Lt. Akal Colzet -- Storm Squadron (Imperial) Tier 1 recruiter/trainer conversation.

	Structural port of the proven Inquisition recruiter template, driven by the
	authentic Live Imperial trainer string file extracted from the client TRE:
		string/en/conversation/tatooine_imperial_trainer_1.stf
	Every leftDialog / option below references a real @conversation/tatooine_imperial_trainer_1:s_<hash>
	string from that table (English text shown in the trailing comment, verified against the
	extracted STF). Screen-flow control lives in akalColzetConvoHandler.lua.

	Quest ladder follows the real Imperial trainer storyline told by the STF:
		Q1 patrol (the Bestine Primary Commerce Route) -> Q2 destroy (the commerce raider pirates) ->
		Q3 escort (supply transports / the distress call) -> Q4 assassinate (the pirate leader) ->
		training -> posted to Storm Squadron under Cdr. Oberhaur.

	Every option link target below is a defined screen (the base conv_handler falls back to
	the initial screen when a link target is missing, which presents as "clicking does nothing").
]]

akal_colzet_convo = ConvoTemplate:new {
	initialScreen = "",
	templateType = "Lua",
	luaClassHandler = "akalColzetConvoHandler",
	screens = {}
}

-- JTL Disabled / No Space Expansion
akal_colzet_convo_no_jtl = ConvoScreen:new {
	id = "no_jtl",
	leftDialog = "@conversation/tatooine_imperial_trainer_1:s_6138854f", -- Do you have business with the Imperial Navy? No? Then I suggest that you come back another time.
	stopConversation = "true",
	options = {}
}
akal_colzet_convo:addScreen(akal_colzet_convo_no_jtl)

-- Rebel Pilot (turned away)
akal_colzet_convo_rebel_pilot = ConvoScreen:new {
	id = "rebel_pilot",
	leftDialog = "@conversation/tatooine_imperial_trainer_1:s_2d4337c5", -- I've seen your face! You're a known Rebel pilot! Guards, arrest this man!
	stopConversation = "true",
	animation = "point_accusingly",
	options = {}
}
akal_colzet_convo:addScreen(akal_colzet_convo_rebel_pilot)

-- Neutral/Privateer Pilot (turned away)
akal_colzet_convo_neutral_pilot = ConvoScreen:new {
	id = "neutral_pilot",
	leftDialog = "@conversation/tatooine_imperial_trainer_1:s_1cccf249", -- You are not a pilot in my squadron, and therefore unable to fly any of the missions I have. Go back to your unit and speak with your commanding office
	stopConversation = "true",
	animation = "shrug_shoulders",
	options = {}
}
akal_colzet_convo:addScreen(akal_colzet_convo_neutral_pilot)

-- Imperial pilot, different squadron
akal_colzet_convo_non_inquisition_pilot = ConvoScreen:new {
	id = "non_inquisition_pilot",
	leftDialog = "@conversation/tatooine_imperial_trainer_1:s_966ca13e", -- Ah, yes. You're in my files as a member of the Imperial Navy, but you're not assigned to my roster. What can I do for you?
	stopConversation = "false",
	options = {
		{"@conversation/tatooine_imperial_trainer_1:s_4854758d", "duty_missions"}, -- I would like to request a mission.
	}
}
akal_colzet_convo:addScreen(akal_colzet_convo_non_inquisition_pilot)

--[[ Recruitment flow ]]
akal_colzet_convo_recruitment = ConvoScreen:new {
	id = "recruitment",
	leftDialog = "@conversation/tatooine_imperial_trainer_1:s_b7c14c03", -- Good morning. My name is Lieutenant Akal Colzet, Imperial Navy. I've been assigned to Tatooine to recruit local volunteer pilots into service. Are you
	stopConversation = "false",
	options = {
		{"@conversation/tatooine_imperial_trainer_1:s_3b3aabc1", "yes_join"}, -- I'd like training, sir.
		{"@conversation/tatooine_imperial_trainer_1:s_388cfea9", "why_volunteers"}, -- The Empire is recruiting volunteer pilots?
		{"@conversation/tatooine_imperial_trainer_1:s_37eb1d12", "decline_join"}, -- I'd rather not sign up right now, sir.
	}
}
akal_colzet_convo:addScreen(akal_colzet_convo_recruitment)

akal_colzet_convo_why_volunteers = ConvoScreen:new {
	id = "why_volunteers",
	leftDialog = "@conversation/tatooine_imperial_trainer_1:s_72ed61c", -- Yes, volunteers. Under normal circumstances it takes years of formal education to become a flight officer in the Imperial Navy. Recently, Rebel opposi
	stopConversation = "false",
	options = {
		{"@conversation/tatooine_imperial_trainer_1:s_3b3aabc1", "yes_join"}, -- I'd like training, sir.
		{"@conversation/tatooine_imperial_trainer_1:s_37eb1d12", "decline_join"}, -- I'd rather not sign up right now, sir.
	}
}
akal_colzet_convo:addScreen(akal_colzet_convo_why_volunteers)

akal_colzet_convo_decline_join = ConvoScreen:new {
	id = "decline_join",
	leftDialog = "@conversation/tatooine_imperial_trainer_1:s_6cb86d0c", -- Ah...yes. Good day then.
	stopConversation = "true",
	animation = "goodbye",
	options = {}
}
akal_colzet_convo:addScreen(akal_colzet_convo_decline_join)

-- Player asked to join; the handler redirects this to "join_confirm". Defined with the
-- same content as join_confirm so the flow is intact even without the handler redirect.
akal_colzet_convo_yes_join = ConvoScreen:new {
	id = "yes_join",
	leftDialog = "@conversation/tatooine_imperial_trainer_1:s_a6574c9a", -- Service in the Imperial Navy isn't to be taken lightly.  You'll be expected to follow orders and any association with the Rebellion would be punished
	stopConversation = "false",
	options = {
		{"@conversation/tatooine_imperial_trainer_1:s_68c831e7", "yes_i_am"}, -- Yes. I want to be in the Imperial Navy.
		{"@conversation/tatooine_imperial_trainer_1:s_37eb1d12", "decline_join"}, -- I'd rather not sign up right now, sir.
	}
}
akal_colzet_convo:addScreen(akal_colzet_convo_yes_join)

-- Sign-up confirmation (handler routes "yes_join" here)
akal_colzet_convo_join_confirm = ConvoScreen:new {
	id = "join_confirm",
	leftDialog = "@conversation/tatooine_imperial_trainer_1:s_a6574c9a", -- Service in the Imperial Navy isn't to be taken lightly.  You'll be expected to follow orders and any association with the Rebellion would be punished
	stopConversation = "false",
	options = {
		{"@conversation/tatooine_imperial_trainer_1:s_68c831e7", "yes_i_am"}, -- Yes. I want to be in the Imperial Navy.
		{"@conversation/tatooine_imperial_trainer_1:s_37eb1d12", "decline_join"}, -- I'd rather not sign up right now, sir.
	}
}
akal_colzet_convo:addScreen(akal_colzet_convo_join_confirm)

-- Conscription/welcome (handler grants novice box + squadron + tier here, then adds the ship option)
akal_colzet_convo_yes_i_am = ConvoScreen:new {
	id = "yes_i_am",
	leftDialog = "@conversation/tatooine_imperial_trainer_1:s_2fe328e", -- By the powers vested in me by the Imperial Naval Command, under the ever watchful eye of the Emperor, I hereby conscript you to service with the non-o
	stopConversation = "false",
	options = {}
}
akal_colzet_convo:addScreen(akal_colzet_convo_yes_i_am)

-- No Ship - grants ship
akal_colzet_convo_no_ship = ConvoScreen:new {
	id = "no_ship",
	leftDialog = "@conversation/tatooine_imperial_trainer_1:s_1d0e7364", -- I'm transferring a ship authorization and control device to your datapad. You'll need this to use your TIE Fighter. Should you lose your control devic
	stopConversation = "false",
	animation = "nod_head_multiple",
	options = {
		{"@conversation/tatooine_imperial_trainer_1:s_304d169e", "yes_im_ready"}, -- I am honored, sir.
	}
}
akal_colzet_convo:addScreen(akal_colzet_convo_no_ship)

akal_colzet_convo_yes_ship = ConvoScreen:new {
	id = "yes_ship",
	leftDialog = "@conversation/tatooine_imperial_trainer_1:s_b3408be1", -- Are you ready for your first assignment?
	stopConversation = "false",
	options = {
		{"@conversation/tatooine_imperial_trainer_1:s_5c5b19e2", "yes_im_ready"}, -- Yes, Sir!
	}
}
akal_colzet_convo:addScreen(akal_colzet_convo_yes_ship)

--[[ Tier 1 -- Mission 1: Patrol the Bestine Commerce Route (handler starts patrol_tatooine_imperial_1) ]]
akal_colzet_convo_yes_im_ready = ConvoScreen:new {
	id = "yes_im_ready",
	leftDialog = "@conversation/tatooine_imperial_trainer_1:s_853678d0", -- I have an assignment for you. As you know, ships travel to and from Bestine every day along the Primary Commerce Route. Commercial traffic to Bestine
	stopConversation = "true",
	options = {}
}
akal_colzet_convo:addScreen(akal_colzet_convo_yes_im_ready)

-- Player is on quest 1 and returns before completing it
akal_colzet_convo_first_quest_active = ConvoScreen:new {
	id = "first_quest_active",
	leftDialog = "@conversation/tatooine_imperial_trainer_1:s_37979335", -- Report back to me when you are finished with the patrol.
	stopConversation = "true",
	options = {}
}
akal_colzet_convo:addScreen(akal_colzet_convo_first_quest_active)

-- Quest 1 complete, needs reward (handler rewards on "patrol_complete")
akal_colzet_convo_excellent_work = ConvoScreen:new {
	id = "excellent_work",
	leftDialog = "@conversation/tatooine_imperial_trainer_1:s_36b3ba5a", -- Report on your patrol, pilot.
	stopConversation = "false",
	options = {
		{"@conversation/tatooine_imperial_trainer_1:s_ee91723f", "patrol_complete"}, -- (Relate the facts on the commerce raider attack.)
		{"@conversation/tatooine_imperial_trainer_1:s_a1088c08", "patrol_complete"}, -- Just a simple patrol, sir.
	}
}
akal_colzet_convo:addScreen(akal_colzet_convo_excellent_work)

akal_colzet_convo_patrol_complete = ConvoScreen:new {
	id = "patrol_complete",
	leftDialog = "@conversation/tatooine_imperial_trainer_1:s_4efae056", -- I'm surprised those pirates didn't turn your ship into a burning heap. Here's your payment. Report back to me when you're ready for another job.
	stopConversation = "true",
	options = {}
}
akal_colzet_convo:addScreen(akal_colzet_convo_patrol_complete)

-- Quest 1 failed/aborted
akal_colzet_convo_failed_quest1 = ConvoScreen:new {
	id = "failed_quest1",
	leftDialog = "@conversation/tatooine_imperial_trainer_1:s_8d324b72", -- I've transferred the patrol coordinates to your datapad. Try harder this time, pilot.
	stopConversation = "false",
	options = {
		{"@conversation/tatooine_imperial_trainer_1:s_f91b288f", "retry_quest1"}, -- Very well. I'll fly it again.
	}
}
akal_colzet_convo:addScreen(akal_colzet_convo_failed_quest1)

-- Quest 1 retry acknowledged (handler restarts patrol_tatooine_imperial_1)
akal_colzet_convo_retry_quest1 = ConvoScreen:new {
	id = "retry_quest1",
	leftDialog = "@conversation/tatooine_imperial_trainer_1:s_37979335", -- Report back to me when you are finished with the patrol.
	stopConversation = "true",
	options = {}
}
akal_colzet_convo:addScreen(akal_colzet_convo_retry_quest1)

--[[ Tier 1 -- Mission 2: Destroy the commerce raiders (handler starts destroy_tatooine_imperial_2) ]]
akal_colzet_convo_grant_quest2 = ConvoScreen:new {
	id = "grant_quest2",
	leftDialog = "@conversation/tatooine_imperial_trainer_1:s_c2ef0b45", -- Pilot. You've managed to achieve some level of success, but you are still relatively inexperienced. I have been authorized to give you special instruc
	stopConversation = "false",
	options = {
		{"@conversation/tatooine_imperial_trainer_1:s_16244233", "quest2_accepted"}, -- I'm ready for a mission, sir.
	}
}
akal_colzet_convo:addScreen(akal_colzet_convo_grant_quest2)

akal_colzet_convo_quest2_accepted = ConvoScreen:new {
	id = "quest2_accepted",
	leftDialog = "@conversation/tatooine_imperial_trainer_1:s_abffcfd7", -- Pirate activity is still high enough that we need combat capable pilots on active duty locating and eliminating them. You have free reign to use letha
	stopConversation = "true",
	options = {}
}
akal_colzet_convo:addScreen(akal_colzet_convo_quest2_accepted)

-- Quest 2 rewarded; leads into Mission 3 (handler starts quest 3 on "train_me3")
akal_colzet_convo_excellent_work2 = ConvoScreen:new {
	id = "excellent_work2",
	leftDialog = "@conversation/tatooine_imperial_trainer_1:s_b1f99085", -- This information will please the Naval Command. You have done an impressive job, Pilot. Perhaps you really are all that you claim.
	stopConversation = "false",
	options = {
		{"@conversation/tatooine_imperial_trainer_1:s_16244233", "train_me3"}, -- I'm ready for a mission, sir.
		{"@conversation/tatooine_imperial_trainer_1:s_9237617f", "train_me3"}, -- What about training?
	}
}
akal_colzet_convo:addScreen(akal_colzet_convo_excellent_work2)

-- Mission 3 accepted (handler starts the quest on "train_me3")
akal_colzet_convo_train_me3 = ConvoScreen:new {
	id = "train_me3",
	leftDialog = "@conversation/tatooine_imperial_trainer_1:s_37910d75", -- With the recent increase in pirate activity, our supply transports are at risk. The Empire would like to assign at least one TIE pilot to every transp
	stopConversation = "true",
	options = {}
}
akal_colzet_convo:addScreen(akal_colzet_convo_train_me3)

akal_colzet_convo_failed_quest2 = ConvoScreen:new {
	id = "failed_quest2",
	leftDialog = "@conversation/tatooine_imperial_trainer_1:s_7ba2ac61", -- No excuses! Get back out there and complete your mission, or I'll find someone who can!
	stopConversation = "false",
	options = {
		{"@conversation/tatooine_imperial_trainer_1:s_2c3d0c07", "retry_quest2"}, -- I will find and destroy the enemy, sir.
	}
}
akal_colzet_convo:addScreen(akal_colzet_convo_failed_quest2)

-- Quest 2 retry acknowledged (handler restarts destroy_tatooine_imperial_2)
akal_colzet_convo_retry_quest2 = ConvoScreen:new {
	id = "retry_quest2",
	leftDialog = "@conversation/tatooine_imperial_trainer_1:s_a934fd0c", -- Go ahead then, try again. The destruction of the pirates benefits the Empire's business in this region. Report back to me when your task is complete.
	stopConversation = "true",
	options = {}
}
akal_colzet_convo:addScreen(akal_colzet_convo_retry_quest2)

--[[ Tier 1 -- Mission 3 report (handler grants the reward on "quest3_rewarded") ]]
akal_colzet_convo_excellent_work3 = ConvoScreen:new {
	id = "excellent_work3",
	leftDialog = "@conversation/tatooine_imperial_trainer_1:s_e106780b", -- Good to see you, Pilot.
	stopConversation = "false",
	options = {
		{"@conversation/tatooine_imperial_trainer_1:s_52b712dc", "quest3_rewarded"}, -- (Relate the details of the distress call.)
		{"@conversation/tatooine_imperial_trainer_1:s_d4dd5a28", "quest3_rewarded"}, -- There was a...
	}
}
akal_colzet_convo:addScreen(akal_colzet_convo_excellent_work3)

akal_colzet_convo_quest3_rewarded = ConvoScreen:new {
	id = "quest3_rewarded",
	leftDialog = "@conversation/tatooine_imperial_trainer_1:s_35daf5c2", -- You responded to a rapidly changing situation, eliminated the enemy, and helped secure valuable medical supplies. I'm proud of you, pilot. You've come
	stopConversation = "true",
	options = {}
}
akal_colzet_convo:addScreen(akal_colzet_convo_quest3_rewarded)

akal_colzet_convo_failed_quest3 = ConvoScreen:new {
	id = "failed_quest3",
	leftDialog = "@conversation/tatooine_imperial_trainer_1:s_969498f6", -- I don't want to hear excuses. You haven't earned the right to give excuses. I want you to get back up there and finish that patrol.
	stopConversation = "false",
	options = {
		{"@conversation/tatooine_imperial_trainer_1:s_6d8d3e00", "retry_quest3"}, -- I will not fail you, sir.
	}
}
akal_colzet_convo:addScreen(akal_colzet_convo_failed_quest3)

-- Quest 3 retry acknowledged (handler restarts the quest)
akal_colzet_convo_retry_quest3 = ConvoScreen:new {
	id = "retry_quest3",
	leftDialog = "@conversation/tatooine_imperial_trainer_1:s_adf9eee2", -- Report to me when you've completed your mission.
	stopConversation = "true",
	options = {}
}
akal_colzet_convo:addScreen(akal_colzet_convo_retry_quest3)

--[[ Tier 1 -- Mission 4: Assassinate the pirate leader (handler starts assassinate_tatooine_imperial_4 on "quest4_accepted") ]]
akal_colzet_convo_grant_quest4 = ConvoScreen:new {
	id = "grant_quest4",
	leftDialog = "@conversation/tatooine_imperial_trainer_1:s_5ce97ee2", -- Imperial intelligence has located a suspected pirate leader. He seems to frequent a staging area close to the Bestine Orbital Region. I'm transferring
	stopConversation = "false",
	options = {
		{"@conversation/tatooine_imperial_trainer_1:s_16244233", "quest4_accepted"}, -- I'm ready for a mission, sir.
	}
}
akal_colzet_convo:addScreen(akal_colzet_convo_grant_quest4)

akal_colzet_convo_quest4_accepted = ConvoScreen:new {
	id = "quest4_accepted",
	leftDialog = "@conversation/tatooine_imperial_trainer_1:s_930b7f4c", -- Your job is to locate and eliminate the pirate leader at the coordinates I have given you. Imperial Naval Command believes a decisive strike against t
	stopConversation = "true",
	options = {}
}
akal_colzet_convo:addScreen(akal_colzet_convo_quest4_accepted)

akal_colzet_convo_failed_quest4 = ConvoScreen:new {
	id = "failed_quest4",
	leftDialog = "@conversation/tatooine_imperial_trainer_1:s_a79075ab", -- Report on the status of your operation against the pirate leader, pilot.
	stopConversation = "false",
	options = {
		{"@conversation/tatooine_imperial_trainer_1:s_248cfc90", "retry_quest4"}, -- (Relate information on your inability to defeat the pirate leader.)
	}
}
akal_colzet_convo:addScreen(akal_colzet_convo_failed_quest4)

-- Quest 4 retry acknowledged (handler restarts assassinate_tatooine_imperial_4)
akal_colzet_convo_retry_quest4 = ConvoScreen:new {
	id = "retry_quest4",
	leftDialog = "@conversation/tatooine_imperial_trainer_1:s_f4d10868", -- Report to me when you have completed your mission to claim your bounty.
	stopConversation = "true",
	options = {}
}
akal_colzet_convo:addScreen(akal_colzet_convo_retry_quest4)

--[[ Player has an active (non-first) mission ]]
akal_colzet_convo_has_mission = ConvoScreen:new {
	id = "has_mission",
	leftDialog = "@conversation/tatooine_imperial_trainer_1:s_8c262163", -- Report back to me when you are finished with your current mission.  You can abort your mission if you want to start over.
	stopConversation = "true",
	options = {}
}
akal_colzet_convo:addScreen(akal_colzet_convo_has_mission)

--[[ All four Tier-1 missions complete -> free training choices (handler builds options) ]]
akal_colzet_convo_missions_complete = ConvoScreen:new {
	id = "missions_complete",
	leftDialog = "@conversation/tatooine_imperial_trainer_1:s_d25495b9", -- Pilot, I am singularly impressed. You have mastered the fundamentals of your profession and have performed beyond expectation and all without formal I
	stopConversation = "false",
	options = {}
}
akal_colzet_convo:addScreen(akal_colzet_convo_missions_complete)

--[[ Additional (XP-gated) training (handler builds options) ]]
akal_colzet_convo_more_training = ConvoScreen:new {
	id = "more_training",
	leftDialog = "@conversation/tatooine_imperial_trainer_1:s_bb6caa54", -- You can learn about Imperial technology, weapons, standard Imperial training, or astromech management.
	stopConversation = "false",
	options = {}
}
akal_colzet_convo:addScreen(akal_colzet_convo_more_training)

-- training acknowledgement screens (handler grants the skill then returns the cloned screen)
akal_colzet_convo_train_player_fighters = ConvoScreen:new {
	id = "train_player_fighters",
	leftDialog = "@conversation/tatooine_imperial_trainer_1:s_7c8aca1b", -- Good choice.  Report back when you are ready for an assignment.
	stopConversation = "true",
	options = {}
}
akal_colzet_convo:addScreen(akal_colzet_convo_train_player_fighters)

akal_colzet_convo_train_player_component = ConvoScreen:new {
	id = "train_player_component",
	leftDialog = "@conversation/tatooine_imperial_trainer_1:s_7c8aca1b", -- Good choice.  Report back when you are ready for an assignment.
	stopConversation = "true",
	options = {}
}
akal_colzet_convo:addScreen(akal_colzet_convo_train_player_component)

akal_colzet_convo_train_player_basics = ConvoScreen:new {
	id = "train_player_basics",
	leftDialog = "@conversation/tatooine_imperial_trainer_1:s_7c8aca1b", -- Good choice.  Report back when you are ready for an assignment.
	stopConversation = "true",
	options = {}
}
akal_colzet_convo:addScreen(akal_colzet_convo_train_player_basics)

akal_colzet_convo_train_player_droid = ConvoScreen:new {
	id = "train_player_droid",
	leftDialog = "@conversation/tatooine_imperial_trainer_1:s_7c8aca1b", -- Good choice.  Report back when you are ready for an assignment.
	stopConversation = "true",
	options = {}
}
akal_colzet_convo:addScreen(akal_colzet_convo_train_player_droid)

-- free-training variants (same acknowledgement string)
akal_colzet_convo_train_player_fighters_free = ConvoScreen:new {
	id = "train_player_fighters_free",
	leftDialog = "@conversation/tatooine_imperial_trainer_1:s_7c8aca1b", -- Good choice.  Report back when you are ready for an assignment.
	stopConversation = "true",
	options = {}
}
akal_colzet_convo:addScreen(akal_colzet_convo_train_player_fighters_free)

akal_colzet_convo_train_player_component_free = ConvoScreen:new {
	id = "train_player_component_free",
	leftDialog = "@conversation/tatooine_imperial_trainer_1:s_7c8aca1b", -- Good choice.  Report back when you are ready for an assignment.
	stopConversation = "true",
	options = {}
}
akal_colzet_convo:addScreen(akal_colzet_convo_train_player_component_free)

akal_colzet_convo_train_player_basics_free = ConvoScreen:new {
	id = "train_player_basics_free",
	leftDialog = "@conversation/tatooine_imperial_trainer_1:s_7c8aca1b", -- Good choice.  Report back when you are ready for an assignment.
	stopConversation = "true",
	options = {}
}
akal_colzet_convo:addScreen(akal_colzet_convo_train_player_basics_free)

akal_colzet_convo_train_player_droid_free = ConvoScreen:new {
	id = "train_player_droid_free",
	leftDialog = "@conversation/tatooine_imperial_trainer_1:s_7c8aca1b", -- Good choice.  Report back when you are ready for an assignment.
	stopConversation = "true",
	options = {}
}
akal_colzet_convo:addScreen(akal_colzet_convo_train_player_droid_free)

--[[ Duty missions (Tier-1 grind: destroy / escort duty) ]]
akal_colzet_convo_duty_missions = ConvoScreen:new {
	id = "duty_missions",
	leftDialog = "@conversation/tatooine_imperial_trainer_1:s_d8487693", -- Pilot. I don't have any specific work for you at this time. You can now select your preferred operation from a list of general duties. Or, if you have
	stopConversation = "false",
	options = {
		{"@conversation/tatooine_imperial_trainer_1:s_259013cd", "destroy_duty"}, -- [Destroy Duty] I'm interested in hunting pirates.
		{"@conversation/tatooine_imperial_trainer_1:s_79ab4bbe", "escort_duty"}, -- [Escort Duty] I'm interested in escorting transports.
		{"@conversation/tatooine_imperial_trainer_1:s_6a128385", "what_is_duty"}, -- What is a duty?
	}
}
akal_colzet_convo:addScreen(akal_colzet_convo_duty_missions)

akal_colzet_convo_what_is_duty = ConvoScreen:new {
	id = "what_is_duty",
	leftDialog = "@conversation/tatooine_imperial_trainer_1:s_d25c510b", -- Duty missions are open ended assignments. They end when you choose to end them. For example, if I assign you the task of hunting pirates, you can hunt
	stopConversation = "false",
	options = {
		{"@conversation/tatooine_imperial_trainer_1:s_259013cd", "destroy_duty"}, -- [Destroy Duty] I'm interested in hunting pirates.
		{"@conversation/tatooine_imperial_trainer_1:s_79ab4bbe", "escort_duty"}, -- [Escort Duty] I'm interested in escorting transports.
	}
}
akal_colzet_convo:addScreen(akal_colzet_convo_what_is_duty)

-- Duty accepted (handler starts destroy_duty_tatooine_imperial_6)
akal_colzet_convo_destroy_duty = ConvoScreen:new {
	id = "destroy_duty",
	leftDialog = "@conversation/tatooine_imperial_trainer_1:s_17519607", -- Good luck, pilot. Stay sharp.
	stopConversation = "true",
	options = {}
}
akal_colzet_convo:addScreen(akal_colzet_convo_destroy_duty)

-- Duty accepted (handler starts escort_duty_tatooine_imperial_7)
akal_colzet_convo_escort_duty = ConvoScreen:new {
	id = "escort_duty",
	leftDialog = "@conversation/tatooine_imperial_trainer_1:s_aceff31e", -- Good luck, pilot.
	stopConversation = "true",
	options = {}
}
akal_colzet_convo:addScreen(akal_colzet_convo_escort_duty)

-- recruitment_not_imperial (player not yet faction-aligned)
akal_colzet_convo_recruitment_not_imperial = ConvoScreen:new {
	id = "recruitment_not_imperial",
	leftDialog = "@conversation/tatooine_imperial_trainer_1:s_b7c14c03", -- Good morning. My name is Lieutenant Akal Colzet, Imperial Navy. I've been assigned to Tatooine to recruit local volunteer pilots into service. Are you
	stopConversation = "false",
	options = {
		{"@conversation/tatooine_imperial_trainer_1:s_3b3aabc1", "yes_join"}, -- I'd like training, sir.
		{"@conversation/tatooine_imperial_trainer_1:s_37eb1d12", "decline_join"}, -- I'd rather not sign up right now, sir.
	}
}
akal_colzet_convo:addScreen(akal_colzet_convo_recruitment_not_imperial)

--[[ Tier 1 complete -> posted to Storm Squadron under Cdr. Oberhaur (next trainer) ]]
akal_colzet_convo_completed_sinkko = ConvoScreen:new {
	id = "completed_sinkko",
	leftDialog = "@conversation/tatooine_imperial_trainer_1:s_9465e2c7", -- You must have impressed someone, pilot. You are being posted for consideration to join Storm Squadron. The squadron is a special operations wing based
	stopConversation = "false",
	options = {
		{"@conversation/tatooine_imperial_trainer_1:s_15a6458f", "what_is_inquisition"}, -- What is Oberhaur like?
		{"@conversation/tatooine_imperial_trainer_1:s_de76730a", "report_to_fazoll"}, -- Where is my new assignment?
	}
}
akal_colzet_convo:addScreen(akal_colzet_convo_completed_sinkko)

akal_colzet_convo_what_is_inquisition = ConvoScreen:new {
	id = "what_is_inquisition",
	leftDialog = "@conversation/tatooine_imperial_trainer_1:s_93b4f46e", -- Cdr. Oberhaur is friendly, but a tough man. He'll work you hard. You aren't officially a member of Storm Squadron yet. You need to impress Cdr. Oberha
	stopConversation = "false",
	options = {
		{"@conversation/tatooine_imperial_trainer_1:s_de76730a", "report_to_fazoll"}, -- Where is my new assignment?
	}
}
akal_colzet_convo:addScreen(akal_colzet_convo_what_is_inquisition)

-- Reassignment: grant waypoint to the next trainer (handler sets colzet_finished + waypoint)
akal_colzet_convo_report_to_fazoll = ConvoScreen:new {
	id = "report_to_fazoll",
	leftDialog = "@conversation/tatooine_imperial_trainer_1:s_6b63ee3", -- Stand at attention, Pilot. Having shown skill in combat situations you are being elevated to an Outer Rim security detail. For the time being, I will
	stopConversation = "true",
	options = {}
}
akal_colzet_convo:addScreen(akal_colzet_convo_report_to_fazoll)

-- Player already reassigned, returns to Colzet
akal_colzet_convo_go_to_next = ConvoScreen:new {
	id = "go_to_next",
	leftDialog = "@conversation/tatooine_imperial_trainer_1:s_2e935a2c", -- Good to see you again, pilot. I hope your new assignment is going well. The voluntary conscription program has been quite successful. If there is anyt
	stopConversation = "true",
	options = {}
}
akal_colzet_convo:addScreen(akal_colzet_convo_go_to_next)

--[[

	Tier 2

]]

-- Tier 2 - Active Mission
akal_colzet_convo_tier2_on_mission = ConvoScreen:new {
	id = "tier2_on_mission",
	leftDialog = "@conversation/tatooine_imperial_trainer_2:s_a59c7bd7",
	stopConversation = "true",
	options = {}
}
akal_colzet_convo:addScreen(akal_colzet_convo_tier2_on_mission)

-- Tier 2 - Initial Briefing
akal_colzet_convo_tier2_initial_briefing = ConvoScreen:new {
	id = "tier2_initial_briefing",
	leftDialog = "@conversation/tatooine_imperial_trainer_2:s_41786376",
	stopConversation = "false",
	options = {
		{"@conversation/tatooine_imperial_trainer_2:s_fa3398f3", "tier2_first_mission"},
	}
}
akal_colzet_convo:addScreen(akal_colzet_convo_tier2_initial_briefing)

-- Tier 2 - Mission 1
akal_colzet_convo_tier2_first_mission = ConvoScreen:new {
	id = "tier2_first_mission",
	leftDialog = "@conversation/tatooine_imperial_trainer_2:s_199bd27f",
	stopConversation = "false",
	options = {
		{"@conversation/tatooine_imperial_trainer_2:s_f1be3213", "tier2_first_mission_details"},
		{"@conversation/tatooine_imperial_trainer_2:s_91223b5c", "accept_tier2_first_mission"},
	}
}
akal_colzet_convo:addScreen(akal_colzet_convo_tier2_first_mission)

akal_colzet_convo_tier2_first_mission_details = ConvoScreen:new {
	id = "tier2_first_mission_details",
	leftDialog = "@conversation/tatooine_imperial_trainer_2:s_d2fa677d",
	stopConversation = "false",
	options = {
		{"@conversation/tatooine_imperial_trainer_2:s_91223b5c", "accept_tier2_first_mission"},
	}
}
akal_colzet_convo:addScreen(akal_colzet_convo_tier2_first_mission_details)

akal_colzet_convo_accept_tier2_first_mission = ConvoScreen:new {
	id = "accept_tier2_first_mission",
	leftDialog = "@conversation/tatooine_imperial_trainer_2:s_aceff31e",
	stopConversation = "true",
	options = {}
}
akal_colzet_convo:addScreen(akal_colzet_convo_accept_tier2_first_mission)

akal_colzet_convo_failed_tier2_first_mission = ConvoScreen:new {
	id = "failed_tier2_first_mission",
	leftDialog = "@conversation/tatooine_imperial_trainer_2:s_825fac62",
	stopConversation = "true",
	options = {}
}
akal_colzet_convo:addScreen(akal_colzet_convo_failed_tier2_first_mission)

akal_colzet_convo_tier2_first_mission_success = ConvoScreen:new {
	id = "tier2_first_mission_success",
	leftDialog = "@conversation/tatooine_imperial_trainer_2:s_ad754",
	stopConversation = "false",
	options = {
		{"@conversation/tatooine_imperial_trainer_2:s_daf7bb7d", "tier2_second_mission"},
	}
}
akal_colzet_convo:addScreen(akal_colzet_convo_tier2_first_mission_success)

-- Tier 2 - Mission 2
akal_colzet_convo_tier2_second_mission = ConvoScreen:new {
	id = "tier2_second_mission",
	leftDialog = "@conversation/tatooine_imperial_trainer_2:s_b8791e16",
	stopConversation = "false",
	options = {
		{"@conversation/tatooine_imperial_trainer_2:s_e6765c30", "accept_tier2_second_mission"},
	}
}
akal_colzet_convo:addScreen(akal_colzet_convo_tier2_second_mission)

akal_colzet_convo_accept_tier2_second_mission = ConvoScreen:new {
	id = "accept_tier2_second_mission",
	leftDialog = "@conversation/tatooine_imperial_trainer_2:s_dfdec194",
	stopConversation = "true",
	options = {}
}
akal_colzet_convo:addScreen(akal_colzet_convo_accept_tier2_second_mission)

akal_colzet_convo_failed_tier2_second_mission = ConvoScreen:new {
	id = "failed_tier2_second_mission",
	leftDialog = "@conversation/tatooine_imperial_trainer_2:s_825fac62",
	stopConversation = "true",
	options = {}
}
akal_colzet_convo:addScreen(akal_colzet_convo_failed_tier2_second_mission)

akal_colzet_convo_tier2_second_mission_success = ConvoScreen:new {
	id = "tier2_second_mission_success",
	leftDialog = "@conversation/tatooine_imperial_trainer_2:s_de870f1",
	stopConversation = "false",
	options = {
		{"@conversation/tatooine_imperial_trainer_2:s_3c9b80ee", "tier2_third_mission"},
	}
}
akal_colzet_convo:addScreen(akal_colzet_convo_tier2_second_mission_success)

-- Tier 2 - Mission 3
akal_colzet_convo_tier2_third_mission = ConvoScreen:new {
	id = "tier2_third_mission",
	leftDialog = "@conversation/tatooine_imperial_trainer_2:s_26408ea",
	stopConversation = "false",
	options = {
		{"@conversation/tatooine_imperial_trainer_2:s_6e39f51b", "tier2_third_mission_details"},
		{"@conversation/tatooine_imperial_trainer_2:s_51fe08f5", "accept_tier2_third_mission"},
	}
}
akal_colzet_convo:addScreen(akal_colzet_convo_tier2_third_mission)

akal_colzet_convo_tier2_third_mission_details = ConvoScreen:new {
	id = "tier2_third_mission_details",
	leftDialog = "@conversation/tatooine_imperial_trainer_2:s_b257ddf8",
	stopConversation = "false",
	options = {
		{"@conversation/tatooine_imperial_trainer_2:s_51fe08f5", "accept_tier2_third_mission"},
	}
}
akal_colzet_convo:addScreen(akal_colzet_convo_tier2_third_mission_details)

akal_colzet_convo_accept_tier2_third_mission = ConvoScreen:new {
	id = "accept_tier2_third_mission",
	leftDialog = "@conversation/tatooine_imperial_trainer_2:s_1d63bf5d",
	stopConversation = "true",
	options = {}
}
akal_colzet_convo:addScreen(akal_colzet_convo_accept_tier2_third_mission)

akal_colzet_convo_failed_tier2_third_mission = ConvoScreen:new {
	id = "failed_tier2_third_mission",
	leftDialog = "@conversation/tatooine_imperial_trainer_2:s_825fac62",
	stopConversation = "true",
	options = {}
}
akal_colzet_convo:addScreen(akal_colzet_convo_failed_tier2_third_mission)

akal_colzet_convo_tier2_third_mission_success = ConvoScreen:new {
	id = "tier2_third_mission_success",
	leftDialog = "@conversation/tatooine_imperial_trainer_2:s_2ccef947",
	stopConversation = "true",
	options = {}
}
akal_colzet_convo:addScreen(akal_colzet_convo_tier2_third_mission_success)

-- Tier 2 - Mission 4
akal_colzet_convo_tier2_fourth_mission = ConvoScreen:new {
	id = "tier2_fourth_mission",
	leftDialog = "@conversation/tatooine_imperial_trainer_2:s_196d2fe6",
	stopConversation = "false",
	options = {
		{"@conversation/tatooine_imperial_trainer_2:s_20b3aa70", "tier2_fourth_mission_details"},
		{"@conversation/tatooine_imperial_trainer_2:s_1f033c46", "accept_tier2_fourth_mission"},
	}
}
akal_colzet_convo:addScreen(akal_colzet_convo_tier2_fourth_mission)

akal_colzet_convo_tier2_fourth_mission_details = ConvoScreen:new {
	id = "tier2_fourth_mission_details",
	leftDialog = "@conversation/tatooine_imperial_trainer_2:s_e17af774",
	stopConversation = "false",
	options = {
		{"@conversation/tatooine_imperial_trainer_2:s_1f033c46", "accept_tier2_fourth_mission"},
	}
}
akal_colzet_convo:addScreen(akal_colzet_convo_tier2_fourth_mission_details)

akal_colzet_convo_accept_tier2_fourth_mission = ConvoScreen:new {
	id = "accept_tier2_fourth_mission",
	leftDialog = "@conversation/tatooine_imperial_trainer_2:s_d1fa21c",
	stopConversation = "true",
	options = {}
}
akal_colzet_convo:addScreen(akal_colzet_convo_accept_tier2_fourth_mission)

akal_colzet_convo_failed_tier2_fourth_mission = ConvoScreen:new {
	id = "failed_tier2_fourth_mission",
	leftDialog = "@conversation/tatooine_imperial_trainer_2:s_306da215",
	stopConversation = "true",
	options = {}
}
akal_colzet_convo:addScreen(akal_colzet_convo_failed_tier2_fourth_mission)

akal_colzet_convo_tier2_fourth_mission_success = ConvoScreen:new {
	id = "tier2_fourth_mission_success",
	leftDialog = "@conversation/tatooine_imperial_trainer_2:s_78c7dc33",
	stopConversation = "true",
	options = {}
}
akal_colzet_convo:addScreen(akal_colzet_convo_tier2_fourth_mission_success)

-- Tier 2 - Training
akal_colzet_convo_ready_train_tier2 = ConvoScreen:new {
	id = "ready_train_tier2",
	leftDialog = "@conversation/tatooine_imperial_trainer_2:s_9ac35c60",
	stopConversation = "false",
	options = {
		-- Options added dynamically via handler
	}
}
akal_colzet_convo:addScreen(akal_colzet_convo_ready_train_tier2)

akal_colzet_convo_tier2_train_fighters = ConvoScreen:new {
	id = "tier2_train_fighters",
	leftDialog = "@conversation/tatooine_imperial_trainer_2:s_c4880407",
	stopConversation = "true",
	options = {}
}
akal_colzet_convo:addScreen(akal_colzet_convo_tier2_train_fighters)

akal_colzet_convo_tier2_train_component = ConvoScreen:new {
	id = "tier2_train_component",
	leftDialog = "@conversation/tatooine_imperial_trainer_2:s_241a34a1",
	stopConversation = "true",
	options = {}
}
akal_colzet_convo:addScreen(akal_colzet_convo_tier2_train_component)

akal_colzet_convo_tier2_train_basics = ConvoScreen:new {
	id = "tier2_train_basics",
	leftDialog = "@conversation/tatooine_imperial_trainer_2:s_486da900",
	stopConversation = "true",
	options = {}
}
akal_colzet_convo:addScreen(akal_colzet_convo_tier2_train_basics)

akal_colzet_convo_tier2_train_droid = ConvoScreen:new {
	id = "tier2_train_droid",
	leftDialog = "@conversation/tatooine_imperial_trainer_2:s_31804e15",
	stopConversation = "true",
	options = {}
}
akal_colzet_convo:addScreen(akal_colzet_convo_tier2_train_droid)

-- Tier 2 - Completed
akal_colzet_convo_tier2_completed = ConvoScreen:new {
	id = "tier2_completed",
	leftDialog = "@conversation/tatooine_imperial_trainer_2:s_49be19d2",
	stopConversation = "true",
	options = {}
}
akal_colzet_convo:addScreen(akal_colzet_convo_tier2_completed)

-- Tier 2 - Duty missions
akal_colzet_convo_tier2_duty_repeat = ConvoScreen:new {
	id = "tier2_duty_repeat",
	leftDialog = "@conversation/tatooine_imperial_trainer_2:s_be89481",
	stopConversation = "false",
	options = {
		{"@conversation/tatooine_imperial_trainer_2:s_f0a7a4ef", "accept_tier2_duty1"},
		{"@conversation/tatooine_imperial_trainer_2:s_e84f3a62", "accept_tier2_duty2"},
		{"@conversation/tatooine_imperial_trainer_2:s_e6765c30", "accept_tier2_duty3"},
		{"@conversation/tatooine_imperial_trainer_2:s_b2a924ab", "tier2_duty_brief1"},
	}
}
akal_colzet_convo:addScreen(akal_colzet_convo_tier2_duty_repeat)

akal_colzet_convo_tier2_duty_brief1 = ConvoScreen:new {
	id = "tier2_duty_brief1",
	leftDialog = "@conversation/tatooine_imperial_trainer_2:s_6a6fe80",
	stopConversation = "false",
	options = {
		{"@conversation/tatooine_imperial_trainer_2:s_8efde2ae", "tier2_duty_brief2"},
	}
}
akal_colzet_convo:addScreen(akal_colzet_convo_tier2_duty_brief1)

akal_colzet_convo_tier2_duty_brief2 = ConvoScreen:new {
	id = "tier2_duty_brief2",
	leftDialog = "@conversation/tatooine_imperial_trainer_2:s_9962665d",
	stopConversation = "false",
	options = {
		{"@conversation/tatooine_imperial_trainer_2:s_8efde2ae", "tier2_duty_brief3"},
	}
}
akal_colzet_convo:addScreen(akal_colzet_convo_tier2_duty_brief2)

akal_colzet_convo_tier2_duty_brief3 = ConvoScreen:new {
	id = "tier2_duty_brief3",
	leftDialog = "@conversation/tatooine_imperial_trainer_2:s_b2634e3d",
	stopConversation = "false",
	options = {
		{"@conversation/tatooine_imperial_trainer_2:s_8efde2ae", "tier2_duty_menu"},
	}
}
akal_colzet_convo:addScreen(akal_colzet_convo_tier2_duty_brief3)

akal_colzet_convo_tier2_duty_menu = ConvoScreen:new {
	id = "tier2_duty_menu",
	leftDialog = "@conversation/tatooine_imperial_trainer_2:s_5b4ccb84",
	stopConversation = "false",
	options = {
		{"@conversation/tatooine_imperial_trainer_2:s_f0a7a4ef", "accept_tier2_duty1"},
		{"@conversation/tatooine_imperial_trainer_2:s_e84f3a62", "accept_tier2_duty2"},
		{"@conversation/tatooine_imperial_trainer_2:s_e6765c30", "accept_tier2_duty3"},
		{"@conversation/tatooine_imperial_trainer_2:s_b2a924ab", "tier2_duty_brief1"},
	}
}
akal_colzet_convo:addScreen(akal_colzet_convo_tier2_duty_menu)

akal_colzet_convo_accept_tier2_duty1 = ConvoScreen:new {
	id = "accept_tier2_duty1",
	leftDialog = "@conversation/tatooine_imperial_trainer_2:s_aceff31e",
	stopConversation = "true",
	options = {}
}
akal_colzet_convo:addScreen(akal_colzet_convo_accept_tier2_duty1)

akal_colzet_convo_accept_tier2_duty2 = ConvoScreen:new {
	id = "accept_tier2_duty2",
	leftDialog = "@conversation/tatooine_imperial_trainer_2:s_205f33ca",
	stopConversation = "true",
	options = {}
}
akal_colzet_convo:addScreen(akal_colzet_convo_accept_tier2_duty2)

akal_colzet_convo_accept_tier2_duty3 = ConvoScreen:new {
	id = "accept_tier2_duty3",
	leftDialog = "@conversation/tatooine_imperial_trainer_2:s_4682fc3c",
	stopConversation = "true",
	options = {}
}
akal_colzet_convo:addScreen(akal_colzet_convo_accept_tier2_duty3)

--[[

	Tier 3

]]

-- Tier 3 - Active Mission
akal_colzet_convo_tier3_on_mission = ConvoScreen:new {
	id = "tier3_on_mission",
	leftDialog = "@conversation/tatooine_imperial_tier3:s_c9911c0f",
	stopConversation = "true",
	options = {}
}
akal_colzet_convo:addScreen(akal_colzet_convo_tier3_on_mission)

-- Tier 3 - Mission 1
akal_colzet_convo_tier3_first_mission = ConvoScreen:new {
	id = "tier3_first_mission",
	leftDialog = "@conversation/tatooine_imperial_tier3:s_51edad38",
	stopConversation = "false",
	options = {
		{"@conversation/tatooine_imperial_tier3:s_d70dba34", "tier3_first_mission_details"},
		{"@conversation/tatooine_imperial_tier3:s_f8e71988", "accept_tier3_first_mission"},
	}
}
akal_colzet_convo:addScreen(akal_colzet_convo_tier3_first_mission)

akal_colzet_convo_tier3_first_mission_details = ConvoScreen:new {
	id = "tier3_first_mission_details",
	leftDialog = "@conversation/tatooine_imperial_tier3:s_d2a2c5a9",
	stopConversation = "false",
	options = {
		{"@conversation/tatooine_imperial_tier3:s_f8e71988", "accept_tier3_first_mission"},
	}
}
akal_colzet_convo:addScreen(akal_colzet_convo_tier3_first_mission_details)

akal_colzet_convo_accept_tier3_first_mission = ConvoScreen:new {
	id = "accept_tier3_first_mission",
	leftDialog = "@conversation/tatooine_imperial_tier3:s_f64e0998",
	stopConversation = "true",
	options = {}
}
akal_colzet_convo:addScreen(akal_colzet_convo_accept_tier3_first_mission)

akal_colzet_convo_failed_tier3_first_mission = ConvoScreen:new {
	id = "failed_tier3_first_mission",
	leftDialog = "@conversation/tatooine_imperial_tier3:s_5a9c71e2",
	stopConversation = "true",
	options = {}
}
akal_colzet_convo:addScreen(akal_colzet_convo_failed_tier3_first_mission)

akal_colzet_convo_tier3_first_mission_success = ConvoScreen:new {
	id = "tier3_first_mission_success",
	leftDialog = "@conversation/tatooine_imperial_tier3:s_4b5066f2",
	stopConversation = "false",
	options = {
		-- Training options added dynamically via handler
	}
}
akal_colzet_convo:addScreen(akal_colzet_convo_tier3_first_mission_success)

-- Tier 3 - Mission 2
akal_colzet_convo_tier3_second_mission = ConvoScreen:new {
	id = "tier3_second_mission",
	leftDialog = "@conversation/tatooine_imperial_tier3:s_47424e40",
	stopConversation = "false",
	options = {
		{"@conversation/tatooine_imperial_tier3:s_d70dba34", "tier3_second_mission_details"},
		{"@conversation/tatooine_imperial_tier3:s_f8e71988", "accept_tier3_second_mission"},
	}
}
akal_colzet_convo:addScreen(akal_colzet_convo_tier3_second_mission)

akal_colzet_convo_tier3_second_mission_details = ConvoScreen:new {
	id = "tier3_second_mission_details",
	leftDialog = "@conversation/tatooine_imperial_tier3:s_b49d8273",
	stopConversation = "false",
	options = {
		{"@conversation/tatooine_imperial_tier3:s_f8e71988", "accept_tier3_second_mission"},
	}
}
akal_colzet_convo:addScreen(akal_colzet_convo_tier3_second_mission_details)

akal_colzet_convo_accept_tier3_second_mission = ConvoScreen:new {
	id = "accept_tier3_second_mission",
	leftDialog = "@conversation/tatooine_imperial_tier3:s_6ffd0979",
	stopConversation = "true",
	options = {}
}
akal_colzet_convo:addScreen(akal_colzet_convo_accept_tier3_second_mission)

akal_colzet_convo_failed_tier3_second_mission = ConvoScreen:new {
	id = "failed_tier3_second_mission",
	leftDialog = "@conversation/tatooine_imperial_tier3:s_53d34239",
	stopConversation = "true",
	options = {}
}
akal_colzet_convo:addScreen(akal_colzet_convo_failed_tier3_second_mission)

akal_colzet_convo_tier3_second_mission_success = ConvoScreen:new {
	id = "tier3_second_mission_success",
	leftDialog = "@conversation/tatooine_imperial_tier3:s_89772a9c",
	stopConversation = "false",
	options = {
		-- Training options added dynamically via handler
	}
}
akal_colzet_convo:addScreen(akal_colzet_convo_tier3_second_mission_success)

-- Tier 3 - Mission 3
akal_colzet_convo_tier3_third_mission = ConvoScreen:new {
	id = "tier3_third_mission",
	leftDialog = "@conversation/tatooine_imperial_tier3:s_5400c2b8",
	stopConversation = "false",
	options = {
		{"@conversation/tatooine_imperial_tier3:s_d70dba34", "tier3_third_mission_details"},
		{"@conversation/tatooine_imperial_tier3:s_f8e71988", "accept_tier3_third_mission"},
	}
}
akal_colzet_convo:addScreen(akal_colzet_convo_tier3_third_mission)

akal_colzet_convo_tier3_third_mission_details = ConvoScreen:new {
	id = "tier3_third_mission_details",
	leftDialog = "@conversation/tatooine_imperial_tier3:s_28876e4d",
	stopConversation = "false",
	options = {
		{"@conversation/tatooine_imperial_tier3:s_f8e71988", "accept_tier3_third_mission"},
	}
}
akal_colzet_convo:addScreen(akal_colzet_convo_tier3_third_mission_details)

akal_colzet_convo_accept_tier3_third_mission = ConvoScreen:new {
	id = "accept_tier3_third_mission",
	leftDialog = "@conversation/tatooine_imperial_tier3:s_b8302127",
	stopConversation = "true",
	options = {}
}
akal_colzet_convo:addScreen(akal_colzet_convo_accept_tier3_third_mission)

akal_colzet_convo_failed_tier3_third_mission = ConvoScreen:new {
	id = "failed_tier3_third_mission",
	leftDialog = "@conversation/tatooine_imperial_tier3:s_a425b892",
	stopConversation = "true",
	options = {}
}
akal_colzet_convo:addScreen(akal_colzet_convo_failed_tier3_third_mission)

akal_colzet_convo_tier3_third_mission_success = ConvoScreen:new {
	id = "tier3_third_mission_success",
	leftDialog = "@conversation/tatooine_imperial_tier3:s_596a67f0",
	stopConversation = "false",
	options = {
		-- Training options added dynamically via handler
	}
}
akal_colzet_convo:addScreen(akal_colzet_convo_tier3_third_mission_success)

-- Tier 3 - Mission 4
akal_colzet_convo_tier3_fourth_mission = ConvoScreen:new {
	id = "tier3_fourth_mission",
	leftDialog = "@conversation/tatooine_imperial_tier3:s_ee64b80a",
	stopConversation = "false",
	options = {
		{"@conversation/tatooine_imperial_tier3:s_c142d50f", "tier3_fourth_mission_details"},
		{"@conversation/tatooine_imperial_tier3:s_180340a", "accept_tier3_fourth_mission"},
	}
}
akal_colzet_convo:addScreen(akal_colzet_convo_tier3_fourth_mission)

akal_colzet_convo_tier3_fourth_mission_details = ConvoScreen:new {
	id = "tier3_fourth_mission_details",
	leftDialog = "@conversation/tatooine_imperial_tier3:s_3bd0f63e",
	stopConversation = "false",
	options = {
		{"@conversation/tatooine_imperial_tier3:s_180340a", "accept_tier3_fourth_mission"},
	}
}
akal_colzet_convo:addScreen(akal_colzet_convo_tier3_fourth_mission_details)

akal_colzet_convo_accept_tier3_fourth_mission = ConvoScreen:new {
	id = "accept_tier3_fourth_mission",
	leftDialog = "@conversation/tatooine_imperial_tier3:s_6905c6b2",
	stopConversation = "true",
	options = {}
}
akal_colzet_convo:addScreen(akal_colzet_convo_accept_tier3_fourth_mission)

akal_colzet_convo_failed_tier3_fourth_mission = ConvoScreen:new {
	id = "failed_tier3_fourth_mission",
	leftDialog = "@conversation/tatooine_imperial_tier3:s_1530dc31",
	stopConversation = "true",
	options = {}
}
akal_colzet_convo:addScreen(akal_colzet_convo_failed_tier3_fourth_mission)

akal_colzet_convo_tier3_fourth_mission_success = ConvoScreen:new {
	id = "tier3_fourth_mission_success",
	leftDialog = "@conversation/tatooine_imperial_tier3:s_5df75ba2",
	stopConversation = "false",
	options = {
		-- Training options added dynamically via handler
	}
}
akal_colzet_convo:addScreen(akal_colzet_convo_tier3_fourth_mission_success)

-- Tier 3 - Training
akal_colzet_convo_tier3_train_fighters = ConvoScreen:new {
	id = "tier3_train_fighters",
	leftDialog = "@conversation/tatooine_imperial_tier3:s_4c42a50e",
	stopConversation = "true",
	options = {}
}
akal_colzet_convo:addScreen(akal_colzet_convo_tier3_train_fighters)

akal_colzet_convo_tier3_train_component = ConvoScreen:new {
	id = "tier3_train_component",
	leftDialog = "@conversation/tatooine_imperial_tier3:s_4c42a50e",
	stopConversation = "true",
	options = {}
}
akal_colzet_convo:addScreen(akal_colzet_convo_tier3_train_component)

akal_colzet_convo_tier3_train_procedures = ConvoScreen:new {
	id = "tier3_train_procedures",
	leftDialog = "@conversation/tatooine_imperial_tier3:s_4c42a50e",
	stopConversation = "true",
	options = {}
}
akal_colzet_convo:addScreen(akal_colzet_convo_tier3_train_procedures)

akal_colzet_convo_tier3_train_droid = ConvoScreen:new {
	id = "tier3_train_droid",
	leftDialog = "@conversation/tatooine_imperial_tier3:s_4c42a50e",
	stopConversation = "true",
	options = {}
}
akal_colzet_convo:addScreen(akal_colzet_convo_tier3_train_droid)

-- Tier 3 - Completed
akal_colzet_convo_tier3_completed = ConvoScreen:new {
	id = "tier3_completed",
	leftDialog = "@conversation/tatooine_imperial_tier3:s_f50e2248",
	stopConversation = "true",
	options = {}
}
akal_colzet_convo:addScreen(akal_colzet_convo_tier3_completed)

--[[

	Tier 4

]]

-- Tier 4 - Active Mission
akal_colzet_convo_tier4_on_mission = ConvoScreen:new {
	id = "tier4_on_mission",
	leftDialog = "@conversation/naboo_imperial_tier4:s_fcbb92d0",
	stopConversation = "true",
	options = {}
}
akal_colzet_convo:addScreen(akal_colzet_convo_tier4_on_mission)

-- Tier 4 - Initial Briefing
akal_colzet_convo_tier4_initial_briefing = ConvoScreen:new {
	id = "tier4_initial_briefing",
	leftDialog = "@conversation/naboo_imperial_tier4:s_59da8c80",
	stopConversation = "false",
	options = {
		{"@conversation/naboo_imperial_tier4:s_c82e9a2f", "tier4_first_mission"},
	}
}
akal_colzet_convo:addScreen(akal_colzet_convo_tier4_initial_briefing)

-- Tier 4 - Mission 1
akal_colzet_convo_tier4_first_mission = ConvoScreen:new {
	id = "tier4_first_mission",
	leftDialog = "@conversation/naboo_imperial_tier4:s_47b7d709",
	stopConversation = "false",
	options = {
		{"@conversation/naboo_imperial_tier4:s_488aa777", "tier4_first_mission_details"},
		{"@conversation/naboo_imperial_tier4:s_e69b471b", "accept_tier4_first_mission"},
	}
}
akal_colzet_convo:addScreen(akal_colzet_convo_tier4_first_mission)

akal_colzet_convo_tier4_first_mission_details = ConvoScreen:new {
	id = "tier4_first_mission_details",
	leftDialog = "@conversation/naboo_imperial_tier4:s_e89ef227",
	stopConversation = "false",
	options = {
		{"@conversation/naboo_imperial_tier4:s_e69b471b", "accept_tier4_first_mission"},
	}
}
akal_colzet_convo:addScreen(akal_colzet_convo_tier4_first_mission_details)

akal_colzet_convo_accept_tier4_first_mission = ConvoScreen:new {
	id = "accept_tier4_first_mission",
	leftDialog = "@conversation/naboo_imperial_tier4:s_6387b3e9",
	stopConversation = "true",
	options = {}
}
akal_colzet_convo:addScreen(akal_colzet_convo_accept_tier4_first_mission)

akal_colzet_convo_failed_tier4_first_mission = ConvoScreen:new {
	id = "failed_tier4_first_mission",
	leftDialog = "@conversation/naboo_imperial_tier4:s_91d10a84",
	stopConversation = "true",
	options = {}
}
akal_colzet_convo:addScreen(akal_colzet_convo_failed_tier4_first_mission)

akal_colzet_convo_tier4_first_mission_success = ConvoScreen:new {
	id = "tier4_first_mission_success",
	leftDialog = "@conversation/naboo_imperial_tier4:s_725be20b",
	stopConversation = "false",
	options = {
		{"@conversation/naboo_imperial_tier4:s_bdebb4cc", "tier4_second_mission"},
	}
}
akal_colzet_convo:addScreen(akal_colzet_convo_tier4_first_mission_success)

-- Tier 4 - Mission 2
akal_colzet_convo_tier4_second_mission = ConvoScreen:new {
	id = "tier4_second_mission",
	leftDialog = "@conversation/naboo_imperial_tier4:s_1e39a0ae",
	stopConversation = "false",
	options = {
		{"@conversation/naboo_imperial_tier4:s_8a38a5ed", "tier4_second_mission_details"},
		{"@conversation/naboo_imperial_tier4:s_6d741d67", "accept_tier4_second_mission"},
	}
}
akal_colzet_convo:addScreen(akal_colzet_convo_tier4_second_mission)

akal_colzet_convo_tier4_second_mission_details = ConvoScreen:new {
	id = "tier4_second_mission_details",
	leftDialog = "@conversation/naboo_imperial_tier4:s_4ee43f47",
	stopConversation = "false",
	options = {
		{"@conversation/naboo_imperial_tier4:s_6d741d67", "accept_tier4_second_mission"},
	}
}
akal_colzet_convo:addScreen(akal_colzet_convo_tier4_second_mission_details)

akal_colzet_convo_accept_tier4_second_mission = ConvoScreen:new {
	id = "accept_tier4_second_mission",
	leftDialog = "@conversation/naboo_imperial_tier4:s_9a9518f8",
	stopConversation = "true",
	options = {}
}
akal_colzet_convo:addScreen(akal_colzet_convo_accept_tier4_second_mission)

akal_colzet_convo_failed_tier4_second_mission = ConvoScreen:new {
	id = "failed_tier4_second_mission",
	leftDialog = "@conversation/naboo_imperial_tier4:s_91d10a84",
	stopConversation = "true",
	options = {}
}
akal_colzet_convo:addScreen(akal_colzet_convo_failed_tier4_second_mission)

akal_colzet_convo_tier4_second_mission_success = ConvoScreen:new {
	id = "tier4_second_mission_success",
	leftDialog = "@conversation/naboo_imperial_tier4:s_417ab2a4",
	stopConversation = "false",
	options = {
		{"@conversation/naboo_imperial_tier4:s_834bed59", "tier4_third_mission"},
	}
}
akal_colzet_convo:addScreen(akal_colzet_convo_tier4_second_mission_success)

-- Tier 4 - Mission 3
akal_colzet_convo_tier4_third_mission = ConvoScreen:new {
	id = "tier4_third_mission",
	leftDialog = "@conversation/naboo_imperial_tier4:s_dafddb17",
	stopConversation = "false",
	options = {
		{"@conversation/naboo_imperial_tier4:s_362a48e0", "tier4_third_mission_details"},
		{"@conversation/naboo_imperial_tier4:s_c17d2691", "accept_tier4_third_mission"},
	}
}
akal_colzet_convo:addScreen(akal_colzet_convo_tier4_third_mission)

akal_colzet_convo_tier4_third_mission_details = ConvoScreen:new {
	id = "tier4_third_mission_details",
	leftDialog = "@conversation/naboo_imperial_tier4:s_4bcaf756",
	stopConversation = "false",
	options = {
		{"@conversation/naboo_imperial_tier4:s_c17d2691", "accept_tier4_third_mission"},
	}
}
akal_colzet_convo:addScreen(akal_colzet_convo_tier4_third_mission_details)

akal_colzet_convo_accept_tier4_third_mission = ConvoScreen:new {
	id = "accept_tier4_third_mission",
	leftDialog = "@conversation/naboo_imperial_tier4:s_db35e23",
	stopConversation = "true",
	options = {}
}
akal_colzet_convo:addScreen(akal_colzet_convo_accept_tier4_third_mission)

akal_colzet_convo_failed_tier4_third_mission = ConvoScreen:new {
	id = "failed_tier4_third_mission",
	leftDialog = "@conversation/naboo_imperial_tier4:s_91d10a84",
	stopConversation = "true",
	options = {}
}
akal_colzet_convo:addScreen(akal_colzet_convo_failed_tier4_third_mission)

akal_colzet_convo_tier4_third_mission_success = ConvoScreen:new {
	id = "tier4_third_mission_success",
	leftDialog = "@conversation/naboo_imperial_tier4:s_aa21cdc1",
	stopConversation = "false",
	options = {
		{"@conversation/naboo_imperial_tier4:s_938d7337", "tier4_fourth_mission"},
	}
}
akal_colzet_convo:addScreen(akal_colzet_convo_tier4_third_mission_success)

-- Tier 4 - Mission 4
akal_colzet_convo_tier4_fourth_mission = ConvoScreen:new {
	id = "tier4_fourth_mission",
	leftDialog = "@conversation/naboo_imperial_tier4:s_1899241d",
	stopConversation = "false",
	options = {
		{"@conversation/naboo_imperial_tier4:s_e07a0513", "tier4_fourth_mission_details"},
		{"@conversation/naboo_imperial_tier4:s_e69b471b", "accept_tier4_fourth_mission"},
	}
}
akal_colzet_convo:addScreen(akal_colzet_convo_tier4_fourth_mission)

akal_colzet_convo_tier4_fourth_mission_details = ConvoScreen:new {
	id = "tier4_fourth_mission_details",
	leftDialog = "@conversation/naboo_imperial_tier4:s_c25d28ef",
	stopConversation = "false",
	options = {
		{"@conversation/naboo_imperial_tier4:s_e69b471b", "accept_tier4_fourth_mission"},
	}
}
akal_colzet_convo:addScreen(akal_colzet_convo_tier4_fourth_mission_details)

akal_colzet_convo_accept_tier4_fourth_mission = ConvoScreen:new {
	id = "accept_tier4_fourth_mission",
	leftDialog = "@conversation/naboo_imperial_tier4:s_320b2029",
	stopConversation = "true",
	options = {}
}
akal_colzet_convo:addScreen(akal_colzet_convo_accept_tier4_fourth_mission)

akal_colzet_convo_failed_tier4_fourth_mission = ConvoScreen:new {
	id = "failed_tier4_fourth_mission",
	leftDialog = "@conversation/naboo_imperial_tier4:s_91d10a84",
	stopConversation = "true",
	options = {}
}
akal_colzet_convo:addScreen(akal_colzet_convo_failed_tier4_fourth_mission)

akal_colzet_convo_tier4_fourth_mission_success = ConvoScreen:new {
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
akal_colzet_convo:addScreen(akal_colzet_convo_tier4_fourth_mission_success)

-- Master mission
akal_colzet_convo_master_mission = ConvoScreen:new {
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
akal_colzet_convo:addScreen(akal_colzet_convo_master_mission)

akal_colzet_convo_master_who_declann = ConvoScreen:new {
	id = "master_who_declann",
	leftDialog = "@conversation/naboo_imperial_tier4:s_55905a28",
	stopConversation = "false",
	options = {
		{"@conversation/naboo_imperial_tier4:s_17fa0de9", "accept_master_mission"},
	}
}
akal_colzet_convo:addScreen(akal_colzet_convo_master_who_declann)

akal_colzet_convo_master_where_report = ConvoScreen:new {
	id = "master_where_report",
	leftDialog = "@conversation/naboo_imperial_tier4:s_a0d28eb",
	stopConversation = "false",
	options = {
		{"@conversation/naboo_imperial_tier4:s_17fa0de9", "accept_master_mission"},
	}
}
akal_colzet_convo:addScreen(akal_colzet_convo_master_where_report)

akal_colzet_convo_master_what_want = ConvoScreen:new {
	id = "master_what_want",
	leftDialog = "@conversation/naboo_imperial_tier4:s_cd04b926",
	stopConversation = "false",
	options = {
		{"@conversation/naboo_imperial_tier4:s_17fa0de9", "accept_master_mission"},
	}
}
akal_colzet_convo:addScreen(akal_colzet_convo_master_what_want)

akal_colzet_convo_master_becoming_imperial = ConvoScreen:new {
	id = "master_becoming_imperial",
	leftDialog = "@conversation/naboo_imperial_tier4:s_c33416a7",
	stopConversation = "false",
	options = {
		{"@conversation/naboo_imperial_tier4:s_17fa0de9", "accept_master_mission"},
	}
}
akal_colzet_convo:addScreen(akal_colzet_convo_master_becoming_imperial)

akal_colzet_convo_accept_master_mission = ConvoScreen:new {
	id = "accept_master_mission",
	leftDialog = "@conversation/naboo_imperial_tier4:s_c28f20f3",
	stopConversation = "true",
	options = {}
}
akal_colzet_convo:addScreen(akal_colzet_convo_accept_master_mission)

-- Tier 4 - Completed
akal_colzet_convo_tier4_completed = ConvoScreen:new {
	id = "tier4_completed",
	leftDialog = "@conversation/naboo_imperial_tier4:s_145d7cc3",
	stopConversation = "false",
	options = {
		{"@conversation/naboo_imperial_tier4:s_4854758d", "tier4_duty_repeat"},
	}
}
akal_colzet_convo:addScreen(akal_colzet_convo_tier4_completed)

-- Tier 4 - Training
akal_colzet_convo_ready_train_tier4 = ConvoScreen:new {
	id = "ready_train_tier4",
	leftDialog = "@conversation/naboo_imperial_tier4:s_5dce257f",
	stopConversation = "false",
	options = {
		-- Options added dynamically via handler
	}
}
akal_colzet_convo:addScreen(akal_colzet_convo_ready_train_tier4)

akal_colzet_convo_tier4_train_fighters = ConvoScreen:new {
	id = "tier4_train_fighters",
	leftDialog = "@conversation/naboo_imperial_tier4:s_490da0e3",
	stopConversation = "true",
	options = {}
}
akal_colzet_convo:addScreen(akal_colzet_convo_tier4_train_fighters)

akal_colzet_convo_tier4_train_component = ConvoScreen:new {
	id = "tier4_train_component",
	leftDialog = "@conversation/naboo_imperial_tier4:s_490da0e3",
	stopConversation = "true",
	options = {}
}
akal_colzet_convo:addScreen(akal_colzet_convo_tier4_train_component)

akal_colzet_convo_tier4_train_basics = ConvoScreen:new {
	id = "tier4_train_basics",
	leftDialog = "@conversation/naboo_imperial_tier4:s_490da0e3",
	stopConversation = "true",
	options = {}
}
akal_colzet_convo:addScreen(akal_colzet_convo_tier4_train_basics)

akal_colzet_convo_tier4_train_droid = ConvoScreen:new {
	id = "tier4_train_droid",
	leftDialog = "@conversation/naboo_imperial_tier4:s_490da0e3",
	stopConversation = "true",
	options = {}
}
akal_colzet_convo:addScreen(akal_colzet_convo_tier4_train_droid)

-- Tier 4 - Duty missions
akal_colzet_convo_tier4_duty_repeat = ConvoScreen:new {
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
akal_colzet_convo:addScreen(akal_colzet_convo_tier4_duty_repeat)

akal_colzet_convo_tier4_duty_brief1 = ConvoScreen:new {
	id = "tier4_duty_brief1",
	leftDialog = "@conversation/naboo_imperial_tier4:s_85c9e37e",
	stopConversation = "false",
	options = {
		{"@conversation/naboo_imperial_tier4:s_61657d0f", "tier4_duty_brief2"},
	}
}
akal_colzet_convo:addScreen(akal_colzet_convo_tier4_duty_brief1)

akal_colzet_convo_tier4_duty_brief2 = ConvoScreen:new {
	id = "tier4_duty_brief2",
	leftDialog = "@conversation/naboo_imperial_tier4:s_52708145",
	stopConversation = "false",
	options = {
		{"@conversation/naboo_imperial_tier4:s_61657d0f", "tier4_duty_brief3"},
	}
}
akal_colzet_convo:addScreen(akal_colzet_convo_tier4_duty_brief2)

akal_colzet_convo_tier4_duty_brief3 = ConvoScreen:new {
	id = "tier4_duty_brief3",
	leftDialog = "@conversation/naboo_imperial_tier4:s_f76cec26",
	stopConversation = "false",
	options = {
		{"@conversation/naboo_imperial_tier4:s_61657d0f", "tier4_duty_menu"},
	}
}
akal_colzet_convo:addScreen(akal_colzet_convo_tier4_duty_brief3)

akal_colzet_convo_tier4_duty_menu = ConvoScreen:new {
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
akal_colzet_convo:addScreen(akal_colzet_convo_tier4_duty_menu)

akal_colzet_convo_accept_tier4_duty1 = ConvoScreen:new {
	id = "accept_tier4_duty1",
	leftDialog = "@conversation/naboo_imperial_tier4:s_ee5488a5",
	stopConversation = "true",
	options = {}
}
akal_colzet_convo:addScreen(akal_colzet_convo_accept_tier4_duty1)

akal_colzet_convo_accept_tier4_duty2 = ConvoScreen:new {
	id = "accept_tier4_duty2",
	leftDialog = "@conversation/naboo_imperial_tier4:s_ee5488a5",
	stopConversation = "true",
	options = {}
}
akal_colzet_convo:addScreen(akal_colzet_convo_accept_tier4_duty2)

akal_colzet_convo_accept_tier4_duty3 = ConvoScreen:new {
	id = "accept_tier4_duty3",
	leftDialog = "@conversation/naboo_imperial_tier4:s_ee5488a5",
	stopConversation = "true",
	options = {}
}
akal_colzet_convo:addScreen(akal_colzet_convo_accept_tier4_duty3)

akal_colzet_convo_accept_tier4_duty4 = ConvoScreen:new {
	id = "accept_tier4_duty4",
	leftDialog = "@conversation/naboo_imperial_tier4:s_ee5488a5",
	stopConversation = "true",
	options = {}
}
akal_colzet_convo:addScreen(akal_colzet_convo_accept_tier4_duty4)


addConversationTemplate("akal_colzet_convo", akal_colzet_convo);
