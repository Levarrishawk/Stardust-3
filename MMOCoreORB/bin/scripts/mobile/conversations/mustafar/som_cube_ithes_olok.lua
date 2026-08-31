-- scripts/mobile/conversations/mustafar/som_cube_ithes_olok.lua
--
-- Strings from string/en/conversation/som_cube_ithes_olok.stf (complete
-- shipped table; s_2 empty already excluded).
--
-- RECONSTRUCTED, THEN CHECKED AGAINST THE LIVE TREE. Every NPC line was
-- already in the right place. Thirteen player options were not, and two
-- strings this file declared unplaceable turned out to be placed. All of
-- it is corrected below.
--
-- Speaker: Ithes Olok is the elderly scholar (s_110 "no spry hatchling").
-- Every leftDialog is his. The player asks and accepts / declines.
--
-- THREE GREETINGS, in the order live tests them, first match wins:
--   completedQuest -> s_140   (stage 4)
--   isOnQuest      -> s_118   (stages 1-3)
--   default        -> s_38    (the courier mistake)
--
-- CORRECTING s_192 AND s_130 -- both DID ship, and neither is a greeting
--
-- This file used to end with a ROWS NOT PLACED section holding s_192 and
-- s_130. Live places both:
--
--   s_190 "Oh... OK, I guess."  ->  s_192 "Well? Why are you just standing
--   there? Is there anything else? I paid in advance, you know."
--
-- s_190 is the OTHER answer to the courier greeting: the player says
-- nothing and lets him keep believing it, so he talks to them as the
-- courier he already paid. s_199 "What is it you're doing here?" and
-- s_206 "I'll be on my way." hang off s_192, not off s_38.
--
--   s_128 "Thanks. I'll figure out the rest myself."  ->  s_130
--
-- s_130 is the reply to s_128 on the cube-opening screen. This file had
-- s_128 landing on s_129 instead, and s_129 is the reply to s_113 on the
-- excavation screen. One string was assumed spare and the other was
-- borrowed to cover for it.
--
-- ROOT CAUSE for both: reading a string's absence from the reconstruction
-- as evidence that SOE never used it, and then arguing the absence in the
-- file. s_192 was called a greeting with no state to trigger it -- it was
-- never a greeting. A string with nowhere to go is a hole in the
-- reconstruction, not a row SOE left out.
--
-- CORRECTING ELEVEN MISPLACED EXITS
--
-- Ithes Olok's pitch is a ladder and every rung carries a way out. SOE cut
-- a fresh exit string per rung; this table holds eight "Sorry, I've got to
-- go." (s_135, s_149, s_154, s_158, s_162, s_170, s_174, s_182), two "Well,
-- good luck with all that" (s_101, s_103) and two "I'll be on my way."
-- (s_186, s_206). Reading them as interchangeable let them drift. Live, by
-- branch:
--
--   greeting        s_38   ->  s_40, s_190          was  s_40, s_199
--   paid_courier    s_192  ->  s_199, s_206         NEW screen
--   what_doing_skip s_203  ->  s_48, s_178, s_182   was  s_48, s_178, s_206
--   famous_olok     s_50   ->  s_52, s_174          was  s_52, s_190
--   chu_gon_bio     s_58   ->  s_61, s_162          was  s_61, s_154
--   chu_gon_bio_no  s_168  ->  s_61, s_162          was  s_61, s_174
--   device_does     s_69   ->  s_70, s_154          was  s_70, s_162
--   merge_items     s_75   ->  s_77, s_149          was  s_77, s_113
--   temple_lost     s_83   ->  s_84, s_135          was  s_84
--   cubes_found     s_90   ->  s_91, s_113          was  s_91
--   cubes_stuck     s_94   ->  s_95, s_101          was  s_95, s_103
--   scrolls         s_99   ->  s_100, s_103         was  s_100, s_101
--
-- ROOT CAUSE: pairing an exit with the NPC line it reads best against
-- instead of with the screen that offers it -- the same failure recorded in
-- som_pei_yi.lua and som_diskret_stahn.lua. Here it compounded, because
-- byte-identical exits made every rung look like it could take any of them.
-- Two rungs (s_83, s_90) ended up with no exit at all, and the exits they
-- should have carried were spent higher up the ladder.
--
-- CORRECTING THE TUTORIAL -- one ladder, entered from three places
--
-- The how-to is not a separate stage-4 shortcut. Live's branch 10 is
-- reached from s_126 (the hand-in), from s_144 (stage 4, "Yes, please")
-- and from s_200 (stage 4 after a lost cube), and all three then run the
-- same rungs:
--
--   s_126 / s_144 / s_200  ->  s_127, s_128
--   s_131                  ->  s_132, s_134
--   s_137                  ->  s_145
--   s_146                  ->  s_148
--
-- This file gave s_144 and s_200 their own two-screen path (s_145 straight
-- to s_146), ended s_137 as a terminal, and hung s_135 on s_131 and s_149
-- on s_146. s_135 belongs on s_83 and s_149 on s_75; s_137 is a rung, not
-- an ending.
--
-- ROOT CAUSE: treating "same sentence twice" as "two separate paths". s_144
-- and s_200 repeat s_126's instruction because the player re-entered the
-- tutorial, not because SOE wrote a shorter version of it.
--
-- Side effects, and where live puts them:
--   accept_notes  s_117  grantCubeQuest      grantQuest
--   notes_handin  s_122  sendCompleteSignal  signalReturnNotes
--   lost_cube     s_194  giveAnotherCube     replaceCube

som_cube_ithes_olok = ConvoTemplate:new {
	initialScreen = "greeting",
	templateType = "Lua",
	luaClassHandler = "cube_ithes_olok_conv_handler",
	screens = {}
}

-- =====================================================================
-- Stage 0 -- first meeting. Courier mistake, then the research pitch.
-- =====================================================================

olok_greeting = ConvoScreen:new {
	id = "greeting",
	leftDialog = "@conversation/som_cube_ithes_olok:s_38", -- What? Oh, you must be the new courier. Just put the papers over there. I'll look at them later.
	stopConversation = "false",
	options = {
		{"@conversation/som_cube_ithes_olok:s_40", "not_courier"}, -- Sorry, I'm not a courier.
		{"@conversation/som_cube_ithes_olok:s_190", "paid_courier"}, -- Oh... OK, I guess.
	}
}
som_cube_ithes_olok:addScreen(olok_greeting)

-- Letting the courier mistake stand. He carries on treating the player as the
-- courier he has already paid, and the same two questions hang off it.
olok_paid_courier = ConvoScreen:new {
	id = "paid_courier",
	leftDialog = "@conversation/som_cube_ithes_olok:s_192", -- Well? Why are you just standing there? Is there anything else? I paid in advance, you know.
	stopConversation = "false",
	options = {
		{"@conversation/som_cube_ithes_olok:s_199", "what_doing_skip"}, -- What is it you're doing here?
		{"@conversation/som_cube_ithes_olok:s_206", "bye_good_skip"}, -- I'll be on my way.
	}
}
som_cube_ithes_olok:addScreen(olok_paid_courier)

olok_not_courier = ConvoScreen:new {
	id = "not_courier",
	leftDialog = "@conversation/som_cube_ithes_olok:s_42", -- I see. Well, never mind about the papers then. What can I do for you? Make it quick though. I'm quite busy.
	stopConversation = "false",
	options = {
		{"@conversation/som_cube_ithes_olok:s_44", "what_doing"}, -- What is it you're doing here?
		{"@conversation/som_cube_ithes_olok:s_186", "bye_good"}, -- I'll be on my way.
	}
}
som_cube_ithes_olok:addScreen(olok_not_courier)

olok_bye_good = ConvoScreen:new {
	id = "bye_good",
	leftDialog = "@conversation/som_cube_ithes_olok:s_188", -- Good.
	stopConversation = "true",
	options = {}
}
som_cube_ithes_olok:addScreen(olok_bye_good)

-- s_46 branch: arrived via s_40 / s_44 (courier cleared first).
olok_what_doing = ConvoScreen:new {
	id = "what_doing",
	leftDialog = "@conversation/som_cube_ithes_olok:s_46", -- Ah. You are interested in the research of the famous Dr. Olok, are you? I knew you had a keen mind as soon as you walked in. Of course, I would be happy to explain it all to you in full detail. If you have a couple of hours we could...
	stopConversation = "false",
	options = {
		{"@conversation/som_cube_ithes_olok:s_48", "famous_olok"}, -- Famous Doctor Olok?
		{"@conversation/som_cube_ithes_olok:s_178", "overview"}, -- Just a quick overview is fine.
		{"@conversation/som_cube_ithes_olok:s_182", "bye_tomorrow"}, -- Sorry, I've got to go.
	}
}
som_cube_ithes_olok:addScreen(olok_what_doing)

-- s_203 branch: arrived via s_199, off the paid-courier screen. One comma more
-- than s_46, and the same three answers.
olok_what_doing_skip = ConvoScreen:new {
	id = "what_doing_skip",
	leftDialog = "@conversation/som_cube_ithes_olok:s_203", -- Ah. You are interested in the research of the famous Dr. Olok, are you? I knew you had a keen mind as soon as you walked in. Of course, I would be happy to explain it all to you in full detail. If you have a couple of hours, we could...
	stopConversation = "false",
	options = {
		{"@conversation/som_cube_ithes_olok:s_48", "famous_olok"}, -- Famous Doctor Olok?
		{"@conversation/som_cube_ithes_olok:s_178", "overview"}, -- Just a quick overview is fine.
		{"@conversation/som_cube_ithes_olok:s_182", "bye_tomorrow"}, -- Sorry, I've got to go.
	}
}
som_cube_ithes_olok:addScreen(olok_what_doing_skip)

olok_bye_good_skip = ConvoScreen:new {
	id = "bye_good_skip",
	leftDialog = "@conversation/som_cube_ithes_olok:s_208", -- Good.
	stopConversation = "true",
	options = {}
}
som_cube_ithes_olok:addScreen(olok_bye_good_skip)

olok_bye_tomorrow = ConvoScreen:new {
	id = "bye_tomorrow",
	leftDialog = "@conversation/som_cube_ithes_olok:s_184", -- Hmm? Yes, perhaps we don't have the time now. Come back tomorrow!
	stopConversation = "true",
	options = {}
}
som_cube_ithes_olok:addScreen(olok_bye_tomorrow)

olok_famous_olok = ConvoScreen:new {
	id = "famous_olok",
	leftDialog = "@conversation/som_cube_ithes_olok:s_50", -- Yes, that's right. Doctor Ithes Olok. The foremost researcher whenever Jedi and Force-related artifacts are involved.
	stopConversation = "false",
	options = {
		{"@conversation/som_cube_ithes_olok:s_52", "chu_gon_ask"}, -- Oh...uh, the FAMOUS Dr. Olok, right.
		{"@conversation/som_cube_ithes_olok:s_174", "bye_overwhelmed"}, -- Sorry, I've got to go.
	}
}
som_cube_ithes_olok:addScreen(olok_famous_olok)

olok_bye_overwhelmed = ConvoScreen:new {
	id = "bye_overwhelmed",
	leftDialog = "@conversation/som_cube_ithes_olok:s_176", -- Certainly. I would feel overwhelmed in my presence too. Good day to you.
	stopConversation = "true",
	options = {}
}
som_cube_ithes_olok:addScreen(olok_bye_overwhelmed)

olok_chu_gon_ask = ConvoScreen:new {
	id = "chu_gon_ask",
	leftDialog = "@conversation/som_cube_ithes_olok:s_54", -- Right. Now, I'm sure you've heard of the legend of Chu-Gon Dar, correct?
	stopConversation = "false",
	options = {
		{"@conversation/som_cube_ithes_olok:s_56", "chu_gon_bio"}, -- Refresh my memory.
		{"@conversation/som_cube_ithes_olok:s_166", "chu_gon_bio_no"}, -- No.
		{"@conversation/som_cube_ithes_olok:s_170", "bye_not_interested"}, -- Sorry, I've got to go.
	}
}
som_cube_ithes_olok:addScreen(olok_chu_gon_ask)

-- s_180 is the overview wording of the same question. Same three answers.
olok_overview = ConvoScreen:new {
	id = "overview",
	leftDialog = "@conversation/som_cube_ithes_olok:s_180", -- You see there are many...oh. Ah, right. Overview. I'm sure you've heard of the legend of Chu-Gon Dar, correct?
	stopConversation = "false",
	options = {
		{"@conversation/som_cube_ithes_olok:s_56", "chu_gon_bio"}, -- Refresh my memory.
		{"@conversation/som_cube_ithes_olok:s_166", "chu_gon_bio_no"}, -- No.
		{"@conversation/som_cube_ithes_olok:s_170", "bye_not_interested"}, -- Sorry, I've got to go.
	}
}
som_cube_ithes_olok:addScreen(olok_overview)

olok_bye_not_interested = ConvoScreen:new {
	id = "bye_not_interested",
	leftDialog = "@conversation/som_cube_ithes_olok:s_172", -- Does this not interest you? Ah, very well. Some other time perhaps.
	stopConversation = "true",
	options = {}
}
som_cube_ithes_olok:addScreen(olok_bye_not_interested)

-- s_58: "Refresh my memory" branch. No comma after Mustafar.
olok_chu_gon_bio = ConvoScreen:new {
	id = "chu_gon_bio",
	leftDialog = "@conversation/som_cube_ithes_olok:s_58", -- Chu-Gon Dar was a Jedi Master that lived thousands of years ago during the era of the Old Republic. He resided at the Jedi Temple here on Mustafar and his knowledge and understanding of the Physical Force was unmatched by any other.
	stopConversation = "false",
	options = {
		{"@conversation/som_cube_ithes_olok:s_61", "device"}, -- Go on.
		{"@conversation/som_cube_ithes_olok:s_162", "bye_not_interested_4"}, -- Sorry, I've got to go.
	}
}
som_cube_ithes_olok:addScreen(olok_chu_gon_bio)

-- s_168: "No." branch. Same bio, comma after Mustafar.
olok_chu_gon_bio_no = ConvoScreen:new {
	id = "chu_gon_bio_no",
	leftDialog = "@conversation/som_cube_ithes_olok:s_168", -- Chu-Gon Dar was a Jedi Master that lived thousands of years ago during the era of the Old Republic. He resided at the Jedi Temple here on Mustafar, and his knowledge and understanding of the Physical Force was unmatched by any other.
	stopConversation = "false",
	options = {
		{"@conversation/som_cube_ithes_olok:s_61", "device"}, -- Go on.
		{"@conversation/som_cube_ithes_olok:s_162", "bye_not_interested_4"}, -- Sorry, I've got to go.
	}
}
som_cube_ithes_olok:addScreen(olok_chu_gon_bio_no)

olok_bye_not_interested_2 = ConvoScreen:new {
	id = "bye_not_interested_2",
	leftDialog = "@conversation/som_cube_ithes_olok:s_156", -- Does this not interest you? Ah, very well. Some other time perhaps.
	stopConversation = "true",
	options = {}
}
som_cube_ithes_olok:addScreen(olok_bye_not_interested_2)

olok_device = ConvoScreen:new {
	id = "device",
	leftDialog = "@conversation/som_cube_ithes_olok:s_64", -- Well, you see, the legend goes on to say that using his vast understanding, he created a device. A device designed to channel and manipulate the Physical Force.
	stopConversation = "false",
	options = {
		{"@conversation/som_cube_ithes_olok:s_65", "device_does"}, -- What does the device do?
		{"@conversation/som_cube_ithes_olok:s_158", "bye_not_interested_3"}, -- Sorry, I've got to go.
	}
}
som_cube_ithes_olok:addScreen(olok_device)

olok_bye_not_interested_3 = ConvoScreen:new {
	id = "bye_not_interested_3",
	leftDialog = "@conversation/som_cube_ithes_olok:s_160", -- Does this not interest you? Ah, very well. Some other time perhaps.
	stopConversation = "true",
	options = {}
}
som_cube_ithes_olok:addScreen(olok_bye_not_interested_3)

olok_device_does = ConvoScreen:new {
	id = "device_does",
	leftDialog = "@conversation/som_cube_ithes_olok:s_69", -- The details are a little fuzzy there, but from what I can tell, it was meant to alter the physical properties of the items that were placed inside of it. Apparently, this sometimes produced interesting results.
	stopConversation = "false",
	options = {
		{"@conversation/som_cube_ithes_olok:s_70", "merge_items"}, -- Interesting results?
		{"@conversation/som_cube_ithes_olok:s_154", "bye_not_interested_2"}, -- Sorry, I've got to go.
	}
}
som_cube_ithes_olok:addScreen(olok_device_does)

olok_bye_not_interested_4 = ConvoScreen:new {
	id = "bye_not_interested_4",
	leftDialog = "@conversation/som_cube_ithes_olok:s_164", -- Does this not interest you? Ah, very well. Some other time perhaps.
	stopConversation = "true",
	options = {}
}
som_cube_ithes_olok:addScreen(olok_bye_not_interested_4)

olok_merge_items = ConvoScreen:new {
	id = "merge_items",
	leftDialog = "@conversation/som_cube_ithes_olok:s_75", -- The device is said to have worked off the principle that the Force flows through all things, both animate and inanimate. If the proper items are placed in the device, and the Physical Force altered in a certain way, it is theoretically possible to merge those items into something entirely new!
	stopConversation = "false",
	options = {
		{"@conversation/som_cube_ithes_olok:s_77", "temple_lost"}, -- What does any of this have to do with your research?
		{"@conversation/som_cube_ithes_olok:s_149", "bye_rules"}, -- Sorry, I've got to go.
	}
}
som_cube_ithes_olok:addScreen(olok_merge_items)

olok_temple_lost = ConvoScreen:new {
	id = "temple_lost",
	leftDialog = "@conversation/som_cube_ithes_olok:s_83", -- Ah yes, the exciting part. After the fall of the Old Republic, the Jedi Temple was abandoned. Eventually, it collapsed due to the violent nature of this planet, and the device and its secrets were lost.
	stopConversation = "false",
	options = {
		{"@conversation/som_cube_ithes_olok:s_84", "cubes_found"}, -- Yes, and?
		{"@conversation/som_cube_ithes_olok:s_135", "bye_tutorial"}, -- Sorry, I've got to go.
	}
}
som_cube_ithes_olok:addScreen(olok_temple_lost)

olok_cubes_found = ConvoScreen:new {
	id = "cubes_found",
	leftDialog = "@conversation/som_cube_ithes_olok:s_90", -- And...a recent excavation of the Jedi Temple ruins revealed a hidden underground storage chamber. It was filled with hundreds of these small cubes you see here. I believe that these cubes are duplicates of the device that Chu-Gon Dar created so many years ago.
	stopConversation = "false",
	options = {
		{"@conversation/som_cube_ithes_olok:s_91", "cubes_stuck"}, -- Really? Do they work?
		{"@conversation/som_cube_ithes_olok:s_113", "decline_fascinating"}, -- That's a fascinating story, but I really must go.
	}
}
som_cube_ithes_olok:addScreen(olok_cubes_found)

olok_decline_fascinating = ConvoScreen:new {
	id = "decline_fascinating",
	leftDialog = "@conversation/som_cube_ithes_olok:s_129", -- I... well. I suppose if you must. Come back any time, though.
	stopConversation = "true",
	options = {}
}
som_cube_ithes_olok:addScreen(olok_decline_fascinating)

-- s_101 / s_104 sit here: leaving after the cube problem, before the
-- scroll. The s_103 / s_105 twin sits on scrolls (s_99).
olok_cubes_stuck = ConvoScreen:new {
	id = "cubes_stuck",
	leftDialog = "@conversation/som_cube_ithes_olok:s_94", -- To be honest, I don't know. These cubes do radiate strongly with the power of the Physical Force, and they do seem hollow inside. I just can't seem to get any of them open. However...
	stopConversation = "false",
	options = {
		{"@conversation/som_cube_ithes_olok:s_95", "scrolls"}, -- However what?
		{"@conversation/som_cube_ithes_olok:s_101", "decline_luck"}, -- Well, good luck with all that, but I really must go.
	}
}
som_cube_ithes_olok:addScreen(olok_cubes_stuck)

olok_decline_luck_2 = ConvoScreen:new {
	id = "decline_luck_2",
	leftDialog = "@conversation/som_cube_ithes_olok:s_105", -- I...well. I suppose if you must. Come back any time, though.
	stopConversation = "true",
	options = {}
}
som_cube_ithes_olok:addScreen(olok_decline_luck_2)

olok_scrolls = ConvoScreen:new {
	id = "scrolls",
	leftDialog = "@conversation/som_cube_ithes_olok:s_99", -- We did find some ancient scrolls in the temple ruins along with the cubes. I think that they may provide the information that we need, but there are a couple of symbols used that I don't quite understand. I need to know more about these symbols in order to read the scrolls.
	stopConversation = "false",
	options = {
		{"@conversation/som_cube_ithes_olok:s_100", "need_notes"}, -- Is there anything that I can do to help?
		{"@conversation/som_cube_ithes_olok:s_103", "decline_luck_2"}, -- Well, good luck with all that, but I really must go.
	}
}
som_cube_ithes_olok:addScreen(olok_scrolls)

olok_decline_luck = ConvoScreen:new {
	id = "decline_luck",
	leftDialog = "@conversation/som_cube_ithes_olok:s_104", -- I...well. I suppose if you must. Come back any time, though.
	stopConversation = "true",
	options = {}
}
som_cube_ithes_olok:addScreen(olok_decline_luck)

olok_need_notes = ConvoScreen:new {
	id = "need_notes",
	leftDialog = "@conversation/som_cube_ithes_olok:s_106", -- Actually, there is. I've seen symbols like these before, while surveying some Old Republic ruins to the south of this facility. I didn't think much about it at the time, but I believe if I could get some notes about the symbols there, we might understand more about this scroll.
	stopConversation = "false",
	options = {
		{"@conversation/som_cube_ithes_olok:s_107", "take_notes"}, -- What do you need me to do?
		{"@conversation/som_cube_ithes_olok:s_108", "decline_help"}, -- On second thought, I don't think I can help.
	}
}
som_cube_ithes_olok:addScreen(olok_need_notes)

olok_decline_help = ConvoScreen:new {
	id = "decline_help",
	leftDialog = "@conversation/som_cube_ithes_olok:s_109", -- Oh really? That's too bad. I guess I keep at it on my own then. Do come back if you change your mind.
	stopConversation = "true",
	options = {}
}
som_cube_ithes_olok:addScreen(olok_decline_help)

olok_take_notes = ConvoScreen:new {
	id = "take_notes",
	leftDialog = "@conversation/som_cube_ithes_olok:s_110", -- I'm no spry hatchling anymore. I can't quite get around as well as I used to, and all my assistants are out in the field already. I need you to go take some notes from three of the symbol stones at the Old Republic ruins down to the south.
	stopConversation = "false",
	options = {
		{"@conversation/som_cube_ithes_olok:s_111", "accept_notes"}, -- I think I can do that.
		{"@conversation/som_cube_ithes_olok:s_114", "decline_help_2"}, -- On second thought, I don't think I can help.
	}
}
som_cube_ithes_olok:addScreen(olok_take_notes)

olok_decline_help_2 = ConvoScreen:new {
	id = "decline_help_2",
	leftDialog = "@conversation/som_cube_ithes_olok:s_116", -- Oh really? That's too bad. I guess I keep at it on my own then. Do come back if you change your mind.
	stopConversation = "true",
	options = {}
}
som_cube_ithes_olok:addScreen(olok_decline_help_2)

olok_accept_notes = ConvoScreen:new {
	id = "accept_notes",
	leftDialog = "@conversation/som_cube_ithes_olok:s_117", -- That's excellent news! If I can make sense of what you bring back, I'll make sure you share in the findings! 
	stopConversation = "true",
	options = {}
}
som_cube_ithes_olok:addScreen(olok_accept_notes)

-- =====================================================================
-- Stages 1-3 -- s_118. Handler fills the option from getStage.
-- =====================================================================

olok_notes_progress = ConvoScreen:new {
	id = "notes_progress",
	leftDialog = "@conversation/som_cube_ithes_olok:s_118", -- Ah, the intrepid archaeologist has returned! Were you able to find the Old Republic ruins? Did you take the notes from the symbol stones?
	stopConversation = "false",
	options = {}
}
som_cube_ithes_olok:addScreen(olok_notes_progress)

olok_still_working = ConvoScreen:new {
	id = "still_working",
	leftDialog = "@conversation/som_cube_ithes_olok:s_121", -- Well then, go finish up! Make haste!
	stopConversation = "true",
	options = {}
}
som_cube_ithes_olok:addScreen(olok_still_working)

olok_notes_handin = ConvoScreen:new {
	id = "notes_handin",
	leftDialog = "@conversation/som_cube_ithes_olok:s_122", -- Excellent! Let me see. Hmm, now to compare it to the scroll. Ah...of course, that's what that means. It all makes sense now. Would you like to see how it works? Let me show you. Take this cube. You can keep it. I have plenty others. Oh, and these three objects.
	stopConversation = "false",
	options = {
		{"@conversation/som_cube_ithes_olok:s_123", "cube_open"}, -- OK. What do I do?
		{"@conversation/som_cube_ithes_olok:s_124", "figure_later"}, -- Thanks, but I'll figure it out myself later.
	}
}
som_cube_ithes_olok:addScreen(olok_notes_handin)

olok_figure_later = ConvoScreen:new {
	id = "figure_later",
	leftDialog = "@conversation/som_cube_ithes_olok:s_125", -- As you wish. Thank you for your help. Come back if you need assistance!
	stopConversation = "true",
	options = {}
}
som_cube_ithes_olok:addScreen(olok_figure_later)

olok_cube_open = ConvoScreen:new {
	id = "cube_open",
	leftDialog = "@conversation/som_cube_ithes_olok:s_126", -- I've initialized the cube so that it can be opened. Just open it like you might any other container and place the items that I gave you inside.
	stopConversation = "false",
	options = {
		{"@conversation/som_cube_ithes_olok:s_127", "cube_activate"}, -- I see. Then what?
		{"@conversation/som_cube_ithes_olok:s_128", "figure_rest"}, -- Thanks. I'll figure out the rest myself.
	}
}
som_cube_ithes_olok:addScreen(olok_cube_open)

olok_figure_rest = ConvoScreen:new {
	id = "figure_rest",
	leftDialog = "@conversation/som_cube_ithes_olok:s_130", -- As you wish. Thank you for your help. Come back if you need assistance!
	stopConversation = "true",
	options = {}
}
som_cube_ithes_olok:addScreen(olok_figure_rest)

olok_cube_activate = ConvoScreen:new {
	id = "cube_activate",
	leftDialog = "@conversation/som_cube_ithes_olok:s_131", -- Once the items are inside, close the cube and then activate it using the radial interface there on the cube.
	stopConversation = "false",
	options = {
		{"@conversation/som_cube_ithes_olok:s_132", "cube_result"}, -- OK, then what?
		{"@conversation/som_cube_ithes_olok:s_134", "figure_rest_2"}, -- Thanks. I'll figure out the rest myself.
	}
}
som_cube_ithes_olok:addScreen(olok_cube_activate)

olok_figure_rest_2 = ConvoScreen:new {
	id = "figure_rest_2",
	leftDialog = "@conversation/som_cube_ithes_olok:s_136", -- As you wish. Thank you for your help. Come back if you need assistance!
	stopConversation = "true",
	options = {}
}
som_cube_ithes_olok:addScreen(olok_figure_rest_2)

olok_bye_tutorial = ConvoScreen:new {
	id = "bye_tutorial",
	leftDialog = "@conversation/som_cube_ithes_olok:s_139", -- Does this not interest you? Ah, very well. Some other time perhaps.
	stopConversation = "true",
	options = {}
}
som_cube_ithes_olok:addScreen(olok_bye_tutorial)

olok_cube_result = ConvoScreen:new {
	id = "cube_result",
	leftDialog = "@conversation/som_cube_ithes_olok:s_137", -- Then you should have a brand-new item inside! Significantly different from the original items that you put in there. Isn't that marvelous!
	stopConversation = "false",
	options = {
		{"@conversation/som_cube_ithes_olok:s_145", "cube_rules"}, -- Is there anything else I should know?
	}
}
som_cube_ithes_olok:addScreen(olok_cube_result)

-- =====================================================================
-- Stage 4 -- finished, stays finished. How-to and lost-cube branches.
-- =====================================================================

olok_greeting_done = ConvoScreen:new {
	id = "greeting_done",
	leftDialog = "@conversation/som_cube_ithes_olok:s_140", -- Ah, what brings you back here, my friend? Do you need another explanation on how to work the cube?
	stopConversation = "false",
	options = {
		-- Live puts s_193 first and gates it on lostCube; the handler drops it for
		-- anyone who still has the cube.
		{"@conversation/som_cube_ithes_olok:s_193", "lost_cube"}, -- Actually, I lost the cube.
		{"@conversation/som_cube_ithes_olok:s_141", "cube_howto"}, -- Yes, please.
		{"@conversation/som_cube_ithes_olok:s_142", "take_care"}, -- No, I've got it figured out.
	}
}
som_cube_ithes_olok:addScreen(olok_greeting_done)

olok_take_care = ConvoScreen:new {
	id = "take_care",
	leftDialog = "@conversation/som_cube_ithes_olok:s_143", -- Excellent. Take care then!
	stopConversation = "true",
	options = {}
}
som_cube_ithes_olok:addScreen(olok_take_care)

-- Stage-4 re-entry into the tutorial. s_144 repeats s_126's instruction and then
-- hands off to the same rungs; s_200 is the same sentence after a lost cube.
olok_cube_howto = ConvoScreen:new {
	id = "cube_howto",
	leftDialog = "@conversation/som_cube_ithes_olok:s_144", -- Of course! Just open the cube like you might any other container and place three items inside.
	stopConversation = "false",
	options = {
		{"@conversation/som_cube_ithes_olok:s_127", "cube_activate"}, -- I see. Then what?
		{"@conversation/som_cube_ithes_olok:s_128", "figure_rest"}, -- Thanks. I'll figure out the rest myself.
	}
}
som_cube_ithes_olok:addScreen(olok_cube_howto)

-- Last rung of the tutorial ladder, reached from s_137 whichever way the player
-- entered it.
olok_cube_rules = ConvoScreen:new {
	id = "cube_rules",
	leftDialog = "@conversation/som_cube_ithes_olok:s_146", -- Just remember that you must combine exactly three items in the cube. It won't work with only one or two. And you will not be able to combine every single item. Only certain items that have an appropriate Force alignment will work in the cube. Does that make sense?
	stopConversation = "false",
	options = {
		{"@conversation/som_cube_ithes_olok:s_148", "thanks_luck"}, -- Yes. Thank you for the explanation.
	}
}
som_cube_ithes_olok:addScreen(olok_cube_rules)

olok_thanks_luck = ConvoScreen:new {
	id = "thanks_luck",
	leftDialog = "@conversation/som_cube_ithes_olok:s_150", -- No, thank you for all your help! Good luck out there!
	stopConversation = "true",
	options = {}
}
som_cube_ithes_olok:addScreen(olok_thanks_luck)

olok_bye_rules = ConvoScreen:new {
	id = "bye_rules",
	leftDialog = "@conversation/som_cube_ithes_olok:s_152", -- Does this not interest you? Ah, very well. Some other time perhaps.
	stopConversation = "true",
	options = {}
}
som_cube_ithes_olok:addScreen(olok_bye_rules)

-- Lost-cube branch. s_194 hands over another cube for real: the handler calls
-- somJenhaTarCubeScreenPlay:replaceCube, which gates on stage 4 and on a base
-- inventory check, the way live did.
olok_lost_cube = ConvoScreen:new {
	id = "lost_cube",
	leftDialog = "@conversation/som_cube_ithes_olok:s_194", -- Seriously? Well, since you were so kind as to help me out, I suppose I can let you have another. But be careful with this one. These are delicate Jedi artifacts!
	stopConversation = "false",
	options = {
		{"@conversation/som_cube_ithes_olok:s_195", "need_explain"}, -- Thank you.
	}
}
som_cube_ithes_olok:addScreen(olok_lost_cube)

olok_need_explain = ConvoScreen:new {
	id = "need_explain",
	leftDialog = "@conversation/som_cube_ithes_olok:s_196", -- Now, do you need another explanation on how to work the cube?
	stopConversation = "false",
	options = {
		{"@conversation/som_cube_ithes_olok:s_198", "cube_howto_2"}, -- Yes, please.
		{"@conversation/som_cube_ithes_olok:s_202", "take_care_2"}, -- No, I've got it figured out.
	}
}
som_cube_ithes_olok:addScreen(olok_need_explain)

olok_cube_howto_2 = ConvoScreen:new {
	id = "cube_howto_2",
	leftDialog = "@conversation/som_cube_ithes_olok:s_200", -- Of course! Just open the cube like you might any other container and place three items inside.
	stopConversation = "false",
	options = {
		{"@conversation/som_cube_ithes_olok:s_127", "cube_activate"}, -- I see. Then what?
		{"@conversation/som_cube_ithes_olok:s_128", "figure_rest"}, -- Thanks. I'll figure out the rest myself.
	}
}
som_cube_ithes_olok:addScreen(olok_cube_howto_2)

olok_take_care_2 = ConvoScreen:new {
	id = "take_care_2",
	leftDialog = "@conversation/som_cube_ithes_olok:s_204", -- Excellent. Take care then!
	stopConversation = "true",
	options = {}
}
som_cube_ithes_olok:addScreen(olok_take_care_2)

addConversationTemplate("som_cube_ithes_olok", som_cube_ithes_olok)

-- =====================================================================
-- ROWS NOT PLACED
-- =====================================================================
-- None. Every row in the table except s_2 (empty) and do_not_edit is on a
-- screen. This section used to hold s_130 and s_192; see CORRECTING s_192
-- AND s_130 at the top for where live puts them and why they were missed.
