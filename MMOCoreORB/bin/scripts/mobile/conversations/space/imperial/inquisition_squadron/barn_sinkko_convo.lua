--[[
	Lt. Barn Sinkko -- Inquisition Squadron (Imperial) Tier 1 recruiter/trainer conversation.

	Structural 1:1 port of the Havoc recruiter template (kreezo_convo.lua), driven by the
	authentic Live Imperial trainer string file extracted from the client TRE:
		string/en/conversation/naboo_imperial_trainer_1.stf
	Every leftDialog / option below references a real @conversation/naboo_imperial_trainer_1:s_<hash>
	string from that table (English text shown in the trailing comment). Screen-flow control lives in
	barnSinkkoConvoHandler.lua. The screen graph mirrors the template's recruit -> ship -> tier-1
	mission ladder (patrol/destroy/escort/assassinate) -> duties -> reassignment-to-Inquisitor flow.

	RECONSTRUCTED (marked inline): a small number of connective screen transitions whose exact
	original screen-id wiring is client-side data; the dialogue STRINGS themselves are all sourced
	from the real Imperial trainer STF (no invented prose).
]]

barn_sinkko_convo = ConvoTemplate:new {
	initialScreen = "",
	templateType = "Lua",
	luaClassHandler = "barnSinkkoConvoHandler",
	screens = {}
}

-- JTL Disabled / No Space Expansion
barn_sinkko_convo_no_jtl = ConvoScreen:new {
	id = "no_jtl",
	leftDialog = "@conversation/naboo_imperial_trainer_1:s_a8755a48", -- Unless you have business with the Imperial Navy, I must ask you to come back another time. I'm very busy right now.
	stopConversation = "true",
	options = {}
}
barn_sinkko_convo:addScreen(barn_sinkko_convo_no_jtl)

-- Rebel Pilot (turned away)
barn_sinkko_convo_rebel_pilot = ConvoScreen:new {
	id = "rebel_pilot",
	leftDialog = "@conversation/naboo_imperial_trainer_1:s_6159d1a3", -- I've seen your face! You're a known Rebel pilot!
	stopConversation = "true",
	animation = "point_accusingly",
	options = {}
}
barn_sinkko_convo:addScreen(barn_sinkko_convo_rebel_pilot)

-- Neutral/Privateer Pilot (turned away)
barn_sinkko_convo_neutral_pilot = ConvoScreen:new {
	id = "neutral_pilot",
	leftDialog = "@conversation/naboo_imperial_trainer_1:s_f6e10f56", -- Good to meet you Pilot. According to my records you're already working with a different division. What can I do for you?
	stopConversation = "true",
	animation = "shrug_shoulders",
	options = {}
}
barn_sinkko_convo:addScreen(barn_sinkko_convo_neutral_pilot)

-- Imperial pilot, different squadron
barn_sinkko_convo_non_inquisition_pilot = ConvoScreen:new {
	id = "non_inquisition_pilot",
	leftDialog = "@conversation/naboo_imperial_trainer_1:s_f6e10f56", -- Good to meet you Pilot. According to my records you're already working with a different division. What can I do for you?
	stopConversation = "false",
	options = {
		{"@conversation/naboo_imperial_trainer_1:s_4854758d", "duty_missions"}, -- I would like to request a mission.
	}
}
barn_sinkko_convo:addScreen(barn_sinkko_convo_non_inquisition_pilot)

--[[ Recruitment flow ]]
barn_sinkko_convo_recruitment = ConvoScreen:new {
	id = "recruitment",
	leftDialog = "@conversation/naboo_imperial_trainer_1:s_5797c779", -- Welcome to the Imperial Navy Recruitment Center. My name is Lieutenant Barn Sinkko. Are you interested in learning about the Imperial Navy?
	stopConversation = "false",
	options = {
		{"@conversation/naboo_imperial_trainer_1:s_b00e89d5", "yes_join"}, -- I'd like to sign up, sir.
		{"@conversation/naboo_imperial_trainer_1:s_388cfea9", "why_volunteers"}, -- The Empire is recruiting volunteer pilots?
		{"@conversation/naboo_imperial_trainer_1:s_37eb1d12", "decline_join"}, -- I'd rather not sign up right now, sir.
	}
}
barn_sinkko_convo:addScreen(barn_sinkko_convo_recruitment)

barn_sinkko_convo_why_volunteers = ConvoScreen:new {
	id = "why_volunteers",
	leftDialog = "@conversation/naboo_imperial_trainer_1:s_550165e", -- Yes, volunteers or conscripts. Rebel opposition has become more direct. We want to recruit new pilots for support duty, freeing up combat pilots for the front lines.
	stopConversation = "false",
	options = {
		{"@conversation/naboo_imperial_trainer_1:s_b00e89d5", "yes_join"}, -- I'd like to sign up, sir.
		{"@conversation/naboo_imperial_trainer_1:s_37eb1d12", "decline_join"}, -- I'd rather not sign up right now, sir.
	}
}
barn_sinkko_convo:addScreen(barn_sinkko_convo_why_volunteers)

barn_sinkko_convo_decline_join = ConvoScreen:new {
	id = "decline_join",
	leftDialog = "@conversation/naboo_imperial_trainer_1:s_c2685407", -- I hope you reconsider. Good day, citizen.
	stopConversation = "true",
	animation = "goodbye",
	options = {}
}
barn_sinkko_convo:addScreen(barn_sinkko_convo_decline_join)

-- Player asked to join; the handler redirects this to "join_confirm". Defined with the
-- same content as join_confirm so the flow is intact even without the handler redirect.
barn_sinkko_convo_yes_join = ConvoScreen:new {
	id = "yes_join",
	leftDialog = "@conversation/naboo_imperial_trainer_1:s_9a34f731", -- Are you sure you want to sign up? You'll be expected to follow orders and treat your superiors with respect. This is a tight operation and we deal har
	stopConversation = "false",
	options = {
		{"@conversation/naboo_imperial_trainer_1:s_37650e5c", "yes_i_am"}, -- Yes, sir! I want to be in the Imperial Navy.
		{"@conversation/naboo_imperial_trainer_1:s_37eb1d12", "decline_join"}, -- I'd rather not sign up right now, sir.
	}
}
barn_sinkko_convo:addScreen(barn_sinkko_convo_yes_join)

-- Sign-up confirmation (handler routes "yes_join" here)
barn_sinkko_convo_join_confirm = ConvoScreen:new {
	id = "join_confirm",
	leftDialog = "@conversation/naboo_imperial_trainer_1:s_9a34f731", -- Are you sure you want to sign up? You'll be expected to follow orders and treat your superiors with respect. This is a tight operation and we deal harshly with insubordinate behavior.
	stopConversation = "false",
	options = {
		{"@conversation/naboo_imperial_trainer_1:s_37650e5c", "yes_i_am"}, -- Yes, sir! I want to be in the Imperial Navy.
		{"@conversation/naboo_imperial_trainer_1:s_37eb1d12", "decline_join"}, -- I'd rather not sign up right now, sir.
	}
}
barn_sinkko_convo:addScreen(barn_sinkko_convo_join_confirm)

-- Conscription/welcome (handler grants novice box + squadron + tier here)
barn_sinkko_convo_yes_i_am = ConvoScreen:new {
	id = "yes_i_am",
	leftDialog = "@conversation/naboo_imperial_trainer_1:s_2fe328e", -- By the powers vested in me by the Imperial Naval Command, under the ever watchful eye of the Emperor, I hereby conscript you to service with the non-o
	stopConversation = "false",
	options = {}
}
barn_sinkko_convo:addScreen(barn_sinkko_convo_yes_i_am)

-- No Ship - grants ship
barn_sinkko_convo_no_ship = ConvoScreen:new {
	id = "no_ship",
	leftDialog = "@conversation/naboo_imperial_trainer_1:s_1d0e7364", -- I'm transferring a ship authorization and control device to your datapad. You'll need this to use your TIE Fighter. Should you lose your control devic
	stopConversation = "false",
	animation = "nod_head_multiple",
	options = {
		{"@conversation/naboo_imperial_trainer_1:s_6047677", "yes_im_ready"}, -- I'm ready, sir.
	}
}
barn_sinkko_convo:addScreen(barn_sinkko_convo_no_ship)

barn_sinkko_convo_yes_ship = ConvoScreen:new {
	id = "yes_ship",
	leftDialog = "@conversation/naboo_imperial_trainer_1:s_b3408be1", -- Are you ready for your first assignment?
	stopConversation = "false",
	options = {
		{"@conversation/naboo_imperial_trainer_1:s_6047677", "yes_im_ready"}, -- I'm ready, sir.
	}
}
barn_sinkko_convo:addScreen(barn_sinkko_convo_yes_ship)

--[[ Tier 1 -- Mission 1: Patrol (handler starts patrol_naboo_imperial_1) ]]
barn_sinkko_convo_yes_im_ready = ConvoScreen:new {
	id = "yes_im_ready",
	leftDialog = "@conversation/naboo_imperial_trainer_1:s_14abbd01", -- Not today. I'm transferring the coordinates of a local security patrol route. It's pretty quiet up there, so you won't run into any trouble. Fly a sin
	stopConversation = "true",
	options = {}
}
barn_sinkko_convo:addScreen(barn_sinkko_convo_yes_im_ready)

-- Player is on quest 1 and returns before completing it
barn_sinkko_convo_first_quest_active = ConvoScreen:new {
	id = "first_quest_active",
	leftDialog = "@conversation/naboo_imperial_trainer_1:s_37979335", -- Report back to me when you are finished with the patrol.
	stopConversation = "true",
	options = {}
}
barn_sinkko_convo:addScreen(barn_sinkko_convo_first_quest_active)

-- Quest 1 complete, needs reward (handler rewards on "patrol_complete")
barn_sinkko_convo_excellent_work = ConvoScreen:new {
	id = "excellent_work",
	leftDialog = "@conversation/naboo_imperial_trainer_1:s_76892f68", -- Pilot. Report on the status of your patrol.
	stopConversation = "false",
	options = {
		{"@conversation/naboo_imperial_trainer_1:s_3a1ddc14", "patrol_complete"}, -- I was attacked by a Rebel fighter wing, sir.
		{"@conversation/naboo_imperial_trainer_1:s_d09c1ecb", "patrol_complete"}, -- Just doing my duty, sir.
	}
}
barn_sinkko_convo:addScreen(barn_sinkko_convo_excellent_work)

barn_sinkko_convo_patrol_complete = ConvoScreen:new {
	id = "patrol_complete",
	leftDialog = "@conversation/naboo_imperial_trainer_1:s_f50739c7", -- You did? Impressive. I suppose that means we won't be able to track their heading, but under the circumstances you did the right thing. My congratulat
	stopConversation = "true",
	options = {}
}
barn_sinkko_convo:addScreen(barn_sinkko_convo_patrol_complete)

-- Quest 1 failed/aborted
barn_sinkko_convo_failed_quest1 = ConvoScreen:new {
	id = "failed_quest1",
	leftDialog = "@conversation/naboo_imperial_trainer_1:s_8d324b72", -- I've transferred the patrol coordinates to your datapad. Try harder this time, pilot.
	stopConversation = "false",
	options = {
		{"@conversation/naboo_imperial_trainer_1:s_6047677", "retry_quest1"}, -- I'm ready, sir.
	}
}
barn_sinkko_convo:addScreen(barn_sinkko_convo_failed_quest1)

-- Quest 1 retry acknowledged (handler restarts patrol_naboo_imperial_1)
barn_sinkko_convo_retry_quest1 = ConvoScreen:new {
	id = "retry_quest1",
	leftDialog = "@conversation/naboo_imperial_trainer_1:s_8b493b63", -- Excellent. I'm transferring the coordinates of a local security patrol route. It's quiet up there, so you won't run into any trouble. Fly a single cir
	stopConversation = "true",
	options = {}
}
barn_sinkko_convo:addScreen(barn_sinkko_convo_retry_quest1)

--[[ Tier 1 -- Mission 2: Destroy (handler starts destroy_naboo_imperial_2) ]]
barn_sinkko_convo_grant_quest2 = ConvoScreen:new {
	id = "grant_quest2",
	leftDialog = "@conversation/naboo_imperial_trainer_1:s_bc1b7622", -- You performed admirably in combat with the last fighter wing. We want to see an encore. I want you to hunt down and destroy the rebel vessels in the a
	stopConversation = "false",
	options = {
		{"@conversation/naboo_imperial_trainer_1:s_5bc07030", "quest2_accepted"}, -- What's the mission, sir?
	}
}
barn_sinkko_convo:addScreen(barn_sinkko_convo_grant_quest2)

barn_sinkko_convo_quest2_accepted = ConvoScreen:new {
	id = "quest2_accepted",
	leftDialog = "@conversation/naboo_imperial_trainer_1:s_e1147f5d", -- I want you to hunt down and destroy the Rebel vessels in the area of the 'Kantari' attack. The Rebels are still out there and we must make them pay. Eliminate them.
	stopConversation = "true",
	options = {}
}
barn_sinkko_convo:addScreen(barn_sinkko_convo_quest2_accepted)

-- Quest 2 rewarded; leads into Mission 3 (handler starts patrol_naboo_imperial_3 on "train_me3")
barn_sinkko_convo_excellent_work2 = ConvoScreen:new {
	id = "excellent_work2",
	leftDialog = "@conversation/naboo_imperial_trainer_1:s_a9bcd9f0", -- Good job. I'm crediting you for the mission, along with a little extra. You performed admirably. I can't say I appreciate your money motivation, but a
	stopConversation = "false",
	options = {
		{"@conversation/naboo_imperial_trainer_1:s_78d92576", "train_me3"}, -- What are my orders, sir?
	}
}
barn_sinkko_convo:addScreen(barn_sinkko_convo_excellent_work2)

-- Mission 3 accepted (handler starts patrol_naboo_imperial_3 on "train_me3")
barn_sinkko_convo_train_me3 = ConvoScreen:new {
	id = "train_me3",
	leftDialog = "@conversation/naboo_imperial_trainer_1:s_2bbdc667", -- Pilot. We've analyzed your recent encounters with the Rebellion and have been unable to determine any pattern to their activity. The planetary securit
	stopConversation = "true",
	options = {}
}
barn_sinkko_convo:addScreen(barn_sinkko_convo_train_me3)

barn_sinkko_convo_failed_quest2 = ConvoScreen:new {
	id = "failed_quest2",
	leftDialog = "@conversation/naboo_imperial_trainer_1:s_5fdfcebf", -- Report back to me when you've successfully eliminated the Rebels.  And do not abort your mission again!
	stopConversation = "false",
	options = {
		{"@conversation/naboo_imperial_trainer_1:s_6047677", "retry_quest2"}, -- I'm ready, sir.
	}
}
barn_sinkko_convo:addScreen(barn_sinkko_convo_failed_quest2)

-- Quest 2 retry acknowledged (handler restarts destroy_naboo_imperial_2)
barn_sinkko_convo_retry_quest2 = ConvoScreen:new {
	id = "retry_quest2",
	leftDialog = "@conversation/naboo_imperial_trainer_1:s_730419d7", -- Very well. The Rebels are apparently still in the same area. You must ensure their destruction this time. It's important that we maintain proper secur
	stopConversation = "true",
	options = {}
}
barn_sinkko_convo:addScreen(barn_sinkko_convo_retry_quest2)

--[[ Tier 1 -- Mission 3 report (handler grants the reward on "quest3_rewarded") ]]
barn_sinkko_convo_excellent_work3 = ConvoScreen:new {
	id = "excellent_work3",
	leftDialog = "@conversation/naboo_imperial_trainer_1:s_76892f68", -- Pilot. Report on the status of your patrol.
	stopConversation = "false",
	options = {
		{"@conversation/naboo_imperial_trainer_1:s_3a1ddc14", "quest3_rewarded"}, -- I was attacked by a Rebel fighter wing, sir.
		{"@conversation/naboo_imperial_trainer_1:s_d09c1ecb", "quest3_rewarded"}, -- Just doing my duty, sir.
	}
}
barn_sinkko_convo:addScreen(barn_sinkko_convo_excellent_work3)

barn_sinkko_convo_quest3_rewarded = ConvoScreen:new {
	id = "quest3_rewarded",
	leftDialog = "@conversation/naboo_imperial_trainer_1:s_fa956108", -- The command staff will begin planning the next phase of the operation. Report back to me when you're ready for another assignment.
	stopConversation = "true",
	options = {}
}
barn_sinkko_convo:addScreen(barn_sinkko_convo_quest3_rewarded)

barn_sinkko_convo_failed_quest3 = ConvoScreen:new {
	id = "failed_quest3",
	leftDialog = "@conversation/naboo_imperial_trainer_1:s_adf9eee2", -- Report to me when you've completed your mission.
	stopConversation = "false",
	options = {
		{"@conversation/naboo_imperial_trainer_1:s_6047677", "retry_quest3"}, -- I'm ready, sir.
	}
}
barn_sinkko_convo:addScreen(barn_sinkko_convo_failed_quest3)

-- Quest 3 retry acknowledged (handler restarts patrol_naboo_imperial_3)
barn_sinkko_convo_retry_quest3 = ConvoScreen:new {
	id = "retry_quest3",
	leftDialog = "@conversation/naboo_imperial_trainer_1:s_a44450e3", -- Good luck, pilot. Report back to me when you've completed the mission.
	stopConversation = "true",
	options = {}
}
barn_sinkko_convo:addScreen(barn_sinkko_convo_retry_quest3)

--[[ Tier 1 -- Mission 4: Assassinate (handler starts assassinate_naboo_imperial_4 on "quest4_accepted") ]]
barn_sinkko_convo_grant_quest4 = ConvoScreen:new {
	id = "grant_quest4",
	leftDialog = "@conversation/naboo_imperial_trainer_1:s_2ac29eb6", -- You've shown a lot of promise so far, Pilot. This is a key assignment. We expect the Rebel team leader to be a highly skilled and well trained pilot. Don't underestimate him.
	stopConversation = "false",
	options = {
		{"@conversation/naboo_imperial_trainer_1:s_5bc07030", "quest4_accepted"}, -- What's the mission, sir?
	}
}
barn_sinkko_convo:addScreen(barn_sinkko_convo_grant_quest4)

barn_sinkko_convo_quest4_accepted = ConvoScreen:new {
	id = "quest4_accepted",
	leftDialog = "@conversation/naboo_imperial_trainer_1:s_368fd90b", -- We have discovered the possible location of the Rebel team leader. You are to be dispatched immediately. Travel to the waypoint I'm transferring to yo
	stopConversation = "true",
	options = {}
}
barn_sinkko_convo:addScreen(barn_sinkko_convo_quest4_accepted)

barn_sinkko_convo_failed_quest4 = ConvoScreen:new {
	id = "failed_quest4",
	leftDialog = "@conversation/naboo_imperial_trainer_1:s_ec04a9b3", -- Report on the status of your operation against the Rebel leader, Pilot.
	stopConversation = "false",
	options = {
		{"@conversation/naboo_imperial_trainer_1:s_6047677", "retry_quest4"}, -- I'm ready, sir.
	}
}
barn_sinkko_convo:addScreen(barn_sinkko_convo_failed_quest4)

-- Quest 4 retry acknowledged (handler restarts assassinate_naboo_imperial_4)
barn_sinkko_convo_retry_quest4 = ConvoScreen:new {
	id = "retry_quest4",
	leftDialog = "@conversation/naboo_imperial_trainer_1:s_e24fd46f", -- You've already proven your combat capability. I'm taking a risk assigning you this mission, don't let me down. Remember, they could be anywhere in the
	stopConversation = "true",
	options = {}
}
barn_sinkko_convo:addScreen(barn_sinkko_convo_retry_quest4)

--[[ Player has an active (non-first) mission ]]
barn_sinkko_convo_has_mission = ConvoScreen:new {
	id = "has_mission",
	leftDialog = "@conversation/naboo_imperial_trainer_1:s_8c262163", -- Report back to me when you are finished with your current mission.  You can abort your mission if you want to start over.
	stopConversation = "true",
	options = {}
}
barn_sinkko_convo:addScreen(barn_sinkko_convo_has_mission)

--[[ All four Tier-1 missions complete -> free training choices (handler builds options) ]]
barn_sinkko_convo_missions_complete = ConvoScreen:new {
	id = "missions_complete",
	leftDialog = "@conversation/naboo_imperial_trainer_1:s_d25495b9", -- Pilot, I am singularly impressed. You have mastered the fundamentals of your profession and have performed beyond expectation and all without formal I
	stopConversation = "false",
	options = {}
}
barn_sinkko_convo:addScreen(barn_sinkko_convo_missions_complete)

--[[ Additional (XP-gated) training (handler builds options) ]]
barn_sinkko_convo_more_training = ConvoScreen:new {
	id = "more_training",
	leftDialog = "@conversation/naboo_imperial_trainer_1:s_366e0c62", -- You can learn about Imperial technology, equipment, space combat training, or astromech management.
	stopConversation = "false",
	options = {}
}
barn_sinkko_convo:addScreen(barn_sinkko_convo_more_training)

-- training acknowledgement screens (handler grants the skill then returns the cloned screen)
barn_sinkko_convo_train_player_fighters = ConvoScreen:new {
	id = "train_player_fighters",
	leftDialog = "@conversation/naboo_imperial_trainer_1:s_7c8aca1b", -- Good choice.  Report back when you are ready for an assignment.
	stopConversation = "true",
	options = {}
}
barn_sinkko_convo:addScreen(barn_sinkko_convo_train_player_fighters)

barn_sinkko_convo_train_player_component = ConvoScreen:new {
	id = "train_player_component",
	leftDialog = "@conversation/naboo_imperial_trainer_1:s_7c8aca1b", -- Good choice.  Report back when you are ready for an assignment.
	stopConversation = "true",
	options = {}
}
barn_sinkko_convo:addScreen(barn_sinkko_convo_train_player_component)

barn_sinkko_convo_train_player_basics = ConvoScreen:new {
	id = "train_player_basics",
	leftDialog = "@conversation/naboo_imperial_trainer_1:s_7c8aca1b", -- Good choice.  Report back when you are ready for an assignment.
	stopConversation = "true",
	options = {}
}
barn_sinkko_convo:addScreen(barn_sinkko_convo_train_player_basics)

barn_sinkko_convo_train_player_droid = ConvoScreen:new {
	id = "train_player_droid",
	leftDialog = "@conversation/naboo_imperial_trainer_1:s_7c8aca1b", -- Good choice.  Report back when you are ready for an assignment.
	stopConversation = "true",
	options = {}
}
barn_sinkko_convo:addScreen(barn_sinkko_convo_train_player_droid)

-- free-training variants (same acknowledgement string)
barn_sinkko_convo_train_player_fighters_free = ConvoScreen:new {
	id = "train_player_fighters_free",
	leftDialog = "@conversation/naboo_imperial_trainer_1:s_7c8aca1b", -- Good choice.  Report back when you are ready for an assignment.
	stopConversation = "true",
	options = {}
}
barn_sinkko_convo:addScreen(barn_sinkko_convo_train_player_fighters_free)

barn_sinkko_convo_train_player_component_free = ConvoScreen:new {
	id = "train_player_component_free",
	leftDialog = "@conversation/naboo_imperial_trainer_1:s_7c8aca1b", -- Good choice.  Report back when you are ready for an assignment.
	stopConversation = "true",
	options = {}
}
barn_sinkko_convo:addScreen(barn_sinkko_convo_train_player_component_free)

barn_sinkko_convo_train_player_basics_free = ConvoScreen:new {
	id = "train_player_basics_free",
	leftDialog = "@conversation/naboo_imperial_trainer_1:s_7c8aca1b", -- Good choice.  Report back when you are ready for an assignment.
	stopConversation = "true",
	options = {}
}
barn_sinkko_convo:addScreen(barn_sinkko_convo_train_player_basics_free)

barn_sinkko_convo_train_player_droid_free = ConvoScreen:new {
	id = "train_player_droid_free",
	leftDialog = "@conversation/naboo_imperial_trainer_1:s_7c8aca1b", -- Good choice.  Report back when you are ready for an assignment.
	stopConversation = "true",
	options = {}
}
barn_sinkko_convo:addScreen(barn_sinkko_convo_train_player_droid_free)

--[[ Duty missions (Tier-1 grind: destroy / escort duty) ]]
barn_sinkko_convo_duty_missions = ConvoScreen:new {
	id = "duty_missions",
	leftDialog = "@conversation/naboo_imperial_trainer_1:s_d8487693", -- Pilot. I don't have any specific work for you at this time. You can now select your preferred operation from a list of general duties. Or, if you have
	stopConversation = "false",
	options = {
		{"@conversation/naboo_imperial_trainer_1:s_87bb7015", "destroy_duty"}, -- [Destroy Duty] I'm interested in hunting Rebel scum.
		{"@conversation/naboo_imperial_trainer_1:s_79ab4bbe", "escort_duty"}, -- [Escort Duty] I'm interested in escorting transports.
	}
}
barn_sinkko_convo:addScreen(barn_sinkko_convo_duty_missions)

-- Duty accepted (handler starts destroy_duty_naboo_imperial_6)
barn_sinkko_convo_destroy_duty = ConvoScreen:new {
	id = "destroy_duty",
	leftDialog = "@conversation/naboo_imperial_trainer_1:s_c80f115e", -- Rebel activity is still high enough that we need combat capable pilots on active duty locating and eliminating them. You have free reign to use lethal
	stopConversation = "true",
	options = {}
}
barn_sinkko_convo:addScreen(barn_sinkko_convo_destroy_duty)

-- Duty accepted (handler starts escort_duty_naboo_imperial_7)
barn_sinkko_convo_escort_duty = ConvoScreen:new {
	id = "escort_duty",
	leftDialog = "@conversation/naboo_imperial_trainer_1:s_98c44634", -- With the recent increase in Rebel activity, our supply transports are at risk. The Empire would like to assign at least one TIE pilot to every transpo
	stopConversation = "true",
	options = {}
}
barn_sinkko_convo:addScreen(barn_sinkko_convo_escort_duty)

-- recruitment_not_imperial (player not yet faction-aligned)
barn_sinkko_convo_recruitment_not_imperial = ConvoScreen:new {
	id = "recruitment_not_imperial",
	leftDialog = "@conversation/naboo_imperial_trainer_1:s_5797c779", -- Welcome to the Imperial Navy Recruitment Center. My name is Lieutenant Barn Sinkko. Are you interested in learning about the Imperial Navy?
	stopConversation = "false",
	options = {
		{"@conversation/naboo_imperial_trainer_1:s_b00e89d5", "yes_join"}, -- I'd like to sign up, sir.
		{"@conversation/naboo_imperial_trainer_1:s_37eb1d12", "decline_join"}, -- I'd rather not sign up right now, sir.
	}
}
barn_sinkko_convo:addScreen(barn_sinkko_convo_recruitment_not_imperial)

--[[ Tier 1 complete -> reassigned to the Inquisition (Under Inquisitor Fa'Zoll) ]]
barn_sinkko_convo_completed_sinkko = ConvoScreen:new {
	id = "completed_sinkko",
	leftDialog = "@conversation/naboo_imperial_trainer_1:s_56dbc789", -- Your skill behind the controls of the TIE Fighter have peaked the interest of several high ranking officers. In particular, members of the Imperial Inquisition have expressed their desire to take over your training...
	stopConversation = "false",
	options = {
		{"@conversation/naboo_imperial_trainer_1:s_6396820e", "what_is_inquisition"}, -- What is the Imperial Inquisition?
		{"@conversation/naboo_imperial_trainer_1:s_1e9a88a8", "report_to_fazoll"}, -- Who do I report to?
	}
}
barn_sinkko_convo:addScreen(barn_sinkko_convo_completed_sinkko)

barn_sinkko_convo_what_is_inquisition = ConvoScreen:new {
	id = "what_is_inquisition",
	leftDialog = "@conversation/naboo_imperial_trainer_1:s_9be59baa", -- The Inquisition is a special judicial branch of the Imperial Intelligence bureau. Of all of the Imperial divisions, only the Inquisition has the abili
	stopConversation = "false",
	options = {
		{"@conversation/naboo_imperial_trainer_1:s_1e9a88a8", "report_to_fazoll"}, -- Who do I report to?
	}
}
barn_sinkko_convo:addScreen(barn_sinkko_convo_what_is_inquisition)

-- Reassignment: grant waypoint to Under Inquisitor Fa'Zoll (handler sets sinkko_finished + waypoint)
barn_sinkko_convo_report_to_fazoll = ConvoScreen:new {
	id = "report_to_fazoll",
	leftDialog = "@conversation/naboo_imperial_trainer_1:s_1cfc4684", -- Under Inquisitor Fa'Zoll in the Emperor's Retreat has been assigned as your new commanding officer. I don't know anything about this person and frankl
	stopConversation = "true",
	options = {}
}
barn_sinkko_convo:addScreen(barn_sinkko_convo_report_to_fazoll)

-- Player already reassigned, returns to Sinkko
barn_sinkko_convo_go_to_next = ConvoScreen:new {
	id = "go_to_next",
	leftDialog = "@conversation/naboo_imperial_trainer_1:s_1fa7fe89", -- I don't have anything else for you. Talk to Under Inquisitor Fa'Zoll in the Emperor's Retreat.
	stopConversation = "true",
	options = {}
}
barn_sinkko_convo:addScreen(barn_sinkko_convo_go_to_next)

--[[

	Tier 2

]]

-- Tier 2 - Active Mission
barn_sinkko_convo_tier2_on_mission = ConvoScreen:new {
	id = "tier2_on_mission",
	leftDialog = "@conversation/naboo_imperial_trainer_2:s_a59c7bd7",
	stopConversation = "true",
	options = {}
}
barn_sinkko_convo:addScreen(barn_sinkko_convo_tier2_on_mission)

-- Tier 2 - Initial Briefing
barn_sinkko_convo_tier2_initial_briefing = ConvoScreen:new {
	id = "tier2_initial_briefing",
	leftDialog = "@conversation/naboo_imperial_trainer_2:s_41786376",
	stopConversation = "false",
	options = {
		{"@conversation/naboo_imperial_trainer_2:s_fa3398f3", "tier2_first_mission"},
	}
}
barn_sinkko_convo:addScreen(barn_sinkko_convo_tier2_initial_briefing)

-- Tier 2 - Mission 1
barn_sinkko_convo_tier2_first_mission = ConvoScreen:new {
	id = "tier2_first_mission",
	leftDialog = "@conversation/naboo_imperial_trainer_2:s_199bd27f",
	stopConversation = "false",
	options = {
		{"@conversation/naboo_imperial_trainer_2:s_f1be3213", "tier2_first_mission_details"},
		{"@conversation/naboo_imperial_trainer_2:s_91223b5c", "accept_tier2_first_mission"},
	}
}
barn_sinkko_convo:addScreen(barn_sinkko_convo_tier2_first_mission)

barn_sinkko_convo_tier2_first_mission_details = ConvoScreen:new {
	id = "tier2_first_mission_details",
	leftDialog = "@conversation/naboo_imperial_trainer_2:s_d2fa677d",
	stopConversation = "false",
	options = {
		{"@conversation/naboo_imperial_trainer_2:s_91223b5c", "accept_tier2_first_mission"},
	}
}
barn_sinkko_convo:addScreen(barn_sinkko_convo_tier2_first_mission_details)

barn_sinkko_convo_accept_tier2_first_mission = ConvoScreen:new {
	id = "accept_tier2_first_mission",
	leftDialog = "@conversation/naboo_imperial_trainer_2:s_aceff31e",
	stopConversation = "true",
	options = {}
}
barn_sinkko_convo:addScreen(barn_sinkko_convo_accept_tier2_first_mission)

barn_sinkko_convo_failed_tier2_first_mission = ConvoScreen:new {
	id = "failed_tier2_first_mission",
	leftDialog = "@conversation/naboo_imperial_trainer_2:s_825fac62",
	stopConversation = "true",
	options = {}
}
barn_sinkko_convo:addScreen(barn_sinkko_convo_failed_tier2_first_mission)

barn_sinkko_convo_tier2_first_mission_success = ConvoScreen:new {
	id = "tier2_first_mission_success",
	leftDialog = "@conversation/naboo_imperial_trainer_2:s_ad754",
	stopConversation = "false",
	options = {
		{"@conversation/naboo_imperial_trainer_2:s_daf7bb7d", "tier2_second_mission"},
	}
}
barn_sinkko_convo:addScreen(barn_sinkko_convo_tier2_first_mission_success)

-- Tier 2 - Mission 2
barn_sinkko_convo_tier2_second_mission = ConvoScreen:new {
	id = "tier2_second_mission",
	leftDialog = "@conversation/naboo_imperial_trainer_2:s_b8791e16",
	stopConversation = "false",
	options = {
		{"@conversation/naboo_imperial_trainer_2:s_e6765c30", "accept_tier2_second_mission"},
	}
}
barn_sinkko_convo:addScreen(barn_sinkko_convo_tier2_second_mission)

barn_sinkko_convo_accept_tier2_second_mission = ConvoScreen:new {
	id = "accept_tier2_second_mission",
	leftDialog = "@conversation/naboo_imperial_trainer_2:s_dfdec194",
	stopConversation = "true",
	options = {}
}
barn_sinkko_convo:addScreen(barn_sinkko_convo_accept_tier2_second_mission)

barn_sinkko_convo_failed_tier2_second_mission = ConvoScreen:new {
	id = "failed_tier2_second_mission",
	leftDialog = "@conversation/naboo_imperial_trainer_2:s_825fac62",
	stopConversation = "true",
	options = {}
}
barn_sinkko_convo:addScreen(barn_sinkko_convo_failed_tier2_second_mission)

barn_sinkko_convo_tier2_second_mission_success = ConvoScreen:new {
	id = "tier2_second_mission_success",
	leftDialog = "@conversation/naboo_imperial_trainer_2:s_de870f1",
	stopConversation = "false",
	options = {
		{"@conversation/naboo_imperial_trainer_2:s_3c9b80ee", "tier2_third_mission"},
	}
}
barn_sinkko_convo:addScreen(barn_sinkko_convo_tier2_second_mission_success)

-- Tier 2 - Mission 3
barn_sinkko_convo_tier2_third_mission = ConvoScreen:new {
	id = "tier2_third_mission",
	leftDialog = "@conversation/naboo_imperial_trainer_2:s_26408ea",
	stopConversation = "false",
	options = {
		{"@conversation/naboo_imperial_trainer_2:s_6e39f51b", "tier2_third_mission_details"},
		{"@conversation/naboo_imperial_trainer_2:s_51fe08f5", "accept_tier2_third_mission"},
	}
}
barn_sinkko_convo:addScreen(barn_sinkko_convo_tier2_third_mission)

barn_sinkko_convo_tier2_third_mission_details = ConvoScreen:new {
	id = "tier2_third_mission_details",
	leftDialog = "@conversation/naboo_imperial_trainer_2:s_b257ddf8",
	stopConversation = "false",
	options = {
		{"@conversation/naboo_imperial_trainer_2:s_51fe08f5", "accept_tier2_third_mission"},
	}
}
barn_sinkko_convo:addScreen(barn_sinkko_convo_tier2_third_mission_details)

barn_sinkko_convo_accept_tier2_third_mission = ConvoScreen:new {
	id = "accept_tier2_third_mission",
	leftDialog = "@conversation/naboo_imperial_trainer_2:s_1d63bf5d",
	stopConversation = "true",
	options = {}
}
barn_sinkko_convo:addScreen(barn_sinkko_convo_accept_tier2_third_mission)

barn_sinkko_convo_failed_tier2_third_mission = ConvoScreen:new {
	id = "failed_tier2_third_mission",
	leftDialog = "@conversation/naboo_imperial_trainer_2:s_825fac62",
	stopConversation = "true",
	options = {}
}
barn_sinkko_convo:addScreen(barn_sinkko_convo_failed_tier2_third_mission)

barn_sinkko_convo_tier2_third_mission_success = ConvoScreen:new {
	id = "tier2_third_mission_success",
	leftDialog = "@conversation/naboo_imperial_trainer_2:s_2ccef947",
	stopConversation = "false",
	options = {
		{"@conversation/naboo_imperial_trainer_2:s_96db4fc7", "tier2_fourth_mission"},
	}
}
barn_sinkko_convo:addScreen(barn_sinkko_convo_tier2_third_mission_success)

-- Tier 2 - Mission 4
barn_sinkko_convo_tier2_fourth_mission = ConvoScreen:new {
	id = "tier2_fourth_mission",
	leftDialog = "@conversation/naboo_imperial_trainer_2:s_196d2fe6",
	stopConversation = "false",
	options = {
		{"@conversation/naboo_imperial_trainer_2:s_20b3aa70", "tier2_fourth_mission_details"},
		{"@conversation/naboo_imperial_trainer_2:s_1f033c46", "accept_tier2_fourth_mission"},
	}
}
barn_sinkko_convo:addScreen(barn_sinkko_convo_tier2_fourth_mission)

barn_sinkko_convo_tier2_fourth_mission_details = ConvoScreen:new {
	id = "tier2_fourth_mission_details",
	leftDialog = "@conversation/naboo_imperial_trainer_2:s_e17af774",
	stopConversation = "false",
	options = {
		{"@conversation/naboo_imperial_trainer_2:s_1f033c46", "accept_tier2_fourth_mission"},
	}
}
barn_sinkko_convo:addScreen(barn_sinkko_convo_tier2_fourth_mission_details)

barn_sinkko_convo_accept_tier2_fourth_mission = ConvoScreen:new {
	id = "accept_tier2_fourth_mission",
	leftDialog = "@conversation/naboo_imperial_trainer_2:s_d1fa21c",
	stopConversation = "true",
	options = {}
}
barn_sinkko_convo:addScreen(barn_sinkko_convo_accept_tier2_fourth_mission)

barn_sinkko_convo_failed_tier2_fourth_mission = ConvoScreen:new {
	id = "failed_tier2_fourth_mission",
	leftDialog = "@conversation/naboo_imperial_trainer_2:s_306da215",
	stopConversation = "true",
	options = {}
}
barn_sinkko_convo:addScreen(barn_sinkko_convo_failed_tier2_fourth_mission)

barn_sinkko_convo_tier2_fourth_mission_success = ConvoScreen:new {
	id = "tier2_fourth_mission_success",
	leftDialog = "@conversation/naboo_imperial_trainer_2:s_78c7dc33",
	stopConversation = "true",
	options = {}
}
barn_sinkko_convo:addScreen(barn_sinkko_convo_tier2_fourth_mission_success)

-- Tier 2 - Training
barn_sinkko_convo_ready_train_tier2 = ConvoScreen:new {
	id = "ready_train_tier2",
	leftDialog = "@conversation/naboo_imperial_trainer_2:s_9ac35c60",
	stopConversation = "false",
	options = {
		-- Options added dynamically via handler
	}
}
barn_sinkko_convo:addScreen(barn_sinkko_convo_ready_train_tier2)

barn_sinkko_convo_tier2_train_fighters = ConvoScreen:new {
	id = "tier2_train_fighters",
	leftDialog = "@conversation/naboo_imperial_trainer_2:s_c4880407",
	stopConversation = "true",
	options = {}
}
barn_sinkko_convo:addScreen(barn_sinkko_convo_tier2_train_fighters)

barn_sinkko_convo_tier2_train_component = ConvoScreen:new {
	id = "tier2_train_component",
	leftDialog = "@conversation/naboo_imperial_trainer_2:s_241a34a1",
	stopConversation = "true",
	options = {}
}
barn_sinkko_convo:addScreen(barn_sinkko_convo_tier2_train_component)

barn_sinkko_convo_tier2_train_basics = ConvoScreen:new {
	id = "tier2_train_basics",
	leftDialog = "@conversation/naboo_imperial_trainer_2:s_486da900",
	stopConversation = "true",
	options = {}
}
barn_sinkko_convo:addScreen(barn_sinkko_convo_tier2_train_basics)

barn_sinkko_convo_tier2_train_droid = ConvoScreen:new {
	id = "tier2_train_droid",
	leftDialog = "@conversation/naboo_imperial_trainer_2:s_31804e15",
	stopConversation = "true",
	options = {}
}
barn_sinkko_convo:addScreen(barn_sinkko_convo_tier2_train_droid)

-- Tier 2 - Completed
barn_sinkko_convo_tier2_completed = ConvoScreen:new {
	id = "tier2_completed",
	leftDialog = "@conversation/naboo_imperial_trainer_2:s_49be19d2",
	stopConversation = "true",
	options = {}
}
barn_sinkko_convo:addScreen(barn_sinkko_convo_tier2_completed)

-- Tier 2 - Duty missions
barn_sinkko_convo_tier2_duty_repeat = ConvoScreen:new {
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
barn_sinkko_convo:addScreen(barn_sinkko_convo_tier2_duty_repeat)

barn_sinkko_convo_tier2_duty_brief1 = ConvoScreen:new {
	id = "tier2_duty_brief1",
	leftDialog = "@conversation/naboo_imperial_trainer_2:s_6a6fe80",
	stopConversation = "false",
	options = {
		{"@conversation/naboo_imperial_trainer_2:s_8efde2ae", "tier2_duty_brief2"},
	}
}
barn_sinkko_convo:addScreen(barn_sinkko_convo_tier2_duty_brief1)

barn_sinkko_convo_tier2_duty_brief2 = ConvoScreen:new {
	id = "tier2_duty_brief2",
	leftDialog = "@conversation/naboo_imperial_trainer_2:s_9962665d",
	stopConversation = "false",
	options = {
		{"@conversation/naboo_imperial_trainer_2:s_8efde2ae", "tier2_duty_brief3"},
	}
}
barn_sinkko_convo:addScreen(barn_sinkko_convo_tier2_duty_brief2)

barn_sinkko_convo_tier2_duty_brief3 = ConvoScreen:new {
	id = "tier2_duty_brief3",
	leftDialog = "@conversation/naboo_imperial_trainer_2:s_b2634e3d",
	stopConversation = "false",
	options = {
		{"@conversation/naboo_imperial_trainer_2:s_8efde2ae", "tier2_duty_menu"},
	}
}
barn_sinkko_convo:addScreen(barn_sinkko_convo_tier2_duty_brief3)

barn_sinkko_convo_tier2_duty_menu = ConvoScreen:new {
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
barn_sinkko_convo:addScreen(barn_sinkko_convo_tier2_duty_menu)

barn_sinkko_convo_accept_tier2_duty1 = ConvoScreen:new {
	id = "accept_tier2_duty1",
	leftDialog = "@conversation/naboo_imperial_trainer_2:s_aceff31e",
	stopConversation = "true",
	options = {}
}
barn_sinkko_convo:addScreen(barn_sinkko_convo_accept_tier2_duty1)

barn_sinkko_convo_accept_tier2_duty2 = ConvoScreen:new {
	id = "accept_tier2_duty2",
	leftDialog = "@conversation/naboo_imperial_trainer_2:s_205f33ca",
	stopConversation = "true",
	options = {}
}
barn_sinkko_convo:addScreen(barn_sinkko_convo_accept_tier2_duty2)

barn_sinkko_convo_accept_tier2_duty3 = ConvoScreen:new {
	id = "accept_tier2_duty3",
	leftDialog = "@conversation/naboo_imperial_trainer_2:s_4682fc3c",
	stopConversation = "true",
	options = {}
}
barn_sinkko_convo:addScreen(barn_sinkko_convo_accept_tier2_duty3)

--[[

	Tier 3

]]

-- Tier 3 - Active Mission
barn_sinkko_convo_tier3_on_mission = ConvoScreen:new {
	id = "tier3_on_mission",
	leftDialog = "@conversation/naboo_imperial_tier3:s_c9911c0f",
	stopConversation = "true",
	options = {}
}
barn_sinkko_convo:addScreen(barn_sinkko_convo_tier3_on_mission)

-- Tier 3 - Mission 1
barn_sinkko_convo_tier3_first_mission = ConvoScreen:new {
	id = "tier3_first_mission",
	leftDialog = "@conversation/naboo_imperial_tier3:s_51edad38",
	stopConversation = "false",
	options = {
		{"@conversation/naboo_imperial_tier3:s_d70dba34", "tier3_first_mission_details"},
		{"@conversation/naboo_imperial_tier3:s_f8e71988", "accept_tier3_first_mission"},
	}
}
barn_sinkko_convo:addScreen(barn_sinkko_convo_tier3_first_mission)

barn_sinkko_convo_tier3_first_mission_details = ConvoScreen:new {
	id = "tier3_first_mission_details",
	leftDialog = "@conversation/naboo_imperial_tier3:s_d2a2c5a9",
	stopConversation = "false",
	options = {
		{"@conversation/naboo_imperial_tier3:s_f8e71988", "accept_tier3_first_mission"},
	}
}
barn_sinkko_convo:addScreen(barn_sinkko_convo_tier3_first_mission_details)

barn_sinkko_convo_accept_tier3_first_mission = ConvoScreen:new {
	id = "accept_tier3_first_mission",
	leftDialog = "@conversation/naboo_imperial_tier3:s_f64e0998",
	stopConversation = "true",
	options = {}
}
barn_sinkko_convo:addScreen(barn_sinkko_convo_accept_tier3_first_mission)

barn_sinkko_convo_failed_tier3_first_mission = ConvoScreen:new {
	id = "failed_tier3_first_mission",
	leftDialog = "@conversation/naboo_imperial_tier3:s_5a9c71e2",
	stopConversation = "true",
	options = {}
}
barn_sinkko_convo:addScreen(barn_sinkko_convo_failed_tier3_first_mission)

barn_sinkko_convo_tier3_first_mission_success = ConvoScreen:new {
	id = "tier3_first_mission_success",
	leftDialog = "@conversation/naboo_imperial_tier3:s_4b5066f2",
	stopConversation = "false",
	options = {
		-- Training options added dynamically via handler
	}
}
barn_sinkko_convo:addScreen(barn_sinkko_convo_tier3_first_mission_success)

-- Tier 3 - Mission 2
barn_sinkko_convo_tier3_second_mission_referral = ConvoScreen:new {
	id = "tier3_second_mission_referral",
	leftDialog = "@conversation/naboo_imperial_tier3:s_47424e40",
	stopConversation = "true",
	options = {}
}
barn_sinkko_convo:addScreen(barn_sinkko_convo_tier3_second_mission_referral)

barn_sinkko_convo_tier3_second_mission = ConvoScreen:new {
	id = "tier3_second_mission",
	leftDialog = "@conversation/naboo_imperial_tier3:s_47424e40",
	stopConversation = "false",
	options = {
		{"@conversation/naboo_imperial_tier3:s_d70dba34", "tier3_second_mission_details"},
		{"@conversation/naboo_imperial_tier3:s_f8e71988", "accept_tier3_second_mission"},
	}
}
barn_sinkko_convo:addScreen(barn_sinkko_convo_tier3_second_mission)

barn_sinkko_convo_tier3_second_mission_details = ConvoScreen:new {
	id = "tier3_second_mission_details",
	leftDialog = "@conversation/naboo_imperial_tier3:s_b49d8273",
	stopConversation = "false",
	options = {
		{"@conversation/naboo_imperial_tier3:s_f8e71988", "accept_tier3_second_mission"},
	}
}
barn_sinkko_convo:addScreen(barn_sinkko_convo_tier3_second_mission_details)

barn_sinkko_convo_accept_tier3_second_mission = ConvoScreen:new {
	id = "accept_tier3_second_mission",
	leftDialog = "@conversation/naboo_imperial_tier3:s_6ffd0979",
	stopConversation = "true",
	options = {}
}
barn_sinkko_convo:addScreen(barn_sinkko_convo_accept_tier3_second_mission)

barn_sinkko_convo_failed_tier3_second_mission = ConvoScreen:new {
	id = "failed_tier3_second_mission",
	leftDialog = "@conversation/naboo_imperial_tier3:s_53d34239",
	stopConversation = "true",
	options = {}
}
barn_sinkko_convo:addScreen(barn_sinkko_convo_failed_tier3_second_mission)

barn_sinkko_convo_tier3_second_mission_success = ConvoScreen:new {
	id = "tier3_second_mission_success",
	leftDialog = "@conversation/naboo_imperial_tier3:s_89772a9c",
	stopConversation = "false",
	options = {
		-- Training options added dynamically via handler
	}
}
barn_sinkko_convo:addScreen(barn_sinkko_convo_tier3_second_mission_success)

-- Tier 3 - Mission 3
barn_sinkko_convo_tier3_third_mission = ConvoScreen:new {
	id = "tier3_third_mission",
	leftDialog = "@conversation/naboo_imperial_tier3:s_5400c2b8",
	stopConversation = "false",
	options = {
		{"@conversation/naboo_imperial_tier3:s_d70dba34", "tier3_third_mission_details"},
		{"@conversation/naboo_imperial_tier3:s_f8e71988", "accept_tier3_third_mission"},
	}
}
barn_sinkko_convo:addScreen(barn_sinkko_convo_tier3_third_mission)

barn_sinkko_convo_tier3_third_mission_details = ConvoScreen:new {
	id = "tier3_third_mission_details",
	leftDialog = "@conversation/naboo_imperial_tier3:s_28876e4d",
	stopConversation = "false",
	options = {
		{"@conversation/naboo_imperial_tier3:s_f8e71988", "accept_tier3_third_mission"},
	}
}
barn_sinkko_convo:addScreen(barn_sinkko_convo_tier3_third_mission_details)

barn_sinkko_convo_accept_tier3_third_mission = ConvoScreen:new {
	id = "accept_tier3_third_mission",
	leftDialog = "@conversation/naboo_imperial_tier3:s_b8302127",
	stopConversation = "true",
	options = {}
}
barn_sinkko_convo:addScreen(barn_sinkko_convo_accept_tier3_third_mission)

barn_sinkko_convo_failed_tier3_third_mission = ConvoScreen:new {
	id = "failed_tier3_third_mission",
	leftDialog = "@conversation/naboo_imperial_tier3:s_a425b892",
	stopConversation = "true",
	options = {}
}
barn_sinkko_convo:addScreen(barn_sinkko_convo_failed_tier3_third_mission)

barn_sinkko_convo_tier3_third_mission_success = ConvoScreen:new {
	id = "tier3_third_mission_success",
	leftDialog = "@conversation/naboo_imperial_tier3:s_596a67f0",
	stopConversation = "false",
	options = {
		-- Training options added dynamically via handler
	}
}
barn_sinkko_convo:addScreen(barn_sinkko_convo_tier3_third_mission_success)

-- Tier 3 - Mission 4
barn_sinkko_convo_tier3_fourth_mission = ConvoScreen:new {
	id = "tier3_fourth_mission",
	leftDialog = "@conversation/naboo_imperial_tier3:s_ee64b80a",
	stopConversation = "false",
	options = {
		{"@conversation/naboo_imperial_tier3:s_c142d50f", "tier3_fourth_mission_details"},
		{"@conversation/naboo_imperial_tier3:s_180340a", "accept_tier3_fourth_mission"},
	}
}
barn_sinkko_convo:addScreen(barn_sinkko_convo_tier3_fourth_mission)

barn_sinkko_convo_tier3_fourth_mission_details = ConvoScreen:new {
	id = "tier3_fourth_mission_details",
	leftDialog = "@conversation/naboo_imperial_tier3:s_3bd0f63e",
	stopConversation = "false",
	options = {
		{"@conversation/naboo_imperial_tier3:s_180340a", "accept_tier3_fourth_mission"},
	}
}
barn_sinkko_convo:addScreen(barn_sinkko_convo_tier3_fourth_mission_details)

barn_sinkko_convo_accept_tier3_fourth_mission = ConvoScreen:new {
	id = "accept_tier3_fourth_mission",
	leftDialog = "@conversation/naboo_imperial_tier3:s_6905c6b2",
	stopConversation = "true",
	options = {}
}
barn_sinkko_convo:addScreen(barn_sinkko_convo_accept_tier3_fourth_mission)

barn_sinkko_convo_failed_tier3_fourth_mission = ConvoScreen:new {
	id = "failed_tier3_fourth_mission",
	leftDialog = "@conversation/naboo_imperial_tier3:s_1530dc31",
	stopConversation = "true",
	options = {}
}
barn_sinkko_convo:addScreen(barn_sinkko_convo_failed_tier3_fourth_mission)

barn_sinkko_convo_tier3_fourth_mission_success = ConvoScreen:new {
	id = "tier3_fourth_mission_success",
	leftDialog = "@conversation/naboo_imperial_tier3:s_5df75ba2",
	stopConversation = "false",
	options = {
		-- Training options added dynamically via handler
	}
}
barn_sinkko_convo:addScreen(barn_sinkko_convo_tier3_fourth_mission_success)

-- Tier 3 - Training
barn_sinkko_convo_tier3_train_fighters = ConvoScreen:new {
	id = "tier3_train_fighters",
	leftDialog = "@conversation/naboo_imperial_tier3:s_4c42a50e",
	stopConversation = "true",
	options = {}
}
barn_sinkko_convo:addScreen(barn_sinkko_convo_tier3_train_fighters)

barn_sinkko_convo_tier3_train_component = ConvoScreen:new {
	id = "tier3_train_component",
	leftDialog = "@conversation/naboo_imperial_tier3:s_4c42a50e",
	stopConversation = "true",
	options = {}
}
barn_sinkko_convo:addScreen(barn_sinkko_convo_tier3_train_component)

barn_sinkko_convo_tier3_train_procedures = ConvoScreen:new {
	id = "tier3_train_procedures",
	leftDialog = "@conversation/naboo_imperial_tier3:s_4c42a50e",
	stopConversation = "true",
	options = {}
}
barn_sinkko_convo:addScreen(barn_sinkko_convo_tier3_train_procedures)

barn_sinkko_convo_tier3_train_droid = ConvoScreen:new {
	id = "tier3_train_droid",
	leftDialog = "@conversation/naboo_imperial_tier3:s_4c42a50e",
	stopConversation = "true",
	options = {}
}
barn_sinkko_convo:addScreen(barn_sinkko_convo_tier3_train_droid)

-- Tier 3 - Completed
barn_sinkko_convo_tier3_completed = ConvoScreen:new {
	id = "tier3_completed",
	leftDialog = "@conversation/naboo_imperial_tier3:s_f50e2248",
	stopConversation = "true",
	options = {}
}
barn_sinkko_convo:addScreen(barn_sinkko_convo_tier3_completed)

--[[

	Tier 4

]]

-- Tier 4 - Active Mission
barn_sinkko_convo_tier4_on_mission = ConvoScreen:new {
	id = "tier4_on_mission",
	leftDialog = "@conversation/naboo_imperial_tier4:s_fcbb92d0",
	stopConversation = "true",
	options = {}
}
barn_sinkko_convo:addScreen(barn_sinkko_convo_tier4_on_mission)

-- Tier 4 - Initial Briefing
barn_sinkko_convo_tier4_initial_briefing = ConvoScreen:new {
	id = "tier4_initial_briefing",
	leftDialog = "@conversation/naboo_imperial_tier4:s_59da8c80",
	stopConversation = "false",
	options = {
		{"@conversation/naboo_imperial_tier4:s_c82e9a2f", "tier4_first_mission"},
	}
}
barn_sinkko_convo:addScreen(barn_sinkko_convo_tier4_initial_briefing)

-- Tier 4 - Mission 1
barn_sinkko_convo_tier4_first_mission = ConvoScreen:new {
	id = "tier4_first_mission",
	leftDialog = "@conversation/naboo_imperial_tier4:s_47b7d709",
	stopConversation = "false",
	options = {
		{"@conversation/naboo_imperial_tier4:s_488aa777", "tier4_first_mission_details"},
		{"@conversation/naboo_imperial_tier4:s_e69b471b", "accept_tier4_first_mission"},
	}
}
barn_sinkko_convo:addScreen(barn_sinkko_convo_tier4_first_mission)

barn_sinkko_convo_tier4_first_mission_details = ConvoScreen:new {
	id = "tier4_first_mission_details",
	leftDialog = "@conversation/naboo_imperial_tier4:s_e89ef227",
	stopConversation = "false",
	options = {
		{"@conversation/naboo_imperial_tier4:s_e69b471b", "accept_tier4_first_mission"},
	}
}
barn_sinkko_convo:addScreen(barn_sinkko_convo_tier4_first_mission_details)

barn_sinkko_convo_accept_tier4_first_mission = ConvoScreen:new {
	id = "accept_tier4_first_mission",
	leftDialog = "@conversation/naboo_imperial_tier4:s_6387b3e9",
	stopConversation = "true",
	options = {}
}
barn_sinkko_convo:addScreen(barn_sinkko_convo_accept_tier4_first_mission)

barn_sinkko_convo_failed_tier4_first_mission = ConvoScreen:new {
	id = "failed_tier4_first_mission",
	leftDialog = "@conversation/naboo_imperial_tier4:s_91d10a84",
	stopConversation = "true",
	options = {}
}
barn_sinkko_convo:addScreen(barn_sinkko_convo_failed_tier4_first_mission)

barn_sinkko_convo_tier4_first_mission_success = ConvoScreen:new {
	id = "tier4_first_mission_success",
	leftDialog = "@conversation/naboo_imperial_tier4:s_725be20b",
	stopConversation = "false",
	options = {
		{"@conversation/naboo_imperial_tier4:s_bdebb4cc", "tier4_second_mission"},
	}
}
barn_sinkko_convo:addScreen(barn_sinkko_convo_tier4_first_mission_success)

-- Tier 4 - Mission 2
barn_sinkko_convo_tier4_second_mission = ConvoScreen:new {
	id = "tier4_second_mission",
	leftDialog = "@conversation/naboo_imperial_tier4:s_1e39a0ae",
	stopConversation = "false",
	options = {
		{"@conversation/naboo_imperial_tier4:s_8a38a5ed", "tier4_second_mission_details"},
		{"@conversation/naboo_imperial_tier4:s_6d741d67", "accept_tier4_second_mission"},
	}
}
barn_sinkko_convo:addScreen(barn_sinkko_convo_tier4_second_mission)

barn_sinkko_convo_tier4_second_mission_details = ConvoScreen:new {
	id = "tier4_second_mission_details",
	leftDialog = "@conversation/naboo_imperial_tier4:s_4ee43f47",
	stopConversation = "false",
	options = {
		{"@conversation/naboo_imperial_tier4:s_6d741d67", "accept_tier4_second_mission"},
	}
}
barn_sinkko_convo:addScreen(barn_sinkko_convo_tier4_second_mission_details)

barn_sinkko_convo_accept_tier4_second_mission = ConvoScreen:new {
	id = "accept_tier4_second_mission",
	leftDialog = "@conversation/naboo_imperial_tier4:s_9a9518f8",
	stopConversation = "true",
	options = {}
}
barn_sinkko_convo:addScreen(barn_sinkko_convo_accept_tier4_second_mission)

barn_sinkko_convo_failed_tier4_second_mission = ConvoScreen:new {
	id = "failed_tier4_second_mission",
	leftDialog = "@conversation/naboo_imperial_tier4:s_91d10a84",
	stopConversation = "true",
	options = {}
}
barn_sinkko_convo:addScreen(barn_sinkko_convo_failed_tier4_second_mission)

barn_sinkko_convo_tier4_second_mission_success = ConvoScreen:new {
	id = "tier4_second_mission_success",
	leftDialog = "@conversation/naboo_imperial_tier4:s_417ab2a4",
	stopConversation = "false",
	options = {
		{"@conversation/naboo_imperial_tier4:s_834bed59", "tier4_third_mission"},
	}
}
barn_sinkko_convo:addScreen(barn_sinkko_convo_tier4_second_mission_success)

-- Tier 4 - Mission 3
barn_sinkko_convo_tier4_third_mission = ConvoScreen:new {
	id = "tier4_third_mission",
	leftDialog = "@conversation/naboo_imperial_tier4:s_dafddb17",
	stopConversation = "false",
	options = {
		{"@conversation/naboo_imperial_tier4:s_362a48e0", "tier4_third_mission_details"},
		{"@conversation/naboo_imperial_tier4:s_c17d2691", "accept_tier4_third_mission"},
	}
}
barn_sinkko_convo:addScreen(barn_sinkko_convo_tier4_third_mission)

barn_sinkko_convo_tier4_third_mission_details = ConvoScreen:new {
	id = "tier4_third_mission_details",
	leftDialog = "@conversation/naboo_imperial_tier4:s_4bcaf756",
	stopConversation = "false",
	options = {
		{"@conversation/naboo_imperial_tier4:s_c17d2691", "accept_tier4_third_mission"},
	}
}
barn_sinkko_convo:addScreen(barn_sinkko_convo_tier4_third_mission_details)

barn_sinkko_convo_accept_tier4_third_mission = ConvoScreen:new {
	id = "accept_tier4_third_mission",
	leftDialog = "@conversation/naboo_imperial_tier4:s_db35e23",
	stopConversation = "true",
	options = {}
}
barn_sinkko_convo:addScreen(barn_sinkko_convo_accept_tier4_third_mission)

barn_sinkko_convo_failed_tier4_third_mission = ConvoScreen:new {
	id = "failed_tier4_third_mission",
	leftDialog = "@conversation/naboo_imperial_tier4:s_91d10a84",
	stopConversation = "true",
	options = {}
}
barn_sinkko_convo:addScreen(barn_sinkko_convo_failed_tier4_third_mission)

barn_sinkko_convo_tier4_third_mission_success = ConvoScreen:new {
	id = "tier4_third_mission_success",
	leftDialog = "@conversation/naboo_imperial_tier4:s_aa21cdc1",
	stopConversation = "false",
	options = {
		{"@conversation/naboo_imperial_tier4:s_938d7337", "tier4_fourth_mission"},
	}
}
barn_sinkko_convo:addScreen(barn_sinkko_convo_tier4_third_mission_success)

-- Tier 4 - Mission 4
barn_sinkko_convo_tier4_fourth_mission = ConvoScreen:new {
	id = "tier4_fourth_mission",
	leftDialog = "@conversation/naboo_imperial_tier4:s_1899241d",
	stopConversation = "false",
	options = {
		{"@conversation/naboo_imperial_tier4:s_e07a0513", "tier4_fourth_mission_details"},
		{"@conversation/naboo_imperial_tier4:s_e69b471b", "accept_tier4_fourth_mission"},
	}
}
barn_sinkko_convo:addScreen(barn_sinkko_convo_tier4_fourth_mission)

barn_sinkko_convo_tier4_fourth_mission_details = ConvoScreen:new {
	id = "tier4_fourth_mission_details",
	leftDialog = "@conversation/naboo_imperial_tier4:s_c25d28ef",
	stopConversation = "false",
	options = {
		{"@conversation/naboo_imperial_tier4:s_e69b471b", "accept_tier4_fourth_mission"},
	}
}
barn_sinkko_convo:addScreen(barn_sinkko_convo_tier4_fourth_mission_details)

barn_sinkko_convo_accept_tier4_fourth_mission = ConvoScreen:new {
	id = "accept_tier4_fourth_mission",
	leftDialog = "@conversation/naboo_imperial_tier4:s_320b2029",
	stopConversation = "true",
	options = {}
}
barn_sinkko_convo:addScreen(barn_sinkko_convo_accept_tier4_fourth_mission)

barn_sinkko_convo_failed_tier4_fourth_mission = ConvoScreen:new {
	id = "failed_tier4_fourth_mission",
	leftDialog = "@conversation/naboo_imperial_tier4:s_91d10a84",
	stopConversation = "true",
	options = {}
}
barn_sinkko_convo:addScreen(barn_sinkko_convo_failed_tier4_fourth_mission)

barn_sinkko_convo_tier4_fourth_mission_success = ConvoScreen:new {
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
barn_sinkko_convo:addScreen(barn_sinkko_convo_tier4_fourth_mission_success)

-- Master mission
barn_sinkko_convo_master_mission = ConvoScreen:new {
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
barn_sinkko_convo:addScreen(barn_sinkko_convo_master_mission)

barn_sinkko_convo_master_who_declann = ConvoScreen:new {
	id = "master_who_declann",
	leftDialog = "@conversation/naboo_imperial_tier4:s_55905a28",
	stopConversation = "false",
	options = {
		{"@conversation/naboo_imperial_tier4:s_17fa0de9", "accept_master_mission"},
	}
}
barn_sinkko_convo:addScreen(barn_sinkko_convo_master_who_declann)

barn_sinkko_convo_master_where_report = ConvoScreen:new {
	id = "master_where_report",
	leftDialog = "@conversation/naboo_imperial_tier4:s_a0d28eb",
	stopConversation = "false",
	options = {
		{"@conversation/naboo_imperial_tier4:s_17fa0de9", "accept_master_mission"},
	}
}
barn_sinkko_convo:addScreen(barn_sinkko_convo_master_where_report)

barn_sinkko_convo_master_what_want = ConvoScreen:new {
	id = "master_what_want",
	leftDialog = "@conversation/naboo_imperial_tier4:s_cd04b926",
	stopConversation = "false",
	options = {
		{"@conversation/naboo_imperial_tier4:s_17fa0de9", "accept_master_mission"},
	}
}
barn_sinkko_convo:addScreen(barn_sinkko_convo_master_what_want)

barn_sinkko_convo_master_becoming_imperial = ConvoScreen:new {
	id = "master_becoming_imperial",
	leftDialog = "@conversation/naboo_imperial_tier4:s_c33416a7",
	stopConversation = "false",
	options = {
		{"@conversation/naboo_imperial_tier4:s_17fa0de9", "accept_master_mission"},
	}
}
barn_sinkko_convo:addScreen(barn_sinkko_convo_master_becoming_imperial)

barn_sinkko_convo_accept_master_mission = ConvoScreen:new {
	id = "accept_master_mission",
	leftDialog = "@conversation/naboo_imperial_tier4:s_c28f20f3",
	stopConversation = "true",
	options = {}
}
barn_sinkko_convo:addScreen(barn_sinkko_convo_accept_master_mission)

-- Tier 4 - Completed
barn_sinkko_convo_tier4_completed = ConvoScreen:new {
	id = "tier4_completed",
	leftDialog = "@conversation/naboo_imperial_tier4:s_145d7cc3",
	stopConversation = "false",
	options = {
		{"@conversation/naboo_imperial_tier4:s_4854758d", "tier4_duty_repeat"},
	}
}
barn_sinkko_convo:addScreen(barn_sinkko_convo_tier4_completed)

-- Tier 4 - Training
barn_sinkko_convo_ready_train_tier4 = ConvoScreen:new {
	id = "ready_train_tier4",
	leftDialog = "@conversation/naboo_imperial_tier4:s_5dce257f",
	stopConversation = "false",
	options = {
		-- Options added dynamically via handler
	}
}
barn_sinkko_convo:addScreen(barn_sinkko_convo_ready_train_tier4)

barn_sinkko_convo_tier4_train_fighters = ConvoScreen:new {
	id = "tier4_train_fighters",
	leftDialog = "@conversation/naboo_imperial_tier4:s_490da0e3",
	stopConversation = "true",
	options = {}
}
barn_sinkko_convo:addScreen(barn_sinkko_convo_tier4_train_fighters)

barn_sinkko_convo_tier4_train_component = ConvoScreen:new {
	id = "tier4_train_component",
	leftDialog = "@conversation/naboo_imperial_tier4:s_490da0e3",
	stopConversation = "true",
	options = {}
}
barn_sinkko_convo:addScreen(barn_sinkko_convo_tier4_train_component)

barn_sinkko_convo_tier4_train_basics = ConvoScreen:new {
	id = "tier4_train_basics",
	leftDialog = "@conversation/naboo_imperial_tier4:s_490da0e3",
	stopConversation = "true",
	options = {}
}
barn_sinkko_convo:addScreen(barn_sinkko_convo_tier4_train_basics)

barn_sinkko_convo_tier4_train_droid = ConvoScreen:new {
	id = "tier4_train_droid",
	leftDialog = "@conversation/naboo_imperial_tier4:s_490da0e3",
	stopConversation = "true",
	options = {}
}
barn_sinkko_convo:addScreen(barn_sinkko_convo_tier4_train_droid)

-- Tier 4 - Duty missions
barn_sinkko_convo_tier4_duty_repeat = ConvoScreen:new {
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
barn_sinkko_convo:addScreen(barn_sinkko_convo_tier4_duty_repeat)

barn_sinkko_convo_tier4_duty_brief1 = ConvoScreen:new {
	id = "tier4_duty_brief1",
	leftDialog = "@conversation/naboo_imperial_tier4:s_85c9e37e",
	stopConversation = "false",
	options = {
		{"@conversation/naboo_imperial_tier4:s_61657d0f", "tier4_duty_brief2"},
	}
}
barn_sinkko_convo:addScreen(barn_sinkko_convo_tier4_duty_brief1)

barn_sinkko_convo_tier4_duty_brief2 = ConvoScreen:new {
	id = "tier4_duty_brief2",
	leftDialog = "@conversation/naboo_imperial_tier4:s_52708145",
	stopConversation = "false",
	options = {
		{"@conversation/naboo_imperial_tier4:s_61657d0f", "tier4_duty_brief3"},
	}
}
barn_sinkko_convo:addScreen(barn_sinkko_convo_tier4_duty_brief2)

barn_sinkko_convo_tier4_duty_brief3 = ConvoScreen:new {
	id = "tier4_duty_brief3",
	leftDialog = "@conversation/naboo_imperial_tier4:s_f76cec26",
	stopConversation = "false",
	options = {
		{"@conversation/naboo_imperial_tier4:s_61657d0f", "tier4_duty_menu"},
	}
}
barn_sinkko_convo:addScreen(barn_sinkko_convo_tier4_duty_brief3)

barn_sinkko_convo_tier4_duty_menu = ConvoScreen:new {
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
barn_sinkko_convo:addScreen(barn_sinkko_convo_tier4_duty_menu)

barn_sinkko_convo_accept_tier4_duty1 = ConvoScreen:new {
	id = "accept_tier4_duty1",
	leftDialog = "@conversation/naboo_imperial_tier4:s_ee5488a5",
	stopConversation = "true",
	options = {}
}
barn_sinkko_convo:addScreen(barn_sinkko_convo_accept_tier4_duty1)

barn_sinkko_convo_accept_tier4_duty2 = ConvoScreen:new {
	id = "accept_tier4_duty2",
	leftDialog = "@conversation/naboo_imperial_tier4:s_ee5488a5",
	stopConversation = "true",
	options = {}
}
barn_sinkko_convo:addScreen(barn_sinkko_convo_accept_tier4_duty2)

barn_sinkko_convo_accept_tier4_duty3 = ConvoScreen:new {
	id = "accept_tier4_duty3",
	leftDialog = "@conversation/naboo_imperial_tier4:s_ee5488a5",
	stopConversation = "true",
	options = {}
}
barn_sinkko_convo:addScreen(barn_sinkko_convo_accept_tier4_duty3)

barn_sinkko_convo_accept_tier4_duty4 = ConvoScreen:new {
	id = "accept_tier4_duty4",
	leftDialog = "@conversation/naboo_imperial_tier4:s_ee5488a5",
	stopConversation = "true",
	options = {}
}
barn_sinkko_convo:addScreen(barn_sinkko_convo_accept_tier4_duty4)


addConversationTemplate("barn_sinkko_convo", barn_sinkko_convo);
