--[[
	Da'la Socuna -- Crimson Phoenix Squadron (Rebel) Tier 1 recruiter/trainer conversation.

	Structural port of the proven Inquisition recruiter template, driven by the
	authentic Live Rebel trainer string file extracted from the client TRE:
		string/en/conversation/tatooine_rebel_trainer_1.stf
	Every leftDialog / option below references a real @conversation/tatooine_rebel_trainer_1:s_<hash>
	string from that table (English text shown verbatim in the trailing comment, verified against
	the extracted STF). Screen-flow control lives in daLaSocunaConvoHandler.lua.

	Quest ladder follows the real Rebel storyline told by the STF:
		Q1 patrol (four-point sensor sweep of a compromised Alliance supply route) ->
		Q2 destroy (take out at least four Imperial TIE fighters) ->
		Q3 strike (hit the TIE wing moving onto the supply route before the Empire realizes
		their fleet info is compromised) ->
		Q4 assassinate (the veteran TIE fighter pilot leading the Imperial activity) ->
		training -> report to Major Eker on Yavin 4.

	Every option link target below is a defined screen (the base conv_handler falls back to
	the initial screen when a link target is missing, which presents as "clicking does nothing").
]]

da_la_socuna_convo = ConvoTemplate:new {
	initialScreen = "",
	templateType = "Lua",
	luaClassHandler = "daLaSocunaConvoHandler",
	screens = {}
}

-- JTL Disabled / No Space Expansion
da_la_socuna_convo_no_jtl = ConvoScreen:new {
	id = "no_jtl",
	leftDialog = "@conversation/tatooine_rebel_trainer_1:s_1d3d8b65", -- You don't look like any sort of pilot to me.  I can't help you.
	stopConversation = "true",
	options = {}
}
da_la_socuna_convo:addScreen(da_la_socuna_convo_no_jtl)

-- Imperial Pilot (opposing faction, turned away)
da_la_socuna_convo_imperial_pilot = ConvoScreen:new {
	id = "imperial_pilot",
	leftDialog = "@conversation/tatooine_rebel_trainer_1:s_d6c8f764", -- Heh. What do you know. An Imperial. Get out of here while you still can!
	stopConversation = "true",
	animation = "point_accusingly",
	options = {}
}
da_la_socuna_convo:addScreen(da_la_socuna_convo_imperial_pilot)

-- Neutral/Privateer Pilot (turned away)
da_la_socuna_convo_neutral_pilot = ConvoScreen:new {
	id = "neutral_pilot",
	leftDialog = "@conversation/tatooine_rebel_trainer_1:s_19d3ee2b", -- I can't help you, smuggler. Try sniffing around Wayfar... you'll find something that suits you.
	stopConversation = "true",
	animation = "shrug_shoulders",
	options = {}
}
da_la_socuna_convo:addScreen(da_la_socuna_convo_neutral_pilot)

-- Rebel pilot, different squadron
da_la_socuna_convo_non_inquisition_pilot = ConvoScreen:new {
	id = "non_inquisition_pilot",
	leftDialog = "@conversation/tatooine_rebel_trainer_1:s_57c3f83e", -- Always good to see another Rebel pilot... but you're not one of my recruits. What can I do for you?
	stopConversation = "false",
	options = {
		{"@conversation/tatooine_rebel_trainer_1:s_1583743c", "duty_missions"}, -- Do you have any missions I could fly?
	}
}
da_la_socuna_convo:addScreen(da_la_socuna_convo_non_inquisition_pilot)

--[[ Recruitment flow ]]
da_la_socuna_convo_recruitment = ConvoScreen:new {
	id = "recruitment",
	leftDialog = "@conversation/tatooine_rebel_trainer_1:s_1622e456", -- Good to meet you. My name is Da'la Socuna and I am here on behalf of the Rebel Alliance naval forces. I train pilots to fly and fight.
	stopConversation = "false",
	options = {
		{"@conversation/tatooine_rebel_trainer_1:s_705f0112", "yes_join"}, -- Train me to fly for the Alliance.
		{"@conversation/tatooine_rebel_trainer_1:s_3f5c320e", "why_volunteers"}, -- I know of the rebellion. I want to help!
		{"@conversation/tatooine_rebel_trainer_1:s_6e646769", "decline_join"}, -- No, thanks.
	}
}
da_la_socuna_convo:addScreen(da_la_socuna_convo_recruitment)

da_la_socuna_convo_why_volunteers = ConvoScreen:new {
	id = "why_volunteers",
	leftDialog = "@conversation/tatooine_rebel_trainer_1:s_790724e4", -- Then it is fortunate that we have met. I can induct you to the Alliance pilot training program immediately.
	stopConversation = "false",
	options = {
		{"@conversation/tatooine_rebel_trainer_1:s_705f0112", "yes_join"}, -- Train me to fly for the Alliance.
		{"@conversation/tatooine_rebel_trainer_1:s_6e646769", "decline_join"}, -- No, thanks.
	}
}
da_la_socuna_convo:addScreen(da_la_socuna_convo_why_volunteers)

da_la_socuna_convo_decline_join = ConvoScreen:new {
	id = "decline_join",
	leftDialog = "@conversation/tatooine_rebel_trainer_1:s_1c2f3f24", -- The Force be with you, then...
	stopConversation = "true",
	animation = "goodbye",
	options = {}
}
da_la_socuna_convo:addScreen(da_la_socuna_convo_decline_join)

-- Player asked to join; the handler redirects this to "join_confirm". Defined with the
-- same content as join_confirm so the flow is intact even without the handler redirect.
da_la_socuna_convo_yes_join = ConvoScreen:new {
	id = "yes_join",
	leftDialog = "@conversation/tatooine_rebel_trainer_1:s_8da0fa08", -- Are you sure about that, %NU?  We could officially put your name on the roster, but even if you remain Covert, there's always a chance of an Imperial uncovering you.
	stopConversation = "false",
	options = {
		{"@conversation/tatooine_rebel_trainer_1:s_7ed5fec3", "yes_i_am"}, -- I want to be part of the Alliance.
		{"@conversation/tatooine_rebel_trainer_1:s_d01d0154", "decline_join"}, -- No, never mind.
	}
}
da_la_socuna_convo:addScreen(da_la_socuna_convo_yes_join)

-- Sign-up confirmation (handler routes "yes_join" here)
da_la_socuna_convo_join_confirm = ConvoScreen:new {
	id = "join_confirm",
	leftDialog = "@conversation/tatooine_rebel_trainer_1:s_8da0fa08", -- Are you sure about that, %NU?  We could officially put your name on the roster, but even if you remain Covert, there's always a chance of an Imperial uncovering you.
	stopConversation = "false",
	options = {
		{"@conversation/tatooine_rebel_trainer_1:s_7ed5fec3", "yes_i_am"}, -- I want to be part of the Alliance.
		{"@conversation/tatooine_rebel_trainer_1:s_d01d0154", "decline_join"}, -- No, never mind.
	}
}
da_la_socuna_convo:addScreen(da_la_socuna_convo_join_confirm)

-- Enlistment/welcome (handler grants novice box + squadron + tier here, then adds the ship option)
da_la_socuna_convo_yes_i_am = ConvoScreen:new {
	id = "yes_i_am",
	leftDialog = "@conversation/tatooine_rebel_trainer_1:s_7d2cd92d", -- Then it is my pleasure to welcome you to the Alliance space navy.
	stopConversation = "false",
	options = {}
}
da_la_socuna_convo:addScreen(da_la_socuna_convo_yes_i_am)

-- No Ship - grants ship
da_la_socuna_convo_no_ship = ConvoScreen:new {
	id = "no_ship",
	leftDialog = "@conversation/tatooine_rebel_trainer_1:s_19ec1fce", -- Just how exactly do you expect to be a Rebel Alliance pilot without a ship?  Here.  I'll add these access codes for a small fighter to your datapad.  You ought to upgrade to a better ship pretty soon, though.
	stopConversation = "false",
	animation = "nod_head_multiple",
	options = {
		{"@conversation/tatooine_rebel_trainer_1:s_b3e9c738", "yes_im_ready"}, -- I'm ready for anything.
	}
}
da_la_socuna_convo:addScreen(da_la_socuna_convo_no_ship)

da_la_socuna_convo_yes_ship = ConvoScreen:new {
	id = "yes_ship",
	leftDialog = "@conversation/tatooine_rebel_trainer_1:s_b3408be1", -- Are you ready for your first assignment?
	stopConversation = "false",
	options = {
		{"@conversation/tatooine_rebel_trainer_1:s_b3e9c738", "yes_im_ready"}, -- I'm ready for anything.
	}
}
da_la_socuna_convo:addScreen(da_la_socuna_convo_yes_ship)

--[[ Tier 1 -- Mission 1: Patrol (handler starts patrol_tatooine_rebel_1) ]]
da_la_socuna_convo_yes_im_ready = ConvoScreen:new {
	id = "yes_im_ready",
	leftDialog = "@conversation/tatooine_rebel_trainer_1:s_8720792f", -- You will fly a four-point patrol above Tatooine. We will need your ship's sensor data when you are finished. Stay hidden... sorry to say, I have a bad feeling about this one.
	stopConversation = "true",
	options = {}
}
da_la_socuna_convo:addScreen(da_la_socuna_convo_yes_im_ready)

-- Player is on quest 1 and returns before completing it
da_la_socuna_convo_first_quest_active = ConvoScreen:new {
	id = "first_quest_active",
	leftDialog = "@conversation/tatooine_rebel_trainer_1:s_d89a93ff", -- %TU, you're too impatient.  Right now I need you to scout that supply route.  We'll talk about training later.
	stopConversation = "true",
	options = {}
}
da_la_socuna_convo:addScreen(da_la_socuna_convo_first_quest_active)

-- Quest 1 complete, player reports in (handler rewards on "patrol_complete")
da_la_socuna_convo_excellent_work = ConvoScreen:new {
	id = "excellent_work",
	leftDialog = "@conversation/tatooine_rebel_trainer_1:s_2c052357", -- Good to see you again, pilot! I will hear your report, now.
	stopConversation = "false",
	options = {
		{"@conversation/tatooine_rebel_trainer_1:s_11327023", "patrol_complete"}, -- The patrol was interrupted by a TIE attack.
		{"@conversation/tatooine_rebel_trainer_1:s_ce2c09ec", "patrol_complete"}, -- Mission accomplished, ma'am!
	}
}
da_la_socuna_convo:addScreen(da_la_socuna_convo_excellent_work)

da_la_socuna_convo_patrol_complete = ConvoScreen:new {
	id = "patrol_complete",
	leftDialog = "@conversation/tatooine_rebel_trainer_1:s_16949037", -- Outstanding work, pilot! Get some rest. Check back with me later for a new assignment.  Also, I've got something extra for you.
	stopConversation = "true",
	options = {}
}
da_la_socuna_convo:addScreen(da_la_socuna_convo_patrol_complete)

-- Quest 1 failed/aborted
da_la_socuna_convo_failed_quest1 = ConvoScreen:new {
	id = "failed_quest1",
	leftDialog = "@conversation/tatooine_rebel_trainer_1:s_aadc4812", -- Well, I'll admit that I didn't prep you for a TIE fighter attack. How do you think you'll fare on your second try?
	stopConversation = "false",
	options = {
		{"@conversation/tatooine_rebel_trainer_1:s_b3e9c738", "retry_quest1"}, -- I'm ready for anything.
	}
}
da_la_socuna_convo:addScreen(da_la_socuna_convo_failed_quest1)

-- Quest 1 retry acknowledged (handler restarts patrol_tatooine_rebel_1)
da_la_socuna_convo_retry_quest1 = ConvoScreen:new {
	id = "retry_quest1",
	leftDialog = "@conversation/tatooine_rebel_trainer_1:s_cc82ca6b", -- Good! Your orders have been renewed. Good luck, pilot!
	stopConversation = "true",
	options = {}
}
da_la_socuna_convo:addScreen(da_la_socuna_convo_retry_quest1)

--[[ Tier 1 -- Mission 2: Destroy (handler starts destroy_tatooine_rebel_3 on "quest2_accepted") ]]
da_la_socuna_convo_grant_quest2 = ConvoScreen:new {
	id = "grant_quest2",
	leftDialog = "@conversation/tatooine_rebel_trainer_1:s_406f8d3e", -- It will take a bit to decode your ship sensor data. In the meantime, we have another assignment for you... if you are ready.
	stopConversation = "false",
	options = {
		{"@conversation/tatooine_rebel_trainer_1:s_bac616e6", "quest2_accepted"}, -- I'm ready for my next mission!
	}
}
da_la_socuna_convo:addScreen(da_la_socuna_convo_grant_quest2)

da_la_socuna_convo_quest2_accepted = ConvoScreen:new {
	id = "quest2_accepted",
	leftDialog = "@conversation/tatooine_rebel_trainer_1:s_8001a590", -- Outstanding! Find any Imperial TIE Fighters in the Tatooine system and take out at least four of them.
	stopConversation = "true",
	options = {}
}
da_la_socuna_convo:addScreen(da_la_socuna_convo_quest2_accepted)

-- Mission 2 report
da_la_socuna_convo_quest2_report = ConvoScreen:new {
	id = "quest2_report",
	leftDialog = "@conversation/tatooine_rebel_trainer_1:s_1f0828c5", -- Report mission status!
	stopConversation = "false",
	options = {
		{"@conversation/tatooine_rebel_trainer_1:s_6a7a0499", "quest2_best"}, -- I got more TIE Fighters than you did on your first mission!
	}
}
da_la_socuna_convo:addScreen(da_la_socuna_convo_quest2_report)

da_la_socuna_convo_quest2_best = ConvoScreen:new {
	id = "quest2_best",
	leftDialog = "@conversation/tatooine_rebel_trainer_1:s_1500b5d6", -- Are you saying that my pilots are not the BEST pilots in the entire Alliance?
	stopConversation = "false",
	options = {
		{"@conversation/tatooine_rebel_trainer_1:s_2ea6d944", "quest2_report_complete"}, -- Really?
	}
}
da_la_socuna_convo:addScreen(da_la_socuna_convo_quest2_best)

da_la_socuna_convo_quest2_report_complete = ConvoScreen:new {
	id = "quest2_report_complete",
	leftDialog = "@conversation/tatooine_rebel_trainer_1:s_4c695dbd", -- No.
	stopConversation = "true",
	options = {}
}
da_la_socuna_convo:addScreen(da_la_socuna_convo_quest2_report_complete)

-- Quest 2 rewarded; leads into Mission 3 (scout and escort the supply convoy)
da_la_socuna_convo_excellent_work2 = ConvoScreen:new {
	id = "excellent_work2",
	leftDialog = "@conversation/tatooine_rebel_trainer_1:s_bda1eb17", -- Your ship sensor data has been completely decoded. The Alliance supply route is entirely compromised. We need you to scout a new route for our in-system supply convoy. Are you up to it?
	stopConversation = "false",
	options = {
		{"@conversation/tatooine_rebel_trainer_1:s_74474b33", "train_me3"}, -- What is our next move, ma'am?
		{"@conversation/tatooine_rebel_trainer_1:s_b3e9c738", "train_me3"}, -- I'm ready for anything.
	}
}
da_la_socuna_convo:addScreen(da_la_socuna_convo_excellent_work2)

-- Mission 3 accepted (handler starts patrol_tatooine_rebel_2 on "train_me3")
da_la_socuna_convo_train_me3 = ConvoScreen:new {
	id = "train_me3",
	leftDialog = "@conversation/tatooine_rebel_trainer_1:s_7077f9f7", -- Outstanding!
	stopConversation = "true",
	options = {}
}
da_la_socuna_convo:addScreen(da_la_socuna_convo_train_me3)

da_la_socuna_convo_failed_quest2 = ConvoScreen:new {
	id = "failed_quest2",
	leftDialog = "@conversation/tatooine_rebel_trainer_1:s_f7ebcc5f", -- Will you fail a second time if I re-assign the mission to you?
	stopConversation = "false",
	options = {
		{"@conversation/tatooine_rebel_trainer_1:s_968c130f", "retry_quest2"}, -- No. I will not!
	}
}
da_la_socuna_convo:addScreen(da_la_socuna_convo_failed_quest2)

-- Quest 2 retry acknowledged (handler restarts destroy_tatooine_rebel_3)
da_la_socuna_convo_retry_quest2 = ConvoScreen:new {
	id = "retry_quest2",
	leftDialog = "@conversation/tatooine_rebel_trainer_1:s_cc82ca6b", -- Good! Your orders have been renewed. Good luck, pilot!
	stopConversation = "true",
	options = {}
}
da_la_socuna_convo:addScreen(da_la_socuna_convo_retry_quest2)

--[[ Tier 1 -- Mission 3 report (handler grants the reward on "quest3_rewarded") ]]
da_la_socuna_convo_excellent_work3 = ConvoScreen:new {
	id = "excellent_work3",
	leftDialog = "@conversation/tatooine_rebel_trainer_1:s_1f0828c5", -- Report mission status!
	stopConversation = "false",
	options = {
		{"@conversation/tatooine_rebel_trainer_1:s_6d7d5f1b", "quest3_rewarded"}, -- All targets eliminated, ma'am!
		{"@conversation/tatooine_rebel_trainer_1:s_ce2c09ec", "quest3_rewarded"}, -- Mission accomplished, ma'am!
	}
}
da_la_socuna_convo:addScreen(da_la_socuna_convo_excellent_work3)

da_la_socuna_convo_quest3_rewarded = ConvoScreen:new {
	id = "quest3_rewarded",
	leftDialog = "@conversation/tatooine_rebel_trainer_1:s_2da98563", -- Great work! Now, get some rest and check back with me later. I will have more for you to do.
	stopConversation = "true",
	options = {}
}
da_la_socuna_convo:addScreen(da_la_socuna_convo_quest3_rewarded)

da_la_socuna_convo_failed_quest3 = ConvoScreen:new {
	id = "failed_quest3",
	leftDialog = "@conversation/tatooine_rebel_trainer_1:s_f7ebcc5f", -- Will you fail a second time if I re-assign the mission to you?
	stopConversation = "false",
	options = {
		{"@conversation/tatooine_rebel_trainer_1:s_968c130f", "retry_quest3"}, -- No. I will not!
	}
}
da_la_socuna_convo:addScreen(da_la_socuna_convo_failed_quest3)

-- Quest 3 retry acknowledged (handler restarts patrol_tatooine_rebel_2)
da_la_socuna_convo_retry_quest3 = ConvoScreen:new {
	id = "retry_quest3",
	leftDialog = "@conversation/tatooine_rebel_trainer_1:s_cc82ca6b", -- Good! Your orders have been renewed. Good luck, pilot!
	stopConversation = "true",
	options = {}
}
da_la_socuna_convo:addScreen(da_la_socuna_convo_retry_quest3)

--[[ Tier 1 -- Mission 4: Assassinate the veteran TIE pilot (handler starts assassinate_tatooine_rebel_4 on "quest4_accepted") ]]
da_la_socuna_convo_grant_quest4 = ConvoScreen:new {
	id = "grant_quest4",
	leftDialog = "@conversation/tatooine_rebel_trainer_1:s_ae1edd02", -- While you were away we gathered enough information to put the Imperial fleet movement out of commission. Are you ready to take flight again?
	stopConversation = "false",
	options = {
		{"@conversation/tatooine_rebel_trainer_1:s_6bb935f1", "quest4_accepted"}, -- Yes, Da'la. I am ready.
	}
}
da_la_socuna_convo:addScreen(da_la_socuna_convo_grant_quest4)

da_la_socuna_convo_quest4_accepted = ConvoScreen:new {
	id = "quest4_accepted",
	leftDialog = "@conversation/tatooine_rebel_trainer_1:s_a20f8416", -- The recent Imperial activity is being led by a veteran TIE fighter pilot. We know of his location. Fly to the nav point, and eliminate this pilot with extreme prejudice.
	stopConversation = "true",
	options = {}
}
da_la_socuna_convo:addScreen(da_la_socuna_convo_quest4_accepted)

da_la_socuna_convo_failed_quest4 = ConvoScreen:new {
	id = "failed_quest4",
	leftDialog = "@conversation/tatooine_rebel_trainer_1:s_2f8ec5d4", -- Report on the TIE veteran target!
	stopConversation = "false",
	options = {
		{"@conversation/tatooine_rebel_trainer_1:s_877e028c", "retry_quest4"}, -- Ma'am! I want another chance, ma'am!
	}
}
da_la_socuna_convo:addScreen(da_la_socuna_convo_failed_quest4)

-- Quest 4 retry acknowledged (handler restarts assassinate_tatooine_rebel_4)
da_la_socuna_convo_retry_quest4 = ConvoScreen:new {
	id = "retry_quest4",
	leftDialog = "@conversation/tatooine_rebel_trainer_1:s_cc82ca6b", -- Good! Your orders have been renewed. Good luck, pilot!
	stopConversation = "true",
	options = {}
}
da_la_socuna_convo:addScreen(da_la_socuna_convo_retry_quest4)

--[[ Player has an active (non-first) mission ]]
da_la_socuna_convo_has_mission = ConvoScreen:new {
	id = "has_mission",
	leftDialog = "@conversation/tatooine_rebel_trainer_1:s_e31d65b7", -- The duty logs indicate that you are in mid-mission. We have nothing to discuss until you are finished.
	stopConversation = "true",
	options = {}
}
da_la_socuna_convo:addScreen(da_la_socuna_convo_has_mission)

--[[ All four Tier-1 missions complete -> free training choices (handler builds options) ]]
da_la_socuna_convo_missions_complete = ConvoScreen:new {
	id = "missions_complete",
	leftDialog = "@conversation/tatooine_rebel_trainer_1:s_6221bd32", -- Congratulations, pilot. Our immediate goals have been met. We have time for training. What areas of Alliance piloting interest you the most?
	stopConversation = "false",
	options = {}
}
da_la_socuna_convo:addScreen(da_la_socuna_convo_missions_complete)

--[[ Additional (XP-gated) training (handler builds options) ]]
da_la_socuna_convo_more_training = ConvoScreen:new {
	id = "more_training",
	leftDialog = "@conversation/tatooine_rebel_trainer_1:s_2c8ee9d", -- There is more I have to teach you, pilot. What areas interest you at the moment?
	stopConversation = "false",
	options = {}
}
da_la_socuna_convo:addScreen(da_la_socuna_convo_more_training)

-- training acknowledgement screens (handler grants the skill then returns the cloned screen)
da_la_socuna_convo_train_player_fighters = ConvoScreen:new {
	id = "train_player_fighters",
	leftDialog = "@conversation/tatooine_rebel_trainer_1:s_c7afc225", -- Let's upgrade your starship license then, shall we?
	stopConversation = "true",
	options = {}
}
da_la_socuna_convo:addScreen(da_la_socuna_convo_train_player_fighters)

da_la_socuna_convo_train_player_component = ConvoScreen:new {
	id = "train_player_component",
	leftDialog = "@conversation/tatooine_rebel_trainer_1:s_d5bc59d9", -- I have adjusted your pilot certification to handle more intricate components.
	stopConversation = "true",
	options = {}
}
da_la_socuna_convo:addScreen(da_la_socuna_convo_train_player_component)

da_la_socuna_convo_train_player_basics = ConvoScreen:new {
	id = "train_player_basics",
	leftDialog = "@conversation/tatooine_rebel_trainer_1:s_96e50d8", -- Here is an update to your procedures manual.
	stopConversation = "true",
	options = {}
}
da_la_socuna_convo:addScreen(da_la_socuna_convo_train_player_basics)

da_la_socuna_convo_train_player_droid = ConvoScreen:new {
	id = "train_player_droid",
	leftDialog = "@conversation/tatooine_rebel_trainer_1:s_c93f1cdc", -- Here are some new droid programs. Use them wisely.
	stopConversation = "true",
	options = {}
}
da_la_socuna_convo:addScreen(da_la_socuna_convo_train_player_droid)

-- free-training variants (same acknowledgement strings)
da_la_socuna_convo_train_player_fighters_free = ConvoScreen:new {
	id = "train_player_fighters_free",
	leftDialog = "@conversation/tatooine_rebel_trainer_1:s_c7afc225", -- Let's upgrade your starship license then, shall we?
	stopConversation = "true",
	options = {}
}
da_la_socuna_convo:addScreen(da_la_socuna_convo_train_player_fighters_free)

da_la_socuna_convo_train_player_component_free = ConvoScreen:new {
	id = "train_player_component_free",
	leftDialog = "@conversation/tatooine_rebel_trainer_1:s_d5bc59d9", -- I have adjusted your pilot certification to handle more intricate components.
	stopConversation = "true",
	options = {}
}
da_la_socuna_convo:addScreen(da_la_socuna_convo_train_player_component_free)

da_la_socuna_convo_train_player_basics_free = ConvoScreen:new {
	id = "train_player_basics_free",
	leftDialog = "@conversation/tatooine_rebel_trainer_1:s_96e50d8", -- Here is an update to your procedures manual.
	stopConversation = "true",
	options = {}
}
da_la_socuna_convo:addScreen(da_la_socuna_convo_train_player_basics_free)

da_la_socuna_convo_train_player_droid_free = ConvoScreen:new {
	id = "train_player_droid_free",
	leftDialog = "@conversation/tatooine_rebel_trainer_1:s_c93f1cdc", -- Here are some new droid programs. Use them wisely.
	stopConversation = "true",
	options = {}
}
da_la_socuna_convo:addScreen(da_la_socuna_convo_train_player_droid_free)

--[[ Duty missions (Tier-1 grind: destroy / escort duty) ]]
da_la_socuna_convo_duty_missions = ConvoScreen:new {
	id = "duty_missions",
	leftDialog = "@conversation/tatooine_rebel_trainer_1:s_c5ac7e76", -- I don't have any pressing assignments right now, but I do have some elective duty missions if you're interested?
	stopConversation = "false",
	options = {
		{"@conversation/tatooine_rebel_trainer_1:s_7a27e11", "destroy_duty"}, -- I'll blast any Imperial crosses my path!
		{"@conversation/tatooine_rebel_trainer_1:s_2cb7683a", "escort_duty"}, -- I feel our transports need escort...
		{"@conversation/tatooine_rebel_trainer_1:s_6106187c", "what_is_duty"}, -- What is a duty mission?
	}
}
da_la_socuna_convo:addScreen(da_la_socuna_convo_duty_missions)

da_la_socuna_convo_what_is_duty = ConvoScreen:new {
	id = "what_is_duty",
	leftDialog = "@conversation/tatooine_rebel_trainer_1:s_cb60fa8", -- A duty mission is a good way to earn experience. Especially for a pilot looking for training like yourself. Duty missions have no real end. You just finish when you finish, know what I mean? So what do you say?
	stopConversation = "false",
	options = {
		{"@conversation/tatooine_rebel_trainer_1:s_7a27e11", "destroy_duty"}, -- I'll blast any Imperial crosses my path!
		{"@conversation/tatooine_rebel_trainer_1:s_2cb7683a", "escort_duty"}, -- I feel our transports need escort...
	}
}
da_la_socuna_convo:addScreen(da_la_socuna_convo_what_is_duty)

-- Duty accepted (handler starts destroy_duty_tatooine_rebel_6)
da_la_socuna_convo_destroy_duty = ConvoScreen:new {
	id = "destroy_duty",
	leftDialog = "@conversation/tatooine_rebel_trainer_1:s_cd1af2b9", -- Outstanding! Good luck, pilot!
	stopConversation = "true",
	options = {}
}
da_la_socuna_convo:addScreen(da_la_socuna_convo_destroy_duty)

-- Duty accepted (handler starts escort_duty_tatooine_rebel_7)
da_la_socuna_convo_escort_duty = ConvoScreen:new {
	id = "escort_duty",
	leftDialog = "@conversation/tatooine_rebel_trainer_1:s_d6e44b20", -- You're right. The Alliance is attempting to move a large number of refugees out of Tatooine space. Protect as many of them as you can. These 'duty' missions have been prepared for you to gain some much needed space combat experience. You can return to the ground at any time when you feel that you have learned enough.
	stopConversation = "true",
	options = {}
}
da_la_socuna_convo:addScreen(da_la_socuna_convo_escort_duty)

-- recruitment_not_imperial (player is not yet aligned with the Rebel faction)
da_la_socuna_convo_recruitment_not_imperial = ConvoScreen:new {
	id = "recruitment_not_imperial",
	leftDialog = "@conversation/tatooine_rebel_trainer_1:s_33e1f5f2", -- Your kindness is radiant, my friend. We could really use someone like you in our organization. Are you willing to place your trust in the Rebel Alliance?
	stopConversation = "false",
	options = {
		{"@conversation/tatooine_rebel_trainer_1:s_8234fa32", "yes_join"}, -- Yes... I am willing. Yes.
		{"@conversation/tatooine_rebel_trainer_1:s_6e646769", "decline_join"}, -- No, thanks.
	}
}
da_la_socuna_convo:addScreen(da_la_socuna_convo_recruitment_not_imperial)

--[[ Tier 1 complete -> reassigned to Major Eker on Yavin 4 ]]
da_la_socuna_convo_completed_sinkko = ConvoScreen:new {
	id = "completed_sinkko",
	leftDialog = "@conversation/tatooine_rebel_trainer_1:s_63642f8", -- It appears that our time together has come to an end, pilot. Alliance HQ wants you reallocated to special operations on Yavin 4 and placed under the command of Major Eker... immediately.
	stopConversation = "false",
	options = {
		{"@conversation/tatooine_rebel_trainer_1:s_6f3e992", "what_is_inquisition"}, -- What can you tell me of Major Eker?
		{"@conversation/tatooine_rebel_trainer_1:s_b3bebc5e", "report_to_fazoll"}, -- How do I get there?
	}
}
da_la_socuna_convo:addScreen(da_la_socuna_convo_completed_sinkko)

da_la_socuna_convo_what_is_inquisition = ConvoScreen:new {
	id = "what_is_inquisition",
	leftDialog = "@conversation/tatooine_rebel_trainer_1:s_855c7780", -- I've heard that Eker was a decorated Imperial pilot and leader of a vicious TIE squadron for several years... until he sickened of their tactics. I believe he defected after being ordered to fire on an unarmed medical transport.
	stopConversation = "false",
	options = {
		{"@conversation/tatooine_rebel_trainer_1:s_b3bebc5e", "report_to_fazoll"}, -- How do I get there?
	}
}
da_la_socuna_convo:addScreen(da_la_socuna_convo_what_is_inquisition)

-- Reassignment: grant waypoint to Major Eker on Yavin 4 (handler sets socuna_finished + waypoint)
da_la_socuna_convo_report_to_fazoll = ConvoScreen:new {
	id = "report_to_fazoll",
	leftDialog = "@conversation/tatooine_rebel_trainer_1:s_2b43e56e", -- Good luck to you, pilot! The Major is currently located at the labor outpost on the moon Yavin 4. Hope to see you again when this war is over...
	stopConversation = "true",
	options = {}
}
da_la_socuna_convo:addScreen(da_la_socuna_convo_report_to_fazoll)

-- Player already reassigned, returns to Da'la Socuna
da_la_socuna_convo_go_to_next = ConvoScreen:new {
	id = "go_to_next",
	leftDialog = "@conversation/tatooine_rebel_trainer_1:s_2e56f341", -- You're not supposed to be here, pilot. You're assigned to Major Eker's group on Yavin 4.
	stopConversation = "true",
	options = {}
}
da_la_socuna_convo:addScreen(da_la_socuna_convo_go_to_next)


--[[
	Major Eker Tier 2 screens using string/en/conversation/yavin_rebel_trainer_2.stf
]]

-- New tier 2 pilot introduction
da_la_socuna_convo_tier2_introduction = ConvoScreen:new {
	id = "tier2_introduction",
	leftDialog = "@conversation/yavin_rebel_trainer_2:s_928a5ee3",
	stopConversation = "false",
	options = {
		{"@conversation/yavin_rebel_trainer_2:s_6a1c47d9", "tier2_intro_accept"},
	}
}
da_la_socuna_convo:addScreen(da_la_socuna_convo_tier2_introduction)

-- Introduction accepted (handler sets tier2_introduced)
da_la_socuna_convo_tier2_intro_accept = ConvoScreen:new {
	id = "tier2_intro_accept",
	leftDialog = "@conversation/yavin_rebel_trainer_2:s_97073639",
	stopConversation = "true",
	options = {}
}
da_la_socuna_convo:addScreen(da_la_socuna_convo_tier2_intro_accept)

-- Duty mission menu
da_la_socuna_convo_tier2_duty_missions = ConvoScreen:new {
	id = "tier2_duty_missions",
	leftDialog = "@conversation/yavin_rebel_trainer_2:s_e641a3d8",
	stopConversation = "false",
	options = {
		{"@conversation/yavin_rebel_trainer_2:s_46fb1c35", "tier2_destroy_duty"},
		{"@conversation/yavin_rebel_trainer_2:s_73c783f8", "tier2_recovery_duty"},
		{"@conversation/yavin_rebel_trainer_2:s_80e4843e", "tier2_escort_duty"},
	}
}
da_la_socuna_convo:addScreen(da_la_socuna_convo_tier2_duty_missions)

-- Duty confirms (handler starts the duty quests)
da_la_socuna_convo_tier2_destroy_duty = ConvoScreen:new {
	id = "tier2_destroy_duty",
	leftDialog = "@conversation/yavin_rebel_trainer_2:s_895e16f4",
	stopConversation = "true",
	options = {}
}
da_la_socuna_convo:addScreen(da_la_socuna_convo_tier2_destroy_duty)

da_la_socuna_convo_tier2_recovery_duty = ConvoScreen:new {
	id = "tier2_recovery_duty",
	leftDialog = "@conversation/yavin_rebel_trainer_2:s_895e16f4",
	stopConversation = "true",
	options = {}
}
da_la_socuna_convo:addScreen(da_la_socuna_convo_tier2_recovery_duty)

da_la_socuna_convo_tier2_escort_duty = ConvoScreen:new {
	id = "tier2_escort_duty",
	leftDialog = "@conversation/yavin_rebel_trainer_2:s_895e16f4",
	stopConversation = "true",
	options = {}
}
da_la_socuna_convo:addScreen(da_la_socuna_convo_tier2_escort_duty)

-- Player already has an active tier 2 mission
da_la_socuna_convo_tier2_has_mission = ConvoScreen:new {
	id = "tier2_has_mission",
	leftDialog = "@conversation/yavin_rebel_trainer_2:s_f7f3ab80",
	stopConversation = "true",
	options = {}
}
da_la_socuna_convo:addScreen(da_la_socuna_convo_tier2_has_mission)

-- Tier 2 training menu (options added dynamically by handler)
da_la_socuna_convo_tier2_training_menu = ConvoScreen:new {
	id = "tier2_training_menu",
	leftDialog = "@conversation/yavin_rebel_trainer_2:s_434cf40e",
	stopConversation = "false",
	options = {}
}
da_la_socuna_convo:addScreen(da_la_socuna_convo_tier2_training_menu)

-- Tier 2 training results (handler grants the skill)
da_la_socuna_convo_tier2_train_fighters = ConvoScreen:new {
	id = "tier2_train_fighters",
	leftDialog = "@conversation/yavin_rebel_trainer_2:s_895e16f4",
	stopConversation = "true",
	options = {}
}
da_la_socuna_convo:addScreen(da_la_socuna_convo_tier2_train_fighters)

da_la_socuna_convo_tier2_train_component = ConvoScreen:new {
	id = "tier2_train_component",
	leftDialog = "@conversation/yavin_rebel_trainer_2:s_895e16f4",
	stopConversation = "true",
	options = {}
}
da_la_socuna_convo:addScreen(da_la_socuna_convo_tier2_train_component)

da_la_socuna_convo_tier2_train_basics = ConvoScreen:new {
	id = "tier2_train_basics",
	leftDialog = "@conversation/yavin_rebel_trainer_2:s_895e16f4",
	stopConversation = "true",
	options = {}
}
da_la_socuna_convo:addScreen(da_la_socuna_convo_tier2_train_basics)

da_la_socuna_convo_tier2_train_droid = ConvoScreen:new {
	id = "tier2_train_droid",
	leftDialog = "@conversation/yavin_rebel_trainer_2:s_895e16f4",
	stopConversation = "true",
	options = {}
}
da_la_socuna_convo:addScreen(da_la_socuna_convo_tier2_train_droid)

-- Tier 2 mission 1 (inspect)
da_la_socuna_convo_tier2_mission1_brief = ConvoScreen:new {
	id = "tier2_mission1_brief",
	leftDialog = "@conversation/yavin_rebel_trainer_2:s_f88289a7",
	stopConversation = "false",
	options = {
		{"@conversation/yavin_rebel_trainer_2:s_468ab4d3", "tier2_accept_mission1"},
	}
}
da_la_socuna_convo:addScreen(da_la_socuna_convo_tier2_mission1_brief)

da_la_socuna_convo_tier2_accept_mission1 = ConvoScreen:new {
	id = "tier2_accept_mission1",
	leftDialog = "@conversation/yavin_rebel_trainer_2:s_d80e99ca",
	stopConversation = "true",
	options = {}
}
da_la_socuna_convo:addScreen(da_la_socuna_convo_tier2_accept_mission1)

da_la_socuna_convo_tier2_mission1_rewarded = ConvoScreen:new {
	id = "tier2_mission1_rewarded",
	leftDialog = "@conversation/yavin_rebel_trainer_2:s_b685e199",
	stopConversation = "true",
	options = {}
}
da_la_socuna_convo:addScreen(da_la_socuna_convo_tier2_mission1_rewarded)

da_la_socuna_convo_tier2_failed_mission1 = ConvoScreen:new {
	id = "tier2_failed_mission1",
	leftDialog = "@conversation/yavin_rebel_trainer_2:s_14086bc1",
	stopConversation = "true",
	options = {}
}
da_la_socuna_convo:addScreen(da_la_socuna_convo_tier2_failed_mission1)

-- Tier 2 mission 2 (escort)
da_la_socuna_convo_tier2_mission2_brief = ConvoScreen:new {
	id = "tier2_mission2_brief",
	leftDialog = "@conversation/yavin_rebel_trainer_2:s_a760a737",
	stopConversation = "false",
	options = {
		{"@conversation/yavin_rebel_trainer_2:s_bc57b086", "tier2_accept_mission2"},
	}
}
da_la_socuna_convo:addScreen(da_la_socuna_convo_tier2_mission2_brief)

da_la_socuna_convo_tier2_accept_mission2 = ConvoScreen:new {
	id = "tier2_accept_mission2",
	leftDialog = "@conversation/yavin_rebel_trainer_2:s_cec991df",
	stopConversation = "true",
	options = {}
}
da_la_socuna_convo:addScreen(da_la_socuna_convo_tier2_accept_mission2)

da_la_socuna_convo_tier2_mission2_rewarded = ConvoScreen:new {
	id = "tier2_mission2_rewarded",
	leftDialog = "@conversation/yavin_rebel_trainer_2:s_9777c464",
	stopConversation = "true",
	options = {}
}
da_la_socuna_convo:addScreen(da_la_socuna_convo_tier2_mission2_rewarded)

da_la_socuna_convo_tier2_failed_mission2 = ConvoScreen:new {
	id = "tier2_failed_mission2",
	leftDialog = "@conversation/yavin_rebel_trainer_2:s_f9855bf1",
	stopConversation = "true",
	options = {}
}
da_la_socuna_convo:addScreen(da_la_socuna_convo_tier2_failed_mission2)

-- Tier 2 mission 3 (recover the Imperial database)
da_la_socuna_convo_tier2_mission3_brief = ConvoScreen:new {
	id = "tier2_mission3_brief",
	leftDialog = "@conversation/yavin_rebel_trainer_2:s_154b642e",
	stopConversation = "false",
	options = {
		{"@conversation/yavin_rebel_trainer_2:s_2dec7766", "tier2_mission3_database"},
	}
}
da_la_socuna_convo:addScreen(da_la_socuna_convo_tier2_mission3_brief)

da_la_socuna_convo_tier2_mission3_database = ConvoScreen:new {
	id = "tier2_mission3_database",
	leftDialog = "@conversation/yavin_rebel_trainer_2:s_5018d177",
	stopConversation = "false",
	options = {
		{"@conversation/yavin_rebel_trainer_2:s_d5609495", "tier2_mission3_recovery_team"},
	}
}
da_la_socuna_convo:addScreen(da_la_socuna_convo_tier2_mission3_database)

da_la_socuna_convo_tier2_mission3_recovery_team = ConvoScreen:new {
	id = "tier2_mission3_recovery_team",
	leftDialog = "@conversation/yavin_rebel_trainer_2:s_5c4ab8c9",
	stopConversation = "false",
	options = {
		{"@conversation/yavin_rebel_trainer_2:s_851cc47", "tier2_mission3_lok_route"},
	}
}
da_la_socuna_convo:addScreen(da_la_socuna_convo_tier2_mission3_recovery_team)

da_la_socuna_convo_tier2_mission3_lok_route = ConvoScreen:new {
	id = "tier2_mission3_lok_route",
	leftDialog = "@conversation/yavin_rebel_trainer_2:s_b0753766",
	stopConversation = "false",
	options = {
		{"@conversation/yavin_rebel_trainer_2:s_a99ad4e8", "tier2_accept_mission3"},
	}
}
da_la_socuna_convo:addScreen(da_la_socuna_convo_tier2_mission3_lok_route)

da_la_socuna_convo_tier2_accept_mission3 = ConvoScreen:new {
	id = "tier2_accept_mission3",
	leftDialog = "@conversation/yavin_rebel_trainer_2:s_a7558b8",
	stopConversation = "true",
	options = {}
}
da_la_socuna_convo:addScreen(da_la_socuna_convo_tier2_accept_mission3)

da_la_socuna_convo_tier2_mission3_rewarded = ConvoScreen:new {
	id = "tier2_mission3_rewarded",
	leftDialog = "@conversation/yavin_rebel_trainer_2:s_b685e199",
	stopConversation = "true",
	options = {}
}
da_la_socuna_convo:addScreen(da_la_socuna_convo_tier2_mission3_rewarded)

da_la_socuna_convo_tier2_failed_mission3 = ConvoScreen:new {
	id = "tier2_failed_mission3",
	leftDialog = "@conversation/yavin_rebel_trainer_2:s_450abd55",
	stopConversation = "true",
	options = {}
}
da_la_socuna_convo:addScreen(da_la_socuna_convo_tier2_failed_mission3)

-- Tier 2 mission 4 (escort Nym's smuggler)
da_la_socuna_convo_tier2_mission4_brief = ConvoScreen:new {
	id = "tier2_mission4_brief",
	leftDialog = "@conversation/yavin_rebel_trainer_2:s_fddb83ca",
	stopConversation = "false",
	options = {
		{"@conversation/yavin_rebel_trainer_2:s_b2e340f6", "tier2_mission4_good_news"},
	}
}
da_la_socuna_convo:addScreen(da_la_socuna_convo_tier2_mission4_brief)

da_la_socuna_convo_tier2_mission4_good_news = ConvoScreen:new {
	id = "tier2_mission4_good_news",
	leftDialog = "@conversation/yavin_rebel_trainer_2:s_d931ff32",
	stopConversation = "false",
	options = {
		{"@conversation/yavin_rebel_trainer_2:s_3f00169", "tier2_mission4_nym_has_it"},
	}
}
da_la_socuna_convo:addScreen(da_la_socuna_convo_tier2_mission4_good_news)

da_la_socuna_convo_tier2_mission4_nym_has_it = ConvoScreen:new {
	id = "tier2_mission4_nym_has_it",
	leftDialog = "@conversation/yavin_rebel_trainer_2:s_18ac5f05",
	stopConversation = "false",
	options = {
		{"@conversation/yavin_rebel_trainer_2:s_3d419bc4", "tier2_mission4_nym_reasons"},
	}
}
da_la_socuna_convo:addScreen(da_la_socuna_convo_tier2_mission4_nym_has_it)

da_la_socuna_convo_tier2_mission4_nym_reasons = ConvoScreen:new {
	id = "tier2_mission4_nym_reasons",
	leftDialog = "@conversation/yavin_rebel_trainer_2:s_b6cf63f0",
	stopConversation = "false",
	options = {
		{"@conversation/yavin_rebel_trainer_2:s_b2e9d505", "tier2_mission4_nym_fee"},
	}
}
da_la_socuna_convo:addScreen(da_la_socuna_convo_tier2_mission4_nym_reasons)

da_la_socuna_convo_tier2_mission4_nym_fee = ConvoScreen:new {
	id = "tier2_mission4_nym_fee",
	leftDialog = "@conversation/yavin_rebel_trainer_2:s_2857391a",
	stopConversation = "false",
	options = {
		{"@conversation/yavin_rebel_trainer_2:s_39acc227", "tier2_mission4_orders"},
	}
}
da_la_socuna_convo:addScreen(da_la_socuna_convo_tier2_mission4_nym_fee)

da_la_socuna_convo_tier2_mission4_orders = ConvoScreen:new {
	id = "tier2_mission4_orders",
	leftDialog = "@conversation/yavin_rebel_trainer_2:s_1c128099",
	stopConversation = "false",
	options = {
		{"@conversation/yavin_rebel_trainer_2:s_cd0a60d4", "tier2_accept_mission4"},
	}
}
da_la_socuna_convo:addScreen(da_la_socuna_convo_tier2_mission4_orders)

da_la_socuna_convo_tier2_accept_mission4 = ConvoScreen:new {
	id = "tier2_accept_mission4",
	leftDialog = "@conversation/yavin_rebel_trainer_2:s_6c872984",
	stopConversation = "true",
	options = {}
}
da_la_socuna_convo:addScreen(da_la_socuna_convo_tier2_accept_mission4)

da_la_socuna_convo_tier2_mission4_rewarded = ConvoScreen:new {
	id = "tier2_mission4_rewarded",
	leftDialog = "@conversation/yavin_rebel_trainer_2:s_2a29add6",
	stopConversation = "true",
	options = {}
}
da_la_socuna_convo:addScreen(da_la_socuna_convo_tier2_mission4_rewarded)

da_la_socuna_convo_tier2_failed_mission4 = ConvoScreen:new {
	id = "tier2_failed_mission4",
	leftDialog = "@conversation/yavin_rebel_trainer_2:s_7b57442",
	stopConversation = "true",
	options = {}
}
da_la_socuna_convo:addScreen(da_la_socuna_convo_tier2_failed_mission4)

-- All tier 2 skills earned, tier incremented
da_la_socuna_convo_tier2_completed = ConvoScreen:new {
	id = "tier2_completed",
	leftDialog = "@conversation/yavin_rebel_trainer_2:s_308630ef",
	stopConversation = "true",
	options = {}
}
da_la_socuna_convo:addScreen(da_la_socuna_convo_tier2_completed)

--[[
	Tier 3 screens (authentic Live strings from string/en/conversation/tatooine_rebel_tier3.stf)
]]

-- Arnecio Ulvaw'op introduction and first mission briefing.
da_la_socuna_convo_tier3_intro_greeting = ConvoScreen:new {
	id = "tier3_intro_greeting",
	leftDialog = "@conversation/tatooine_rebel_tier3:s_6f921f12",
	stopConversation = "false",
	options = {{"@conversation/tatooine_rebel_tier3:s_783af10a", "tier3_intro_dossier"}}
}
da_la_socuna_convo:addScreen(da_la_socuna_convo_tier3_intro_greeting)

da_la_socuna_convo_tier3_intro_dossier = ConvoScreen:new {
	id = "tier3_intro_dossier",
	leftDialog = "@conversation/tatooine_rebel_tier3:s_be9caae0",
	stopConversation = "false",
	options = {{"@conversation/tatooine_rebel_tier3:s_81682525", "tier3_intro_dathomir"}}
}
da_la_socuna_convo:addScreen(da_la_socuna_convo_tier3_intro_dossier)

da_la_socuna_convo_tier3_intro_dathomir = ConvoScreen:new {
	id = "tier3_intro_dathomir",
	leftDialog = "@conversation/tatooine_rebel_tier3:s_645464dc",
	stopConversation = "false",
	options = {{"@conversation/tatooine_rebel_tier3:s_4c695dbd", "tier3_intro_prison"}}
}
da_la_socuna_convo:addScreen(da_la_socuna_convo_tier3_intro_dathomir)

da_la_socuna_convo_tier3_intro_prison = ConvoScreen:new {
	id = "tier3_intro_prison",
	leftDialog = "@conversation/tatooine_rebel_tier3:s_d2f7d204",
	stopConversation = "false",
	options = {{"@conversation/tatooine_rebel_tier3:s_2787404a", "tier3_intro_interest"}}
}
da_la_socuna_convo:addScreen(da_la_socuna_convo_tier3_intro_prison)

da_la_socuna_convo_tier3_intro_interest = ConvoScreen:new {
	id = "tier3_intro_interest",
	leftDialog = "@conversation/tatooine_rebel_tier3:s_8fbd3f85",
	stopConversation = "false",
	options = {{"@conversation/tatooine_rebel_tier3:s_3059f369", "tier3_intro_cautious"}}
}
da_la_socuna_convo:addScreen(da_la_socuna_convo_tier3_intro_interest)

da_la_socuna_convo_tier3_intro_cautious = ConvoScreen:new {
	id = "tier3_intro_cautious",
	leftDialog = "@conversation/tatooine_rebel_tier3:s_b3f5831e",
	stopConversation = "false",
	options = {{"@conversation/tatooine_rebel_tier3:s_82f0aea5", "tier3_intro_personal"}}
}
da_la_socuna_convo:addScreen(da_la_socuna_convo_tier3_intro_cautious)

da_la_socuna_convo_tier3_intro_personal = ConvoScreen:new {
	id = "tier3_intro_personal",
	leftDialog = "@conversation/tatooine_rebel_tier3:s_12e4e81a",
	stopConversation = "false",
	options = {{"@conversation/tatooine_rebel_tier3:s_5bd69df6", "tier3_intro_officer"}}
}
da_la_socuna_convo:addScreen(da_la_socuna_convo_tier3_intro_personal)

da_la_socuna_convo_tier3_intro_officer = ConvoScreen:new {
	id = "tier3_intro_officer",
	leftDialog = "@conversation/tatooine_rebel_tier3:s_86fe6fa2",
	stopConversation = "false",
	options = {{"@conversation/tatooine_rebel_tier3:s_3aa053cf", "tier3_intro_location"}}
}
da_la_socuna_convo:addScreen(da_la_socuna_convo_tier3_intro_officer)

da_la_socuna_convo_tier3_intro_location = ConvoScreen:new {
	id = "tier3_intro_location",
	leftDialog = "@conversation/tatooine_rebel_tier3:s_189648be",
	stopConversation = "false",
	options = {{"@conversation/tatooine_rebel_tier3:s_6a45ad00", "tier3_intro_lambda"}}
}
da_la_socuna_convo:addScreen(da_la_socuna_convo_tier3_intro_location)

da_la_socuna_convo_tier3_intro_lambda = ConvoScreen:new {
	id = "tier3_intro_lambda",
	leftDialog = "@conversation/tatooine_rebel_tier3:s_459dafe4",
	stopConversation = "false",
	options = {{"@conversation/tatooine_rebel_tier3:s_4c695dbd", "tier3_intro_shuttle"}}
}
da_la_socuna_convo:addScreen(da_la_socuna_convo_tier3_intro_lambda)

da_la_socuna_convo_tier3_intro_shuttle = ConvoScreen:new {
	id = "tier3_intro_shuttle",
	leftDialog = "@conversation/tatooine_rebel_tier3:s_374e94fe",
	stopConversation = "false",
	options = {{"@conversation/tatooine_rebel_tier3:s_61657d0f", "tier3_intro_escort"}}
}
da_la_socuna_convo:addScreen(da_la_socuna_convo_tier3_intro_shuttle)

da_la_socuna_convo_tier3_intro_escort = ConvoScreen:new {
	id = "tier3_intro_escort",
	leftDialog = "@conversation/tatooine_rebel_tier3:s_13faa821",
	stopConversation = "false",
	options = {{"@conversation/tatooine_rebel_tier3:s_1bd3a505", "tier3_intro_assault_droid"}}
}
da_la_socuna_convo:addScreen(da_la_socuna_convo_tier3_intro_escort)

da_la_socuna_convo_tier3_intro_assault_droid = ConvoScreen:new {
	id = "tier3_intro_assault_droid",
	leftDialog = "@conversation/tatooine_rebel_tier3:s_c4bc453f",
	stopConversation = "false",
	options = {{"@conversation/tatooine_rebel_tier3:s_25e98647", "tier3_accept_mission1"}}
}
da_la_socuna_convo:addScreen(da_la_socuna_convo_tier3_intro_assault_droid)

da_la_socuna_convo_tier3_not_ready = ConvoScreen:new {
	id = "tier3_not_ready",
	leftDialog = "@conversation/tatooine_rebel_tier3:s_614f7f1c",
	stopConversation = "true",
	options = {}
}
da_la_socuna_convo:addScreen(da_la_socuna_convo_tier3_not_ready)

da_la_socuna_convo_tier3_has_mission = ConvoScreen:new {
	id = "tier3_has_mission",
	leftDialog = "@conversation/tatooine_rebel_tier3:s_5a66cd79",
	stopConversation = "true",
	options = {}
}
da_la_socuna_convo:addScreen(da_la_socuna_convo_tier3_has_mission)

-- Tier 3 mission 1
da_la_socuna_convo_tier3_mission1_brief = ConvoScreen:new {
	id = "tier3_mission1_brief",
	leftDialog = "@conversation/tatooine_rebel_tier3:s_7b907498",
	stopConversation = "false",
	options = {
		{"@conversation/tatooine_rebel_tier3:s_90377ed4", "tier3_accept_mission1"},
	}
}
da_la_socuna_convo:addScreen(da_la_socuna_convo_tier3_mission1_brief)

da_la_socuna_convo_tier3_accept_mission1 = ConvoScreen:new {
	id = "tier3_accept_mission1",
	leftDialog = "@conversation/tatooine_rebel_tier3:s_d5bf212f",
	stopConversation = "true",
	options = {}
}
da_la_socuna_convo:addScreen(da_la_socuna_convo_tier3_accept_mission1)

da_la_socuna_convo_tier3_failed_mission1 = ConvoScreen:new {
	id = "tier3_failed_mission1",
	leftDialog = "@conversation/tatooine_rebel_tier3:s_c74a6348",
	stopConversation = "true",
	options = {}
}
da_la_socuna_convo:addScreen(da_la_socuna_convo_tier3_failed_mission1)

-- Tier 3 excellent work screens (training options added dynamically by handler)
da_la_socuna_convo_tier3_excellent_work1 = ConvoScreen:new {
	id = "tier3_excellent_work1",
	leftDialog = "@conversation/tatooine_rebel_tier3:s_8bd6bf55",
	stopConversation = "false",
	options = {}
}
da_la_socuna_convo:addScreen(da_la_socuna_convo_tier3_excellent_work1)

-- Tier 3 mission 2
da_la_socuna_convo_tier3_mission2_brief = ConvoScreen:new {
	id = "tier3_mission2_brief",
	leftDialog = "@conversation/tatooine_rebel_tier3:s_a8e0243a",
	stopConversation = "false",
	options = {
		{"@conversation/tatooine_rebel_tier3:s_ca8f5dda", "tier3_accept_mission2"},
	}
}
da_la_socuna_convo:addScreen(da_la_socuna_convo_tier3_mission2_brief)

da_la_socuna_convo_tier3_accept_mission2 = ConvoScreen:new {
	id = "tier3_accept_mission2",
	leftDialog = "@conversation/tatooine_rebel_tier3:s_b1479cf9",
	stopConversation = "true",
	options = {}
}
da_la_socuna_convo:addScreen(da_la_socuna_convo_tier3_accept_mission2)

da_la_socuna_convo_tier3_failed_mission2 = ConvoScreen:new {
	id = "tier3_failed_mission2",
	leftDialog = "@conversation/tatooine_rebel_tier3:s_c74a6348",
	stopConversation = "true",
	options = {}
}
da_la_socuna_convo:addScreen(da_la_socuna_convo_tier3_failed_mission2)

da_la_socuna_convo_tier3_excellent_work2 = ConvoScreen:new {
	id = "tier3_excellent_work2",
	leftDialog = "@conversation/tatooine_rebel_tier3:s_fa6e2383",
	stopConversation = "false",
	options = {}
}
da_la_socuna_convo:addScreen(da_la_socuna_convo_tier3_excellent_work2)

-- Tier 3 mission 3
da_la_socuna_convo_tier3_mission3_brief = ConvoScreen:new {
	id = "tier3_mission3_brief",
	leftDialog = "@conversation/tatooine_rebel_tier3:s_573af66b",
	stopConversation = "false",
	options = {
		{"@conversation/tatooine_rebel_tier3:s_eba35f17", "tier3_accept_mission3"},
	}
}
da_la_socuna_convo:addScreen(da_la_socuna_convo_tier3_mission3_brief)

da_la_socuna_convo_tier3_accept_mission3 = ConvoScreen:new {
	id = "tier3_accept_mission3",
	leftDialog = "@conversation/tatooine_rebel_tier3:s_db13b2d9",
	stopConversation = "true",
	options = {}
}
da_la_socuna_convo:addScreen(da_la_socuna_convo_tier3_accept_mission3)

da_la_socuna_convo_tier3_failed_mission3 = ConvoScreen:new {
	id = "tier3_failed_mission3",
	leftDialog = "@conversation/tatooine_rebel_tier3:s_c74a6348",
	stopConversation = "true",
	options = {}
}
da_la_socuna_convo:addScreen(da_la_socuna_convo_tier3_failed_mission3)

da_la_socuna_convo_tier3_excellent_work3 = ConvoScreen:new {
	id = "tier3_excellent_work3",
	leftDialog = "@conversation/tatooine_rebel_tier3:s_887fc0e9",
	stopConversation = "false",
	options = {}
}
da_la_socuna_convo:addScreen(da_la_socuna_convo_tier3_excellent_work3)

-- Tier 3 mission 4
da_la_socuna_convo_tier3_mission4_brief = ConvoScreen:new {
	id = "tier3_mission4_brief",
	leftDialog = "@conversation/tatooine_rebel_tier3:s_d35a8803",
	stopConversation = "false",
	options = {
		{"@conversation/tatooine_rebel_tier3:s_76340c2f", "tier3_accept_mission4"},
	}
}
da_la_socuna_convo:addScreen(da_la_socuna_convo_tier3_mission4_brief)

da_la_socuna_convo_tier3_accept_mission4 = ConvoScreen:new {
	id = "tier3_accept_mission4",
	leftDialog = "@conversation/tatooine_rebel_tier3:s_7b3fb40b",
	stopConversation = "true",
	options = {}
}
da_la_socuna_convo:addScreen(da_la_socuna_convo_tier3_accept_mission4)

da_la_socuna_convo_tier3_failed_mission4 = ConvoScreen:new {
	id = "tier3_failed_mission4",
	leftDialog = "@conversation/tatooine_rebel_tier3:s_c74a6348",
	stopConversation = "true",
	options = {}
}
da_la_socuna_convo:addScreen(da_la_socuna_convo_tier3_failed_mission4)

da_la_socuna_convo_tier3_excellent_work4 = ConvoScreen:new {
	id = "tier3_excellent_work4",
	leftDialog = "@conversation/tatooine_rebel_tier3:s_f72b6d44",
	stopConversation = "false",
	options = {}
}
da_la_socuna_convo:addScreen(da_la_socuna_convo_tier3_excellent_work4)

-- Tier 3 training results (handler grants the skill, no XP cost)
da_la_socuna_convo_tier3_train_fighters = ConvoScreen:new {
	id = "tier3_train_fighters",
	leftDialog = "@conversation/tatooine_rebel_tier3:s_3b851af5",
	stopConversation = "true",
	options = {}
}
da_la_socuna_convo:addScreen(da_la_socuna_convo_tier3_train_fighters)

da_la_socuna_convo_tier3_train_component = ConvoScreen:new {
	id = "tier3_train_component",
	leftDialog = "@conversation/tatooine_rebel_tier3:s_3b851af5",
	stopConversation = "true",
	options = {}
}
da_la_socuna_convo:addScreen(da_la_socuna_convo_tier3_train_component)

da_la_socuna_convo_tier3_train_basics = ConvoScreen:new {
	id = "tier3_train_basics",
	leftDialog = "@conversation/tatooine_rebel_tier3:s_3b851af5",
	stopConversation = "true",
	options = {}
}
da_la_socuna_convo:addScreen(da_la_socuna_convo_tier3_train_basics)

da_la_socuna_convo_tier3_train_droid = ConvoScreen:new {
	id = "tier3_train_droid",
	leftDialog = "@conversation/tatooine_rebel_tier3:s_3b851af5",
	stopConversation = "true",
	options = {}
}
da_la_socuna_convo:addScreen(da_la_socuna_convo_tier3_train_droid)

-- All tier 3 skills earned, tier incremented
da_la_socuna_convo_tier3_completed = ConvoScreen:new {
	id = "tier3_completed",
	leftDialog = "@conversation/tatooine_rebel_tier3:s_d72cbbfa",
	stopConversation = "true",
	options = {}
}
da_la_socuna_convo:addScreen(da_la_socuna_convo_tier3_completed)

--[[
	Tier 4 + Master screens (authentic Live strings from string/en/conversation/tatooine_rebel_tier4.stf)
]]

da_la_socuna_convo_tier4_on_mission = ConvoScreen:new {
	id = "tier4_on_mission",
	leftDialog = "@conversation/tatooine_rebel_tier4:s_a86d6540",
	stopConversation = "true",
	options = {}
}
da_la_socuna_convo:addScreen(da_la_socuna_convo_tier4_on_mission)

da_la_socuna_convo_tier4_initial_briefing = ConvoScreen:new {
	id = "tier4_initial_briefing",
	leftDialog = "@conversation/tatooine_rebel_tier4:s_37df0fba",
	stopConversation = "false",
	options = {
		{"@conversation/tatooine_rebel_tier4:s_5bc07030", "tier4_intro_not_spy"},
	}
}
da_la_socuna_convo:addScreen(da_la_socuna_convo_tier4_initial_briefing)

local function addUfwolTier4Screen(id, dialog, option, nextScreen)
	local screen = ConvoScreen:new {
		id = id,
		leftDialog = "@conversation/tatooine_rebel_tier4:" .. dialog,
		stopConversation = option == nil and "true" or "false",
		options = option == nil and {} or {{"@conversation/tatooine_rebel_tier4:" .. option, nextScreen}},
	}

	da_la_socuna_convo:addScreen(screen)
end

addUfwolTier4Screen("tier4_intro_not_spy", "s_2db03120", "s_221bd4ce", "tier4_intro_ulvawop")
addUfwolTier4Screen("tier4_intro_ulvawop", "s_6e4f5881", "s_6c38055e", "tier4_intro_spies")
addUfwolTier4Screen("tier4_intro_spies", "s_325c76db", "s_856aca7d", "tier4_intro_activity")
addUfwolTier4Screen("tier4_intro_activity", "s_aa15510b", "s_521e8b09", "tier4_intro_phoenix")
addUfwolTier4Screen("tier4_intro_phoenix", "s_15235513", "s_d9cced1f", "tier4_intro_attack")
addUfwolTier4Screen("tier4_intro_attack", "s_5471712d", "s_43fcfbca", "tier4_intro_numbers")
addUfwolTier4Screen("tier4_intro_numbers", "s_f73581de", "s_8ddbf95b", "tier4_intro_new_ties")
addUfwolTier4Screen("tier4_intro_new_ties", "s_579532ac", "s_c127c173", "tier4_intro_next_generation")
addUfwolTier4Screen("tier4_intro_next_generation", "s_b1dd06bd", "s_914a4095", "tier4_intro_warnings")
addUfwolTier4Screen("tier4_intro_warnings", "s_954ec468", "s_61657d0f", "tier4_intro_challenge")
addUfwolTier4Screen("tier4_intro_challenge", "s_f689a56f", "s_d55f2579", "tier4_first_mission")

-- Tier 4 mission 1 (attack the Empire's advanced fighters)
da_la_socuna_convo_tier4_first_mission = ConvoScreen:new {
	id = "tier4_first_mission",
	leftDialog = "@conversation/tatooine_rebel_tier4:s_d68a9f0a",
	stopConversation = "false",
	options = {
		{"@conversation/tatooine_rebel_tier4:s_49e55ca2", "accept_tier4_first_mission"},
	}
}
da_la_socuna_convo:addScreen(da_la_socuna_convo_tier4_first_mission)

da_la_socuna_convo_accept_tier4_first_mission = ConvoScreen:new {
	id = "accept_tier4_first_mission",
	leftDialog = "@conversation/tatooine_rebel_tier4:s_79e6aa32",
	stopConversation = "true",
	options = {}
}
da_la_socuna_convo:addScreen(da_la_socuna_convo_accept_tier4_first_mission)

da_la_socuna_convo_failed_tier4_first_mission = ConvoScreen:new {
	id = "failed_tier4_first_mission",
	leftDialog = "@conversation/tatooine_rebel_tier4:s_45ae8603",
	stopConversation = "true",
	options = {}
}
da_la_socuna_convo:addScreen(da_la_socuna_convo_failed_tier4_first_mission)

da_la_socuna_convo_tier4_first_mission_success = ConvoScreen:new {
	id = "tier4_first_mission_success",
	leftDialog = "@conversation/tatooine_rebel_tier4:s_6c01a28a",
	stopConversation = "true",
	options = {}
}
da_la_socuna_convo:addScreen(da_la_socuna_convo_tier4_first_mission_success)

-- Tier 4 mission 2 (steal an advanced Imperial fighter)
da_la_socuna_convo_tier4_second_mission = ConvoScreen:new {
	id = "tier4_second_mission",
	leftDialog = "@conversation/tatooine_rebel_tier4:s_7b03d343",
	stopConversation = "false",
	options = {
		{"@conversation/tatooine_rebel_tier4:s_d059f8aa", "tier4_second_empire_resources"},
	}
}
da_la_socuna_convo:addScreen(da_la_socuna_convo_tier4_second_mission)

addUfwolTier4Screen("tier4_second_empire_resources", "s_83b2f3f1", "s_6425e854", "tier4_second_gut_it_out")
addUfwolTier4Screen("tier4_second_gut_it_out", "s_ea7b0fb2", "s_6425e854", "tier4_second_work_smarter")
addUfwolTier4Screen("tier4_second_work_smarter", "s_4ca48b38", "s_e816c4f3", "tier4_second_threat")
addUfwolTier4Screen("tier4_second_threat", "s_4df417ce", "s_18d61e21", "tier4_second_hijack")
addUfwolTier4Screen("tier4_second_hijack", "s_c946f118", "s_790d22d6", "tier4_second_not_easy")
addUfwolTier4Screen("tier4_second_not_easy", "s_1cd7da68", "s_a33056f4", "tier4_second_test_ride")
addUfwolTier4Screen("tier4_second_test_ride", "s_2183d62a", "s_d82b46ba", "tier4_second_assault_droid")
addUfwolTier4Screen("tier4_second_assault_droid", "s_32b5bee1", "s_8e9d0848", "tier4_second_alliance_technology")
addUfwolTier4Screen("tier4_second_alliance_technology", "s_92a98982", "s_49e55ca2", "accept_tier4_second_mission")

da_la_socuna_convo_accept_tier4_second_mission = ConvoScreen:new {
	id = "accept_tier4_second_mission",
	leftDialog = "@conversation/tatooine_rebel_tier4:s_9fcfe841",
	stopConversation = "true",
	options = {}
}
da_la_socuna_convo:addScreen(da_la_socuna_convo_accept_tier4_second_mission)

da_la_socuna_convo_failed_tier4_second_mission = ConvoScreen:new {
	id = "failed_tier4_second_mission",
	leftDialog = "@conversation/tatooine_rebel_tier4:s_45ae8603",
	stopConversation = "true",
	options = {}
}
da_la_socuna_convo:addScreen(da_la_socuna_convo_failed_tier4_second_mission)

da_la_socuna_convo_tier4_second_mission_success = ConvoScreen:new {
	id = "tier4_second_mission_success",
	leftDialog = "@conversation/tatooine_rebel_tier4:s_bf1cdb65",
	stopConversation = "true",
	options = {}
}
da_la_socuna_convo:addScreen(da_la_socuna_convo_tier4_second_mission_success)

-- Tier 4 mission 3 (space battle)
da_la_socuna_convo_tier4_third_mission = ConvoScreen:new {
	id = "tier4_third_mission",
	leftDialog = "@conversation/tatooine_rebel_tier4:s_49bf2ccb",
	stopConversation = "false",
	options = {
		{"@conversation/tatooine_rebel_tier4:s_c8a0830d", "tier4_third_handling"},
	}
}
da_la_socuna_convo:addScreen(da_la_socuna_convo_tier4_third_mission)

addUfwolTier4Screen("tier4_third_handling", "s_6dea357d", "s_6425e854", "tier4_third_engineers")
addUfwolTier4Screen("tier4_third_engineers", "s_f3eda860", "s_2c10011d", "tier4_third_party")
addUfwolTier4Screen("tier4_third_party", "s_9722b330", "s_89e27dc9", "tier4_third_no_stamp")
addUfwolTier4Screen("tier4_third_no_stamp", "s_7f14ac3a", "s_63e0ab42", "tier4_third_new_tack")
addUfwolTier4Screen("tier4_third_new_tack", "s_1eed1024", "s_8009422e", "tier4_third_endor_lead")
addUfwolTier4Screen("tier4_third_endor_lead", "s_c2b3ccaa", "s_bc57b086", "tier4_third_station")
addUfwolTier4Screen("tier4_third_station", "s_62fa1f75", "s_e42b260e", "accept_tier4_third_mission")

da_la_socuna_convo_accept_tier4_third_mission = ConvoScreen:new {
	id = "accept_tier4_third_mission",
	leftDialog = "@conversation/tatooine_rebel_tier4:s_fed525e5",
	stopConversation = "true",
	options = {}
}
da_la_socuna_convo:addScreen(da_la_socuna_convo_accept_tier4_third_mission)

da_la_socuna_convo_failed_tier4_third_mission = ConvoScreen:new {
	id = "failed_tier4_third_mission",
	leftDialog = "@conversation/tatooine_rebel_tier4:s_45ae8603",
	stopConversation = "true",
	options = {}
}
da_la_socuna_convo:addScreen(da_la_socuna_convo_failed_tier4_third_mission)

da_la_socuna_convo_tier4_third_mission_success = ConvoScreen:new {
	id = "tier4_third_mission_success",
	leftDialog = "@conversation/tatooine_rebel_tier4:s_fb3d31a9",
	stopConversation = "true",
	options = {}
}
da_la_socuna_convo:addScreen(da_la_socuna_convo_tier4_third_mission_success)

-- Tier 4 mission 4 (terminate the Imperial ship and recover its debris)
da_la_socuna_convo_tier4_fourth_mission = ConvoScreen:new {
	id = "tier4_fourth_mission",
	leftDialog = "@conversation/tatooine_rebel_tier4:s_d30b6d26",
	stopConversation = "false",
	options = {
		{"@conversation/tatooine_rebel_tier4:s_87f091b9", "tier4_fourth_reputation"},
	}
}
da_la_socuna_convo:addScreen(da_la_socuna_convo_tier4_fourth_mission)

addUfwolTier4Screen("tier4_fourth_reputation", "s_33cdebfd", "s_742d8c68", "tier4_fourth_full_member")
addUfwolTier4Screen("tier4_fourth_full_member", "s_856e4aab", "s_b3e9c738", "tier4_fourth_endor_failure")
addUfwolTier4Screen("tier4_fourth_endor_failure", "s_323479fd", "s_1131a10a", "tier4_fourth_endor_intel")
addUfwolTier4Screen("tier4_fourth_endor_intel", "s_5b998dc7", "s_71a53f8b", "tier4_fourth_activity")
addUfwolTier4Screen("tier4_fourth_activity", "s_ba8b09ff", "s_fa396956", "tier4_fourth_unknown_project")
addUfwolTier4Screen("tier4_fourth_unknown_project", "s_a72f79b2", "s_32b7bf59", "tier4_fourth_complex_project")
addUfwolTier4Screen("tier4_fourth_complex_project", "s_4123d99b", "s_fbb318e5", "tier4_fourth_target")
addUfwolTier4Screen("tier4_fourth_target", "s_b659eebb", "s_fb9f7cd6", "accept_tier4_fourth_mission")

da_la_socuna_convo_accept_tier4_fourth_mission = ConvoScreen:new {
	id = "accept_tier4_fourth_mission",
	leftDialog = "@conversation/tatooine_rebel_tier4:s_cc7b5947",
	stopConversation = "true",
	options = {}
}
da_la_socuna_convo:addScreen(da_la_socuna_convo_accept_tier4_fourth_mission)

da_la_socuna_convo_failed_tier4_fourth_mission = ConvoScreen:new {
	id = "failed_tier4_fourth_mission",
	leftDialog = "@conversation/tatooine_rebel_tier4:s_45ae8603",
	stopConversation = "true",
	options = {}
}
da_la_socuna_convo:addScreen(da_la_socuna_convo_failed_tier4_fourth_mission)

da_la_socuna_convo_tier4_fourth_mission_success = ConvoScreen:new {
	id = "tier4_fourth_mission_success",
	leftDialog = "@conversation/tatooine_rebel_tier4:s_6c524e01",
	stopConversation = "true",
	options = {}
}
da_la_socuna_convo:addScreen(da_la_socuna_convo_tier4_fourth_mission_success)

-- Tier 4 training menu (options added dynamically by handler)
da_la_socuna_convo_ready_train_tier4 = ConvoScreen:new {
	id = "ready_train_tier4",
	leftDialog = "@conversation/tatooine_rebel_tier4:s_cb594529",
	stopConversation = "false",
	options = {}
}
da_la_socuna_convo:addScreen(da_la_socuna_convo_ready_train_tier4)

-- Tier 4 training results (handler grants the skill)
da_la_socuna_convo_tier4_train_fighters = ConvoScreen:new {
	id = "tier4_train_fighters",
	leftDialog = "@conversation/tatooine_rebel_tier4:s_7dae4367",
	stopConversation = "true",
	options = {}
}
da_la_socuna_convo:addScreen(da_la_socuna_convo_tier4_train_fighters)

da_la_socuna_convo_tier4_train_component = ConvoScreen:new {
	id = "tier4_train_component",
	leftDialog = "@conversation/tatooine_rebel_tier4:s_7dae4367",
	stopConversation = "true",
	options = {}
}
da_la_socuna_convo:addScreen(da_la_socuna_convo_tier4_train_component)

da_la_socuna_convo_tier4_train_basics = ConvoScreen:new {
	id = "tier4_train_basics",
	leftDialog = "@conversation/tatooine_rebel_tier4:s_7dae4367",
	stopConversation = "true",
	options = {}
}
da_la_socuna_convo:addScreen(da_la_socuna_convo_tier4_train_basics)

da_la_socuna_convo_tier4_train_droid = ConvoScreen:new {
	id = "tier4_train_droid",
	leftDialog = "@conversation/tatooine_rebel_tier4:s_7dae4367",
	stopConversation = "true",
	options = {}
}
da_la_socuna_convo:addScreen(da_la_socuna_convo_tier4_train_droid)

-- Tier 4 repeatable duty menu
da_la_socuna_convo_tier4_duty_repeat = ConvoScreen:new {
	id = "tier4_duty_repeat",
	leftDialog = "@conversation/tatooine_rebel_tier4:s_39a10eac",
	stopConversation = "false",
	options = {
		{"@conversation/tatooine_rebel_tier4:s_91502216", "accept_tier4_duty1"},
		{"@conversation/tatooine_rebel_tier4:s_d0fd857b", "accept_tier4_duty2"},
		{"@conversation/tatooine_rebel_tier4:s_d55f2579", "accept_tier4_duty3"},
		{"@conversation/tatooine_rebel_tier4:s_bc57b086", "accept_tier4_duty4"},
	}
}
da_la_socuna_convo:addScreen(da_la_socuna_convo_tier4_duty_repeat)

da_la_socuna_convo_accept_tier4_duty1 = ConvoScreen:new {
	id = "accept_tier4_duty1",
	leftDialog = "@conversation/tatooine_rebel_tier4:s_a5b93c4d",
	stopConversation = "true",
	options = {}
}
da_la_socuna_convo:addScreen(da_la_socuna_convo_accept_tier4_duty1)

da_la_socuna_convo_accept_tier4_duty2 = ConvoScreen:new {
	id = "accept_tier4_duty2",
	leftDialog = "@conversation/tatooine_rebel_tier4:s_a5b93c4d",
	stopConversation = "true",
	options = {}
}
da_la_socuna_convo:addScreen(da_la_socuna_convo_accept_tier4_duty2)

da_la_socuna_convo_accept_tier4_duty3 = ConvoScreen:new {
	id = "accept_tier4_duty3",
	leftDialog = "@conversation/tatooine_rebel_tier4:s_a5b93c4d",
	stopConversation = "true",
	options = {}
}
da_la_socuna_convo:addScreen(da_la_socuna_convo_accept_tier4_duty3)

da_la_socuna_convo_accept_tier4_duty4 = ConvoScreen:new {
	id = "accept_tier4_duty4",
	leftDialog = "@conversation/tatooine_rebel_tier4:s_a5b93c4d",
	stopConversation = "true",
	options = {}
}
da_la_socuna_convo:addScreen(da_la_socuna_convo_accept_tier4_duty4)

-- Master mission hand-off
da_la_socuna_convo_master_mission = ConvoScreen:new {
	id = "master_mission",
	leftDialog = "@conversation/tatooine_rebel_tier4:s_30a32651",
	stopConversation = "false",
	options = {
		{"@conversation/tatooine_rebel_tier4:s_719a036e", "master_details"},
		{"@conversation/tatooine_rebel_tier4:s_e42b260e", "accept_master_mission"},
	}
}
da_la_socuna_convo:addScreen(da_la_socuna_convo_master_mission)

da_la_socuna_convo_master_details = ConvoScreen:new {
	id = "master_details",
	leftDialog = "@conversation/tatooine_rebel_tier4:s_3bf1bb23",
	stopConversation = "false",
	options = {
		{"@conversation/tatooine_rebel_tier4:s_e42b260e", "accept_master_mission"},
	}
}
da_la_socuna_convo:addScreen(da_la_socuna_convo_master_details)

da_la_socuna_convo_accept_master_mission = ConvoScreen:new {
	id = "accept_master_mission",
	leftDialog = "@conversation/tatooine_rebel_tier4:s_e7488f0b",
	stopConversation = "true",
	options = {}
}
da_la_socuna_convo:addScreen(da_la_socuna_convo_accept_master_mission)

-- Master pilot: everything finished
da_la_socuna_convo_tier4_completed = ConvoScreen:new {
	id = "tier4_completed",
	leftDialog = "@conversation/tatooine_rebel_tier4:s_233489bc",
	stopConversation = "true",
	options = {}
}
da_la_socuna_convo:addScreen(da_la_socuna_convo_tier4_completed)

addConversationTemplate("da_la_socuna_convo", da_la_socuna_convo);
