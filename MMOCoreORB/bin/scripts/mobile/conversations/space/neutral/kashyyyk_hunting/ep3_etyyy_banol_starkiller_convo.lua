-- Banol Starkiller -- Sordaan Xris's fixer, who runs the dirty work against Tripp Rar and Ziven.
--
-- Giver for the two Kashyyyk hunting quest heads that had no giver:
--
--   assassinate/ep3_hunting_banol_destroy_tripps_goods  (KashyyykHuntingScreenplay.lua global line
--                                                        338, registered line 376)
--   recovery/ep3_hunting_banol_capture_fordan           (global line 378, registered line 441)
--
-- Before this file nothing in the repo gave either quest out.
--
-- EVERY leftDialog and EVERY option below is a verbatim shipped key from
-- conversation/ep3_etyyy_banol_starkiller.stf. Nothing is authored.
--
-- The two pitches match the screenplays field for field:
--   s_560 "I've been seeing to it that any shipments of hunting goods that Tripp tries to send off of
--   the planet hit a minor bump... I want you to go destroy one of her shipments. Be sure to take out
--   any witnesses as well." == assassinateSpawns target rod_protector_ace_tier5 plus escorts
--   rod_protector_tier4/tier4/tier5, targetPatrols kash_hunting_tripps_goods_1..4 leaving Tripp's
--   Rodian Hunter Outpost, questZone space_kashyyyk.
--   s_530 "That punk, Ziven, is expecting the arrival of a friend of his named Fordan Szholz... I want
--   you to capture Fordan's ship after he arrives in Kashyyyk space, and deliver the captured hunter
--   to my agents." == recoverShip rod_protector_ace_tier5, preRecoveryPoints
--   kash_hunting_capture_fordan_1..4 (await the arrival) then recoveryPoints 5..7 ending at Sordaan's
--   Rodian Hunter Outpost (Banol's agents), questZone space_kashyyyk.
--   s_534 "Launch into Kashyyyk space and await further word on Fordan's arrival." == arrivalDelay 12.
--
-- FLAGGED INTERPRETATION -- SCREEN TOPOLOGY. The client ships no screen graph. The blocks below are
-- read off the .stf's own key order and its yes/no pairings; the order in which the handler selects
-- between blocks is ours.
--
-- FLAGGED INTERPRETATION -- REUSED ACCEPT REPLY s_520. Four of the shipped offer blocks (s_486,
-- s_496, s_506, s_542) ship a "Yes, I'll do it." option with no NPC reply key of its own; only the
-- s_516 block ships one, s_520 "Good. You know the drill." Because a ConvoScreen must carry a
-- leftDialog, s_520 is reused as the landing screen for those accepts. The text is client fact; three
-- of its four placements are not. (s_546 "Good. You know the drill. Return to me when it's done." is
-- the shipped reply inside the s_542 block and is used there.)
--
-- FLAGGED INTERPRETATION -- s_752 AS THE BUSY SCREEN. The .stf ships four byte-identical copies of
-- "It looks like you already have a mission in space. Come back once you've completed that one."
-- (s_752, s_753, s_754, s_755), one per accept point. s_752 is used for a player who is currently
-- holding one of Banol's two quests -- there the sentence is literally true and no interpretation is
-- involved. s_753 carries the flight gate below. s_754 and s_755 are left unused rather than given
-- invented distinctions.
--
-- UNUSED SHIPPED KEYS:
--   s_484 -- empty in the client.
--   s_754, s_755 -- byte-identical duplicates of s_752/s_753; see above.
--
-- REACHABILITY: ep3_etyyy_banol_starkiller is not spawned anywhere in this repo and there is no
-- Kashyyyk ground zone in config.lua ZonesEnabled. See the handler header.

ep3_etyyy_banol_starkiller_convotemplate = ConvoTemplate:new {
	initialScreen = "ep3_banol_greeting",
	templateType = "Lua",
	luaClassHandler = "Ep3EtyyyBanolStarkillerConvoHandler",
	screens = {}
}

--[[
	FLAGGED INTERPRETATION -- THE SORDAAN REFERRAL. s_556 opens "Sordaan wanted me to throw some work
	your way. Lost one of his bets, eh?", so the client's Banol expects the player to arrive referred by
	Sordaan Xris. s_570 is the brush-off for anyone who has not been sent. There is no Sordaan Xris
	conversation anywhere in this repo (his .stf ships 162 entries and is a ground chain nobody has
	built), so gating on a referral flag nothing can ever write would leave both of Banol's quests
	permanently unreachable. The handler therefore carries BANOL_REQUIRE_SORDAAN_REFERRAL = false: the
	referral is treated as satisfied, and this screen is reachable only once that constant is flipped.
	The text is client fact; treating the referral as satisfied is ours, and it is a one-line revert.
]]
ep3_banol_brushoff = ConvoScreen:new {
	id = "ep3_banol_brushoff",
	leftDialog = "@conversation/ep3_etyyy_banol_starkiller:s_570", --What? What are you looking at? Huh? Do I look like I'm here for your entertainment? Well, I'm not. So, fly away little bird.
	stopConversation = "true",
	options = {}
}
ep3_etyyy_banol_starkiller_convotemplate:addScreen(ep3_banol_brushoff);

ep3_banol_greeting = ConvoScreen:new {
	id = "ep3_banol_greeting",
	leftDialog = "@conversation/ep3_etyyy_banol_starkiller:s_556", --What? Oh yeah, right. Sordaan wanted me to throw some work your way. Lost one of his bets, eh? No, don't tell me the gruesome details. I really don't care. So let's see. Ah perfect. You can help me with a slightly sensitive project I've been working on.
	stopConversation = "false",
	options = {
		{"@conversation/ep3_etyyy_banol_starkiller:s_558", "ep3_banol_pitch"}, --What's the project?
	}
}
ep3_etyyy_banol_starkiller_convotemplate:addScreen(ep3_banol_greeting);

ep3_banol_pitch = ConvoScreen:new {
	id = "ep3_banol_pitch",
	leftDialog = "@conversation/ep3_etyyy_banol_starkiller:s_560", --There's this other hunter in the camp. You might have seen her, Tripp Rar. Sordaan doesn't like her very much, and by extension, that means I don't like her much either. I've been seeing to it that any shipments of hunting goods that Tripp tries to send off of the planet hit a minor bump. More to the point, they get destroyed whenever possible. I want you to go destroy one of her shipments. Be sure to take out any witnesses as well.
	stopConversation = "false",
	options = {
		{"@conversation/ep3_etyyy_banol_starkiller:s_562", "ep3_banol_accept"}, --Okay, I'll do it.
		{"@conversation/ep3_etyyy_banol_starkiller:s_566", "ep3_banol_decline"}, --Um, no thanks.
	}
}
ep3_etyyy_banol_starkiller_convotemplate:addScreen(ep3_banol_pitch);

-- The grant of assassinate/ep3_hunting_banol_destroy_tripps_goods happens in the handler on this id.
ep3_banol_accept = ConvoScreen:new {
	id = "ep3_banol_accept",
	leftDialog = "@conversation/ep3_etyyy_banol_starkiller:s_564", --Good, good. Intercept them in Kashyyyk space. Oh, and return to me when it's done. I look forward to hearing about your success.
	stopConversation = "true",
	options = {}
}
ep3_etyyy_banol_starkiller_convotemplate:addScreen(ep3_banol_accept);

ep3_banol_decline = ConvoScreen:new {
	id = "ep3_banol_decline",
	leftDialog = "@conversation/ep3_etyyy_banol_starkiller:s_568", --Don't have the stomach for this kind of thing? Fine. But if you change your mind, I'm not going anywhere.
	stopConversation = "true",
	options = {}
}
ep3_etyyy_banol_starkiller_convotemplate:addScreen(ep3_banol_decline);

-- Player is currently holding one of Banol's two space quests. The line is literally accurate here.
ep3_banol_busy = ConvoScreen:new {
	id = "ep3_banol_busy",
	leftDialog = "@conversation/ep3_etyyy_banol_starkiller:s_752", --It looks like you already have a mission in space. Come back once you've completed that one.
	stopConversation = "true",
	options = {}
}
ep3_etyyy_banol_starkiller_convotemplate:addScreen(ep3_banol_busy);

--[[
	FLAGGED INTERPRETATION -- THE FLIGHT GATE. The engine exposes no generic "player holds any space
	mission" test: space_helpers.lua only offers isSpaceQuestActive / isSpaceQuestTaskActive /
	isSpaceQuestComplete / isSpaceQuestTaskComplete for a NAMED quest, and MissionObject.idl:479 only
	exposes isSpaceDutyMission(). This screen therefore fires on the conditions the handler can
	actually see at an accept point: JTL off, not a pilot, or no certified ship. The text is client
	fact; that trigger is not.
]]
ep3_banol_no_space = ConvoScreen:new {
	id = "ep3_banol_no_space",
	leftDialog = "@conversation/ep3_etyyy_banol_starkiller:s_753", --It looks like you already have a mission in space. Come back once you've completed that one.
	stopConversation = "true",
	options = {}
}
ep3_etyyy_banol_starkiller_convotemplate:addScreen(ep3_banol_no_space);

--[[
	FLAGGED INTERPRETATION -- FAILURE DETECTION. s_486 "What happened? How hard is it to stop a
	shipment of goods from leaving the system?" is written for a player who took the shipment job and
	lost it. SpaceAssassinateScreenplay leaves no distinguishable failure record the conversation can
	read, so this handler cannot separate "failed it" from "walked away": it shows this block to
	anyone who once accepted and no longer has the quest active or complete. The text is client fact;
	that trigger is not.
]]
ep3_banol_failed = ConvoScreen:new {
	id = "ep3_banol_failed",
	leftDialog = "@conversation/ep3_etyyy_banol_starkiller:s_486", --What happened? How hard is it to stop a shipment of goods from leaving the system? Tripp has another shipment scheduled. Would you like to try again? Do you think you could do it right this time?
	stopConversation = "false",
	options = {
		{"@conversation/ep3_etyyy_banol_starkiller:s_488", "ep3_banol_retry"}, --Yes, I'll do it.
		{"@conversation/ep3_etyyy_banol_starkiller:s_492", "ep3_banol_retry_no"}, --No, thank you.
	}
}
ep3_etyyy_banol_starkiller_convotemplate:addScreen(ep3_banol_failed);

-- Re-grant happens in the handler on this id. leftDialog is the reused s_520; see the header.
ep3_banol_retry = ConvoScreen:new {
	id = "ep3_banol_retry",
	leftDialog = "@conversation/ep3_etyyy_banol_starkiller:s_520", --Good. You know the drill.
	stopConversation = "true",
	options = {}
}
ep3_etyyy_banol_starkiller_convotemplate:addScreen(ep3_banol_retry);

ep3_banol_retry_no = ConvoScreen:new {
	id = "ep3_banol_retry_no",
	leftDialog = "@conversation/ep3_etyyy_banol_starkiller:s_494", --Yeah, alright. If you change you're mind, let me know.
	stopConversation = "true",
	options = {}
}
ep3_etyyy_banol_starkiller_convotemplate:addScreen(ep3_banol_retry_no);

-- Idle re-offer: the shipment job has been done at least once and the Fordan pitch has already been
-- put to the player. Accepting here clears the "Fordan pitched" latch, so finishing the shipment
-- again brings s_526 back -- which is what s_526 itself says ("You did pretty good taking out Tripp's
-- LATEST shipment").
ep3_banol_reoffer = ConvoScreen:new {
	id = "ep3_banol_reoffer",
	leftDialog = "@conversation/ep3_etyyy_banol_starkiller:s_496", --Looking for something to do? Tripp has another shipment scheduled. Would you like to go destroy it?
	stopConversation = "false",
	options = {
		{"@conversation/ep3_etyyy_banol_starkiller:s_498", "ep3_banol_reoffer_accept"}, --Yes, I'll do it.
		{"@conversation/ep3_etyyy_banol_starkiller:s_502", "ep3_banol_reoffer_no"}, --No, thank you.
	}
}
ep3_etyyy_banol_starkiller_convotemplate:addScreen(ep3_banol_reoffer);

ep3_banol_reoffer_accept = ConvoScreen:new {
	id = "ep3_banol_reoffer_accept",
	leftDialog = "@conversation/ep3_etyyy_banol_starkiller:s_520", --Good. You know the drill.
	stopConversation = "true",
	options = {}
}
ep3_etyyy_banol_starkiller_convotemplate:addScreen(ep3_banol_reoffer_accept);

ep3_banol_reoffer_no = ConvoScreen:new {
	id = "ep3_banol_reoffer_no",
	leftDialog = "@conversation/ep3_etyyy_banol_starkiller:s_504", --Yeah, alright. If you change you're mind, let me know.
	stopConversation = "true",
	options = {}
}
ep3_etyyy_banol_starkiller_convotemplate:addScreen(ep3_banol_reoffer_no);

--[[
	The Fordan job was taken and lost. s_506 is explicit that this is permanent -- "Reports say he's
	left the system... I should have taken care of that one myself, but it's over" -- so after a failed
	capture the recovery quest is not offered again, exactly as the client text states. All that
	remains is the repeatable shipment job. Same failure-detection caveat as ep3_banol_failed above.
]]
ep3_banol_fordan_failed = ConvoScreen:new {
	id = "ep3_banol_fordan_failed",
	leftDialog = "@conversation/ep3_etyyy_banol_starkiller:s_506", --You let Fordan slip away? I can't believe it. Reports say he's left the system. If he returns, he'll be ready for another attempt and will probably be as heavily armed as possible. I should have taken care of that one myself, but it's over. No point in worrying about it now. If you want to make it up to me, Tripp has another shipment loading up. Go take out that shipment before they can leave the system.
	stopConversation = "false",
	options = {
		{"@conversation/ep3_etyyy_banol_starkiller:s_508", "ep3_banol_fordan_failed_accept"}, --Yes, I'll do it.
		{"@conversation/ep3_etyyy_banol_starkiller:s_512", "ep3_banol_fordan_failed_no"}, --No, thank you.
	}
}
ep3_etyyy_banol_starkiller_convotemplate:addScreen(ep3_banol_fordan_failed);

ep3_banol_fordan_failed_accept = ConvoScreen:new {
	id = "ep3_banol_fordan_failed_accept",
	leftDialog = "@conversation/ep3_etyyy_banol_starkiller:s_520", --Good. You know the drill.
	stopConversation = "true",
	options = {}
}
ep3_etyyy_banol_starkiller_convotemplate:addScreen(ep3_banol_fordan_failed_accept);

ep3_banol_fordan_failed_no = ConvoScreen:new {
	id = "ep3_banol_fordan_failed_no",
	leftDialog = "@conversation/ep3_etyyy_banol_starkiller:s_514", --Yeah, alright. If you change you're mind, let me know.
	stopConversation = "true",
	options = {}
}
ep3_etyyy_banol_starkiller_convotemplate:addScreen(ep3_banol_fordan_failed_no);

-- The Fordan capture succeeded. This is Banol's standing screen from then on; s_520 below is the
-- shipped reply to s_518, so this is the one block where s_520 sits where the client put it.
ep3_banol_fordan_praise = ConvoScreen:new {
	id = "ep3_banol_fordan_praise",
	leftDialog = "@conversation/ep3_etyyy_banol_starkiller:s_516", --That business with Fordan went pretty well. I'm impressed by your abilities, and I don't impress easily. Tripp has another shipment scheduled. Would you like to take it out?
	stopConversation = "false",
	options = {
		{"@conversation/ep3_etyyy_banol_starkiller:s_518", "ep3_banol_praise_accept"}, --Yes, I'll do it.
		{"@conversation/ep3_etyyy_banol_starkiller:s_522", "ep3_banol_praise_no"}, --No, thank you.
	}
}
ep3_etyyy_banol_starkiller_convotemplate:addScreen(ep3_banol_fordan_praise);

ep3_banol_praise_accept = ConvoScreen:new {
	id = "ep3_banol_praise_accept",
	leftDialog = "@conversation/ep3_etyyy_banol_starkiller:s_520", --Good. You know the drill.
	stopConversation = "true",
	options = {}
}
ep3_etyyy_banol_starkiller_convotemplate:addScreen(ep3_banol_praise_accept);

ep3_banol_praise_no = ConvoScreen:new {
	id = "ep3_banol_praise_no",
	leftDialog = "@conversation/ep3_etyyy_banol_starkiller:s_524", --Yeah, alright. If you change you're mind, let me know.
	stopConversation = "true",
	options = {}
}
ep3_etyyy_banol_starkiller_convotemplate:addScreen(ep3_banol_praise_no);

-- Shipment job done, Fordan not yet offered. s_552/s_554 are the outright decline of this screen:
-- "You did good, so I let it slide" answers "You did pretty good taking out Tripp's latest shipment".
ep3_banol_fordan_intro = ConvoScreen:new {
	id = "ep3_banol_fordan_intro",
	leftDialog = "@conversation/ep3_etyyy_banol_starkiller:s_526", --You did pretty good taking out Tripp's latest shipment. I'm happy with the results. Any interest in another little project I've got brewing?
	stopConversation = "false",
	options = {
		{"@conversation/ep3_etyyy_banol_starkiller:s_528", "ep3_banol_fordan_pitch"}, --Sure, what's the plan?
		{"@conversation/ep3_etyyy_banol_starkiller:s_552", "ep3_banol_fordan_brush"}, --No, thank you.
	}
}
ep3_etyyy_banol_starkiller_convotemplate:addScreen(ep3_banol_fordan_intro);

ep3_banol_fordan_pitch = ConvoScreen:new {
	id = "ep3_banol_fordan_pitch",
	leftDialog = "@conversation/ep3_etyyy_banol_starkiller:s_530", --That punk, Ziven, is expecting the arrival of a friend of his named Fordan Szholz. This Szholz is reported to be a highly skilled hunter. Sordaan has asked me to see to it that he doesn't arrive on Kashyyyk. I want you to capture Fordan's ship after he arrives in Kashyyyk space, and deliver the captured hunter to my agents. They'll take care of the rest.
	stopConversation = "false",
	options = {
		{"@conversation/ep3_etyyy_banol_starkiller:s_532", "ep3_banol_fordan_accept"}, --I'll do it.
		{"@conversation/ep3_etyyy_banol_starkiller:s_536", "ep3_banol_fordan_decline"}, --Um, no thanks. Kidnapping is not my thing.
	}
}
ep3_etyyy_banol_starkiller_convotemplate:addScreen(ep3_banol_fordan_pitch);

-- The grant of recovery/ep3_hunting_banol_capture_fordan happens in the handler on this id.
ep3_banol_fordan_accept = ConvoScreen:new {
	id = "ep3_banol_fordan_accept",
	leftDialog = "@conversation/ep3_etyyy_banol_starkiller:s_534", --Good. Launch into Kashyyyk space and await further word on Fordan's arrival.
	stopConversation = "true",
	options = {}
}
ep3_etyyy_banol_starkiller_convotemplate:addScreen(ep3_banol_fordan_accept);

-- s_540 is a shipped player option with no shipped parent screen of its own. It is hung here because
-- "Is there anything else I could do?" only makes sense right after refusing a job, and s_542 answers
-- it with the shipment job. FLAGGED INTERPRETATION -- the text is client fact, this placement is ours.
ep3_banol_fordan_decline = ConvoScreen:new {
	id = "ep3_banol_fordan_decline",
	leftDialog = "@conversation/ep3_etyyy_banol_starkiller:s_538", --Yeah, okay. Whatever.
	stopConversation = "false",
	options = {
		{"@conversation/ep3_etyyy_banol_starkiller:s_540", "ep3_banol_else"}, --Is there anything else I could do?
	}
}
ep3_etyyy_banol_starkiller_convotemplate:addScreen(ep3_banol_fordan_decline);

ep3_banol_fordan_brush = ConvoScreen:new {
	id = "ep3_banol_fordan_brush",
	leftDialog = "@conversation/ep3_etyyy_banol_starkiller:s_554", --Yeah, alright. You did good, so I let it slide. But if you change you're mind, let me know.
	stopConversation = "true",
	options = {}
}
ep3_etyyy_banol_starkiller_convotemplate:addScreen(ep3_banol_fordan_brush);

ep3_banol_else = ConvoScreen:new {
	id = "ep3_banol_else",
	leftDialog = "@conversation/ep3_etyyy_banol_starkiller:s_542", --Yeah, I guess. Tripp has another shipment scheduled. Interested in hitting that again?
	stopConversation = "false",
	options = {
		{"@conversation/ep3_etyyy_banol_starkiller:s_544", "ep3_banol_else_accept"}, --I'll do it.
		{"@conversation/ep3_etyyy_banol_starkiller:s_548", "ep3_banol_else_no"}, --Um, no thanks.
	}
}
ep3_etyyy_banol_starkiller_convotemplate:addScreen(ep3_banol_else);

ep3_banol_else_accept = ConvoScreen:new {
	id = "ep3_banol_else_accept",
	leftDialog = "@conversation/ep3_etyyy_banol_starkiller:s_546", --Good. You know the drill. Return to me when it's done.
	stopConversation = "true",
	options = {}
}
ep3_etyyy_banol_starkiller_convotemplate:addScreen(ep3_banol_else_accept);

ep3_banol_else_no = ConvoScreen:new {
	id = "ep3_banol_else_no",
	leftDialog = "@conversation/ep3_etyyy_banol_starkiller:s_550", --Yeah, alright. If you change you're mind, let me know.
	stopConversation = "true",
	options = {}
}
ep3_etyyy_banol_starkiller_convotemplate:addScreen(ep3_banol_else_no);

addConversationTemplate("ep3_etyyy_banol_starkiller_convotemplate", ep3_etyyy_banol_starkiller_convotemplate);
