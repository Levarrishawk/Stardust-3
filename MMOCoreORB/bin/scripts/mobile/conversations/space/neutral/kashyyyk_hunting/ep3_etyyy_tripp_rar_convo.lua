-- Tripp Rar -- the Rodian hunt-master whose outbound shipments keep getting destroyed.
--
-- Giver for escort/ep3_hunting_tripp_protect_shipment (KashyyykHuntingScreenplay.lua, global at line
-- 282, registered line 332). Before this file nothing in the repo gave that quest out.
--
-- EVERY leftDialog and EVERY option below is a verbatim shipped key from
-- conversation/ep3_etyyy_tripp_rar.stf (69 entries). Nothing is authored.
--
-- The pitch matches the screenplay field for field: s_384 "many of my shipments are being attacked
-- and often destroyed. I was hoping you might be interested in providing some extra protection for
-- one of my shipments" is escortShips = {"rod_protector_ace_tier5"} out of Tripp's Rodian Hunter
-- Outpost; s_388 "When you're ready launch into space here in the Kashyyyk system. We'll relay more
-- information once you're there" is questZone space_kashyyyk with escortPoints
-- kash_hunting_tripp_shipment_1..4; and s_374 "Were you able to recognize any of your attackers?" is
-- the screenplay's unnamed attackShips (the .stf never names them either).
--
-- FLAGGED INTERPRETATION -- SCREEN TOPOLOGY. The client ships no screen graph. The order used here
-- is a depth-first walk of the .stf's own key order.
--
-- FLAGGED INTERPRETATION -- s_749 AS THE IN-FLIGHT SCREEN. s_749 "We'll relay coordinates to you for
-- where you should meet the shipment once you're in space" is a shipped NPC line with no shipped
-- player option that reaches it from s_388. It is used here for a player who is holding the escort
-- and hails her again, and as the landing screen for the retry. The text is client fact; those two
-- placements are not.
--
-- THE GROUND MOUF HUNT IS NOT BUILT HERE, DELIBERATELY. Roughly half of this .stf is a five-stage
-- Etyyy ground hunt (14 pristine mouf pelts -> 18 flawless mouf incisors -> the named moufs -> show
-- the jaws -> go see Sordaan Xris) plus the repeated "[Show Brightclaw's Jaw to Tripp]" /
-- "[Show Paleclaw's Jaw to Tripp]" options. The jaw objects exist
-- (object/custom_content/tangible/quest/quest_start/ep3_hunt_loot_brightclaw_jaw.lua and
-- ..._paleclaw_jaw.lua) but there is no mouf collection quest, no Sordaan Xris conversation and no
-- Kashyyyk ground screenplay anywhere in this repo, so every stage of it would have to be invented.
-- It belongs to whoever builds the Etyyy ground chain, not to this space giver.
--
-- UNUSED SHIPPED KEYS, all of them the ground hunt just described:
--   s_368 (empty), s_398, s_404, s_406, s_408, s_410, s_412, s_418, s_424, s_426, s_428, s_430,
--   s_432, s_438, s_444, s_446, s_448, s_450, s_452, s_454, s_456, s_458, s_460, s_466, s_470,
--   s_472, s_474, s_476, s_480, s_482, and the 12 "[Show ... Jaw to Tripp]" option keys
--   s_237, s_239, s_241, s_243, s_380, s_382, s_394, s_396, s_400, s_402, s_414, s_416, s_420,
--   s_422, s_434, s_436, s_440, s_442, s_462, s_464, s_468, s_478.

ep3_etyyy_tripp_rar_convotemplate = ConvoTemplate:new {
	initialScreen = "ep3_tripp_offer",
	templateType = "Lua",
	luaClassHandler = "Ep3EtyyyTrippRarConvoHandler",
	screens = {}
}

ep3_tripp_offer = ConvoScreen:new {
	id = "ep3_tripp_offer",
	leftDialog = "@conversation/ep3_etyyy_tripp_rar:s_384", --Greetings again. Actually I'm glad you came by and spoke with me. I have a problem I thought you might be able to help me solve. The goods I and my hunters gather are shipped to other planets where I sell them, but lately many of my shipments are being attacked and often destroyed. I was hoping you might be interested in providing some extra protection for one of my shipments?
	stopConversation = "false",
	options = {
		{"@conversation/ep3_etyyy_tripp_rar:s_386", "ep3_tripp_accept"}, --Um, sure, I suppose I could do that.
		{"@conversation/ep3_etyyy_tripp_rar:s_390", "ep3_tripp_decline"}, --Er, no I'd better not.
	}
}
ep3_etyyy_tripp_rar_convotemplate:addScreen(ep3_tripp_offer);

-- The grant happens in the handler on this screen id.
ep3_tripp_accept = ConvoScreen:new {
	id = "ep3_tripp_accept",
	leftDialog = "@conversation/ep3_etyyy_tripp_rar:s_388", --Ah, good. When you're ready launch into space here in the Kashyyyk system. We'll relay more information once you're there. Oh, and if you can identify whoever it is that's attacking my shipments, I'd really appreciate it.
	stopConversation = "true",
	options = {}
}
ep3_etyyy_tripp_rar_convotemplate:addScreen(ep3_tripp_accept);

--[[
	FLAGGED INTERPRETATION -- THE SPACE GATE. s_750 reads "It looks like you already have a mission in
	space. Come back once you've completed that one." The engine exposes no generic "player holds any
	space mission" test: space_helpers.lua only offers isSpaceQuestActive / isSpaceQuestTaskActive /
	isSpaceQuestComplete / isSpaceQuestTaskComplete for a NAMED quest, and MissionObject.idl:479 only
	exposes isSpaceDutyMission(). So this screen fires on the conditions the handler can actually see:
	JTL off, not a pilot, or no certified ship. The text is client fact; that trigger is not.
]]
ep3_tripp_no_space = ConvoScreen:new {
	id = "ep3_tripp_no_space",
	leftDialog = "@conversation/ep3_etyyy_tripp_rar:s_750", --It looks like you already have a mission in space. Come back once you've completed that one.
	stopConversation = "true",
	options = {}
}
ep3_etyyy_tripp_rar_convotemplate:addScreen(ep3_tripp_no_space);

ep3_tripp_decline = ConvoScreen:new {
	id = "ep3_tripp_decline",
	leftDialog = "@conversation/ep3_etyyy_tripp_rar:s_392", --I understand, but thanks anyway.
	stopConversation = "true",
	options = {}
}
ep3_etyyy_tripp_rar_convotemplate:addScreen(ep3_tripp_decline);

-- Escort running. Also the landing screen for the retry -- see the header.
ep3_tripp_in_flight = ConvoScreen:new {
	id = "ep3_tripp_in_flight",
	leftDialog = "@conversation/ep3_etyyy_tripp_rar:s_749", --We'll relay coordinates to you for where you should meet the shipment once you're in space.
	stopConversation = "true",
	options = {}
}
ep3_etyyy_tripp_rar_convotemplate:addScreen(ep3_tripp_in_flight);

-- Escort survived.
ep3_tripp_complete = ConvoScreen:new {
	id = "ep3_tripp_complete",
	leftDialog = "@conversation/ep3_etyyy_tripp_rar:s_370", --Welcome, I trust all goes well for you?
	stopConversation = "false",
	options = {
		{"@conversation/ep3_etyyy_tripp_rar:s_372", "ep3_tripp_grateful"}, --Your shipment should be safe. I fought off the attackers.
	}
}
ep3_etyyy_tripp_rar_convotemplate:addScreen(ep3_tripp_complete);

ep3_tripp_grateful = ConvoScreen:new {
	id = "ep3_tripp_grateful",
	leftDialog = "@conversation/ep3_etyyy_tripp_rar:s_374", --My pilot told me how well you performed in helping them get my shipment of goods out of the system. I'm very grateful! Were you able to recognize any of your attackers?
	stopConversation = "false",
	options = {
		{"@conversation/ep3_etyyy_tripp_rar:s_376", "ep3_tripp_mercenaries"}, --Um, no. They just seemed like a random group of mercenaries.
	}
}
ep3_etyyy_tripp_rar_convotemplate:addScreen(ep3_tripp_grateful);

ep3_tripp_mercenaries = ConvoScreen:new {
	id = "ep3_tripp_mercenaries",
	leftDialog = "@conversation/ep3_etyyy_tripp_rar:s_378", --Ah, I see. That's too bad. Well, at least you defeated them. That's the important thing.
	stopConversation = "true",
	options = {}
}
ep3_etyyy_tripp_rar_convotemplate:addScreen(ep3_tripp_mercenaries);

--[[
	FLAGGED INTERPRETATION -- FAILURE DETECTION. s_156 "Even with your help, my shipment of goods
	wasn't safe" is written for a player who took the escort and lost it. SpaceEscortScreenplay leaves
	no distinguishable failure record the conversation can read, so this handler cannot separate "lost
	the shipment" from "walked away": it shows this arc to anyone who once accepted and no longer has
	the quest active or complete. The text is client fact; that trigger is not.
]]
ep3_tripp_failed = ConvoScreen:new {
	id = "ep3_tripp_failed",
	leftDialog = "@conversation/ep3_etyyy_tripp_rar:s_156", --It's worse than I feared. Even with your help, my shipment of goods wasn't safe. I don't know what to do now.
	stopConversation = "false",
	options = {
		{"@conversation/ep3_etyyy_tripp_rar:s_230", "ep3_tripp_retry"}, --I could try again.
		{"@conversation/ep3_etyyy_tripp_rar:s_233", "ep3_tripp_give_up"}, --Sorry it didn't work out.
	}
}
ep3_etyyy_tripp_rar_convotemplate:addScreen(ep3_tripp_failed);

-- Re-grant happens in the handler on this screen id.
ep3_tripp_retry = ConvoScreen:new {
	id = "ep3_tripp_retry",
	leftDialog = "@conversation/ep3_etyyy_tripp_rar:s_749", --We'll relay coordinates to you for where you should meet the shipment once you're in space.
	stopConversation = "true",
	options = {}
}
ep3_etyyy_tripp_rar_convotemplate:addScreen(ep3_tripp_retry);

ep3_tripp_give_up = ConvoScreen:new {
	id = "ep3_tripp_give_up",
	leftDialog = "@conversation/ep3_etyyy_tripp_rar:s_235", --I suppose I'll think of something.
	stopConversation = "true",
	options = {}
}
ep3_etyyy_tripp_rar_convotemplate:addScreen(ep3_tripp_give_up);


-- Ground screens folded in (ruling 2026-09-04). Screen ids are the shipped
-- java keys. Existing space screens above are untouched.
ep3_etyyy_tripp_rar_convo_s_374 = ConvoScreen:new {
	id = "s_374",
	leftDialog = "@conversation/ep3_etyyy_tripp_rar:s_374", -- My pilot told me how well you performed in helping them get my shipment of goods out of the system. ...
	stopConversation = "true",
	options = {}
}
ep3_etyyy_tripp_rar_convotemplate:addScreen(ep3_etyyy_tripp_rar_convo_s_374)

ep3_etyyy_tripp_rar_convo_s_470 = ConvoScreen:new {
	id = "s_470",
	leftDialog = "@conversation/ep3_etyyy_tripp_rar:s_470", -- Very impressive. Brightclaw was not a typical mouf, and defeating him would take much skill and cour...
	stopConversation = "true",
	options = {}
}
ep3_etyyy_tripp_rar_convotemplate:addScreen(ep3_etyyy_tripp_rar_convo_s_470)

ep3_etyyy_tripp_rar_convo_s_476 = ConvoScreen:new {
	id = "s_476",
	leftDialog = "@conversation/ep3_etyyy_tripp_rar:s_476", -- Very impressive. Brightclaw was not a typical mouf, and defeating him would take much skill and cour...
	stopConversation = "true",
	options = {}
}
ep3_etyyy_tripp_rar_convotemplate:addScreen(ep3_etyyy_tripp_rar_convo_s_476)

ep3_etyyy_tripp_rar_convo_s_480 = ConvoScreen:new {
	id = "s_480",
	leftDialog = "@conversation/ep3_etyyy_tripp_rar:s_480", -- Very impressive. Paleclaw was a ferocious mouf. I'm certain that defeating him was not an easy hunt....
	stopConversation = "true",
	options = {}
}
ep3_etyyy_tripp_rar_convotemplate:addScreen(ep3_etyyy_tripp_rar_convo_s_480)

ep3_etyyy_tripp_rar_convo_s_482 = ConvoScreen:new {
	id = "s_482",
	leftDialog = "@conversation/ep3_etyyy_tripp_rar:s_482", -- Very impressive. Paleclaw was a ferocious mouf. I'm certain that defeating him was not an easy hunt....
	stopConversation = "true",
	options = {}
}
ep3_etyyy_tripp_rar_convotemplate:addScreen(ep3_etyyy_tripp_rar_convo_s_482)

ep3_etyyy_tripp_rar_convo_s_378 = ConvoScreen:new {
	id = "s_378",
	leftDialog = "@conversation/ep3_etyyy_tripp_rar:s_378", -- Ah, I see. That's too bad. Well, at least you defeated them. That's the important thing.
	stopConversation = "true",
	options = {}
}
ep3_etyyy_tripp_rar_convotemplate:addScreen(ep3_etyyy_tripp_rar_convo_s_378)

ep3_etyyy_tripp_rar_convo_s_750 = ConvoScreen:new {
	id = "s_750",
	leftDialog = "@conversation/ep3_etyyy_tripp_rar:s_750", -- It looks like you already have a mission in space. Come back once you've completed that one.
	stopConversation = "true",
	options = {}
}
ep3_etyyy_tripp_rar_convotemplate:addScreen(ep3_etyyy_tripp_rar_convo_s_750)

ep3_etyyy_tripp_rar_convo_s_388 = ConvoScreen:new {
	id = "s_388",
	leftDialog = "@conversation/ep3_etyyy_tripp_rar:s_388", -- Ah, good. When you're ready launch into space here in the Kashyyyk system. We'll relay more informat...
	stopConversation = "true",
	options = {}
}
ep3_etyyy_tripp_rar_convotemplate:addScreen(ep3_etyyy_tripp_rar_convo_s_388)

ep3_etyyy_tripp_rar_convo_s_235 = ConvoScreen:new {
	id = "s_235",
	leftDialog = "@conversation/ep3_etyyy_tripp_rar:s_235", -- I suppose I'll think of something.
	stopConversation = "true",
	options = {}
}
ep3_etyyy_tripp_rar_convotemplate:addScreen(ep3_etyyy_tripp_rar_convo_s_235)

ep3_etyyy_tripp_rar_convo_s_392 = ConvoScreen:new {
	id = "s_392",
	leftDialog = "@conversation/ep3_etyyy_tripp_rar:s_392", -- I understand, but thanks anyway.
	stopConversation = "true",
	options = {}
}
ep3_etyyy_tripp_rar_convotemplate:addScreen(ep3_etyyy_tripp_rar_convo_s_392)

ep3_etyyy_tripp_rar_convo_s_408 = ConvoScreen:new {
	id = "s_408",
	leftDialog = "@conversation/ep3_etyyy_tripp_rar:s_408", -- Don't let him bully you. Sordaan has a vast fortune which lets him buy most things he might desire, ...
	stopConversation = "true",
	options = {}
}
ep3_etyyy_tripp_rar_convotemplate:addScreen(ep3_etyyy_tripp_rar_convo_s_408)

ep3_etyyy_tripp_rar_convo_s_412 = ConvoScreen:new {
	id = "s_412",
	leftDialog = "@conversation/ep3_etyyy_tripp_rar:s_412", -- Okay. Farewell for now then. Return when you're ready.
	stopConversation = "true",
	options = {}
}
ep3_etyyy_tripp_rar_convotemplate:addScreen(ep3_etyyy_tripp_rar_convo_s_412)

ep3_etyyy_tripp_rar_convo_s_428 = ConvoScreen:new {
	id = "s_428",
	leftDialog = "@conversation/ep3_etyyy_tripp_rar:s_428", -- You probably noticed some vicious moufs in the same general area as the vibrant moufs. Many vicious ...
	stopConversation = "true",
	options = {}
}
ep3_etyyy_tripp_rar_convotemplate:addScreen(ep3_etyyy_tripp_rar_convo_s_428)

ep3_etyyy_tripp_rar_convo_s_432 = ConvoScreen:new {
	id = "s_432",
	leftDialog = "@conversation/ep3_etyyy_tripp_rar:s_432", -- Okay. Farewell for now then.
	stopConversation = "true",
	options = {}
}
ep3_etyyy_tripp_rar_convotemplate:addScreen(ep3_etyyy_tripp_rar_convo_s_432)

ep3_etyyy_tripp_rar_convo_s_448 = ConvoScreen:new {
	id = "s_448",
	leftDialog = "@conversation/ep3_etyyy_tripp_rar:s_448", -- Excellent. I'll have you hunting moufs, as I said. You're after pristine mouf pelts. Specifically fr...
	stopConversation = "true",
	options = {}
}
ep3_etyyy_tripp_rar_convotemplate:addScreen(ep3_etyyy_tripp_rar_convo_s_448)

ep3_etyyy_tripp_rar_convo_s_460 = ConvoScreen:new {
	id = "s_460",
	leftDialog = "@conversation/ep3_etyyy_tripp_rar:s_460", -- Okay. Farewell for now then.
	stopConversation = "true",
	options = {}
}
ep3_etyyy_tripp_rar_convotemplate:addScreen(ep3_etyyy_tripp_rar_convo_s_460)

ep3_etyyy_tripp_rar_convo_s_452 = ConvoScreen:new {
	id = "s_452",
	leftDialog = "@conversation/ep3_etyyy_tripp_rar:s_452", -- You'll find vibrant moufs in the northwest corner of the region. They're past the Arcona compound, a...
	stopConversation = "true",
	options = {}
}
ep3_etyyy_tripp_rar_convotemplate:addScreen(ep3_etyyy_tripp_rar_convo_s_452)

ep3_etyyy_tripp_rar_convo_s_456 = ConvoScreen:new {
	id = "s_456",
	leftDialog = "@conversation/ep3_etyyy_tripp_rar:s_456", -- Okay. Farewell for now then.
	stopConversation = "true",
	options = {}
}
ep3_etyyy_tripp_rar_convotemplate:addScreen(ep3_etyyy_tripp_rar_convo_s_456)

ep3_etyyy_tripp_rar_convo_s_474 = ConvoScreen:new {
	id = "s_474",
	leftDialog = "@conversation/ep3_etyyy_tripp_rar:s_474", -- Good. Even he would be impressed by this.
	stopConversation = "true",
	options = {}
}
ep3_etyyy_tripp_rar_convotemplate:addScreen(ep3_etyyy_tripp_rar_convo_s_474)

ep3_etyyy_tripp_rar_convo_s_370 = ConvoScreen:new {
	id = "s_370",
	leftDialog = "@conversation/ep3_etyyy_tripp_rar:s_370", -- Welcome, I trust all goes well for you?
	stopConversation = "false",
	options = {
		{"@conversation/ep3_etyyy_tripp_rar:s_372", "s_374"},
		{"@conversation/ep3_etyyy_tripp_rar:s_380", "s_476"},
		{"@conversation/ep3_etyyy_tripp_rar:s_382", "s_482"},
	}
}
ep3_etyyy_tripp_rar_convotemplate:addScreen(ep3_etyyy_tripp_rar_convo_s_370)

ep3_etyyy_tripp_rar_convo_s_156 = ConvoScreen:new {
	id = "s_156",
	leftDialog = "@conversation/ep3_etyyy_tripp_rar:s_156", -- It's worse than I feared. Even with your help, my shipment of goods wasn't safe. I don't know what t...
	stopConversation = "false",
	options = {
		{"@conversation/ep3_etyyy_tripp_rar:s_230", "s_388"},
		{"@conversation/ep3_etyyy_tripp_rar:s_233", "s_235"},
		{"@conversation/ep3_etyyy_tripp_rar:s_241", "s_476"},
		{"@conversation/ep3_etyyy_tripp_rar:s_243", "s_482"},
	}
}
ep3_etyyy_tripp_rar_convotemplate:addScreen(ep3_etyyy_tripp_rar_convo_s_156)

ep3_etyyy_tripp_rar_convo_s_749 = ConvoScreen:new {
	id = "s_749",
	leftDialog = "@conversation/ep3_etyyy_tripp_rar:s_749", -- We'll relay coordinates to you for where you should meet the shipment once you're in space.
	stopConversation = "false",
	options = {
		{"@conversation/ep3_etyyy_tripp_rar:s_237", "s_476"},
		{"@conversation/ep3_etyyy_tripp_rar:s_239", "s_482"},
	}
}
ep3_etyyy_tripp_rar_convotemplate:addScreen(ep3_etyyy_tripp_rar_convo_s_749)

ep3_etyyy_tripp_rar_convo_s_384 = ConvoScreen:new {
	id = "s_384",
	leftDialog = "@conversation/ep3_etyyy_tripp_rar:s_384", -- Greetings again. Actually I'm glad you came by and spoke with me. I have a problem I thought you mig...
	stopConversation = "false",
	options = {
		{"@conversation/ep3_etyyy_tripp_rar:s_386", "s_388"},
		{"@conversation/ep3_etyyy_tripp_rar:s_390", "s_392"},
		{"@conversation/ep3_etyyy_tripp_rar:s_394", "s_476"},
		{"@conversation/ep3_etyyy_tripp_rar:s_396", "s_482"},
	}
}
ep3_etyyy_tripp_rar_convotemplate:addScreen(ep3_etyyy_tripp_rar_convo_s_384)

ep3_etyyy_tripp_rar_convo_s_398 = ConvoScreen:new {
	id = "s_398",
	leftDialog = "@conversation/ep3_etyyy_tripp_rar:s_398", -- Hello. How goes your hunting?
	stopConversation = "false",
	options = {
		{"@conversation/ep3_etyyy_tripp_rar:s_400", "s_476"},
		{"@conversation/ep3_etyyy_tripp_rar:s_402", "s_482"},
	}
}
ep3_etyyy_tripp_rar_convotemplate:addScreen(ep3_etyyy_tripp_rar_convo_s_398)

ep3_etyyy_tripp_rar_convo_s_404 = ConvoScreen:new {
	id = "s_404",
	leftDialog = "@conversation/ep3_etyyy_tripp_rar:s_404", -- You're becoming quite the hunter. These incisors are exactly as flawless as I'd hoped they would be....
	stopConversation = "false",
	options = {
		{"@conversation/ep3_etyyy_tripp_rar:s_406", "s_408"},
		{"@conversation/ep3_etyyy_tripp_rar:s_410", "s_412"},
		{"@conversation/ep3_etyyy_tripp_rar:s_414", "s_476"},
		{"@conversation/ep3_etyyy_tripp_rar:s_416", "s_482"},
	}
}
ep3_etyyy_tripp_rar_convotemplate:addScreen(ep3_etyyy_tripp_rar_convo_s_404)

ep3_etyyy_tripp_rar_convo_s_418 = ConvoScreen:new {
	id = "s_418",
	leftDialog = "@conversation/ep3_etyyy_tripp_rar:s_418", -- Please collect 18 flawless mouf incisors. You'll find vicious moufs in the northwest corner of Etyyy...
	stopConversation = "false",
	options = {
		{"@conversation/ep3_etyyy_tripp_rar:s_420", "s_476"},
		{"@conversation/ep3_etyyy_tripp_rar:s_422", "s_482"},
	}
}
ep3_etyyy_tripp_rar_convotemplate:addScreen(ep3_etyyy_tripp_rar_convo_s_418)

ep3_etyyy_tripp_rar_convo_s_424 = ConvoScreen:new {
	id = "s_424",
	leftDialog = "@conversation/ep3_etyyy_tripp_rar:s_424", -- These are wonderful mouf pelts. Good job! Ready for your next hunting goal?
	stopConversation = "false",
	options = {
		{"@conversation/ep3_etyyy_tripp_rar:s_426", "s_428"},
		{"@conversation/ep3_etyyy_tripp_rar:s_430", "s_432"},
		{"@conversation/ep3_etyyy_tripp_rar:s_434", "s_476"},
		{"@conversation/ep3_etyyy_tripp_rar:s_436", "s_482"},
	}
}
ep3_etyyy_tripp_rar_convotemplate:addScreen(ep3_etyyy_tripp_rar_convo_s_424)

ep3_etyyy_tripp_rar_convo_s_438 = ConvoScreen:new {
	id = "s_438",
	leftDialog = "@conversation/ep3_etyyy_tripp_rar:s_438", -- You'll find vibrant moufs in the northwest corner of the hunting grounds. Return to me when you have...
	stopConversation = "false",
	options = {
		{"@conversation/ep3_etyyy_tripp_rar:s_440", "s_476"},
		{"@conversation/ep3_etyyy_tripp_rar:s_442", "s_482"},
	}
}
ep3_etyyy_tripp_rar_convotemplate:addScreen(ep3_etyyy_tripp_rar_convo_s_438)

ep3_etyyy_tripp_rar_convo_s_444 = ConvoScreen:new {
	id = "s_444",
	animation = "greet",
	leftDialog = "@conversation/ep3_etyyy_tripp_rar:s_444", -- So you're the hunter I've been hearing so much about. Ready to get back to the hunt? I'll have you h...
	stopConversation = "false",
	options = {
		{"@conversation/ep3_etyyy_tripp_rar:s_446", "s_448"},
		{"@conversation/ep3_etyyy_tripp_rar:s_458", "s_460"},
		{"@conversation/ep3_etyyy_tripp_rar:s_462", "s_476"},
		{"@conversation/ep3_etyyy_tripp_rar:s_464", "s_482"},
	}
}
ep3_etyyy_tripp_rar_convotemplate:addScreen(ep3_etyyy_tripp_rar_convo_s_444)

ep3_etyyy_tripp_rar_convo_s_466 = ConvoScreen:new {
	id = "s_466",
	leftDialog = "@conversation/ep3_etyyy_tripp_rar:s_466", -- I apologize if I seem rude, but I'm busy looking into why my shipments of mouf pelts and mouf inciso...
	stopConversation = "false",
	options = {
		{"@conversation/ep3_etyyy_tripp_rar:s_468", "s_476"},
		{"@conversation/ep3_etyyy_tripp_rar:s_478", "s_482"},
	}
}
ep3_etyyy_tripp_rar_convotemplate:addScreen(ep3_etyyy_tripp_rar_convo_s_466)

addConversationTemplate("ep3_etyyy_tripp_rar_convotemplate", ep3_etyyy_tripp_rar_convotemplate);
