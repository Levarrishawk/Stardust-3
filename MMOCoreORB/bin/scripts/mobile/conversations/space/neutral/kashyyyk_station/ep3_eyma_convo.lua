-- Eyma -- commander of the Civilian Protection Guild (his own words, s_657).
--
-- Giver for the four Kashyyyk station-file quest heads that had no giver:
--
--   escort/ep3_kash_station_escort_ghrag                (global line 124, registered line 164)
--   assassinate/ep3_kash_station_assassinate_imperial   (global line 433, registered line 471)
--   assassinate/ep3_kash_station_assassinate_rebel      (global line 389, registered line 431)
--   assassinate/ep3_kash_station_assassinate_neutral    (global line 473, registered line 511)
--
-- All four live in screenplays/space/squadrons/KashyyykStationScreenplay.lua.
--
-- EVERY leftDialog and EVERY option below is a verbatim shipped key from
-- conversation/ep3_eyma.stf (199 entries). Nothing is authored.
--
-- THE REPO ALREADY NAMED HIM. KashyyykStationScreenplay.lua:119-122, written before this file, reads
-- 'STF: "Eyma has made contact with a high-ranking Ghrag mercenary who wants to leave the
-- organization and join an order of monks on Tatooine."' and line 405-406 reads 'STF title_d: Eyma
-- tracks the dealer using information from the Ghrag traitor the player escorted out of the system.'
-- His conversation stf carries both of those in his own voice:
--   s_470 "we have been contacted by a high-ranking Ghrag mercenary!  He wishes to escape the
--          criminal life and join the monks on Tatooine."
--   s_347 "The ex-mercenary that you escorted out of Kashyyyk space has provided us with detailed
--          tactical information about the Ghrag mercenary clan."
--
-- Each pitch matches its screenplay field for field:
--   s_477 "You'll need to escort his shuttle to the Kashyyyk space station and protect him from any
--   Ghrag mercenaries that would attack him" == questType "escort", escortShips
--   {"ghrag_traitor_tier5"} and the three attackShips waves of ghrag_merc / ghrag_assassin /
--   ghrag_persuader / ghrag_specialist.
--   s_359 "a weapons dealer named Vosc Traaer from Naboo... He was a supplier for the Empire until he
--   was discovered to be an embezzeler" and s_297 "plans to destroy the Imperial Space station in
--   Kashyyyk space" == assassinate/ep3_kash_station_assassinate_imperial.
--   s_377 "a weapons dealer named Faydo Sha from Corellia... discovered him to be a prolific
--   slave-trader" and s_369 "plans to destroy a Rebel Outpost somewhere here in Kashyyyk" ==
--   assassinate/ep3_kash_station_assassinate_rebel. This is the variant the screenplay's own comment
--   at line 385-386 says the trn_slaver_barge_tier5 target is client-supported for.
--   s_427 "a weapons dealer named Kred'ka Sul" and s_419 "for the purpose of destroying the Kashyyyk
--   space station" == assassinate/ep3_kash_station_assassinate_neutral.
--   s_363 / s_381 / s_427 all read "intercept his starship and destroy it" == questType
--   "assassinate", and "will be escorted through this system" == the four-strong escorts list on
--   assassinateSpawns.
--
-- THE THREE-WAY FACTION SPLIT IS THE CLIENT'S, NOT OURS. The stf ships three complete, separate
-- weapons-dealer briefings, one per faction, and says so in its own text: s_355 "They know that you
-- are an Imperial pilot", s_373 "They know that you are a Rebel pilot", s_423 "They know that you
-- have been talking to Rian Ry and myself". The screenplay ships exactly three matching quests. The
-- handler routes with TangibleObject(pPlayer):isImperial() / :isRebel(), the same test the sibling
-- files spacestation_kash_imperial_conv_handler.lua:201-205 and
-- spacestation_kash_rebel_conv_handler.lua:172-176 already use.
--
-- ORDERING IS ENFORCED IN THE HANDLER, NOT BY parentQuest. All three assassinates declare
-- parentQuest = "escort_ep3_kash_station_escort_ghrag", but every Space*Screenplay uses parentQuest
-- only as a fail-cascade (createEvent(200, ..., "failQuest", ...)); it starts nothing and gates
-- nothing. The client's own ordering -- escort first, then the dealer, because the dealer intel comes
-- FROM the escorted traitor (s_347, s_363 "According to our friend the ex-Ghrag...") -- is enforced
-- in getInitialScreen.
--
-- FLAGGED INTERPRETATION -- SCREEN TOPOLOGY. The client ships no screen graph. Every chain below is
-- read off the .stf's own key order and its speaker alternation. Three joins are ours and are called
-- out at the screen that makes them:
--   (a) s_652 as a first-meeting screen gated on a MET latch, with s_470 "It is good to see you
--       again!" from the second conversation onward. His text distinguishes the two; the latch is
--       ours.
--   (b) s_211 "Got anything for me?" and s_252 "Is that all?" hung as options off s_309. Both are
--       player lines whose parent screen the client does not identify.
--   (c) s_679 "I suggest you contact Rian Ry at the Kashyyyk space station" reused as the deflection
--       for a player the handler can see cannot fly.
--
-- FLAGGED INTERPRETATION -- s_420 CARRIES TWO ROLES. "%TU! It is imperative that you locate and
-- eliminate that weapons broker!  Let's start from the beginning and stay focused this time!" is his
-- only line about an outstanding dealer contract. Its first sentence is a nag at a player still
-- holding it; its second is a re-offer to a player who lost it. He ships nothing else for either, so
-- it is declared twice -- once with no options (active) and once with s_422/s_424 (failed).
--
-- FLAGGED INTERPRETATION -- THE FLIGHT GATE. Every accept point re-checks JTL / pilot / certified
-- ship and deflects to s_679 instead of granting. (The engine exposes no generic "player holds any
-- space mission" test: space_helpers.lua only offers isSpaceQuestActive / isSpaceQuestTaskActive /
-- isSpaceQuestComplete / isSpaceQuestTaskComplete for a NAMED quest, and MissionObject.idl:479 only
-- exposes isSpaceDutyMission().) The text is client fact; the trigger is not.
--
-- UNUSED SHIPPED KEYS, AND WHY:
--   s_307 -- empty in the client.
--   DUPLICATE REWARD BLOCKS. The client ships the starship-blaster reward three times, once per
--   faction variant, with identical text: s_219/s_221/s_223/s_225 and s_227/s_229/s_231/s_234 repeat
--   s_213/s_215/s_217 word for word. Only the first copy is used; the handler already knows the
--   player's faction, so the other two are redundant.
--   THE CIVILIAN-RESCUE ARC (s_615, s_619, s_621, s_625, s_628, s_632, s_636, s_639, s_642, s_645,
--   s_648 = the first meeting and the Tyyyn-nebula distress call; s_584 = its nag; s_588, s_591,
--   s_595, s_597, s_601 = its failure and retry; s_604, s_608, s_612 = its payoff). NOT built here on
--   purpose: rescue/ep3_kash_station_rescue_alpha and _bravo ALREADY have a giver --
--   screenplays/space/spacestations/spacestation_kashyyyk_conv_handler.lua (Rian Ry). Adding a second
--   giver was not asked for and would double-issue the quest.
--   THE TACTICAL-SITUATION DEBRIEF (s_505, s_509, s_513, s_517, s_523, s_527, s_531, s_535, s_540,
--   s_543, s_547, s_549, s_553, s_556, s_560, s_564, s_567, s_571, s_573, s_577, s_580). It grants no
--   quest -- both answers end at "I will give Rian Ry the security clearance to broker civilian
--   protection contracts to you", i.e. it unlocks Rian's escort_duty/destroy_duty contracts, which
--   already have their giver in the same station handler.
--   THE "GO SEE RIAN" IDLE (s_455 "Greetings, %TU.  Why don't you check in with Rian Ry.  She has
--   civilian protection contracts for you if you're interested.", s_458, s_461, s_463, s_466). Same
--   reason as the debrief above -- it points at Rian's contracts, which already have their giver. It
--   is also a duplicate role: s_679 already serves as this handler's "nothing for you right now"
--   screen and is reachable from the greeting.
--   THE RIAN RY BANTER (s_689, s_692, s_695, s_699, s_702, s_705, s_708, s_711, s_715, s_718, s_737,
--   s_741, s_745, s_749, s_752, s_754, s_756, s_758) and the passing-through exchange (s_760, s_762,
--   s_764, s_766, s_768). Pure flavour, and the client ships no unambiguous speaker order for it --
--   building a graph would mean guessing. Left out rather than invented.
--   THE SECOND STARSHIP-BOOSTER GIFT (s_352, s_354, s_358, s_360, s_362), a hand-out interleaved with
--   the imperial briefing in the key order. It is an item grant with no itemReward anywhere in the
--   screenplay to hang it on.
--
-- REACHABILITY: ep3_eyma is not spawned anywhere in this repo and there is no Kashyyyk ground zone in
-- config.lua ZonesEnabled. See the handler header.

ep3_eyma_convotemplate = ConvoTemplate:new {
	initialScreen = "ep3_eyma_greeting",
	templateType = "Lua",
	luaClassHandler = "Ep3EymaConvoHandler",
	screens = {}
}

-- ---------------------------------------------------------------------------------------------
-- First meeting. See FLAGGED INTERPRETATION (a) in the header.
-- ---------------------------------------------------------------------------------------------

ep3_eyma_greeting = ConvoScreen:new {
	id = "ep3_eyma_greeting",
	leftDialog = "@conversation/ep3_eyma:s_652", --Greetings kind spirit.  What can I do for you today?
	stopConversation = "false",
	options = {
		{"@conversation/ep3_eyma:s_654", "ep3_eyma_who"}, --Who are you?
		{"@conversation/ep3_eyma:s_721", "ep3_eyma_work"}, --I'm looking for work.
	}
}
ep3_eyma_convotemplate:addScreen(ep3_eyma_greeting);

ep3_eyma_who = ConvoScreen:new {
	id = "ep3_eyma_who",
	leftDialog = "@conversation/ep3_eyma:s_657", --I am Eyma, commander of the Civilian Protection guild.  We are a benevolent organization of merchants and freelance pilots that protect commerce in outlying areas such as this.  Have you heard of us?
	stopConversation = "false",
	options = {
		{"@conversation/ep3_eyma:s_660", "ep3_eyma_unknown"}, --This is the first I've heard of you.
		{"@conversation/ep3_eyma:s_670", "ep3_eyma_known"}, --Yes. I have heard of you.
	}
}
ep3_eyma_convotemplate:addScreen(ep3_eyma_who);

ep3_eyma_unknown = ConvoScreen:new {
	id = "ep3_eyma_unknown",
	leftDialog = "@conversation/ep3_eyma:s_663", --We're not very proficient at promoting this organization.  But that's acceptable.  We don't want too much attention at the moment.  The very notion of a 'protection' effort for freelance pilots would draw numerous criminal forces out of the murky depths... so to speak.
	stopConversation = "false",
	options = {
		{"@conversation/ep3_eyma:s_667", "ep3_eyma_see_rian"}, --What sort of work do you have to offer?
	}
}
ep3_eyma_convotemplate:addScreen(ep3_eyma_unknown);

ep3_eyma_known = ConvoScreen:new {
	id = "ep3_eyma_known",
	leftDialog = "@conversation/ep3_eyma:s_673", --Ah, from Rian Ry the commander of the Kashyyyk space station no doubt.  She is a fine commander is she not?  Very, very fine indeed.
	stopConversation = "false",
	options = {
		{"@conversation/ep3_eyma:s_676", "ep3_eyma_see_rian"}, --So do you have any jobs?
	}
}
ep3_eyma_convotemplate:addScreen(ep3_eyma_known);

-- Also the deflection screen for a player who cannot fly. See FLAGGED INTERPRETATION (c).
ep3_eyma_see_rian = ConvoScreen:new {
	id = "ep3_eyma_see_rian",
	leftDialog = "@conversation/ep3_eyma:s_679", --There are definitely some issues that need clarification and problems that require solutions.  I suggest you contact Rian Ry at the Kashyyyk space station and find out what's new.  She'll point you in the right direction!  She always does...
	stopConversation = "false",
	options = {
		{"@conversation/ep3_eyma:s_683", "ep3_eyma_farewell"}, --Thanks.
	}
}
ep3_eyma_convotemplate:addScreen(ep3_eyma_see_rian);

ep3_eyma_farewell = ConvoScreen:new {
	id = "ep3_eyma_farewell",
	leftDialog = "@conversation/ep3_eyma:s_686", --Goodbye!
	stopConversation = "true",
	options = {}
}
ep3_eyma_convotemplate:addScreen(ep3_eyma_farewell);

ep3_eyma_work = ConvoScreen:new {
	id = "ep3_eyma_work",
	leftDialog = "@conversation/ep3_eyma:s_724", --Right to the point then.  I appreciate that.  To tell the truth there are many issues facing the Civilian Protection guild that need immediate solutions.  To begin, I suggest you contact Rian Ry at the Kashyyyk space station and find out what's new.  She's a tremendous help.  Just tremendous...
	stopConversation = "false",
	options = {
		{"@conversation/ep3_eyma:s_729", "ep3_eyma_work_farewell"}, --Thanks!
	}
}
ep3_eyma_convotemplate:addScreen(ep3_eyma_work);

ep3_eyma_work_farewell = ConvoScreen:new {
	id = "ep3_eyma_work_farewell",
	leftDialog = "@conversation/ep3_eyma:s_733", --Farewell, friend!
	stopConversation = "true",
	options = {}
}
ep3_eyma_convotemplate:addScreen(ep3_eyma_work_farewell);

-- ---------------------------------------------------------------------------------------------
-- escort/ep3_kash_station_escort_ghrag -- the defecting Ghrag mercenary
-- ---------------------------------------------------------------------------------------------

ep3_eyma_escort_offer = ConvoScreen:new {
	id = "ep3_eyma_escort_offer",
	leftDialog = "@conversation/ep3_eyma:s_470", --Ah! %TU.  It is good to see you again!  Would you believe it... we have been contacted by a high-ranking Ghrag mercenary!  He wishes to escape the criminal life and join the monks on Tatooine.  Isn't that wonderful!
	stopConversation = "false",
	options = {
		{"@conversation/ep3_eyma:s_474", "ep3_eyma_escort_brief"}, --If you say so.
	}
}
ep3_eyma_convotemplate:addScreen(ep3_eyma_escort_offer);

ep3_eyma_escort_brief = ConvoScreen:new {
	id = "ep3_eyma_escort_brief",
	leftDialog = "@conversation/ep3_eyma:s_477", --Yes!  Now I want you to help him make his escape.  You'll need to escort his shuttle to the Kashyyyk space station and protect him from any Ghrag mercenaries that would attack him.  In exchange for this he will provide us with valuable tactical information.  Hopefully enough to eliminate them entirely...
	stopConversation = "false",
	options = {
		{"@conversation/ep3_eyma:s_481", "ep3_eyma_escort_ruse"}, --He'll be dead before he takes off.
		{"@conversation/ep3_eyma:s_497", "ep3_eyma_escort_accept_fast"}, --Sounds good to me. Let's go.
	}
}
ep3_eyma_convotemplate:addScreen(ep3_eyma_escort_brief);

ep3_eyma_escort_ruse = ConvoScreen:new {
	id = "ep3_eyma_escort_ruse",
	leftDialog = "@conversation/ep3_eyma:s_485", --He is constructing a ruse by which he leaves the station to secure several crates of Corellian brandy on order at the Kashyyyk space station.  It's something he does quite often so they might let him slip through unscathed.
	stopConversation = "false",
	options = {
		{"@conversation/ep3_eyma:s_489", "ep3_eyma_escort_accept"}, --Okay, then.
	}
}
ep3_eyma_convotemplate:addScreen(ep3_eyma_escort_ruse);

-- The grant of escort/ep3_kash_station_escort_ghrag happens in the handler on this id.
ep3_eyma_escort_accept = ConvoScreen:new {
	id = "ep3_eyma_escort_accept",
	leftDialog = "@conversation/ep3_eyma:s_493", --Good luck!
	stopConversation = "true",
	options = {}
}
ep3_eyma_convotemplate:addScreen(ep3_eyma_escort_accept);

-- Same grant, reached from s_497 instead of s_489.
ep3_eyma_escort_accept_fast = ConvoScreen:new {
	id = "ep3_eyma_escort_accept_fast",
	leftDialog = "@conversation/ep3_eyma:s_501", --Excellent!
	stopConversation = "true",
	options = {}
}
ep3_eyma_convotemplate:addScreen(ep3_eyma_escort_accept_fast);

ep3_eyma_escort_active = ConvoScreen:new {
	id = "ep3_eyma_escort_active",
	leftDialog = "@conversation/ep3_eyma:s_725", --What are you still doing here?  The Ghrag mercenary wants to flee his evil clan as soon as possible!
	stopConversation = "true",
	options = {}
}
ep3_eyma_convotemplate:addScreen(ep3_eyma_escort_active);

ep3_eyma_escort_failed = ConvoScreen:new {
	id = "ep3_eyma_escort_failed",
	leftDialog = "@conversation/ep3_eyma:s_275", --So, Rian Ry informs me that the Ghrag mercenary we wanted to convey out of this system has been lost.  This is a tremendous loss... but we may be able to salvage the situation.  Are you available to deal with this problem immediately?
	stopConversation = "false",
	options = {
		{"@conversation/ep3_eyma:s_278", "ep3_eyma_escort_retry_brief"}, --Yes. I want to try again.
		{"@conversation/ep3_eyma:s_289", "ep3_eyma_escort_later"}, --Not at this time.
	}
}
ep3_eyma_convotemplate:addScreen(ep3_eyma_escort_failed);

ep3_eyma_escort_retry_brief = ConvoScreen:new {
	id = "ep3_eyma_escort_retry_brief",
	leftDialog = "@conversation/ep3_eyma:s_280", --Evidently, the Ghrag traitor that we lost had a friend with whom he consulted about his flight to safety.  Now that he has been destroyed, his friend is convinced that he is next on the Ghrag's hit-list.  Will you escort him out of Kashyyyk space?
	stopConversation = "false",
	options = {
		{"@conversation/ep3_eyma:s_283", "ep3_eyma_escort_retry"}, --Yes. I will.
	}
}
ep3_eyma_convotemplate:addScreen(ep3_eyma_escort_retry_brief);

-- The re-grant of escort/ep3_kash_station_escort_ghrag happens in the handler on this id.
ep3_eyma_escort_retry = ConvoScreen:new {
	id = "ep3_eyma_escort_retry",
	leftDialog = "@conversation/ep3_eyma:s_286", --Splendid.  Better luck this time, %TU.
	stopConversation = "true",
	options = {}
}
ep3_eyma_convotemplate:addScreen(ep3_eyma_escort_retry);

ep3_eyma_escort_later = ConvoScreen:new {
	id = "ep3_eyma_escort_later",
	leftDialog = "@conversation/ep3_eyma:s_292", --Then please come back when you are.
	stopConversation = "true",
	options = {}
}
ep3_eyma_convotemplate:addScreen(ep3_eyma_escort_later);

-- ---------------------------------------------------------------------------------------------
-- The hand-off from the escort into the weapons-dealer contract.
--
-- s_349's target is declared as the NEUTRAL offer because a screen option can name only one
-- destination. The handler re-routes an Imperial or Rebel player off that id to their own briefing
-- before it is shown. Same mechanism as the flight gate; see the handler.
-- ---------------------------------------------------------------------------------------------

ep3_eyma_escort_done = ConvoScreen:new {
	id = "ep3_eyma_escort_done",
	leftDialog = "@conversation/ep3_eyma:s_347", --Well hello there, %TU!  I have some tremendously good news.  The ex-mercenary that you escorted out of Kashyyyk space has provided us with detailed tactical information about the Ghrag mercenary clan.
	stopConversation = "false",
	options = {
		{"@conversation/ep3_eyma:s_349", "ep3_eyma_neutral_offer"}, --What sort of information?
	}
}
ep3_eyma_convotemplate:addScreen(ep3_eyma_escort_done);

-- ---------------------------------------------------------------------------------------------
-- assassinate/ep3_kash_station_assassinate_imperial -- Vosc Traaer of Naboo
-- ---------------------------------------------------------------------------------------------

ep3_eyma_imperial_offer = ConvoScreen:new {
	id = "ep3_eyma_imperial_offer",
	leftDialog = "@conversation/ep3_eyma:s_297", --The Ghrag are trying to secure a battery of heavy weapons... station-killers, if you will.  It would appear that they have plans to destroy the Imperial Space station in Kashyyyk space.
	stopConversation = "false",
	options = {
		{"@conversation/ep3_eyma:s_353", "ep3_eyma_imperial_why"}, --Why would they do that?
	}
}
ep3_eyma_convotemplate:addScreen(ep3_eyma_imperial_offer);

ep3_eyma_imperial_why = ConvoScreen:new {
	id = "ep3_eyma_imperial_why",
	leftDialog = "@conversation/ep3_eyma:s_355", --They have been doing extensive research on you, my friend.  They know that you are an Imperial pilot.  They believe that the Empire has commanded you to disrupt their activities as part of an ongoing mission.  Now they want revenge.
	stopConversation = "false",
	options = {
		{"@conversation/ep3_eyma:s_357", "ep3_eyma_imperial_dealer"}, --So what do we do?
	}
}
ep3_eyma_convotemplate:addScreen(ep3_eyma_imperial_why);

ep3_eyma_imperial_dealer = ConvoScreen:new {
	id = "ep3_eyma_imperial_dealer",
	leftDialog = "@conversation/ep3_eyma:s_359", --We must prevent the Ghrag from acquiring these weapons.  They have made contact with a weapons dealer named Vosc Traaer from Naboo.  You may have heard of him.  He was a supplier for the Empire until he was discovered to be an embezzeler.
	stopConversation = "false",
	options = {
		{"@conversation/ep3_eyma:s_361", "ep3_eyma_imperial_plan"}, --How do we stop them?
	}
}
ep3_eyma_convotemplate:addScreen(ep3_eyma_imperial_dealer);

ep3_eyma_imperial_plan = ConvoScreen:new {
	id = "ep3_eyma_imperial_plan",
	leftDialog = "@conversation/ep3_eyma:s_363", --According to our friend the ex-Ghrag... Vosc Traaer will be escorted through this system sometime today.  I suggest you intercept his starship and destroy it.  Then the mercenaries will need to find some other way to ruin the Kashyyyk system.  What do you say?
	stopConversation = "false",
	options = {
		{"@conversation/ep3_eyma:s_365", "ep3_eyma_imperial_accept"}, --I'm ready!
	}
}
ep3_eyma_convotemplate:addScreen(ep3_eyma_imperial_plan);

-- The grant of assassinate/ep3_kash_station_assassinate_imperial happens in the handler on this id.
ep3_eyma_imperial_accept = ConvoScreen:new {
	id = "ep3_eyma_imperial_accept",
	leftDialog = "@conversation/ep3_eyma:s_367", --Excellent!  Good luck to you, %TU!
	stopConversation = "true",
	options = {}
}
ep3_eyma_convotemplate:addScreen(ep3_eyma_imperial_accept);

-- ---------------------------------------------------------------------------------------------
-- assassinate/ep3_kash_station_assassinate_rebel -- Faydo Sha of Corellia
--
-- The client ships THREE complete runs of this briefing off one opener, differing only in how coy
-- the player is about the Rebel outpost (s_371 straight / s_387 "Rebel outpost?" / s_403 "No
-- really... what Rebel outpost?"). All three end on the same grant. All three are shipped text, so
-- all three are built.
-- ---------------------------------------------------------------------------------------------

ep3_eyma_rebel_offer = ConvoScreen:new {
	id = "ep3_eyma_rebel_offer",
	leftDialog = "@conversation/ep3_eyma:s_369", --The Ghrag are trying to secure a battery of heavy weapons... station-killers, if you will.  It would appear that they have plans to destroy a Rebel Outpost somewhere here in Kashyyyk.  Do you know of this place?
	stopConversation = "false",
	options = {
		{"@conversation/ep3_eyma:s_371", "ep3_eyma_rebel_why"}, --Why would they do that?
		{"@conversation/ep3_eyma:s_387", "ep3_eyma_rebel_coy"}, --Rebel outpost?
		{"@conversation/ep3_eyma:s_403", "ep3_eyma_rebel_denial"}, --No really... what Rebel outpost?
	}
}
ep3_eyma_convotemplate:addScreen(ep3_eyma_rebel_offer);

ep3_eyma_rebel_why = ConvoScreen:new {
	id = "ep3_eyma_rebel_why",
	leftDialog = "@conversation/ep3_eyma:s_373", --They have been doing extensive research on you, my friend.  They know that you are a Rebel pilot.  They believe you are acting on behalf of the Alliance to disrupt their activities.  Now they want revenge.
	stopConversation = "false",
	options = {
		{"@conversation/ep3_eyma:s_375", "ep3_eyma_rebel_dealer"}, --So what do we do?
	}
}
ep3_eyma_convotemplate:addScreen(ep3_eyma_rebel_why);

ep3_eyma_rebel_dealer = ConvoScreen:new {
	id = "ep3_eyma_rebel_dealer",
	leftDialog = "@conversation/ep3_eyma:s_377", --We must prevent the Ghrag from acquiring these weapons.  They have made contact with a weapons dealer named Faydo Sha from Corellia.  You may have heard of him.  He was a supplier for the Rebellion until they discovered him to be a prolific slave-trader.
	stopConversation = "false",
	options = {
		{"@conversation/ep3_eyma:s_379", "ep3_eyma_rebel_plan"}, --How do we stop them?
	}
}
ep3_eyma_convotemplate:addScreen(ep3_eyma_rebel_dealer);

ep3_eyma_rebel_plan = ConvoScreen:new {
	id = "ep3_eyma_rebel_plan",
	leftDialog = "@conversation/ep3_eyma:s_381", --According to our friend the ex-Ghrag... Faydo Sha will be escorted through this system sometime today.  I suggest you intercept his starship and destroy it.  Then the mercenaries will need to find some other way to ruin the Kashyyyk system.  What do you say?
	stopConversation = "false",
	options = {
		{"@conversation/ep3_eyma:s_383", "ep3_eyma_rebel_accept"}, --I'm ready!
	}
}
ep3_eyma_convotemplate:addScreen(ep3_eyma_rebel_plan);

-- The grant of assassinate/ep3_kash_station_assassinate_rebel happens in the handler on this id.
ep3_eyma_rebel_accept = ConvoScreen:new {
	id = "ep3_eyma_rebel_accept",
	leftDialog = "@conversation/ep3_eyma:s_385", --Excellent!  Good luck to you, %TU!
	stopConversation = "true",
	options = {}
}
ep3_eyma_convotemplate:addScreen(ep3_eyma_rebel_accept);

ep3_eyma_rebel_coy = ConvoScreen:new {
	id = "ep3_eyma_rebel_coy",
	leftDialog = "@conversation/ep3_eyma:s_389", --Heh.  Your secret is safe with me, %TU.  They have been doing extensive research on you, my friend.  They know that you are a Rebel pilot.  They believe you are acting on behalf of the Alliance to disrupt their activities.  Now they want revenge.
	stopConversation = "false",
	options = {
		{"@conversation/ep3_eyma:s_391", "ep3_eyma_rebel_coy_dealer"}, --So what do we do?
	}
}
ep3_eyma_convotemplate:addScreen(ep3_eyma_rebel_coy);

ep3_eyma_rebel_coy_dealer = ConvoScreen:new {
	id = "ep3_eyma_rebel_coy_dealer",
	leftDialog = "@conversation/ep3_eyma:s_393", --We must prevent the Ghrag from acquiring these weapons.  They have made contact with a weapons dealer named Faydo Sha from Corellia.  You may have heard of him.  He was a supplier for the Alliance until they discovered him to be a prolific slave-trader.
	stopConversation = "false",
	options = {
		{"@conversation/ep3_eyma:s_395", "ep3_eyma_rebel_coy_plan"}, --How do we stop them?
	}
}
ep3_eyma_convotemplate:addScreen(ep3_eyma_rebel_coy_dealer);

ep3_eyma_rebel_coy_plan = ConvoScreen:new {
	id = "ep3_eyma_rebel_coy_plan",
	leftDialog = "@conversation/ep3_eyma:s_397", --According to our friend the ex-Ghrag... Faydo Sha will be escorted through this system sometime today.  I suggest you intercept his starship and destroy it.  Then the mercenaries will need to find some other way to ruin the Kashyyyk system.  What do you say?
	stopConversation = "false",
	options = {
		{"@conversation/ep3_eyma:s_399", "ep3_eyma_rebel_coy_accept"}, --I'm ready!
	}
}
ep3_eyma_convotemplate:addScreen(ep3_eyma_rebel_coy_plan);

-- Same grant as ep3_eyma_rebel_accept.
ep3_eyma_rebel_coy_accept = ConvoScreen:new {
	id = "ep3_eyma_rebel_coy_accept",
	leftDialog = "@conversation/ep3_eyma:s_401", --Excellent!  Good luck to you, %TU!
	stopConversation = "true",
	options = {}
}
ep3_eyma_convotemplate:addScreen(ep3_eyma_rebel_coy_accept);

ep3_eyma_rebel_denial = ConvoScreen:new {
	id = "ep3_eyma_rebel_denial",
	leftDialog = "@conversation/ep3_eyma:s_405", --You honestly don't know?  Apparently there is a hidden Rebel outpost here.  The Alliance has put forth a massive effort to protect the Wookiees.  In turn, they recruit the Wookiees for the Rebellion.  The Ghrag know that you are a Rebel pilot.  They want to exact revenge from the Alliance for what you've done to them.
	stopConversation = "false",
	options = {
		{"@conversation/ep3_eyma:s_407", "ep3_eyma_rebel_denial_dealer"}, --So what do we do?
	}
}
ep3_eyma_convotemplate:addScreen(ep3_eyma_rebel_denial);

ep3_eyma_rebel_denial_dealer = ConvoScreen:new {
	id = "ep3_eyma_rebel_denial_dealer",
	leftDialog = "@conversation/ep3_eyma:s_409", --We must prevent the Ghrag from acquiring these weapons.  They have made contact with a weapons dealer named Faydo Sha from Corellia.  You may have heard of him.  He was a supplier for the Alliance until they discovered him to be a prolific slave-trader.
	stopConversation = "false",
	options = {
		{"@conversation/ep3_eyma:s_411", "ep3_eyma_rebel_denial_plan"}, --How do we stop them?
	}
}
ep3_eyma_convotemplate:addScreen(ep3_eyma_rebel_denial_dealer);

ep3_eyma_rebel_denial_plan = ConvoScreen:new {
	id = "ep3_eyma_rebel_denial_plan",
	leftDialog = "@conversation/ep3_eyma:s_413", --According to our friend the ex-Ghrag... Faydo Sha will be escorted through this system sometime today.  I suggest you intercept his starship and destroy it.  Then the mercenaries will need to find some other way to ruin the Kashyyyk system.  What do you say?
	stopConversation = "false",
	options = {
		{"@conversation/ep3_eyma:s_415", "ep3_eyma_rebel_denial_accept"}, --I'm ready!
	}
}
ep3_eyma_convotemplate:addScreen(ep3_eyma_rebel_denial_plan);

-- Same grant as ep3_eyma_rebel_accept.
ep3_eyma_rebel_denial_accept = ConvoScreen:new {
	id = "ep3_eyma_rebel_denial_accept",
	leftDialog = "@conversation/ep3_eyma:s_417", --Excellent!  Good luck to you, %TU!
	stopConversation = "true",
	options = {}
}
ep3_eyma_convotemplate:addScreen(ep3_eyma_rebel_denial_accept);

-- ---------------------------------------------------------------------------------------------
-- assassinate/ep3_kash_station_assassinate_neutral -- Kred'ka Sul
-- ---------------------------------------------------------------------------------------------

ep3_eyma_neutral_offer = ConvoScreen:new {
	id = "ep3_eyma_neutral_offer",
	leftDialog = "@conversation/ep3_eyma:s_419", --The Ghrag are now trying to secure a battery of heavy weapons... station-killers, if you will... for the purpose of destroying the Kashyyyk space station.
	stopConversation = "false",
	options = {
		{"@conversation/ep3_eyma:s_421", "ep3_eyma_neutral_why"}, --Why would they do that?
		{"@conversation/ep3_eyma:s_433", "ep3_eyma_neutral_rian"}, --I've mostly been talking to Rian.
	}
}
ep3_eyma_convotemplate:addScreen(ep3_eyma_neutral_offer);

ep3_eyma_neutral_why = ConvoScreen:new {
	id = "ep3_eyma_neutral_why",
	leftDialog = "@conversation/ep3_eyma:s_423", --They have spies everywhere in Kashyyyk.  They know that you have been talking to Rian Ry and myself and that your friendship with the Civilian Protection guild is very strong.
	stopConversation = "false",
	options = {
		{"@conversation/ep3_eyma:s_425", "ep3_eyma_neutral_plan"}, --So what do we do?
	}
}
ep3_eyma_convotemplate:addScreen(ep3_eyma_neutral_why);

ep3_eyma_neutral_plan = ConvoScreen:new {
	id = "ep3_eyma_neutral_plan",
	leftDialog = "@conversation/ep3_eyma:s_427", --We must prevent the Ghrag from obtaining these weapons.  They have made contact with a weapons dealer named Kred'ka Sul.  He'll be flying in to Kashyyyk space sometime today.  You need to intercept him and prevent him from selling his wares to the Ghrag.
	stopConversation = "false",
	options = {
		{"@conversation/ep3_eyma:s_429", "ep3_eyma_neutral_accept"}, --I'm ready!
	}
}
ep3_eyma_convotemplate:addScreen(ep3_eyma_neutral_plan);

-- The grant of assassinate/ep3_kash_station_assassinate_neutral happens in the handler on this id.
ep3_eyma_neutral_accept = ConvoScreen:new {
	id = "ep3_eyma_neutral_accept",
	leftDialog = "@conversation/ep3_eyma:s_431", --Excellent!  Good luck to you, %TU!
	stopConversation = "true",
	options = {}
}
ep3_eyma_convotemplate:addScreen(ep3_eyma_neutral_accept);

ep3_eyma_neutral_rian = ConvoScreen:new {
	id = "ep3_eyma_neutral_rian",
	leftDialog = "@conversation/ep3_eyma:s_435", --Be that as it may... they're going to blow up the station and we need to stop it!
	stopConversation = "false",
	options = {
		{"@conversation/ep3_eyma:s_439", "ep3_eyma_neutral_rian_plan"}, --So what do we do?
	}
}
ep3_eyma_convotemplate:addScreen(ep3_eyma_neutral_rian);

ep3_eyma_neutral_rian_plan = ConvoScreen:new {
	id = "ep3_eyma_neutral_rian_plan",
	leftDialog = "@conversation/ep3_eyma:s_443", --We must prevent the Ghrag from obtaining these weapons.  They have made contact with a weapons dealer named Kred'ka Sul.  He'll be flying in to Kashyyyk space sometime today.  You need to intercept him and prevent him from selling his wares to the Ghrag.
	stopConversation = "false",
	options = {
		{"@conversation/ep3_eyma:s_447", "ep3_eyma_neutral_rian_accept"}, --I'm ready!
	}
}
ep3_eyma_convotemplate:addScreen(ep3_eyma_neutral_rian_plan);

-- Same grant as ep3_eyma_neutral_accept.
ep3_eyma_neutral_rian_accept = ConvoScreen:new {
	id = "ep3_eyma_neutral_rian_accept",
	leftDialog = "@conversation/ep3_eyma:s_451", --Excellent!  Good luck to you, %TU!
	stopConversation = "true",
	options = {}
}
ep3_eyma_convotemplate:addScreen(ep3_eyma_neutral_rian_accept);

-- ---------------------------------------------------------------------------------------------
-- The dealer contract in flight, and lost. Both are s_420. See the FLAGGED INTERPRETATION.
-- ---------------------------------------------------------------------------------------------

ep3_eyma_dealer_active = ConvoScreen:new {
	id = "ep3_eyma_dealer_active",
	leftDialog = "@conversation/ep3_eyma:s_420", --%TU! It is imperative that you locate and eliminate that weapons broker!  Let's start from the beginning and stay focused this time!
	stopConversation = "true",
	options = {}
}
ep3_eyma_convotemplate:addScreen(ep3_eyma_dealer_active);

-- s_422's target is the neutral offer for the same reason s_349's is; the handler re-routes.
ep3_eyma_dealer_failed = ConvoScreen:new {
	id = "ep3_eyma_dealer_failed",
	leftDialog = "@conversation/ep3_eyma:s_420", --%TU! It is imperative that you locate and eliminate that weapons broker!  Let's start from the beginning and stay focused this time!
	stopConversation = "false",
	options = {
		{"@conversation/ep3_eyma:s_422", "ep3_eyma_neutral_offer"}, --Yes. Let's go again.
		{"@conversation/ep3_eyma:s_424", "ep3_eyma_dealer_refused"}, --Not right now.
	}
}
ep3_eyma_convotemplate:addScreen(ep3_eyma_dealer_failed);

ep3_eyma_dealer_refused = ConvoScreen:new {
	id = "ep3_eyma_dealer_refused",
	leftDialog = "@conversation/ep3_eyma:s_426", --Not right now?  What are you thinking?!
	stopConversation = "true",
	options = {}
}
ep3_eyma_convotemplate:addScreen(ep3_eyma_dealer_refused);

-- ---------------------------------------------------------------------------------------------
-- The dealer is down. This is the end of everything Eyma gives.
--
-- s_211 and s_252 are hung here -- see FLAGGED INTERPRETATION (b). s_311's target is declared as the
-- neutral branch for the same reason s_349's is; the handler re-routes by faction.
-- ---------------------------------------------------------------------------------------------

ep3_eyma_dealer_done = ConvoScreen:new {
	id = "ep3_eyma_dealer_done",
	leftDialog = "@conversation/ep3_eyma:s_309", --Good to see you again, %TU!  It's been quite an interesting time, has it not?
	stopConversation = "false",
	options = {
		{"@conversation/ep3_eyma:s_311", "ep3_eyma_more_neutral"}, --Is there anything else you need me to do?
		{"@conversation/ep3_eyma:s_211", "ep3_eyma_reward"}, --Got anything for me?
		{"@conversation/ep3_eyma:s_252", "ep3_eyma_veteran"}, --Is that all?
	}
}
ep3_eyma_convotemplate:addScreen(ep3_eyma_dealer_done);

-- Talk only. The screenplay carries no itemReward for any of the three assassinates, so there is no
-- prototype to hand over. Whether one should exist is an open item for whoever sets itemReward.
ep3_eyma_reward = ConvoScreen:new {
	id = "ep3_eyma_reward",
	leftDialog = "@conversation/ep3_eyma:s_213", --Now that you mention it... yes!  Apparently the Ghrag were also planning to buy a starship blaster prototype from the weapons dealer you disintegrated.  Perhaps you would like to have it?
	stopConversation = "false",
	options = {
		{"@conversation/ep3_eyma:s_215", "ep3_eyma_reward_farewell"}, --Thanks!
	}
}
ep3_eyma_convotemplate:addScreen(ep3_eyma_reward);

ep3_eyma_reward_farewell = ConvoScreen:new {
	id = "ep3_eyma_reward_farewell",
	leftDialog = "@conversation/ep3_eyma:s_217", --Farewell, %TU.
	stopConversation = "true",
	options = {}
}
ep3_eyma_convotemplate:addScreen(ep3_eyma_reward_farewell);

-- The CPG Veteran this points at is already built:
-- screenplays/space/conversations/neutral/cpg_patrol/ep3CpgVeteranConvoHandler.lua.
ep3_eyma_veteran = ConvoScreen:new {
	id = "ep3_eyma_veteran",
	leftDialog = "@conversation/ep3_eyma:s_254", --Now that you ask, you may be interested in speaking with a CPG Veteran that patrols the Kashyyyk space station.  There is talk of tracking down remaining Ghrag mercenaries by slicing their communication system.
	stopConversation = "false",
	options = {
		{"@conversation/ep3_eyma:s_256", "ep3_eyma_veteran_where"}, --Where do I find this veteran?
	}
}
ep3_eyma_convotemplate:addScreen(ep3_eyma_veteran);

ep3_eyma_veteran_where = ConvoScreen:new {
	id = "ep3_eyma_veteran_where",
	leftDialog = "@conversation/ep3_eyma:s_258", --Rian likes to keep at least one heavy fighter orbiting her space station at all times.  Most CPG Veterans favor the YT-1300-style chassis, so look for one of those flying a patrol pattern around the station.
	stopConversation = "false",
	options = {
		{"@conversation/ep3_eyma:s_260", "ep3_eyma_veteran_farewell"}, --Thanks!
	}
}
ep3_eyma_convotemplate:addScreen(ep3_eyma_veteran_where);

ep3_eyma_veteran_farewell = ConvoScreen:new {
	id = "ep3_eyma_veteran_farewell",
	leftDialog = "@conversation/ep3_eyma:s_262", --Take care and good luck!
	stopConversation = "true",
	options = {}
}
ep3_eyma_convotemplate:addScreen(ep3_eyma_veteran_farewell);

ep3_eyma_more_rebel = ConvoScreen:new {
	id = "ep3_eyma_more_rebel",
	leftDialog = "@conversation/ep3_eyma:s_313", --I have been contacted by your superiors at the Rebel outpost.  Do you know what I mean?  They have heard of your exploits and would like to offer more missions.
	stopConversation = "false",
	options = {
		{"@conversation/ep3_eyma:s_315", "ep3_eyma_more_rebel_coy"}, --I don't know what you mean.
		{"@conversation/ep3_eyma:s_321", "ep3_eyma_signoff"}, --Farewell.
	}
}
ep3_eyma_convotemplate:addScreen(ep3_eyma_more_rebel);

ep3_eyma_more_rebel_coy = ConvoScreen:new {
	id = "ep3_eyma_more_rebel_coy",
	leftDialog = "@conversation/ep3_eyma:s_317", --Of course you don't.
	stopConversation = "true",
	options = {}
}
ep3_eyma_convotemplate:addScreen(ep3_eyma_more_rebel_coy);

ep3_eyma_more_imperial = ConvoScreen:new {
	id = "ep3_eyma_more_imperial",
	leftDialog = "@conversation/ep3_eyma:s_319", --The commander of the Imperial space station has requested your presence.  I'm not exactly sure how they knew you were helping out the CPG... but it seems they are quite impressed with your abilities.  Due to saving their space station from Ghrag mercenaries, no doubt!
	stopConversation = "false",
	options = {
		{"@conversation/ep3_eyma:s_321", "ep3_eyma_signoff"}, --Farewell.
	}
}
ep3_eyma_convotemplate:addScreen(ep3_eyma_more_imperial);

ep3_eyma_signoff = ConvoScreen:new {
	id = "ep3_eyma_signoff",
	leftDialog = "@conversation/ep3_eyma:s_323", --And you the same, %TU.
	stopConversation = "true",
	options = {}
}
ep3_eyma_convotemplate:addScreen(ep3_eyma_signoff);

-- The contract he points at here is Rian Ry's destroy_duty_ep3_kash_station_destroy_duty_neutral,
-- which already has its giver in spacestation_kashyyyk_conv_handler.lua. Nothing is granted here.
ep3_eyma_more_neutral = ConvoScreen:new {
	id = "ep3_eyma_more_neutral",
	leftDialog = "@conversation/ep3_eyma:s_325", --Not at the moment.  I have authorized Rian Ry to provide you with another sort of contract.  Something that the CPG reserves only for its most trusted pilots.  You should talk to her about it!
	stopConversation = "false",
	options = {
		{"@conversation/ep3_eyma:s_327", "ep3_eyma_neutral_signoff"}, --Sounds good.
		{"@conversation/ep3_eyma:s_331", "ep3_eyma_contract"}, --What sort of contract?
	}
}
ep3_eyma_convotemplate:addScreen(ep3_eyma_more_neutral);

ep3_eyma_neutral_signoff = ConvoScreen:new {
	id = "ep3_eyma_neutral_signoff",
	leftDialog = "@conversation/ep3_eyma:s_329", --Farewell %TU!
	stopConversation = "true",
	options = {}
}
ep3_eyma_convotemplate:addScreen(ep3_eyma_neutral_signoff);

ep3_eyma_contract = ConvoScreen:new {
	id = "ep3_eyma_contract",
	leftDialog = "@conversation/ep3_eyma:s_333", --Well, the Ghrag are bereft of leadership and have lost their focus... thanks to you!  However, there are still many independent mercenaries of the Ghrag clan lurking in the Kashyyyk system.  We would like for you to eliminate them as you see fit.
	stopConversation = "false",
	options = {
		{"@conversation/ep3_eyma:s_335", "ep3_eyma_contract_yes"}, --I like that.
		{"@conversation/ep3_eyma:s_339", "ep3_eyma_contract_no"}, --I'm not interested.
	}
}
ep3_eyma_convotemplate:addScreen(ep3_eyma_contract);

ep3_eyma_contract_yes = ConvoScreen:new {
	id = "ep3_eyma_contract_yes",
	leftDialog = "@conversation/ep3_eyma:s_337", --Capital!  Please speak with Rian at the space station and she will make sure the paperwork is in order.
	stopConversation = "true",
	options = {}
}
ep3_eyma_convotemplate:addScreen(ep3_eyma_contract_yes);

ep3_eyma_contract_no = ConvoScreen:new {
	id = "ep3_eyma_contract_no",
	leftDialog = "@conversation/ep3_eyma:s_341", --Oh!  My apologies then, %TU.  You don't have to take any of these contracts.  If you prefer, Rian Ry is still authorized to give you protection duties.  You're quite good at protecting the civilian interests here in Kashyyyk.
	stopConversation = "false",
	options = {
		{"@conversation/ep3_eyma:s_343", "ep3_eyma_contract_bye"}, --Thank you.
	}
}
ep3_eyma_convotemplate:addScreen(ep3_eyma_contract_no);

ep3_eyma_contract_bye = ConvoScreen:new {
	id = "ep3_eyma_contract_bye",
	leftDialog = "@conversation/ep3_eyma:s_345", --Good bye, %TU!
	stopConversation = "true",
	options = {}
}
ep3_eyma_convotemplate:addScreen(ep3_eyma_contract_bye);

addConversationTemplate("ep3_eyma_convotemplate", ep3_eyma_convotemplate);
