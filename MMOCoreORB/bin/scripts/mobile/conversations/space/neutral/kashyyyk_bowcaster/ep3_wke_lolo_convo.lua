-- Lolo -- the Wookiee weaponsmith in Kachirho, and the ground giver for the bowcaster space leg that
-- had no giver:
--
--   inspect/ep3_wke_bowcaster_crafting   "Kashyyyk System: Recover Missing Bowcaster Pieces"
--     (screenplays/space/squadrons/KashyyykHuntingScreenplay.lua, global line 694,
--      registered line 725)
--
-- Before this file nothing in the repo handed it out: it had zero :startQuest call sites, declares no
-- parentQuest, declares no sideQuest, and is nobody's sideQuest. Its courier
-- (wke_resist_tier3_bowcaster_parts) and its spawn (space_kashyyyk_spawner.lua:197-199) were already
-- in place; only the grant was missing.
--
-- EVERY leftDialog and EVERY option below is a verbatim shipped key from
-- conversation/ep3_kachirho_lolo.stf. Nothing is authored.
--
-- WHERE THIS SITS IN THE SHIPPED GROUND QUEST. quest/ep3_kachirho_trando_rifle_crafting.qst,
-- journal category "Trandoshan Slavers", runs talkToLolo -> craftBowcaster -> returnKressik. The
-- space leg sits between talkToLolo and craftBowcaster: Lolo cannot assemble the weapon until the
-- feed-mechanism parts come back out of the Kashyyyk system.
--
-- SHIPPED DATA IS INTERNALLY INCONSISTENT ABOUT WHO SENT THE PLAYER. The .qst names Kressik; Lolo's
-- own player line s_19 says "Jobarkko sent me", and his closing line s_104 says "I hope that Jobarkko
-- isn't to upset with me over this". Both are shipped. This file does not try to resolve that -- it
-- uses the client's own words and leaves the discrepancy where SOE left it.
--
-- The pitch matches the screenplay field for field:
--   s_92 "One group took the feed mechanism parts and tried to ship it off world." == the quest's
--   own title_d, "a member of the Wookiee resistance stole a box of parts ... launched off of
--   Kashyyyk", and the courier agent wke_resist_tier3_bowcaster_parts, a wke_resist hull carrying
--   cargoString "ep3_wke_bowcaster_parts".
--   s_97 "the Wookiee who took the parts for the feed mechanism had hyperdrive problems and is still
--   in the system. You can probably get a lock on his distress signal" == questZone space_kashyyyk
--   and the SpaceInspectScreenplay shape: a stationary-ish target you fly to and SCAN rather than
--   destroy. That is why the grant hangs on s_97 and not earlier.
--   s_88 "Ah, you have the pieces. That is great. I will put them together for you and give you the
--   correct part." == the completion of the inspect leg and the hand-back into craftBowcaster.
--
-- FLAGGED INTERPRETATION -- SCREEN TOPOLOGY. The client ships no screen graph. The blocks below are
-- read off the .stf's own key order and its strict speaker alternation (Lolo on s_91, s_76, s_78,
-- s_80, s_82, s_84, s_92, s_94, s_97, s_99, s_104; the player on the keys between them), and off the
-- self-contained blocks the file ships (s_100/s_101/s_102, s_89/s_105/s_106/s_107/s_108,
-- s_254/s_255/s_256/s_257/s_258). Which block the handler picks is ours.
--
-- FLAGGED INTERPRETATION -- s_100 AS THE FLIGHT GATE. s_100 "Sorry...no time to talk. Work, work,
-- work." is Lolo's only shipped brush-off, and s_101/s_102 are the only shipped replies to it
-- ("I am looking for a bowcaster." / "you came to the wrong place ... Maybe I could put you on a
-- waiting list."). It is used here for a player the handler can see cannot fly the leg at all: JTL
-- off, not a pilot, or no certified ship. That is exactly how Captain Koh's s_270 is used
-- (ep3_mining_captain_koh_convo.lua). The text is client fact; the trigger is not.
--
-- FLAGGED INTERPRETATION -- FAILURE DETECTION. SpaceInspectScreenplay leaves no distinguishable
-- failure record a conversation can read, so a "took it once" latch is written on a successful grant
-- and the s_89 block is shown to anyone who once took it and now has it neither active nor complete.
-- That cannot separate "failed it" from "abandoned it". The .stf's own line for this case says as
-- much without naming a cause: s_89 "No luck with that pilot? No matter. He is still out there if
-- you would like to give it another shot?"
--
-- THE REPEAT IS THE CLIENT'S IDEA, NOT OURS. s_256 "Can I do that space part again?" / s_258 "Sure."
-- ship in the client, so this space leg is explicitly repeatable and the handler re-grants from that
-- option. Nothing about the repeat is authored.
--
-- UNUSED SHIPPED KEYS:
--   s_86 -- empty in the client.
--   s_87 "Rowarro. Grrrrllll. Roorroww." -- Lolo speaking Shyriiwook. The client must switch to it on
--   something this repo cannot read (there is no language-comprehension hook on the conversation
--   path), so no screen is built on it rather than inventing a trigger.
--
-- REACHABILITY: ep3_wke_lolo is not spawned anywhere in this repo -- nothing outside
-- mobile/custom_content/ep3/ep3_wke_lolo.lua and its object template references the mobile at all --
-- there are no Kashyyyk ground spawn areas, and bin/conf/config.lua ZonesEnabled contains no
-- Kashyyyk ground zone (only SpaceZonesEnabled carries "space_kashyyyk"). This conversation is
-- correct and inert until all three of those are addressed. The mobile itself is now conversable:
-- see mobile/custom_content/ep3/ep3_wke_lolo.lua.

ep3_wke_lolo_convotemplate = ConvoTemplate:new {
	initialScreen = "ep3_lolo_greeting",
	templateType = "Lua",
	luaClassHandler = "Ep3WkeLoloConvoHandler",
	screens = {}
}

-- ---------------------------------------------------------------------------------------------
-- First approach: the whole shipped account of how the bowcaster came apart, ending in the grant.
-- ---------------------------------------------------------------------------------------------

ep3_lolo_greeting = ConvoScreen:new {
	id = "ep3_lolo_greeting",
	leftDialog = "@conversation/ep3_kachirho_lolo:s_91", --Yes? What can I do for you on this fine day?
	stopConversation = "false",
	options = {
		{"@conversation/ep3_kachirho_lolo:s_19", "ep3_lolo_gone"}, --Actually, Jobarkko sent me to look at the new bowcaster.
	}
}
ep3_wke_lolo_convotemplate:addScreen(ep3_lolo_greeting);

ep3_lolo_gone = ConvoScreen:new {
	id = "ep3_lolo_gone",
	leftDialog = "@conversation/ep3_kachirho_lolo:s_76", --This is just great. I am sorry that Jobarkko wasted your time. The bowcaster is gone. Well...I guess technically not gone. I still have the schematics for it but I am afraid that all of the parts needed to put it together have been taken.
	stopConversation = "false",
	options = {
		{"@conversation/ep3_kachirho_lolo:s_77", "ep3_lolo_taken"}, --Taken. What do you mean, taken?
	}
}
ep3_wke_lolo_convotemplate:addScreen(ep3_lolo_gone);

ep3_lolo_taken = ConvoScreen:new {
	id = "ep3_lolo_taken",
	leftDialog = "@conversation/ep3_kachirho_lolo:s_78", --Everyone was so excited about this new bowcaster that no one would actually wait for me to put it together. The resistance shows up here before I could assemble the weapon and starts arguing about what to do with it.
	stopConversation = "false",
	options = {
		{"@conversation/ep3_kachirho_lolo:s_79", "ep3_lolo_infighting"}, --The resistance was fighting amongst themselves?
	}
}
ep3_wke_lolo_convotemplate:addScreen(ep3_lolo_taken);

ep3_lolo_infighting = ConvoScreen:new {
	id = "ep3_lolo_infighting",
	leftDialog = "@conversation/ep3_kachirho_lolo:s_80", --That shouldn't surprise you. How else do you think a relatively small group of Trandoshans can control an entire population.
	stopConversation = "false",
	options = {
		{"@conversation/ep3_kachirho_lolo:s_81", "ep3_lolo_empire"}, --Well, they are backed by the Empire.
	}
}
ep3_wke_lolo_convotemplate:addScreen(ep3_lolo_infighting);

ep3_lolo_empire = ConvoScreen:new {
	id = "ep3_lolo_empire",
	leftDialog = "@conversation/ep3_kachirho_lolo:s_82", --Bah! The Empire hasn't had an effective military in this sector for many years now.
	stopConversation = "false",
	options = {
		{"@conversation/ep3_kachirho_lolo:s_83", "ep3_lolo_explain"}, --What do you mean?
	}
}
ep3_wke_lolo_convotemplate:addScreen(ep3_lolo_empire);

ep3_lolo_explain = ConvoScreen:new {
	id = "ep3_lolo_explain",
	leftDialog = "@conversation/ep3_kachirho_lolo:s_84", --The resistance spends most of their time fighting each other rather then fighting the Trandoshans.
	stopConversation = "false",
	options = {
		{"@conversation/ep3_kachirho_lolo:s_85", "ep3_lolo_split"}, --So what happened to the bowcaster?
	}
}
ep3_wke_lolo_convotemplate:addScreen(ep3_lolo_explain);

-- The two halves of the weapon part company here: the feed mechanism goes off world (the space leg)
-- and the power handler goes back to the camps (the ground leg).
ep3_lolo_split = ConvoScreen:new {
	id = "ep3_lolo_split",
	leftDialog = "@conversation/ep3_kachirho_lolo:s_92", --Well they started fighting and made a complete mess out of my store. Both groups grabbed parts of it and made a run for it. One group took the feed mechanism parts and tried to ship it off world. The other grabbed the power handler and went back to their camps.
	stopConversation = "false",
	options = {
		{"@conversation/ep3_kachirho_lolo:s_93", "ep3_lolo_schematic"}, --So how would I make one of these bowcasters?
	}
}
ep3_wke_lolo_convotemplate:addScreen(ep3_lolo_split);

ep3_lolo_schematic = ConvoScreen:new {
	id = "ep3_lolo_schematic",
	leftDialog = "@conversation/ep3_kachirho_lolo:s_94", --I can give you the schematic for the barrel and the bowcaster. They are useless to me now. As for the other stuff you will have to recover them from the Wookiees who took them from me.
	stopConversation = "false",
	options = {
		{"@conversation/ep3_kachirho_lolo:s_95", "ep3_lolo_accept"}, --Alright. Where can I find these parts?
	}
}
ep3_wke_lolo_convotemplate:addScreen(ep3_lolo_schematic);

-- GRANT. s_97 is the moment Lolo points the player at the stranded courier and asks for the pieces
-- back, so the grant of inspect/ep3_wke_bowcaster_crafting happens in the handler on this id.
ep3_lolo_accept = ConvoScreen:new {
	id = "ep3_lolo_accept",
	leftDialog = "@conversation/ep3_kachirho_lolo:s_97", --I heard that the Wookiee who took the parts for the feed mechanism had hyperdrive problems and is still in the system. You can probably get a lock on his distress signal. It is in pieces but if you can recover it and bring it back to me I will put it together for you. And it would be my guess that the leaders of the other group took the power handlers and issued them to their troops to put into their weapons already.
	stopConversation = "false",
	options = {
		{"@conversation/ep3_kachirho_lolo:s_98", "ep3_lolo_handlers"}, --So they will have put the handlers in their weapons?
	}
}
ep3_wke_lolo_convotemplate:addScreen(ep3_lolo_accept);

ep3_lolo_handlers = ConvoScreen:new {
	id = "ep3_lolo_handlers",
	leftDialog = "@conversation/ep3_kachirho_lolo:s_99", --No. Those power handlers are specifically designed for the new bowcaster.
	stopConversation = "false",
	options = {
		{"@conversation/ep3_kachirho_lolo:s_103", "ep3_lolo_howto"}, --What do I do to put the bowcaster together?
	}
}
ep3_wke_lolo_convotemplate:addScreen(ep3_lolo_handlers);

ep3_lolo_howto = ConvoScreen:new {
	id = "ep3_lolo_howto",
	leftDialog = "@conversation/ep3_kachirho_lolo:s_104", --Make a barrel. Add that in with the power handler and the feed mechanism and you will have a bowcaster. I hope that Jobarkko isn't to upset with me over this...it wasn't my fault.
	stopConversation = "true",
	options = {}
}
ep3_wke_lolo_convotemplate:addScreen(ep3_lolo_howto);

-- ---------------------------------------------------------------------------------------------
-- Leg in hand.
-- ---------------------------------------------------------------------------------------------

-- s_90 is the only shipped in-progress hail: he has said everything he knows and is waiting on the
-- parts.
ep3_lolo_active = ConvoScreen:new {
	id = "ep3_lolo_active",
	leftDialog = "@conversation/ep3_kachirho_lolo:s_90", --I have told you everything I know. If you manage to get those parts for the feed mechanism I will happily put them together for you. Take care.
	stopConversation = "true",
	options = {}
}
ep3_wke_lolo_convotemplate:addScreen(ep3_lolo_active);

-- ---------------------------------------------------------------------------------------------
-- Parts recovered.
-- ---------------------------------------------------------------------------------------------

ep3_lolo_done = ConvoScreen:new {
	id = "ep3_lolo_done",
	leftDialog = "@conversation/ep3_kachirho_lolo:s_88", --Ah, you have the pieces. That is great. I will put them together for you and give you the correct part. Put this part together with the barrel and the power handler to make the bowcaster.
	stopConversation = "false",
	options = {
		{"@conversation/ep3_kachirho_lolo:s_103", "ep3_lolo_done_howto"}, --What do I do to put the bowcaster together?
	}
}
ep3_wke_lolo_convotemplate:addScreen(ep3_lolo_done);

-- Same shipped line as ep3_lolo_howto, on its own id so the handler can tell "heard the debrief"
-- from "heard the pitch".
ep3_lolo_done_howto = ConvoScreen:new {
	id = "ep3_lolo_done_howto",
	leftDialog = "@conversation/ep3_kachirho_lolo:s_104", --Make a barrel. Add that in with the power handler and the feed mechanism and you will have a bowcaster. I hope that Jobarkko isn't to upset with me over this...it wasn't my fault.
	stopConversation = "true",
	options = {}
}
ep3_wke_lolo_convotemplate:addScreen(ep3_lolo_done_howto);

-- ---------------------------------------------------------------------------------------------
-- The shipped repeat block. s_256 is the client asking, in its own words, to run the space leg
-- again, so the leg is repeatable by client attestation and not by our choice.
-- ---------------------------------------------------------------------------------------------

ep3_lolo_standing = ConvoScreen:new {
	id = "ep3_lolo_standing",
	leftDialog = "@conversation/ep3_kachirho_lolo:s_254", --There is nothing more that I can do for you.
	stopConversation = "false",
	options = {
		{"@conversation/ep3_kachirho_lolo:s_256", "ep3_lolo_repeat"}, --Can I do that space part again?
		{"@conversation/ep3_kachirho_lolo:s_255", "ep3_lolo_bye"}, --Ok, thanks and see you later.
	}
}
ep3_wke_lolo_convotemplate:addScreen(ep3_lolo_standing);

-- RE-GRANT. s_258 is Lolo agreeing to the repeat, so the re-grant happens in the handler on this id.
ep3_lolo_repeat = ConvoScreen:new {
	id = "ep3_lolo_repeat",
	leftDialog = "@conversation/ep3_kachirho_lolo:s_258", --Sure.
	stopConversation = "true",
	options = {}
}
ep3_wke_lolo_convotemplate:addScreen(ep3_lolo_repeat);

ep3_lolo_bye = ConvoScreen:new {
	id = "ep3_lolo_bye",
	leftDialog = "@conversation/ep3_kachirho_lolo:s_257", --Bye bye.
	stopConversation = "true",
	options = {}
}
ep3_wke_lolo_convotemplate:addScreen(ep3_lolo_bye);

-- ---------------------------------------------------------------------------------------------
-- Took it once, lost it: the shipped retry block.
-- ---------------------------------------------------------------------------------------------

ep3_lolo_retry = ConvoScreen:new {
	id = "ep3_lolo_retry",
	leftDialog = "@conversation/ep3_kachirho_lolo:s_89", --No luck with that pilot? No matter. He is still out there if you would like to give it another shot?
	stopConversation = "false",
	options = {
		{"@conversation/ep3_kachirho_lolo:s_105", "ep3_lolo_retry_yes"}, --Sure, I am ready to take care of him now.
		{"@conversation/ep3_kachirho_lolo:s_106", "ep3_lolo_retry_no"}, --No thanks, maybe later.
	}
}
ep3_wke_lolo_convotemplate:addScreen(ep3_lolo_retry);

-- RE-GRANT. s_108 is Lolo sending the player back out, so the re-grant happens in the handler here.
ep3_lolo_retry_yes = ConvoScreen:new {
	id = "ep3_lolo_retry_yes",
	leftDialog = "@conversation/ep3_kachirho_lolo:s_108", --Good luck to you.
	stopConversation = "true",
	options = {}
}
ep3_wke_lolo_convotemplate:addScreen(ep3_lolo_retry_yes);

ep3_lolo_retry_no = ConvoScreen:new {
	id = "ep3_lolo_retry_no",
	leftDialog = "@conversation/ep3_kachirho_lolo:s_107", --Take care then.
	stopConversation = "true",
	options = {}
}
ep3_wke_lolo_convotemplate:addScreen(ep3_lolo_retry_no);

-- ---------------------------------------------------------------------------------------------
-- Cannot fly the leg. See the FLAGGED INTERPRETATION on s_100 in the header.
-- ---------------------------------------------------------------------------------------------

ep3_lolo_busy = ConvoScreen:new {
	id = "ep3_lolo_busy",
	leftDialog = "@conversation/ep3_kachirho_lolo:s_100", --Sorry...no time to talk. Work, work, work. I always have orders to fill and schedules to keep.
	stopConversation = "false",
	options = {
		{"@conversation/ep3_kachirho_lolo:s_101", "ep3_lolo_waiting_list"}, --I am looking for a bowcaster. A special bowcaster.
	}
}
ep3_wke_lolo_convotemplate:addScreen(ep3_lolo_busy);

ep3_lolo_waiting_list = ConvoScreen:new {
	id = "ep3_lolo_waiting_list",
	leftDialog = "@conversation/ep3_kachirho_lolo:s_102", --A bowcaster eh? Well, I am afraid that you came to the wrong place. I do not have any in stock at this time. Maybe I could put you on a waiting list.
	stopConversation = "true",
	options = {}
}
ep3_wke_lolo_convotemplate:addScreen(ep3_lolo_waiting_list);

addConversationTemplate("ep3_wke_lolo_convotemplate", ep3_wke_lolo_convotemplate);
