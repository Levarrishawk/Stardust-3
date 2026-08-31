-- scripts/mobile/conversations/mustafar/miner_madness_chief_drono.lua
--
-- Chief Armstrong -- giver and turn-in for som_poison_miners, "Miner
-- Madness".  Runs on somPoisonMinersScreenPlay.
--
-- THIS TREE IS NOT INFERRED.  It is SOE's own conversation script,
-- conversation/miner_madness_chief_drono.java, read node for node.  The
-- file keeps SOE's name even though the NPC's shipped display name is
-- "Chief Armstrong" (som_poison_miners.stf task06); "drono" is only the
-- script's internal name.  Strings are the shipped rows of
-- string/en/conversation/miner_madness_chief_drono.stf.
--
-- SOE's greeting dispatch is four conditions, first match wins:
--
--   hasCompletedQuest("som_poison_miners")                     s_4   done
--   isTaskActive(...,"mustafar_poison_miners_five")            s_6   report
--   isQuestActive("som_poison_miners")                         s_10  checkin
--   default                                                    s_16  greeting
--
-- mustafar_poison_miners_five is the .qst's turn-in wait, which is
-- somPoisonMinersScreenPlay's STAGE_REPORT.  The handler maps it that way.
--
-- Four side effects, all in the handler, all exactly where SOE put them:
--   s_25 -> s_26   sendSignal(player, "mustafar_poison_miners_reward")
--   s_54 -> s_55   clearQuest then grantQuest("som_poison_miners")
--   s_48 -> s_50   grantQuest("som_poison_miners")
--   s_44 -> s_46   grantQuest("som_poison_miners")
--
-- s_48 and s_44 are two different ways to say yes and SOE gave them the
-- same reply text and the same grant.  s_40 (the refusal) grants nothing.
--
-- Animations are SOE's too.  animation is the NPC's and playerAnimation is
-- the player's (ConversationScreen.h:203-208).  A screen with no anim line
-- in SOE's script gets neither field -- s_50, the blunt accept, is the one
-- screen here that has none.

miner_madness_chief_drono = ConvoTemplate:new {
	initialScreen = "greeting",
	templateType = "Lua",
	luaClassHandler = "miner_madness_chief_drono_conv_handler",
	screens = {}
}

-- =====================================================================
-- First meeting.  s_16 -> s_18 -> s_20 -> s_28 -> s_30 -> s_32 -> s_34,
-- then the branch: s_48 accepts outright, s_36 pushes back first.
-- =====================================================================

miner_madness_chief_drono_greeting = ConvoScreen:new {
	id = "greeting",
	animation = "slump_head",
	leftDialog = "@conversation/miner_madness_chief_drono:s_16", -- Not again. We lost another crew to trilom poisoning. It's not like we haven't enough to worry about, but now we have our friends to deal with. What do you want?
	stopConversation = "false",
	options = {
		{"@conversation/miner_madness_chief_drono:s_18", "whats_going_on"}, -- What's going on?
	}
}
miner_madness_chief_drono:addScreen(miner_madness_chief_drono_greeting)

miner_madness_chief_drono_whats_going_on = ConvoScreen:new {
	id = "whats_going_on",
	animation = "sigh_deeply",
	playerAnimation = "huh",
	leftDialog = "@conversation/miner_madness_chief_drono:s_20", -- One of our field crews hit a patch of trilom gas while they were sampling. They didn't have the proper gear and now...never mind.
	stopConversation = "false",
	options = {
		{"@conversation/miner_madness_chief_drono:s_28", "what_is_trilom"}, -- No, please go on. What is trilom poisoning?
	}
}
miner_madness_chief_drono:addScreen(miner_madness_chief_drono_whats_going_on)

miner_madness_chief_drono_what_is_trilom = ConvoScreen:new {
	id = "what_is_trilom",
	animation = "sigh_deeply",
	leftDialog = "@conversation/miner_madness_chief_drono:s_30", -- Never heard of trilom, huh? Trilom is a gas that builds in pockets below the surface. With the proper gear, it isn't any problem, but without the gear, it is deadly. First it causes massive aggression, delusions, and paranoia in anyone who breathes it. After that...well, after that, a slow painful death.
	stopConversation = "false",
	options = {
		{"@conversation/miner_madness_chief_drono:s_32", "sorry_to_hear"}, -- I am sorry to hear that a crew of yours was affected.
	}
}
miner_madness_chief_drono:addScreen(miner_madness_chief_drono_what_is_trilom)

miner_madness_chief_drono_sorry_to_hear = ConvoScreen:new {
	id = "sorry_to_hear",
	animation = "whisper",
	leftDialog = "@conversation/miner_madness_chief_drono:s_34", -- Thanks for that. Hey, listen...maybe you can help. This is going to sound terrible, but could you help us put those guys down? You know, put them out of their misery.
	stopConversation = "false",
	options = {
		{"@conversation/miner_madness_chief_drono:s_36", "not_a_killer"}, -- What? I am not a cold-blooded killer.
		{"@conversation/miner_madness_chief_drono:s_48", "accept_blunt"}, -- Sure, why not.
	}
}
miner_madness_chief_drono:addScreen(miner_madness_chief_drono_sorry_to_hear)

miner_madness_chief_drono_not_a_killer = ConvoScreen:new {
	id = "not_a_killer",
	animation = "slow_down",
	playerAnimation = "wtf",
	leftDialog = "@conversation/miner_madness_chief_drono:s_38", -- It's not like that. You see, all of us know the dangers of trilom and none of us want to live like that. Once the trilom poisoning takes effect, everything we once were is dead anyways. Normally, we do it for each other but me and the boys have already had to deal with two other crews recently. We just can't take another.
	stopConversation = "false",
	options = {
		{"@conversation/miner_madness_chief_drono:s_40", "decline"}, -- Sorry, but I cannot help you do this.
		{"@conversation/miner_madness_chief_drono:s_44", "accept"}, -- I understand. I will do this for you.
	}
}
miner_madness_chief_drono:addScreen(miner_madness_chief_drono_not_a_killer)

-- ACTION startMission: groundquests.grantQuest(player, "som_poison_miners")
miner_madness_chief_drono_accept_blunt = ConvoScreen:new {
	id = "accept_blunt",
	leftDialog = "@conversation/miner_madness_chief_drono:s_50", -- All the miners have a homing beacon installed in their uniforms in case they ever get lost or trapped. You need to travel to their base camp and activate the tracking system there. Under the effects of trilom, a person can travel a long ways off, fighting everything they see until they finally die. Use the tracking system to find the crew and...and please make it quick.
	stopConversation = "true",
	options = {}
}
miner_madness_chief_drono:addScreen(miner_madness_chief_drono_accept_blunt)

-- ACTION startMission: groundquests.grantQuest(player, "som_poison_miners")
miner_madness_chief_drono_accept = ConvoScreen:new {
	id = "accept",
	animation = "explain",
	leftDialog = "@conversation/miner_madness_chief_drono:s_46", -- All the miners have a homing beacon installed in their uniforms in case they ever get lost or trapped. You need to travel to their base camp and activate the tracking system there. Under the effects of trilom, a person can travel a long ways off, fighting everything they see until they finally die. Use the tracking system to find the crew and...and please make it quick.
	stopConversation = "true",
	options = {}
}
miner_madness_chief_drono:addScreen(miner_madness_chief_drono_accept)

miner_madness_chief_drono_decline = ConvoScreen:new {
	id = "decline",
	animation = "nod",
	leftDialog = "@conversation/miner_madness_chief_drono:s_42", -- Yeah, I don't blame you. Sorry for trying to shove our problems off on you.
	stopConversation = "true",
	options = {}
}
miner_madness_chief_drono:addScreen(miner_madness_chief_drono_decline)

-- =====================================================================
-- Quest active, crew not yet found.  s_10 -> s_22 -> s_52 -> s_54 -> s_55.
-- The retry path: SOE clears and re-grants the quest so the tracking
-- computer can be used again from the top.
-- =====================================================================

miner_madness_chief_drono_checkin = ConvoScreen:new {
	id = "checkin",
	animation = "slump_head",
	leftDialog = "@conversation/miner_madness_chief_drono:s_10", -- I don't really want to talk about anything until our boys are taken care of.
	stopConversation = "false",
	options = {
		{"@conversation/miner_madness_chief_drono:s_22", "having_problems"}, -- I am having some problems tracking them down.
	}
}
miner_madness_chief_drono:addScreen(miner_madness_chief_drono_checkin)

miner_madness_chief_drono_having_problems = ConvoScreen:new {
	id = "having_problems",
	animation = "implore",
	leftDialog = "@conversation/miner_madness_chief_drono:s_52", -- Are you willing to give it another try? Please, it is really important that our friends are...you know.
	stopConversation = "false",
	options = {
		{"@conversation/miner_madness_chief_drono:s_54", "retry"}, -- Okay, I will try to find them again.
	}
}
miner_madness_chief_drono:addScreen(miner_madness_chief_drono_having_problems)

-- ACTION regrantMission: clearQuest then grantQuest, both "som_poison_miners"
miner_madness_chief_drono_retry = ConvoScreen:new {
	id = "retry",
	animation = "explain",
	playerAnimation = "nod",
	leftDialog = "@conversation/miner_madness_chief_drono:s_55", -- Just head back to the camp and use the tracking computer again. It should point you in the right direction. Good luck.
	stopConversation = "true",
	options = {}
}
miner_madness_chief_drono:addScreen(miner_madness_chief_drono_retry)

-- =====================================================================
-- Turn-in.  s_6 -> s_25 -> s_26.  s_26 is where the reward is handed over
-- and where mustafar_poison_miners_reward fires.
-- =====================================================================

miner_madness_chief_drono_report = ConvoScreen:new {
	id = "report",
	animation = "nervous",
	leftDialog = "@conversation/miner_madness_chief_drono:s_6", -- So is the deed done?
	stopConversation = "false",
	options = {
		{"@conversation/miner_madness_chief_drono:s_25", "hand_in"}, -- Yeah. I took care of those sick miners.
	}
}
miner_madness_chief_drono:addScreen(miner_madness_chief_drono_report)

-- ACTION grantReward: sendSignal(player, "mustafar_poison_miners_reward")
miner_madness_chief_drono_hand_in = ConvoScreen:new {
	id = "hand_in",
	animation = "sigh_deeply",
	playerAnimation = "nod",
	leftDialog = "@conversation/miner_madness_chief_drono:s_26", -- It had to be done. Trilom is not a nice thing. I have heard that you are lucid during the most painful parts of the death. Anyways, me and the boys want you to have this for taking care of our friends. Now if you will excuse us, we need to bury our friends.
	stopConversation = "true",
	options = {}
}
miner_madness_chief_drono:addScreen(miner_madness_chief_drono_hand_in)

-- =====================================================================
-- After the quest.  s_4, a bubble with no options.
-- =====================================================================

miner_madness_chief_drono_done = ConvoScreen:new {
	id = "done",
	animation = "nod",
	leftDialog = "@conversation/miner_madness_chief_drono:s_4", -- Thanks for all your help with our sick friends. We really do appreciate you stepping up like that.
	stopConversation = "true",
	options = {}
}
miner_madness_chief_drono:addScreen(miner_madness_chief_drono_done)

addConversationTemplate("miner_madness_chief_drono", miner_madness_chief_drono)
