-- scripts/mobile/conversations/mustafar/som_doctor_lu.lua
--
-- RECONSTRUCTED FROM THE STRING TABLE, THEN CHECKED AGAINST THE LIVE TREE.
--
-- Strings from string/en/conversation/som_doctor_lu.stf (complete shipped
-- table; s_2 empty and do_not_edit already excluded). The reconstruction was
-- done from the .stf alone -- speaker voice, adjacent-number spines and
-- answer-to-question fit -- and every screen and every edge below has since
-- been read back against the server-side tree. The wiring came out right:
-- every option, every destination and every branch matches. Two claims in the
-- old header did not, and both are corrected in place below.
--
-- Three speaker calls a cold read gets wrong. All three were argued from the
-- shipped text alone, and the live tree agrees with all three:
--   s_52 is the PLAYER ("I see. Well perhaps it is time for me to go back to work.")
--   s_54 is Dr. Lu     ("What are you going to do?")
-- Those two were called FORCED by the alternation argument, and they are: live
-- runs s_52 -> s_54 and s_56 -> s_58 exactly that way. s_58 "Hmmmm...well,
-- okay. I will just wait here." is Dr. Lu, because waiting is the thing he does
-- -- he says it again at s_38 and at s_42.
--   s_50 is Dr. Lu     ("Thanks again.")
-- s_50 was the weakest call in this file: only CONSISTENT with the reward
-- exchange, not forced, because "Thanks again" fits either mouth. Live settles
-- it -- s_50 is Dr. Lu's closing line and it is where the quest is paid out.
-- s_10 is Dr. Lu too (nervous hedging); it is the stage-5 greeting, not a
-- player line -- the player answer that fits it is s_44.
--
-- First meeting is one spine, s_66 through s_98, in the order SOE numbered
-- the rows. Each answer unlocks the next question. s_96 / s_98 is the
-- decline sibling on the s_90 offer; s_92 / s_94 is the accept that grants.
--
-- In-progress check-ins (stages 1, 3, 5) were placed by answer-fit only and
-- were called the least certain part of the tree. They are all three correct:
--   stage 1  s_60 "glad you are not dead" / s_62 / s_64
--   stage 3  s_20 "take care of your business" (the phrase from s_52 / s_56) / s_37 / s_38
--   stage 5  s_10 "Is San'sii...dead?" / s_44 / s_45
--
-- Greeting by somBlackguardProblemScreenPlay, in live's condition order
--   quest won      already_helped    s_46   (runs > 0; see CORRECTING s_46)
--   stage 6        singed            s_43
--   stage 5        sansii_checkin    s_10
--   stage 4        waiting_news      s_14   (he said he would wait at s_58)
--   stage 3        business_checkin  s_20
--   stage 2        ruins_return      s_24
--   stage 1        ruins_checkin     s_60
--   default        greeting          s_66
--
-- Side effects fire on the closer of each spine:
--   wish_well       grantQuest
--   wait_here       signalMinionsDefeated
--   wait_for_sansii signalVanskDefeated
--   thanks_again    signalSansiiDefeated   (NOT reward; see CORRECTING THE PAYOUT)
--
-- =====================================================================
-- CORRECTING s_46 -- it was called unplaceable, and live places it first
-- =====================================================================
-- The old header ended with a ROWS NOT PLACED block saying s_46 "has no honest
-- screen", on the reasoning that awardQuest resets the screenplay to stage 0
-- with allowRepeats, so a finished player is indistinguishable from a new one
-- and must be greeted as a first meeting.
--
-- Live greets him with s_46 and nothing else. It is the FIRST condition in the
-- whole start chain, ahead of all six stage checks, and it is a one-liner with
-- no options -- a bark, not a conversation. It is added below as
-- already_helped.
--
-- ROOT CAUSE: taking our own screenplay's state model as the set of questions
-- that can be asked. Stage is what THIS file tracks, so "no stage distinguishes
-- them" got read as "nothing distinguishes them". Runs does -- the screenplay
-- has always written it, awardQuest increments it, and stage 0 with a run
-- behind you is not the same player as stage 0 with none. The row was declared
-- unplaceable because the only tool reached for could not place it.
--
-- Note what live's ordering means: because the completed check runs before the
-- stage checks, a player who has finished once can never be greeted with s_66
-- again, so the .qst's allowRepeats is unreachable through the only giver. That
-- is live's behaviour, not a bug to route around.
--
-- =====================================================================
-- CORRECTING THE PAYOUT -- it fires one screen later than this file said
-- =====================================================================
-- The old header put signalSansiiDefeated on reward (s_48), the screen where
-- Dr. Lu offers a relic as payment. Live fires it on s_50, "Thanks again." --
-- s_48 carries no action at all.
--
-- ROOT CAUSE: hooking the screen that DESCRIBES the payment rather than the
-- screen that ENDS the exchange. s_48 is Dr. Lu saying he is paying; the player
-- still has to accept at s_49, and the server pays when the conversation
-- closes. This is the same mistake, in the same place, as Ikt's turn-in -- see
-- WHERE THE HOOKS SIT in ikt_conv_handler.lua. Screen text announcing a reward
-- is not the reward.
--
-- The other three hooks were right: grantMission on s_94, sendFirstSignal on
-- s_58, sendSecondSignal on s_42.

som_doctor_lu = ConvoTemplate:new {
	initialScreen = "greeting",
	templateType = "Lua",
	luaClassHandler = "doctor_lu_conv_handler",
	screens = {}
}

-- =====================================================================
-- Stage 0 -- first meeting. Linear spine s_66 through s_98.
-- =====================================================================

doctor_lu_greeting = ConvoScreen:new {
	id = "greeting",
	leftDialog = "@conversation/som_doctor_lu:s_66", -- Don't even bother to try to go up there. Those stinking Blackguard will not let anyone near the ruins, except for Colonel Narl's crew, of course. You might as well just turn right around and head the other way.
	stopConversation = "false",
	options = {
		{"@conversation/som_doctor_lu:s_68", "why_blackguard"}, -- Why would these...Blackguard try to stop me?
	}
}
som_doctor_lu:addScreen(doctor_lu_greeting)

doctor_lu_why_blackguard = ConvoScreen:new {
	id = "why_blackguard",
	leftDialog = "@conversation/som_doctor_lu:s_70", -- They want the treasures that are in the ruins for themselves. I tried to explain to them that I only wanted to study those relics, but they didn't believe me. I was lucky to get out of there in one piece. At least Colonel Narl agreed to let me study anything they pull out of the ruins, before they sell them off.
	stopConversation = "false",
	options = {
		{"@conversation/som_doctor_lu:s_72", "archaeologist"}, -- What are you? Some sort of archaeologist?
	}
}
som_doctor_lu:addScreen(doctor_lu_why_blackguard)

doctor_lu_archaeologist = ConvoScreen:new {
	id = "archaeologist",
	leftDialog = "@conversation/som_doctor_lu:s_74", -- That is exactly what I am. I am Doctor Mi Fon Lu of the Theed Academy. I came here when I heard of the amazing discoveries coming from these perfectly preserved ruins. It is amazing to think that where we now stand was once a thriving temple during the period of the Old Republic. That was thousands of years ago, of course.
	stopConversation = "false",
	options = {
		{"@conversation/som_doctor_lu:s_76", "who_is_narl"}, -- So, who is this Colonel Narl?
	}
}
som_doctor_lu:addScreen(doctor_lu_archaeologist)

doctor_lu_who_is_narl = ConvoScreen:new {
	id = "who_is_narl",
	leftDialog = "@conversation/som_doctor_lu:s_78", -- He is a treasure hunter, like so many others all over this planet. I don't think he is a real Colonel though...I think he just likes the sound of it. He is nice enough to me, but he probably wouldn't take kindly to anyone else. He seems to be the only one that the Blackguard cannot push around.
	stopConversation = "false",
	options = {
		{"@conversation/som_doctor_lu:s_80", "why_narl"}, -- Why is that?
	}
}
som_doctor_lu:addScreen(doctor_lu_who_is_narl)

doctor_lu_why_narl = ConvoScreen:new {
	id = "why_narl",
	leftDialog = "@conversation/som_doctor_lu:s_82", -- Colonel Narl has a pretty big crew. The Blackguard use some pretty strange powers, but the Colonel outnumbers them. They seem to have developed a truce of sorts. The two sides have divided the ruins between them and leave each other alone. Of course, whenever anyone new shows up, they both turn on the newcomer.
	stopConversation = "false",
	options = {
		{"@conversation/som_doctor_lu:s_84", "blackguard_study"}, -- I am guessing that the Blackguard have something you wish to study.
	}
}
som_doctor_lu:addScreen(doctor_lu_why_narl)

doctor_lu_blackguard_study = ConvoScreen:new {
	id = "blackguard_study",
	leftDialog = "@conversation/som_doctor_lu:s_86", -- Only the heart of the whole ruins. The primary temple is located on their side, and they won't let me anywhere near it. Their leader, San'sii, is there most of the time studying it. I told him that I could help him, but he just laughed and then I couldn't breath. He really freaks me out.
	stopConversation = "false",
	options = {
		{"@conversation/som_doctor_lu:s_88", "perhaps_help"}, -- Well, perhaps I can help you.
	}
}
som_doctor_lu:addScreen(doctor_lu_blackguard_study)

doctor_lu_perhaps_help = ConvoScreen:new {
	id = "perhaps_help",
	leftDialog = "@conversation/som_doctor_lu:s_90", -- I don't know exactly what you can do for me. If you go up there, the Blackguard will definitely attack you, and I am pretty sure the Colonel will too. Like I said before, you should just turn around and head the other way.
	stopConversation = "false",
	options = {
		{"@conversation/som_doctor_lu:s_92", "wish_well"}, -- Don't worry about me. I can handle myself.
		{"@conversation/som_doctor_lu:s_96", "decline"}, -- That is a sound plan. I think I will do that.
	}
}
som_doctor_lu:addScreen(doctor_lu_perhaps_help)

doctor_lu_wish_well = ConvoScreen:new {
	id = "wish_well",
	leftDialog = "@conversation/som_doctor_lu:s_94", -- In that case, I wish you well. If you make it out of there alive, perhaps you will stop by and tell me about what you saw?
	stopConversation = "true",
	options = {}
}
som_doctor_lu:addScreen(doctor_lu_wish_well)

doctor_lu_decline = ConvoScreen:new {
	id = "decline",
	leftDialog = "@conversation/som_doctor_lu:s_98", -- That is the best course of action.
	stopConversation = "true",
	options = {}
}
som_doctor_lu:addScreen(doctor_lu_decline)

-- =====================================================================
-- Stage 1 -- minion kill still live. Check-in only; no hand-in option.
-- =====================================================================

doctor_lu_ruins_checkin = ConvoScreen:new {
	id = "ruins_checkin",
	leftDialog = "@conversation/som_doctor_lu:s_60", -- Hiya. I am glad to see that you are not dead. So, did you see anything in the ruins that I would be interested in?
	stopConversation = "false",
	options = {
		{"@conversation/som_doctor_lu:s_62", "take_care"}, -- Nope, but I am planning on going back.
	}
}
som_doctor_lu:addScreen(doctor_lu_ruins_checkin)

doctor_lu_take_care = ConvoScreen:new {
	id = "take_care",
	leftDialog = "@conversation/som_doctor_lu:s_64", -- Okay, well, take care, my friend.
	stopConversation = "true",
	options = {}
}
som_doctor_lu:addScreen(doctor_lu_take_care)

-- =====================================================================
-- Stage 2 -- waiting on signalMinionsDefeated.
-- =====================================================================

doctor_lu_ruins_return = ConvoScreen:new {
	id = "ruins_return",
	leftDialog = "@conversation/som_doctor_lu:s_24", -- Good to see you again, my friend. How was your trip into the ruins? Did you see anything that I might be interested in?
	stopConversation = "false",
	options = {
		{"@conversation/som_doctor_lu:s_27", "what_do_you_mean"}, -- I wasn't there looking around. I took care of some business.
	}
}
som_doctor_lu:addScreen(doctor_lu_ruins_return)

doctor_lu_what_do_you_mean = ConvoScreen:new {
	id = "what_do_you_mean",
	leftDialog = "@conversation/som_doctor_lu:s_28", -- What do you mean?
	stopConversation = "false",
	options = {
		{"@conversation/som_doctor_lu:s_30", "efforts_wasted"}, -- I eliminated some of those Blackguard for you.
	}
}
som_doctor_lu:addScreen(doctor_lu_what_do_you_mean)

doctor_lu_efforts_wasted = ConvoScreen:new {
	id = "efforts_wasted",
	leftDialog = "@conversation/som_doctor_lu:s_32", -- What! I must say that is most impressive. But I fear that your efforts are wasted. The real problem with the Blackguard is their leaders. Even if you took out all the Blackguard minions, they would never let me near the ruins.
	stopConversation = "false",
	options = {
		{"@conversation/som_doctor_lu:s_34", "vansk_and_sansii"}, -- This San'sii character?
	}
}
som_doctor_lu:addScreen(doctor_lu_efforts_wasted)

doctor_lu_vansk_and_sansii = ConvoScreen:new {
	id = "vansk_and_sansii",
	leftDialog = "@conversation/som_doctor_lu:s_36", -- Him and his woman...Vansk. She is a real mean one. This is just a guess, but I don't think she was hugged enough as a child. Those two alone could easily keep me from going anywhere near those ruins.
	stopConversation = "false",
	options = {
		{"@conversation/som_doctor_lu:s_52", "what_will_you_do"}, -- I see. Well perhaps it is time for me to go back to work.
	}
}
som_doctor_lu:addScreen(doctor_lu_vansk_and_sansii)

doctor_lu_what_will_you_do = ConvoScreen:new {
	id = "what_will_you_do",
	leftDialog = "@conversation/som_doctor_lu:s_54", -- What are you going to do?
	stopConversation = "false",
	options = {
		{"@conversation/som_doctor_lu:s_56", "wait_here"}, -- You are better off not knowing.
	}
}
som_doctor_lu:addScreen(doctor_lu_what_will_you_do)

doctor_lu_wait_here = ConvoScreen:new {
	id = "wait_here",
	leftDialog = "@conversation/som_doctor_lu:s_58", -- Hmmmm...well, okay. I will just wait here.
	stopConversation = "true",
	options = {}
}
som_doctor_lu:addScreen(doctor_lu_wait_here)

-- =====================================================================
-- Stage 3 -- Vansk kill still live. Check-in only; no hand-in option.
-- =====================================================================

doctor_lu_business_checkin = ConvoScreen:new {
	id = "business_checkin",
	leftDialog = "@conversation/som_doctor_lu:s_20", -- So did you...did you take care of your business?
	stopConversation = "false",
	options = {
		{"@conversation/som_doctor_lu:s_37", "still_waiting"}, -- Not yet. But you shouldn't worry about it.
	}
}
som_doctor_lu:addScreen(doctor_lu_business_checkin)

doctor_lu_still_waiting = ConvoScreen:new {
	id = "still_waiting",
	leftDialog = "@conversation/som_doctor_lu:s_38", -- Right. I will just stay here and wait for you to come back.
	stopConversation = "true",
	options = {}
}
som_doctor_lu:addScreen(doctor_lu_still_waiting)

-- =====================================================================
-- Stage 4 -- waiting on signalVanskDefeated.
-- =====================================================================

doctor_lu_waiting_news = ConvoScreen:new {
	id = "waiting_news",
	leftDialog = "@conversation/som_doctor_lu:s_14", -- I waited right here just like I said I would. So, what news?
	stopConversation = "false",
	options = {
		{"@conversation/som_doctor_lu:s_39", "ask_sansii"}, -- Vansk will no longer be of any hassle to you.
	}
}
som_doctor_lu:addScreen(doctor_lu_waiting_news)

doctor_lu_ask_sansii = ConvoScreen:new {
	id = "ask_sansii",
	leftDialog = "@conversation/som_doctor_lu:s_40", -- You took out Vansk? I was impressed before but now I am in serious awe. I...I don't mean to ask this...I have never actually asked for this sort of help before. Could you maybe take care of San'sii too? He scares me a lot, and now that Vansk is gone, he might decide to take out his rage on someone weaker...like me.
	stopConversation = "false",
	options = {
		{"@conversation/som_doctor_lu:s_41", "wait_for_sansii"}, -- I was thinking the same thing.
	}
}
som_doctor_lu:addScreen(doctor_lu_ask_sansii)

doctor_lu_wait_for_sansii = ConvoScreen:new {
	id = "wait_for_sansii",
	leftDialog = "@conversation/som_doctor_lu:s_42", -- I cannot thank you enough. While you go do that, I am going to just wait here and hope for the best.
	stopConversation = "true",
	options = {}
}
som_doctor_lu:addScreen(doctor_lu_wait_for_sansii)

-- =====================================================================
-- Stage 5 -- San'sii kill still live. Check-in only; no hand-in option.
-- =====================================================================

doctor_lu_sansii_checkin = ConvoScreen:new {
	id = "sansii_checkin",
	leftDialog = "@conversation/som_doctor_lu:s_10", -- Is San'sii...you know...dead?
	stopConversation = "false",
	options = {
		{"@conversation/som_doctor_lu:s_44", "ruins_wonders"}, -- Nope, he is a cagey one. I will get him though.
	}
}
som_doctor_lu:addScreen(doctor_lu_sansii_checkin)

doctor_lu_ruins_wonders = ConvoScreen:new {
	id = "ruins_wonders",
	leftDialog = "@conversation/som_doctor_lu:s_45", -- I cannot wait to get a look at those ruins. The wonders that I will be able to uncover will be...great.
	stopConversation = "true",
	options = {}
}
som_doctor_lu:addScreen(doctor_lu_ruins_wonders)

-- =====================================================================
-- Stage 6 -- waiting on signalSansiiDefeated. Reward fires on this signal.
-- =====================================================================

doctor_lu_singed = ConvoScreen:new {
	id = "singed",
	leftDialog = "@conversation/som_doctor_lu:s_43", -- You appear to be a little singed. I take it by your appearance that you dealt with San'sii.
	stopConversation = "false",
	options = {
		{"@conversation/som_doctor_lu:s_47", "reward"}, -- You better believe it.
	}
}
som_doctor_lu:addScreen(doctor_lu_singed)

doctor_lu_reward = ConvoScreen:new {
	id = "reward",
	leftDialog = "@conversation/som_doctor_lu:s_48", -- Thank you, thank you, thank you. You have made this archaeologist very happy. I don't have much, but I do have some relics that I pulled out of the ruins before I was driven away by those Blackguard. I insist you take one as payment.
	stopConversation = "false",
	options = {
		{"@conversation/som_doctor_lu:s_49", "thanks_again"}, -- You don't have to twist my arm. Thank you.
	}
}
som_doctor_lu:addScreen(doctor_lu_reward)

doctor_lu_thanks_again = ConvoScreen:new {
	id = "thanks_again",
	leftDialog = "@conversation/som_doctor_lu:s_50", -- Thanks again.
	stopConversation = "true",
	options = {}
}
som_doctor_lu:addScreen(doctor_lu_thanks_again)

-- =====================================================================
-- Quest already won -- live's first condition. See CORRECTING s_46.
-- =====================================================================
-- DEVIATION: live delivers this one as chat.chat, a spatial speech bubble with
-- no conversation window at all. Core3 has no equivalent inside a conversation
-- template, so it is a one-line terminal screen -- the same stand-in every
-- other bark in this set uses.

doctor_lu_already_helped = ConvoScreen:new {
	id = "already_helped",
	leftDialog = "@conversation/som_doctor_lu:s_46", -- Hey, thanks for all your help. Those ruins are really fascinating. The evidence clearly suggests that this moon wasn't always a burning ball of fire, but a lush green planet. Something cataclysmic must have happened to leave it in this state. I am sure the truth is out there to be found. Good travels to you, my friend.
	stopConversation = "true",
	options = {}
}
som_doctor_lu:addScreen(doctor_lu_already_helped)

-- Every row in the shipped table is now placed. s_2 is empty and do_not_edit is
-- the editor's own banner; neither is dialogue.

addConversationTemplate("som_doctor_lu", som_doctor_lu)
