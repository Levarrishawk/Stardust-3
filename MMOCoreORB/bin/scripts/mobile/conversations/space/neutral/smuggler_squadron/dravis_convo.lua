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

addConversationTemplate("dravis_convo", dravis_convo);
