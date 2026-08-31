-- scripts/mobile/conversations/mustafar/som_storm_lord_jural.lua
--
-- Strings from string/en/conversation/som_storm_lord_jural.stf (complete
-- shipped table; s_2 empty and do_not_edit already excluded).
--
-- The tree SHAPE is no longer inferred. SOE's own server-side conversation
-- script for this NPC is in hand, and every screen, every option, every
-- animation and every side effect below is transcribed from it node for
-- node. Where this file used to guess -- the return-visit pairings, which
-- screen fires which signal, and whether s_62 had a home -- the guesses have
-- been replaced with what SOE actually wrote. Three of them were wrong; see
-- SIDE EFFECTS below.
--
-- Speaker: Jural is the Corellian Times reporter (s_82). Every leftDialog
-- is hers. The player is the one who volunteers to kill. Dr. Namdaot /
-- the Storm Lord is only talked about.
--
-- GREETING DISPATCH. SOE tests the quest's own task names, top-down, first
-- match wins. somStormLordScreenPlay carries the same ladder as a stage
-- number, so each condition maps to exactly one stage:
--
--   hasCompletedQuest("som_storm_lord")   -> s_62   done         (runs > 0)
--   isTaskActive "storm_lord_eight"       -> s_55   stage 8
--   isTaskActive "storm_lord_seven"       -> s_8    stage 7
--   isTaskActive "storm_lord_six"         -> s_10   stage 6
--   isTaskActive "storm_lord_five"        -> s_18   stage 5
--   isTaskActive "storm_lord_four"        -> s_20   stage 4
--   isTaskActive "storm_lord_three"       -> s_32   stage 3
--   isTaskActive "storm_lord_two"         -> s_34   stage 2
--   isTaskActive "storm_lord_one"         -> s_72   stage 1
--   default                               -> s_74   stage 0, first meeting
--
-- The completed test is FIRST, above every task test. So a player who has
-- finished the ladder gets the s_62 bubble and is never re-offered the
-- quest, even though the [list] sets allowRepeats true. Both facts are
-- true at once: allowRepeats only means the quest system would accept a
-- re-grant, and SOE's giver simply never asks for one. Same shape as the
-- four Mensix givers.
--
-- Kill-stage greetings (s_72, s_32, s_18, s_8) are bubbles with no options.
-- That is SOE's, not a shortcut: there is no player line in the table that
-- is a "still working on it" check-in, and inventing one would be a defect.
-- Hand-in options live only on the wait-stage greetings.
--
-- SIDE EFFECTS. SOE hangs every one of them on the ACCEPT of the NEXT job,
-- not on the report screen that precedes it. This file previously fired
-- them one screen early; that is corrected here and in the handler.
--
--   accept_minions      s_120 -> s_122   grantQuest("som_storm_lord")
--   accept_zealots      s_44  -> s_66    storm_lord_minions_defeated
--   accept_prophet      s_51  -> s_54    storm_lord_zealots_defeated
--   accept_storm_lord   s_58  -> s_60    storm_lord_prophet_defeated
--   payment             s_63  -> s_64    storm_lord_defeated  (pays)
--
-- The consequence is deliberate on SOE's part: the three DECLINE branches
-- (s_52, s_68, s_59) send no signal at all, so a player who says "not right
-- now" stays parked on the finished wait task and can come back and accept
-- later. The report screens themselves (s_38, s_46, s_57) are pure
-- exposition. Only s_63 both reports and pays, because task 8 is the last
-- one and its signal is what fires the Reward.
--
-- ANIMATIONS. animation is the NPC's and playerAnimation is the player's
-- (ConversationScreen.h:203-208). Both are transcribed from SOE's anim
-- lines; a screen with no anim line gets neither field.

som_storm_lord_jural = ConvoTemplate:new {
	initialScreen = "greeting",
	templateType = "Lua",
	luaClassHandler = "storm_lord_jural_conv_handler",
	screens = {}
}

-- =====================================================================
-- Stage 0 -- first meeting. Spine s_74 through s_126.
-- =====================================================================

jural_greeting = ConvoScreen:new {
	id = "greeting",
	leftDialog = "@conversation/som_storm_lord_jural:s_74", -- Please don't tell me that you are on your way to join up with the Dr. Namdaot...well, I suppose he calls himself the Storm Lord now.
	animation = "shake_head_disgust",
	stopConversation = "false",
	options = {
		{"@conversation/som_storm_lord_jural:s_76", "dont_know"}, -- I am afraid I don't know what you are talking about.
	}
}
som_storm_lord_jural:addScreen(jural_greeting)

jural_dont_know = ConvoScreen:new {
	id = "dont_know",
	leftDialog = "@conversation/som_storm_lord_jural:s_78", -- Whew! Finally, someone with some sense. You shouldn't travel any further up this road. That madman and his followers have almost completely taken over the whole valley. The only people they even tolerate are this group of scavengers who pay occasional homage to the Storm Lord.
	animation = "sweat",
	stopConversation = "false",
	options = {
		{"@conversation/som_storm_lord_jural:s_80", "who_is_storm_lord"}, -- Who or what is this Storm Lord you keep mentioning?
	}
}
som_storm_lord_jural:addScreen(jural_dont_know)

jural_who_is_storm_lord = ConvoScreen:new {
	id = "who_is_storm_lord",
	leftDialog = "@conversation/som_storm_lord_jural:s_82", -- I am sorry. I completely forgot my manners. I am Jural, a reporter for the Corellian Times...perhaps you have read my column on galactic exploration? No? Anyways, I was out here reporting on Dr. Namdaot's excavation of the temple ruins up the way.
	animation = "point_to_self",
	stopConversation = "false",
	options = {
		{"@conversation/som_storm_lord_jural:s_84", "temple_ruins"}, -- There are temple ruins up there?
	}
}
som_storm_lord_jural:addScreen(jural_who_is_storm_lord)

jural_temple_ruins = ConvoScreen:new {
	id = "temple_ruins",
	leftDialog = "@conversation/som_storm_lord_jural:s_86", -- Yes, a very large complex of them. Dr. Namdaot was uncovering some amazing finds. It would seem that those ruins were once the main temple on Mustafar. He was on the trail of something big when the change occurred. He said that he had found evidence that a powerful Jedi artifact was once housed in the temple and that it might have something to do with why Mustafar is like it is today.
	animation = "nod",
	stopConversation = "false",
	options = {
		{"@conversation/som_storm_lord_jural:s_88", "the_change"}, -- You said that a change occurred?
	}
}
som_storm_lord_jural:addScreen(jural_temple_ruins)

jural_the_change = ConvoScreen:new {
	id = "the_change",
	leftDialog = "@conversation/som_storm_lord_jural:s_90", -- It was subtle at first, barely noticeable. Sometimes you would get the feeling someone was watching you even though you were all by yourself. Other times you would hear...well, I could swear they were voices, but they were too low to understand. Everyone was feeling it, and Dr. Namdaot, the worst of all...
	animation = "whisper",
	stopConversation = "false",
	options = {
		{"@conversation/som_storm_lord_jural:s_92", "voices"}, -- Go on.
	}
}
som_storm_lord_jural:addScreen(jural_the_change)

-- SOE gives s_94 no anim line.
jural_voices = ConvoScreen:new {
	id = "voices",
	leftDialog = "@conversation/som_storm_lord_jural:s_94", -- Dr. Namdaot started to talk back to the voices. At first, when we would ask him about it, he would just chuckle and say that it was nothing. But after a while, we would catch him having conversations with nothing. When we asked him about those, he would get very angry and tell us to mind our own business. Then one day, he just walked out of base camp and went to the summit temple ruins.
	stopConversation = "false",
	options = {
		{"@conversation/som_storm_lord_jural:s_96", "doctor_snapped"}, -- Sounds like the good doctor just snapped.
	}
}
som_storm_lord_jural:addScreen(jural_voices)

jural_doctor_snapped = ConvoScreen:new {
	id = "doctor_snapped",
	leftDialog = "@conversation/som_storm_lord_jural:s_98", -- Some of us thought that too. But what happened when he came back left no doubt in my mind that those voices and strange feelings were real. The doctor was gone for a few days, and then one morning, just showed back up...but he was different. He declared his divinity to the whole camp and ordered everyone to worship him as the Storm Lord.
	animation = "explain",
	stopConversation = "false",
	options = {
		{"@conversation/som_storm_lord_jural:s_100", "lost_his_mind"}, -- I was right. The doctor lost his mind.
	}
}
som_storm_lord_jural:addScreen(jural_doctor_snapped)

jural_lost_his_mind = ConvoScreen:new {
	id = "lost_his_mind",
	leftDialog = "@conversation/som_storm_lord_jural:s_102", -- Hush. Let me continue. After Dr. Namdaot made this proclamation, the sky darkened, and lightning began pounding the ground around the camp. The members of the team who were feeling the effects of that place the worst immediately dropped to their knees and started praying to him. It took others a little longer to come around, but eventually, everyone was enthralled by him. Everyone but me and my brother, Talper.
	animation = "shush",
	stopConversation = "false",
	options = {
		{"@conversation/som_storm_lord_jural:s_104", "brother_dying"}, -- I was going to ask about him. He doesn't look so good.
	}
}
som_storm_lord_jural:addScreen(jural_lost_his_mind)

jural_brother_dying = ConvoScreen:new {
	id = "brother_dying",
	leftDialog = "@conversation/som_storm_lord_jural:s_106", -- Yes, I fear he is dying. While everyone else was worshipping this Storm Lord, Talper yelled at him...calling him a fraud. Dr. Namdaot looked at my brother with such venom and called him an unbeliever. Then he did something.
	animation = "sigh_deeply",
	stopConversation = "false",
	options = {
		{"@conversation/som_storm_lord_jural:s_108", "what_something"}, -- What do you mean...something?
	}
}
som_storm_lord_jural:addScreen(jural_brother_dying)

jural_what_something = ConvoScreen:new {
	id = "what_something",
	leftDialog = "@conversation/som_storm_lord_jural:s_110", -- I don't really know. One moment, my brother was facing down Dr. Namdaot, and the next, he was lying on the ground, writhing in pain. All the doctor did was wave his hand at him. Since then, Talper has been steadily getting worse. I don't think he will last very much longer and, as far as I can tell, there is nothing wrong with him. I can only assume that it is the doing of this Storm Lord.
	animation = "shrug_hands",
	playerAnimation = "huh",
	stopConversation = "false",
	options = {
		{"@conversation/som_storm_lord_jural:s_112", "anything_i_can_do"}, -- Is there anything that I can do?
	}
}
som_storm_lord_jural:addScreen(jural_what_something)

jural_anything_i_can_do = ConvoScreen:new {
	id = "anything_i_can_do",
	leftDialog = "@conversation/som_storm_lord_jural:s_114", -- Maybe. Just maybe. I have been paying close attention to the goings-on in the camp and think I have an answer. The doctor immediately began sending his worshippers out to gather up more followers and I was wondering why. Well, it would seem that none of them survive very long. Almost all of the group of original followers are dead. I have seen their bodies...they look drained.
	animation = "rub_chin_thoughtful",
	stopConversation = "false",
	options = {
		{"@conversation/som_storm_lord_jural:s_116", "the_plan"}, -- I am not following you.
	}
}
som_storm_lord_jural:addScreen(jural_anything_i_can_do)

jural_the_plan = ConvoScreen:new {
	id = "the_plan",
	leftDialog = "@conversation/som_storm_lord_jural:s_118", -- I think that the doctor is doing something to his followers that drains their life away from them. Perhaps this is the source of his power. If he didn't have so many people following him, maybe he would lose strength, and he would lose power over my brother. I know it is a long shot, but it is the only thing that I can think of.
	animation = "explain",
	stopConversation = "false",
	options = {
		{"@conversation/som_storm_lord_jural:s_120", "accept_minions"}, -- I will see what I can do about taking out his followers.
		{"@conversation/som_storm_lord_jural:s_124", "decline_first"}, -- I wish I could help you, but I just cannot.
	}
}
som_storm_lord_jural:addScreen(jural_the_plan)

-- s_120 carries SOE's startMission = grantQuest(player, "som_storm_lord").
jural_accept_minions = ConvoScreen:new {
	id = "accept_minions",
	leftDialog = "@conversation/som_storm_lord_jural:s_122", -- Thank you. Try taking out some of his minions. I am sure that if he loses enough of them, he will become weaker.
	animation = "nod_head_multiple",
	stopConversation = "true",
	options = {}
}
som_storm_lord_jural:addScreen(jural_accept_minions)

-- The only decline that costs nothing, because nothing has been granted yet.
jural_decline_first = ConvoScreen:new {
	id = "decline_first",
	leftDialog = "@conversation/som_storm_lord_jural:s_126", -- I understand. Thank you for listening to my plight. Safe journey to you.
	animation = "sigh_deeply",
	playerAnimation = "stop",
	stopConversation = "true",
	options = {}
}
som_storm_lord_jural:addScreen(jural_decline_first)

-- =====================================================================
-- Stage 1 -- minion kill still live. Check-in only; no hand-in option.
-- =====================================================================

jural_minions_checkin = ConvoScreen:new {
	id = "minions_checkin",
	leftDialog = "@conversation/som_storm_lord_jural:s_72", -- Talper isn't doing so well. Unless you can defeat those minions of the so-called Storm Lord, he isn't going to make it.
	animation = "weeping",
	stopConversation = "true",
	options = {}
}
som_storm_lord_jural:addScreen(jural_minions_checkin)

-- =====================================================================
-- Stage 2 -- minions done. s_38 names the miss, then offers the zealots.
-- The signal rides the s_44 accept, not this report.
-- =====================================================================

jural_minions_return = ConvoScreen:new {
	id = "minions_return",
	leftDialog = "@conversation/som_storm_lord_jural:s_34", -- You are back! How did your mission go?
	animation = "beckon",
	stopConversation = "false",
	options = {
		{"@conversation/som_storm_lord_jural:s_37", "minions_done"}, -- It has been taken care of. How is your brother?
	}
}
som_storm_lord_jural:addScreen(jural_minions_return)

-- Exposition only. No side effect on this screen.
jural_minions_done = ConvoScreen:new {
	id = "minions_done",
	leftDialog = "@conversation/som_storm_lord_jural:s_38", -- There hasn't been any change in his condition. Maybe the minions just are not powerful enough to have any effect on Dr. Namdaot's strength. I think we are going to have to aim higher.
	animation = "sigh_deeply",
	stopConversation = "false",
	options = {
		{"@conversation/som_storm_lord_jural:s_40", "zealots_offer"}, -- I am listening.
	}
}
som_storm_lord_jural:addScreen(jural_minions_done)

jural_zealots_offer = ConvoScreen:new {
	id = "zealots_offer",
	leftDialog = "@conversation/som_storm_lord_jural:s_42", -- Not all of the Storm Lord's original worshippers died. Some of them took on traits that are very similar to his. I call them zealots. They are fanatic in their worship of the doctor. Maybe their strength adds to his somehow. If they were eliminated, maybe Talper would get better.
	animation = "explain",
	stopConversation = "false",
	options = {
		{"@conversation/som_storm_lord_jural:s_44", "accept_zealots"}, -- I will hunt down these zealots for you.
		{"@conversation/som_storm_lord_jural:s_68", "decline_zealots"}, -- I am afraid I have done all I can for now.
	}
}
som_storm_lord_jural:addScreen(jural_zealots_offer)

-- s_44 carries SOE's sendFirstSignal = storm_lord_minions_defeated.
jural_accept_zealots = ConvoScreen:new {
	id = "accept_zealots",
	leftDialog = "@conversation/som_storm_lord_jural:s_66", -- Be careful. When I said they took on the traits of the Storm Lord, I meant it. I have seen them do some very strange things.
	animation = "implore",
	stopConversation = "true",
	options = {}
}
som_storm_lord_jural:addScreen(jural_accept_zealots)

-- No signal, and SOE gives s_70 no anim line. The player stays on the
-- finished wait task and can come back to s_34 and accept then.
jural_decline_zealots = ConvoScreen:new {
	id = "decline_zealots",
	leftDialog = "@conversation/som_storm_lord_jural:s_70", -- Okay. Thank you for trying.
	stopConversation = "true",
	options = {}
}
som_storm_lord_jural:addScreen(jural_decline_zealots)

-- =====================================================================
-- Stage 3 -- zealot kill still live. Check-in only; no hand-in option.
-- =====================================================================

jural_zealots_checkin = ConvoScreen:new {
	id = "zealots_checkin",
	leftDialog = "@conversation/som_storm_lord_jural:s_32", -- Talper is fading fast. He is strong, but I don't think he can hold out for much longer.
	animation = "weeping",
	stopConversation = "true",
	options = {}
}
som_storm_lord_jural:addScreen(jural_zealots_checkin)

-- =====================================================================
-- Stage 4 -- zealots done. s_46 is the result; then the Prophet. The
-- signal rides the s_51 accept, not this report.
-- =====================================================================

jural_zealots_return = ConvoScreen:new {
	id = "zealots_return",
	leftDialog = "@conversation/som_storm_lord_jural:s_20", -- I could hear the sounds of the battle all the way down here. I was afraid that you wouldn't make it back.
	animation = "kisscheek",
	stopConversation = "false",
	options = {
		{"@conversation/som_storm_lord_jural:s_45", "plan_working"}, -- Don't worry about me. I am no stranger to a fight.
	}
}
som_storm_lord_jural:addScreen(jural_zealots_return)

-- Exposition only. No side effect on this screen.
jural_plan_working = ConvoScreen:new {
	id = "plan_working",
	leftDialog = "@conversation/som_storm_lord_jural:s_46", -- Well, the good news is that Talper looks a little better today. I think our plan is working. The problem is that we are just not doing enough...which got me to thinking: if the zealots help strengthen the Storm Lord, then maybe the more fanatic the worshipper is, the more powerful he becomes.
	animation = "pound_fist_palm",
	playerAnimation = "pose_proudly",
	stopConversation = "false",
	options = {
		{"@conversation/som_storm_lord_jural:s_47", "not_zealots"}, -- You want me to take out some more zealots?
	}
}
som_storm_lord_jural:addScreen(jural_plan_working)

jural_not_zealots = ConvoScreen:new {
	id = "not_zealots",
	leftDialog = "@conversation/som_storm_lord_jural:s_48", -- No. I was thinking of someone who is more fanatical then all of the zealots combined -- the Prophet.
	animation = "shake_head_no",
	stopConversation = "false",
	options = {
		{"@conversation/som_storm_lord_jural:s_49", "the_prophet"}, -- He has a prophet?
	}
}
som_storm_lord_jural:addScreen(jural_not_zealots)

jural_the_prophet = ConvoScreen:new {
	id = "the_prophet",
	leftDialog = "@conversation/som_storm_lord_jural:s_50", -- Yes. Dr. Namdaot no longer directly speaks to his followers. Instead, he only talks to his most devoted follower, who then preaches to all the others. I think if you were to defeat the Prophet, the Storm Lord would be so weak that he couldn't maintain control over Talper's sickness.
	animation = "explain",
	playerAnimation = "rub_chin_thoughtful",
	stopConversation = "false",
	options = {
		{"@conversation/som_storm_lord_jural:s_51", "accept_prophet"}, -- Once more into the brink...
		{"@conversation/som_storm_lord_jural:s_52", "decline_prophet"}, -- I wish I could help you. But I just can't right now.
	}
}
som_storm_lord_jural:addScreen(jural_the_prophet)

-- s_51 carries SOE's sendSecondSignal = storm_lord_zealots_defeated.
jural_accept_prophet = ConvoScreen:new {
	id = "accept_prophet",
	leftDialog = "@conversation/som_storm_lord_jural:s_54", -- Now, I must warn you. The Prophet is nearly as strong as Dr. Namdaot is and he will fight to the death to protect his master. This is no small challenge that I have asked of you. Good luck.
	animation = "slow_down",
	stopConversation = "true",
	options = {}
}
som_storm_lord_jural:addScreen(jural_accept_prophet)

-- No signal. The player stays on the finished wait task.
jural_decline_prophet = ConvoScreen:new {
	id = "decline_prophet",
	leftDialog = "@conversation/som_storm_lord_jural:s_53", -- I knew it was a long shot asking you in the first place. It is okay. Thank you for what you have already done.
	animation = "sigh_deeply",
	stopConversation = "true",
	options = {}
}
som_storm_lord_jural:addScreen(jural_decline_prophet)

-- =====================================================================
-- Stage 5 -- Prophet kill still live. Check-in only; no hand-in option.
-- =====================================================================

jural_prophet_checkin = ConvoScreen:new {
	id = "prophet_checkin",
	leftDialog = "@conversation/som_storm_lord_jural:s_18", -- Talper is feeling better, but I think that just gained some time. He is still very sick.
	animation = "hug_self",
	stopConversation = "true",
	options = {}
}
som_storm_lord_jural:addScreen(jural_prophet_checkin)

-- =====================================================================
-- Stage 6 -- Prophet done. s_10 already knows; s_57 aims at the last one.
-- The signal rides the s_58 accept, not this report.
-- =====================================================================

jural_prophet_return = ConvoScreen:new {
	id = "prophet_return",
	leftDialog = "@conversation/som_storm_lord_jural:s_10", -- I was very worried about you. I know the Prophet is no ordinary thug. The good news is that Talper actually opened his eyes for a little while...that is how I knew you had won.
	animation = "celebrate",
	stopConversation = "false",
	options = {
		{"@conversation/som_storm_lord_jural:s_56", "ask_storm_lord"}, -- Yeah, I beat the Prophet. So is Talper going to be alright?
	}
}
som_storm_lord_jural:addScreen(jural_prophet_return)

-- Exposition only. No side effect on this screen.
jural_ask_storm_lord = ConvoScreen:new {
	id = "ask_storm_lord",
	leftDialog = "@conversation/som_storm_lord_jural:s_57", -- I don't know. He still has a fever and hasn't opened his eyes since that one time. I am afraid that there is only one way to be certain. I must ask you to kill the Storm Lord.
	animation = "shrug_hands",
	stopConversation = "false",
	options = {
		{"@conversation/som_storm_lord_jural:s_58", "accept_storm_lord"}, -- I figured it would come to this. Where is he?
		{"@conversation/som_storm_lord_jural:s_59", "decline_storm_lord"}, -- I am afraid that I have some other business to attend to first.
	}
}
som_storm_lord_jural:addScreen(jural_ask_storm_lord)

-- s_58 carries SOE's sendThirdSignal = storm_lord_prophet_defeated.
jural_accept_storm_lord = ConvoScreen:new {
	id = "accept_storm_lord",
	leftDialog = "@conversation/som_storm_lord_jural:s_60", -- He never leaves the temple at the top of the mountain anymore. I am sure that all your prior efforts have weakened him. Now is the perfect time to strike, before he can regain any strength. Good luck to you.
	animation = "pound_fist_palm",
	playerAnimation = "nod",
	stopConversation = "true",
	options = {}
}
som_storm_lord_jural:addScreen(jural_accept_storm_lord)

-- No signal, and SOE gives s_61 no anim line.
jural_decline_storm_lord = ConvoScreen:new {
	id = "decline_storm_lord",
	leftDialog = "@conversation/som_storm_lord_jural:s_61", -- I understand. I think Talper can hold on for a while longer.
	stopConversation = "true",
	options = {}
}
som_storm_lord_jural:addScreen(jural_decline_storm_lord)

-- =====================================================================
-- Stage 7 -- Storm Lord kill still live. Check-in only; no hand-in option.
-- =====================================================================

jural_storm_lord_checkin = ConvoScreen:new {
	id = "storm_lord_checkin",
	leftDialog = "@conversation/som_storm_lord_jural:s_8", -- Talper is starting to get worse again. The Storm Lord must be defeated or he doesn't have much of a chance.
	animation = "whisper",
	stopConversation = "true",
	options = {}
}
som_storm_lord_jural:addScreen(jural_storm_lord_checkin)

-- =====================================================================
-- Stage 8 -- Storm Lord done. Payment is s_64, and it is the one screen
-- that both reports and pays: task 8 is the last, so its signal fires
-- the Reward.
-- =====================================================================

jural_storm_lord_return = ConvoScreen:new {
	id = "storm_lord_return",
	leftDialog = "@conversation/som_storm_lord_jural:s_55", -- You did it! Talper is already feeling better. He is still extremely weak and it will take him a while to recover, but I can tell he is going to make it. You are very brave to help us out like this.
	animation = "offer_affection",
	stopConversation = "false",
	options = {
		{"@conversation/som_storm_lord_jural:s_63", "payment"}, -- Think nothing of it.
	}
}
som_storm_lord_jural:addScreen(jural_storm_lord_return)

-- s_63 carries SOE's sendFourthSignal = storm_lord_defeated.
jural_payment = ConvoScreen:new {
	id = "payment",
	leftDialog = "@conversation/som_storm_lord_jural:s_64", -- No, it was something. Please, take this as payment for saving the life of my brother. Thank you again.
	animation = "manipulate_medium",
	stopConversation = "true",
	options = {}
}
som_storm_lord_jural:addScreen(jural_payment)

-- =====================================================================
-- Finished -- SOE's top condition, above every task test.
-- =====================================================================

jural_done = ConvoScreen:new {
	id = "done",
	leftDialog = "@conversation/som_storm_lord_jural:s_62", -- Hello again. Talper is doing much better. He is still very weak, but he is going to make it. And we owe it all to you. Thank you so much.
	animation = "greet",
	stopConversation = "true",
	options = {}
}
som_storm_lord_jural:addScreen(jural_done)

addConversationTemplate("som_storm_lord_jural", som_storm_lord_jural)

-- =====================================================================
-- ROWS NOT PLACED
-- =====================================================================
-- None. Every non-empty row of the shipped table now has a screen. s_62
-- used to be listed here as unplaceable on the reasoning that the
-- screenplay resets to stage 0 after payout and nothing distinguished a
-- repeater from a new player. SOE's dispatch settles it: the completed
-- test is the first condition it evaluates, so s_62 is the greeting for
-- anyone who has finished the ladder. somStormLordScreenPlay already
-- keeps a "runs" counter through that reset, and the handler routes on it.
