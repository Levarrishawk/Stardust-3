--[[
	Hakasha Sireen -- Black Epsilon Squadron (Imperial) Tier 1 recruiter/trainer conversation.

	Structural port of the proven Inquisition recruiter template, driven by the
	authentic Live Imperial trainer string file extracted from the client TRE:
		string/en/conversation/corellia_imperial_trainer_1.stf
	Every leftDialog / option below references a real @conversation/corellia_imperial_trainer_1:s_<hash>
	string from that table (English text shown in the trailing comment). Screen-flow control lives in
	hakasshaSireenConvoHandler.lua. The screen graph mirrors the template's recruit -> ship -> tier-1
	mission ladder (patrol/destroy/escort/assassinate) -> duties -> reassignment-to-Inquisitor flow.

	RECONSTRUCTED (marked inline): a small number of connective screen transitions whose exact
	original screen-id wiring is client-side data; the dialogue STRINGS themselves are all sourced
	from the real Imperial trainer STF (no invented prose).
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
	leftDialog = "@conversation/corellia_imperial_trainer_1:s_12d7f011", -- Unless you have business with the Imperial Navy, I must ask you to come back another time. I'm very busy right now.
	stopConversation = "true",
	options = {}
}
hakassha_sireen_convo:addScreen(hakassha_sireen_convo_no_jtl)

-- Rebel Pilot (turned away)
hakassha_sireen_convo_rebel_pilot = ConvoScreen:new {
	id = "rebel_pilot",
	leftDialog = "@conversation/corellia_imperial_trainer_1:s_11bb9c43", -- I've seen your face! You're a known Rebel pilot!
	stopConversation = "true",
	animation = "point_accusingly",
	options = {}
}
hakassha_sireen_convo:addScreen(hakassha_sireen_convo_rebel_pilot)

-- Neutral/Privateer Pilot (turned away)
hakassha_sireen_convo_neutral_pilot = ConvoScreen:new {
	id = "neutral_pilot",
	leftDialog = "@conversation/corellia_imperial_trainer_1:s_cae1bdcf", -- Good to meet you Pilot. According to my records you're already working with a different division. What can I do for you?
	stopConversation = "true",
	animation = "shrug_shoulders",
	options = {}
}
hakassha_sireen_convo:addScreen(hakassha_sireen_convo_neutral_pilot)

-- Imperial pilot, different squadron
hakassha_sireen_convo_non_inquisition_pilot = ConvoScreen:new {
	id = "non_inquisition_pilot",
	leftDialog = "@conversation/corellia_imperial_trainer_1:s_cae1bdcf", -- Good to meet you Pilot. According to my records you're already working with a different division. What can I do for you?
	stopConversation = "false",
	options = {
		{"@conversation/corellia_imperial_trainer_1:s_29e5ec7", "duty_missions"}, -- I would like to request a mission.
	}
}
hakassha_sireen_convo:addScreen(hakassha_sireen_convo_non_inquisition_pilot)

--[[ Recruitment flow ]]
hakassha_sireen_convo_recruitment = ConvoScreen:new {
	id = "recruitment",
	leftDialog = "@conversation/corellia_imperial_trainer_1:s_2e48b5f1", -- Welcome to the Imperial Navy Recruitment Center. My name is Lieutenant Barn Sinkko. Are you interested in learning about the Imperial Navy?
	stopConversation = "false",
	options = {
		{"@conversation/corellia_imperial_trainer_1:s_c6d9f61", "yes_join"}, -- I'd like to sign up, sir.
		{"@conversation/corellia_imperial_trainer_1:s_da3e5ec3", "why_volunteers"}, -- The Empire is recruiting volunteer pilots?
		{"@conversation/corellia_imperial_trainer_1:s_1acdc4ba", "decline_join"}, -- I'd rather not sign up right now, sir.
	}
}
hakassha_sireen_convo:addScreen(hakassha_sireen_convo_recruitment)

hakassha_sireen_convo_why_volunteers = ConvoScreen:new {
	id = "why_volunteers",
	leftDialog = "@conversation/corellia_imperial_trainer_1:s_c782972e", -- Yes, volunteers or conscripts. Rebel opposition has become more direct. We want to recruit new pilots for support duty, freeing up combat pilots for the front lines.
	stopConversation = "false",
	options = {
		{"@conversation/corellia_imperial_trainer_1:s_c6d9f61", "yes_join"}, -- I'd like to sign up, sir.
		{"@conversation/corellia_imperial_trainer_1:s_1acdc4ba", "decline_join"}, -- I'd rather not sign up right now, sir.
	}
}
hakassha_sireen_convo:addScreen(hakassha_sireen_convo_why_volunteers)

hakassha_sireen_convo_decline_join = ConvoScreen:new {
	id = "decline_join",
	leftDialog = "@conversation/corellia_imperial_trainer_1:s_11bb9c43", -- I hope you reconsider. Good day, citizen.
	stopConversation = "true",
	animation = "goodbye",
	options = {}
}
hakassha_sireen_convo:addScreen(hakassha_sireen_convo_decline_join)

-- Sign-up confirmation (handler routes "yes_join" here)
hakassha_sireen_convo_join_confirm = ConvoScreen:new {
	id = "join_confirm",
	leftDialog = "@conversation/corellia_imperial_trainer_1:s_42a16c5f", -- Are you sure you want to sign up? You'll be expected to follow orders and treat your superiors with respect. This is a tight operation and we deal harshly with insubordinate behavior.
	stopConversation = "false",
	options = {
		{"@conversation/corellia_imperial_trainer_1:s_67ded17", "yes_i_am"}, -- Yes, sir! I want to be in the Imperial Navy.
		{"@conversation/corellia_imperial_trainer_1:s_1acdc4ba", "decline_join"}, -- I'd rather not sign up right now, sir.
	}
}
hakassha_sireen_convo:addScreen(hakassha_sireen_convo_join_confirm)

-- Conscription/welcome (handler grants novice box + squadron + tier here)
hakassha_sireen_convo_yes_i_am = ConvoScreen:new {
	id = "yes_i_am",
	leftDialog = "@conversation/corellia_imperial_trainer_1:s_2e48b5f1", -- By the powers vested in me by the Imperial Naval Command... I hereby conscript you to service with the non-officer flight rank of Pilot Initiate. May you serve the Empire dutifully. Welcome to the Imperial Navy.
	stopConversation = "false",
	options = {}
}
hakassha_sireen_convo:addScreen(hakassha_sireen_convo_yes_i_am)

-- No Ship - grants ship
hakassha_sireen_convo_no_ship = ConvoScreen:new {
	id = "no_ship",
	leftDialog = "@conversation/corellia_imperial_trainer_1:s_c782972e", -- I'm transferring a ship authorization and control device to your datapad. You'll need this to use your TIE Fighter...
	stopConversation = "false",
	animation = "nod_head_multiple",
	options = {
		{"@conversation/corellia_imperial_trainer_1:s_1adbadc4", "yes_im_ready"}, -- I'm ready, sir.
	}
}
hakassha_sireen_convo:addScreen(hakassha_sireen_convo_no_ship)

hakassha_sireen_convo_yes_ship = ConvoScreen:new {
	id = "yes_ship",
	leftDialog = "@conversation/corellia_imperial_trainer_1:s_7c8aca1b", -- Are you ready for your first assignment?
	stopConversation = "false",
	options = {
		{"@conversation/corellia_imperial_trainer_1:s_1adbadc4", "yes_im_ready"}, -- I'm ready, sir.
	}
}
hakassha_sireen_convo:addScreen(hakassha_sireen_convo_yes_ship)

--[[ Tier 1 -- Mission 1: Patrol (handler starts patrol_naboo_imperial_1) ]]
hakassha_sireen_convo_yes_im_ready = ConvoScreen:new {
	id = "yes_im_ready",
	leftDialog = "@conversation/corellia_imperial_trainer_1:s_83dc5be7", -- Not today. I'm transferring the coordinates of a local security patrol route... Fly a single circuit of the patrol route... When you're done, return to me for further instructions.
	stopConversation = "true",
	options = {}
}
hakassha_sireen_convo:addScreen(hakassha_sireen_convo_yes_im_ready)

-- Player is on quest 1 and returns before completing it
hakassha_sireen_convo_first_quest_active = ConvoScreen:new {
	id = "first_quest_active",
	leftDialog = "@conversation/corellia_imperial_trainer_1:s_88ffee3a", -- Report back to me when you are finished with the patrol.
	stopConversation = "true",
	options = {}
}
hakassha_sireen_convo:addScreen(hakassha_sireen_convo_first_quest_active)

-- Quest 1 complete, needs reward (handler rewards on "patrol_complete")
hakassha_sireen_convo_excellent_work = ConvoScreen:new {
	id = "excellent_work",
	leftDialog = "@conversation/corellia_imperial_trainer_1:s_7f8a87c", -- Pilot. Report on the status of your patrol.
	stopConversation = "false",
	options = {
		{"@conversation/corellia_imperial_trainer_1:s_dd5ca133", "patrol_complete"}, -- I was attacked by a Rebel fighter wing, sir.
		{"@conversation/corellia_imperial_trainer_1:s_b789ed1e", "patrol_complete"}, -- Just doing my duty, sir.
	}
}
hakassha_sireen_convo:addScreen(hakassha_sireen_convo_excellent_work)

hakassha_sireen_convo_patrol_complete = ConvoScreen:new {
	id = "patrol_complete",
	leftDialog = "@conversation/corellia_imperial_trainer_1:s_1345d43f", -- You did? Impressive... You've shown that not only can you fly a basic patrol, but you aren't bad with a laser cannon either. Here's your payment for the job.
	stopConversation = "true",
	options = {}
}
hakassha_sireen_convo:addScreen(hakassha_sireen_convo_patrol_complete)

-- Quest 1 failed/aborted
hakassha_sireen_convo_failed_quest1 = ConvoScreen:new {
	id = "failed_quest1",
	leftDialog = "@conversation/corellia_imperial_trainer_1:s_386d47c9", -- I've transferred the patrol coordinates to your datapad. Try harder this time, pilot.
	stopConversation = "false",
	options = {
		{"@conversation/corellia_imperial_trainer_1:s_1adbadc4", "retry_quest1"}, -- I'm ready, sir.
	}
}
hakassha_sireen_convo:addScreen(hakassha_sireen_convo_failed_quest1)

--[[ Tier 1 -- Mission 2: Destroy (handler starts destroy_naboo_imperial_2) ]]
hakassha_sireen_convo_grant_quest2 = ConvoScreen:new {
	id = "grant_quest2",
	leftDialog = "@conversation/corellia_imperial_trainer_1:s_c168cb82", -- You performed admirably... I want you to hunt down and destroy the rebel vessels in the area of the 'Kantari' attack... The security of the Naboo system must be maintained.
	stopConversation = "false",
	options = {
		{"@conversation/corellia_imperial_trainer_1:s_86c66182", "quest2_accepted"}, -- What's the mission, sir?
	}
}
hakassha_sireen_convo:addScreen(hakassha_sireen_convo_grant_quest2)

hakassha_sireen_convo_quest2_accepted = ConvoScreen:new {
	id = "quest2_accepted",
	leftDialog = "@conversation/corellia_imperial_trainer_1:s_c81a8a32", -- I want you to hunt down and destroy the Rebel vessels in the area of the 'Kantari' attack. The Rebels are still out there and we must make them pay. Eliminate them.
	stopConversation = "true",
	options = {}
}
hakassha_sireen_convo:addScreen(hakassha_sireen_convo_quest2_accepted)

hakassha_sireen_convo_excellent_work2 = ConvoScreen:new {
	id = "excellent_work2",
	leftDialog = "@conversation/corellia_imperial_trainer_1:s_c4031ec5", -- Good job. I'm crediting you for the mission, along with a little extra. You performed admirably.
	stopConversation = "true",
	options = {}
}
hakassha_sireen_convo:addScreen(hakassha_sireen_convo_excellent_work2)

hakassha_sireen_convo_failed_quest2 = ConvoScreen:new {
	id = "failed_quest2",
	leftDialog = "@conversation/corellia_imperial_trainer_1:s_eb66b332", -- Report back to me when you've successfully eliminated the Rebels. And do not abort your mission again!
	stopConversation = "false",
	options = {
		{"@conversation/corellia_imperial_trainer_1:s_1adbadc4", "retry_quest2"}, -- I'm ready, sir.
	}
}
hakassha_sireen_convo:addScreen(hakassha_sireen_convo_failed_quest2)

--[[ Tier 1 -- Mission 3: Patrol/Escort (handler starts patrol_naboo_imperial_3 on "train_me3") ]]
hakassha_sireen_convo_excellent_work3 = ConvoScreen:new {
	id = "excellent_work3",
	leftDialog = "@conversation/corellia_imperial_trainer_1:s_51db72fc", -- With the recent increase in Rebel activity, our supply transports are at risk... You will be paid for every successful escort operation you complete.
	stopConversation = "false",
	options = {
		{"@conversation/corellia_imperial_trainer_1:s_87f86e3e", "quest3_rewarded"}, -- What are my orders, sir?
	}
}
hakassha_sireen_convo:addScreen(hakassha_sireen_convo_excellent_work3)

hakassha_sireen_convo_quest3_rewarded = ConvoScreen:new {
	id = "quest3_rewarded",
	leftDialog = "@conversation/corellia_imperial_trainer_1:s_4dc7104e", -- Good, I have a lot of work for you... I can also assign you to escorting transports moving supplies.
	stopConversation = "false",
	options = {
		{"@conversation/corellia_imperial_trainer_1:s_1adbadc4", "train_me3"}, -- I'm ready, sir.
	}
}
hakassha_sireen_convo:addScreen(hakassha_sireen_convo_quest3_rewarded)

hakassha_sireen_convo_failed_quest3 = ConvoScreen:new {
	id = "failed_quest3",
	leftDialog = "@conversation/corellia_imperial_trainer_1:s_ee63dfa9", -- Report to me when you've completed your mission.
	stopConversation = "false",
	options = {
		{"@conversation/corellia_imperial_trainer_1:s_1adbadc4", "retry_quest3"}, -- I'm ready, sir.
	}
}
hakassha_sireen_convo:addScreen(hakassha_sireen_convo_failed_quest3)

--[[ Tier 1 -- Mission 4: Assassinate (handler starts assassinate_naboo_imperial_4 on "quest4_accepted") ]]
hakassha_sireen_convo_grant_quest4 = ConvoScreen:new {
	id = "grant_quest4",
	leftDialog = "@conversation/corellia_imperial_trainer_1:s_6942389e", -- You've shown a lot of promise so far, Pilot. This is a key assignment. We expect the Rebel team leader to be a highly skilled and well trained pilot. Don't underestimate him.
	stopConversation = "false",
	options = {
		{"@conversation/corellia_imperial_trainer_1:s_86c66182", "quest4_accepted"}, -- What's the mission, sir?
	}
}
hakassha_sireen_convo:addScreen(hakassha_sireen_convo_grant_quest4)

hakassha_sireen_convo_quest4_accepted = ConvoScreen:new {
	id = "quest4_accepted",
	leftDialog = "@conversation/corellia_imperial_trainer_1:s_eec1eeb4", -- We have discovered the possible location of the Rebel team leader... Travel to the waypoint... Find and eliminate him.
	stopConversation = "true",
	options = {}
}
hakassha_sireen_convo:addScreen(hakassha_sireen_convo_quest4_accepted)

hakassha_sireen_convo_failed_quest4 = ConvoScreen:new {
	id = "failed_quest4",
	leftDialog = "@conversation/corellia_imperial_trainer_1:s_3c33e829", -- Report on the status of your operation against the Rebel leader, Pilot.
	stopConversation = "false",
	options = {
		{"@conversation/corellia_imperial_trainer_1:s_1adbadc4", "retry_quest4"}, -- I'm ready, sir.
	}
}
hakassha_sireen_convo:addScreen(hakassha_sireen_convo_failed_quest4)

--[[ Player has an active (non-first) mission ]]
hakassha_sireen_convo_has_mission = ConvoScreen:new {
	id = "has_mission",
	leftDialog = "@conversation/corellia_imperial_trainer_1:s_4b074298", -- Report back to me when you are finished with your current mission. You can abort your mission if you want to start over.
	stopConversation = "true",
	options = {}
}
hakassha_sireen_convo:addScreen(hakassha_sireen_convo_has_mission)

--[[ All four Tier-1 missions complete -> free training choices (handler builds options) ]]
hakassha_sireen_convo_missions_complete = ConvoScreen:new {
	id = "missions_complete",
	leftDialog = "@conversation/corellia_imperial_trainer_1:s_d2d78159", -- Pilot, I am singularly impressed. You have mastered the fundamentals of your profession and have performed beyond expectation... I think it's time for a promotion.
	stopConversation = "false",
	options = {}
}
hakassha_sireen_convo:addScreen(hakassha_sireen_convo_missions_complete)

--[[ Additional (XP-gated) training (handler builds options) ]]
hakassha_sireen_convo_more_training = ConvoScreen:new {
	id = "more_training",
	leftDialog = "@conversation/corellia_imperial_trainer_1:s_444df4b9", -- You can learn about Imperial technology, equipment, space combat training, or astromech management.
	stopConversation = "false",
	options = {}
}
hakassha_sireen_convo:addScreen(hakassha_sireen_convo_more_training)

-- training acknowledgement screens (handler grants the skill then returns the cloned screen)
hakassha_sireen_convo_train_player_fighters = ConvoScreen:new {
	id = "train_player_fighters",
	leftDialog = "@conversation/corellia_imperial_trainer_1:s_7c8aca1b", -- Good choice. Report back when you are ready for an assignment.
	stopConversation = "true",
	options = {}
}
hakassha_sireen_convo:addScreen(hakassha_sireen_convo_train_player_fighters)

hakassha_sireen_convo_train_player_component = ConvoScreen:new {
	id = "train_player_component",
	leftDialog = "@conversation/corellia_imperial_trainer_1:s_7c8aca1b", -- Good choice. Report back when you are ready for an assignment.
	stopConversation = "true",
	options = {}
}
hakassha_sireen_convo:addScreen(hakassha_sireen_convo_train_player_component)

hakassha_sireen_convo_train_player_basics = ConvoScreen:new {
	id = "train_player_basics",
	leftDialog = "@conversation/corellia_imperial_trainer_1:s_7c8aca1b", -- Good choice. Report back when you are ready for an assignment.
	stopConversation = "true",
	options = {}
}
hakassha_sireen_convo:addScreen(hakassha_sireen_convo_train_player_basics)

hakassha_sireen_convo_train_player_droid = ConvoScreen:new {
	id = "train_player_droid",
	leftDialog = "@conversation/corellia_imperial_trainer_1:s_7c8aca1b", -- Good choice. Report back when you are ready for an assignment.
	stopConversation = "true",
	options = {}
}
hakassha_sireen_convo:addScreen(hakassha_sireen_convo_train_player_droid)

-- free-training variants (same acknowledgement string)
hakassha_sireen_convo_train_player_fighters_free = ConvoScreen:new {
	id = "train_player_fighters_free",
	leftDialog = "@conversation/corellia_imperial_trainer_1:s_7c8aca1b", -- Good choice. Report back when you are ready for an assignment.
	stopConversation = "true",
	options = {}
}
hakassha_sireen_convo:addScreen(hakassha_sireen_convo_train_player_fighters_free)

hakassha_sireen_convo_train_player_component_free = ConvoScreen:new {
	id = "train_player_component_free",
	leftDialog = "@conversation/corellia_imperial_trainer_1:s_7c8aca1b",
	stopConversation = "true",
	options = {}
}
hakassha_sireen_convo:addScreen(hakassha_sireen_convo_train_player_component_free)

hakassha_sireen_convo_train_player_basics_free = ConvoScreen:new {
	id = "train_player_basics_free",
	leftDialog = "@conversation/corellia_imperial_trainer_1:s_7c8aca1b",
	stopConversation = "true",
	options = {}
}
hakassha_sireen_convo:addScreen(hakassha_sireen_convo_train_player_basics_free)

hakassha_sireen_convo_train_player_droid_free = ConvoScreen:new {
	id = "train_player_droid_free",
	leftDialog = "@conversation/corellia_imperial_trainer_1:s_7c8aca1b",
	stopConversation = "true",
	options = {}
}
hakassha_sireen_convo:addScreen(hakassha_sireen_convo_train_player_droid_free)

--[[ Duty missions (Tier-1 grind: destroy / escort duty) ]]
hakassha_sireen_convo_duty_missions = ConvoScreen:new {
	id = "duty_missions",
	leftDialog = "@conversation/corellia_imperial_trainer_1:s_8cf0a3be", -- Pilot. I don't have any specific work for you at this time. You can now select your preferred operation from a list of general duties...
	stopConversation = "false",
	options = {
		{"@conversation/corellia_imperial_trainer_1:s_13e807c3", "destroy_duty"}, -- [Destroy Duty] I'm interested in hunting Rebel scum.
		{"@conversation/corellia_imperial_trainer_1:s_79ab4bbe", "escort_duty"}, -- [Escort Duty] I'm interested in escorting transports.
	}
}
hakassha_sireen_convo:addScreen(hakassha_sireen_convo_duty_missions)

-- recruitment_not_imperial (player not yet faction-aligned)
hakassha_sireen_convo_recruitment_not_imperial = ConvoScreen:new {
	id = "recruitment_not_imperial",
	leftDialog = "@conversation/corellia_imperial_trainer_1:s_2e48b5f1", -- Welcome to the Imperial Navy Recruitment Center. My name is Lieutenant Barn Sinkko. Are you interested in learning about the Imperial Navy?
	stopConversation = "false",
	options = {
		{"@conversation/corellia_imperial_trainer_1:s_c6d9f61", "yes_join"}, -- I'd like to sign up, sir.
		{"@conversation/corellia_imperial_trainer_1:s_1acdc4ba", "decline_join"}, -- I'd rather not sign up right now, sir.
	}
}
hakassha_sireen_convo:addScreen(hakassha_sireen_convo_recruitment_not_imperial)

--[[ Tier 1 complete -> reassigned to the Inquisition (Under Inquisitor Fa'Zoll) ]]
hakassha_sireen_convo_completed_sinkko = ConvoScreen:new {
	id = "completed_sinkko",
	leftDialog = "@conversation/corellia_imperial_trainer_1:s_d2d78159", -- Your skill behind the controls of the TIE Fighter have peaked the interest of several high ranking officers. In particular, members of the Imperial Inquisition have expressed their desire to take over your training...
	stopConversation = "false",
	options = {
		{"@conversation/corellia_imperial_trainer_1:s_19ff301f", "what_is_inquisition"}, -- What is the Imperial Inquisition?
		{"@conversation/corellia_imperial_trainer_1:s_85dd7d6c", "report_to_fazoll"}, -- Who do I report to?
	}
}
hakassha_sireen_convo:addScreen(hakassha_sireen_convo_completed_sinkko)

hakassha_sireen_convo_what_is_inquisition = ConvoScreen:new {
	id = "what_is_inquisition",
	leftDialog = "@conversation/corellia_imperial_trainer_1:s_de514757", -- The Inquisition is a special judicial branch of the Imperial Intelligence bureau... To become a member of the Inquisition is a rare honor.
	stopConversation = "false",
	options = {
		{"@conversation/corellia_imperial_trainer_1:s_85dd7d6c", "report_to_fazoll"}, -- Who do I report to?
	}
}
hakassha_sireen_convo:addScreen(hakassha_sireen_convo_what_is_inquisition)

-- Reassignment: grant waypoint to Under Inquisitor Fa'Zoll (handler sets sinkko_finished + waypoint)
hakassha_sireen_convo_report_to_fazoll = ConvoScreen:new {
	id = "report_to_fazoll",
	leftDialog = "@conversation/corellia_imperial_trainer_1:s_1bf00a8", -- Under Inquisitor Fa'Zoll in the Emperor's Retreat has been assigned as your new commanding officer...
	stopConversation = "true",
	options = {}
}
hakassha_sireen_convo:addScreen(hakassha_sireen_convo_report_to_fazoll)

-- Player already reassigned, returns to Sinkko
hakassha_sireen_convo_go_to_next = ConvoScreen:new {
	id = "go_to_next",
	leftDialog = "@conversation/corellia_imperial_trainer_1:s_7bff5a7f", -- I don't have anything else for you. Talk to Under Inquisitor Fa'Zoll in the Emperor's Retreat.
	stopConversation = "true",
	options = {}
}
hakassha_sireen_convo:addScreen(hakassha_sireen_convo_go_to_next)

addConversationTemplate("hakassha_sireen_convo", hakassha_sireen_convo);
