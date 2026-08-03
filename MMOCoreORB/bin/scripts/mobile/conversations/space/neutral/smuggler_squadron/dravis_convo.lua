--[[
	Dravis -- Smuggler Alliance Squadron (Neutral) Tier 1 recruiter/trainer conversation.

	Structural port of the proven Inquisition recruiter template, driven by the
	authentic Live Imperial trainer string file extracted from the client TRE:
		string/en/conversation/tatooine_privateer_trainer_1.stf
	Every leftDialog / option below references a real @conversation/tatooine_privateer_trainer_1:s_<hash>
	string from that table (English text shown in the trailing comment). Screen-flow control lives in
	dravisConvoHandler.lua. The screen graph mirrors the template's recruit -> ship -> tier-1
	mission ladder (patrol/destroy/escort/assassinate) -> duties -> reassignment-to-Inquisitor flow.

	RECONSTRUCTED (marked inline): a small number of connective screen transitions whose exact
	original screen-id wiring is client-side data; the dialogue STRINGS themselves are all sourced
	from the real Imperial trainer STF (no invented prose).
]]

dravis_convo = ConvoTemplate:new {
	initialScreen = "",
	templateType = "Lua",
	luaClassHandler = "dravisConvoHandler",
	screens = {}
}

-- JTL Disabled / No Space Expansion
dravis_convo_no_jtl = ConvoScreen:new {
	id = "no_jtl",
	leftDialog = "@conversation/tatooine_privateer_trainer_1:s_c30fda16", -- Unless you have business with the Imperial Navy, I must ask you to come back another time. I'm very busy right now.
	stopConversation = "true",
	options = {}
}
dravis_convo:addScreen(dravis_convo_no_jtl)

-- Rebel Pilot (turned away)
dravis_convo_rebel_pilot = ConvoScreen:new {
	id = "imperial_pilot",
	leftDialog = "@conversation/tatooine_privateer_trainer_1:s_681e480d", -- I've seen your face! You're a known Rebel pilot!
	stopConversation = "true",
	animation = "point_accusingly",
	options = {}
}
dravis_convo:addScreen(dravis_convo_rebel_pilot)

-- Neutral/Privateer Pilot (turned away)
dravis_convo_neutral_pilot = ConvoScreen:new {
	id = "rebel_pilot",
	leftDialog = "@conversation/tatooine_privateer_trainer_1:s_20df70f7", -- Good to meet you Pilot. According to my records you're already working with a different division. What can I do for you?
	stopConversation = "true",
	animation = "shrug_shoulders",
	options = {}
}
dravis_convo:addScreen(dravis_convo_neutral_pilot)

-- Imperial pilot, different squadron
dravis_convo_non_inquisition_pilot = ConvoScreen:new {
	id = "non_inquisition_pilot",
	leftDialog = "@conversation/tatooine_privateer_trainer_1:s_20df70f7", -- Good to meet you Pilot. According to my records you're already working with a different division. What can I do for you?
	stopConversation = "false",
	options = {
		{"@conversation/tatooine_privateer_trainer_1:s_e81a1436", "duty_missions"}, -- I would like to request a mission.
	}
}
dravis_convo:addScreen(dravis_convo_non_inquisition_pilot)

--[[ Recruitment flow ]]
dravis_convo_recruitment = ConvoScreen:new {
	id = "recruitment",
	leftDialog = "@conversation/tatooine_privateer_trainer_1:s_d60a3e3", -- Welcome to the Imperial Navy Recruitment Center. My name is Lieutenant Barn Sinkko. Are you interested in learning about the Imperial Navy?
	stopConversation = "false",
	options = {
		{"@conversation/tatooine_privateer_trainer_1:s_8d95c731", "yes_join"}, -- I'd like to sign up, sir.
		{"@conversation/tatooine_privateer_trainer_1:s_381dd7dd", "why_volunteers"}, -- The Empire is recruiting volunteer pilots?
		{"@conversation/tatooine_privateer_trainer_1:s_2883b989", "decline_join"}, -- I'd rather not sign up right now, sir.
	}
}
dravis_convo:addScreen(dravis_convo_recruitment)

dravis_convo_why_volunteers = ConvoScreen:new {
	id = "why_volunteers",
	leftDialog = "@conversation/tatooine_privateer_trainer_1:s_85355c2f", -- Yes, volunteers or conscripts. Rebel opposition has become more direct. We want to recruit new pilots for support duty, freeing up combat pilots for the front lines.
	stopConversation = "false",
	options = {
		{"@conversation/tatooine_privateer_trainer_1:s_8d95c731", "yes_join"}, -- I'd like to sign up, sir.
		{"@conversation/tatooine_privateer_trainer_1:s_2883b989", "decline_join"}, -- I'd rather not sign up right now, sir.
	}
}
dravis_convo:addScreen(dravis_convo_why_volunteers)

dravis_convo_decline_join = ConvoScreen:new {
	id = "decline_join",
	leftDialog = "@conversation/tatooine_privateer_trainer_1:s_41e93b9e", -- I hope you reconsider. Good day, citizen.
	stopConversation = "true",
	animation = "goodbye",
	options = {}
}
dravis_convo:addScreen(dravis_convo_decline_join)

-- Sign-up confirmation (handler routes "yes_join" here)
dravis_convo_join_confirm = ConvoScreen:new {
	id = "join_confirm",
	leftDialog = "@conversation/tatooine_privateer_trainer_1:s_7436b5b6", -- Are you sure you want to sign up? You'll be expected to follow orders and treat your superiors with respect. This is a tight operation and we deal harshly with insubordinate behavior.
	stopConversation = "false",
	options = {
		{"@conversation/tatooine_privateer_trainer_1:s_e81a1436", "yes_i_am"}, -- Yes, sir! I want to be in the Imperial Navy.
		{"@conversation/tatooine_privateer_trainer_1:s_2883b989", "decline_join"}, -- I'd rather not sign up right now, sir.
	}
}
dravis_convo:addScreen(dravis_convo_join_confirm)

-- Conscription/welcome (handler grants novice box + squadron + tier here)
dravis_convo_yes_i_am = ConvoScreen:new {
	id = "yes_i_am",
	leftDialog = "@conversation/tatooine_privateer_trainer_1:s_7f1ca275", -- By the powers vested in me by the Imperial Naval Command... I hereby conscript you to service with the non-officer flight rank of Pilot Initiate. May you serve the Empire dutifully. Welcome to the Imperial Navy.
	stopConversation = "false",
	options = {}
}
dravis_convo:addScreen(dravis_convo_yes_i_am)

-- No Ship - grants ship
dravis_convo_no_ship = ConvoScreen:new {
	id = "no_ship",
	leftDialog = "@conversation/tatooine_privateer_trainer_1:s_70421509", -- I'm transferring a ship authorization and control device to your datapad. You'll need this to use your TIE Fighter...
	stopConversation = "false",
	animation = "nod_head_multiple",
	options = {
		{"@conversation/tatooine_privateer_trainer_1:s_1adbadc4", "yes_im_ready"}, -- I'm ready, sir.
	}
}
dravis_convo:addScreen(dravis_convo_no_ship)

dravis_convo_yes_ship = ConvoScreen:new {
	id = "yes_ship",
	leftDialog = "@conversation/tatooine_privateer_trainer_1:s_807f6dd0", -- Are you ready for your first assignment?
	stopConversation = "false",
	options = {
		{"@conversation/tatooine_privateer_trainer_1:s_1adbadc4", "yes_im_ready"}, -- I'm ready, sir.
	}
}
dravis_convo:addScreen(dravis_convo_yes_ship)

--[[ Tier 1 -- Mission 1: Patrol (handler starts patrol_naboo_imperial_1) ]]
dravis_convo_yes_im_ready = ConvoScreen:new {
	id = "yes_im_ready",
	leftDialog = "@conversation/tatooine_privateer_trainer_1:s_d345d41f", -- Not today. I'm transferring the coordinates of a local security patrol route... Fly a single circuit of the patrol route... When you're done, return to me for further instructions.
	stopConversation = "true",
	options = {}
}
dravis_convo:addScreen(dravis_convo_yes_im_ready)

-- Player is on quest 1 and returns before completing it
dravis_convo_first_quest_active = ConvoScreen:new {
	id = "first_quest_active",
	leftDialog = "@conversation/tatooine_privateer_trainer_1:s_2e5f3688", -- Report back to me when you are finished with the patrol.
	stopConversation = "true",
	options = {}
}
dravis_convo:addScreen(dravis_convo_first_quest_active)

-- Quest 1 complete, needs reward (handler rewards on "patrol_complete")
dravis_convo_excellent_work = ConvoScreen:new {
	id = "excellent_work",
	leftDialog = "@conversation/tatooine_privateer_trainer_1:s_2e5f3688", -- Pilot. Report on the status of your patrol.
	stopConversation = "false",
	options = {
		{"@conversation/tatooine_privateer_trainer_1:s_3818dc2a", "patrol_complete"}, -- I was attacked by a Rebel fighter wing, sir.
		{"@conversation/tatooine_privateer_trainer_1:s_6106187c", "patrol_complete"}, -- Just doing my duty, sir.
	}
}
dravis_convo:addScreen(dravis_convo_excellent_work)

dravis_convo_patrol_complete = ConvoScreen:new {
	id = "patrol_complete",
	leftDialog = "@conversation/tatooine_privateer_trainer_1:s_6d6f9a8d", -- You did? Impressive... You've shown that not only can you fly a basic patrol, but you aren't bad with a laser cannon either. Here's your payment for the job.
	stopConversation = "true",
	options = {}
}
dravis_convo:addScreen(dravis_convo_patrol_complete)

-- Quest 1 failed/aborted
dravis_convo_failed_quest1 = ConvoScreen:new {
	id = "failed_quest1",
	leftDialog = "@conversation/tatooine_privateer_trainer_1:s_70421509", -- I've transferred the patrol coordinates to your datapad. Try harder this time, pilot.
	stopConversation = "false",
	options = {
		{"@conversation/tatooine_privateer_trainer_1:s_1adbadc4", "retry_quest1"}, -- I'm ready, sir.
	}
}
dravis_convo:addScreen(dravis_convo_failed_quest1)

--[[ Tier 1 -- Mission 2: Destroy (handler starts destroy_naboo_imperial_2) ]]
dravis_convo_grant_quest2 = ConvoScreen:new {
	id = "grant_quest2",
	leftDialog = "@conversation/tatooine_privateer_trainer_1:s_3924fc00", -- You performed admirably... I want you to hunt down and destroy the rebel vessels in the area of the 'Kantari' attack... The security of the Naboo system must be maintained.
	stopConversation = "false",
	options = {
		{"@conversation/tatooine_privateer_trainer_1:s_6106187c", "quest2_accepted"}, -- What's the mission, sir?
	}
}
dravis_convo:addScreen(dravis_convo_grant_quest2)

dravis_convo_quest2_accepted = ConvoScreen:new {
	id = "quest2_accepted",
	leftDialog = "@conversation/tatooine_privateer_trainer_1:s_3924fc00", -- I want you to hunt down and destroy the Rebel vessels in the area of the 'Kantari' attack. The Rebels are still out there and we must make them pay. Eliminate them.
	stopConversation = "true",
	options = {}
}
dravis_convo:addScreen(dravis_convo_quest2_accepted)

dravis_convo_excellent_work2 = ConvoScreen:new {
	id = "excellent_work2",
	leftDialog = "@conversation/tatooine_privateer_trainer_1:s_e5c453e0", -- Good job. I'm crediting you for the mission, along with a little extra. You performed admirably.
	stopConversation = "true",
	options = {}
}
dravis_convo:addScreen(dravis_convo_excellent_work2)

dravis_convo_failed_quest2 = ConvoScreen:new {
	id = "failed_quest2",
	leftDialog = "@conversation/tatooine_privateer_trainer_1:s_9ea8105f", -- Report back to me when you've successfully eliminated the Rebels. And do not abort your mission again!
	stopConversation = "false",
	options = {
		{"@conversation/tatooine_privateer_trainer_1:s_1adbadc4", "retry_quest2"}, -- I'm ready, sir.
	}
}
dravis_convo:addScreen(dravis_convo_failed_quest2)

--[[ Tier 1 -- Mission 3: Patrol/Escort (handler starts patrol_naboo_imperial_3 on "train_me3") ]]
dravis_convo_excellent_work3 = ConvoScreen:new {
	id = "excellent_work3",
	leftDialog = "@conversation/tatooine_privateer_trainer_1:s_e5c453e0", -- With the recent increase in Rebel activity, our supply transports are at risk... You will be paid for every successful escort operation you complete.
	stopConversation = "false",
	options = {
		{"@conversation/tatooine_privateer_trainer_1:s_b26194cb", "quest3_rewarded"}, -- What are my orders, sir?
	}
}
dravis_convo:addScreen(dravis_convo_excellent_work3)

dravis_convo_quest3_rewarded = ConvoScreen:new {
	id = "quest3_rewarded",
	leftDialog = "@conversation/tatooine_privateer_trainer_1:s_2a8b0366", -- Good, I have a lot of work for you... I can also assign you to escorting transports moving supplies.
	stopConversation = "false",
	options = {
		{"@conversation/tatooine_privateer_trainer_1:s_1adbadc4", "train_me3"}, -- I'm ready, sir.
	}
}
dravis_convo:addScreen(dravis_convo_quest3_rewarded)

dravis_convo_failed_quest3 = ConvoScreen:new {
	id = "failed_quest3",
	leftDialog = "@conversation/tatooine_privateer_trainer_1:s_61b6e28a", -- Report to me when you've completed your mission.
	stopConversation = "false",
	options = {
		{"@conversation/tatooine_privateer_trainer_1:s_1adbadc4", "retry_quest3"}, -- I'm ready, sir.
	}
}
dravis_convo:addScreen(dravis_convo_failed_quest3)

--[[ Tier 1 -- Mission 4: Assassinate (handler starts assassinate_naboo_imperial_4 on "quest4_accepted") ]]
dravis_convo_grant_quest4 = ConvoScreen:new {
	id = "grant_quest4",
	leftDialog = "@conversation/tatooine_privateer_trainer_1:s_3924fc00", -- You've shown a lot of promise so far, Pilot. This is a key assignment. We expect the Rebel team leader to be a highly skilled and well trained pilot. Don't underestimate him.
	stopConversation = "false",
	options = {
		{"@conversation/tatooine_privateer_trainer_1:s_6106187c", "quest4_accepted"}, -- What's the mission, sir?
	}
}
dravis_convo:addScreen(dravis_convo_grant_quest4)

dravis_convo_quest4_accepted = ConvoScreen:new {
	id = "quest4_accepted",
	leftDialog = "@conversation/tatooine_privateer_trainer_1:s_d345d41f", -- We have discovered the possible location of the Rebel team leader... Travel to the waypoint... Find and eliminate him.
	stopConversation = "true",
	options = {}
}
dravis_convo:addScreen(dravis_convo_quest4_accepted)

dravis_convo_failed_quest4 = ConvoScreen:new {
	id = "failed_quest4",
	leftDialog = "@conversation/tatooine_privateer_trainer_1:s_681e480d", -- Report on the status of your operation against the Rebel leader, Pilot.
	stopConversation = "false",
	options = {
		{"@conversation/tatooine_privateer_trainer_1:s_1adbadc4", "retry_quest4"}, -- I'm ready, sir.
	}
}
dravis_convo:addScreen(dravis_convo_failed_quest4)

--[[ Player has an active (non-first) mission ]]
dravis_convo_has_mission = ConvoScreen:new {
	id = "has_mission",
	leftDialog = "@conversation/tatooine_privateer_trainer_1:s_b4d6cb30", -- Report back to me when you are finished with your current mission. You can abort your mission if you want to start over.
	stopConversation = "true",
	options = {}
}
dravis_convo:addScreen(dravis_convo_has_mission)

--[[ All four Tier-1 missions complete -> free training choices (handler builds options) ]]
dravis_convo_missions_complete = ConvoScreen:new {
	id = "missions_complete",
	leftDialog = "@conversation/tatooine_privateer_trainer_1:s_6d6f9a8d", -- Pilot, I am singularly impressed. You have mastered the fundamentals of your profession and have performed beyond expectation... I think it's time for a promotion.
	stopConversation = "false",
	options = {}
}
dravis_convo:addScreen(dravis_convo_missions_complete)

--[[ Additional (XP-gated) training (handler builds options) ]]
dravis_convo_more_training = ConvoScreen:new {
	id = "more_training",
	leftDialog = "@conversation/tatooine_privateer_trainer_1:s_4d19fcb1", -- You can learn about Imperial technology, equipment, space combat training, or astromech management.
	stopConversation = "false",
	options = {}
}
dravis_convo:addScreen(dravis_convo_more_training)

-- training acknowledgement screens (handler grants the skill then returns the cloned screen)
dravis_convo_train_player_fighters = ConvoScreen:new {
	id = "train_player_fighters",
	leftDialog = "@conversation/tatooine_privateer_trainer_1:s_2b94498c", -- Good choice. Report back when you are ready for an assignment.
	stopConversation = "true",
	options = {}
}
dravis_convo:addScreen(dravis_convo_train_player_fighters)

dravis_convo_train_player_component = ConvoScreen:new {
	id = "train_player_component",
	leftDialog = "@conversation/tatooine_privateer_trainer_1:s_2b94498c", -- Good choice. Report back when you are ready for an assignment.
	stopConversation = "true",
	options = {}
}
dravis_convo:addScreen(dravis_convo_train_player_component)

dravis_convo_train_player_basics = ConvoScreen:new {
	id = "train_player_basics",
	leftDialog = "@conversation/tatooine_privateer_trainer_1:s_2b94498c", -- Good choice. Report back when you are ready for an assignment.
	stopConversation = "true",
	options = {}
}
dravis_convo:addScreen(dravis_convo_train_player_basics)

dravis_convo_train_player_droid = ConvoScreen:new {
	id = "train_player_droid",
	leftDialog = "@conversation/tatooine_privateer_trainer_1:s_2b94498c", -- Good choice. Report back when you are ready for an assignment.
	stopConversation = "true",
	options = {}
}
dravis_convo:addScreen(dravis_convo_train_player_droid)

-- free-training variants (same acknowledgement string)
dravis_convo_train_player_fighters_free = ConvoScreen:new {
	id = "train_player_fighters_free",
	leftDialog = "@conversation/tatooine_privateer_trainer_1:s_2b94498c", -- Good choice. Report back when you are ready for an assignment.
	stopConversation = "true",
	options = {}
}
dravis_convo:addScreen(dravis_convo_train_player_fighters_free)

dravis_convo_train_player_component_free = ConvoScreen:new {
	id = "train_player_component_free",
	leftDialog = "@conversation/tatooine_privateer_trainer_1:s_2b94498c",
	stopConversation = "true",
	options = {}
}
dravis_convo:addScreen(dravis_convo_train_player_component_free)

dravis_convo_train_player_basics_free = ConvoScreen:new {
	id = "train_player_basics_free",
	leftDialog = "@conversation/tatooine_privateer_trainer_1:s_2b94498c",
	stopConversation = "true",
	options = {}
}
dravis_convo:addScreen(dravis_convo_train_player_basics_free)

dravis_convo_train_player_droid_free = ConvoScreen:new {
	id = "train_player_droid_free",
	leftDialog = "@conversation/tatooine_privateer_trainer_1:s_2b94498c",
	stopConversation = "true",
	options = {}
}
dravis_convo:addScreen(dravis_convo_train_player_droid_free)

--[[ Duty missions (Tier-1 grind: destroy / escort duty) ]]
dravis_convo_duty_missions = ConvoScreen:new {
	id = "duty_missions",
	leftDialog = "@conversation/tatooine_privateer_trainer_1:s_541c2f70", -- Pilot. I don't have any specific work for you at this time. You can now select your preferred operation from a list of general duties...
	stopConversation = "false",
	options = {
		{"@conversation/tatooine_privateer_trainer_1:s_3818dc2a", "destroy_duty"}, -- [Destroy Duty] I'm interested in hunting Rebel scum.
		{"@conversation/tatooine_privateer_trainer_1:s_7d57477f", "escort_duty"}, -- [Escort Duty] I'm interested in escorting transports.
	}
}
dravis_convo:addScreen(dravis_convo_duty_missions)

-- recruitment_not_imperial (player not yet faction-aligned)
dravis_convo_recruitment_not_imperial = ConvoScreen:new {
	id = "recruitment_not_imperial",
	leftDialog = "@conversation/tatooine_privateer_trainer_1:s_d60a3e3", -- Welcome to the Imperial Navy Recruitment Center. My name is Lieutenant Barn Sinkko. Are you interested in learning about the Imperial Navy?
	stopConversation = "false",
	options = {
		{"@conversation/tatooine_privateer_trainer_1:s_8d95c731", "yes_join"}, -- I'd like to sign up, sir.
		{"@conversation/tatooine_privateer_trainer_1:s_2883b989", "decline_join"}, -- I'd rather not sign up right now, sir.
	}
}
dravis_convo:addScreen(dravis_convo_recruitment_not_imperial)

--[[ Tier 1 complete -> reassigned to the Inquisition (Under Inquisitor Fa'Zoll) ]]
dravis_convo_completed_sinkko = ConvoScreen:new {
	id = "completed_sinkko",
	leftDialog = "@conversation/tatooine_privateer_trainer_1:s_999009d", -- Your skill behind the controls of the TIE Fighter have peaked the interest of several high ranking officers. In particular, members of the Imperial Inquisition have expressed their desire to take over your training...
	stopConversation = "false",
	options = {
		{"@conversation/tatooine_privateer_trainer_1:s_6106187c", "what_is_inquisition"}, -- What is the Imperial Inquisition?
		{"@conversation/tatooine_privateer_trainer_1:s_111621e7", "report_to_fazoll"}, -- Who do I report to?
	}
}
dravis_convo:addScreen(dravis_convo_completed_sinkko)

dravis_convo_what_is_inquisition = ConvoScreen:new {
	id = "what_is_inquisition",
	leftDialog = "@conversation/tatooine_privateer_trainer_1:s_85355c2f", -- The Inquisition is a special judicial branch of the Imperial Intelligence bureau... To become a member of the Inquisition is a rare honor.
	stopConversation = "false",
	options = {
		{"@conversation/tatooine_privateer_trainer_1:s_111621e7", "report_to_fazoll"}, -- Who do I report to?
	}
}
dravis_convo:addScreen(dravis_convo_what_is_inquisition)

-- Reassignment: grant waypoint to Under Inquisitor Fa'Zoll (handler sets sinkko_finished + waypoint)
dravis_convo_report_to_fazoll = ConvoScreen:new {
	id = "report_to_fazoll",
	leftDialog = "@conversation/tatooine_privateer_trainer_1:s_7f1ca275", -- Under Inquisitor Fa'Zoll in the Emperor's Retreat has been assigned as your new commanding officer...
	stopConversation = "true",
	options = {}
}
dravis_convo:addScreen(dravis_convo_report_to_fazoll)

-- Player already reassigned, returns to Sinkko
dravis_convo_go_to_next = ConvoScreen:new {
	id = "go_to_next",
	leftDialog = "@conversation/tatooine_privateer_trainer_1:s_71e7a88", -- I don't have anything else for you. Talk to Under Inquisitor Fa'Zoll in the Emperor's Retreat.
	stopConversation = "true",
	options = {}
}
dravis_convo:addScreen(dravis_convo_go_to_next)

addConversationTemplate("dravis_convo", dravis_convo);
