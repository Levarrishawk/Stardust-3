-- Captain Koh -- Corellian Engineering's mining taskmaster on Kashyyyk.
--
-- Giver for the four Kashyyyk mining quest heads that had no giver:
--
--   space_mining_destroy/kashyyyk_mining_quest_5   (KashyyykMiningScreenplay.lua global line 31,
--                                                   registered line 65)
--   space_mining_destroy/kashyyyk_mining_quest_8   (global line 76, registered line 109)
--   convoy/kashyyyk_mining_quest_11                (global line 118, registered line 173)
--   assassinate/kashyyyk_mining_quest_12           (global line 181, registered line 222)
--
-- Before this file nothing in the repo gave any of the four out. quest_11 was referenced only inside
-- a comment in SpaceConvoyScreenplay.lua, which starts nothing.
--
-- EVERY leftDialog and EVERY option below is a verbatim shipped key from
-- conversation/ep3_mining_captain_koh.stf (136 entries). Nothing is authored.
--
-- Each pitch matches its screenplay field for field:
--   s_260 / s_221 "Head to Kashyyyk space and get me some samples of the organometallic asteroids up
--   there. You can keep what you mine, I just need a little." == quest_5, resourceType
--   "organometallic", unitsRequired 500, questZone space_kashyyyk, attackShips {} (the .stf names no
--   attacker for it either).
--   s_113 "We're in need of a broad resource sample of several systems---Kashyyyk, which you should be
--   familiar with already, Endor, and Dathomir... procure a 125 unit sample from each" == quest_8,
--   unitsRequired 125, and it is the quest whose own title is "Broad Sample Part I". The Endor and
--   Dathomir legs were never shipped in this string tree (see the GAP note on the screenplay), so
--   this conversation ends the sampling arc at the Kashyyyk leg, exactly as the code does.
--   s_143 "There is a convoy of Y-8 mining vessels coming through the Kashyyyk system later today...
--   their path leads them through dangerous waters" and s_145 "Meet them at the designated rendezvous
--   point in the Kashyyyk system, and see to it that every ship in that convoy makes it to the
--   hyperspace point" == quest_11, convoyPoints kash_mining_11_convoy_1..5 ending at the hyperspace
--   beacon, attackShips gotal_bandit_* (STF quest_escort_d: "Be wary of attacking Gotal bandits").
--   s_163 "Their flagship, 'The Gilded Wookiee', will be starting on that route any minute. They
--   probably have a heavy fighter escort, despite the path you cleared" == quest_12, whose own
--   title_d says it uses "the path you cleared previously for the mining convoy" -- which is why the
--   screenplay's targetPatrols re-use the quest_11 corridor, and why this conversation does not offer
--   quest_12 until quest_11 is complete.
--
-- FLAGGED INTERPRETATION -- SCREEN TOPOLOGY. The client ships no screen graph. The blocks below are
-- read off the .stf's own key order and its yes/no pairings; the order in which the handler selects
-- between blocks is ours.
--
-- FLAGGED INTERPRETATION -- s_270 AS THE FLIGHT GATE. s_270 "I don't have time for you! Be gone!" is
-- Koh's shipped dismissal. It is used here at every accept point for a player the handler can see is
-- unable to fly the mission: JTL off, not a pilot, or no certified ship. (The engine exposes no
-- generic "player holds any space mission" test: space_helpers.lua only offers isSpaceQuestActive /
-- isSpaceQuestTaskActive / isSpaceQuestComplete / isSpaceQuestTaskComplete for a NAMED quest, and
-- MissionObject.idl:479 only exposes isSpaceDutyMission().) The text is client fact; that trigger is
-- not.
--
-- FLAGGED INTERPRETATION -- WHICH FAILURE LINE GOES WITH WHICH LEG. The .stf ships seven Koh failure
-- openers and seven player retry options but pairs none of them. Three pair themselves by content and
-- are used that way: s_233 "You couldn't even escort a few of our mining vessels out of the system"
-- with s_244/s_245 "Maybe I could catch up and try to help them?" (quest_11); s_234 with s_246/s_247
-- "Find that ship and blow it away. NOW!" (quest_12); s_232/s_242/s_243 as the general "something
-- went wrong" pair (quest_5); s_229/s_238/s_239 for quest_8. The remaining failure lines name legs
-- that are not built and are listed as unused below.
--
-- FLAGGED INTERPRETATION -- FAILURE DETECTION, all four legs. SpaceMiningDestroyScreenplay,
-- SpaceConvoyScreenplay and SpaceAssassinateScreenplay leave no distinguishable failure record the
-- conversation can read, so this handler cannot separate "failed it" from "walked away": it shows a
-- leg's failure block to anyone who once accepted that leg and no longer has it active or complete.
--
-- FLAGGED INTERPRETATION -- NO SECOND PAYOUT. s_190 promises "a larger cargo hold for that fighter",
-- s_122 a "Mark II" mining laser, s_147 and s_173 cash bonuses. Every one of those four screenplays
-- already pays its own creditReward on completion and every one carries itemReward = {}. Nothing here
-- hands out a second reward; these screens are debriefs only. The text is client fact; whether the
-- promised items should exist is an open item for whoever sets itemReward.
--
-- THE LOK AND CORELLIA LEGS ARE NOT BUILT HERE, DELIBERATELY. Koh's shipped chain runs
-- Kashyyyk samples -> a revenge raid on Lok's mining fields -> the Y-8 convoy -> the Gilded Wookiee ->
-- siphoning a stranded freighter at Corellia -> the broad sample -> diamond cores at Kessel -> a Y-8
-- deed. The Lok and Corellia legs were never shipped as quests at all, so they stay out and their keys
-- stay listed as unused below.
--
-- THE KESSEL LEG IS NOW BUILT HERE (added after the original four; it was left for a later pass then,
-- and this is that pass). It is shipped and registered as
-- space_mining_destroy/kessel_mining_quest_13 -- KesselDutyScreenplay.lua global line 178, registered
-- line 215 -- and nothing in the repo handed it out. It is not a Kashyyyk quest, but Koh is the only
-- NPC the client gives it to, and it matches the screenplay field for field:
--   s_195 "A rare cluster of asteroids has been discovered in the highly dangerous Kessel system",
--   s_197 "Diamonds, pilot.  They have diamond cores.", s_199 "Ever been to Kessel?  Well, if you
--   haven't, you're going now.  Head out and sample those diamond cores before anyone else can get a
--   hold of them.  You will almost certainly be attacked by pirates while mining those rocks."
--   == questZone space_light1 (STF quest_location_t "Kessel System"), resourceType "space_diamond"
--   and unitsRequired 500 (STF title "Kessel System:  Space Diamonds", title_d "Mine 500 units of
--   precious space diamonds from the Kessel system.  Watch out for pirates!"), and the blacksun
--   attackShips for "you will almost certainly be attacked by pirates".
-- The Y-8 deed finale (s_205-s_209) closes Koh's arc and is wired as the tail of the same leg, which
-- is where the .stf puts it -- there is no separate deed quest anywhere in the client or the repo.
--
-- UNUSED SHIPPED KEYS:
--   s_99 -- empty in the client.
--   s_170 -- a player line ("It was terrible. Gotals everywhere...") whose parent Koh screen was
--   never shipped; the quest_12 debrief starts at s_171 instead.
--   s_101, s_103, s_105, s_107 -- a generic accept/decline pair ("Sounds easy." / "Glad to hear it,
--   pilot." / "I don't think I can wing it." / "Your loss!") that names no leg and has no shipped
--   parent.
--   s_213 -- a sign-off reply with no shipped parent; s_148 is used for that role instead.
--   THE LOK RAID (never shipped as a quest, and Lok is not this zone): s_152, s_154, s_156, s_157,
--   s_175, s_177, s_179, s_181, s_150, s_127, s_129, s_131, s_133, s_135, s_137, s_230, s_240, s_241.
--   THE CORELLIA SIPHON (never shipped as a quest, and Corellia is not this zone): s_90, s_92, s_94,
--   s_96, s_98, s_84, s_85, s_86, s_87, s_88, s_89, s_231, s_236, s_237.
--   (The Kessel diamonds leg and the Y-8 deed finale used to be listed here as unused. All twenty-two
--   of those keys -- s_191 through s_209, s_235, s_248, s_249 -- are now used, at the bottom of this
--   file.)
--
-- REACHABILITY: ep3_mining_captain_koh is not spawned anywhere in this repo and there is no Kashyyyk
-- ground zone in config.lua ZonesEnabled. See the handler header.

ep3_mining_captain_koh_convotemplate = ConvoTemplate:new {
	initialScreen = "ep3_koh_greeting",
	templateType = "Lua",
	luaClassHandler = "Ep3MiningCaptainKohConvoHandler",
	screens = {}
}

-- ---------------------------------------------------------------------------------------------
-- Introduction and quest_5 -- "Extract 500 Units of Organometallic Asteroid"
-- ---------------------------------------------------------------------------------------------

ep3_koh_greeting = ConvoScreen:new {
	id = "ep3_koh_greeting",
	leftDialog = "@conversation/ep3_mining_captain_koh:s_227", --Oh?  Do you have business with me?
	stopConversation = "false",
	options = {
		{"@conversation/ep3_mining_captain_koh:s_250", "ep3_koh_intro"}, --Thom Steele sent me here to take over some mining duties in the Kashyyyk sector.
	}
}
ep3_mining_captain_koh_convotemplate:addScreen(ep3_koh_greeting);

ep3_koh_intro = ConvoScreen:new {
	id = "ep3_koh_intro",
	leftDialog = "@conversation/ep3_mining_captain_koh:s_252", --Did he now?  Well then, I'll have to put you to work!  My name is Captain Koh, and I'll be your taskmaster while you are stationed on this planet.  You will respect my command!
	stopConversation = "false",
	options = {
		{"@conversation/ep3_mining_captain_koh:s_254", "ep3_koh_ready"}, --Sounds like fun.
	}
}
ep3_mining_captain_koh_convotemplate:addScreen(ep3_koh_intro);

ep3_koh_ready = ConvoScreen:new {
	id = "ep3_koh_ready",
	leftDialog = "@conversation/ep3_mining_captain_koh:s_256", --Fun?  Hardly!  Mining asteroids ain't like shooting kreetles, boy!  Are you ready to be put to work or not?
	stopConversation = "false",
	options = {
		{"@conversation/ep3_mining_captain_koh:s_258", "ep3_koh_q5_accept"}, --Sir, yes sir!
		{"@conversation/ep3_mining_captain_koh:s_266", "ep3_koh_q5_decline"}, --Not exactly.  Perhaps later.
	}
}
ep3_mining_captain_koh_convotemplate:addScreen(ep3_koh_ready);

-- The grant of space_mining_destroy/kashyyyk_mining_quest_5 happens in the handler on this id.
ep3_koh_q5_accept = ConvoScreen:new {
	id = "ep3_koh_q5_accept",
	leftDialog = "@conversation/ep3_mining_captain_koh:s_260", --That's more like it.  Head to Kashyyyk space and get me some samples of the organometallic asteroids up there.  You can keep what you mine, I just need a little.
	stopConversation = "false",
	options = {
		{"@conversation/ep3_mining_captain_koh:s_262", "ep3_koh_q5_ack"}, --I'll do my best.
	}
}
ep3_mining_captain_koh_convotemplate:addScreen(ep3_koh_q5_accept);

ep3_koh_q5_ack = ConvoScreen:new {
	id = "ep3_koh_q5_ack",
	leftDialog = "@conversation/ep3_mining_captain_koh:s_264", --Right you shall.
	stopConversation = "true",
	options = {}
}
ep3_mining_captain_koh_convotemplate:addScreen(ep3_koh_q5_ack);

ep3_koh_q5_decline = ConvoScreen:new {
	id = "ep3_koh_q5_decline",
	leftDialog = "@conversation/ep3_mining_captain_koh:s_268", --Hmph!  Well, come back if you change your mind.
	stopConversation = "true",
	options = {}
}
ep3_mining_captain_koh_convotemplate:addScreen(ep3_koh_q5_decline);

-- See the FLAGGED INTERPRETATION on s_270 in the header.
ep3_koh_no_space = ConvoScreen:new {
	id = "ep3_koh_no_space",
	leftDialog = "@conversation/ep3_mining_captain_koh:s_270", --I don't have time for you!  Be gone!
	stopConversation = "true",
	options = {}
}
ep3_mining_captain_koh_convotemplate:addScreen(ep3_koh_no_space);

ep3_koh_q5_active = ConvoScreen:new {
	id = "ep3_koh_q5_active",
	leftDialog = "@conversation/ep3_mining_captain_koh:s_215", --You have your orders pilot, so why aren't you in space?
	stopConversation = "true",
	options = {}
}
ep3_mining_captain_koh_convotemplate:addScreen(ep3_koh_q5_active);

-- Met him, turned the first job down (or never took it), came back later.
ep3_koh_q5_reoffer = ConvoScreen:new {
	id = "ep3_koh_q5_reoffer",
	leftDialog = "@conversation/ep3_mining_captain_koh:s_217", --Ready to do some work for me?
	stopConversation = "false",
	options = {
		{"@conversation/ep3_mining_captain_koh:s_219", "ep3_koh_q5_reaccept"}, --I believe I am.
		{"@conversation/ep3_mining_captain_koh:s_223", "ep3_koh_q5_reoffer_no"}, --I don't think so.
	}
}
ep3_mining_captain_koh_convotemplate:addScreen(ep3_koh_q5_reoffer);

ep3_koh_q5_reaccept = ConvoScreen:new {
	id = "ep3_koh_q5_reaccept",
	leftDialog = "@conversation/ep3_mining_captain_koh:s_221", --That's more like it.  Head to Kashyyyk space and get me some samples of the organometallic asteroids up there.  You can keep what you mine, I just need a little.
	stopConversation = "true",
	options = {}
}
ep3_mining_captain_koh_convotemplate:addScreen(ep3_koh_q5_reaccept);

ep3_koh_q5_reoffer_no = ConvoScreen:new {
	id = "ep3_koh_q5_reoffer_no",
	leftDialog = "@conversation/ep3_mining_captain_koh:s_225", --Then stop bugging me.
	stopConversation = "true",
	options = {}
}
ep3_mining_captain_koh_convotemplate:addScreen(ep3_koh_q5_reoffer_no);

ep3_koh_q5_failed = ConvoScreen:new {
	id = "ep3_koh_q5_failed",
	leftDialog = "@conversation/ep3_mining_captain_koh:s_232", --Let me guess...something went wrong?
	stopConversation = "false",
	options = {
		{"@conversation/ep3_mining_captain_koh:s_242", "ep3_koh_q5_retry"}, --Err, yeah, you could say that.  It won't happen again!
	}
}
ep3_mining_captain_koh_convotemplate:addScreen(ep3_koh_q5_failed);

ep3_koh_q5_retry = ConvoScreen:new {
	id = "ep3_koh_q5_retry",
	leftDialog = "@conversation/ep3_mining_captain_koh:s_243", --Get back to work then, and don't show your face here until you've succeeded!
	stopConversation = "true",
	options = {}
}
ep3_mining_captain_koh_convotemplate:addScreen(ep3_koh_q5_retry);

ep3_koh_q5_done = ConvoScreen:new {
	id = "ep3_koh_q5_done",
	leftDialog = "@conversation/ep3_mining_captain_koh:s_186", --Do you have those samples, pilot?
	stopConversation = "false",
	options = {
		{"@conversation/ep3_mining_captain_koh:s_188", "ep3_koh_q5_debrief"}, --Yes sir.  Here they are.
	}
}
ep3_mining_captain_koh_convotemplate:addScreen(ep3_koh_q5_done);

-- Debrief only -- see the NO SECOND PAYOUT note in the header.
ep3_koh_q5_debrief = ConvoScreen:new {
	id = "ep3_koh_q5_debrief",
	leftDialog = "@conversation/ep3_mining_captain_koh:s_190", --Excellent!  I'll need to analyze these to see if they confirm a suspicion of mine.  Come back in a bit to check in with me.  In the meantime, here is your pay for the mission.  Oh, and it's about time we gave you a larger cargo hold for that fighter.
	stopConversation = "true",
	options = {}
}
ep3_mining_captain_koh_convotemplate:addScreen(ep3_koh_q5_debrief);

-- ---------------------------------------------------------------------------------------------
-- quest_11 -- "Protect the Y-8 Convoy"
-- ---------------------------------------------------------------------------------------------

ep3_koh_q11_offer = ConvoScreen:new {
	id = "ep3_koh_q11_offer",
	leftDialog = "@conversation/ep3_mining_captain_koh:s_139", --I have an urgent task for you, pilot.
	stopConversation = "false",
	options = {
		{"@conversation/ep3_mining_captain_koh:s_142", "ep3_koh_q11_brief"}, --Let's hear it.
	}
}
ep3_mining_captain_koh_convotemplate:addScreen(ep3_koh_q11_offer);

ep3_koh_q11_brief = ConvoScreen:new {
	id = "ep3_koh_q11_brief",
	leftDialog = "@conversation/ep3_mining_captain_koh:s_143", --There is a convoy of Y-8 mining vessels coming through the Kashyyyk system later today.  They're headed for a hyperspace beacon, and their path leads them through dangerous waters.  As always, we expect the worst and hope for the best.
	stopConversation = "false",
	options = {
		{"@conversation/ep3_mining_captain_koh:s_144", "ep3_koh_q11_accept"}, --So I'll be their escort?
	}
}
ep3_mining_captain_koh_convotemplate:addScreen(ep3_koh_q11_brief);

-- The grant of convoy/kashyyyk_mining_quest_11 happens in the handler on this id.
ep3_koh_q11_accept = ConvoScreen:new {
	id = "ep3_koh_q11_accept",
	leftDialog = "@conversation/ep3_mining_captain_koh:s_145", --Indeed, pilot.  Meet them at the designated rendezvous point in the Kashyyyk system, and see to it that every ship in that convoy makes it to the hyperspace point.
	stopConversation = "true",
	options = {}
}
ep3_mining_captain_koh_convotemplate:addScreen(ep3_koh_q11_accept);

ep3_koh_q11_active = ConvoScreen:new {
	id = "ep3_koh_q11_active",
	leftDialog = "@conversation/ep3_mining_captain_koh:s_140", --That convoy won't escort itself!  Get moving, NOW!
	stopConversation = "true",
	options = {}
}
ep3_mining_captain_koh_convotemplate:addScreen(ep3_koh_q11_active);

ep3_koh_q11_done = ConvoScreen:new {
	id = "ep3_koh_q11_done",
	leftDialog = "@conversation/ep3_mining_captain_koh:s_141", --So, pilot?  Did they make it out safely?
	stopConversation = "false",
	options = {
		{"@conversation/ep3_mining_captain_koh:s_146", "ep3_koh_q11_debrief"}, --I wouldn't be here otherwise.
	}
}
ep3_mining_captain_koh_convotemplate:addScreen(ep3_koh_q11_done);

ep3_koh_q11_debrief = ConvoScreen:new {
	id = "ep3_koh_q11_debrief",
	leftDialog = "@conversation/ep3_mining_captain_koh:s_147", --Excellent work.  Stupendous.  Marvelous!  You've done our company a huge service by protecting that cargo!  You've earned this reward.  Keep it up and you may find yourself piloting a Y-8 one of these days...
	stopConversation = "false",
	options = {
		{"@conversation/ep3_mining_captain_koh:s_211", "ep3_koh_q11_signoff"}, --I'll be back soon then.
	}
}
ep3_mining_captain_koh_convotemplate:addScreen(ep3_koh_q11_debrief);

ep3_koh_q11_signoff = ConvoScreen:new {
	id = "ep3_koh_q11_signoff",
	leftDialog = "@conversation/ep3_mining_captain_koh:s_148", --Indeed you will.  Come back when you are ready for more work!
	stopConversation = "true",
	options = {}
}
ep3_mining_captain_koh_convotemplate:addScreen(ep3_koh_q11_signoff);

ep3_koh_q11_failed = ConvoScreen:new {
	id = "ep3_koh_q11_failed",
	leftDialog = "@conversation/ep3_mining_captain_koh:s_233", --You dolt!  You couldn't even escort a few of our mining vessels out of the system.  What good are you to me?
	stopConversation = "false",
	options = {
		{"@conversation/ep3_mining_captain_koh:s_244", "ep3_koh_q11_retry"}, --Maybe I could catch up and try to help them?
	}
}
ep3_mining_captain_koh_convotemplate:addScreen(ep3_koh_q11_failed);

ep3_koh_q11_retry = ConvoScreen:new {
	id = "ep3_koh_q11_retry",
	leftDialog = "@conversation/ep3_mining_captain_koh:s_245", --Get back up there and try to find them!  They may still need you!
	stopConversation = "true",
	options = {}
}
ep3_mining_captain_koh_convotemplate:addScreen(ep3_koh_q11_retry);

-- ---------------------------------------------------------------------------------------------
-- quest_12 -- "Intercept the Gilded Wookiee"
-- ---------------------------------------------------------------------------------------------

ep3_koh_q12_offer = ConvoScreen:new {
	id = "ep3_koh_q12_offer",
	leftDialog = "@conversation/ep3_mining_captain_koh:s_159", --Tell me, pilot.  Did Gotal bandits keep the Gilded Wookiee from leaving the zone?
	stopConversation = "false",
	options = {
		{"@conversation/ep3_mining_captain_koh:s_160", "ep3_koh_q12_brief1"}, --Err...what?
	}
}
ep3_mining_captain_koh_convotemplate:addScreen(ep3_koh_q12_offer);

ep3_koh_q12_brief1 = ConvoScreen:new {
	id = "ep3_koh_q12_brief1",
	leftDialog = "@conversation/ep3_mining_captain_koh:s_161", --Remember clearing a path for that convoy?  The Gotal bandits you took out?  Yeah, thought so.  Well, another convoy---not ours, mind you---is using our same route to that hyperspace beacon!  Trying to slip in behind us, let us do the hard work...
	stopConversation = "false",
	options = {
		{"@conversation/ep3_mining_captain_koh:s_162", "ep3_koh_q12_brief2"}, --I see where this is headed...
	}
}
ep3_mining_captain_koh_convotemplate:addScreen(ep3_koh_q12_brief1);

ep3_koh_q12_brief2 = ConvoScreen:new {
	id = "ep3_koh_q12_brief2",
	leftDialog = "@conversation/ep3_mining_captain_koh:s_163", --Teach them a lesson!  Their flagship, 'The Gilded Wookiee', will be starting on that route any minute.  They probably have a heavy fighter escort, despite the path you cleared.
	stopConversation = "false",
	options = {
		{"@conversation/ep3_mining_captain_koh:s_164", "ep3_koh_q12_brief3"}, --So I should blow them up?
	}
}
ep3_mining_captain_koh_convotemplate:addScreen(ep3_koh_q12_brief2);

ep3_koh_q12_brief3 = ConvoScreen:new {
	id = "ep3_koh_q12_brief3",
	leftDialog = "@conversation/ep3_mining_captain_koh:s_165", --Are you deaf?  I said teach them a lesson!  Yes, blow them up, scatter their ships across space, etcetera, ad infinitum!  And the escorts too...don't forget about the escorts.  As far as the rest of the galaxy is concerned, Gotal bandits got them before they could get out of the system.
	stopConversation = "false",
	options = {
		{"@conversation/ep3_mining_captain_koh:s_166", "ep3_koh_q12_accept"}, --No witnesses.  Got it.
		{"@conversation/ep3_mining_captain_koh:s_168", "ep3_koh_q12_decline"}, --I can't kill in such a wanton fashion!
	}
}
ep3_mining_captain_koh_convotemplate:addScreen(ep3_koh_q12_brief3);

-- The grant of assassinate/kashyyyk_mining_quest_12 happens in the handler on this id.
ep3_koh_q12_accept = ConvoScreen:new {
	id = "ep3_koh_q12_accept",
	leftDialog = "@conversation/ep3_mining_captain_koh:s_167", --You were never here!  Get moving!
	stopConversation = "true",
	options = {}
}
ep3_mining_captain_koh_convotemplate:addScreen(ep3_koh_q12_accept);

ep3_koh_q12_decline = ConvoScreen:new {
	id = "ep3_koh_q12_decline",
	leftDialog = "@conversation/ep3_mining_captain_koh:s_169", --Then we don't need to be speaking pilot!  Good day!
	stopConversation = "true",
	options = {}
}
ep3_mining_captain_koh_convotemplate:addScreen(ep3_koh_q12_decline);

ep3_koh_q12_active = ConvoScreen:new {
	id = "ep3_koh_q12_active",
	leftDialog = "@conversation/ep3_mining_captain_koh:s_158", --Kill, pilot!  Stop gabbing and kill!
	stopConversation = "true",
	options = {}
}
ep3_mining_captain_koh_convotemplate:addScreen(ep3_koh_q12_active);

-- The debrief starts at Koh's own reaction; the player line s_170 that would precede it has no
-- shipped parent screen. See the header.
ep3_koh_q12_done = ConvoScreen:new {
	id = "ep3_koh_q12_done",
	leftDialog = "@conversation/ep3_mining_captain_koh:s_171", --Tch tch.  A tragedy.  Really.  Tuggin' on my heartstrings there...
	stopConversation = "false",
	options = {
		{"@conversation/ep3_mining_captain_koh:s_172", "ep3_koh_q12_bonus"}, --My pay...for...delivering this news?
	}
}
ep3_mining_captain_koh_convotemplate:addScreen(ep3_koh_q12_done);

ep3_koh_q12_bonus = ConvoScreen:new {
	id = "ep3_koh_q12_bonus",
	leftDialog = "@conversation/ep3_mining_captain_koh:s_173", --Right, right.  News.  Pay.  Good one.  Here's a little bonus for the 'news'.
	stopConversation = "true",
	options = {}
}
ep3_mining_captain_koh_convotemplate:addScreen(ep3_koh_q12_bonus);

ep3_koh_q12_failed = ConvoScreen:new {
	id = "ep3_koh_q12_failed",
	leftDialog = "@conversation/ep3_mining_captain_koh:s_234", --Did you lose your nerve, pilot?  Or did you just fail outright?
	stopConversation = "false",
	options = {
		{"@conversation/ep3_mining_captain_koh:s_246", "ep3_koh_q12_retry"}, --No comment.
	}
}
ep3_mining_captain_koh_convotemplate:addScreen(ep3_koh_q12_failed);

ep3_koh_q12_retry = ConvoScreen:new {
	id = "ep3_koh_q12_retry",
	leftDialog = "@conversation/ep3_mining_captain_koh:s_247", --Find that ship and blow it away.  NOW!
	stopConversation = "true",
	options = {}
}
ep3_mining_captain_koh_convotemplate:addScreen(ep3_koh_q12_retry);

-- ---------------------------------------------------------------------------------------------
-- quest_8 -- "Broad Sample Part I"
-- ---------------------------------------------------------------------------------------------

ep3_koh_q8_offer = ConvoScreen:new {
	id = "ep3_koh_q8_offer",
	leftDialog = "@conversation/ep3_mining_captain_koh:s_109", --Welcome back, pilot.  It's time to earn your keep.
	stopConversation = "false",
	options = {
		{"@conversation/ep3_mining_captain_koh:s_112", "ep3_koh_q8_brief"}, --What now?
	}
}
ep3_mining_captain_koh_convotemplate:addScreen(ep3_koh_q8_offer);

ep3_koh_q8_brief = ConvoScreen:new {
	id = "ep3_koh_q8_brief",
	leftDialog = "@conversation/ep3_mining_captain_koh:s_113", --We're in need of a broad resource sample of several systems---Kashyyyk, which you should be familiar with already, Endor, and Dathomir.  You will fly to these three systems in that order, and procure a 125 unit sample from each.  Are you up to that task?
	stopConversation = "false",
	options = {
		{"@conversation/ep3_mining_captain_koh:s_114", "ep3_koh_q8_accept"}, --I think so.
		{"@conversation/ep3_mining_captain_koh:s_115", "ep3_koh_q8_decline"}, --Not today.
	}
}
ep3_mining_captain_koh_convotemplate:addScreen(ep3_koh_q8_brief);

-- The grant of space_mining_destroy/kashyyyk_mining_quest_8 happens in the handler on this id.
ep3_koh_q8_accept = ConvoScreen:new {
	id = "ep3_koh_q8_accept",
	leftDialog = "@conversation/ep3_mining_captain_koh:s_116", --That's the right attitude.  You have your orders, so get moving.
	stopConversation = "true",
	options = {}
}
ep3_mining_captain_koh_convotemplate:addScreen(ep3_koh_q8_accept);

ep3_koh_q8_decline = ConvoScreen:new {
	id = "ep3_koh_q8_decline",
	leftDialog = "@conversation/ep3_mining_captain_koh:s_118", --Bah!  I'll find another pilot then!
	stopConversation = "true",
	options = {}
}
ep3_mining_captain_koh_convotemplate:addScreen(ep3_koh_q8_decline);

ep3_koh_q8_active = ConvoScreen:new {
	id = "ep3_koh_q8_active",
	leftDialog = "@conversation/ep3_mining_captain_koh:s_110", --You have your orders pilot.  Get a move on!
	stopConversation = "true",
	options = {}
}
ep3_mining_captain_koh_convotemplate:addScreen(ep3_koh_q8_active);

ep3_koh_q8_done = ConvoScreen:new {
	id = "ep3_koh_q8_done",
	leftDialog = "@conversation/ep3_mining_captain_koh:s_111", --Have you completed your sampling mission?
	stopConversation = "false",
	options = {
		{"@conversation/ep3_mining_captain_koh:s_119", "ep3_koh_q8_debrief"}, --I have.
	}
}
ep3_mining_captain_koh_convotemplate:addScreen(ep3_koh_q8_done);

-- Debrief only -- see the NO SECOND PAYOUT note in the header.
ep3_koh_q8_debrief = ConvoScreen:new {
	id = "ep3_koh_q8_debrief",
	leftDialog = "@conversation/ep3_mining_captain_koh:s_120", --Excellent.  As usual, you can keep what you mined, we just need the data.  It is about time we gave you a new mining laser too.  Yours is looking a little old.
	stopConversation = "false",
	options = {
		{"@conversation/ep3_mining_captain_koh:s_121", "ep3_koh_q8_laser"}, --Is it more powerful too?
	}
}
ep3_mining_captain_koh_convotemplate:addScreen(ep3_koh_q8_debrief);

ep3_koh_q8_laser = ConvoScreen:new {
	id = "ep3_koh_q8_laser",
	leftDialog = "@conversation/ep3_mining_captain_koh:s_122", --Indeed it is. This is the Mark II model.  You'll find mining asteroids is a bit easier using this.  We don't get many of these in---so they are only reserved for our best pilots.
	stopConversation = "false",
	options = {
		{"@conversation/ep3_mining_captain_koh:s_123", "ep3_koh_q8_end"}, --Good to know I'm appreciated.
	}
}
ep3_mining_captain_koh_convotemplate:addScreen(ep3_koh_q8_laser);

-- The end of Koh's shipped KASHYYYK arc. Reached as the tail of the quest_8 debrief; seeing it sets
-- the quest_8 debriefed latch, and from the next conversation on the handler opens the Kessel leg
-- below instead ("Come back when you are ready for another task" -> "This is it pilot.  Your big
-- break.").
ep3_koh_q8_end = ConvoScreen:new {
	id = "ep3_koh_q8_end",
	leftDialog = "@conversation/ep3_mining_captain_koh:s_124", --You've done us a great service thus far.  Come back when you are ready for another task.
	stopConversation = "true",
	options = {}
}
ep3_mining_captain_koh_convotemplate:addScreen(ep3_koh_q8_end);

ep3_koh_q8_failed = ConvoScreen:new {
	id = "ep3_koh_q8_failed",
	leftDialog = "@conversation/ep3_mining_captain_koh:s_229", --WHAT?  I don't want to hear your excuses, pilot.
	stopConversation = "false",
	options = {
		{"@conversation/ep3_mining_captain_koh:s_238", "ep3_koh_q8_retry"}, --Aw, please, just one more try!
	}
}
ep3_mining_captain_koh_convotemplate:addScreen(ep3_koh_q8_failed);

ep3_koh_q8_retry = ConvoScreen:new {
	id = "ep3_koh_q8_retry",
	leftDialog = "@conversation/ep3_mining_captain_koh:s_239", --Get back up there and try again, on the double pilot!
	stopConversation = "true",
	options = {}
}
ep3_mining_captain_koh_convotemplate:addScreen(ep3_koh_q8_retry);

-- ---------------------------------------------------------------------------------------------
-- quest_13 -- "Kessel System:  Space Diamonds", and the Y-8 deed that closes Koh's arc.
--
-- space_mining_destroy/kessel_mining_quest_13 lives in KesselDutyScreenplay.lua (global line 178,
-- registerScreenPlay line 215), not in KashyyykMiningScreenplay.lua, because its questZone is
-- space_light1. It is Koh's leg all the same -- see the header.
-- ---------------------------------------------------------------------------------------------

ep3_koh_q13_offer = ConvoScreen:new {
	id = "ep3_koh_q13_offer",
	leftDialog = "@conversation/ep3_mining_captain_koh:s_191", --This is it pilot.  Your big break.  The mission that will put you on the map.
	stopConversation = "false",
	options = {
		{"@conversation/ep3_mining_captain_koh:s_194", "ep3_koh_q13_brief1"}, --Tell me more.
	}
}
ep3_mining_captain_koh_convotemplate:addScreen(ep3_koh_q13_offer);

ep3_koh_q13_brief1 = ConvoScreen:new {
	id = "ep3_koh_q13_brief1",
	leftDialog = "@conversation/ep3_mining_captain_koh:s_195", --A rare cluster of asteroids has been discovered in the highly dangerous Kessel system.  Do you know what makes these asteroids special?
	stopConversation = "false",
	options = {
		{"@conversation/ep3_mining_captain_koh:s_196", "ep3_koh_q13_brief2"}, --Not as such.
	}
}
ep3_mining_captain_koh_convotemplate:addScreen(ep3_koh_q13_brief1);

ep3_koh_q13_brief2 = ConvoScreen:new {
	id = "ep3_koh_q13_brief2",
	leftDialog = "@conversation/ep3_mining_captain_koh:s_197", --Diamonds, pilot.  They have diamond cores.  Inside each of these miserable space rocks beats a pristine gemstone heart.
	stopConversation = "false",
	options = {
		{"@conversation/ep3_mining_captain_koh:s_198", "ep3_koh_q13_brief3"}, --Ooh.
	}
}
ep3_mining_captain_koh_convotemplate:addScreen(ep3_koh_q13_brief2);

ep3_koh_q13_brief3 = ConvoScreen:new {
	id = "ep3_koh_q13_brief3",
	leftDialog = "@conversation/ep3_mining_captain_koh:s_199", --Ever been to Kessel?  Well, if you haven't, you're going now.  Head out and sample those diamond cores before anyone else can get a hold of them.  You will almost certainly be attacked by pirates while mining those rocks.
	stopConversation = "false",
	options = {
		{"@conversation/ep3_mining_captain_koh:s_200", "ep3_koh_q13_accept"}, --Yes sir.
		{"@conversation/ep3_mining_captain_koh:s_201", "ep3_koh_q13_decline"}, --Too dangerous.  Find someone else to mine your diamonds.
	}
}
ep3_mining_captain_koh_convotemplate:addScreen(ep3_koh_q13_brief3);

-- The grant of space_mining_destroy/kessel_mining_quest_13 happens in the handler on this id.
ep3_koh_q13_accept = ConvoScreen:new {
	id = "ep3_koh_q13_accept",
	leftDialog = "@conversation/ep3_mining_captain_koh:s_202", --Report back when you have the diamonds.
	stopConversation = "true",
	options = {}
}
ep3_mining_captain_koh_convotemplate:addScreen(ep3_koh_q13_accept);

ep3_koh_q13_decline = ConvoScreen:new {
	id = "ep3_koh_q13_decline",
	leftDialog = "@conversation/ep3_mining_captain_koh:s_203", --Cowardice doesn't become you, pilot.  Off with you.
	stopConversation = "true",
	options = {}
}
ep3_mining_captain_koh_convotemplate:addScreen(ep3_koh_q13_decline);

ep3_koh_q13_active = ConvoScreen:new {
	id = "ep3_koh_q13_active",
	leftDialog = "@conversation/ep3_mining_captain_koh:s_192", --Is your cargo hold full of space diamonds yet?  I didn't think so!  Get back to work!
	stopConversation = "true",
	options = {}
}
ep3_mining_captain_koh_convotemplate:addScreen(ep3_koh_q13_active);

ep3_koh_q13_done = ConvoScreen:new {
	id = "ep3_koh_q13_done",
	leftDialog = "@conversation/ep3_mining_captain_koh:s_193", --Do you have the diamonds?
	stopConversation = "false",
	options = {
		{"@conversation/ep3_mining_captain_koh:s_204", "ep3_koh_q13_debrief"}, --Of course.
	}
}
ep3_mining_captain_koh_convotemplate:addScreen(ep3_koh_q13_done);

-- Debrief only -- see the NO SECOND PAYOUT note in the header. s_207's Y-8 deed is the one promise in
-- this file that names a specific object; kessel_mining_quest_13 carries itemReward = {} like the
-- other four, and nothing here hands a deed out. Whether that deed should exist is for whoever sets
-- itemReward, not for a conversation.
ep3_koh_q13_debrief = ConvoScreen:new {
	id = "ep3_koh_q13_debrief",
	leftDialog = "@conversation/ep3_mining_captain_koh:s_205", --I'm suitably impressed, pilot.  Your mining talents cannot be underestimated or overlooked.  Your work with me is done, but I have a parting gift for you, on behalf of the Mining Division of Corellian Engineering.
	stopConversation = "false",
	options = {
		{"@conversation/ep3_mining_captain_koh:s_206", "ep3_koh_q13_deed"}, --A gift?
	}
}
ep3_mining_captain_koh_convotemplate:addScreen(ep3_koh_q13_debrief);

ep3_koh_q13_deed = ConvoScreen:new {
	id = "ep3_koh_q13_deed",
	leftDialog = "@conversation/ep3_mining_captain_koh:s_207", --This is a deed to one of the company's new Y-8 mining vessels.  You've earned this, pilot.  Take it, along with my gratitude.  May it serve you well.
	stopConversation = "false",
	options = {
		{"@conversation/ep3_mining_captain_koh:s_208", "ep3_koh_q13_farewell"}, --I'll use it well.
	}
}
ep3_mining_captain_koh_convotemplate:addScreen(ep3_koh_q13_deed);

-- The end of Koh's whole shipped arc, and his standing screen from then on.
ep3_koh_q13_farewell = ConvoScreen:new {
	id = "ep3_koh_q13_farewell",
	leftDialog = "@conversation/ep3_mining_captain_koh:s_209", --I'm sure we will meet again pilot.  I look forward to hearing more of your mining adventures.  Good luck!
	stopConversation = "true",
	options = {}
}
ep3_mining_captain_koh_convotemplate:addScreen(ep3_koh_q13_farewell);

ep3_koh_q13_failed = ConvoScreen:new {
	id = "ep3_koh_q13_failed",
	leftDialog = "@conversation/ep3_mining_captain_koh:s_235", --No diamonds?  Your ineptitude amazes me sometimes!
	stopConversation = "false",
	options = {
		{"@conversation/ep3_mining_captain_koh:s_248", "ep3_koh_q13_retry"}, --I'll do better next time.
	}
}
ep3_mining_captain_koh_convotemplate:addScreen(ep3_koh_q13_failed);

ep3_koh_q13_retry = ConvoScreen:new {
	id = "ep3_koh_q13_retry",
	leftDialog = "@conversation/ep3_mining_captain_koh:s_249", --That has yet to be demonstrated.  Get back up there and find us some diamonds!
	stopConversation = "true",
	options = {}
}
ep3_mining_captain_koh_convotemplate:addScreen(ep3_koh_q13_retry);

addConversationTemplate("ep3_mining_captain_koh_convotemplate", ep3_mining_captain_koh_convotemplate);
