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

--[[ Tier 1 -- Mission 2: Destroy (handler starts destroy_tatooine_rebel_2 on "quest2_accepted") ]]
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

-- Quest 2 rewarded; leads into Mission 3 (strike the TIE wing on the supply route)
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

-- Mission 3 accepted (handler starts patrol_tatooine_rebel_3 on "train_me3")
da_la_socuna_convo_train_me3 = ConvoScreen:new {
	id = "train_me3",
	leftDialog = "@conversation/tatooine_rebel_trainer_1:s_b0778713", -- The Empire does not yet know that their fleet info has been compromised. Strike the new TIE fighters moving into this area with extreme prejudice, and they will have no choice but to halt their invasion strategy.
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

-- Quest 2 retry acknowledged (handler restarts destroy_tatooine_rebel_2)
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

-- Quest 3 retry acknowledged (handler restarts patrol_tatooine_rebel_3)
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
	Tier 2 screens (Vrak-stage dispatch through Da'la Socuna; authentic Live strings from
	string/en/conversation/lok_rebel_trainer_2.stf)
]]

-- New tier 2 pilot introduction
da_la_socuna_convo_tier2_introduction = ConvoScreen:new {
	id = "tier2_introduction",
	leftDialog = "@conversation/lok_rebel_trainer_2:s_438969d3", -- greeting
	stopConversation = "false",
	options = {
		{"@conversation/lok_rebel_trainer_2:s_da77c355", "tier2_intro_accept"},
	}
}
da_la_socuna_convo:addScreen(da_la_socuna_convo_tier2_introduction)

-- Introduction accepted (handler sets tier2_introduced)
da_la_socuna_convo_tier2_intro_accept = ConvoScreen:new {
	id = "tier2_intro_accept",
	leftDialog = "@conversation/lok_rebel_trainer_2:s_e58d7043",
	stopConversation = "true",
	options = {}
}
da_la_socuna_convo:addScreen(da_la_socuna_convo_tier2_intro_accept)

-- Duty mission menu
da_la_socuna_convo_tier2_duty_missions = ConvoScreen:new {
	id = "tier2_duty_missions",
	leftDialog = "@conversation/lok_rebel_trainer_2:s_9d922723",
	stopConversation = "false",
	options = {
		{"@conversation/lok_rebel_trainer_2:s_1dfeca09", "tier2_destroy_duty"},
		{"@conversation/lok_rebel_trainer_2:s_e02126d9", "tier2_recovery_duty"},
		{"@conversation/lok_rebel_trainer_2:s_cd3e2b38", "tier2_escort_duty"},
	}
}
da_la_socuna_convo:addScreen(da_la_socuna_convo_tier2_duty_missions)

-- Duty confirms (handler starts the duty quests)
da_la_socuna_convo_tier2_destroy_duty = ConvoScreen:new {
	id = "tier2_destroy_duty",
	leftDialog = "@conversation/lok_rebel_trainer_2:s_99210986",
	stopConversation = "true",
	options = {}
}
da_la_socuna_convo:addScreen(da_la_socuna_convo_tier2_destroy_duty)

da_la_socuna_convo_tier2_recovery_duty = ConvoScreen:new {
	id = "tier2_recovery_duty",
	leftDialog = "@conversation/lok_rebel_trainer_2:s_e6569c04",
	stopConversation = "true",
	options = {}
}
da_la_socuna_convo:addScreen(da_la_socuna_convo_tier2_recovery_duty)

da_la_socuna_convo_tier2_escort_duty = ConvoScreen:new {
	id = "tier2_escort_duty",
	leftDialog = "@conversation/lok_rebel_trainer_2:s_37e5c8bc",
	stopConversation = "true",
	options = {}
}
da_la_socuna_convo:addScreen(da_la_socuna_convo_tier2_escort_duty)

-- Player already has an active tier 2 mission
da_la_socuna_convo_tier2_has_mission = ConvoScreen:new {
	id = "tier2_has_mission",
	leftDialog = "@conversation/lok_rebel_trainer_2:s_d356f8d",
	stopConversation = "true",
	options = {}
}
da_la_socuna_convo:addScreen(da_la_socuna_convo_tier2_has_mission)

-- Tier 2 training menu (options added dynamically by handler)
da_la_socuna_convo_tier2_training_menu = ConvoScreen:new {
	id = "tier2_training_menu",
	leftDialog = "@conversation/lok_rebel_trainer_2:s_4ee75073",
	stopConversation = "false",
	options = {}
}
da_la_socuna_convo:addScreen(da_la_socuna_convo_tier2_training_menu)

-- Tier 2 training results (handler grants the skill)
da_la_socuna_convo_tier2_train_fighters = ConvoScreen:new {
	id = "tier2_train_fighters",
	leftDialog = "@conversation/lok_rebel_trainer_2:s_5a954a3f",
	stopConversation = "true",
	options = {}
}
da_la_socuna_convo:addScreen(da_la_socuna_convo_tier2_train_fighters)

da_la_socuna_convo_tier2_train_component = ConvoScreen:new {
	id = "tier2_train_component",
	leftDialog = "@conversation/lok_rebel_trainer_2:s_5a954a3f",
	stopConversation = "true",
	options = {}
}
da_la_socuna_convo:addScreen(da_la_socuna_convo_tier2_train_component)

da_la_socuna_convo_tier2_train_basics = ConvoScreen:new {
	id = "tier2_train_basics",
	leftDialog = "@conversation/lok_rebel_trainer_2:s_5a954a3f",
	stopConversation = "true",
	options = {}
}
da_la_socuna_convo:addScreen(da_la_socuna_convo_tier2_train_basics)

da_la_socuna_convo_tier2_train_droid = ConvoScreen:new {
	id = "tier2_train_droid",
	leftDialog = "@conversation/lok_rebel_trainer_2:s_5a954a3f",
	stopConversation = "true",
	options = {}
}
da_la_socuna_convo:addScreen(da_la_socuna_convo_tier2_train_droid)

-- Tier 2 mission 1 (inspect)
da_la_socuna_convo_tier2_mission1_brief = ConvoScreen:new {
	id = "tier2_mission1_brief",
	leftDialog = "@conversation/lok_rebel_trainer_2:s_c91bccf0",
	stopConversation = "false",
	options = {
		{"@conversation/lok_rebel_trainer_2:s_359d1c6c", "tier2_accept_mission1"},
	}
}
da_la_socuna_convo:addScreen(da_la_socuna_convo_tier2_mission1_brief)

da_la_socuna_convo_tier2_accept_mission1 = ConvoScreen:new {
	id = "tier2_accept_mission1",
	leftDialog = "@conversation/lok_rebel_trainer_2:s_5ee66c06",
	stopConversation = "true",
	options = {}
}
da_la_socuna_convo:addScreen(da_la_socuna_convo_tier2_accept_mission1)

da_la_socuna_convo_tier2_mission1_rewarded = ConvoScreen:new {
	id = "tier2_mission1_rewarded",
	leftDialog = "@conversation/lok_rebel_trainer_2:s_71350221",
	stopConversation = "true",
	options = {}
}
da_la_socuna_convo:addScreen(da_la_socuna_convo_tier2_mission1_rewarded)

da_la_socuna_convo_tier2_failed_mission1 = ConvoScreen:new {
	id = "tier2_failed_mission1",
	leftDialog = "@conversation/lok_rebel_trainer_2:s_1eaa0d45",
	stopConversation = "true",
	options = {}
}
da_la_socuna_convo:addScreen(da_la_socuna_convo_tier2_failed_mission1)

-- Tier 2 mission 2 (escort)
da_la_socuna_convo_tier2_mission2_brief = ConvoScreen:new {
	id = "tier2_mission2_brief",
	leftDialog = "@conversation/lok_rebel_trainer_2:s_565951d5",
	stopConversation = "false",
	options = {
		{"@conversation/lok_rebel_trainer_2:s_80b2d7f9", "tier2_accept_mission2"},
	}
}
da_la_socuna_convo:addScreen(da_la_socuna_convo_tier2_mission2_brief)

da_la_socuna_convo_tier2_accept_mission2 = ConvoScreen:new {
	id = "tier2_accept_mission2",
	leftDialog = "@conversation/lok_rebel_trainer_2:s_2af8de7c",
	stopConversation = "true",
	options = {}
}
da_la_socuna_convo:addScreen(da_la_socuna_convo_tier2_accept_mission2)

da_la_socuna_convo_tier2_mission2_rewarded = ConvoScreen:new {
	id = "tier2_mission2_rewarded",
	leftDialog = "@conversation/lok_rebel_trainer_2:s_4af0c602",
	stopConversation = "true",
	options = {}
}
da_la_socuna_convo:addScreen(da_la_socuna_convo_tier2_mission2_rewarded)

da_la_socuna_convo_tier2_failed_mission2 = ConvoScreen:new {
	id = "tier2_failed_mission2",
	leftDialog = "@conversation/lok_rebel_trainer_2:s_1eaa0d45",
	stopConversation = "true",
	options = {}
}
da_la_socuna_convo:addScreen(da_la_socuna_convo_tier2_failed_mission2)

-- Tier 2 mission 3 (recovery)
da_la_socuna_convo_tier2_mission3_brief = ConvoScreen:new {
	id = "tier2_mission3_brief",
	leftDialog = "@conversation/lok_rebel_trainer_2:s_3ae0bba3",
	stopConversation = "false",
	options = {
		{"@conversation/lok_rebel_trainer_2:s_dce7fb", "tier2_accept_mission3"},
	}
}
da_la_socuna_convo:addScreen(da_la_socuna_convo_tier2_mission3_brief)

da_la_socuna_convo_tier2_accept_mission3 = ConvoScreen:new {
	id = "tier2_accept_mission3",
	leftDialog = "@conversation/lok_rebel_trainer_2:s_723b4288",
	stopConversation = "true",
	options = {}
}
da_la_socuna_convo:addScreen(da_la_socuna_convo_tier2_accept_mission3)

da_la_socuna_convo_tier2_mission3_rewarded = ConvoScreen:new {
	id = "tier2_mission3_rewarded",
	leftDialog = "@conversation/lok_rebel_trainer_2:s_9417b6d9",
	stopConversation = "true",
	options = {}
}
da_la_socuna_convo:addScreen(da_la_socuna_convo_tier2_mission3_rewarded)

da_la_socuna_convo_tier2_failed_mission3 = ConvoScreen:new {
	id = "tier2_failed_mission3",
	leftDialog = "@conversation/lok_rebel_trainer_2:s_1eaa0d45",
	stopConversation = "true",
	options = {}
}
da_la_socuna_convo:addScreen(da_la_socuna_convo_tier2_failed_mission3)

-- Tier 2 mission 4 (assassinate)
da_la_socuna_convo_tier2_mission4_brief = ConvoScreen:new {
	id = "tier2_mission4_brief",
	leftDialog = "@conversation/lok_rebel_trainer_2:s_75e5035c",
	stopConversation = "false",
	options = {
		{"@conversation/lok_rebel_trainer_2:s_9b2edf50", "tier2_accept_mission4"},
	}
}
da_la_socuna_convo:addScreen(da_la_socuna_convo_tier2_mission4_brief)

da_la_socuna_convo_tier2_accept_mission4 = ConvoScreen:new {
	id = "tier2_accept_mission4",
	leftDialog = "@conversation/lok_rebel_trainer_2:s_b24f64b",
	stopConversation = "true",
	options = {}
}
da_la_socuna_convo:addScreen(da_la_socuna_convo_tier2_accept_mission4)

da_la_socuna_convo_tier2_mission4_rewarded = ConvoScreen:new {
	id = "tier2_mission4_rewarded",
	leftDialog = "@conversation/lok_rebel_trainer_2:s_5164f707",
	stopConversation = "true",
	options = {}
}
da_la_socuna_convo:addScreen(da_la_socuna_convo_tier2_mission4_rewarded)

da_la_socuna_convo_tier2_failed_mission4 = ConvoScreen:new {
	id = "tier2_failed_mission4",
	leftDialog = "@conversation/lok_rebel_trainer_2:s_1eaa0d45",
	stopConversation = "true",
	options = {}
}
da_la_socuna_convo:addScreen(da_la_socuna_convo_tier2_failed_mission4)

-- All tier 2 skills earned, tier incremented
da_la_socuna_convo_tier2_completed = ConvoScreen:new {
	id = "tier2_completed",
	leftDialog = "@conversation/lok_rebel_trainer_2:s_5884fe0d",
	stopConversation = "true",
	options = {}
}
da_la_socuna_convo:addScreen(da_la_socuna_convo_tier2_completed)

--[[
	Tier 3 screens (authentic Live strings from string/en/conversation/tatooine_rebel_tier3.stf)
]]

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
	leftDialog = "@conversation/tatooine_rebel_tier4:s_1ec8846c",
	stopConversation = "false",
	options = {
		{"@conversation/tatooine_rebel_tier4:s_5bc07030", "tier4_first_mission"},
	}
}
da_la_socuna_convo:addScreen(da_la_socuna_convo_tier4_initial_briefing)

-- Tier 4 mission 1 (survival)
da_la_socuna_convo_tier4_first_mission = ConvoScreen:new {
	id = "tier4_first_mission",
	leftDialog = "@conversation/tatooine_rebel_tier4:s_ac30ef3",
	stopConversation = "false",
	options = {
		{"@conversation/tatooine_rebel_tier4:s_c1c9b365", "accept_tier4_first_mission"},
	}
}
da_la_socuna_convo:addScreen(da_la_socuna_convo_tier4_first_mission)

da_la_socuna_convo_accept_tier4_first_mission = ConvoScreen:new {
	id = "accept_tier4_first_mission",
	leftDialog = "@conversation/tatooine_rebel_tier4:s_a5b93c4d",
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

-- Tier 4 mission 2 (assassinate)
da_la_socuna_convo_tier4_second_mission = ConvoScreen:new {
	id = "tier4_second_mission",
	leftDialog = "@conversation/tatooine_rebel_tier4:s_b659eebb",
	stopConversation = "false",
	options = {
		{"@conversation/tatooine_rebel_tier4:s_bc57b086", "accept_tier4_second_mission"},
	}
}
da_la_socuna_convo:addScreen(da_la_socuna_convo_tier4_second_mission)

da_la_socuna_convo_accept_tier4_second_mission = ConvoScreen:new {
	id = "accept_tier4_second_mission",
	leftDialog = "@conversation/tatooine_rebel_tier4:s_a5b93c4d",
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
	leftDialog = "@conversation/tatooine_rebel_tier4:s_4b3f09bc",
	stopConversation = "false",
	options = {
		{"@conversation/tatooine_rebel_tier4:s_89951606", "accept_tier4_third_mission"},
	}
}
da_la_socuna_convo:addScreen(da_la_socuna_convo_tier4_third_mission)

da_la_socuna_convo_accept_tier4_third_mission = ConvoScreen:new {
	id = "accept_tier4_third_mission",
	leftDialog = "@conversation/tatooine_rebel_tier4:s_a5b93c4d",
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

-- Tier 4 mission 4 (recovery)
da_la_socuna_convo_tier4_fourth_mission = ConvoScreen:new {
	id = "tier4_fourth_mission",
	leftDialog = "@conversation/tatooine_rebel_tier4:s_c946f118",
	stopConversation = "false",
	options = {
		{"@conversation/tatooine_rebel_tier4:s_d0fd857b", "accept_tier4_fourth_mission"},
	}
}
da_la_socuna_convo:addScreen(da_la_socuna_convo_tier4_fourth_mission)

da_la_socuna_convo_accept_tier4_fourth_mission = ConvoScreen:new {
	id = "accept_tier4_fourth_mission",
	leftDialog = "@conversation/tatooine_rebel_tier4:s_a5b93c4d",
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
