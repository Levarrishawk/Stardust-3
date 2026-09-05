-- Ziven Tissak -- the Etyyy hunt-master whose friend Fordan Szholz never arrives, and who answers
-- Sordaan Xris by burning his freighters.
--
-- Giver for the three Kashyyyk hunting quest heads that had no giver:
--
--   rescue/ep3_hunting_ziven_fordans_ship                    (KashyyykHuntingScreenplay.lua global
--                                                             line 443, registered line 503)
--   assassinate/ep3_hunting_ziven_vs_sordaans_freighter_01   (global line 505, registered line 544)
--   assassinate/ep3_hunting_ziven_vs_sordaans_freighter_02   (global line 546, registered line 585)
--
-- Before this file nothing in the repo gave any of the three out.
--
-- EVERY leftDialog and EVERY option below is a verbatim shipped key from
-- conversation/ep3_etyyy_ziven_tissak.stf (84 entries). Nothing is authored.
--
-- The three pitches match the screenplays field for field:
--   s_366 "We've identified what we think is a tracking signal from his ship. Would you go
--   investigate for me? Recover his ship if you find it" == rescueShip rod_protector_ace_tier5 at
--   rescueLocation, which is the last recoveryPoint of recovery_ep3_hunting_banol_capture_fordan --
--   i.e. exactly where Banol's agents stripped and abandoned her. The two arcs meet on that
--   coordinate; that is the whole point of the chain.
--   s_576 "Destroy two of his freighters. The first is leaving soon." == the freighter_01 /
--   freighter_02 pair, target freighterheavy_tier4 both times, escorts stepping up from
--   rod_protector_tier4 x2 to rod_protector_tier5 x2 + rod_protector_ace_tier5, matching the _02
--   title_d "Be ready for a tougher fight this time."
--
-- freighter_02 carries parentQuest = freighter_01 in the screenplay. That field is a fail-cascade
-- only (SpaceAssassinateScreenplay.lua:121-122 fails the parent when the child fails); it is not a
-- gate. The gate is this conversation, which does not offer _02 until _01 is complete -- which is
-- what s_761 says: "Once you succeeded in that, we'll give you the location of the second freighter."
--
-- FLAGGED INTERPRETATION -- SCREEN TOPOLOGY. The client ships no screen graph. The blocks below are
-- read off the .stf's own key order and its yes/no pairings; the order in which the handler selects
-- between blocks is ours.
--
-- FLAGGED INTERPRETATION -- REUSED LANDING SCREENS. s_748, s_765 and s_763 are shipped NPC lines that
-- each name one specific leg ("head to the location we upload to you for Fordan's ship", "Destroy
-- Sordaan's first freighter", "Destroy Sordaan's second freighter and it's escort") with no shipped
-- player option reaching them. Each is used twice: as the screen a player sees while holding that
-- leg, and as the landing screen for that leg's retry. The text is client fact; those placements are
-- not.
--
-- FLAGGED INTERPRETATION -- s_745 AS THE FLIGHT GATE. The .stf ships four byte-identical copies of
-- "It looks like you already have a mission in space. Come back once you've completed that one."
-- (s_745, s_747, s_760, s_768), one per accept point. Only s_745 is wired, and it fires on the
-- conditions the handler can actually see -- JTL off, not a pilot, or no certified ship -- because
-- the engine exposes no generic "player holds any space mission" test: space_helpers.lua only offers
-- isSpaceQuestActive / isSpaceQuestTaskActive / isSpaceQuestComplete / isSpaceQuestTaskComplete for a
-- NAMED quest, and MissionObject.idl:479 only exposes isSpaceDutyMission(). The other three copies
-- are left unused rather than given invented distinctions.
--
-- THE ETYYY GROUND WEBWEAVER HUNT IS NOT BUILT HERE, DELIBERATELY. Roughly half of this .stf is a
-- multi-stage Etyyy ground hunt (go see Tuwezz Vol at Hracca Glade -> 38 untainted webweaver fangs ->
-- 2 immaculate webweaver eyes -> show Silkthrower's Fang -> go see Sordaan Xris) plus fifteen repeats
-- of the "[Show Silkthrower's Fang to Ziven]" option key. There is no webweaver collection quest, no
-- Tuwezz Vol conversation, no Sordaan Xris conversation and no Kashyyyk ground screenplay anywhere in
-- this repo, so every stage of it would have to be invented. It belongs to whoever builds the Etyyy
-- ground chain, not to this space giver. This is the same call already made for Tripp Rar's mouf hunt.
--
-- UNUSED SHIPPED KEYS:
--   s_747, s_760, s_768 -- byte-identical duplicates of s_745; see above.
--   s_580 is USED (freighter_01 retry landing); nothing else in the space arc is left out.
--   s_1697 -- empty in the client.
--   The ground hunt: s_1699, s_1701, s_1703, s_1705, s_1707, s_1709, s_1711, s_1713, s_1715, s_1717,
--   s_1719, s_1721, s_1723, s_1725, s_1727, s_1729, s_1731, s_1733, s_1735, s_1737, s_1739, s_1741,
--   s_1743, s_1745, s_1747, s_1749, s_1751, s_1753, s_1755, s_1757, s_1759, s_1761, s_1763, s_1765,
--   s_1767, s_1769.
--   The repeated "[Show Silkthrower's Fang to Ziven]" option keys: s_245, s_247, s_249, s_251,
--   s_253, s_255, s_257, s_259, s_261, s_263.
--
-- REACHABILITY: ep3_etyyy_ziven_tissak is not spawned anywhere in this repo and there is no Kashyyyk
-- ground zone in config.lua ZonesEnabled. See the handler header.

ep3_etyyy_ziven_tissak_convotemplate = ConvoTemplate:new {
	initialScreen = "ep3_ziven_fordan_offer",
	templateType = "Lua",
	luaClassHandler = "Ep3EtyyyZivenTissakConvoHandler",
	screens = {}
}

ep3_ziven_fordan_offer = ConvoScreen:new {
	id = "ep3_ziven_fordan_offer",
	leftDialog = "@conversation/ep3_etyyy_ziven_tissak:s_366", --I just received some disturbing news. A friend of mine, Fordan Szholz, was on his way to Kashyyyk but was attacked before he could arrive. I don't even know how long ago this happened, because I didn't know he was even coming to Kashyyyk until I received this news. We've identified what we think is a tracking signal from his ship. Would you go investigate for me? Recover his ship if you find it...hopefully with Fordan safely inside.
	stopConversation = "false",
	options = {
		{"@conversation/ep3_etyyy_ziven_tissak:s_571", "ep3_ziven_fordan_accept"}, --Um, okay, I suppose I can do that.
		{"@conversation/ep3_etyyy_ziven_tissak:s_572", "ep3_ziven_fordan_decline"}, --Er, no. I don't think that would be a good idea for me to do.
	}
}
ep3_etyyy_ziven_tissak_convotemplate:addScreen(ep3_ziven_fordan_offer);

-- The grant of rescue/ep3_hunting_ziven_fordans_ship happens in the handler on this id.
ep3_ziven_fordan_accept = ConvoScreen:new {
	id = "ep3_ziven_fordan_accept",
	leftDialog = "@conversation/ep3_etyyy_ziven_tissak:s_573", --Very good. I don't know what to expect up there, but try to salvage Fordan's ship if at all possible. Hopefully, he's safe inside of it, but even if he's not, his ship might have clues as to what happened.
	stopConversation = "true",
	options = {}
}
ep3_etyyy_ziven_tissak_convotemplate:addScreen(ep3_ziven_fordan_accept);

ep3_ziven_fordan_decline = ConvoScreen:new {
	id = "ep3_ziven_fordan_decline",
	leftDialog = "@conversation/ep3_etyyy_ziven_tissak:s_574", --I understand. Not everyone has the stomach for this kind of thing.
	stopConversation = "true",
	options = {}
}
ep3_etyyy_ziven_tissak_convotemplate:addScreen(ep3_ziven_fordan_decline);

-- Holding the rescue. Also the landing screen for its retry -- see the header.
ep3_ziven_fordan_in_flight = ConvoScreen:new {
	id = "ep3_ziven_fordan_in_flight",
	leftDialog = "@conversation/ep3_etyyy_ziven_tissak:s_748", --Launch into space and head to the location we upload to you for Fordan's ship.
	stopConversation = "true",
	options = {}
}
ep3_etyyy_ziven_tissak_convotemplate:addScreen(ep3_ziven_fordan_in_flight);

--[[
	FLAGGED INTERPRETATION -- FAILURE DETECTION. s_575 "I heard about the attacks, and you're inability
	to recover Fordan's ship" is written for a player who took the rescue and lost it.
	SpaceRescueScreenplay leaves no distinguishable failure record the conversation can read, so this
	handler cannot separate "failed it" from "walked away": it shows this block to anyone who once
	accepted and no longer has the quest active or complete. The text is client fact; that trigger is
	not. The same caveat applies to ep3_ziven_freighter1_failed and ep3_ziven_freighter2_failed below.
]]
ep3_ziven_fordan_failed = ConvoScreen:new {
	id = "ep3_ziven_fordan_failed",
	leftDialog = "@conversation/ep3_etyyy_ziven_tissak:s_575", --I heard about the attacks, and you're inability to recover Fordan's ship. We've reacquired the location of the ship. Please try again.
	stopConversation = "false",
	options = {
		{"@conversation/ep3_etyyy_ziven_tissak:s_758", "ep3_ziven_fordan_retry"}, --I'll take care of it.
		{"@conversation/ep3_etyyy_ziven_tissak:s_759", "ep3_ziven_fordan_retry_no"}, --No thanks.
	}
}
ep3_etyyy_ziven_tissak_convotemplate:addScreen(ep3_ziven_fordan_failed);

-- Re-grant happens in the handler on this id.
ep3_ziven_fordan_retry = ConvoScreen:new {
	id = "ep3_ziven_fordan_retry",
	leftDialog = "@conversation/ep3_etyyy_ziven_tissak:s_748", --Launch into space and head to the location we upload to you for Fordan's ship.
	stopConversation = "true",
	options = {}
}
ep3_etyyy_ziven_tissak_convotemplate:addScreen(ep3_ziven_fordan_retry);

ep3_ziven_fordan_retry_no = ConvoScreen:new {
	id = "ep3_ziven_fordan_retry_no",
	leftDialog = "@conversation/ep3_etyyy_ziven_tissak:s_762", --Okay, but return if you change your mind.
	stopConversation = "true",
	options = {}
}
ep3_etyyy_ziven_tissak_convotemplate:addScreen(ep3_ziven_fordan_retry_no);

-- Fordan's ship recovered. This is the whole reason the freighter arc exists.
ep3_ziven_freighter1_offer = ConvoScreen:new {
	id = "ep3_ziven_freighter1_offer",
	leftDialog = "@conversation/ep3_etyyy_ziven_tissak:s_576", --I appreciate you recovering that ship. My technicians were able to learn some things and I now know who was behind Fordan's disappearance: Sordaan Xris. Luckily, Fordan is okay and back on his home planet, but Sordaan must pay for what he's done. I want you to launch into space and hit Sordaan where it will hurt the most...in his bank balance. Destroy two of his freighters. The first is leaving soon.
	stopConversation = "false",
	options = {
		{"@conversation/ep3_etyyy_ziven_tissak:s_578", "ep3_ziven_freighter1_accept"}, --Um, okay, I suppose I can do that.
		{"@conversation/ep3_etyyy_ziven_tissak:s_582", "ep3_ziven_freighter1_decline"}, --No, not right now.
	}
}
ep3_etyyy_ziven_tissak_convotemplate:addScreen(ep3_ziven_freighter1_offer);

-- The grant of assassinate/ep3_hunting_ziven_vs_sordaans_freighter_01 happens in the handler on this
-- id. Two shipped NPC lines answer s_578 -- s_580 "Thank you. Launch into space when you're ready."
-- and s_761. s_761 is used here because it names this leg and the one after it; s_580 carries the
-- retry landing below, so neither shipped line is wasted.
ep3_ziven_freighter1_accept = ConvoScreen:new {
	id = "ep3_ziven_freighter1_accept",
	leftDialog = "@conversation/ep3_etyyy_ziven_tissak:s_761", --Excellent. Launch into space and destroy the first freighter as well as any ships escorting it. Once you succeeded in that, we'll give you the location of the second freighter.
	stopConversation = "true",
	options = {}
}
ep3_etyyy_ziven_tissak_convotemplate:addScreen(ep3_ziven_freighter1_accept);

ep3_ziven_freighter1_decline = ConvoScreen:new {
	id = "ep3_ziven_freighter1_decline",
	leftDialog = "@conversation/ep3_etyyy_ziven_tissak:s_584", --I understand. Not everyone has the stomach for this kind of thing.
	stopConversation = "true",
	options = {}
}
ep3_etyyy_ziven_tissak_convotemplate:addScreen(ep3_ziven_freighter1_decline);

ep3_ziven_freighter1_in_flight = ConvoScreen:new {
	id = "ep3_ziven_freighter1_in_flight",
	leftDialog = "@conversation/ep3_etyyy_ziven_tissak:s_765", --Destroy Sordaan's first freighter. Make sure none of his ships survive.
	stopConversation = "true",
	options = {}
}
ep3_etyyy_ziven_tissak_convotemplate:addScreen(ep3_ziven_freighter1_in_flight);

ep3_ziven_freighter1_failed = ConvoScreen:new {
	id = "ep3_ziven_freighter1_failed",
	leftDialog = "@conversation/ep3_etyyy_ziven_tissak:s_875", --The first freighter escaped, but that's not a problem. There are plenty more of them. We'll simply start with a different one.
	stopConversation = "false",
	options = {
		{"@conversation/ep3_etyyy_ziven_tissak:s_876", "ep3_ziven_freighter1_retry"}, --I'll try again.
		{"@conversation/ep3_etyyy_ziven_tissak:s_879", "ep3_ziven_freighter1_retry_no"}, --No thanks.
	}
}
ep3_etyyy_ziven_tissak_convotemplate:addScreen(ep3_ziven_freighter1_failed);

-- Re-grant happens in the handler on this id.
ep3_ziven_freighter1_retry = ConvoScreen:new {
	id = "ep3_ziven_freighter1_retry",
	leftDialog = "@conversation/ep3_etyyy_ziven_tissak:s_580", --Thank you. Launch into space when you're ready.
	stopConversation = "true",
	options = {}
}
ep3_etyyy_ziven_tissak_convotemplate:addScreen(ep3_ziven_freighter1_retry);

ep3_ziven_freighter1_retry_no = ConvoScreen:new {
	id = "ep3_ziven_freighter1_retry_no",
	leftDialog = "@conversation/ep3_etyyy_ziven_tissak:s_881", --Okay, but return if you change your mind.
	stopConversation = "true",
	options = {}
}
ep3_etyyy_ziven_tissak_convotemplate:addScreen(ep3_ziven_freighter1_retry_no);

-- First freighter down. s_764 is the shipped step to the second.
ep3_ziven_freighter2_offer = ConvoScreen:new {
	id = "ep3_ziven_freighter2_offer",
	leftDialog = "@conversation/ep3_etyyy_ziven_tissak:s_764", --You did well on the first freighter, but that's not enough. Go take out a second of Sordaan's freighters.
	stopConversation = "false",
	options = {
		{"@conversation/ep3_etyyy_ziven_tissak:s_766", "ep3_ziven_freighter2_accept"}, --I'm on my way.
		{"@conversation/ep3_etyyy_ziven_tissak:s_772", "ep3_ziven_freighter2_decline"}, --No thanks.
	}
}
ep3_etyyy_ziven_tissak_convotemplate:addScreen(ep3_ziven_freighter2_offer);

-- The grant of assassinate/ep3_hunting_ziven_vs_sordaans_freighter_02 happens in the handler on this id.
ep3_ziven_freighter2_accept = ConvoScreen:new {
	id = "ep3_ziven_freighter2_accept",
	leftDialog = "@conversation/ep3_etyyy_ziven_tissak:s_769", --Vey good. Destroy the second freighter and any ships that are escorting it.
	stopConversation = "true",
	options = {}
}
ep3_etyyy_ziven_tissak_convotemplate:addScreen(ep3_ziven_freighter2_accept);

ep3_ziven_freighter2_decline = ConvoScreen:new {
	id = "ep3_ziven_freighter2_decline",
	leftDialog = "@conversation/ep3_etyyy_ziven_tissak:s_774", --Okay, but return if you change your mind.
	stopConversation = "true",
	options = {}
}
ep3_etyyy_ziven_tissak_convotemplate:addScreen(ep3_ziven_freighter2_decline);

ep3_ziven_freighter2_in_flight = ConvoScreen:new {
	id = "ep3_ziven_freighter2_in_flight",
	leftDialog = "@conversation/ep3_etyyy_ziven_tissak:s_763", --Destroy Sordaan's second freighter and it's escort. Sordaan hates nothing more than spending money, and this should cost him a lot of it.
	stopConversation = "true",
	options = {}
}
ep3_etyyy_ziven_tissak_convotemplate:addScreen(ep3_ziven_freighter2_in_flight);

ep3_ziven_freighter2_failed = ConvoScreen:new {
	id = "ep3_ziven_freighter2_failed",
	leftDialog = "@conversation/ep3_etyyy_ziven_tissak:s_883", --The second freighter got away. Not to worry, it's only a minor setback. We'll pick another freighter to target. Do you think you can destroy it this time?
	stopConversation = "false",
	options = {
		{"@conversation/ep3_etyyy_ziven_tissak:s_884", "ep3_ziven_freighter2_retry"}, --Let me try again.
		{"@conversation/ep3_etyyy_ziven_tissak:s_886", "ep3_ziven_freighter2_retry_no"}, --No thanks.
	}
}
ep3_etyyy_ziven_tissak_convotemplate:addScreen(ep3_ziven_freighter2_failed);

-- Re-grant happens in the handler on this id.
ep3_ziven_freighter2_retry = ConvoScreen:new {
	id = "ep3_ziven_freighter2_retry",
	leftDialog = "@conversation/ep3_etyyy_ziven_tissak:s_763", --Destroy Sordaan's second freighter and it's escort. Sordaan hates nothing more than spending money, and this should cost him a lot of it.
	stopConversation = "true",
	options = {}
}
ep3_etyyy_ziven_tissak_convotemplate:addScreen(ep3_ziven_freighter2_retry);

ep3_ziven_freighter2_retry_no = ConvoScreen:new {
	id = "ep3_ziven_freighter2_retry_no",
	leftDialog = "@conversation/ep3_etyyy_ziven_tissak:s_888", --Okay, but return if you change your mind.
	stopConversation = "true",
	options = {}
}
ep3_etyyy_ziven_tissak_convotemplate:addScreen(ep3_ziven_freighter2_retry_no);

-- Both freighters destroyed. End of Ziven's shipped space arc.
ep3_ziven_complete = ConvoScreen:new {
	id = "ep3_ziven_complete",
	leftDialog = "@conversation/ep3_etyyy_ziven_tissak:s_882", --Very well done! That should send a message to Sordaan to leave me and my clan in peace. And if not, there's plenty more pain I can send his way.
	stopConversation = "true",
	options = {}
}
ep3_etyyy_ziven_tissak_convotemplate:addScreen(ep3_ziven_complete);

-- See the FLAGGED INTERPRETATION on s_745 in the header.
ep3_ziven_no_space = ConvoScreen:new {
	id = "ep3_ziven_no_space",
	leftDialog = "@conversation/ep3_etyyy_ziven_tissak:s_745", --It looks like you already have a mission in space. Come back once you've completed that one.
	stopConversation = "true",
	options = {}
}
ep3_etyyy_ziven_tissak_convotemplate:addScreen(ep3_ziven_no_space);


-- Ground screens folded in (ruling 2026-09-04). Screen ids are the shipped
-- java keys. Existing space screens above are untouched.
ep3_etyyy_ziven_tissak_convo_s_1763 = ConvoScreen:new {
	id = "s_1763",
	leftDialog = "@conversation/ep3_etyyy_ziven_tissak:s_1763", -- Is that... it is! Silkthrower's fang. Not many hunters could have defeated that webweaver. I've also...
	stopConversation = "true",
	options = {}
}
ep3_etyyy_ziven_tissak_convotemplate:addScreen(ep3_etyyy_ziven_tissak_convo_s_1763)

ep3_etyyy_ziven_tissak_convo_s_1769 = ConvoScreen:new {
	id = "s_1769",
	leftDialog = "@conversation/ep3_etyyy_ziven_tissak:s_1769", -- Is that... it is! Silkthrower's fang. Not many hunters could have defeated that webweaver, yet you h...
	stopConversation = "true",
	options = {}
}
ep3_etyyy_ziven_tissak_convotemplate:addScreen(ep3_etyyy_ziven_tissak_convo_s_1769)

ep3_etyyy_ziven_tissak_convo_s_768 = ConvoScreen:new {
	id = "s_768",
	leftDialog = "@conversation/ep3_etyyy_ziven_tissak:s_768", -- It looks like you already have a mission in space. Come back once you've completed that one.
	stopConversation = "true",
	options = {}
}
ep3_etyyy_ziven_tissak_convotemplate:addScreen(ep3_etyyy_ziven_tissak_convo_s_768)

ep3_etyyy_ziven_tissak_convo_s_769 = ConvoScreen:new {
	id = "s_769",
	leftDialog = "@conversation/ep3_etyyy_ziven_tissak:s_769", -- Vey good. Destroy the second freighter and any ships that are escorting it.
	stopConversation = "true",
	options = {}
}
ep3_etyyy_ziven_tissak_convotemplate:addScreen(ep3_etyyy_ziven_tissak_convo_s_769)

ep3_etyyy_ziven_tissak_convo_s_888 = ConvoScreen:new {
	id = "s_888",
	leftDialog = "@conversation/ep3_etyyy_ziven_tissak:s_888", -- Okay, but return if you change your mind.
	stopConversation = "true",
	options = {}
}
ep3_etyyy_ziven_tissak_convotemplate:addScreen(ep3_etyyy_ziven_tissak_convo_s_888)

ep3_etyyy_ziven_tissak_convo_s_774 = ConvoScreen:new {
	id = "s_774",
	leftDialog = "@conversation/ep3_etyyy_ziven_tissak:s_774", -- Okay, but return if you change your mind.
	stopConversation = "true",
	options = {}
}
ep3_etyyy_ziven_tissak_convotemplate:addScreen(ep3_etyyy_ziven_tissak_convo_s_774)

ep3_etyyy_ziven_tissak_convo_s_760 = ConvoScreen:new {
	id = "s_760",
	leftDialog = "@conversation/ep3_etyyy_ziven_tissak:s_760", -- It looks like you already have a mission in space. Come back once you've completed that one.
	stopConversation = "true",
	options = {}
}
ep3_etyyy_ziven_tissak_convotemplate:addScreen(ep3_etyyy_ziven_tissak_convo_s_760)

ep3_etyyy_ziven_tissak_convo_s_761 = ConvoScreen:new {
	id = "s_761",
	leftDialog = "@conversation/ep3_etyyy_ziven_tissak:s_761", -- Excellent. Launch into space and destroy the first freighter as well as any ships escorting it. Once...
	stopConversation = "true",
	options = {}
}
ep3_etyyy_ziven_tissak_convotemplate:addScreen(ep3_etyyy_ziven_tissak_convo_s_761)

ep3_etyyy_ziven_tissak_convo_s_881 = ConvoScreen:new {
	id = "s_881",
	leftDialog = "@conversation/ep3_etyyy_ziven_tissak:s_881", -- Okay, but return if you change your mind.
	stopConversation = "true",
	options = {}
}
ep3_etyyy_ziven_tissak_convotemplate:addScreen(ep3_etyyy_ziven_tissak_convo_s_881)

ep3_etyyy_ziven_tissak_convo_s_762 = ConvoScreen:new {
	id = "s_762",
	leftDialog = "@conversation/ep3_etyyy_ziven_tissak:s_762", -- Okay, but return if you change your mind.
	stopConversation = "true",
	options = {}
}
ep3_etyyy_ziven_tissak_convotemplate:addScreen(ep3_etyyy_ziven_tissak_convo_s_762)

ep3_etyyy_ziven_tissak_convo_s_747 = ConvoScreen:new {
	id = "s_747",
	leftDialog = "@conversation/ep3_etyyy_ziven_tissak:s_747", -- It looks like you already have a mission in space. Come back once you've completed that one.
	stopConversation = "true",
	options = {}
}
ep3_etyyy_ziven_tissak_convotemplate:addScreen(ep3_etyyy_ziven_tissak_convo_s_747)

ep3_etyyy_ziven_tissak_convo_s_580 = ConvoScreen:new {
	id = "s_580",
	leftDialog = "@conversation/ep3_etyyy_ziven_tissak:s_580", -- Thank you. Launch into space when you're ready.
	stopConversation = "true",
	options = {}
}
ep3_etyyy_ziven_tissak_convotemplate:addScreen(ep3_etyyy_ziven_tissak_convo_s_580)

ep3_etyyy_ziven_tissak_convo_s_584 = ConvoScreen:new {
	id = "s_584",
	leftDialog = "@conversation/ep3_etyyy_ziven_tissak:s_584", -- I understand. Not everyone has the stomach for this kind of thing.
	stopConversation = "true",
	options = {}
}
ep3_etyyy_ziven_tissak_convotemplate:addScreen(ep3_etyyy_ziven_tissak_convo_s_584)

ep3_etyyy_ziven_tissak_convo_s_745 = ConvoScreen:new {
	id = "s_745",
	leftDialog = "@conversation/ep3_etyyy_ziven_tissak:s_745", -- It looks like you already have a mission in space. Come back once you've completed that one.
	stopConversation = "true",
	options = {}
}
ep3_etyyy_ziven_tissak_convotemplate:addScreen(ep3_etyyy_ziven_tissak_convo_s_745)

ep3_etyyy_ziven_tissak_convo_s_573 = ConvoScreen:new {
	id = "s_573",
	leftDialog = "@conversation/ep3_etyyy_ziven_tissak:s_573", -- Very good. I don't know what to expect up there, but try to salvage Fordan's ship if at all possible...
	stopConversation = "true",
	options = {}
}
ep3_etyyy_ziven_tissak_convotemplate:addScreen(ep3_etyyy_ziven_tissak_convo_s_573)

ep3_etyyy_ziven_tissak_convo_s_574 = ConvoScreen:new {
	id = "s_574",
	leftDialog = "@conversation/ep3_etyyy_ziven_tissak:s_574", -- I understand. Not everyone has the stomach for this kind of thing.
	stopConversation = "true",
	options = {}
}
ep3_etyyy_ziven_tissak_convotemplate:addScreen(ep3_etyyy_ziven_tissak_convo_s_574)

ep3_etyyy_ziven_tissak_convo_s_1707 = ConvoScreen:new {
	id = "s_1707",
	leftDialog = "@conversation/ep3_etyyy_ziven_tissak:s_1707", -- Send him my regards as well, if you would.
	stopConversation = "true",
	options = {}
}
ep3_etyyy_ziven_tissak_convotemplate:addScreen(ep3_etyyy_ziven_tissak_convo_s_1707)

ep3_etyyy_ziven_tissak_convo_s_1711 = ConvoScreen:new {
	id = "s_1711",
	leftDialog = "@conversation/ep3_etyyy_ziven_tissak:s_1711", -- Very well. Return to me when you are ready.
	stopConversation = "true",
	options = {}
}
ep3_etyyy_ziven_tissak_convotemplate:addScreen(ep3_etyyy_ziven_tissak_convo_s_1711)

ep3_etyyy_ziven_tissak_convo_s_1723 = ConvoScreen:new {
	id = "s_1723",
	leftDialog = "@conversation/ep3_etyyy_ziven_tissak:s_1723", -- You will again be hunting webweavers, but you'll be targeting webweaver warriors. From them, I ask t...
	stopConversation = "true",
	options = {}
}
ep3_etyyy_ziven_tissak_convotemplate:addScreen(ep3_etyyy_ziven_tissak_convo_s_1723)

ep3_etyyy_ziven_tissak_convo_s_1727 = ConvoScreen:new {
	id = "s_1727",
	leftDialog = "@conversation/ep3_etyyy_ziven_tissak:s_1727", -- Very well. Return when you are ready to hunt.
	stopConversation = "true",
	options = {}
}
ep3_etyyy_ziven_tissak_convotemplate:addScreen(ep3_etyyy_ziven_tissak_convo_s_1727)

ep3_etyyy_ziven_tissak_convo_s_1739 = ConvoScreen:new {
	id = "s_1739",
	leftDialog = "@conversation/ep3_etyyy_ziven_tissak:s_1739", -- Your prey will be the feared webweaver spiders. Most of these creatures never leave the deepest murk...
	stopConversation = "true",
	options = {}
}
ep3_etyyy_ziven_tissak_convotemplate:addScreen(ep3_etyyy_ziven_tissak_convo_s_1739)

ep3_etyyy_ziven_tissak_convo_s_1743 = ConvoScreen:new {
	id = "s_1743",
	leftDialog = "@conversation/ep3_etyyy_ziven_tissak:s_1743", -- Very well. Return when you are ready to hunt.
	stopConversation = "true",
	options = {}
}
ep3_etyyy_ziven_tissak_convotemplate:addScreen(ep3_etyyy_ziven_tissak_convo_s_1743)

ep3_etyyy_ziven_tissak_convo_s_1751 = ConvoScreen:new {
	id = "s_1751",
	leftDialog = "@conversation/ep3_etyyy_ziven_tissak:s_1751", -- Tuwezz is down at the Hracca Glade gate camp. I'll upload a waypoint to your datapad to make finding...
	stopConversation = "true",
	options = {}
}
ep3_etyyy_ziven_tissak_convotemplate:addScreen(ep3_etyyy_ziven_tissak_convo_s_1751)

ep3_etyyy_ziven_tissak_convo_s_1755 = ConvoScreen:new {
	id = "s_1755",
	leftDialog = "@conversation/ep3_etyyy_ziven_tissak:s_1755", -- Very well. Return when you are ready to hunt.
	stopConversation = "true",
	options = {}
}
ep3_etyyy_ziven_tissak_convotemplate:addScreen(ep3_etyyy_ziven_tissak_convo_s_1755)

ep3_etyyy_ziven_tissak_convo_s_1767 = ConvoScreen:new {
	id = "s_1767",
	leftDialog = "@conversation/ep3_etyyy_ziven_tissak:s_1767", -- It's time he was forced to recognize hunting excellence in someone other than himself. Though based ...
	stopConversation = "true",
	options = {}
}
ep3_etyyy_ziven_tissak_convotemplate:addScreen(ep3_etyyy_ziven_tissak_convo_s_1767)

ep3_etyyy_ziven_tissak_convo_s_882 = ConvoScreen:new {
	id = "s_882",
	leftDialog = "@conversation/ep3_etyyy_ziven_tissak:s_882", -- Very well done! That should send a message to Sordaan to leave me and my clan in peace. And if not, ...
	stopConversation = "false",
	options = {
		{"@conversation/ep3_etyyy_ziven_tissak:s_263", "s_1769"},
	}
}
ep3_etyyy_ziven_tissak_convotemplate:addScreen(ep3_etyyy_ziven_tissak_convo_s_882)

ep3_etyyy_ziven_tissak_convo_s_883 = ConvoScreen:new {
	id = "s_883",
	leftDialog = "@conversation/ep3_etyyy_ziven_tissak:s_883", -- The second freighter got away. Not to worry, it's only a minor setback. We'll pick another freighter...
	stopConversation = "false",
	options = {
		{"@conversation/ep3_etyyy_ziven_tissak:s_884", "s_769"},
		{"@conversation/ep3_etyyy_ziven_tissak:s_886", "s_888"},
		{"@conversation/ep3_etyyy_ziven_tissak:s_261", "s_1769"},
	}
}
ep3_etyyy_ziven_tissak_convotemplate:addScreen(ep3_etyyy_ziven_tissak_convo_s_883)

ep3_etyyy_ziven_tissak_convo_s_763 = ConvoScreen:new {
	id = "s_763",
	leftDialog = "@conversation/ep3_etyyy_ziven_tissak:s_763", -- Destroy Sordaan's second freighter and it's escort. Sordaan hates nothing more than spending money, ...
	stopConversation = "false",
	options = {
		{"@conversation/ep3_etyyy_ziven_tissak:s_259", "s_1769"},
	}
}
ep3_etyyy_ziven_tissak_convotemplate:addScreen(ep3_etyyy_ziven_tissak_convo_s_763)

ep3_etyyy_ziven_tissak_convo_s_764 = ConvoScreen:new {
	id = "s_764",
	leftDialog = "@conversation/ep3_etyyy_ziven_tissak:s_764", -- You did well on the first freighter, but that's not enough. Go take out a second of Sordaan's freigh...
	stopConversation = "false",
	options = {
		{"@conversation/ep3_etyyy_ziven_tissak:s_766", "s_769"},
		{"@conversation/ep3_etyyy_ziven_tissak:s_772", "s_774"},
		{"@conversation/ep3_etyyy_ziven_tissak:s_257", "s_1769"},
	}
}
ep3_etyyy_ziven_tissak_convotemplate:addScreen(ep3_etyyy_ziven_tissak_convo_s_764)

ep3_etyyy_ziven_tissak_convo_s_875 = ConvoScreen:new {
	id = "s_875",
	leftDialog = "@conversation/ep3_etyyy_ziven_tissak:s_875", -- The first freighter escaped, but that's not a problem. There are plenty more of them. We'll simply s...
	stopConversation = "false",
	options = {
		{"@conversation/ep3_etyyy_ziven_tissak:s_876", "s_761"},
		{"@conversation/ep3_etyyy_ziven_tissak:s_879", "s_881"},
		{"@conversation/ep3_etyyy_ziven_tissak:s_255", "s_1769"},
	}
}
ep3_etyyy_ziven_tissak_convotemplate:addScreen(ep3_etyyy_ziven_tissak_convo_s_875)

ep3_etyyy_ziven_tissak_convo_s_765 = ConvoScreen:new {
	id = "s_765",
	leftDialog = "@conversation/ep3_etyyy_ziven_tissak:s_765", -- Destroy Sordaan's first freighter. Make sure none of his ships survive.
	stopConversation = "false",
	options = {
		{"@conversation/ep3_etyyy_ziven_tissak:s_253", "s_1769"},
	}
}
ep3_etyyy_ziven_tissak_convotemplate:addScreen(ep3_etyyy_ziven_tissak_convo_s_765)

ep3_etyyy_ziven_tissak_convo_s_576 = ConvoScreen:new {
	id = "s_576",
	leftDialog = "@conversation/ep3_etyyy_ziven_tissak:s_576", -- I appreciate you recovering that ship. My technicians were able to learn some things and I now know ...
	stopConversation = "false",
	options = {
		{"@conversation/ep3_etyyy_ziven_tissak:s_758", "s_761"},
		{"@conversation/ep3_etyyy_ziven_tissak:s_759", "s_762"},
		{"@conversation/ep3_etyyy_ziven_tissak:s_251", "s_1769"},
	}
}
ep3_etyyy_ziven_tissak_convotemplate:addScreen(ep3_etyyy_ziven_tissak_convo_s_576)

ep3_etyyy_ziven_tissak_convo_s_575 = ConvoScreen:new {
	id = "s_575",
	leftDialog = "@conversation/ep3_etyyy_ziven_tissak:s_575", -- I heard about the attacks, and you're inability to recover Fordan's ship. We've reacquired the locat...
	stopConversation = "false",
	options = {
		{"@conversation/ep3_etyyy_ziven_tissak:s_578", "s_580"},
		{"@conversation/ep3_etyyy_ziven_tissak:s_582", "s_584"},
		{"@conversation/ep3_etyyy_ziven_tissak:s_249", "s_1769"},
	}
}
ep3_etyyy_ziven_tissak_convotemplate:addScreen(ep3_etyyy_ziven_tissak_convo_s_575)

ep3_etyyy_ziven_tissak_convo_s_748 = ConvoScreen:new {
	id = "s_748",
	leftDialog = "@conversation/ep3_etyyy_ziven_tissak:s_748", -- Launch into space and head to the location we upload to you for Fordan's ship.
	stopConversation = "false",
	options = {
		{"@conversation/ep3_etyyy_ziven_tissak:s_247", "s_1769"},
	}
}
ep3_etyyy_ziven_tissak_convotemplate:addScreen(ep3_etyyy_ziven_tissak_convo_s_748)

ep3_etyyy_ziven_tissak_convo_s_366 = ConvoScreen:new {
	id = "s_366",
	leftDialog = "@conversation/ep3_etyyy_ziven_tissak:s_366", -- I just received some disturbing news. A friend of mine, Fordan Szholz, was on his way to Kashyyyk bu...
	stopConversation = "false",
	options = {
		{"@conversation/ep3_etyyy_ziven_tissak:s_571", "s_573"},
		{"@conversation/ep3_etyyy_ziven_tissak:s_572", "s_574"},
		{"@conversation/ep3_etyyy_ziven_tissak:s_245", "s_1769"},
	}
}
ep3_etyyy_ziven_tissak_convotemplate:addScreen(ep3_etyyy_ziven_tissak_convo_s_366)

ep3_etyyy_ziven_tissak_convo_s_1699 = ConvoScreen:new {
	id = "s_1699",
	leftDialog = "@conversation/ep3_etyyy_ziven_tissak:s_1699", -- Good hunting to you.
	stopConversation = "false",
	options = {
		{"@conversation/ep3_etyyy_ziven_tissak:s_1701", "s_1769"},
	}
}
ep3_etyyy_ziven_tissak_convotemplate:addScreen(ep3_etyyy_ziven_tissak_convo_s_1699)

ep3_etyyy_ziven_tissak_convo_s_1703 = ConvoScreen:new {
	id = "s_1703",
	leftDialog = "@conversation/ep3_etyyy_ziven_tissak:s_1703", -- Again you amaze me. These are 2 of the most perfect webweaver eyes I've yet seen. Good hunting indee...
	stopConversation = "false",
	options = {
		{"@conversation/ep3_etyyy_ziven_tissak:s_1705", "s_1707"},
		{"@conversation/ep3_etyyy_ziven_tissak:s_1709", "s_1711"},
		{"@conversation/ep3_etyyy_ziven_tissak:s_1713", "s_1769"},
	}
}
ep3_etyyy_ziven_tissak_convotemplate:addScreen(ep3_etyyy_ziven_tissak_convo_s_1703)

ep3_etyyy_ziven_tissak_convo_s_1715 = ConvoScreen:new {
	id = "s_1715",
	leftDialog = "@conversation/ep3_etyyy_ziven_tissak:s_1715", -- You'll find webweaver warriors in the southeast corner of Etyyy. They are usually further in along t...
	stopConversation = "false",
	options = {
		{"@conversation/ep3_etyyy_ziven_tissak:s_1717", "s_1769"},
	}
}
ep3_etyyy_ziven_tissak_convotemplate:addScreen(ep3_etyyy_ziven_tissak_convo_s_1715)

ep3_etyyy_ziven_tissak_convo_s_1719 = ConvoScreen:new {
	id = "s_1719",
	leftDialog = "@conversation/ep3_etyyy_ziven_tissak:s_1719", -- The things I've heard about your hunting skills have been proven to be accurate. But are you ready f...
	stopConversation = "false",
	options = {
		{"@conversation/ep3_etyyy_ziven_tissak:s_1721", "s_1723"},
		{"@conversation/ep3_etyyy_ziven_tissak:s_1725", "s_1727"},
		{"@conversation/ep3_etyyy_ziven_tissak:s_1729", "s_1769"},
	}
}
ep3_etyyy_ziven_tissak_convotemplate:addScreen(ep3_etyyy_ziven_tissak_convo_s_1719)

ep3_etyyy_ziven_tissak_convo_s_1731 = ConvoScreen:new {
	id = "s_1731",
	leftDialog = "@conversation/ep3_etyyy_ziven_tissak:s_1731", -- Gather 38 webweaver fangs. You'll find webweavers down toward the southeast corner of the hunting gr...
	stopConversation = "false",
	options = {
		{"@conversation/ep3_etyyy_ziven_tissak:s_1733", "s_1769"},
	}
}
ep3_etyyy_ziven_tissak_convotemplate:addScreen(ep3_etyyy_ziven_tissak_convo_s_1731)

ep3_etyyy_ziven_tissak_convo_s_1735 = ConvoScreen:new {
	id = "s_1735",
	animation = "greet",
	leftDialog = "@conversation/ep3_etyyy_ziven_tissak:s_1735", -- You've come back to me quite the accomplished hunter. And I hope to continue your growth. Are you re...
	stopConversation = "false",
	options = {
		{"@conversation/ep3_etyyy_ziven_tissak:s_1737", "s_1739"},
		{"@conversation/ep3_etyyy_ziven_tissak:s_1741", "s_1743"},
		{"@conversation/ep3_etyyy_ziven_tissak:s_1745", "s_1769"},
	}
}
ep3_etyyy_ziven_tissak_convotemplate:addScreen(ep3_etyyy_ziven_tissak_convo_s_1735)

ep3_etyyy_ziven_tissak_convo_s_1747 = ConvoScreen:new {
	id = "s_1747",
	leftDialog = "@conversation/ep3_etyyy_ziven_tissak:s_1747", -- Welcome to Etyyy! Hopefully you will fare better than the last hunters that Kerssoc was foolish enou...
	stopConversation = "false",
	options = {
		{"@conversation/ep3_etyyy_ziven_tissak:s_1749", "s_1751"},
		{"@conversation/ep3_etyyy_ziven_tissak:s_1753", "s_1755"},
		{"@conversation/ep3_etyyy_ziven_tissak:s_1757", "s_1769"},
	}
}
ep3_etyyy_ziven_tissak_convotemplate:addScreen(ep3_etyyy_ziven_tissak_convo_s_1747)

ep3_etyyy_ziven_tissak_convo_s_1759 = ConvoScreen:new {
	id = "s_1759",
	leftDialog = "@conversation/ep3_etyyy_ziven_tissak:s_1759", -- Greetings, young hunter. May your weapon never miss its mark.
	stopConversation = "false",
	options = {
		{"@conversation/ep3_etyyy_ziven_tissak:s_1761", "s_1769"},
	}
}
ep3_etyyy_ziven_tissak_convotemplate:addScreen(ep3_etyyy_ziven_tissak_convo_s_1759)

addConversationTemplate("ep3_etyyy_ziven_tissak_convotemplate", ep3_etyyy_ziven_tissak_convotemplate);
