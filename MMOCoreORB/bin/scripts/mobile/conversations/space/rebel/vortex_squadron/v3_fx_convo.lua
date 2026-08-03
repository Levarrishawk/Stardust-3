--[[
	V3-FX (droid) -- Vortex Squadron (Rebel) Tier 1 recruiter/trainer conversation.

	Structural port of the proven Inquisition recruiter template, driven by the
	authentic Live Rebel trainer string file extracted from the client TRE:
		string/en/conversation/naboo_rebel_trainer_1.stf
	Every leftDialog / option below references a real @conversation/naboo_rebel_trainer_1:s_<hash>
	string from that table (English text shown in the trailing comment, verified against the
	extracted STF). Screen-flow control lives in v3fxConvoHandler.lua.

	Quest ladder follows the real V3-FX storyline told by the STF:
		Q1 patrol (four-point sensor patrol above Naboo) ->
		Q2 destroy (revenge: four TIE fighters) ->
		Q3 patrol again (cover the compromised Alliance supply route) ->
		Q4 assassinate (the veteran TIE fighter ace) ->
		training -> report to Brother Vrovel on Dantooine.

	Every option link target below is a defined screen (the base conv_handler falls back to
	the initial screen when a link target is missing, which presents as "clicking does nothing").
]]

v3_fx_convo = ConvoTemplate:new {
	initialScreen = "",
	templateType = "Lua",
	luaClassHandler = "v3fxConvoHandler",
	screens = {}
}

-- JTL Disabled / No Space Expansion
v3_fx_convo_no_jtl = ConvoScreen:new {
	id = "no_jtl",
	leftDialog = "@conversation/naboo_rebel_trainer_1:s_eedd7284", -- Greeting, Sir.  Ma'am?  Pardon me.  I'm terribly sorry.  I cannot help you with that.  *bzzt*
	stopConversation = "true",
	options = {}
}
v3_fx_convo:addScreen(v3_fx_convo_no_jtl)

-- Imperial Pilot (opposing faction, turned away)
v3_fx_convo_imperial_pilot = ConvoScreen:new {
	id = "imperial_pilot",
	leftDialog = "@conversation/naboo_rebel_trainer_1:s_3fc246bd", -- Error.  You have been grounded by Alliance HQ.  There are serious accusations against you... Working for the E
	stopConversation = "true",
	animation = "point_accusingly",
	options = {}
}
v3_fx_convo:addScreen(v3_fx_convo_imperial_pilot)

-- Neutral/Privateer Pilot (turned away)
v3_fx_convo_neutral_pilot = ConvoScreen:new {
	id = "neutral_pilot",
	leftDialog = "@conversation/naboo_rebel_trainer_1:s_466afe42", -- Forgive me. I am not authorized to assign missions to you. Perhaps you should speak with your commanding offic
	stopConversation = "true",
	animation = "shrug_shoulders",
	options = {}
}
v3_fx_convo:addScreen(v3_fx_convo_neutral_pilot)

-- Rebel pilot, different squadron
v3_fx_convo_non_inquisition_pilot = ConvoScreen:new {
	id = "non_inquisition_pilot",
	leftDialog = "@conversation/naboo_rebel_trainer_1:s_8c6a4b66", -- Oh. You are an Alliance pilot, but I do not recognize you. How may I be of service?
	stopConversation = "false",
	options = {
		{"@conversation/naboo_rebel_trainer_1:s_4ffd4b9d", "duty_missions"}, -- I am interested in a duty mission.
	}
}
v3_fx_convo:addScreen(v3_fx_convo_non_inquisition_pilot)

--[[ Recruitment flow ]]
v3_fx_convo_recruitment = ConvoScreen:new {
	id = "recruitment",
	leftDialog = "@conversation/naboo_rebel_trainer_1:s_cd448c20", -- Greetings. I am V3-FX, Alliance Pilot Relations. May I interest you in our starfighter training program?
	stopConversation = "false",
	options = {
		{"@conversation/naboo_rebel_trainer_1:s_fb1c19c1", "yes_join"}, -- I want training!
		{"@conversation/naboo_rebel_trainer_1:s_99dfe276", "why_volunteers"}, -- Interested? Is there money in it?
		{"@conversation/naboo_rebel_trainer_1:s_1df40ac6", "decline_join"}, -- Goodbye, V3.
	}
}
v3_fx_convo:addScreen(v3_fx_convo_recruitment)

v3_fx_convo_why_volunteers = ConvoScreen:new {
	id = "why_volunteers",
	leftDialog = "@conversation/naboo_rebel_trainer_1:s_9ba2e5e1", -- There is a measure of monetary compensation for your efforts. Honestly, most pilots fly because they feel it i
	stopConversation = "false",
	options = {
		{"@conversation/naboo_rebel_trainer_1:s_104b565a", "yes_join"}, -- Well, I'll join anyway.
		{"@conversation/naboo_rebel_trainer_1:s_1df40ac6", "decline_join"}, -- Goodbye, V3.
	}
}
v3_fx_convo:addScreen(v3_fx_convo_why_volunteers)

v3_fx_convo_decline_join = ConvoScreen:new {
	id = "decline_join",
	leftDialog = "@conversation/naboo_rebel_trainer_1:s_41e49ae6", -- Good day to you, then.
	stopConversation = "true",
	animation = "goodbye",
	options = {}
}
v3_fx_convo:addScreen(v3_fx_convo_decline_join)

-- Player asked to join; the handler redirects this to "join_confirm". Defined with the
-- same content as join_confirm so the flow is intact even without the handler redirect.
v3_fx_convo_yes_join = ConvoScreen:new {
	id = "yes_join",
	leftDialog = "@conversation/naboo_rebel_trainer_1:s_a9a1aa2a", -- Wonderful! I will teach you to fly starfighters in exchange for your loyalty to the Alliance, and your full wi
	stopConversation = "false",
	options = {
		{"@conversation/naboo_rebel_trainer_1:s_7ed5fec3", "yes_i_am"}, -- I want to be part of the Alliance.
		{"@conversation/naboo_rebel_trainer_1:s_1df40ac6", "decline_join"}, -- Goodbye, V3.
	}
}
v3_fx_convo:addScreen(v3_fx_convo_yes_join)

-- Sign-up confirmation (handler routes "yes_join" here)
v3_fx_convo_join_confirm = ConvoScreen:new {
	id = "join_confirm",
	leftDialog = "@conversation/naboo_rebel_trainer_1:s_a9a1aa2a", -- Wonderful! I will teach you to fly starfighters in exchange for your loyalty to the Alliance, and your full wi
	stopConversation = "false",
	options = {
		{"@conversation/naboo_rebel_trainer_1:s_7ed5fec3", "yes_i_am"}, -- I want to be part of the Alliance.
		{"@conversation/naboo_rebel_trainer_1:s_1df40ac6", "decline_join"}, -- Goodbye, V3.
	}
}
v3_fx_convo:addScreen(v3_fx_convo_join_confirm)

-- Enlistment/welcome (handler grants novice box + squadron + tier here, then adds the ship option)
v3_fx_convo_yes_i_am = ConvoScreen:new {
	id = "yes_i_am",
	leftDialog = "@conversation/naboo_rebel_trainer_1:s_6cc94470", -- In that case, I welcome you to the Rebel Alliance pilot training program.
	stopConversation = "false",
	options = {}
}
v3_fx_convo:addScreen(v3_fx_convo_yes_i_am)

-- No Ship - grants ship
v3_fx_convo_no_ship = ConvoScreen:new {
	id = "no_ship",
	leftDialog = "@conversation/naboo_rebel_trainer_1:s_909a1feb", -- You will need a ship, in order to be a pilot.  I will add the control codes to your datapad for a simple Z95.
	stopConversation = "false",
	animation = "nod_head_multiple",
	options = {
		{"@conversation/naboo_rebel_trainer_1:s_b04f2893", "yes_im_ready"}, -- Yes. I am ready.
	}
}
v3_fx_convo:addScreen(v3_fx_convo_no_ship)

v3_fx_convo_yes_ship = ConvoScreen:new {
	id = "yes_ship",
	leftDialog = "@conversation/naboo_rebel_trainer_1:s_52fb0136", -- You are most welcome. Are you ready for your first assignment?
	stopConversation = "false",
	options = {
		{"@conversation/naboo_rebel_trainer_1:s_b04f2893", "yes_im_ready"}, -- Yes. I am ready.
	}
}
v3_fx_convo:addScreen(v3_fx_convo_yes_ship)

--[[ Tier 1 -- Mission 1: Patrol (handler starts patrol_naboo_rebel_1 on "yes_im_ready") ]]
v3_fx_convo_yes_im_ready = ConvoScreen:new {
	id = "yes_im_ready",
	leftDialog = "@conversation/naboo_rebel_trainer_1:s_748d90dd", -- Glorious! Your first mission is a short-range, four-point patrol. When you return, your ship's sensor data wil
	stopConversation = "true",
	options = {}
}
v3_fx_convo:addScreen(v3_fx_convo_yes_im_ready)

-- Player is on quest 1 and returns before completing it
v3_fx_convo_first_quest_active = ConvoScreen:new {
	id = "first_quest_active",
	leftDialog = "@conversation/naboo_rebel_trainer_1:s_e6a9899d", -- You must go to the starport in order to begin your assignment. It's just over there - on the other side of the
	stopConversation = "true",
	options = {}
}
v3_fx_convo:addScreen(v3_fx_convo_first_quest_active)

-- Quest 1 complete, player reports in (handler rewards on "patrol_complete")
v3_fx_convo_excellent_work = ConvoScreen:new {
	id = "excellent_work",
	leftDialog = "@conversation/naboo_rebel_trainer_1:s_f14340ef", -- Thank goodness you've returned in one piece! How was your first mission?
	stopConversation = "false",
	options = {
		{"@conversation/naboo_rebel_trainer_1:s_85fcdc55", "patrol_complete"}, -- Fighters attacked me!
		{"@conversation/naboo_rebel_trainer_1:s_73edb45", "patrol_complete"}, -- They fought well, but I fought better.
	}
}
v3_fx_convo:addScreen(v3_fx_convo_excellent_work)

v3_fx_convo_patrol_complete = ConvoScreen:new {
	id = "patrol_complete",
	leftDialog = "@conversation/naboo_rebel_trainer_1:s_36fa01ee", -- We will need a short while to decode and interpret your starship sensor data. In the meantime, there is more w
	stopConversation = "true",
	options = {}
}
v3_fx_convo:addScreen(v3_fx_convo_patrol_complete)

-- Quest 1 failed/aborted
v3_fx_convo_failed_quest1 = ConvoScreen:new {
	id = "failed_quest1",
	leftDialog = "@conversation/naboo_rebel_trainer_1:s_f4d0e976", -- The Alliance HQ computer system is rather disappointed with your performance. I have been instructed to renew
	stopConversation = "false",
	options = {
		{"@conversation/naboo_rebel_trainer_1:s_b04f2893", "retry_quest1"}, -- Yes. I am ready.
	}
}
v3_fx_convo:addScreen(v3_fx_convo_failed_quest1)

-- Quest 1 retry acknowledged (handler restarts patrol_naboo_rebel_1)
v3_fx_convo_retry_quest1 = ConvoScreen:new {
	id = "retry_quest1",
	leftDialog = "@conversation/naboo_rebel_trainer_1:s_4d3c3acd", -- You will fly a four-point patrol above Naboo. We will need your ship's sensor data when you are finished.
	stopConversation = "true",
	options = {}
}
v3_fx_convo:addScreen(v3_fx_convo_retry_quest1)

--[[ Tier 1 -- Mission 2: Destroy (handler starts destroy_naboo_rebel_2 on "quest2_accepted") ]]
v3_fx_convo_grant_quest2 = ConvoScreen:new {
	id = "grant_quest2",
	leftDialog = "@conversation/naboo_rebel_trainer_1:s_fb2ee4e7", -- Not so fast, %TU.  There'll be time for training later.  Right now we need you to do another assignment.  I ho
	stopConversation = "false",
	options = {
		{"@conversation/naboo_rebel_trainer_1:s_6fb5a316", "quest2_accepted"}, -- I am more than ready.
	}
}
v3_fx_convo:addScreen(v3_fx_convo_grant_quest2)

v3_fx_convo_quest2_accepted = ConvoScreen:new {
	id = "quest2_accepted",
	leftDialog = "@conversation/naboo_rebel_trainer_1:s_314a123f", -- That is good to hear. Let's have some revenge on the Empire. Find four of their puny TIE fighters in the Naboo
	stopConversation = "true",
	options = {}
}
v3_fx_convo:addScreen(v3_fx_convo_quest2_accepted)

-- Quest 2 rewarded; the decoded sensor data leads into Mission 3 (supply-route patrol).
-- Must NOT be a dead-end stop screen: the handler starts quest 3 on screen id "train_me3".
v3_fx_convo_excellent_work2 = ConvoScreen:new {
	id = "excellent_work2",
	leftDialog = "@conversation/naboo_rebel_trainer_1:s_b0047226", -- We have decoded your starship sensor data... and we have bad news. The planned Alliance supply route has been
	stopConversation = "false",
	options = {
		{"@conversation/naboo_rebel_trainer_1:s_f8b02865", "train_me3"}, -- What do I do?
		{"@conversation/naboo_rebel_trainer_1:s_a66ff602", "train_me3"}, -- Our transports could use my help.
	}
}
v3_fx_convo:addScreen(v3_fx_convo_excellent_work2)

-- Mission 3 accepted (handler starts patrol_naboo_rebel_3 on "train_me3")
v3_fx_convo_train_me3 = ConvoScreen:new {
	id = "train_me3",
	leftDialog = "@conversation/naboo_rebel_trainer_1:s_9757e73a", -- You'll be covering a little-used Alliance supply route. It's become more important in recent days because of I
	stopConversation = "true",
	options = {}
}
v3_fx_convo:addScreen(v3_fx_convo_train_me3)

v3_fx_convo_failed_quest2 = ConvoScreen:new {
	id = "failed_quest2",
	leftDialog = "@conversation/naboo_rebel_trainer_1:s_b1ab42f0", -- Alliance HQ has requested that I assign a new mission to you... since you have failed the previous. Good luck!
	stopConversation = "false",
	options = {
		{"@conversation/naboo_rebel_trainer_1:s_b04f2893", "retry_quest2"}, -- Yes. I am ready.
	}
}
v3_fx_convo:addScreen(v3_fx_convo_failed_quest2)

-- Quest 2 retry acknowledged (handler restarts destroy_naboo_rebel_2)
v3_fx_convo_retry_quest2 = ConvoScreen:new {
	id = "retry_quest2",
	leftDialog = "@conversation/naboo_rebel_trainer_1:s_d9c6f8a5", -- Four or more will do quite nicely. Focus on the TIE fighters. They are critical to the Empire's operations in
	stopConversation = "true",
	options = {}
}
v3_fx_convo:addScreen(v3_fx_convo_retry_quest2)

--[[ Tier 1 -- Mission 3 report (handler grants the reward on "quest3_rewarded") ]]
v3_fx_convo_excellent_work3 = ConvoScreen:new {
	id = "excellent_work3",
	leftDialog = "@conversation/naboo_rebel_trainer_1:s_7ad400bc", -- Alliance command is impressed with your courage, pilot! The main computer specifically mentioned your ability
	stopConversation = "false",
	options = {
		{"@conversation/naboo_rebel_trainer_1:s_fc27931b", "quest3_rewarded"}, -- Thanks.
		{"@conversation/naboo_rebel_trainer_1:s_f1c5717b", "quest3_rewarded"}, -- I am quite certain the Alliance appreciates it, as well!
	}
}
v3_fx_convo:addScreen(v3_fx_convo_excellent_work3)

-- Quest 3 reward acknowledged. Must be a stop screen with NO options: an option into
-- "train_me3" here would re-start quest 3 after it has already been rewarded.
v3_fx_convo_quest3_rewarded = ConvoScreen:new {
	id = "quest3_rewarded",
	leftDialog = "@conversation/naboo_rebel_trainer_1:s_cd4363b6", -- You are welcome, pilot!  As a bonus:  I've had a flightsuit made for you.
	stopConversation = "true",
	options = {}
}
v3_fx_convo:addScreen(v3_fx_convo_quest3_rewarded)

v3_fx_convo_failed_quest3 = ConvoScreen:new {
	id = "failed_quest3",
	leftDialog = "@conversation/naboo_rebel_trainer_1:s_c7626ea8", -- I have been ordered to reassign a mission to you. The mission you most recently failed. My apologies. And... g
	stopConversation = "false",
	options = {
		{"@conversation/naboo_rebel_trainer_1:s_b04f2893", "retry_quest3"}, -- Yes. I am ready.
	}
}
v3_fx_convo:addScreen(v3_fx_convo_failed_quest3)

-- Quest 3 retry acknowledged (handler restarts patrol_naboo_rebel_3)
v3_fx_convo_retry_quest3 = ConvoScreen:new {
	id = "retry_quest3",
	leftDialog = "@conversation/naboo_rebel_trainer_1:s_9757e73a", -- You'll be covering a little-used Alliance supply route. It's become more important in recent days because of I
	stopConversation = "true",
	options = {}
}
v3_fx_convo:addScreen(v3_fx_convo_retry_quest3)

--[[ Tier 1 -- Mission 4: Assassinate the veteran TIE ace (handler starts assassinate_naboo_rebel_4 on "quest4_accepted") ]]
v3_fx_convo_grant_quest4 = ConvoScreen:new {
	id = "grant_quest4",
	leftDialog = "@conversation/naboo_rebel_trainer_1:s_999f2284", -- While you were away, we discovered some information that will break the back of the Empire's fleet movements h
	stopConversation = "false",
	options = {
		{"@conversation/naboo_rebel_trainer_1:s_6a150013", "quest4_accepted"}, -- Let's have some details.
	}
}
v3_fx_convo:addScreen(v3_fx_convo_grant_quest4)

v3_fx_convo_quest4_accepted = ConvoScreen:new {
	id = "quest4_accepted",
	leftDialog = "@conversation/naboo_rebel_trainer_1:s_74163bd7", -- Destroy the veteran TIE pilot leader at a specific rally point. You will receive the waypoint data once you ar
	stopConversation = "true",
	options = {}
}
v3_fx_convo:addScreen(v3_fx_convo_quest4_accepted)

v3_fx_convo_failed_quest4 = ConvoScreen:new {
	id = "failed_quest4",
	leftDialog = "@conversation/naboo_rebel_trainer_1:s_54d18017", -- Alliance HQ demands that you rejoin battle against the TIE Veteran so that our campaign may move forward. Good
	stopConversation = "false",
	options = {
		{"@conversation/naboo_rebel_trainer_1:s_b04f2893", "retry_quest4"}, -- Yes. I am ready.
	}
}
v3_fx_convo:addScreen(v3_fx_convo_failed_quest4)

-- Quest 4 retry acknowledged (handler restarts assassinate_naboo_rebel_4)
v3_fx_convo_retry_quest4 = ConvoScreen:new {
	id = "retry_quest4",
	leftDialog = "@conversation/naboo_rebel_trainer_1:s_ee82c4c3", -- It should not be difficult. He should be one of very few veteran TIE fighter pilots in this vicinity.
	stopConversation = "true",
	options = {}
}
v3_fx_convo:addScreen(v3_fx_convo_retry_quest4)

--[[ Player has an active (non-first) mission ]]
v3_fx_convo_has_mission = ConvoScreen:new {
	id = "has_mission",
	leftDialog = "@conversation/naboo_rebel_trainer_1:s_e31d65b7", -- The duty logs indicate that you are in mid-mission. We have nothing to discuss until you are finished.
	stopConversation = "true",
	options = {}
}
v3_fx_convo:addScreen(v3_fx_convo_has_mission)

--[[ All four Tier-1 missions complete -> free training choices (handler builds options) ]]
v3_fx_convo_missions_complete = ConvoScreen:new {
	id = "missions_complete",
	leftDialog = "@conversation/naboo_rebel_trainer_1:s_6f3e9d4b", -- You have performed wonderfully! Alliance HQ has authorized me to provide your first starship training module.
	stopConversation = "false",
	options = {}
}
v3_fx_convo:addScreen(v3_fx_convo_missions_complete)

--[[ Additional (XP-gated) training (handler builds options) ]]
v3_fx_convo_more_training = ConvoScreen:new {
	id = "more_training",
	leftDialog = "@conversation/naboo_rebel_trainer_1:s_838cca30", -- Greetings, pilot. You are performing exceptionally well! It would be my pleasure to provide any further traini
	stopConversation = "false",
	options = {}
}
v3_fx_convo:addScreen(v3_fx_convo_more_training)

-- training acknowledgement screens (handler grants the skill then returns the cloned screen)
v3_fx_convo_train_player_fighters = ConvoScreen:new {
	id = "train_player_fighters",
	leftDialog = "@conversation/naboo_rebel_trainer_1:s_c010439f", -- Splendid!
	stopConversation = "true",
	options = {}
}
v3_fx_convo:addScreen(v3_fx_convo_train_player_fighters)

v3_fx_convo_train_player_component = ConvoScreen:new {
	id = "train_player_component",
	leftDialog = "@conversation/naboo_rebel_trainer_1:s_c5dca41d", -- Splendid! You are now rated for more powerful components. Use them well!
	stopConversation = "true",
	options = {}
}
v3_fx_convo:addScreen(v3_fx_convo_train_player_component)

v3_fx_convo_train_player_basics = ConvoScreen:new {
	id = "train_player_basics",
	leftDialog = "@conversation/naboo_rebel_trainer_1:s_145a9b15", -- Of course! I have removed the code-lock on your procedures manual. Secret techniques are now available to you.
	stopConversation = "true",
	options = {}
}
v3_fx_convo:addScreen(v3_fx_convo_train_player_basics)

v3_fx_convo_train_player_droid = ConvoScreen:new {
	id = "train_player_droid",
	leftDialog = "@conversation/naboo_rebel_trainer_1:s_8062b983", -- How noble of you, sir! Droid programming is a critical skill for the Alliance pilot.
	stopConversation = "true",
	options = {}
}
v3_fx_convo:addScreen(v3_fx_convo_train_player_droid)

-- free-training variants (same acknowledgement strings)
v3_fx_convo_train_player_fighters_free = ConvoScreen:new {
	id = "train_player_fighters_free",
	leftDialog = "@conversation/naboo_rebel_trainer_1:s_c010439f", -- Splendid!
	stopConversation = "true",
	options = {}
}
v3_fx_convo:addScreen(v3_fx_convo_train_player_fighters_free)

v3_fx_convo_train_player_component_free = ConvoScreen:new {
	id = "train_player_component_free",
	leftDialog = "@conversation/naboo_rebel_trainer_1:s_c5dca41d", -- Splendid! You are now rated for more powerful components. Use them well!
	stopConversation = "true",
	options = {}
}
v3_fx_convo:addScreen(v3_fx_convo_train_player_component_free)

v3_fx_convo_train_player_basics_free = ConvoScreen:new {
	id = "train_player_basics_free",
	leftDialog = "@conversation/naboo_rebel_trainer_1:s_145a9b15", -- Of course! I have removed the code-lock on your procedures manual. Secret techniques are now available to you.
	stopConversation = "true",
	options = {}
}
v3_fx_convo:addScreen(v3_fx_convo_train_player_basics_free)

v3_fx_convo_train_player_droid_free = ConvoScreen:new {
	id = "train_player_droid_free",
	leftDialog = "@conversation/naboo_rebel_trainer_1:s_8062b983", -- How noble of you, sir! Droid programming is a critical skill for the Alliance pilot.
	stopConversation = "true",
	options = {}
}
v3_fx_convo:addScreen(v3_fx_convo_train_player_droid_free)

--[[ Duty missions (Tier-1 grind: destroy / escort duty) ]]
v3_fx_convo_duty_missions = ConvoScreen:new {
	id = "duty_missions",
	leftDialog = "@conversation/naboo_rebel_trainer_1:s_dfc3b1e1", -- Of course. I am authorized to assign a selection of combat duty missions to you. Would you like to perform a d
	stopConversation = "false",
	options = {
		{"@conversation/naboo_rebel_trainer_1:s_7a27e11", "destroy_duty"}, -- I'll blast any Imperial crosses my path!
		{"@conversation/naboo_rebel_trainer_1:s_a66ff602", "escort_duty"}, -- Our transports could use my help.
		{"@conversation/naboo_rebel_trainer_1:s_6106187c", "what_is_duty"}, -- What is a duty mission?
	}
}
v3_fx_convo:addScreen(v3_fx_convo_duty_missions)

v3_fx_convo_what_is_duty = ConvoScreen:new {
	id = "what_is_duty",
	leftDialog = "@conversation/naboo_rebel_trainer_1:s_96184c1", -- A duty mission is an excellent way of earning experience towards your next training session. No good trainer w
	stopConversation = "false",
	options = {
		{"@conversation/naboo_rebel_trainer_1:s_7a27e11", "destroy_duty"}, -- I'll blast any Imperial crosses my path!
		{"@conversation/naboo_rebel_trainer_1:s_a66ff602", "escort_duty"}, -- Our transports could use my help.
	}
}
v3_fx_convo:addScreen(v3_fx_convo_what_is_duty)

-- Duty accepted (handler starts destroy_duty_naboo_rebel_6)
v3_fx_convo_destroy_duty = ConvoScreen:new {
	id = "destroy_duty",
	leftDialog = "@conversation/naboo_rebel_trainer_1:s_ca5e8b8b", -- Affirmative, sir. I have placed your ID on the duty roster. You are free to sweep and clear Imperial warships
	stopConversation = "true",
	options = {}
}
v3_fx_convo:addScreen(v3_fx_convo_destroy_duty)

-- Duty accepted (handler starts escort_duty_naboo_rebel_7)
v3_fx_convo_escort_duty = ConvoScreen:new {
	id = "escort_duty",
	leftDialog = "@conversation/naboo_rebel_trainer_1:s_6c399378", -- Agreed! I will put your ID on the escort duty roster. You can return to the ground at any time when you feel t
	stopConversation = "true",
	options = {}
}
v3_fx_convo:addScreen(v3_fx_convo_escort_duty)

-- recruitment_not_imperial (player is Rebel-aligned but not yet a pilot)
v3_fx_convo_recruitment_not_imperial = ConvoScreen:new {
	id = "recruitment_not_imperial",
	leftDialog = "@conversation/naboo_rebel_trainer_1:s_cca63822", -- What a fortunate coincidence! I am able to induct you to the Alliance pilot training course immediately - prov
	stopConversation = "false",
	options = {
		{"@conversation/naboo_rebel_trainer_1:s_7ed5fec3", "yes_join"}, -- I want to be part of the Alliance.
		{"@conversation/naboo_rebel_trainer_1:s_1df40ac6", "decline_join"}, -- Goodbye, V3.
	}
}
v3_fx_convo:addScreen(v3_fx_convo_recruitment_not_imperial)

--[[ Tier 1 complete -> reassigned to Brother Vrovel of the Vortex group (Dantooine) ]]
v3_fx_convo_completed_sinkko = ConvoScreen:new {
	id = "completed_sinkko",
	leftDialog = "@conversation/naboo_rebel_trainer_1:s_2e5c9032", -- Congratulations, pilot! You have successfully completed the first tier of the Alliance starfighter training pr
	stopConversation = "false",
	options = {
		{"@conversation/naboo_rebel_trainer_1:s_4efbdbfa", "what_is_inquisition"}, -- What is 'Vortex?'
		{"@conversation/naboo_rebel_trainer_1:s_60c4f974", "report_to_fazoll"}, -- Where do I go?
	}
}
v3_fx_convo:addScreen(v3_fx_convo_completed_sinkko)

v3_fx_convo_what_is_inquisition = ConvoScreen:new {
	id = "what_is_inquisition",
	leftDialog = "@conversation/naboo_rebel_trainer_1:s_7a4f9992", -- Unfortunately, I have very little information on the Vortex group. Alliance HQ indicates that they are a frien
	stopConversation = "false",
	options = {
		{"@conversation/naboo_rebel_trainer_1:s_8334632", "report_to_fazoll"}, -- Where do I find this Brother Vrovel?
	}
}
v3_fx_convo:addScreen(v3_fx_convo_what_is_inquisition)

-- Reassignment: grant waypoint to Brother Vrovel (handler sets v3fx_finished + waypoint)
v3_fx_convo_report_to_fazoll = ConvoScreen:new {
	id = "report_to_fazoll",
	leftDialog = "@conversation/naboo_rebel_trainer_1:s_4063c2da", -- You must go to planet Dantooine and meet with Brother Vrovel, leader of the Vortex organization. He's located
	stopConversation = "true",
	options = {}
}
v3_fx_convo:addScreen(v3_fx_convo_report_to_fazoll)

-- Player already reassigned, returns to V3-FX
v3_fx_convo_go_to_next = ConvoScreen:new {
	id = "go_to_next",
	leftDialog = "@conversation/naboo_rebel_trainer_1:s_b7b55289", -- Hello there! It is good to see you, although I believe you are supposed to be on planet Dantooine... correct?
	stopConversation = "true",
	options = {}
}
v3_fx_convo:addScreen(v3_fx_convo_go_to_next)

addConversationTemplate("v3_fx_convo", v3_fx_convo);
