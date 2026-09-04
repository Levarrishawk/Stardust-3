-- scripts/mobile/conversations/mustafar/som_glyph_hunt.lua
--
-- Strings from string/en/conversation/som_glyph_hunt.stf (complete shipped
-- table; s_2 empty and do_not_edit already excluded).
--
-- HOW THIS WAS BUILT, AND WHAT THAT COST. The wiring was first reconstructed
-- from the string table alone -- speaker voice, adjacent-number spines, and
-- answer-to-question fit, nothing else -- because the trees were server-side.
-- It has since been checked edge by edge against the server-side script, which
-- does record the wiring. The first-meeting spine and both job spines held
-- exactly. The four in-progress greetings did not, and two other claims below
-- were wrong. All three corrections are recorded here rather than quietly
-- applied.
--
-- CORRECTING THE FOUR STAGE GREETINGS. They were paired with the wrong player
-- lines -- within each task, the check-in screen and the hand-in screen were
-- swapped. Live is:
--   on first task       s_48 + s_50   "located all three yet?" / "still looking"
--   first task done     s_17 + s_25   "find anything yet?"     / "copies. Here."
--   on second task      s_13 + s_37   "sections on the officers?" / "still on the job"
--   second task done    s_5  + s_39   "locate the missing sections?" / "here you go"
--
-- ROOT CAUSE: reading the questions for how SPECIFIC they sound. s_17 "Did you
-- manage to find anything yet?" is vague and s_48 "Have you managed to locate
-- all three of the glyphs yet?" is precise, so the vague one was read as the
-- earlier of the two. Live is the other way round, and the same inversion was
-- then repeated on the second task. Nothing in the .stf distinguishes them --
-- both are questions the same man asks the same player on the same errand --
-- so the guess had no evidence behind it either way. What made it visible was
-- the option: each of the four screens ended up carrying a player line live
-- does not offer there, which is a checkable fact rather than a judgement.
--
-- CORRECTING THE POST-QUEST GREETING. See THE POST-QUEST GREETING below.
--
-- CORRECTING WHERE THE FIRST SIGNAL FIRES. See the handler.
--
-- Speaker: Pletus is the elderly Naboo academic (s_60 calls him "old timer",
-- s_62 is his self-introduction). Player lines are the ones that answer his
-- questions or accept / decline work (s_33 "Not a problem", s_74 "Maybe I
-- can help"). %NU is left exactly as shipped.
--
-- First-meeting spine is s_54 through s_84 in the order SOE numbered it.
-- After s_62 names only "the Coyn", two player questions are live:
--   s_64  "Who are these Coyn?" -> s_66, which names the Razor Runners
--   s_70  "Why would the Coyn care about you being there?" -> s_72
-- After s_66 names the guild, the same why-question ships again as s_68
-- ("Why would these Razor Runners care..."). Both wordings are placed;
-- they are the same question asked on either side of learning the guild
-- name, and both land on s_72 (the hire / loot answer).
--
-- s_25 ships as "copies of two of the ruins" even though the quest is
-- three glyphs and stage 2 is "all three copied". Quoted exactly; not
-- corrected.
--
-- Second-job spine is s_25 through s_34 (accept) with s_35 / s_46 the
-- decline sibling on the s_28 pay-offer. Reward spine is s_39 through s_44.
--
-- In-progress / hand-in greetings, one per live stage, taken from the live
-- start chain rather than guessed:
--   1  s_48  player s_50 -> s_52                    check-in 1
--   2  s_17  player s_25 -> s_26                    hand-in 1
--   3  s_13  player s_37 -> s_38                    check-in 2
--   4  s_5   player s_39 -> s_40                    hand-in 2
-- Stage 0 / transient 5: first meeting s_54. Stage 5 dies immediately
-- after awardQuest; treat it as 0.
--
-- THE POST-QUEST GREETING. s_36 is placed, and it is the FIRST thing live
-- checks -- ahead of all four stage greetings and ahead of the first meeting.
-- It used to sit under a "ROWS NOT PLACED" heading here, on the reasoning that
-- "no public entry point distinguishes a repeater from a new player, so s_36
-- has no honest screen".
--
-- That was wrong on both counts. Live's gate is
-- groundquests.hasCompletedQuest(player, "som_glyph_hunt"), and this port has
-- had the equivalent all along: the screenplay's `runs` counter, which its own
-- comment describes as "what says the character has finished it at least once".
--
-- ROOT CAUSE: the claim was written while reading the .stf, before the
-- screenplay's data keys were in view, and it was never revisited once `runs`
-- existed. It is the kind of claim that reads as a finding -- "the shipped data
-- has no home for this row" -- when it was only a statement about what had been
-- looked at. A row with nowhere to go is a conclusion, not a default.
--
-- Note what live's ordering means: a character who has finished the quest gets
-- s_36 and nothing else, forever. Pletus never offers it a second time, whatever
-- the .qst's allowRepeats says. See the handler.
--
-- Side effects (in the handler, not here):
--   accept_glyphs   grantQuest
--   two_copies      signalGlyphsFound   (he takes the copies)
--   payment         signalGlyphFinish   (he pays)

som_glyph_hunt = ConvoTemplate:new {
	initialScreen = "greeting",
	templateType = "Lua",
	luaClassHandler = "glyph_hunt_conv_handler",
	screens = {}
}

-- =====================================================================
-- Already helped him -- checked FIRST, before every stage below, which is
-- where live checks it. See THE POST-QUEST GREETING in the header.
-- =====================================================================

-- DEVIATION, the standing one for this port. Live delivers s_36 with
-- chat.chat -- a spatial speech bubble and no conversation window at all.
-- Core3 cannot render that from a conversation template, so it becomes a
-- one-line terminal screen. Same treatment as every other bark in this
-- directory.
pletus_already_helped = ConvoScreen:new {
	id = "already_helped",
	leftDialog = "@conversation/som_glyph_hunt:s_36", -- Hello again. I have just been studying these glyphs that you were kind enough to recover. I still am not sure what it means, but I am fairly certain that this is some sort of history written in the stone glyphs. Thank you again.
	stopConversation = "true",
	options = {}
}
som_glyph_hunt:addScreen(pletus_already_helped)

-- =====================================================================
-- Stage 0 -- first meeting. Spine s_54 through s_84.
-- =====================================================================

pletus_greeting = ConvoScreen:new {
	id = "greeting",
	leftDialog = "@conversation/som_glyph_hunt:s_54", -- Hello, traveler. It's another glorious day here on Mustafar. What a wonderful world, wouldn't you agree?
	stopConversation = "false",
	options = {
		{"@conversation/som_glyph_hunt:s_56", "not_that_glorious"}, -- I don't know if I would go that far.
	}
}
som_glyph_hunt:addScreen(pletus_greeting)

pletus_not_that_glorious = ConvoScreen:new {
	id = "not_that_glorious",
	leftDialog = "@conversation/som_glyph_hunt:s_58", -- I certainly would. There are some amazing discoveries taking place all around us. I was on the trail of one of my own until those Coyn showed up and drove me out.
	stopConversation = "false",
	options = {
		{"@conversation/som_glyph_hunt:s_60", "who_is_pletus"}, -- Slow down, old timer. What are you talking about?
	}
}
som_glyph_hunt:addScreen(pletus_not_that_glorious)

-- s_64 and s_70 are both live here: identity first, or skip straight to why.
pletus_who_is_pletus = ConvoScreen:new {
	id = "who_is_pletus",
	leftDialog = "@conversation/som_glyph_hunt:s_62", -- Sorry, I was getting ahead of myself. I am Pletus Croix of the Nabooian Historical Archives. When I heard of the discovery of all the ruins here on Mustafar, I just had to see them for myself. You see, there is no mention of them in any of the galactic records. I was studying the glyphs in the ruins north of here and was piecing together the story of Mustafar when the Coyn showed up.
	stopConversation = "false",
	options = {
		{"@conversation/som_glyph_hunt:s_64", "who_are_coyn"}, -- Who are these Coyn?
		{"@conversation/som_glyph_hunt:s_70", "why_they_care"}, -- Why would the Coyn care about you being there?
	}
}
som_glyph_hunt:addScreen(pletus_who_is_pletus)

pletus_who_are_coyn = ConvoScreen:new {
	id = "who_are_coyn",
	leftDialog = "@conversation/som_glyph_hunt:s_66", -- They are warriors for hire. Their entire people join their mercenary guilds and hire themselves out for various operations around the galaxy. The group who took over the ruins call themselves Razor Runners. Named after their leader, Hal Razor, no doubt.
	stopConversation = "false",
	options = {
		{"@conversation/som_glyph_hunt:s_68", "why_they_care"}, -- Why would these Razor Runners care about you being there?
	}
}
som_glyph_hunt:addScreen(pletus_who_are_coyn)

pletus_why_they_care = ConvoScreen:new {
	id = "why_they_care",
	leftDialog = "@conversation/som_glyph_hunt:s_72", -- Most likely, they were hired by someone to secure the ruins for financial gain. They didn't want anyone else sniffing around while they looted the place. I was on the verge of unlocking the mystery of this moon too. Such a shame that all that knowledge will be lost because of greedy men.
	stopConversation = "false",
	options = {
		{"@conversation/som_glyph_hunt:s_74", "offer_glyphs"}, -- Maybe I can help you out.
	}
}
som_glyph_hunt:addScreen(pletus_why_they_care)

pletus_offer_glyphs = ConvoScreen:new {
	id = "offer_glyphs",
	leftDialog = "@conversation/som_glyph_hunt:s_76", -- Really? You do look like the sort who can handle himself against those mercenaries. Okay, listen up and I will fill you in on what needs to be done. There are three altars with glyphs all over them up there. I was just starting to study them when I was kicked out. I believe they tell the story of what happened on Mustafar. If you could study those glyphs for me, I am sure I could piece it all together.
	stopConversation = "false",
	options = {
		{"@conversation/som_glyph_hunt:s_78", "accept_glyphs"}, -- Sounds easy enough.
		{"@conversation/som_glyph_hunt:s_82", "decline_glyphs"}, -- On second thought, I am going to stay away from the Coyn.
	}
}
som_glyph_hunt:addScreen(pletus_offer_glyphs)

pletus_accept_glyphs = ConvoScreen:new {
	id = "accept_glyphs",
	leftDialog = "@conversation/som_glyph_hunt:s_80", -- It should be. Just find all three of the glyphs, study them, and then come back to me. Don't try to be a hero or anything. If those Razor Runners start shooting, get out of there. I want to know the history of this moon, but I don't want anyone to die because of it.
	stopConversation = "true",
	options = {}
}
som_glyph_hunt:addScreen(pletus_accept_glyphs)

pletus_decline_glyphs = ConvoScreen:new {
	id = "decline_glyphs",
	leftDialog = "@conversation/som_glyph_hunt:s_84", -- That is probably for the best. I will just have to wait for them to leave and then see if I can find anything out from the scrapes they leave behind.
	stopConversation = "true",
	options = {}
}
som_glyph_hunt:addScreen(pletus_decline_glyphs)

-- =====================================================================
-- Stage 1 -- glyph copies still live. Check-in only; no hand-in option.
-- =====================================================================

pletus_glyphs_checkin = ConvoScreen:new {
	id = "glyphs_checkin",
	leftDialog = "@conversation/som_glyph_hunt:s_48", -- Hello again, %NU. Have you managed to locate all three of the glyphs yet?
	stopConversation = "false",
	options = {
		{"@conversation/som_glyph_hunt:s_50", "still_looking"}, -- Not so far. But I am still looking.
	}
}
som_glyph_hunt:addScreen(pletus_glyphs_checkin)

pletus_still_looking = ConvoScreen:new {
	id = "still_looking",
	leftDialog = "@conversation/som_glyph_hunt:s_52", -- That sounds good. I will just wait here for your return.
	stopConversation = "true",
	options = {}
}
som_glyph_hunt:addScreen(pletus_still_looking)

-- =====================================================================
-- Stage 2 -- all three copied; hand-in 1. s_25 is the shipped player line
-- even though it says "two of the ruins".
-- =====================================================================

pletus_glyphs_return = ConvoScreen:new {
	id = "glyphs_return",
	leftDialog = "@conversation/som_glyph_hunt:s_17", -- It is good to see you again, %NU. Did you manage to find anything yet?
	stopConversation = "false",
	options = {
		{"@conversation/som_glyph_hunt:s_25", "two_copies"}, -- I managed to get copies of two of the ruins. Here.
	}
}
som_glyph_hunt:addScreen(pletus_glyphs_return)

pletus_two_copies = ConvoScreen:new {
	id = "two_copies",
	leftDialog = "@conversation/som_glyph_hunt:s_26", -- Astounding. This shows the moon as a once-rich, lush world. And this obviously shows the aftermath of some sort of cataclysmic event. Where is the third glyph? The one that should show us what happened.
	stopConversation = "false",
	options = {
		{"@conversation/som_glyph_hunt:s_27", "defaced"}, -- It has been defaced. It is missing entire sections.
	}
}
som_glyph_hunt:addScreen(pletus_two_copies)

pletus_defaced = ConvoScreen:new {
	id = "defaced",
	leftDialog = "@conversation/som_glyph_hunt:s_28", -- What! When I made my initial survey, I know all three were intact and in good condition. That means the Coyn must have removed those missing sections. I hate to ask you this, but...but this discovery is simply too important. I need you to recover the pieces from them. I can pay you.
	stopConversation = "false",
	options = {
		{"@conversation/som_glyph_hunt:s_29", "start_looking"}, -- Okay. Where should I start looking?
		{"@conversation/som_glyph_hunt:s_35", "decline_officers"}, -- Maybe later. I have other things to attend to right now.
	}
}
som_glyph_hunt:addScreen(pletus_defaced)

pletus_start_looking = ConvoScreen:new {
	id = "start_looking",
	leftDialog = "@conversation/som_glyph_hunt:s_30", -- It is obvious that the mercenaries were targeting these on purpose. I would wager everything I own that their commanding officers have the missing pieces. You will have to defeat them and recover the pieces.
	stopConversation = "false",
	options = {
		{"@conversation/som_glyph_hunt:s_33", "the_officers"}, -- Not a problem. Who are the officers?
	}
}
som_glyph_hunt:addScreen(pletus_start_looking)

pletus_the_officers = ConvoScreen:new {
	id = "the_officers",
	leftDialog = "@conversation/som_glyph_hunt:s_34", -- There are two of them. The younger is called Captain Starslay...no...Captain Starkill, that's it. The senior officer is Hal Razor. A pompous jay if I ever laid my eyes on one, but, from what I gather, a very capable soldier. If anyone has those pieces, it will be those two.
	stopConversation = "true",
	options = {}
}
som_glyph_hunt:addScreen(pletus_the_officers)

pletus_decline_officers = ConvoScreen:new {
	id = "decline_officers",
	leftDialog = "@conversation/som_glyph_hunt:s_46", -- Very well. Take care, traveler.
	stopConversation = "true",
	options = {}
}
som_glyph_hunt:addScreen(pletus_decline_officers)

-- =====================================================================
-- Stage 3 -- officer kill still live. Check-in only; no hand-in option.
-- =====================================================================

pletus_sections_checkin = ConvoScreen:new {
	id = "sections_checkin",
	leftDialog = "@conversation/som_glyph_hunt:s_13", -- Did you find the missing sections on the Coyn officers?
	stopConversation = "false",
	options = {
		{"@conversation/som_glyph_hunt:s_37", "still_on_job"}, -- Not so far. But I am still on the job.
	}
}
som_glyph_hunt:addScreen(pletus_sections_checkin)

pletus_still_on_job = ConvoScreen:new {
	id = "still_on_job",
	leftDialog = "@conversation/som_glyph_hunt:s_38", -- Alright. I will just wait here for you to return again.
	stopConversation = "true",
	options = {}
}
som_glyph_hunt:addScreen(pletus_still_on_job)

-- =====================================================================
-- Stage 4 -- both chunks recovered; hand-in 2. Payment is s_44.
-- =====================================================================

pletus_officers_return = ConvoScreen:new {
	id = "officers_return",
	leftDialog = "@conversation/som_glyph_hunt:s_5", -- So did you manage to locate the missing sections?
	stopConversation = "false",
	options = {
		{"@conversation/som_glyph_hunt:s_39", "ritual"}, -- Yes, here you go.
	}
}
som_glyph_hunt:addScreen(pletus_officers_return)

pletus_ritual = ConvoScreen:new {
	id = "ritual",
	leftDialog = "@conversation/som_glyph_hunt:s_40", -- Ah, thank you. This is very interesting. These show what appear to be robed figures surrounding a large crystal in a ritual of sorts. In the background, you can make out shadowy figures...they appear to be very menacing. Light is coming out of the fingertips of the robed figures and entering the crystal.  Hmmmm....
	stopConversation = "false",
	options = {
		{"@conversation/som_glyph_hunt:s_41", "crystal"}, -- What is it?
	}
}
som_glyph_hunt:addScreen(pletus_ritual)

pletus_crystal = ConvoScreen:new {
	id = "crystal",
	leftDialog = "@conversation/som_glyph_hunt:s_42", -- The next frame shows the crystal shattering in a ball of fire. The menacing figure in the background is fleeing but is caught in the fire, as are all of the robed figures. Very strange. I wonder if this is what actually happened or just some sort of ritual prayer of the ancients who used to live here.
	stopConversation = "false",
	options = {
		{"@conversation/som_glyph_hunt:s_43", "payment"}, -- I don't know.
	}
}
som_glyph_hunt:addScreen(pletus_crystal)

pletus_payment = ConvoScreen:new {
	id = "payment",
	leftDialog = "@conversation/som_glyph_hunt:s_44", -- I will need to study this further. And as promised, here is your payment for services rendered. Thank you again for your help. This is an amazing find, although it will be some time before I am sure what it means.
	stopConversation = "true",
	options = {}
}
som_glyph_hunt:addScreen(pletus_payment)

addConversationTemplate("som_glyph_hunt", som_glyph_hunt)

-- =====================================================================
-- ROWS NOT PLACED
-- =====================================================================
-- None. Every speaking row in the table now has a screen. s_36 was the last
-- one listed here and it is placed as already_helped; see THE POST-QUEST
-- GREETING in the header for why the earlier "no honest screen" note was
-- wrong and what it was reasoning from.
