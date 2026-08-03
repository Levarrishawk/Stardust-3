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

addConversationTemplate("barn_sinkko_convo", barn_sinkko_convo);
