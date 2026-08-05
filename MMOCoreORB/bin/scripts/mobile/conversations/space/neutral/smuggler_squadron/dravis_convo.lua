--[[
	Dravis -- Smuggler Alliance Squadron (Neutral) Tier 1 recruiter/trainer conversation.

	Structural port of the proven Inquisition recruiter template, driven by the
	authentic Live neutral/privateer trainer string file extracted from the client TRE:
		string/en/conversation/tatooine_privateer_trainer_1.stf
	Every leftDialog / option below references a real @conversation/tatooine_privateer_trainer_1:s_<hash>
	string from that table (English text shown in the trailing comment, verified against the
	extracted STF). Screen-flow control lives in dravisConvoHandler.lua.

	Quest ladder follows the real privateer storyline told by the STF:
		Q1 patrol (missing shipments) -> Q2 destroy (Black Sun pirates) ->
		Q3 patrol again (more Black Sun) -> Q4 assassinate (the Black Sun ace) ->
		training -> report to Talon Karrde.

	Every option link target below is a defined screen (the base conv_handler falls back to
	the initial screen when a link target is missing, which presents as "clicking does nothing").
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
	leftDialog = "@conversation/tatooine_privateer_trainer_1:s_c30fda16", -- Don't you have something you should be doing right now?
	stopConversation = "true",
	options = {}
}
dravis_convo:addScreen(dravis_convo_no_jtl)

-- Imperial Pilot (turned away)
dravis_convo_imperial_pilot = ConvoScreen:new {
	id = "imperial_pilot",
	leftDialog = "@conversation/tatooine_privateer_trainer_1:s_49a60ce1", -- I don't want any trouble, Imperial. Why don't you go harass someone else?
	stopConversation = "true",
	animation = "point_accusingly",
	options = {}
}
dravis_convo:addScreen(dravis_convo_imperial_pilot)

-- Rebel Pilot (turned away)
dravis_convo_rebel_pilot = ConvoScreen:new {
	id = "rebel_pilot",
	leftDialog = "@conversation/tatooine_privateer_trainer_1:s_35047e82", -- Look, no offense, but I could get in big trouble with the Smugglers Alliance if I started just handing out missions...
	stopConversation = "true",
	animation = "shrug_shoulders",
	options = {}
}
dravis_convo:addScreen(dravis_convo_rebel_pilot)

-- Neutral pilot, different squadron
dravis_convo_non_inquisition_pilot = ConvoScreen:new {
	id = "non_inquisition_pilot",
	leftDialog = "@conversation/tatooine_privateer_trainer_1:s_20df70f7", -- Hey, I've heard of you! Not a bad pilot, as I understand it. What can I do for you?
	stopConversation = "false",
	options = {
		{"@conversation/tatooine_privateer_trainer_1:s_c1ff5062", "duty_missions"}, -- I'm looking for a mission. Do you have any?
	}
}
dravis_convo:addScreen(dravis_convo_non_inquisition_pilot)

--[[ Recruitment flow ]]
dravis_convo_recruitment = ConvoScreen:new {
	id = "recruitment",
	leftDialog = "@conversation/tatooine_privateer_trainer_1:s_d60a3e3", -- Oh you do, huh? Well what do I look like, a flight instructor? Go join the Imperial Academy if you want to learn how to fly.
	stopConversation = "false",
	options = {
		{"@conversation/tatooine_privateer_trainer_1:s_6d273b75", "yes_join"}, -- Will you train me?
		{"@conversation/tatooine_privateer_trainer_1:s_381dd7dd", "why_volunteers"}, -- How much is this going to cost?
		{"@conversation/tatooine_privateer_trainer_1:s_2883b989", "decline_join"}, -- Not right now, thanks.
	}
}
dravis_convo:addScreen(dravis_convo_recruitment)

dravis_convo_why_volunteers = ConvoScreen:new {
	id = "why_volunteers",
	leftDialog = "@conversation/tatooine_privateer_trainer_1:s_62f16f7a", -- Well, training like this, it's worth its weight in spice. And I hope you don't think you're going to turn into an ace spacer overnight! Tell you what:
	stopConversation = "false",
	options = {
		{"@conversation/tatooine_privateer_trainer_1:s_940e1e78", "yes_join"}, -- I want to join.
		{"@conversation/tatooine_privateer_trainer_1:s_2883b989", "decline_join"}, -- Not right now, thanks.
	}
}
dravis_convo:addScreen(dravis_convo_why_volunteers)

dravis_convo_decline_join = ConvoScreen:new {
	id = "decline_join",
	leftDialog = "@conversation/tatooine_privateer_trainer_1:s_41e93b9e", -- Perhaps some other time, then.
	stopConversation = "true",
	animation = "goodbye",
	options = {}
}
dravis_convo:addScreen(dravis_convo_decline_join)

-- Player asked to join; the handler redirects this to "join_confirm". Defined with the
-- same content as join_confirm so the flow is intact even without the handler redirect.
dravis_convo_yes_join = ConvoScreen:new {
	id = "yes_join",
	leftDialog = "@conversation/tatooine_privateer_trainer_1:s_aa69d394", -- I suppose we could work something out. But you're going to owe me! And you'll need your own ship! I can't supply every wannabe freighter bum.
	stopConversation = "false",
	options = {
		{"@conversation/tatooine_privateer_trainer_1:s_ebe2e111", "yes_i_am"}, -- It's a deal.
		{"@conversation/tatooine_privateer_trainer_1:s_2883b989", "decline_join"}, -- Not right now, thanks.
	}
}
dravis_convo:addScreen(dravis_convo_yes_join)

-- Sign-up confirmation (handler routes "yes_join" here)
dravis_convo_join_confirm = ConvoScreen:new {
	id = "join_confirm",
	leftDialog = "@conversation/tatooine_privateer_trainer_1:s_aa69d394", -- I suppose we could work something out. But you're going to owe me! And you'll need your own ship! I can't supply every wannabe freighter bum.
	stopConversation = "false",
	options = {
		{"@conversation/tatooine_privateer_trainer_1:s_ebe2e111", "yes_i_am"}, -- It's a deal.
		{"@conversation/tatooine_privateer_trainer_1:s_2883b989", "decline_join"}, -- Not right now, thanks.
	}
}
dravis_convo:addScreen(dravis_convo_join_confirm)

-- Enlistment/welcome (handler grants novice box + squadron + tier here, then adds the ship option)
dravis_convo_yes_i_am = ConvoScreen:new {
	id = "yes_i_am",
	leftDialog = "@conversation/tatooine_privateer_trainer_1:s_807f6dd0", -- Ok, I'll let Talon Karrde know we've got a new employee. Are you ready for your first assignment?
	stopConversation = "false",
	options = {}
}
dravis_convo:addScreen(dravis_convo_yes_i_am)

-- No Ship - grants ship
dravis_convo_no_ship = ConvoScreen:new {
	id = "no_ship",
	leftDialog = "@conversation/tatooine_privateer_trainer_1:s_ce52ddaa", -- You're going to need a ship if you plan on doing anything constructive around here. I'll add the control codes...
	stopConversation = "false",
	animation = "nod_head_multiple",
	options = {
		{"@conversation/tatooine_privateer_trainer_1:s_1adbadc4", "yes_im_ready"}, -- I'm ready.
	}
}
dravis_convo:addScreen(dravis_convo_no_ship)

dravis_convo_yes_ship = ConvoScreen:new {
	id = "yes_ship",
	leftDialog = "@conversation/tatooine_privateer_trainer_1:s_807f6dd0", -- Ok, I'll let Talon Karrde know we've got a new employee. Are you ready for your first assignment?
	stopConversation = "false",
	options = {
		{"@conversation/tatooine_privateer_trainer_1:s_1adbadc4", "yes_im_ready"}, -- I'm ready.
	}
}
dravis_convo:addScreen(dravis_convo_yes_ship)

--[[ Tier 1 -- Mission 1: Patrol (handler starts patrol_tatooine_privateer_1) ]]
dravis_convo_yes_im_ready = ConvoScreen:new {
	id = "yes_im_ready",
	leftDialog = "@conversation/tatooine_privateer_trainer_1:s_95df6b05", -- Some of our shipments have come up missing. We suspect foul play... Why don't you run a quick patrol and make sure...
	stopConversation = "true",
	options = {}
}
dravis_convo:addScreen(dravis_convo_yes_im_ready)

-- Player is on quest 1 and returns before completing it
dravis_convo_first_quest_active = ConvoScreen:new {
	id = "first_quest_active",
	leftDialog = "@conversation/tatooine_privateer_trainer_1:s_ca38bc3e", -- Run that patrol, and we'll talk about training later.
	stopConversation = "true",
	options = {}
}
dravis_convo:addScreen(dravis_convo_first_quest_active)

-- Quest 1 complete, player reports in (handler rewards on "patrol_complete")
dravis_convo_excellent_work = ConvoScreen:new {
	id = "excellent_work",
	leftDialog = "@conversation/tatooine_privateer_trainer_1:s_9fdd7cf3", -- Yes?
	stopConversation = "false",
	options = {
		{"@conversation/tatooine_privateer_trainer_1:s_ff2a95e8", "patrol_complete"}, -- A Black Sun pirate attacked me!
		{"@conversation/tatooine_privateer_trainer_1:s_676c343f", "patrol_complete"}, -- That was easy.
	}
}
dravis_convo:addScreen(dravis_convo_excellent_work)

dravis_convo_patrol_complete = ConvoScreen:new {
	id = "patrol_complete",
	leftDialog = "@conversation/tatooine_privateer_trainer_1:s_7705d12c", -- Good job. I knew that patrol would be no problem for you.
	stopConversation = "true",
	options = {}
}
dravis_convo:addScreen(dravis_convo_patrol_complete)

-- Quest 1 failed/aborted
dravis_convo_failed_quest1 = ConvoScreen:new {
	id = "failed_quest1",
	leftDialog = "@conversation/tatooine_privateer_trainer_1:s_fa5082f1", -- Ran into a spot of trouble, huh? Are you up to running that patrol again, or not? 'Course you are!
	stopConversation = "false",
	options = {
		{"@conversation/tatooine_privateer_trainer_1:s_1adbadc4", "retry_quest1"}, -- I'm ready.
	}
}
dravis_convo:addScreen(dravis_convo_failed_quest1)

-- Quest 1 retry acknowledged (handler restarts patrol_tatooine_privateer_1)
dravis_convo_retry_quest1 = ConvoScreen:new {
	id = "retry_quest1",
	leftDialog = "@conversation/tatooine_privateer_trainer_1:s_ca38bc3e", -- Run that patrol, and we'll talk about training later.
	stopConversation = "true",
	options = {}
}
dravis_convo:addScreen(dravis_convo_retry_quest1)

--[[ Tier 1 -- Mission 2: Destroy (handler starts destroy_tatooine_privateer_2 on "quest2_accepted") ]]
dravis_convo_grant_quest2 = ConvoScreen:new {
	id = "grant_quest2",
	leftDialog = "@conversation/tatooine_privateer_trainer_1:s_3924fc00", -- There are still pirates in the area. We need you to get out there and kill them right now, understand?
	stopConversation = "false",
	options = {
		{"@conversation/tatooine_privateer_trainer_1:s_d24a2285", "quest2_accepted"}, -- Will do.
	}
}
dravis_convo:addScreen(dravis_convo_grant_quest2)

dravis_convo_quest2_accepted = ConvoScreen:new {
	id = "quest2_accepted",
	leftDialog = "@conversation/tatooine_privateer_trainer_1:s_25669048", -- So the Black Sun are trying to move in on Hutt space, huh? Well we'd better show them who's in charge around here...
	stopConversation = "true",
	options = {}
}
dravis_convo:addScreen(dravis_convo_quest2_accepted)

-- Quest 2 rewarded; leads into Mission 3 (second patrol)
dravis_convo_excellent_work2 = ConvoScreen:new {
	id = "excellent_work2",
	leftDialog = "@conversation/tatooine_privateer_trainer_1:s_6d6f9a8d", -- We thought that would be the last of the Black Sun pirates, but I guess there were more out there. Try running that patrol again, ok?...
	stopConversation = "false",
	options = {
		{"@conversation/tatooine_privateer_trainer_1:s_d24a2285", "train_me3"}, -- Will do.
		{"@conversation/tatooine_privateer_trainer_1:s_9237617f", "train_me3"}, -- What about training?
	}
}
dravis_convo:addScreen(dravis_convo_excellent_work2)

-- Mission 3 accepted (handler starts patrol_tatooine_privateer_3 on "train_me3")
dravis_convo_train_me3 = ConvoScreen:new {
	id = "train_me3",
	leftDialog = "@conversation/tatooine_privateer_trainer_1:s_ca38bc3e", -- Run that patrol, and we'll talk about training later.
	stopConversation = "true",
	options = {}
}
dravis_convo:addScreen(dravis_convo_train_me3)

dravis_convo_failed_quest2 = ConvoScreen:new {
	id = "failed_quest2",
	leftDialog = "@conversation/tatooine_privateer_trainer_1:s_fa5082f1", -- Ran into a spot of trouble, huh? Are you up to running that patrol again, or not? 'Course you are!
	stopConversation = "false",
	options = {
		{"@conversation/tatooine_privateer_trainer_1:s_1adbadc4", "retry_quest2"}, -- I'm ready.
	}
}
dravis_convo:addScreen(dravis_convo_failed_quest2)

-- Quest 2 retry acknowledged (handler restarts destroy_tatooine_privateer_2)
dravis_convo_retry_quest2 = ConvoScreen:new {
	id = "retry_quest2",
	leftDialog = "@conversation/tatooine_privateer_trainer_1:s_5ac0c4a5", -- Good, great, whatever. See you later.
	stopConversation = "true",
	options = {}
}
dravis_convo:addScreen(dravis_convo_retry_quest2)

--[[ Tier 1 -- Mission 3 report (handler grants the reward on "quest3_rewarded") ]]
dravis_convo_excellent_work3 = ConvoScreen:new {
	id = "excellent_work3",
	leftDialog = "@conversation/tatooine_privateer_trainer_1:s_9fdd7cf3", -- Yes?
	stopConversation = "false",
	options = {
		{"@conversation/tatooine_privateer_trainer_1:s_d0cc72e0", "quest3_rewarded"}, -- I bet there are more out there.
		{"@conversation/tatooine_privateer_trainer_1:s_676c343f", "quest3_rewarded"}, -- That was easy.
	}
}
dravis_convo:addScreen(dravis_convo_excellent_work3)

dravis_convo_quest3_rewarded = ConvoScreen:new {
	id = "quest3_rewarded",
	leftDialog = "@conversation/tatooine_privateer_trainer_1:s_1f0c9843", -- Ha! That'll get the Black Sun off our backs for a while. Way to go!
	stopConversation = "true",
	options = {}
}
dravis_convo:addScreen(dravis_convo_quest3_rewarded)

dravis_convo_failed_quest3 = ConvoScreen:new {
	id = "failed_quest3",
	leftDialog = "@conversation/tatooine_privateer_trainer_1:s_fa5082f1", -- Ran into a spot of trouble, huh? Are you up to running that patrol again, or not? 'Course you are!
	stopConversation = "false",
	options = {
		{"@conversation/tatooine_privateer_trainer_1:s_1adbadc4", "retry_quest3"}, -- I'm ready.
	}
}
dravis_convo:addScreen(dravis_convo_failed_quest3)

-- Quest 3 retry acknowledged (handler restarts patrol_tatooine_privateer_3)
dravis_convo_retry_quest3 = ConvoScreen:new {
	id = "retry_quest3",
	leftDialog = "@conversation/tatooine_privateer_trainer_1:s_ca38bc3e", -- Run that patrol, and we'll talk about training later.
	stopConversation = "true",
	options = {}
}
dravis_convo:addScreen(dravis_convo_retry_quest3)

--[[ Tier 1 -- Mission 4: Assassinate the Black Sun ace (handler starts assassinate_tatooine_privateer_4) ]]
dravis_convo_grant_quest4 = ConvoScreen:new {
	id = "grant_quest4",
	leftDialog = "@conversation/tatooine_privateer_trainer_1:s_2a8b0366", -- Well these Black Sun pirates aren't getting the message. We need to hit them hard: Cut off the head and the tail will follow. I want you to kill an ace...
	stopConversation = "false",
	options = {
		{"@conversation/tatooine_privateer_trainer_1:s_d24a2285", "quest4_accepted"}, -- Will do.
	}
}
dravis_convo:addScreen(dravis_convo_grant_quest4)

dravis_convo_quest4_accepted = ConvoScreen:new {
	id = "quest4_accepted",
	leftDialog = "@conversation/tatooine_privateer_trainer_1:s_5ac0c4a5", -- Good, great, whatever. See you later.
	stopConversation = "true",
	options = {}
}
dravis_convo:addScreen(dravis_convo_quest4_accepted)

dravis_convo_failed_quest4 = ConvoScreen:new {
	id = "failed_quest4",
	leftDialog = "@conversation/tatooine_privateer_trainer_1:s_999009d", -- What happened to you? I thought you could handle this? Look, we need that ace DEAD. If you're not up to this, then maybe you should hire some help.
	stopConversation = "false",
	options = {
		{"@conversation/tatooine_privateer_trainer_1:s_1adbadc4", "retry_quest4"}, -- I'm ready.
	}
}
dravis_convo:addScreen(dravis_convo_failed_quest4)

-- Quest 4 retry acknowledged (handler restarts assassinate_tatooine_privateer_4)
dravis_convo_retry_quest4 = ConvoScreen:new {
	id = "retry_quest4",
	leftDialog = "@conversation/tatooine_privateer_trainer_1:s_5ac0c4a5", -- Good, great, whatever. See you later.
	stopConversation = "true",
	options = {}
}
dravis_convo:addScreen(dravis_convo_retry_quest4)

--[[ Player has an active (non-first) mission ]]
dravis_convo_has_mission = ConvoScreen:new {
	id = "has_mission",
	leftDialog = "@conversation/tatooine_privateer_trainer_1:s_a2123b71", -- You need to do some more for me, before I do anything more for you. There'll be time for training later...
	stopConversation = "true",
	options = {}
}
dravis_convo:addScreen(dravis_convo_has_mission)

--[[ All four Tier-1 missions complete -> free training choices (handler builds options) ]]
dravis_convo_missions_complete = ConvoScreen:new {
	id = "missions_complete",
	leftDialog = "@conversation/tatooine_privateer_trainer_1:s_ae220ebc", -- There's no doubt all that practice has paid off. I think you've proven you're ready for some additional training...
	stopConversation = "false",
	options = {}
}
dravis_convo:addScreen(dravis_convo_missions_complete)

--[[ Additional (XP-gated) training (handler builds options) ]]
dravis_convo_more_training = ConvoScreen:new {
	id = "more_training",
	leftDialog = "@conversation/tatooine_privateer_trainer_1:s_605d90db", -- Right! I think you're ready for some additional training. Now tell me, which area interests you the most?
	stopConversation = "false",
	options = {}
}
dravis_convo:addScreen(dravis_convo_more_training)

-- training acknowledgement screens (handler grants the skill then returns the cloned screen)
dravis_convo_train_player_fighters = ConvoScreen:new {
	id = "train_player_fighters",
	leftDialog = "@conversation/tatooine_privateer_trainer_1:s_2b94498c", -- Excellent choice. Learning to pilot better ships will allow you to tackle more difficult assignments.
	stopConversation = "true",
	options = {}
}
dravis_convo:addScreen(dravis_convo_train_player_fighters)

dravis_convo_train_player_component = ConvoScreen:new {
	id = "train_player_component",
	leftDialog = "@conversation/tatooine_privateer_trainer_1:s_2b94498c", -- Excellent choice. Learning to pilot better ships will allow you to tackle more difficult assignments.
	stopConversation = "true",
	options = {}
}
dravis_convo:addScreen(dravis_convo_train_player_component)

dravis_convo_train_player_basics = ConvoScreen:new {
	id = "train_player_basics",
	leftDialog = "@conversation/tatooine_privateer_trainer_1:s_2b94498c", -- Excellent choice. Learning to pilot better ships will allow you to tackle more difficult assignments.
	stopConversation = "true",
	options = {}
}
dravis_convo:addScreen(dravis_convo_train_player_basics)

dravis_convo_train_player_droid = ConvoScreen:new {
	id = "train_player_droid",
	leftDialog = "@conversation/tatooine_privateer_trainer_1:s_2b94498c", -- Excellent choice. Learning to pilot better ships will allow you to tackle more difficult assignments.
	stopConversation = "true",
	options = {}
}
dravis_convo:addScreen(dravis_convo_train_player_droid)

-- free-training variants (same acknowledgement string)
dravis_convo_train_player_fighters_free = ConvoScreen:new {
	id = "train_player_fighters_free",
	leftDialog = "@conversation/tatooine_privateer_trainer_1:s_2b94498c", -- Excellent choice. Learning to pilot better ships will allow you to tackle more difficult assignments.
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
	leftDialog = "@conversation/tatooine_privateer_trainer_1:s_4d19fcb1", -- What's on your mind? Thinking about performing some duty missions?
	stopConversation = "false",
	options = {
		{"@conversation/tatooine_privateer_trainer_1:s_695b8483", "destroy_duty"}, -- Black Sun pirates.
		{"@conversation/tatooine_privateer_trainer_1:s_96294214", "escort_duty"}, -- Escort Duty.
		{"@conversation/tatooine_privateer_trainer_1:s_6106187c", "what_is_duty"}, -- What is a duty mission?
	}
}
dravis_convo:addScreen(dravis_convo_duty_missions)

dravis_convo_what_is_duty = ConvoScreen:new {
	id = "what_is_duty",
	leftDialog = "@conversation/tatooine_privateer_trainer_1:s_d43b2932", -- Duty missions are a good way for you to get experience as a pilot. Only experienced pilots can receive the pro...
	stopConversation = "false",
	options = {
		{"@conversation/tatooine_privateer_trainer_1:s_695b8483", "destroy_duty"}, -- Black Sun pirates.
		{"@conversation/tatooine_privateer_trainer_1:s_96294214", "escort_duty"}, -- Escort Duty.
	}
}
dravis_convo:addScreen(dravis_convo_what_is_duty)

-- Duty accepted (handler starts destroy_duty_tatooine_privateer_6)
dravis_convo_destroy_duty = ConvoScreen:new {
	id = "destroy_duty",
	leftDialog = "@conversation/tatooine_privateer_trainer_1:s_71015a7d", -- There are a lot of Black Sun pirates in the Tatooine system and they have no business being here. Just go out...
	stopConversation = "true",
	options = {}
}
dravis_convo:addScreen(dravis_convo_destroy_duty)

-- Duty accepted (handler starts escort_duty_tatooine_privateer_7)
dravis_convo_escort_duty = ConvoScreen:new {
	id = "escort_duty",
	leftDialog = "@conversation/tatooine_privateer_trainer_1:s_7436b5b6", -- That's good thinking. We need to make sure our shipments are making it through safely. Get out there and escort...
	stopConversation = "true",
	options = {}
}
dravis_convo:addScreen(dravis_convo_escort_duty)

-- recruitment_not_imperial (player is aligned with the GCW factions, not yet a pilot)
dravis_convo_recruitment_not_imperial = ConvoScreen:new {
	id = "recruitment_not_imperial",
	leftDialog = "@conversation/tatooine_privateer_trainer_1:s_c6f8e9e9", -- Ever heard of the Smugglers Alliance?
	stopConversation = "false",
	options = {
		{"@conversation/tatooine_privateer_trainer_1:s_940e1e78", "yes_join"}, -- I want to join.
		{"@conversation/tatooine_privateer_trainer_1:s_2883b989", "decline_join"}, -- Not right now, thanks.
	}
}
dravis_convo:addScreen(dravis_convo_recruitment_not_imperial)

--[[ Tier 1 complete -> reassigned to Talon Karrde ]]
dravis_convo_completed_sinkko = ConvoScreen:new {
	id = "completed_sinkko",
	leftDialog = "@conversation/tatooine_privateer_trainer_1:s_be1beb37", -- Listen, something has come up that we need you to take care of. Talon Karrde's got a special assignment for you...
	stopConversation = "false",
	options = {
		{"@conversation/tatooine_privateer_trainer_1:s_111621e7", "report_to_fazoll"}, -- Where do I go now?
	}
}
dravis_convo:addScreen(dravis_convo_completed_sinkko)

-- Reassignment: grant waypoint to the next trainer (handler sets dravis_finished + waypoint)
dravis_convo_report_to_fazoll = ConvoScreen:new {
	id = "report_to_fazoll",
	leftDialog = "@conversation/tatooine_privateer_trainer_1:s_d3d66c68", -- Excellent! Now talk to Talon Karrde.
	stopConversation = "true",
	options = {}
}
dravis_convo:addScreen(dravis_convo_report_to_fazoll)

-- Player already reassigned, returns to Dravis
dravis_convo_go_to_next = ConvoScreen:new {
	id = "go_to_next",
	leftDialog = "@conversation/tatooine_privateer_trainer_1:s_31fc5801", -- Well then go away and stop bothering me. I'm a busy man!
	stopConversation = "true",
	options = {}
}
dravis_convo:addScreen(dravis_convo_go_to_next)


--[[
	Tier 2-4 + master hand-off screens (milestone conformance).
	Mechanical transplants of the proven neutral squadron progression templates:
	  tier2_* screens  <- kaydine_convo.lua  (@conversation/naboo_privateer_trainer_2)
	  tier3_* screens  <- dulios_convo.lua   (@conversation/naboo_privateer_tier3)
	  tier4_*/master_* <- dinge_convo.lua    (@conversation/naboo_privateer_tier4, naboo_privateer_trainer_1)
	Screen ids are namespaced (tier2_/tier3_; dinge ids kept verbatim, already tier4_/master_
	namespaced) so one handler serves the whole ladder. All string ids are existing client STF
	references reused verbatim; no new string ids were invented.
]]

dravis_tier2_on_mission = ConvoScreen:new {
	id = "tier2_on_mission",
	leftDialog = "@conversation/naboo_privateer_trainer_2:s_e95a95a5", -- I believe you have some business to attend to... in space?
	stopConversation = "true",
	options = {}
}
dravis_convo:addScreen(dravis_tier2_on_mission);

dravis_tier2_completed_kaydine = ConvoScreen:new {
	id = "tier2_completed_kaydine",
	leftDialog = "@conversation/naboo_privateer_trainer_2:s_aae78dca", -- I think it's time for you to take on more responsibilities. Head deeper into the palace, my friend! Look for Commander Dulios.
	stopConversation = "true",
	options = {}
}
dravis_convo:addScreen(dravis_tier2_completed_kaydine);

dravis_tier2_here_for_work = ConvoScreen:new {
	id = "tier2_here_for_work",
	leftDialog = "@conversation/naboo_privateer_trainer_2:s_c5fcc7f5", -- Greetings, Captain %TU! Are you ready to take my place on the duty roster?
	stopConversation = "false",
	options = {
		{"@conversation/naboo_privateer_trainer_2:s_6114e8b7", "tier2_duty_options"}, -- I'm ready for duty
		{"@conversation/naboo_privateer_trainer_2:s_45d20070", "tier2_ready_train_pilot"}, -- I need training
	}
}
dravis_convo:addScreen(dravis_tier2_here_for_work);

dravis_tier2_duty_options = ConvoScreen:new {
	id = "tier2_duty_options",
	leftDialog = "@conversation/naboo_privateer_trainer_2:s_63053557", -- Good! What duty element do you want to participate in today?
	stopConversation = "false",
	options = {
		{"@conversation/naboo_privateer_trainer_2:s_c892e540", "tier2_accept_duty_destroy1"}, -- Destroy Ay'Nat Legion pirates in this system.
		{"@conversation/naboo_privateer_trainer_2:s_9b73da8", "tier2_accept_duty_escort"}, -- Protect the Royal Kylantha cargo.
		{"@conversation/naboo_privateer_trainer_2:s_30297e22", "tier2_accept_duty_recovery"}, -- Recover ships stolen by the Ay'Nat Legion.
	}
}
dravis_convo:addScreen(dravis_tier2_duty_options);

dravis_tier2_accept_duty_destroy1 = ConvoScreen:new {
	id = "tier2_accept_duty_destroy1",
	leftDialog = "@conversation/naboo_privateer_trainer_2:s_bb291959", -- Excellent! Be careful up there! Those Ay'Nat outlaws are deadly enemies!
	stopConversation = "true",
	options = {}
}
dravis_convo:addScreen(dravis_tier2_accept_duty_destroy1);

dravis_tier2_accept_duty_escort = ConvoScreen:new {
	id = "tier2_accept_duty_escort",
	leftDialog = "@conversation/naboo_privateer_trainer_2:s_2e7b17f3", -- It's very likely you'll fall under attack from Ay'Nat Legion pirates. Be careful...
	stopConversation = "true",
	options = {}
}
dravis_convo:addScreen(dravis_tier2_accept_duty_escort);

dravis_tier2_accept_duty_recovery = ConvoScreen:new {
	id = "tier2_accept_duty_recovery",
	leftDialog = "@conversation/naboo_privateer_trainer_2:s_a0072111", -- Hm. A grim job if there ever was one. I respect your courage. Good luck!
	stopConversation = "true",
	options = {}
}
dravis_convo:addScreen(dravis_tier2_accept_duty_recovery);

dravis_tier2_ready_train_pilot = ConvoScreen:new {
	id = "tier2_ready_train_pilot",
	leftDialog = "@conversation/naboo_privateer_trainer_2:s_8a84109d", -- It must be your lucky day. I actually do have some elective duty missions. Take a look and tell me what you want.
	stopConversation = "false",
	options = {}
}
dravis_convo:addScreen(dravis_tier2_ready_train_pilot);

dravis_tier2_initial_train_fighters = ConvoScreen:new {
	id = "tier2_initial_train_fighters",
	leftDialog = "@conversation/naboo_privateer_trainer_2:s_4aa3066e", -- Ah yes! Good choice! Learning to fly many different types of ships makes an effective pilot!
	stopConversation = "true",
	options = {}
}
dravis_convo:addScreen(dravis_tier2_initial_train_fighters);

dravis_tier2_initial_train_components = ConvoScreen:new {
	id = "tier2_initial_train_components",
	leftDialog = "@conversation/naboo_privateer_trainer_2:s_8ad6a62e", -- You bet! New components should make your ship more than a match against a dozen Ay'Nat Ghost Fighters!
	stopConversation = "true",
	options = {}
}
dravis_convo:addScreen(dravis_tier2_initial_train_components);

dravis_tier2_initial_train_techniques = ConvoScreen:new {
	id = "tier2_initial_train_techniques",
	leftDialog = "@conversation/naboo_privateer_trainer_2:s_f32117e", -- You bet! New defense procedures should make you more than a match against a dozen Ay'Nat Ghost Fighters!
	stopConversation = "true",
	options = {}
}
dravis_convo:addScreen(dravis_tier2_initial_train_techniques);

dravis_tier2_initial_train_algorithms = ConvoScreen:new {
	id = "tier2_initial_train_algorithms",
	leftDialog = "@conversation/naboo_privateer_trainer_2:s_fd75abb", -- You bet! New droid algorithms in there should make you more than a match against a dozen Ay'Nat Ghost Fighters!
	stopConversation = "true",
	options = {}
}
dravis_convo:addScreen(dravis_tier2_initial_train_algorithms);

dravis_tier2_mission2_train_fighters = ConvoScreen:new {
	id = "tier2_mission2_train_fighters",
	leftDialog = "@conversation/naboo_privateer_trainer_2:s_4aa3066e", -- Ah yes! Good choice!
	stopConversation = "true",
	options = {}
}
dravis_convo:addScreen(dravis_tier2_mission2_train_fighters);

dravis_tier2_mission2_train_components = ConvoScreen:new {
	id = "tier2_mission2_train_components",
	leftDialog = "@conversation/naboo_privateer_trainer_2:s_8ad6a62e", -- You bet! New components...
	stopConversation = "true",
	options = {}
}
dravis_convo:addScreen(dravis_tier2_mission2_train_components);

dravis_tier2_mission2_train_techniques = ConvoScreen:new {
	id = "tier2_mission2_train_techniques",
	leftDialog = "@conversation/naboo_privateer_trainer_2:s_f32117e", -- You bet! New defense procedures...
	stopConversation = "true",
	options = {}
}
dravis_convo:addScreen(dravis_tier2_mission2_train_techniques);

dravis_tier2_mission2_train_algorithms = ConvoScreen:new {
	id = "tier2_mission2_train_algorithms",
	leftDialog = "@conversation/naboo_privateer_trainer_2:s_fd75abb", -- You bet! New droid algorithms...
	stopConversation = "true",
	options = {}
}
dravis_convo:addScreen(dravis_tier2_mission2_train_algorithms);

dravis_tier2_mission3_train_fighters = ConvoScreen:new {
	id = "tier2_mission3_train_fighters",
	leftDialog = "@conversation/naboo_privateer_trainer_2:s_4aa3066e",
	stopConversation = "true",
	options = {}
}
dravis_convo:addScreen(dravis_tier2_mission3_train_fighters);

dravis_tier2_mission3_train_components = ConvoScreen:new {
	id = "tier2_mission3_train_components",
	leftDialog = "@conversation/naboo_privateer_trainer_2:s_8ad6a62e",
	stopConversation = "true",
	options = {}
}
dravis_convo:addScreen(dravis_tier2_mission3_train_components);

dravis_tier2_mission3_train_techniques = ConvoScreen:new {
	id = "tier2_mission3_train_techniques",
	leftDialog = "@conversation/naboo_privateer_trainer_2:s_f32117e",
	stopConversation = "true",
	options = {}
}
dravis_convo:addScreen(dravis_tier2_mission3_train_techniques);

dravis_tier2_mission3_train_algorithms = ConvoScreen:new {
	id = "tier2_mission3_train_algorithms",
	leftDialog = "@conversation/naboo_privateer_trainer_2:s_fd75abb",
	stopConversation = "true",
	options = {}
}
dravis_convo:addScreen(dravis_tier2_mission3_train_algorithms);

dravis_tier2_mission4_train_fighters = ConvoScreen:new {
	id = "tier2_mission4_train_fighters",
	leftDialog = "@conversation/naboo_privateer_trainer_2:s_4aa3066e",
	stopConversation = "true",
	options = {}
}
dravis_convo:addScreen(dravis_tier2_mission4_train_fighters);

dravis_tier2_mission4_train_components = ConvoScreen:new {
	id = "tier2_mission4_train_components",
	leftDialog = "@conversation/naboo_privateer_trainer_2:s_8ad6a62e",
	stopConversation = "true",
	options = {}
}
dravis_convo:addScreen(dravis_tier2_mission4_train_components);

dravis_tier2_mission4_train_techniques = ConvoScreen:new {
	id = "tier2_mission4_train_techniques",
	leftDialog = "@conversation/naboo_privateer_trainer_2:s_f32117e",
	stopConversation = "true",
	options = {}
}
dravis_convo:addScreen(dravis_tier2_mission4_train_techniques);

dravis_tier2_mission4_train_algorithms = ConvoScreen:new {
	id = "tier2_mission4_train_algorithms",
	leftDialog = "@conversation/naboo_privateer_trainer_2:s_fd75abb",
	stopConversation = "true",
	options = {}
}
dravis_convo:addScreen(dravis_tier2_mission4_train_algorithms);

dravis_tier2_final_train_fighters = ConvoScreen:new {
	id = "tier2_final_train_fighters",
	leftDialog = "@conversation/naboo_privateer_trainer_2:s_4aa3066e",
	stopConversation = "true",
	options = {}
}
dravis_convo:addScreen(dravis_tier2_final_train_fighters);

dravis_tier2_final_train_components = ConvoScreen:new {
	id = "tier2_final_train_components",
	leftDialog = "@conversation/naboo_privateer_trainer_2:s_8ad6a62e",
	stopConversation = "true",
	options = {}
}
dravis_convo:addScreen(dravis_tier2_final_train_components);

dravis_tier2_final_train_techniques = ConvoScreen:new {
	id = "tier2_final_train_techniques",
	leftDialog = "@conversation/naboo_privateer_trainer_2:s_f32117e",
	stopConversation = "true",
	options = {}
}
dravis_convo:addScreen(dravis_tier2_final_train_techniques);

dravis_tier2_final_train_algorithms = ConvoScreen:new {
	id = "tier2_final_train_algorithms",
	leftDialog = "@conversation/naboo_privateer_trainer_2:s_fd75abb",
	stopConversation = "true",
	options = {}
}
dravis_convo:addScreen(dravis_tier2_final_train_algorithms);

dravis_tier2_first_mission = ConvoScreen:new {
	id = "tier2_first_mission",
	leftDialog = "@conversation/naboo_privateer_trainer_2:s_130b925b", -- We'll need you to catch up to the Ay'Nat Captain's personal starship... a rather fast vessel! Disable him, and protect the RSF Boarding Team while they arrest him.
	stopConversation = "false",
	options = {
		{"@conversation/naboo_privateer_trainer_2:s_1b428a9f", "tier2_start_first_mission"}, -- Yes, Captain. I'm ready.
		{"@conversation/naboo_privateer_trainer_2:s_1c2b565d", "tier2_not_ready"}, -- Not quite yet, sir.
	}
}
dravis_convo:addScreen(dravis_tier2_first_mission);

dravis_tier2_failed_first_mission = ConvoScreen:new {
	id = "tier2_failed_first_mission",
	leftDialog = "@conversation/naboo_privateer_trainer_2:s_65042122", -- So, I hear you were not able to destroy all three of the Ay'Nat Legion's outlaw fighters. But don't worry...
	stopConversation = "false",
	options = {
		{"@conversation/naboo_privateer_trainer_2:s_4a1d2431", "tier2_try_first_mission"}, -- Yes, I'm ready.
		{"@conversation/naboo_privateer_trainer_2:s_1c2b565d", "tier2_not_ready"}, -- Not quite yet, sir.
	}
}
dravis_convo:addScreen(dravis_tier2_failed_first_mission);

dravis_tier2_start_first_mission = ConvoScreen:new {
	id = "tier2_start_first_mission",
	leftDialog = "@conversation/naboo_privateer_trainer_2:s_a80d9308", -- Good luck!
	stopConversation = "true",
	options = {}
}
dravis_convo:addScreen(dravis_tier2_start_first_mission);

dravis_tier2_try_first_mission = ConvoScreen:new {
	id = "tier2_try_first_mission",
	leftDialog = "@conversation/naboo_privateer_trainer_2:s_726bdb69", -- Good! Then let's get you back out there right away!
	stopConversation = "true",
	options = {}
}
dravis_convo:addScreen(dravis_tier2_try_first_mission);

dravis_tier2_cant_wait_first = ConvoScreen:new {
	id = "tier2_cant_wait_first",
	leftDialog = "@conversation/naboo_privateer_trainer_2:s_a80d9308", -- Good luck!
	stopConversation = "true",
	options = {}
}
dravis_convo:addScreen(dravis_tier2_cant_wait_first);

dravis_tier2_complete_first_mission = ConvoScreen:new {
	id = "tier2_complete_first_mission",
	leftDialog = "@conversation/naboo_privateer_trainer_2:s_9abb9538", -- Fantastic work! The space station holocomm'd me regarding a massive battle between a lone RSF pilot...
	stopConversation = "false",
	options = {
		{"@conversation/naboo_privateer_trainer_2:s_aa77ffde", "tier2_according_to_plan"}, -- It was nothing
	}
}
dravis_convo:addScreen(dravis_tier2_complete_first_mission);

dravis_tier2_according_to_plan = ConvoScreen:new {
	id = "tier2_according_to_plan",
	leftDialog = "@conversation/naboo_privateer_trainer_2:s_8d90962a", -- Nonsense! You've earned this.
	stopConversation = "true",
	options = {}
}
dravis_convo:addScreen(dravis_tier2_according_to_plan);

dravis_tier2_first_mission_success = ConvoScreen:new {
	id = "tier2_first_mission_success",
	leftDialog = "@conversation/naboo_privateer_trainer_2:s_9248b2ba", -- Well you've certainly earned it. I'll talk to you later.
	stopConversation = "true",
	options = {}
}
dravis_convo:addScreen(dravis_tier2_first_mission_success);

dravis_tier2_second_mission = ConvoScreen:new {
	id = "tier2_second_mission",
	leftDialog = "@conversation/naboo_privateer_trainer_2:s_ec671b3f", -- Well, the Empire has demanded that the prisoners be turned over for questioning.
	stopConversation = "false",
	options = {
		{"@conversation/naboo_privateer_trainer_2:s_2d67b7a8", "tier2_accept_escort_details"}, -- Where do I come in?
		{"@conversation/naboo_privateer_trainer_2:s_1c2b565d", "tier2_not_ready"}, -- Not quite yet, sir.
	}
}
dravis_convo:addScreen(dravis_tier2_second_mission);

dravis_tier2_accept_escort_details = ConvoScreen:new {
	id = "tier2_accept_escort_details",
	leftDialog = "@conversation/naboo_privateer_trainer_2:s_287eca83", -- We needed to get that prisoner ship out of the Naboo system to keep the Empire happy.
	stopConversation = "false",
	options = {
		{"@conversation/naboo_privateer_trainer_2:s_1b428a9f", "tier2_accept_escort"}, -- Yes, Captain. I'm ready.
		{"@conversation/naboo_privateer_trainer_2:s_1c2b565d", "tier2_not_ready"}, -- Not quite yet, sir.
	}
}
dravis_convo:addScreen(dravis_tier2_accept_escort_details);

dravis_tier2_failed_second_mission = ConvoScreen:new {
	id = "tier2_failed_second_mission",
	leftDialog = "@conversation/naboo_privateer_trainer_2:s_6da2c92b", -- I realize there were a lot of fighters up there to deal with... but nothing changes the fact that the Ay'Nat Legion must go!
	stopConversation = "false",
	options = {
		{"@conversation/naboo_privateer_trainer_2:s_4a1d2431", "tier2_back_to_escort"}, -- Yes, I'm ready.
		{"@conversation/naboo_privateer_trainer_2:s_1c2b565d", "tier2_not_ready"}, -- Not quite yet, sir.
	}
}
dravis_convo:addScreen(dravis_tier2_failed_second_mission);

dravis_tier2_accept_escort = ConvoScreen:new {
	id = "tier2_accept_escort",
	leftDialog = "@conversation/naboo_privateer_trainer_2:s_57ba8a73", -- In that case, let's get you back up there. This time make sure the RSF prison ship makes it out of the system.
	stopConversation = "true",
	options = {}
}
dravis_convo:addScreen(dravis_tier2_accept_escort);

dravis_tier2_back_to_escort = ConvoScreen:new {
	id = "tier2_back_to_escort",
	leftDialog = "@conversation/naboo_privateer_trainer_2:s_57ba8a73", -- In that case, let's get you back up there. This time make sure the RSF prison ship makes it out of the system.
	stopConversation = "true",
	options = {}
}
dravis_convo:addScreen(dravis_tier2_back_to_escort);

dravis_tier2_now_is_good = ConvoScreen:new {
	id = "tier2_now_is_good",
	leftDialog = "@conversation/naboo_privateer_trainer_2:s_d586f458", -- Excellent! Get back out there and do me proud!
	stopConversation = "true",
	options = {}
}
dravis_convo:addScreen(dravis_tier2_now_is_good);

dravis_tier2_be_smarter = ConvoScreen:new {
	id = "tier2_be_smarter",
	leftDialog = "@conversation/naboo_privateer_trainer_2:s_85263c6d", -- We can't afford to botch this opportunity!
	stopConversation = "true",
	options = {}
}
dravis_convo:addScreen(dravis_tier2_be_smarter);

dravis_tier2_complete_second_mission = ConvoScreen:new {
	id = "tier2_complete_second_mission",
	leftDialog = "@conversation/naboo_privateer_trainer_2:s_70287826", -- Now that's showing some excellent leadership potential! You've really earned your pay this time.
	stopConversation = "false",
	options = {
		{"@conversation/naboo_privateer_trainer_2:s_5fa9a5d3", "tier2_duty_calls"}, -- Thanks
	}
}
dravis_convo:addScreen(dravis_tier2_complete_second_mission);

dravis_tier2_duty_calls = ConvoScreen:new {
	id = "tier2_duty_calls",
	leftDialog = "@conversation/naboo_privateer_trainer_2:s_9248b2ba", -- Well you've certainly earned it. I'll talk to you later.
	stopConversation = "true",
	options = {}
}
dravis_convo:addScreen(dravis_tier2_duty_calls);

dravis_tier2_here_is_pay = ConvoScreen:new {
	id = "tier2_here_is_pay",
	leftDialog = "@conversation/naboo_privateer_trainer_2:s_ae21cb72", -- Thanks to you! Great work, %NU. You've really earned these credits.
	stopConversation = "true",
	options = {}
}
dravis_convo:addScreen(dravis_tier2_here_is_pay);

dravis_tier2_third_mission = ConvoScreen:new {
	id = "tier2_third_mission",
	leftDialog = "@conversation/naboo_privateer_trainer_2:s_35fb22d6", -- The Royal family has increased security in the wake of recent theft. A number of Her Majesty's personal starships have gone missing.
	stopConversation = "false",
	options = {
		{"@conversation/naboo_privateer_trainer_2:s_a6c7fa2b", "tier2_accept_inspect"}, -- What are the details?
		{"@conversation/naboo_privateer_trainer_2:s_1c2b565d", "tier2_not_ready"}, -- Not quite yet, sir.
	}
}
dravis_convo:addScreen(dravis_tier2_third_mission);

dravis_tier2_failed_third_mission = ConvoScreen:new {
	id = "tier2_failed_third_mission",
	leftDialog = "@conversation/naboo_privateer_trainer_2:s_85263c6d", -- We can't afford to botch this opportunity! RSF has a new battery of information... and another chance...
	stopConversation = "false",
	options = {
		{"@conversation/naboo_privateer_trainer_2:s_4a1d2431", "tier2_on_your_way"}, -- Yes, I'm ready.
		{"@conversation/naboo_privateer_trainer_2:s_1c2b565d", "tier2_not_ready"}, -- Not quite yet, sir.
	}
}
dravis_convo:addScreen(dravis_tier2_failed_third_mission);

dravis_tier2_accept_inspect = ConvoScreen:new {
	id = "tier2_accept_inspect",
	leftDialog = "@conversation/naboo_privateer_trainer_2:s_3cef63a0", -- Fly out to your choice of strike points... look for Ay'Nat Legion fighters.
	stopConversation = "true",
	options = {}
}
dravis_convo:addScreen(dravis_tier2_accept_inspect);

dravis_tier2_on_your_way = ConvoScreen:new {
	id = "tier2_on_your_way",
	leftDialog = "@conversation/naboo_privateer_trainer_2:s_726bdb69", -- Good! Then let's get you back out there right away!
	stopConversation = "true",
	options = {}
}
dravis_convo:addScreen(dravis_tier2_on_your_way);

dravis_tier2_take_it_serious = ConvoScreen:new {
	id = "tier2_take_it_serious",
	leftDialog = "@conversation/naboo_privateer_trainer_2:s_bb291959", -- Excellent! Be careful up there! Those Ay'Nat outlaws are deadly enemies!
	stopConversation = "true",
	options = {}
}
dravis_convo:addScreen(dravis_tier2_take_it_serious);

dravis_tier2_bad_liar = ConvoScreen:new {
	id = "tier2_bad_liar",
	leftDialog = "@conversation/naboo_privateer_trainer_2:s_da8818c5", -- If you say so, %NU. I still say it's an impressive accomplishment.
	stopConversation = "true",
	options = {}
}
dravis_convo:addScreen(dravis_tier2_bad_liar);

dravis_tier2_complete_third_mission = ConvoScreen:new {
	id = "tier2_complete_third_mission",
	leftDialog = "@conversation/naboo_privateer_trainer_2:s_ef08027f", -- That's excellent news for the peaceful citizens of the Naboo system.
	stopConversation = "false",
	options = {
		{"@conversation/naboo_privateer_trainer_2:s_5fa9a5d3", "tier2_turnover_intelligence"}, -- Thanks
	}
}
dravis_convo:addScreen(dravis_tier2_complete_third_mission);

dravis_tier2_turnover_intelligence = ConvoScreen:new {
	id = "tier2_turnover_intelligence",
	leftDialog = "@conversation/naboo_privateer_trainer_2:s_9248b2ba", -- Well you've certainly earned it. I'll talk to you later.
	stopConversation = "true",
	options = {}
}
dravis_convo:addScreen(dravis_tier2_turnover_intelligence);

dravis_tier2_fourth_mission = ConvoScreen:new {
	id = "tier2_fourth_mission",
	leftDialog = "@conversation/naboo_privateer_trainer_2:s_c4ef0e93", -- We need you to slip in to Ay'Nat-controlled space, and hunt down a trio of Ace outlaws.
	stopConversation = "false",
	options = {
		{"@conversation/naboo_privateer_trainer_2:s_1b428a9f", "tier2_accept_assassinate"}, -- Yes, Captain. I'm ready.
		{"@conversation/naboo_privateer_trainer_2:s_1c2b565d", "tier2_not_ready"}, -- Not quite yet, sir.
	}
}
dravis_convo:addScreen(dravis_tier2_fourth_mission);

dravis_tier2_failed_fourth_mission = ConvoScreen:new {
	id = "tier2_failed_fourth_mission",
	leftDialog = "@conversation/naboo_privateer_trainer_2:s_65042122", -- So, I hear you were not able to destroy all three of the Ay'Nat Legion's outlaw fighters. But don't worry...
	stopConversation = "false",
	options = {
		{"@conversation/naboo_privateer_trainer_2:s_4a1d2431", "tier2_nonsense"}, -- Yes, I'm ready.
		{"@conversation/naboo_privateer_trainer_2:s_1c2b565d", "tier2_not_ready"}, -- Not quite yet, sir.
	}
}
dravis_convo:addScreen(dravis_tier2_failed_fourth_mission);

dravis_tier2_accept_assassinate = ConvoScreen:new {
	id = "tier2_accept_assassinate",
	leftDialog = "@conversation/naboo_privateer_trainer_2:s_ff45f1fd", -- Good luck to you, Captain %TU!
	stopConversation = "true",
	options = {}
}
dravis_convo:addScreen(dravis_tier2_accept_assassinate);

dravis_tier2_nonsense = ConvoScreen:new {
	id = "tier2_nonsense",
	leftDialog = "@conversation/naboo_privateer_trainer_2:s_726bdb69", -- Good! Then let's get you back out there right away!
	stopConversation = "true",
	options = {}
}
dravis_convo:addScreen(dravis_tier2_nonsense);

dravis_tier2_let_me_know = ConvoScreen:new {
	id = "tier2_let_me_know",
	leftDialog = "@conversation/naboo_privateer_trainer_2:s_d586f458", -- Excellent! Get back out there and do me proud!
	stopConversation = "true",
	options = {}
}
dravis_convo:addScreen(dravis_tier2_let_me_know);

dravis_tier2_report_back_success = ConvoScreen:new {
	id = "tier2_report_back_success",
	leftDialog = "@conversation/naboo_privateer_trainer_2:s_a80d9308", -- Good luck!
	stopConversation = "true",
	options = {}
}
dravis_convo:addScreen(dravis_tier2_report_back_success);

dravis_tier2_key_to_success = ConvoScreen:new {
	id = "tier2_key_to_success",
	leftDialog = "@conversation/naboo_privateer_trainer_2:s_225b33f", -- Good luck, son!
	stopConversation = "true",
	options = {}
}
dravis_convo:addScreen(dravis_tier2_key_to_success);

dravis_tier2_just_malfunctioned = ConvoScreen:new {
	id = "tier2_just_malfunctioned",
	leftDialog = "@conversation/naboo_privateer_trainer_2:s_b0ab3e88", -- Oh! You had me going there. Well you've earned that, anyway.
	stopConversation = "true",
	options = {}
}
dravis_convo:addScreen(dravis_tier2_just_malfunctioned);

dravis_tier2_complete_fourth_mission = ConvoScreen:new {
	id = "tier2_complete_fourth_mission",
	leftDialog = "@conversation/naboo_privateer_trainer_2:s_76e6f264", -- Captain %TU! You are doing a fantastic job! I think you've grown enough as a pilot to warrant advancement.
	stopConversation = "false",
	options = {
		{"@conversation/naboo_privateer_trainer_2:s_5fa9a5d3", "tier2_fourth_mission_success"}, -- Thanks
	}
}
dravis_convo:addScreen(dravis_tier2_complete_fourth_mission);

dravis_tier2_fourth_mission_success = ConvoScreen:new {
	id = "tier2_fourth_mission_success",
	leftDialog = "@conversation/naboo_privateer_trainer_2:s_aa83c988", -- Head deeper into the palace, my friend! Look for Commander Dulios.
	stopConversation = "true",
	options = {}
}
dravis_convo:addScreen(dravis_tier2_fourth_mission_success);

dravis_tier2_not_ready = ConvoScreen:new {
	id = "tier2_not_ready",
	leftDialog = "@conversation/naboo_privateer_trainer_2:s_943f6352", -- Alright. Hurry up and come back when you're ready.
	stopConversation = "true",
	options = {}
}
dravis_convo:addScreen(dravis_tier2_not_ready);

dravis_tier3_completed_dulios = ConvoScreen:new {
	id = "tier3_completed_dulios",
	leftDialog = "@conversation/naboo_privateer_tier3:s_4fc6a099", -- Aw. I think I'm actually going to miss you - maybe. But duty calls. You're now assigned to Admiral Diness Imler, down the hall - he'll be giving you orders from now on. See ya, %TU.
	stopConversation = "true",
	options = {}
}
dravis_convo:addScreen(dravis_tier3_completed_dulios);

dravis_tier3_train_warships_final = ConvoScreen:new {
	id = "tier3_train_warships_final",
	leftDialog = "@conversation/naboo_privateer_tier3:s_4fc6a099", -- Aw. I think I'm actually going to miss you...
	stopConversation = "true",
	options = {}
}
dravis_convo:addScreen(dravis_tier3_train_warships_final);

dravis_tier3_train_components_final = ConvoScreen:new {
	id = "tier3_train_components_final",
	leftDialog = "@conversation/naboo_privateer_tier3:s_4fc6a099", -- Aw. I think I'm actually going to miss you...
	stopConversation = "true",
	options = {}
}
dravis_convo:addScreen(dravis_tier3_train_components_final);

dravis_tier3_train_techniques_final = ConvoScreen:new {
	id = "tier3_train_techniques_final",
	leftDialog = "@conversation/naboo_privateer_tier3:s_4fc6a099", -- Aw. I think I'm actually going to miss you...
	stopConversation = "true",
	options = {}
}
dravis_convo:addScreen(dravis_tier3_train_techniques_final);

dravis_tier3_train_programming_final = ConvoScreen:new {
	id = "tier3_train_programming_final",
	leftDialog = "@conversation/naboo_privateer_tier3:s_4fc6a099", -- Aw. I think I'm actually going to miss you...
	stopConversation = "true",
	options = {}
}
dravis_convo:addScreen(dravis_tier3_train_programming_final);

dravis_tier3_first_mission = ConvoScreen:new {
	id = "tier3_first_mission",
	leftDialog = "@conversation/naboo_privateer_tier3:s_a31b65f9", -- %TU. You're the new one.
	stopConversation = "false",
	options = {
		{"@conversation/naboo_privateer_tier3:s_19425c2f", "tier3_im_dulios"}, -- You are?
		{"@conversation/naboo_privateer_tier3:s_731caa45", "tier3_have_mission"}, -- Got a mission for me?
	}
}
dravis_convo:addScreen(dravis_tier3_first_mission);

dravis_tier3_im_dulios = ConvoScreen:new {
	id = "tier3_im_dulios",
	leftDialog = "@conversation/naboo_privateer_tier3:s_88a726df", -- Hey, we'll see what you say when you're on this side of the desk. Let's get you started.
	stopConversation = "false",
	options = {
		{"@conversation/naboo_privateer_tier3:s_b1da46d", "tier3_have_mission"}, -- Where do I start?
	}
}
dravis_convo:addScreen(dravis_tier3_im_dulios);

dravis_tier3_have_mission = ConvoScreen:new {
	id = "tier3_have_mission",
	leftDialog = "@conversation/naboo_privateer_tier3:s_666cac71", -- These guys pose a SERIOUS threat to the royal family - hell, to this entire planet.
	stopConversation = "false",
	options = {
		{"@conversation/naboo_privateer_tier3:s_5bd69df6", "tier3_blacksun_threat"}, -- What do you need me to do?
	}
}
dravis_convo:addScreen(dravis_tier3_have_mission);

dravis_tier3_blacksun_threat = ConvoScreen:new {
	id = "tier3_blacksun_threat",
	leftDialog = "@conversation/naboo_privateer_tier3:s_e1e07205", -- All you need to do is stop his ship. The boys in the lab are putting together a little surprise for him, but it's up to you to deliver the package. Get over to the Dantooine System; we'll update you from there.
	stopConversation = "false",
	options = {
		{"@conversation/naboo_privateer_tier3:s_7478d95d", "tier3_accept_first_mission"}, -- Loud and clear. Where to?
	}
}
dravis_convo:addScreen(dravis_tier3_blacksun_threat);

dravis_tier3_accept_first_mission = ConvoScreen:new {
	id = "tier3_accept_first_mission",
	leftDialog = "@conversation/naboo_privateer_tier3:s_46eb0ec8", -- First, go to Dantooine. Just follow the data in your nav system. And keep your eyes open. This guy's a professional.
	stopConversation = "true",
	options = {}
}
dravis_convo:addScreen(dravis_tier3_accept_first_mission);

dravis_tier3_failed_first_mission = ConvoScreen:new {
	id = "tier3_failed_first_mission",
	leftDialog = "@conversation/naboo_privateer_tier3:s_97e76dd", -- This Royal Security Forces assignment isn't so easy after all, is it?
	stopConversation = "false",
	options = {
		{"@conversation/naboo_privateer_tier3:s_b144d69b", "tier3_try_first_again"}, -- Nothing I can't handle.
	}
}
dravis_convo:addScreen(dravis_tier3_failed_first_mission);

dravis_tier3_try_first_again = ConvoScreen:new {
	id = "tier3_try_first_again",
	leftDialog = "@conversation/naboo_privateer_tier3:s_46eb0ec8", -- First, go to Dantooine. Just follow the data in your nav system. And keep your eyes open. This guy's a professional.
	stopConversation = "true",
	options = {}
}
dravis_convo:addScreen(dravis_tier3_try_first_again);

dravis_tier3_complete_mission1 = ConvoScreen:new {
	id = "tier3_complete_mission1",
	leftDialog = "@conversation/naboo_privateer_tier3:s_8de81731", -- I'm really going to miss that Saymonz Varg.
	stopConversation = "false",
	options = {}
}
dravis_convo:addScreen(dravis_tier3_complete_mission1);

dravis_tier3_second_mission = ConvoScreen:new {
	id = "tier3_second_mission",
	leftDialog = "@conversation/naboo_privateer_tier3:s_5075e20b", -- Your new mission targets a criminal of a different type. I'm talking about diplomats.
	stopConversation = "false",
	options = {
		{"@conversation/naboo_privateer_tier3:s_66f6527f", "tier3_diplomats_know"}, -- Do the diplomats know?
		{"@conversation/naboo_privateer_tier3:s_9d9af42e", "tier3_where_diplomats"}, -- Where are these diplomats?
	}
}
dravis_convo:addScreen(dravis_tier3_second_mission);

dravis_tier3_diplomats_know = ConvoScreen:new {
	id = "tier3_diplomats_know",
	leftDialog = "@conversation/naboo_privateer_tier3:s_68d4ba6b", -- To be honest, it's probably not them. It's probably smugglers taking advantage of the opportunity, and hiding gear on their ship. Doesn't matter. Same difference.
	stopConversation = "false",
	options = {
		{"@conversation/naboo_privateer_tier3:s_a41bb8c7", "tier3_how_suspicious"}, -- How can you be so suspicious?
	}
}
dravis_convo:addScreen(dravis_tier3_diplomats_know);

dravis_tier3_how_suspicious = ConvoScreen:new {
	id = "tier3_how_suspicious",
	leftDialog = "@conversation/naboo_privateer_tier3:s_83905129", -- Unlike you, I DO get paid the big bucks, %NU, and it's on account of my suspicious nature. Smugglers may be packing these ships with contraband.
	stopConversation = "false",
	options = {
		{"@conversation/naboo_privateer_tier3:s_c089dba4", "tier3_just_am"}, -- I just am.
	}
}
dravis_convo:addScreen(dravis_tier3_how_suspicious);

dravis_tier3_just_am = ConvoScreen:new {
	id = "tier3_just_am",
	leftDialog = "@conversation/naboo_privateer_tier3:s_c65cf2da", -- What's not to like?
	stopConversation = "false",
	options = {
		{"@conversation/naboo_privateer_tier3:s_9d9af42e", "tier3_where_diplomats"}, -- Where are these diplomats?
	}
}
dravis_convo:addScreen(dravis_tier3_just_am);

dravis_tier3_where_diplomats = ConvoScreen:new {
	id = "tier3_where_diplomats",
	leftDialog = "@conversation/naboo_privateer_tier3:s_76734574", -- En route. Fly out to the waypoint and get ready to inspect each and every one of them.
	stopConversation = "false",
	options = {
		{"@conversation/naboo_privateer_tier3:s_6c251948", "tier3_accept_second_mission"}, -- You got it.
	}
}
dravis_convo:addScreen(dravis_tier3_where_diplomats);

dravis_tier3_accept_second_mission = ConvoScreen:new {
	id = "tier3_accept_second_mission",
	leftDialog = "@conversation/naboo_privateer_tier3:s_c4095762", -- Fly your ship out to the waypoint. Inspect the diplomats' ships. Use some pretext if you have to. See what you can find.
	stopConversation = "true",
	options = {}
}
dravis_convo:addScreen(dravis_tier3_accept_second_mission);

dravis_tier3_failed_second_mission = ConvoScreen:new {
	id = "tier3_failed_second_mission",
	leftDialog = "@conversation/naboo_privateer_tier3:s_53daee1c", -- You're starting to get a bad reputation.
	stopConversation = "false",
	options = {
		{"@conversation/naboo_privateer_tier3:s_83b47a80", "tier3_stories_about_me"}, -- You telling stories about me?
	}
}
dravis_convo:addScreen(dravis_tier3_failed_second_mission);

dravis_tier3_stories_about_me = ConvoScreen:new {
	id = "tier3_stories_about_me",
	leftDialog = "@conversation/naboo_privateer_tier3:s_57d34626", -- I don't need to! People know those hunters are using you for target practice. Get back out there - and try fighting back this time.
	stopConversation = "true",
	options = {}
}
dravis_convo:addScreen(dravis_tier3_stories_about_me);

dravis_tier3_complete_mission2 = ConvoScreen:new {
	id = "tier3_complete_mission2",
	leftDialog = "@conversation/naboo_privateer_tier3:s_47152ac5", -- Oh yeah. The worst of the worst. That data you intercepted has led us to a real hornet's nest of assassins and terrorists.
	stopConversation = "false",
	options = {}
}
dravis_convo:addScreen(dravis_tier3_complete_mission2);

dravis_tier3_third_mission = ConvoScreen:new {
	id = "tier3_third_mission",
	leftDialog = "@conversation/naboo_privateer_tier3:s_70e76a9a", -- OK, %NU, no more busywork. Time for some good old-fashioned killing. How does that sound?
	stopConversation = "false",
	options = {
		{"@conversation/naboo_privateer_tier3:s_5a889c20", "tier3_rodians_feel"}, -- Like a dream come true.
		{"@conversation/naboo_privateer_tier3:s_5a2317e2", "tier3_killing_bad_guys"}, -- Depends. Am I killing bad guys?
	}
}
dravis_convo:addScreen(dravis_tier3_third_mission);

dravis_tier3_rodians_feel = ConvoScreen:new {
	id = "tier3_rodians_feel",
	leftDialog = "@conversation/naboo_privateer_tier3:s_b7137723", -- OK. Then let's get started. How do you feel about Rodians?
	stopConversation = "false",
	options = {
		{"@conversation/naboo_privateer_tier3:s_589399fa", "tier3_love_em"}, -- Love 'em.
		{"@conversation/naboo_privateer_tier3:s_af5ccac", "tier3_hate_em"}, -- Hate 'em.
	}
}
dravis_convo:addScreen(dravis_tier3_rodians_feel);

dravis_tier3_killing_bad_guys = ConvoScreen:new {
	id = "tier3_killing_bad_guys",
	leftDialog = "@conversation/naboo_privateer_tier3:s_ab3f1614", -- Boy, do I. This is a good one. I'd like to do this myself.
	stopConversation = "false",
	options = {
		{"@conversation/naboo_privateer_tier3:s_a09da7f1", "tier3_rodians_feel"}, -- You like that?
	}
}
dravis_convo:addScreen(dravis_tier3_killing_bad_guys);

dravis_tier3_love_em = ConvoScreen:new {
	id = "tier3_love_em",
	leftDialog = "@conversation/naboo_privateer_tier3:s_4bdc789d", -- Hope you're being sarcastic. You're looking for a Rodian assassin.
	stopConversation = "false",
	options = {
		{"@conversation/naboo_privateer_tier3:s_51ca1520", "tier3_rodian_killed"}, -- An assassin? Who's he killed?
	}
}
dravis_convo:addScreen(dravis_tier3_love_em);

dravis_tier3_hate_em = ConvoScreen:new {
	id = "tier3_hate_em",
	leftDialog = "@conversation/naboo_privateer_tier3:s_bf22a8c8", -- Can't say I blame 'em. Got no use for them myself. But this Rodian's a real pain in the keister. We think he's killed two ambassadors already.
	stopConversation = "false",
	options = {
		{"@conversation/naboo_privateer_tier3:s_24ee6c29", "tier3_shooting_politicians"}, -- Someone's always shooting at politicians.
	}
}
dravis_convo:addScreen(dravis_tier3_hate_em);

dravis_tier3_rodian_killed = ConvoScreen:new {
	id = "tier3_rodian_killed",
	leftDialog = "@conversation/naboo_privateer_tier3:s_96924c42", -- A couple of ambassadors, for starters. But that's not why we're interested in him. Word is, his next target is the Queen.
	stopConversation = "false",
	options = {
		{"@conversation/naboo_privateer_tier3:s_b8c1a96f", "tier3_more_complicated"}, -- Hm. That makes it a little more complicated.
	}
}
dravis_convo:addScreen(dravis_tier3_rodian_killed);

dravis_tier3_shooting_politicians = ConvoScreen:new {
	id = "tier3_shooting_politicians",
	leftDialog = "@conversation/naboo_privateer_tier3:s_919b5558", -- It's not the ambassadors they're worried about. This guy's gunning for the Queen.
	stopConversation = "false",
	options = {
		{"@conversation/naboo_privateer_tier3:s_ebe811bd", "tier3_more_complicated"}, -- That makes it a little more complicated.
	}
}
dravis_convo:addScreen(dravis_tier3_shooting_politicians);

dravis_tier3_more_complicated = ConvoScreen:new {
	id = "tier3_more_complicated",
	leftDialog = "@conversation/naboo_privateer_tier3:s_d5861157", -- The Royal Family is always a high-profile target, buddy. Believe me. The Queen's got more bounties on her head than you've got toes on your feet.
	stopConversation = "false",
	options = {
		{"@conversation/naboo_privateer_tier3:s_692788e8", "tier3_find_charmer"}, -- Where can I find this charmer?
	}
}
dravis_convo:addScreen(dravis_tier3_more_complicated);

dravis_tier3_find_charmer = ConvoScreen:new {
	id = "tier3_find_charmer",
	leftDialog = "@conversation/naboo_privateer_tier3:s_f6976b78", -- Sounds like a plan. Go to the Dantooine system. Follow the coordinates on your ship's nav system; should lead you right to him. And you've got the element of surprise - I think.
	stopConversation = "false",
	options = {
		{"@conversation/naboo_privateer_tier3:s_a5fe9928", "tier3_accept_third_mission"}, -- I'll take care of it.
	}
}
dravis_convo:addScreen(dravis_tier3_find_charmer);

dravis_tier3_accept_third_mission = ConvoScreen:new {
	id = "tier3_accept_third_mission",
	leftDialog = "@conversation/naboo_privateer_tier3:s_b679efe", -- See that you do.
	stopConversation = "true",
	options = {}
}
dravis_convo:addScreen(dravis_tier3_accept_third_mission);

dravis_tier3_failed_third_mission = ConvoScreen:new {
	id = "tier3_failed_third_mission",
	leftDialog = "@conversation/naboo_privateer_tier3:s_cae364a9", -- That Rodian is giving you a run for your money.
	stopConversation = "false",
	options = {
		{"@conversation/naboo_privateer_tier3:s_18868d04", "tier3_i_was_better"}, -- I was better.
	}
}
dravis_convo:addScreen(dravis_tier3_failed_third_mission);

dravis_tier3_i_was_better = ConvoScreen:new {
	id = "tier3_i_was_better",
	leftDialog = "@conversation/naboo_privateer_tier3:s_2852c031", -- Prove it. Finish your job.
	stopConversation = "true",
	options = {}
}
dravis_convo:addScreen(dravis_tier3_i_was_better);

dravis_tier3_complete_mission3 = ConvoScreen:new {
	id = "tier3_complete_mission3",
	leftDialog = "@conversation/naboo_privateer_tier3:s_b61d6d4f", -- OK! That's one less Rodian messing up the place. Nice work. Time to get back to your training.
	stopConversation = "false",
	options = {}
}
dravis_convo:addScreen(dravis_tier3_complete_mission3);

dravis_tier3_fourth_mission = ConvoScreen:new {
	id = "tier3_fourth_mission",
	leftDialog = "@conversation/naboo_privateer_tier3:s_333a7093", -- This is a good one; wish I could do it myself. You're going after a Rodian assassin.
	stopConversation = "false",
	options = {
		{"@conversation/naboo_privateer_tier3:s_e7b0a6c9", "tier3_another_assassin"}, -- Another assassin?
		{"@conversation/naboo_privateer_tier3:s_719a036e", "tier3_who"}, -- Who?
	}
}
dravis_convo:addScreen(dravis_tier3_fourth_mission);

dravis_tier3_another_assassin = ConvoScreen:new {
	id = "tier3_another_assassin",
	leftDialog = "@conversation/naboo_privateer_tier3:s_acc52186", -- There's more?
	stopConversation = "false",
	options = {
		{"@conversation/naboo_privateer_tier3:s_c551ea96", "tier3_beldini_target"}, -- Looks that way.
	}
}
dravis_convo:addScreen(dravis_tier3_another_assassin);

dravis_tier3_who = ConvoScreen:new {
	id = "tier3_who",
	leftDialog = "@conversation/naboo_privateer_tier3:s_5ed53186", -- A human, name of Beldini. The worst of the bunch. He'd kill ya as soon as look at ya.
	stopConversation = "false",
	options = {
		{"@conversation/naboo_privateer_tier3:s_981c060d", "tier3_shoot_first"}, -- Then I guess I better shoot first.
	}
}
dravis_convo:addScreen(dravis_tier3_who);

dravis_tier3_beldini_target = ConvoScreen:new {
	id = "tier3_beldini_target",
	leftDialog = "@conversation/naboo_privateer_tier3:s_3c432969", -- Right. Your first target is a human, Beldini. Terrorist, killer, all-around bad guy.
	stopConversation = "false",
	options = {
		{"@conversation/naboo_privateer_tier3:s_6bdcb65c", "tier3_just_tell_where"}, -- Just tell me where to go.
	}
}
dravis_convo:addScreen(dravis_tier3_beldini_target);

dravis_tier3_shoot_first = ConvoScreen:new {
	id = "tier3_shoot_first",
	leftDialog = "@conversation/naboo_privateer_tier3:s_46eb0ec8", -- First, go to Dantooine. Just follow the data in your nav system. And keep your eyes open. This guy's a professional.
	stopConversation = "false",
	options = {
		{"@conversation/naboo_privateer_tier3:s_ff7bebda", "tier3_accept_fourth_mission"}, -- Don't let me down, ok? You'd hate to see a grown man cry.
	}
}
dravis_convo:addScreen(dravis_tier3_shoot_first);

dravis_tier3_just_tell_where = ConvoScreen:new {
	id = "tier3_just_tell_where",
	leftDialog = "@conversation/naboo_privateer_tier3:s_46eb0ec8", -- First, go to Dantooine. Just follow the data in your nav system. And keep your eyes open. This guy's a professional.
	stopConversation = "false",
	options = {
		{"@conversation/naboo_privateer_tier3:s_f69a2921", "tier3_accept_fourth_mission"}, -- Glad to hear it.
	}
}
dravis_convo:addScreen(dravis_tier3_just_tell_where);

dravis_tier3_accept_fourth_mission = ConvoScreen:new {
	id = "tier3_accept_fourth_mission",
	leftDialog = "@conversation/naboo_privateer_tier3:s_3fa8b6f1", -- Coordinates are in your ship. You're clear to leave.
	stopConversation = "true",
	options = {}
}
dravis_convo:addScreen(dravis_tier3_accept_fourth_mission);

dravis_tier3_failed_fourth_mission = ConvoScreen:new {
	id = "tier3_failed_fourth_mission",
	leftDialog = "@conversation/naboo_privateer_tier3:s_145dcab", -- NO! I only like pilots that finish their missions! Get back out there!
	stopConversation = "false",
	options = {
		{"@conversation/naboo_privateer_tier3:s_b144d69b", "tier3_nothing_cant_handle"}, -- Nothing I can't handle.
	}
}
dravis_convo:addScreen(dravis_tier3_failed_fourth_mission);

dravis_tier3_nothing_cant_handle = ConvoScreen:new {
	id = "tier3_nothing_cant_handle",
	leftDialog = "@conversation/naboo_privateer_tier3:s_ff5d0ba8", -- Because those lowlifes are using you for target practice. Get back up there and take those guys out!
	stopConversation = "true",
	options = {}
}
dravis_convo:addScreen(dravis_tier3_nothing_cant_handle);

dravis_tier3_complete_mission4 = ConvoScreen:new {
	id = "tier3_complete_mission4",
	leftDialog = "@conversation/naboo_privateer_tier3:s_ae2d3229", -- I salute you, %TU. You're one heck of a pilot. Is there anything you DON'T know?
	stopConversation = "false",
	options = {}
}
dravis_convo:addScreen(dravis_tier3_complete_mission4);

dravis_tier3_on_mission = ConvoScreen:new {
	id = "tier3_on_mission",
	leftDialog = "@conversation/naboo_privateer_tier3:s_327eb2d6", -- Oh yeah, that's right, I forgot. How about you GO DO THAT ALREADY.
	stopConversation = "true",
	options = {}
}
dravis_convo:addScreen(dravis_tier3_on_mission);

dravis_tier3_train_warships = ConvoScreen:new {
	id = "tier3_train_warships",
	leftDialog = "@conversation/naboo_privateer_tier3:s_89ff8475", -- Obviously. This pilot will give you a lesson. Afterwards, you come see me for your next mission.
	stopConversation = "true",
	options = {}
}
dravis_convo:addScreen(dravis_tier3_train_warships);

dravis_tier3_train_components = ConvoScreen:new {
	id = "tier3_train_components",
	leftDialog = "@conversation/naboo_privateer_tier3:s_9b1d2d87", -- Done. This pilot will give you a lesson. Afterwards, you come see me for your next mission.
	stopConversation = "true",
	options = {}
}
dravis_convo:addScreen(dravis_tier3_train_components);

dravis_tier3_train_techniques = ConvoScreen:new {
	id = "tier3_train_techniques",
	leftDialog = "@conversation/naboo_privateer_tier3:s_bd234730", -- You got it. This pilot will give you a lesson. Afterwards, you come see me for your next mission.
	stopConversation = "true",
	options = {}
}
dravis_convo:addScreen(dravis_tier3_train_techniques);

dravis_tier3_train_programming = ConvoScreen:new {
	id = "tier3_train_programming",
	leftDialog = "@conversation/naboo_privateer_tier3:s_dcf601cc", -- Don't we all! This pilot will give you a lesson. Afterwards, you come see me for your next mission.
	stopConversation = "true",
	options = {}
}
dravis_convo:addScreen(dravis_tier3_train_programming);

dravis_tier4_on_mission = ConvoScreen:new {
	id = "tier4_on_mission",
	leftDialog = "@conversation/naboo_privateer_tier4:s_67b2bdc1", -- Hurry up. It's time to get back to work.
	stopConversation = "true",
	options = {}
}
dravis_convo:addScreen(dravis_tier4_on_mission);

dravis_tier4_initial_briefing = ConvoScreen:new {
	id = "tier4_initial_briefing",
	leftDialog = "@conversation/naboo_privateer_tier4:s_cdffba3e", -- Tsk. You're late. That's not a good way to start your tour with me, pilot. Are you ready to begin? I have a briefing prepped for you.
	stopConversation = "false",
	options = {
		{"@conversation/naboo_privateer_tier4:s_c82e9a2f", "tier4_first_mission"}, -- Yes, please.
	}
}
dravis_convo:addScreen(dravis_tier4_initial_briefing);

dravis_tier4_first_mission = ConvoScreen:new {
	id = "tier4_first_mission",
	leftDialog = "@conversation/naboo_privateer_tier4:s_a82676b8", -- Royal Security Forces are using a deep space scan vessel in Endor space.
	stopConversation = "false",
	options = {
		{"@conversation/naboo_privateer_tier4:s_b2e340f6", "tier4_first_mission_details"}, -- What's that?
		{"@conversation/naboo_privateer_tier4:s_d55f2579", "accept_tier4_first_mission"}, -- I'm ready to go.
	}
}
dravis_convo:addScreen(dravis_tier4_first_mission);

dravis_tier4_first_mission_details = ConvoScreen:new {
	id = "tier4_first_mission_details",
	leftDialog = "@conversation/naboo_privateer_tier4:s_a224e8fe", -- A deep space scan vessel. It's an RSF ship. We're using it to investigate Endor space.
	stopConversation = "false",
	options = {
		{"@conversation/naboo_privateer_tier4:s_d55f2579", "accept_tier4_first_mission"}, -- I'm ready to go.
	}
}
dravis_convo:addScreen(dravis_tier4_first_mission_details);

dravis_accept_tier4_first_mission = ConvoScreen:new {
	id = "accept_tier4_first_mission",
	leftDialog = "@conversation/naboo_privateer_tier4:s_90422eb5", -- Good luck.
	stopConversation = "true",
	options = {}
}
dravis_convo:addScreen(dravis_accept_tier4_first_mission);

dravis_failed_tier4_first_mission = ConvoScreen:new {
	id = "failed_tier4_first_mission",
	leftDialog = "@conversation/naboo_privateer_tier4:s_d858532", -- Get out there and try again.
	stopConversation = "true",
	options = {}
}
dravis_convo:addScreen(dravis_failed_tier4_first_mission);

dravis_tier4_first_mission_success = ConvoScreen:new {
	id = "tier4_first_mission_success",
	leftDialog = "@conversation/naboo_privateer_tier4:s_bdc28bb4", -- You did a nice job protecting that scan vessel. We took a look at the tapes.
	stopConversation = "false",
	options = {
		{"@conversation/naboo_privateer_tier4:s_8289ab5b", "tier4_second_mission"}, -- I'm ready for my next mission.
	}
}
dravis_convo:addScreen(dravis_tier4_first_mission_success);

dravis_tier4_second_mission = ConvoScreen:new {
	id = "tier4_second_mission",
	leftDialog = "@conversation/naboo_privateer_tier4:s_9145ef83", -- Listen. There's a heavy mining freighter passing through Endor space.
	stopConversation = "false",
	options = {
		{"@conversation/naboo_privateer_tier4:s_25f8ac14", "tier4_second_mission_details"}, -- What's it carrying?
		{"@conversation/naboo_privateer_tier4:s_d55f2579", "accept_tier4_second_mission"}, -- I'm ready to go.
	}
}
dravis_convo:addScreen(dravis_tier4_second_mission);

dravis_tier4_second_mission_details = ConvoScreen:new {
	id = "tier4_second_mission_details",
	leftDialog = "@conversation/naboo_privateer_tier4:s_88678c75", -- Supplies, a few passengers, nothing special.
	stopConversation = "false",
	options = {
		{"@conversation/naboo_privateer_tier4:s_8462774c", "tier4_second_mission_go"}, -- So I should inspect the ship.
	}
}
dravis_convo:addScreen(dravis_tier4_second_mission_details);

dravis_tier4_second_mission_go = ConvoScreen:new {
	id = "tier4_second_mission_go",
	leftDialog = "@conversation/naboo_privateer_tier4:s_87246f3e", -- You got it. Go check it out. And I don't mean one quick pass, either. Take a GOOD look...
	stopConversation = "false",
	options = {
		{"@conversation/naboo_privateer_tier4:s_d55f2579", "accept_tier4_second_mission"}, -- I'm ready to go.
	}
}
dravis_convo:addScreen(dravis_tier4_second_mission_go);

dravis_accept_tier4_second_mission = ConvoScreen:new {
	id = "accept_tier4_second_mission",
	leftDialog = "@conversation/naboo_privateer_tier4:s_9281abbb", -- Go get 'em, tiger.
	stopConversation = "true",
	options = {}
}
dravis_convo:addScreen(dravis_accept_tier4_second_mission);

dravis_failed_tier4_second_mission = ConvoScreen:new {
	id = "failed_tier4_second_mission",
	leftDialog = "@conversation/naboo_privateer_tier4:s_d858532", -- Get out there and try again.
	stopConversation = "true",
	options = {}
}
dravis_convo:addScreen(dravis_failed_tier4_second_mission);

dravis_tier4_second_mission_success = ConvoScreen:new {
	id = "tier4_second_mission_success",
	leftDialog = "@conversation/naboo_privateer_tier4:s_41799e3b", -- You did good. I have a new mission for you.
	stopConversation = "false",
	options = {
		{"@conversation/naboo_privateer_tier4:s_614d7ac4", "tier4_third_mission"}, -- What is the mission?
	}
}
dravis_convo:addScreen(dravis_tier4_second_mission_success);

dravis_tier4_third_mission = ConvoScreen:new {
	id = "tier4_third_mission",
	leftDialog = "@conversation/naboo_privateer_tier4:s_b5ee61ed", -- A pair of Imperial freighters have entered Yavin space...
	stopConversation = "false",
	options = {
		{"@conversation/naboo_privateer_tier4:s_77e48d5b", "tier4_third_mission_details"}, -- What do you mean?
		{"@conversation/naboo_privateer_tier4:s_d55f2579", "accept_tier4_third_mission"}, -- I'm ready to go.
	}
}
dravis_convo:addScreen(dravis_tier4_third_mission);

dravis_tier4_third_mission_details = ConvoScreen:new {
	id = "tier4_third_mission_details",
	leftDialog = "@conversation/naboo_privateer_tier4:s_7378bc13", -- You know how testy Imperial freighter captains can be...
	stopConversation = "false",
	options = {
		{"@conversation/naboo_privateer_tier4:s_d55f2579", "accept_tier4_third_mission"}, -- I'm ready to go.
	}
}
dravis_convo:addScreen(dravis_tier4_third_mission_details);

dravis_accept_tier4_third_mission = ConvoScreen:new {
	id = "accept_tier4_third_mission",
	leftDialog = "@conversation/naboo_privateer_tier4:s_ff66ed8b", -- You don't have to love 'em. You just have to keep 'em happy. Get out there and take care of those captains.
	stopConversation = "true",
	options = {}
}
dravis_convo:addScreen(dravis_accept_tier4_third_mission);

dravis_failed_tier4_third_mission = ConvoScreen:new {
	id = "failed_tier4_third_mission",
	leftDialog = "@conversation/naboo_privateer_tier4:s_d858532", -- Get out there and try again.
	stopConversation = "true",
	options = {}
}
dravis_convo:addScreen(dravis_failed_tier4_third_mission);

dravis_tier4_third_mission_success = ConvoScreen:new {
	id = "tier4_third_mission_success",
	leftDialog = "@conversation/naboo_privateer_tier4:s_44b1cd3c", -- Mm. We'll see. Let's get you going on a new mission.
	stopConversation = "false",
	options = {
		{"@conversation/naboo_privateer_tier4:s_614d7ac4", "tier4_fourth_mission"}, -- What is the mission?
	}
}
dravis_convo:addScreen(dravis_tier4_third_mission_success);

dravis_tier4_fourth_mission = ConvoScreen:new {
	id = "tier4_fourth_mission",
	leftDialog = "@conversation/naboo_privateer_tier4:s_1cf9a0f6", -- I've saved the best for last. I need a pilot willing to fly sorties against Black Sun pirates...
	stopConversation = "false",
	options = {
		{"@conversation/naboo_privateer_tier4:s_e9ea6fec", "tier4_fourth_mission_details"}, -- Good. Because I want to go after them.
		{"@conversation/naboo_privateer_tier4:s_d55f2579", "accept_tier4_fourth_mission"}, -- I'm ready to go.
	}
}
dravis_convo:addScreen(dravis_tier4_fourth_mission);

dravis_tier4_fourth_mission_details = ConvoScreen:new {
	id = "tier4_fourth_mission_details",
	leftDialog = "@conversation/naboo_privateer_tier4:s_fd271a84", -- You read my mind. But this time, you're not going alone. We need a show of force. You'll be joining a fleet of RSF pilots in a sortie against the Black Sun.
	stopConversation = "false",
	options = {
		{"@conversation/naboo_privateer_tier4:s_d55f2579", "accept_tier4_fourth_mission"}, -- I'm ready to go.
	}
}
dravis_convo:addScreen(dravis_tier4_fourth_mission_details);

dravis_accept_tier4_fourth_mission = ConvoScreen:new {
	id = "accept_tier4_fourth_mission",
	leftDialog = "@conversation/naboo_privateer_tier4:s_9281abbb", -- Go get 'em, tiger.
	stopConversation = "true",
	options = {}
}
dravis_convo:addScreen(dravis_accept_tier4_fourth_mission);

dravis_failed_tier4_fourth_mission = ConvoScreen:new {
	id = "failed_tier4_fourth_mission",
	leftDialog = "@conversation/naboo_privateer_tier4:s_a9d8ef68", -- Give it another shot. Those Black Suns aren't so tough.
	stopConversation = "true",
	options = {}
}
dravis_convo:addScreen(dravis_failed_tier4_fourth_mission);

dravis_tier4_fourth_mission_success = ConvoScreen:new {
	id = "tier4_fourth_mission_success",
	leftDialog = "@conversation/naboo_privateer_tier4:s_92fa7352", -- I have just been informed that Grand Admiral Nial Declann has ordered that you be transferred to his squadron, effective immediately...
	stopConversation = "false",
	options = {
		{"@conversation/naboo_privateer_tier4:s_9fe8c7e7", "master_what_want"}, -- Does it say what they want from me?
		{"@conversation/naboo_privateer_tier4:s_7177c3f2", "master_who_declann"}, -- Who is Grand Admiral Nial Declann?
		{"@conversation/naboo_privateer_tier4:s_50d4081c", "master_where_report"}, -- Where do I report?
		{"@conversation/naboo_privateer_tier4:s_57f232d6", "master_becoming_imperial"}, -- I am going to become an Imperial?
		{"@conversation/naboo_privateer_tier4:s_1adbadc4", "accept_master_mission"}, -- I'm ready.
	}
}
dravis_convo:addScreen(dravis_tier4_fourth_mission_success);

dravis_master_mission = ConvoScreen:new {
	id = "master_mission",
	leftDialog = "@conversation/naboo_privateer_tier4:s_92fa7352", -- I have just been informed that Grand Admiral Nial Declann has ordered that you be transferred to his squadron, effective immediately...
	stopConversation = "false",
	options = {
		{"@conversation/naboo_privateer_tier4:s_9fe8c7e7", "master_what_want"}, -- Does it say what they want from me?
		{"@conversation/naboo_privateer_tier4:s_7177c3f2", "master_who_declann"}, -- Who is Grand Admiral Nial Declann?
		{"@conversation/naboo_privateer_tier4:s_50d4081c", "master_where_report"}, -- Where do I report?
		{"@conversation/naboo_privateer_tier4:s_57f232d6", "master_becoming_imperial"}, -- I am going to become an Imperial?
		{"@conversation/naboo_privateer_tier4:s_1adbadc4", "accept_master_mission"}, -- I'm ready.
	}
}
dravis_convo:addScreen(dravis_master_mission);

dravis_master_what_want = ConvoScreen:new {
	id = "master_what_want",
	leftDialog = "@conversation/naboo_privateer_tier4:s_492a501d", -- I wish I knew! That's highly classified information. The Admiral will explain everything to you. Pack your bags! The Admiral is waiting.
	stopConversation = "false",
	options = {
		{"@conversation/naboo_privateer_tier4:s_1adbadc4", "accept_master_mission"}, -- I'm ready.
	}
}
dravis_convo:addScreen(dravis_master_what_want);

dravis_master_who_declann = ConvoScreen:new {
	id = "master_who_declann",
	leftDialog = "@conversation/naboo_privateer_tier4:s_cf0a01fd", -- Well, let me put it this way. In the Imperial Navy, power is held by only a few men...
	stopConversation = "false",
	options = {
		{"@conversation/naboo_privateer_tier4:s_1adbadc4", "accept_master_mission"}, -- I'm ready.
	}
}
dravis_convo:addScreen(dravis_master_who_declann);

dravis_master_where_report = ConvoScreen:new {
	id = "master_where_report",
	leftDialog = "@conversation/naboo_privateer_tier4:s_cd140a4", -- According to this, you are to report directly to the Grand Admiral at the Theed Palace...
	stopConversation = "false",
	options = {
		{"@conversation/naboo_privateer_tier4:s_1adbadc4", "accept_master_mission"}, -- I'm ready.
	}
}
dravis_convo:addScreen(dravis_master_where_report);

dravis_master_becoming_imperial = ConvoScreen:new {
	id = "master_becoming_imperial",
	leftDialog = "@conversation/naboo_privateer_tier4:s_5d72fdfa", -- Well, not officially. But this is a big opportunity for you. You will be working under them until they no longer are in need of your services. You will retain all of your RSF rankings and privileges.
	stopConversation = "false",
	options = {
		{"@conversation/naboo_privateer_tier4:s_1adbadc4", "accept_master_mission"}, -- I'm ready.
	}
}
dravis_convo:addScreen(dravis_master_becoming_imperial);

dravis_accept_master_mission = ConvoScreen:new {
	id = "accept_master_mission",
	leftDialog = "@conversation/naboo_privateer_tier4:s_42d6c3ee", -- Go on. Your ship is waiting.
	stopConversation = "true",
	options = {}
}
dravis_convo:addScreen(dravis_accept_master_mission);

dravis_tier4_completed = ConvoScreen:new {
	id = "tier4_completed",
	leftDialog = "@conversation/naboo_privateer_tier4:s_bd35f50b", -- I see you made it back from serving with the Empire in one piece. I am very glad of that. I have some jobs for you if you are interested.
	stopConversation = "false",
	options = {
		{"@conversation/naboo_privateer_tier4:s_85a73c8b", "tier4_duty_repeat"}, -- So do you have a mission for me?
	}
}
dravis_convo:addScreen(dravis_tier4_completed);

dravis_ready_train_tier4 = ConvoScreen:new {
	id = "ready_train_tier4",
	leftDialog = "@conversation/naboo_privateer_tier4:s_d91c04b2", -- I'm supposed to give you a skill. Hurry up. Let's get this over with.
	stopConversation = "false",
	options = {
		-- Options added dynamically via handler
	}
}
dravis_convo:addScreen(dravis_ready_train_tier4);

dravis_tier4_train_fighters = ConvoScreen:new {
	id = "tier4_train_fighters",
	leftDialog = "@conversation/naboo_privateer_trainer_1:s_cd72f93", -- Good choice.
	stopConversation = "true",
	options = {}
}
dravis_convo:addScreen(dravis_tier4_train_fighters);

dravis_tier4_train_component = ConvoScreen:new {
	id = "tier4_train_component",
	leftDialog = "@conversation/naboo_privateer_trainer_1:s_cd72f93", -- Good choice.
	stopConversation = "true",
	options = {}
}
dravis_convo:addScreen(dravis_tier4_train_component);

dravis_tier4_train_basics = ConvoScreen:new {
	id = "tier4_train_basics",
	leftDialog = "@conversation/naboo_privateer_trainer_1:s_cd72f93", -- Good choice.
	stopConversation = "true",
	options = {}
}
dravis_convo:addScreen(dravis_tier4_train_basics);

dravis_tier4_train_droid = ConvoScreen:new {
	id = "tier4_train_droid",
	leftDialog = "@conversation/naboo_privateer_trainer_1:s_cd72f93", -- Good choice.
	stopConversation = "true",
	options = {}
}
dravis_convo:addScreen(dravis_tier4_train_droid);

dravis_tier4_duty_missions = ConvoScreen:new {
	id = "tier4_duty_missions",
	leftDialog = "@conversation/naboo_privateer_tier4:s_24231574", -- That's a nice attitude for a pilot to have. Actually, I do have some duty missions to assign. Take a look at what there is. Shall I give you a briefing?
	stopConversation = "false",
	options = {
		{"@conversation/naboo_privateer_tier4:s_e1e40ead", "tier4_duty_brief_destroy"}, -- That would be nice.
	}
}
dravis_convo:addScreen(dravis_tier4_duty_missions);

dravis_tier4_duty_repeat = ConvoScreen:new {
	id = "tier4_duty_repeat",
	leftDialog = "@conversation/naboo_privateer_tier4:s_3f76a413", -- I like it when my pilots stay busy. Why don't you volunteer for something? Or I can give you the briefing again, if you like.
	stopConversation = "false",
	options = {
		{"@conversation/naboo_privateer_tier4:s_62c8be58", "accept_tier4_duty1"}, -- I can handle those Black Suns.
		{"@conversation/naboo_privateer_tier4:s_619658af", "accept_tier4_duty2"}, -- I'll escort that mining transport.
		{"@conversation/naboo_privateer_tier4:s_7869de8a", "accept_tier4_duty3"}, -- What's wrong with that Ay'Nat ship?
		{"@conversation/naboo_privateer_tier4:s_413ac49a", "accept_tier4_duty4"}, -- I want to help that mining craft.
		{"@conversation/naboo_privateer_tier4:s_70d61202", "tier4_duty_brief_destroy"}, -- Please, give me the briefing again.
	}
}
dravis_convo:addScreen(dravis_tier4_duty_repeat);

dravis_tier4_duty_brief_destroy = ConvoScreen:new {
	id = "tier4_duty_brief_destroy",
	leftDialog = "@conversation/naboo_privateer_tier4:s_1cf9a0f6", -- I've saved the best for last. I need a pilot willing to fly sorties against Black Sun pirates. Dangerous, but fun. Especially for a big strong pilot like you.
	stopConversation = "false",
	options = {
		{"@conversation/naboo_privateer_tier4:s_2836e6b5", "tier4_duty_brief_escort"}, -- OK.
	}
}
dravis_convo:addScreen(dravis_tier4_duty_brief_destroy);

dravis_tier4_duty_brief_escort = ConvoScreen:new {
	id = "tier4_duty_brief_escort",
	leftDialog = "@conversation/naboo_privateer_tier4:s_5603b2a1", -- Now listen up and pay attention. I hate repeating myself. I need a pilot to escort a Naboo mining transport through Endor space. I'll warn you, Borvo the Hutt's men will probably be interested in that transport.
	stopConversation = "false",
	options = {
		{"@conversation/naboo_privateer_tier4:s_2836e6b5", "tier4_duty_brief_recovery"}, -- OK.
	}
}
dravis_convo:addScreen(dravis_tier4_duty_brief_escort);

dravis_tier4_duty_brief_recovery = ConvoScreen:new {
	id = "tier4_duty_brief_recovery",
	leftDialog = "@conversation/naboo_privateer_tier4:s_8ca0b65b", -- If you have a thing against the Ay'Nat, you could help me out by capturing one of their private vessels.
	stopConversation = "false",
	options = {
		{"@conversation/naboo_privateer_tier4:s_2836e6b5", "tier4_duty_menu"}, -- OK.
	}
}
dravis_convo:addScreen(dravis_tier4_duty_brief_recovery);

dravis_tier4_duty_menu = ConvoScreen:new {
	id = "tier4_duty_menu",
	leftDialog = "@conversation/naboo_privateer_tier4:s_1993702c", -- If you're feeling like a hero today, you could rescue a Naboo mining craft from Ay'Nat pirates.
	stopConversation = "false",
	options = {
		{"@conversation/naboo_privateer_tier4:s_62c8be58", "accept_tier4_duty1"}, -- I can handle those Black Suns.
		{"@conversation/naboo_privateer_tier4:s_619658af", "accept_tier4_duty2"}, -- I'll escort that mining transport.
		{"@conversation/naboo_privateer_tier4:s_7869de8a", "accept_tier4_duty3"}, -- What's wrong with that Ay'Nat ship?
		{"@conversation/naboo_privateer_tier4:s_413ac49a", "accept_tier4_duty4"}, -- I want to help that mining craft.
		{"@conversation/naboo_privateer_tier4:s_70d61202", "tier4_duty_brief_destroy"}, -- Please, give me the briefing again.
	}
}
dravis_convo:addScreen(dravis_tier4_duty_menu);

dravis_accept_tier4_duty1 = ConvoScreen:new {
	id = "accept_tier4_duty1",
	leftDialog = "@conversation/naboo_privateer_tier4:s_9281abbb", -- Go get 'em, tiger.
	stopConversation = "true",
	options = {}
}
dravis_convo:addScreen(dravis_accept_tier4_duty1);

dravis_accept_tier4_duty2 = ConvoScreen:new {
	id = "accept_tier4_duty2",
	leftDialog = "@conversation/naboo_privateer_tier4:s_90422eb5", -- Good luck.
	stopConversation = "true",
	options = {}
}
dravis_convo:addScreen(dravis_accept_tier4_duty2);

dravis_accept_tier4_duty3 = ConvoScreen:new {
	id = "accept_tier4_duty3",
	leftDialog = "@conversation/naboo_privateer_tier4:s_42d6c3ee", -- Go on. Your ship is waiting.
	stopConversation = "true",
	options = {}
}
dravis_convo:addScreen(dravis_accept_tier4_duty3);

dravis_accept_tier4_duty4 = ConvoScreen:new {
	id = "accept_tier4_duty4",
	leftDialog = "@conversation/naboo_privateer_tier4:s_9750cd6f", -- Lucky miners! Have fun.
	stopConversation = "true",
	options = {}
}
dravis_convo:addScreen(dravis_accept_tier4_duty4);

addConversationTemplate("dravis_convo", dravis_convo);
