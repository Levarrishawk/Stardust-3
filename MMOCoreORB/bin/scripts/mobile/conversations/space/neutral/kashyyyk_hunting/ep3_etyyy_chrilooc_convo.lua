-- Chrilooc -- the Kachirho fixer who trades what he knows about Brody Johnson for a space job.
--
-- Giver for recovery/ep3_hunting_chrilooc_medical_supplies (KashyyykHuntingScreenplay.lua, global at
-- line 591, registered line 652). Before this file nothing in the repo gave that quest out.
--
-- EVERY leftDialog and EVERY option below is a verbatim shipped key from
-- conversation/ep3_etyyy_chrilooc.stf (51 entries). Nothing is authored.
--
-- The pitch matches the screenplay field for field: s_440 "I want you to intercept a shipment of
-- supplies inbound to the Kashyyyk system. You'll be relieving some Gotal bandits of them" is
-- recoverShip = "gotal_warlord_tier5" with escortShips gotal_bandit_tier4/5 in questZone
-- space_kashyyyk; s_446 "You can launch into space from the starport here in town" is that same
-- questZone; and s_390 "the medical supplies ... secured by my people" is the completion.
--
-- FLAGGED INTERPRETATION -- SCREEN TOPOLOGY. The client ships no screen graph. The order used here
-- is a depth-first walk of the .stf's own key order.
--
-- ETYYY ACCESS IS NOT INVENTED. s_384 "Do whatever Kerssoc asks, and he should let you in" and s_394
-- "you're already working with Kerssoc ... Kerssoc can grant you access" are read off the flag
-- Kerssoc's own handler already writes, EP3_KERSSOC_ACCESS_KEY (":ep3_etyyy_kerssoc:etyyy", set at
-- ep3EtyyyKerssocConvoHandler.lua:222). Nothing new is stored for it.
--
-- JOHNSON SMITH LEG NOT BUILT. s_368 and s_366 are written for a player who has already dealt with
-- Johnson Smith. There is no Johnson Smith giver in this repo (his .stf ships, his mobile
-- ep3_etyyy_johnson_smith.lua ships, no conversation does), so nothing sets that flag yet. The two
-- screens are declared and the one flag key they read is documented in the handler, so a future
-- Johnson Smith handler needs to write one value and change nothing here.
--
-- UNUSED SHIPPED KEYS, with reasons:
--   s_362  empty string in the client file.
--   s_364  a Shyriiwook line with no shipped translation and no shipped screen that reaches it.
--   s_456  "Oh, that's too bad. Never mind." / s_458 "Right. Good bye." -- a shipped decline pair
--          with no shipped parent. Attaching them anywhere would be inventing the parent, so they
--          are left out rather than guessed at.
--   s_460  "The forests will never be the same." -- an ambient line with no shipped parent screen
--          and no option that reaches it.

ep3_etyyy_chrilooc_convotemplate = ConvoTemplate:new {
	initialScreen = "ep3_chrilooc_greeting",
	templateType = "Lua",
	luaClassHandler = "Ep3EtyyyChriloocConvoHandler",
	screens = {}
}

ep3_chrilooc_greeting = ConvoScreen:new {
	id = "ep3_chrilooc_greeting",
	leftDialog = "@conversation/ep3_etyyy_chrilooc:s_432", --What do you want? I have no patience or time for... ah, I see. You're looking for Brody Johnson. I'm sorry. I have nothing to say on that subject.
	stopConversation = "false",
	options = {
		{"@conversation/ep3_etyyy_chrilooc:s_434", "ep3_chrilooc_wrelaac"}, --Are you sure? Wrelaac said Brody spoke to you.
		{"@conversation/ep3_etyyy_chrilooc:s_452", "ep3_chrilooc_farewell"}, --No thanks.
	}
}
ep3_etyyy_chrilooc_convotemplate:addScreen(ep3_chrilooc_greeting);

ep3_chrilooc_wrelaac = ConvoScreen:new {
	id = "ep3_chrilooc_wrelaac",
	leftDialog = "@conversation/ep3_etyyy_chrilooc:s_436", --Yes, I'm... wait, come to think of it, you may be of use to me. I do remember Brody Johnson and would be willing to help you if in exchange you are willing to help me.
	stopConversation = "false",
	options = {
		{"@conversation/ep3_etyyy_chrilooc:s_438", "ep3_chrilooc_pitch"}, --Okay, what do you want me to do?
	}
}
ep3_etyyy_chrilooc_convotemplate:addScreen(ep3_chrilooc_wrelaac);

ep3_chrilooc_pitch = ConvoScreen:new {
	id = "ep3_chrilooc_pitch",
	leftDialog = "@conversation/ep3_etyyy_chrilooc:s_440", --I and my associates are in need of medical supplies. Times are especially tough at the moment, and one cannot be overly prepared. But we lack the resources necessary to get them via the normal channels. Therefore, I want you to intercept a shipment of supplies inbound to the Kashyyyk system. You'll be relieving some Gotal bandits of them. And trust me, those bandits didn't pay for those supplies either.
	stopConversation = "false",
	options = {
		{"@conversation/ep3_etyyy_chrilooc:s_442", "ep3_chrilooc_accept"}, --Very well. I'll do it.
		{"@conversation/ep3_etyyy_chrilooc:s_448", "ep3_chrilooc_decline"}, --No thanks. Sounds too risky.
	}
}
ep3_etyyy_chrilooc_convotemplate:addScreen(ep3_chrilooc_pitch);

-- The grant happens in the handler on this screen id.
ep3_chrilooc_accept = ConvoScreen:new {
	id = "ep3_chrilooc_accept",
	leftDialog = "@conversation/ep3_etyyy_chrilooc:s_446", --Very good. You can launch into space from the starport here in town. Return to me after the medical supplies have been secured by my people.
	stopConversation = "true",
	options = {}
}
ep3_etyyy_chrilooc_convotemplate:addScreen(ep3_chrilooc_accept);

--[[
	FLAGGED INTERPRETATION -- THE SPACE GATE. s_444 (and its twin s_418 on the retry arc) reads "It
	looks like you already have a mission in space. Come back once you've completed that one." The
	engine exposes no generic "player holds any space mission" test: space_helpers.lua only offers
	isSpaceQuestActive / isSpaceQuestTaskActive / isSpaceQuestComplete / isSpaceQuestTaskComplete for
	a NAMED quest, and MissionObject.idl:479 only exposes isSpaceDutyMission(). So this screen fires
	on the conditions the handler can actually see: JTL off, not a pilot, or no certified ship. The
	text is client fact; that trigger is not. Widen it here if a generic test is ever added.
]]
ep3_chrilooc_no_space = ConvoScreen:new {
	id = "ep3_chrilooc_no_space",
	leftDialog = "@conversation/ep3_etyyy_chrilooc:s_444", --It looks like you already have a mission in space. Come back once you've completed that one.
	stopConversation = "true",
	options = {}
}
ep3_etyyy_chrilooc_convotemplate:addScreen(ep3_chrilooc_no_space);

ep3_chrilooc_decline = ConvoScreen:new {
	id = "ep3_chrilooc_decline",
	leftDialog = "@conversation/ep3_etyyy_chrilooc:s_450", --Guess you weren't serious about finding Brody Johnson. So be it.
	stopConversation = "true",
	options = {}
}
ep3_etyyy_chrilooc_convotemplate:addScreen(ep3_chrilooc_decline);

-- Recovery running.
ep3_chrilooc_busy = ConvoScreen:new {
	id = "ep3_chrilooc_busy",
	leftDialog = "@conversation/ep3_etyyy_chrilooc:s_426", --Launch into Kashyyyk space and intercept those medical supplies.
	stopConversation = "false",
	options = {
		{"@conversation/ep3_etyyy_chrilooc:s_428", "ep3_chrilooc_busy_ack"}, --I'm on my way.
	}
}
ep3_etyyy_chrilooc_convotemplate:addScreen(ep3_chrilooc_busy);

ep3_chrilooc_busy_ack = ConvoScreen:new {
	id = "ep3_chrilooc_busy_ack",
	leftDialog = "@conversation/ep3_etyyy_chrilooc:s_430", --Return when you are done.
	stopConversation = "true",
	options = {}
}
ep3_etyyy_chrilooc_convotemplate:addScreen(ep3_chrilooc_busy_ack);

--[[
	FLAGGED INTERPRETATION -- FAILURE DETECTION. s_414 "Maybe things didn't go so well last time" is
	written for a player who took the recovery and lost it. SpaceRecoveryScreenplay leaves no
	distinguishable failure record the conversation can read, so this handler cannot separate "lost
	the shipment" from "walked away": it shows this arc to anyone who once accepted and no longer has
	the quest active or complete. The text is client fact; that trigger is not.
]]
ep3_chrilooc_failed = ConvoScreen:new {
	id = "ep3_chrilooc_failed",
	leftDialog = "@conversation/ep3_etyyy_chrilooc:s_414", --Look, we really need medical supplies. I'm going to have to insist that you help us with those. Maybe things didn't go so well last time, but you're simply going to have to try again if you want my assistance.
	stopConversation = "false",
	options = {
		{"@conversation/ep3_etyyy_chrilooc:s_416", "ep3_chrilooc_retry"}, --I understand. I'll try again.
		{"@conversation/ep3_etyyy_chrilooc:s_422", "ep3_chrilooc_retry_no"}, --No thanks. It's just too risky.
	}
}
ep3_etyyy_chrilooc_convotemplate:addScreen(ep3_chrilooc_failed);

-- Re-grant happens in the handler on this screen id.
ep3_chrilooc_retry = ConvoScreen:new {
	id = "ep3_chrilooc_retry",
	leftDialog = "@conversation/ep3_etyyy_chrilooc:s_420", --Very good. You can launch into space from the starport here in town. Return to me after the medical supplies have been secured by my people
	stopConversation = "true",
	options = {}
}
ep3_etyyy_chrilooc_convotemplate:addScreen(ep3_chrilooc_retry);

-- s_418 is the retry arc's own copy of s_444. Same gate, see the block above ep3_chrilooc_no_space.
ep3_chrilooc_retry_no_space = ConvoScreen:new {
	id = "ep3_chrilooc_retry_no_space",
	leftDialog = "@conversation/ep3_etyyy_chrilooc:s_418", --It looks like you already have a mission in space. Come back once you've completed that one.
	stopConversation = "true",
	options = {}
}
ep3_etyyy_chrilooc_convotemplate:addScreen(ep3_chrilooc_retry_no_space);

ep3_chrilooc_retry_no = ConvoScreen:new {
	id = "ep3_chrilooc_retry_no",
	leftDialog = "@conversation/ep3_etyyy_chrilooc:s_424", --Guess you weren't serious about finding Brody Johnson. So be it.
	stopConversation = "true",
	options = {}
}
ep3_etyyy_chrilooc_convotemplate:addScreen(ep3_chrilooc_retry_no);

-- Recovery complete -- he pays in information.
ep3_chrilooc_complete = ConvoScreen:new {
	id = "ep3_chrilooc_complete",
	leftDialog = "@conversation/ep3_etyyy_chrilooc:s_390", --I appreciate your help in obtaining those medical supplies. In return I'll tell you what I know. I have a contact in the hunting grounds to the south known as Etyyy. I think he might have information about Brody Johnson. Yes, Brody spoke to me, but I can't say much more than that. My contact might know more, though, because I do know that Brody went to Etyyy.
	stopConversation = "false",
	options = {
		{"@conversation/ep3_etyyy_chrilooc:s_392", "ep3_chrilooc_how"}, --How do I get to these hunting grounds?
		{"@conversation/ep3_etyyy_chrilooc:s_406", "ep3_chrilooc_etyyy"}, --I've already gained access to the hunting grounds from Kerssoc.
	}
}
ep3_etyyy_chrilooc_convotemplate:addScreen(ep3_chrilooc_complete);

ep3_chrilooc_how = ConvoScreen:new {
	id = "ep3_chrilooc_how",
	leftDialog = "@conversation/ep3_etyyy_chrilooc:s_396", --Etyyy is under the control of some Rodian hunters. They are very, very selective about who they let enter [*coughs*] their hunting grounds. To gain access, you'll need to speak with Kerssoc, a Rodian hunter at the small Rodian hunting camp near the gate to Etyyy.
	stopConversation = "false",
	options = {
		{"@conversation/ep3_etyyy_chrilooc:s_398", "ep3_chrilooc_kerssoc"}, --I'll go speak with Kerssoc.
		{"@conversation/ep3_etyyy_chrilooc:s_402", "ep3_chrilooc_later"}, --Never mind. I think I'll come back later.
	}
}
ep3_etyyy_chrilooc_convotemplate:addScreen(ep3_chrilooc_how);

-- s_394 is the client's own alternate of s_396 for a player who is ALREADY working with Kerssoc.
ep3_chrilooc_how_working = ConvoScreen:new {
	id = "ep3_chrilooc_how_working",
	leftDialog = "@conversation/ep3_etyyy_chrilooc:s_394", --I've heard that you're already working with Kerssoc, a Rodian hunter near here. That's good. Continue with that. Kerssoc can grant you access to the hunting grounds. Once you've gained that, return and speak with me again. Oh, and don't let Kerssoc find out we've spoken. That could ruin everything.
	stopConversation = "false",
	options = {
		{"@conversation/ep3_etyyy_chrilooc:s_398", "ep3_chrilooc_kerssoc"}, --I'll go speak with Kerssoc.
		{"@conversation/ep3_etyyy_chrilooc:s_402", "ep3_chrilooc_later"}, --Never mind. I think I'll come back later.
	}
}
ep3_etyyy_chrilooc_convotemplate:addScreen(ep3_chrilooc_how_working);

ep3_chrilooc_kerssoc = ConvoScreen:new {
	id = "ep3_chrilooc_kerssoc",
	leftDialog = "@conversation/ep3_etyyy_chrilooc:s_400", --Follow the path east out of Kachirho, and you'll find them. Oh, and don't let Kerssoc know you've been talking to me. That will pretty much guarantee you won't get in.
	stopConversation = "true",
	options = {}
}
ep3_etyyy_chrilooc_convotemplate:addScreen(ep3_chrilooc_kerssoc);

ep3_chrilooc_later = ConvoScreen:new {
	id = "ep3_chrilooc_later",
	leftDialog = "@conversation/ep3_etyyy_chrilooc:s_404", --As you wish. I'll be here.
	stopConversation = "true",
	options = {}
}
ep3_etyyy_chrilooc_convotemplate:addScreen(ep3_chrilooc_later);

-- Heard the Etyyy lead, still has no access from Kerssoc.
ep3_chrilooc_no_access = ConvoScreen:new {
	id = "ep3_chrilooc_no_access",
	leftDialog = "@conversation/ep3_etyyy_chrilooc:s_384", --You need to gain access to the hunting grounds, Etyyy. Do whatever Kerssoc asks, and he should let you in.
	stopConversation = "false",
	options = {
		{"@conversation/ep3_etyyy_chrilooc:s_386", "ep3_chrilooc_no_access_ack"}, --Right. I'm working on it.
		{"@conversation/ep3_etyyy_chrilooc:s_452", "ep3_chrilooc_farewell"}, --No thanks.
	}
}
ep3_etyyy_chrilooc_convotemplate:addScreen(ep3_chrilooc_no_access);

ep3_chrilooc_no_access_ack = ConvoScreen:new {
	id = "ep3_chrilooc_no_access_ack",
	leftDialog = "@conversation/ep3_etyyy_chrilooc:s_388", --Good luck.
	stopConversation = "true",
	options = {}
}
ep3_etyyy_chrilooc_convotemplate:addScreen(ep3_chrilooc_no_access_ack);

-- s_408 is his answer to the player asserting Etyyy access inside the payoff conversation.
ep3_chrilooc_etyyy = ConvoScreen:new {
	id = "ep3_chrilooc_etyyy",
	leftDialog = "@conversation/ep3_etyyy_chrilooc:s_408", --Excellent. You're being able to travel to and from Etyyy will allow you to be of further service to me. And, of course, I can be of further service to you. West of the main Rodian hunting camp is a small compound being used by Arconans who are addicted to salt. Something about their physiology causes salt to be very addictive to Arconans. At this compound you'll find a colleague of mine named Johnson Smith.
	stopConversation = "false",
	options = {
		{"@conversation/ep3_etyyy_chrilooc:s_372", "ep3_chrilooc_arcona"}, --Johnson Smith at the Arcona compound?
		{"@conversation/ep3_etyyy_chrilooc:s_410", "ep3_chrilooc_johnson_never"}, --Ugh. More travel. Never mind.
	}
}
ep3_etyyy_chrilooc_convotemplate:addScreen(ep3_chrilooc_etyyy);

-- s_370 is the same handoff on a LATER hail (the client's own "Good, now that you can come and go").
ep3_chrilooc_etyyy_return = ConvoScreen:new {
	id = "ep3_chrilooc_etyyy_return",
	leftDialog = "@conversation/ep3_etyyy_chrilooc:s_370", --Good, now that you can come and go from Etyyy, you can be of further service to me. And I can be of further service to you. West of the main Rodian hunting camp is a small compound being used by Arconans who are addicted to salt. Something about their physiology causes salt to be very addictive to Arconans. At this compound you'll find a colleague of mine named Johnson Smith.
	stopConversation = "false",
	options = {
		{"@conversation/ep3_etyyy_chrilooc:s_372", "ep3_chrilooc_arcona"}, --Johnson Smith at the Arcona compound?
		{"@conversation/ep3_etyyy_chrilooc:s_410", "ep3_chrilooc_johnson_never"}, --Ugh. More travel. Never mind.
	}
}
ep3_etyyy_chrilooc_convotemplate:addScreen(ep3_chrilooc_etyyy_return);

ep3_chrilooc_arcona = ConvoScreen:new {
	id = "ep3_chrilooc_arcona",
	leftDialog = "@conversation/ep3_etyyy_chrilooc:s_374", --That's right. Please help Johnson. He's not only helping those poor Arconans, but he is also overseeing a little project of mine. I'm certain he could use your help. Please do whatever you can for him. I think he will also have more information about the person you are looking for, Brody Johnson. So you see, if you seek him out, you help both of us.
	stopConversation = "false",
	options = {
		{"@conversation/ep3_etyyy_chrilooc:s_376", "ep3_chrilooc_johnson_go"}, --I'll go speak with Johnson Smith.
		{"@conversation/ep3_etyyy_chrilooc:s_380", "ep3_chrilooc_johnson_later"}, --I'll go do that later.
	}
}
ep3_etyyy_chrilooc_convotemplate:addScreen(ep3_chrilooc_arcona);

ep3_chrilooc_johnson_go = ConvoScreen:new {
	id = "ep3_chrilooc_johnson_go",
	leftDialog = "@conversation/ep3_etyyy_chrilooc:s_378", --Excellent. On your way then.
	stopConversation = "true",
	options = {}
}
ep3_etyyy_chrilooc_convotemplate:addScreen(ep3_chrilooc_johnson_go);

ep3_chrilooc_johnson_later = ConvoScreen:new {
	id = "ep3_chrilooc_johnson_later",
	leftDialog = "@conversation/ep3_etyyy_chrilooc:s_382", --As you wish.
	stopConversation = "true",
	options = {}
}
ep3_etyyy_chrilooc_convotemplate:addScreen(ep3_chrilooc_johnson_later);

ep3_chrilooc_johnson_never = ConvoScreen:new {
	id = "ep3_chrilooc_johnson_never",
	leftDialog = "@conversation/ep3_etyyy_chrilooc:s_412", --Giving up? I'm actually surprised. And disappointed. You could have been of use to me in Etyyy. Ah well, I guess it wasn't to be.
	stopConversation = "true",
	options = {}
}
ep3_etyyy_chrilooc_convotemplate:addScreen(ep3_chrilooc_johnson_never);

-- Reached only once a Johnson Smith chain exists. See the header note.
ep3_chrilooc_johnson_done = ConvoScreen:new {
	id = "ep3_chrilooc_johnson_done",
	leftDialog = "@conversation/ep3_etyyy_chrilooc:s_368", --You've spoken to Johnson Smith? Good. I'm sure he can help you locate Brody. And please help him with the other matters he asks of you.
	stopConversation = "true",
	options = {}
}
ep3_etyyy_chrilooc_convotemplate:addScreen(ep3_chrilooc_johnson_done);

ep3_chrilooc_truth = ConvoScreen:new {
	id = "ep3_chrilooc_truth",
	leftDialog = "@conversation/ep3_etyyy_chrilooc:s_366", --So you discovered the truth, eh? Makes no real difference to me. I never understood why Brody would want to pretend he was dead anyway. Strange one, that human. But useful in his own way.
	stopConversation = "true",
	options = {}
}
ep3_etyyy_chrilooc_convotemplate:addScreen(ep3_chrilooc_truth);

ep3_chrilooc_farewell = ConvoScreen:new {
	id = "ep3_chrilooc_farewell",
	leftDialog = "@conversation/ep3_etyyy_chrilooc:s_454", --As you wish. Farewell.
	stopConversation = "true",
	options = {}
}
ep3_etyyy_chrilooc_convotemplate:addScreen(ep3_chrilooc_farewell);

addConversationTemplate("ep3_etyyy_chrilooc_convotemplate", ep3_etyyy_chrilooc_convotemplate);
