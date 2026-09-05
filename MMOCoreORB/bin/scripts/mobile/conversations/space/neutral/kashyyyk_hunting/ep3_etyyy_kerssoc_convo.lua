-- Kerssoc -- Rodian hunter outside the Etyyy hunting grounds, Kashyyyk.
--
-- He is the giver for the only Kashyyyk hunting chain that has no giver in the repo:
--     delivery_no_pickup_ep3_hunting_kerssoc_smuggle_goods   (head, Corellia system)
--       -> escort_ep3_hunting_kerssoc_supplies               (side quest, COMPLETION split)
--         -> assassinate_ep3_hunting_kerssoc_destroy_chiss_weapons
-- All three are registered in screenplays/space/squadrons/KashyyykHuntingScreenplay.lua
-- (lines 66, 120, 159) and, before this file, nothing anywhere referenced them.
--
-- EVERY leftDialog and EVERY option below is a verbatim shipped key from
-- conversation/ep3_etyyy_kerssoc.stf (61 entries). Nothing is authored.
--
-- FLAGGED INTERPRETATION -- SCREEN TOPOLOGY. The .stf is a flat key/value dump; the client ships no
-- screen graph, so which option hangs under which screen is reconstructed here from the text and
-- from SwgConversationEditor's creation order (ids rise depth-first). The strings are client fact;
-- the edges between them are not. The one arc that is unambiguous end to end is the space delivery
-- offer, s_1104 -> s_1106 -> s_1108 -> s_1110 -> s_1112, and that is the arc that hands out
-- delivery_no_pickup/ep3_hunting_kerssoc_smuggle_goods. s_1108 names the quest in the client's own
-- words -- "I need all of them delivered to a contact I have in the Corellia system" -- and the
-- screenplay's questZone is "space_corellia".
--
-- FLAGGED INTERPRETATION -- s_1148 ("You're a hunter?") hung off the greeting. It is a player line
-- with no shipped parent. It is the entry to the s_1150/s_1154/s_1158 small-talk arc, which
-- otherwise has no way in. Delete that one option to remove the interpretation.
--
-- FLAGGED INTERPRETATION -- s_1146 ("Bah, you're no hunter. Leave now.") is used as the hail for a
-- player who has already refused him, and carries s_1148 so the refusal is not permanent. The
-- client names no trigger for it.
--
-- GROUND LEGS NOT ENFORCED. Two legs of this chain are ground content: 17 flawless Kashyyyk bantha
-- pelts (s_1132) and 21 Chiss poachers (s_1072). This repo has no Kashyyyk ground screenplay, no
-- Kashyyyk ground spawn areas, and the Kashyyyk ground zones are not in config.lua ZonesEnabled, so
-- there is nothing to count against. The handler advances those two legs on a hail instead; see
-- KERSSOC_GROUND_LEGS_AUTO in ep3EtyyyKerssocConvoHandler.lua, which is the single switch that
-- turns that off once real ground quests exist.
--
-- UNUSED SHIPPED KEYS: s_1054 only (empty string in the client file).

ep3_etyyy_kerssoc_convotemplate = ConvoTemplate:new {
	initialScreen = "ep3_etyyy_kerssoc_greeting",
	templateType = "Lua",
	luaClassHandler = "Ep3EtyyyKerssocConvoHandler",
	screens = {}
}

-- Default hail for a pilot who has not started anything with him.
ep3_etyyy_kerssoc_greeting = ConvoScreen:new {
	id = "ep3_etyyy_kerssoc_greeting",
	leftDialog = "@conversation/ep3_etyyy_kerssoc:s_1124", --You want to enter the hunting grounds? You think Etyyy is open to just anyone? Ha. Not even close. If you can prove you can handle yourself as a hunter, and maybe make yourself useful, well maybe. I'm not promising anything. And I'll likely just turn you down either way. But if you're willing to do some things for me, I might grant you access to the hunting grounds.
	stopConversation = "false",
	options = {
		{"@conversation/ep3_etyyy_kerssoc:s_1126", "ep3_etyyy_kerssoc_task_1"}, --What do you want me to do?
		{"@conversation/ep3_etyyy_kerssoc:s_1148", "ep3_etyyy_kerssoc_hunter_1"}, --You're a hunter?
	}
}
ep3_etyyy_kerssoc_convotemplate:addScreen(ep3_etyyy_kerssoc_greeting);

-- The small-talk arc. s_1150 -> s_1154 -> s_1158 restates the bantha-pelt task, so it converges on
-- the same accept/decline pair as the direct arc.
ep3_etyyy_kerssoc_hunter_1 = ConvoScreen:new {
	id = "ep3_etyyy_kerssoc_hunter_1",
	leftDialog = "@conversation/ep3_etyyy_kerssoc:s_1150", --Indeed I am. Not yet to the level of those in the actual hunting grounds, but I will be soon. Oh, so soon. Anyway.
	stopConversation = "false",
	options = {
		{"@conversation/ep3_etyyy_kerssoc:s_1152", "ep3_etyyy_kerssoc_hunter_2"}, --Hunting grounds?
	}
}
ep3_etyyy_kerssoc_convotemplate:addScreen(ep3_etyyy_kerssoc_hunter_1);

ep3_etyyy_kerssoc_hunter_2 = ConvoScreen:new {
	id = "ep3_etyyy_kerssoc_hunter_2",
	leftDialog = "@conversation/ep3_etyyy_kerssoc:s_1154", --That's right. The hunting grounds to the south. The Wookiees call that area Etyyy. Which I guess is as good a name as any. You, um, interested in going there? I could help you out if you're willing to help me?
	stopConversation = "false",
	options = {
		{"@conversation/ep3_etyyy_kerssoc:s_1156", "ep3_etyyy_kerssoc_hunter_3"}, --Yes, how do I get there?
		{"@conversation/ep3_etyyy_kerssoc:s_1160", "ep3_etyyy_kerssoc_hunter_no"}, --No thanks.
	}
}
ep3_etyyy_kerssoc_convotemplate:addScreen(ep3_etyyy_kerssoc_hunter_2);

ep3_etyyy_kerssoc_hunter_3 = ConvoScreen:new {
	id = "ep3_etyyy_kerssoc_hunter_3",
	leftDialog = "@conversation/ep3_etyyy_kerssoc:s_1158", --Whoa. Not so fast. You have to get my permission before you'll be able to enter Etyyy.  First I want to see what kind of hunter you are. And to be honest, I want you to hunt a prey that we are not allowed to hunt ourselves. For whatever reason, Sordaan, the lead Rodian hunter here on Kashyyyk, has declared Kashyyyk bantha off limits to Rodian hunters. Don't ask me why. Something to do with a childhood tragedy or something.
	stopConversation = "false",
	options = {
		{"@conversation/ep3_etyyy_kerssoc:s_1134", "ep3_etyyy_kerssoc_pelts_accept"}, --I'll do it.
		{"@conversation/ep3_etyyy_kerssoc:s_1142", "ep3_etyyy_kerssoc_pelts_not_worth"}, --No thanks. Doesn't seem like it would be worth it.
	}
}
ep3_etyyy_kerssoc_convotemplate:addScreen(ep3_etyyy_kerssoc_hunter_3);

ep3_etyyy_kerssoc_hunter_no = ConvoScreen:new {
	id = "ep3_etyyy_kerssoc_hunter_no",
	leftDialog = "@conversation/ep3_etyyy_kerssoc:s_1162", --Didn't think you looked like the hunting type anyway. Not really sure why I bothered to offer.
	stopConversation = "true",
	options = {}
}
ep3_etyyy_kerssoc_convotemplate:addScreen(ep3_etyyy_kerssoc_hunter_no);

-- The direct arc into the bantha-pelt task.
ep3_etyyy_kerssoc_task_1 = ConvoScreen:new {
	id = "ep3_etyyy_kerssoc_task_1",
	leftDialog = "@conversation/ep3_etyyy_kerssoc:s_1128", --Eager? That's a good sign. First I want to see what kind of hunter you are. And to be honest, I want you to hunt a prey that we are not allowed to hunt ourselves. For whatever reason, Sordaan, the lead Rodian hunter here on Kashyyyk, has declared Kashyyyk bantha off limits to Rodian hunters. Don't ask my why. Something to do with a childhood tragedy or something.
	stopConversation = "false",
	options = {
		{"@conversation/ep3_etyyy_kerssoc:s_1130", "ep3_etyyy_kerssoc_task_2"}, --You want me to hunt Kashyyyk banthas?
	}
}
ep3_etyyy_kerssoc_convotemplate:addScreen(ep3_etyyy_kerssoc_task_1);

ep3_etyyy_kerssoc_task_2 = ConvoScreen:new {
	id = "ep3_etyyy_kerssoc_task_2",
	leftDialog = "@conversation/ep3_etyyy_kerssoc:s_1132", --Yes, I do. You could get away with it. Probably. I'm mostly sure you could. At the very least, Sordaan would be unlikely to blame me. So, go hunt Kashyyyk banthas. You'll find them all over the place. I need 17 flawless Kashyyyk bantha pelts. Not every Kashyyyk bantha you hunt will have a pelt that's in good enough shape, but plenty of them will. When you've collected 17 of them, come back here and talk to me.
	stopConversation = "false",
	options = {
		{"@conversation/ep3_etyyy_kerssoc:s_1134", "ep3_etyyy_kerssoc_pelts_accept"}, --I'll do it.
		{"@conversation/ep3_etyyy_kerssoc:s_1138", "ep3_etyyy_kerssoc_pelts_decline"}, --No thanks.
	}
}
ep3_etyyy_kerssoc_convotemplate:addScreen(ep3_etyyy_kerssoc_task_2);

-- The pelt leg is marked accepted in the handler on this screen id.
ep3_etyyy_kerssoc_pelts_accept = ConvoScreen:new {
	id = "ep3_etyyy_kerssoc_pelts_accept",
	leftDialog = "@conversation/ep3_etyyy_kerssoc:s_1136", --Good. Go to it. 17 flawless Kashyyyk bantha pelts. I'll be waiting.
	stopConversation = "true",
	options = {}
}
ep3_etyyy_kerssoc_convotemplate:addScreen(ep3_etyyy_kerssoc_pelts_accept);

ep3_etyyy_kerssoc_pelts_decline = ConvoScreen:new {
	id = "ep3_etyyy_kerssoc_pelts_decline",
	leftDialog = "@conversation/ep3_etyyy_kerssoc:s_1140", --If you can't stomach something simple like this, you have no hope of ever entering Etyyy.
	stopConversation = "false",
	options = {
		{"@conversation/ep3_etyyy_kerssoc:s_1164", "ep3_etyyy_kerssoc_going"}, --I'm going.
	}
}
ep3_etyyy_kerssoc_convotemplate:addScreen(ep3_etyyy_kerssoc_pelts_decline);

ep3_etyyy_kerssoc_pelts_not_worth = ConvoScreen:new {
	id = "ep3_etyyy_kerssoc_pelts_not_worth",
	leftDialog = "@conversation/ep3_etyyy_kerssoc:s_1144", --Fine. Go away.
	stopConversation = "true",
	options = {}
}
ep3_etyyy_kerssoc_convotemplate:addScreen(ep3_etyyy_kerssoc_pelts_not_worth);

ep3_etyyy_kerssoc_going = ConvoScreen:new {
	id = "ep3_etyyy_kerssoc_going",
	leftDialog = "@conversation/ep3_etyyy_kerssoc:s_1166", --Good.
	stopConversation = "true",
	options = {}
}
ep3_etyyy_kerssoc_convotemplate:addScreen(ep3_etyyy_kerssoc_going);

-- FLAGGED INTERPRETATION. Hail for a player who refused. s_1148 is carried so the refusal is not
-- permanent; the client names no trigger for s_1146.
ep3_etyyy_kerssoc_no_hunter = ConvoScreen:new {
	id = "ep3_etyyy_kerssoc_no_hunter",
	leftDialog = "@conversation/ep3_etyyy_kerssoc:s_1146", --Bah, you're no hunter. Leave now.
	stopConversation = "false",
	options = {
		{"@conversation/ep3_etyyy_kerssoc:s_1148", "ep3_etyyy_kerssoc_hunter_1"}, --You're a hunter?
	}
}
ep3_etyyy_kerssoc_convotemplate:addScreen(ep3_etyyy_kerssoc_no_hunter);

-- Pelt leg running.
ep3_etyyy_kerssoc_pelts_waiting = ConvoScreen:new {
	id = "ep3_etyyy_kerssoc_pelts_waiting",
	leftDialog = "@conversation/ep3_etyyy_kerssoc:s_1118", --Go get those flawless Kashyyyk bantha pelts. I'm waiting.
	stopConversation = "false",
	options = {
		{"@conversation/ep3_etyyy_kerssoc:s_1120", "ep3_etyyy_kerssoc_pelts_good"}, --I'm on it. Back soon.
	}
}
ep3_etyyy_kerssoc_convotemplate:addScreen(ep3_etyyy_kerssoc_pelts_waiting);

ep3_etyyy_kerssoc_pelts_good = ConvoScreen:new {
	id = "ep3_etyyy_kerssoc_pelts_good",
	leftDialog = "@conversation/ep3_etyyy_kerssoc:s_1122", --Good.
	stopConversation = "true",
	options = {}
}
ep3_etyyy_kerssoc_convotemplate:addScreen(ep3_etyyy_kerssoc_pelts_good);

--[[
	THE SPACE QUEST.

	delivery_no_pickup/ep3_hunting_kerssoc_smuggle_goods is s_1108 + s_1112 word for word: the pelts
	the player gathered plus "some others I've had stashed" go to "a contact I have in the Corellia
	system", and "Once there, you'll receive word on where to meet my contact" is the
	SpaceDeliveryNoPickupScreenplay rendezvous. s_1112's warning -- "There are some Chiss poachers in
	the area, and they've tried to intercept my shipments in the past" -- is the screenplay's
	attackShips list, which is chiss_poacher_tier4 / chiss_poacher_bomber_tier4.
]]
ep3_etyyy_kerssoc_pelts_turnin = ConvoScreen:new {
	id = "ep3_etyyy_kerssoc_pelts_turnin",
	leftDialog = "@conversation/ep3_etyyy_kerssoc:s_1104", --Well, look at these flawless Kashyyyk bantha pelts. Well done. I'd say I'm impressed, but it's not like it was all that difficult a task. But it was appreciated all the same.
	stopConversation = "false",
	options = {
		{"@conversation/ep3_etyyy_kerssoc:s_1106", "ep3_etyyy_kerssoc_smuggle_offer"}, --Can I get to the hunting grounds now?
	}
}
ep3_etyyy_kerssoc_convotemplate:addScreen(ep3_etyyy_kerssoc_pelts_turnin);

-- Same shipped key, no follow-on. Used when the player has the pelts but cannot fly the delivery
-- (JTL off, or not a pilot), so the offer is never dangled at someone who cannot take it.
ep3_etyyy_kerssoc_pelts_turnin_nopilot = ConvoScreen:new {
	id = "ep3_etyyy_kerssoc_pelts_turnin_nopilot",
	leftDialog = "@conversation/ep3_etyyy_kerssoc:s_1104", --Well, look at these flawless Kashyyyk bantha pelts. Well done. I'd say I'm impressed, but it's not like it was all that difficult a task. But it was appreciated all the same.
	stopConversation = "true",
	options = {}
}
ep3_etyyy_kerssoc_convotemplate:addScreen(ep3_etyyy_kerssoc_pelts_turnin_nopilot);

ep3_etyyy_kerssoc_smuggle_offer = ConvoScreen:new {
	id = "ep3_etyyy_kerssoc_smuggle_offer",
	leftDialog = "@conversation/ep3_etyyy_kerssoc:s_1108", --No. Not yet. We've only just started. Next I need you to deliver these flawless Kashyyyk bantha pelts you've gathered as well as some others I've had stashed. Never mind where they came from. I need all of them delivered to a contact I have in the Corellia system.
	stopConversation = "false",
	options = {
		{"@conversation/ep3_etyyy_kerssoc:s_1110", "ep3_etyyy_kerssoc_smuggle_accept"}, --Okay, I'll deliver them.
		{"@conversation/ep3_etyyy_kerssoc:s_1114", "ep3_etyyy_kerssoc_smuggle_later"}, --Maybe later.
	}
}
ep3_etyyy_kerssoc_convotemplate:addScreen(ep3_etyyy_kerssoc_smuggle_offer);

-- The grant happens in the handler on this screen id.
ep3_etyyy_kerssoc_smuggle_accept = ConvoScreen:new {
	id = "ep3_etyyy_kerssoc_smuggle_accept",
	leftDialog = "@conversation/ep3_etyyy_kerssoc:s_1112", --Good. Away you go then. Fly to the Corellia system. Once there, you'll receive word on where to meet my contact. Be careful though. There are some Chiss poachers in the area, and they've tried to intercept my shipments in the past. They will track you all the way to the Corellia system if they are after you. So be careful.
	stopConversation = "true",
	options = {}
}
ep3_etyyy_kerssoc_convotemplate:addScreen(ep3_etyyy_kerssoc_smuggle_accept);

ep3_etyyy_kerssoc_smuggle_later = ConvoScreen:new {
	id = "ep3_etyyy_kerssoc_smuggle_later",
	leftDialog = "@conversation/ep3_etyyy_kerssoc:s_1116", --Okay. Come back when you're ready.
	stopConversation = "true",
	options = {}
}
ep3_etyyy_kerssoc_convotemplate:addScreen(ep3_etyyy_kerssoc_smuggle_later);

ep3_etyyy_kerssoc_smuggle_active = ConvoScreen:new {
	id = "ep3_etyyy_kerssoc_smuggle_active",
	leftDialog = "@conversation/ep3_etyyy_kerssoc:s_1102", --Go deliver those pelts. Times a-wasting.
	stopConversation = "true",
	options = {}
}
ep3_etyyy_kerssoc_convotemplate:addScreen(ep3_etyyy_kerssoc_smuggle_active);

--[[
	escort/ep3_hunting_kerssoc_supplies is handed out by the delivery screenplay itself as a side
	quest (sideQuestSplitType COMPLETION, KashyyykHuntingScreenplay.lua:44-48), so this screen is the
	retry path, which is exactly what s_1092 is: "You were supposed to escort a shipment of supplies.
	What happened? Ah, whatever. I'll give you another chance."
]]
ep3_etyyy_kerssoc_escort_retry = ConvoScreen:new {
	id = "ep3_etyyy_kerssoc_escort_retry",
	leftDialog = "@conversation/ep3_etyyy_kerssoc:s_1092", --You were supposed to escort a shipment of supplies. What happened? Ah, whatever. I'll give you another chance. There's always another shipment needing protection these days. Ready to try again?
	stopConversation = "false",
	options = {
		{"@conversation/ep3_etyyy_kerssoc:s_1094", "ep3_etyyy_kerssoc_escort_retry_yes"}, --Yes I am.
		{"@conversation/ep3_etyyy_kerssoc:s_1098", "ep3_etyyy_kerssoc_escort_retry_later"}, --I'll try again later.
	}
}
ep3_etyyy_kerssoc_convotemplate:addScreen(ep3_etyyy_kerssoc_escort_retry);

ep3_etyyy_kerssoc_escort_retry_yes = ConvoScreen:new {
	id = "ep3_etyyy_kerssoc_escort_retry_yes",
	leftDialog = "@conversation/ep3_etyyy_kerssoc:s_1096", --Good. Go to it. Make sure nothing happens to those supplies.
	stopConversation = "true",
	options = {}
}
ep3_etyyy_kerssoc_convotemplate:addScreen(ep3_etyyy_kerssoc_escort_retry_yes);

ep3_etyyy_kerssoc_escort_retry_later = ConvoScreen:new {
	id = "ep3_etyyy_kerssoc_escort_retry_later",
	leftDialog = "@conversation/ep3_etyyy_kerssoc:s_1100", --Hmm. I see.
	stopConversation = "true",
	options = {}
}
ep3_etyyy_kerssoc_convotemplate:addScreen(ep3_etyyy_kerssoc_escort_retry_later);

-- Same shape for assassinate/ep3_hunting_kerssoc_destroy_chiss_weapons, the escort's own side quest.
ep3_etyyy_kerssoc_weapons_retry = ConvoScreen:new {
	id = "ep3_etyyy_kerssoc_weapons_retry",
	leftDialog = "@conversation/ep3_etyyy_kerssoc:s_1082", --What happened to destroying the ship full of Chiss poacher weapons? Couldn't handle it? Or did you simply have a run of bad luck? I'm going to hope it was the luck thing. Otherwise I'm wasting my time. Ready to try your luck again?
	stopConversation = "false",
	options = {
		{"@conversation/ep3_etyyy_kerssoc:s_1084", "ep3_etyyy_kerssoc_weapons_retry_yes"}, --I am. This time I'll succeed.
		{"@conversation/ep3_etyyy_kerssoc:s_1088", "ep3_etyyy_kerssoc_weapons_retry_later"}, --I'll try again later.
	}
}
ep3_etyyy_kerssoc_convotemplate:addScreen(ep3_etyyy_kerssoc_weapons_retry);

ep3_etyyy_kerssoc_weapons_retry_yes = ConvoScreen:new {
	id = "ep3_etyyy_kerssoc_weapons_retry_yes",
	leftDialog = "@conversation/ep3_etyyy_kerssoc:s_1086", --Yeah. Let's hope so.
	stopConversation = "true",
	options = {}
}
ep3_etyyy_kerssoc_convotemplate:addScreen(ep3_etyyy_kerssoc_weapons_retry_yes);

ep3_etyyy_kerssoc_weapons_retry_later = ConvoScreen:new {
	id = "ep3_etyyy_kerssoc_weapons_retry_later",
	leftDialog = "@conversation/ep3_etyyy_kerssoc:s_1090", --Really. Don't hurry or anything.
	stopConversation = "true",
	options = {}
}
ep3_etyyy_kerssoc_convotemplate:addScreen(ep3_etyyy_kerssoc_weapons_retry_later);

--[[
	GROUND LEG, NOT ENFORCED. s_1072 is the 21-Chiss-poacher hunt that follows the space
	assassinate. There is no Kashyyyk ground screenplay in this repo to count kills against, so the
	handler advances it on a hail (KERSSOC_GROUND_LEGS_AUTO). The text is client fact; the
	progression is not.
]]
ep3_etyyy_kerssoc_camp = ConvoScreen:new {
	id = "ep3_etyyy_kerssoc_camp",
	leftDialog = "@conversation/ep3_etyyy_kerssoc:s_1072", --Good work destroying that shipment of Chiss weapons. Though it has kind of riled up the Chiss poacher camp to the north. Maybe we should rile them up even more. Go attack their camp and reduce their numbers a bit. Take out 21 Chiss poachers. Yeah, that sounds like a good number. Return to me when you're done.
	stopConversation = "false",
	options = {
		{"@conversation/ep3_etyyy_kerssoc:s_1074", "ep3_etyyy_kerssoc_camp_accept"}, --Those Chiss poachers won't know what hit them.
		{"@conversation/ep3_etyyy_kerssoc:s_1078", "ep3_etyyy_kerssoc_camp_later"}, --Maybe later.
	}
}
ep3_etyyy_kerssoc_convotemplate:addScreen(ep3_etyyy_kerssoc_camp);

ep3_etyyy_kerssoc_camp_accept = ConvoScreen:new {
	id = "ep3_etyyy_kerssoc_camp_accept",
	leftDialog = "@conversation/ep3_etyyy_kerssoc:s_1076", --Good. Off you go then.
	stopConversation = "true",
	options = {}
}
ep3_etyyy_kerssoc_convotemplate:addScreen(ep3_etyyy_kerssoc_camp_accept);

ep3_etyyy_kerssoc_camp_later = ConvoScreen:new {
	id = "ep3_etyyy_kerssoc_camp_later",
	leftDialog = "@conversation/ep3_etyyy_kerssoc:s_1080", --Fine. But don't wait too long.
	stopConversation = "true",
	options = {}
}
ep3_etyyy_kerssoc_convotemplate:addScreen(ep3_etyyy_kerssoc_camp_later);

ep3_etyyy_kerssoc_camp_active = ConvoScreen:new {
	id = "ep3_etyyy_kerssoc_camp_active",
	leftDialog = "@conversation/ep3_etyyy_kerssoc:s_1070", --Go on. Get to it. Those Chiss poachers aren't going to kill themselves.
	stopConversation = "true",
	options = {}
}
ep3_etyyy_kerssoc_convotemplate:addScreen(ep3_etyyy_kerssoc_camp_active);

-- The payoff he promised in s_1124. s_1064 names Sordaan Xris, whose own conversation file
-- (conversation/ep3_etyyy_sordaan_xris.stf) ships in the client, so the pointer is client fact.
ep3_etyyy_kerssoc_access = ConvoScreen:new {
	id = "ep3_etyyy_kerssoc_access",
	leftDialog = "@conversation/ep3_etyyy_kerssoc:s_1060", --Well done with your attack on the Chiss camp. You've done far better than I ever expected. I suppose I can grant you access to the hunting grounds, Etyyy. Ready to go?
	stopConversation = "false",
	options = {
		{"@conversation/ep3_etyyy_kerssoc:s_1062", "ep3_etyyy_kerssoc_access_yes"}, --Yes, I'm definitely ready.
		{"@conversation/ep3_etyyy_kerssoc:s_1066", "ep3_etyyy_kerssoc_access_no"}, --No, I think I'll go later.
	}
}
ep3_etyyy_kerssoc_convotemplate:addScreen(ep3_etyyy_kerssoc_access);

ep3_etyyy_kerssoc_access_yes = ConvoScreen:new {
	id = "ep3_etyyy_kerssoc_access_yes",
	leftDialog = "@conversation/ep3_etyyy_kerssoc:s_1064", --Good. The gate is just to the west. You can enter there. Once you're inside, go to the main Rodian hunting camp. It's just past the gate. You can't miss it. You should speak with Sordaan Xris at the hunting camp. He's the self-proclaimed leader of the Rodian hunters. I'm not sure what kind of welcome you'll receive, but you'll have to speak with him before doing much else there.
	stopConversation = "true",
	options = {}
}
ep3_etyyy_kerssoc_convotemplate:addScreen(ep3_etyyy_kerssoc_access_yes);

ep3_etyyy_kerssoc_access_no = ConvoScreen:new {
	id = "ep3_etyyy_kerssoc_access_no",
	leftDialog = "@conversation/ep3_etyyy_kerssoc:s_1068", --Very well. Return to me when you're ready to enter Etyyy.
	stopConversation = "true",
	options = {}
}
ep3_etyyy_kerssoc_convotemplate:addScreen(ep3_etyyy_kerssoc_access_no);

ep3_etyyy_kerssoc_hunting_grounds = ConvoScreen:new {
	id = "ep3_etyyy_kerssoc_hunting_grounds",
	leftDialog = "@conversation/ep3_etyyy_kerssoc:s_1058", --I trust you're doing well in the hunting grounds.
	stopConversation = "true",
	options = {}
}
ep3_etyyy_kerssoc_convotemplate:addScreen(ep3_etyyy_kerssoc_hunting_grounds);

--[[
	NOT REACHABLE YET, KEPT SO NO SHIPPED KEY IS DROPPED. s_1056 makes Kerssoc the drop-off for
	somebody else's poached-goods run and sends the player back to Manfred:
	conversation/ep3_etyyy_manfred_carter.stf ships in the client and ep3_etyyy_manfred_carter.lua
	exists as a mobile, but Manfred has no conversation and no screenplay, so nothing can set the
	state this screen needs. Wire it from Manfred's handler when that giver is built.
]]
ep3_etyyy_kerssoc_poached_goods = ConvoScreen:new {
	id = "ep3_etyyy_kerssoc_poached_goods",
	leftDialog = "@conversation/ep3_etyyy_kerssoc:s_1056", --Right. I was expecting you with these poached goods. Return to Manfred and let him know I'll ship these next chance I get.
	stopConversation = "true",
	options = {}
}
ep3_etyyy_kerssoc_convotemplate:addScreen(ep3_etyyy_kerssoc_poached_goods);

-- s_1301/s_1302/s_1303 carry identical text in the client. All three are kept so no shipped key is
-- dropped; the handler uses one per in-flight leg.
ep3_etyyy_kerssoc_busy_escort = ConvoScreen:new {
	id = "ep3_etyyy_kerssoc_busy_escort",
	leftDialog = "@conversation/ep3_etyyy_kerssoc:s_1301", --It looks like you already have a mission in space. Come back once you've completed that one.
	stopConversation = "true",
	options = {}
}
ep3_etyyy_kerssoc_convotemplate:addScreen(ep3_etyyy_kerssoc_busy_escort);

ep3_etyyy_kerssoc_busy_weapons = ConvoScreen:new {
	id = "ep3_etyyy_kerssoc_busy_weapons",
	leftDialog = "@conversation/ep3_etyyy_kerssoc:s_1302", --It looks like you already have a mission in space. Come back once you've completed that one.
	stopConversation = "true",
	options = {}
}
ep3_etyyy_kerssoc_convotemplate:addScreen(ep3_etyyy_kerssoc_busy_weapons);

ep3_etyyy_kerssoc_busy_other = ConvoScreen:new {
	id = "ep3_etyyy_kerssoc_busy_other",
	leftDialog = "@conversation/ep3_etyyy_kerssoc:s_1303", --It looks like you already have a mission in space. Come back once you've completed that one.
	stopConversation = "true",
	options = {}
}
ep3_etyyy_kerssoc_convotemplate:addScreen(ep3_etyyy_kerssoc_busy_other);


-- Ground screens folded in (ruling 2026-09-04). Screen ids are the shipped
-- java keys. Existing space screens above are untouched.
ep3_etyyy_kerssoc_convo_s_1064 = ConvoScreen:new {
	id = "s_1064",
	leftDialog = "@conversation/ep3_etyyy_kerssoc:s_1064", -- Good. The gate is just to the west. You can enter there. Once you're inside, go to the main Rodian h...
	stopConversation = "true",
	options = {}
}
ep3_etyyy_kerssoc_convotemplate:addScreen(ep3_etyyy_kerssoc_convo_s_1064)

ep3_etyyy_kerssoc_convo_s_1068 = ConvoScreen:new {
	id = "s_1068",
	leftDialog = "@conversation/ep3_etyyy_kerssoc:s_1068", -- Very well. Return to me when you're ready to enter Etyyy.
	stopConversation = "true",
	options = {}
}
ep3_etyyy_kerssoc_convotemplate:addScreen(ep3_etyyy_kerssoc_convo_s_1068)

ep3_etyyy_kerssoc_convo_s_1076 = ConvoScreen:new {
	id = "s_1076",
	leftDialog = "@conversation/ep3_etyyy_kerssoc:s_1076", -- Good. Off you go then.
	stopConversation = "true",
	options = {}
}
ep3_etyyy_kerssoc_convotemplate:addScreen(ep3_etyyy_kerssoc_convo_s_1076)

ep3_etyyy_kerssoc_convo_s_1080 = ConvoScreen:new {
	id = "s_1080",
	leftDialog = "@conversation/ep3_etyyy_kerssoc:s_1080", -- Fine. But don't wait too long.
	stopConversation = "true",
	options = {}
}
ep3_etyyy_kerssoc_convotemplate:addScreen(ep3_etyyy_kerssoc_convo_s_1080)

ep3_etyyy_kerssoc_convo_s_1303 = ConvoScreen:new {
	id = "s_1303",
	leftDialog = "@conversation/ep3_etyyy_kerssoc:s_1303", -- It looks like you already have a mission in space. Come back once you've completed that one.
	stopConversation = "true",
	options = {}
}
ep3_etyyy_kerssoc_convotemplate:addScreen(ep3_etyyy_kerssoc_convo_s_1303)

ep3_etyyy_kerssoc_convo_s_1086 = ConvoScreen:new {
	id = "s_1086",
	leftDialog = "@conversation/ep3_etyyy_kerssoc:s_1086", -- Yeah. Let's hope so.
	stopConversation = "true",
	options = {}
}
ep3_etyyy_kerssoc_convotemplate:addScreen(ep3_etyyy_kerssoc_convo_s_1086)

ep3_etyyy_kerssoc_convo_s_1090 = ConvoScreen:new {
	id = "s_1090",
	leftDialog = "@conversation/ep3_etyyy_kerssoc:s_1090", -- Really. Don't hurry or anything.
	stopConversation = "true",
	options = {}
}
ep3_etyyy_kerssoc_convotemplate:addScreen(ep3_etyyy_kerssoc_convo_s_1090)

ep3_etyyy_kerssoc_convo_s_1302 = ConvoScreen:new {
	id = "s_1302",
	leftDialog = "@conversation/ep3_etyyy_kerssoc:s_1302", -- It looks like you already have a mission in space. Come back once you've completed that one.
	stopConversation = "true",
	options = {}
}
ep3_etyyy_kerssoc_convotemplate:addScreen(ep3_etyyy_kerssoc_convo_s_1302)

ep3_etyyy_kerssoc_convo_s_1096 = ConvoScreen:new {
	id = "s_1096",
	leftDialog = "@conversation/ep3_etyyy_kerssoc:s_1096", -- Good. Go to it. Make sure nothing happens to those supplies.
	stopConversation = "true",
	options = {}
}
ep3_etyyy_kerssoc_convotemplate:addScreen(ep3_etyyy_kerssoc_convo_s_1096)

ep3_etyyy_kerssoc_convo_s_1100 = ConvoScreen:new {
	id = "s_1100",
	leftDialog = "@conversation/ep3_etyyy_kerssoc:s_1100", -- Hmm. I see.
	stopConversation = "true",
	options = {}
}
ep3_etyyy_kerssoc_convotemplate:addScreen(ep3_etyyy_kerssoc_convo_s_1100)

ep3_etyyy_kerssoc_convo_s_1108 = ConvoScreen:new {
	id = "s_1108",
	leftDialog = "@conversation/ep3_etyyy_kerssoc:s_1108", -- No. Not yet. We've only just started. Next I need you to deliver these flawless Kashyyyk bantha pelt...
	stopConversation = "false",
	options = {
		{"@conversation/ep3_etyyy_kerssoc:s_1110", "s_1112"},
		{"@conversation/ep3_etyyy_kerssoc:s_1114", "s_1116"},
	}
}
ep3_etyyy_kerssoc_convotemplate:addScreen(ep3_etyyy_kerssoc_convo_s_1108)

ep3_etyyy_kerssoc_convo_s_1301 = ConvoScreen:new {
	id = "s_1301",
	leftDialog = "@conversation/ep3_etyyy_kerssoc:s_1301", -- It looks like you already have a mission in space. Come back once you've completed that one.
	stopConversation = "true",
	options = {}
}
ep3_etyyy_kerssoc_convotemplate:addScreen(ep3_etyyy_kerssoc_convo_s_1301)

ep3_etyyy_kerssoc_convo_s_1112 = ConvoScreen:new {
	id = "s_1112",
	leftDialog = "@conversation/ep3_etyyy_kerssoc:s_1112", -- Good. Away you go then. Fly to the Corellia system. Once there, you'll receive word on where to meet...
	stopConversation = "true",
	options = {}
}
ep3_etyyy_kerssoc_convotemplate:addScreen(ep3_etyyy_kerssoc_convo_s_1112)

ep3_etyyy_kerssoc_convo_s_1116 = ConvoScreen:new {
	id = "s_1116",
	leftDialog = "@conversation/ep3_etyyy_kerssoc:s_1116", -- Okay. Come back when you're ready.
	stopConversation = "true",
	options = {}
}
ep3_etyyy_kerssoc_convotemplate:addScreen(ep3_etyyy_kerssoc_convo_s_1116)

ep3_etyyy_kerssoc_convo_s_1122 = ConvoScreen:new {
	id = "s_1122",
	leftDialog = "@conversation/ep3_etyyy_kerssoc:s_1122", -- Good.
	stopConversation = "true",
	options = {}
}
ep3_etyyy_kerssoc_convotemplate:addScreen(ep3_etyyy_kerssoc_convo_s_1122)

ep3_etyyy_kerssoc_convo_s_1128 = ConvoScreen:new {
	id = "s_1128",
	leftDialog = "@conversation/ep3_etyyy_kerssoc:s_1128", -- Eager? That's a good sign. First I want to see what kind of hunter you are. And to be honest, I want...
	stopConversation = "false",
	options = {
		{"@conversation/ep3_etyyy_kerssoc:s_1130", "s_1132"},
	}
}
ep3_etyyy_kerssoc_convotemplate:addScreen(ep3_etyyy_kerssoc_convo_s_1128)

ep3_etyyy_kerssoc_convo_s_1144 = ConvoScreen:new {
	id = "s_1144",
	leftDialog = "@conversation/ep3_etyyy_kerssoc:s_1144", -- Fine. Go away.
	stopConversation = "true",
	options = {}
}
ep3_etyyy_kerssoc_convotemplate:addScreen(ep3_etyyy_kerssoc_convo_s_1144)

ep3_etyyy_kerssoc_convo_s_1132 = ConvoScreen:new {
	id = "s_1132",
	leftDialog = "@conversation/ep3_etyyy_kerssoc:s_1132", -- Yes, I do. You could get away with it. Probably. I'm mostly sure you could. At the very least, Sorda...
	stopConversation = "false",
	options = {
		{"@conversation/ep3_etyyy_kerssoc:s_1134", "s_1136"},
		{"@conversation/ep3_etyyy_kerssoc:s_1138", "s_1140"},
	}
}
ep3_etyyy_kerssoc_convotemplate:addScreen(ep3_etyyy_kerssoc_convo_s_1132)

ep3_etyyy_kerssoc_convo_s_1136 = ConvoScreen:new {
	id = "s_1136",
	leftDialog = "@conversation/ep3_etyyy_kerssoc:s_1136", -- Good. Go to it. 17 flawless Kashyyyk bantha pelts. I'll be waiting.
	stopConversation = "true",
	options = {}
}
ep3_etyyy_kerssoc_convotemplate:addScreen(ep3_etyyy_kerssoc_convo_s_1136)

ep3_etyyy_kerssoc_convo_s_1140 = ConvoScreen:new {
	id = "s_1140",
	leftDialog = "@conversation/ep3_etyyy_kerssoc:s_1140", -- If you can't stomach something simple like this, you have no hope of ever entering Etyyy.
	stopConversation = "true",
	options = {}
}
ep3_etyyy_kerssoc_convotemplate:addScreen(ep3_etyyy_kerssoc_convo_s_1140)

ep3_etyyy_kerssoc_convo_s_1150 = ConvoScreen:new {
	id = "s_1150",
	leftDialog = "@conversation/ep3_etyyy_kerssoc:s_1150", -- Indeed I am. Not yet to the level of those in the actual hunting grounds, but I will be soon. Oh, so...
	stopConversation = "false",
	options = {
		{"@conversation/ep3_etyyy_kerssoc:s_1152", "s_1154"},
	}
}
ep3_etyyy_kerssoc_convotemplate:addScreen(ep3_etyyy_kerssoc_convo_s_1150)

ep3_etyyy_kerssoc_convo_s_1166 = ConvoScreen:new {
	id = "s_1166",
	leftDialog = "@conversation/ep3_etyyy_kerssoc:s_1166", -- Good.
	stopConversation = "true",
	options = {}
}
ep3_etyyy_kerssoc_convotemplate:addScreen(ep3_etyyy_kerssoc_convo_s_1166)

ep3_etyyy_kerssoc_convo_s_1154 = ConvoScreen:new {
	id = "s_1154",
	leftDialog = "@conversation/ep3_etyyy_kerssoc:s_1154", -- That's right. The hunting grounds to the south. The Wookiees call that area Etyyy. Which I guess is ...
	stopConversation = "false",
	options = {
		{"@conversation/ep3_etyyy_kerssoc:s_1156", "s_1158"},
		{"@conversation/ep3_etyyy_kerssoc:s_1160", "s_1162"},
	}
}
ep3_etyyy_kerssoc_convotemplate:addScreen(ep3_etyyy_kerssoc_convo_s_1154)

ep3_etyyy_kerssoc_convo_s_1158 = ConvoScreen:new {
	id = "s_1158",
	leftDialog = "@conversation/ep3_etyyy_kerssoc:s_1158", -- Whoa. Not so fast. You have to get my permission before you'll be able to enter Etyyy.  First I want...
	stopConversation = "false",
	options = {
		{"@conversation/ep3_etyyy_kerssoc:s_1130", "s_1132"},
	}
}
ep3_etyyy_kerssoc_convotemplate:addScreen(ep3_etyyy_kerssoc_convo_s_1158)

ep3_etyyy_kerssoc_convo_s_1162 = ConvoScreen:new {
	id = "s_1162",
	leftDialog = "@conversation/ep3_etyyy_kerssoc:s_1162", -- Didn't think you looked like the hunting type anyway. Not really sure why I bothered to offer.
	stopConversation = "true",
	options = {}
}
ep3_etyyy_kerssoc_convotemplate:addScreen(ep3_etyyy_kerssoc_convo_s_1162)

ep3_etyyy_kerssoc_convo_s_1056 = ConvoScreen:new {
	id = "s_1056",
	leftDialog = "@conversation/ep3_etyyy_kerssoc:s_1056", -- Right. I was expecting you with these poached goods. Return to Manfred and let him know I'll ship th...
	stopConversation = "true",
	options = {}
}
ep3_etyyy_kerssoc_convotemplate:addScreen(ep3_etyyy_kerssoc_convo_s_1056)

ep3_etyyy_kerssoc_convo_s_1058 = ConvoScreen:new {
	id = "s_1058",
	leftDialog = "@conversation/ep3_etyyy_kerssoc:s_1058", -- I trust you're doing well in the hunting grounds.
	stopConversation = "true",
	options = {}
}
ep3_etyyy_kerssoc_convotemplate:addScreen(ep3_etyyy_kerssoc_convo_s_1058)

ep3_etyyy_kerssoc_convo_s_1060 = ConvoScreen:new {
	id = "s_1060",
	leftDialog = "@conversation/ep3_etyyy_kerssoc:s_1060", -- Well done with your attack on the Chiss camp. You've done far better than I ever expected. I suppose...
	stopConversation = "false",
	options = {
		{"@conversation/ep3_etyyy_kerssoc:s_1062", "s_1064"},
		{"@conversation/ep3_etyyy_kerssoc:s_1066", "s_1068"},
	}
}
ep3_etyyy_kerssoc_convotemplate:addScreen(ep3_etyyy_kerssoc_convo_s_1060)

ep3_etyyy_kerssoc_convo_s_1070 = ConvoScreen:new {
	id = "s_1070",
	leftDialog = "@conversation/ep3_etyyy_kerssoc:s_1070", -- Go on. Get to it. Those Chiss poachers aren't going to kill themselves.
	stopConversation = "true",
	options = {}
}
ep3_etyyy_kerssoc_convotemplate:addScreen(ep3_etyyy_kerssoc_convo_s_1070)

ep3_etyyy_kerssoc_convo_s_1072 = ConvoScreen:new {
	id = "s_1072",
	leftDialog = "@conversation/ep3_etyyy_kerssoc:s_1072", -- Good work destroying that shipment of Chiss weapons. Though it has kind of riled up the Chiss poache...
	stopConversation = "false",
	options = {
		{"@conversation/ep3_etyyy_kerssoc:s_1074", "s_1076"},
		{"@conversation/ep3_etyyy_kerssoc:s_1078", "s_1080"},
	}
}
ep3_etyyy_kerssoc_convotemplate:addScreen(ep3_etyyy_kerssoc_convo_s_1072)

ep3_etyyy_kerssoc_convo_s_1082 = ConvoScreen:new {
	id = "s_1082",
	leftDialog = "@conversation/ep3_etyyy_kerssoc:s_1082", -- What happened to destroying the ship full of Chiss poacher weapons? Couldn't handle it? Or did you s...
	stopConversation = "false",
	options = {
		{"@conversation/ep3_etyyy_kerssoc:s_1084", "s_1086"},
		{"@conversation/ep3_etyyy_kerssoc:s_1088", "s_1090"},
	}
}
ep3_etyyy_kerssoc_convotemplate:addScreen(ep3_etyyy_kerssoc_convo_s_1082)

ep3_etyyy_kerssoc_convo_s_1092 = ConvoScreen:new {
	id = "s_1092",
	leftDialog = "@conversation/ep3_etyyy_kerssoc:s_1092", -- You were supposed to escort a shipment of supplies. What happened? Ah, whatever. I'll give you anoth...
	stopConversation = "false",
	options = {
		{"@conversation/ep3_etyyy_kerssoc:s_1094", "s_1096"},
		{"@conversation/ep3_etyyy_kerssoc:s_1098", "s_1100"},
	}
}
ep3_etyyy_kerssoc_convotemplate:addScreen(ep3_etyyy_kerssoc_convo_s_1092)

ep3_etyyy_kerssoc_convo_s_1102 = ConvoScreen:new {
	id = "s_1102",
	leftDialog = "@conversation/ep3_etyyy_kerssoc:s_1102", -- Go deliver those pelts. Times a-wasting.
	stopConversation = "true",
	options = {}
}
ep3_etyyy_kerssoc_convotemplate:addScreen(ep3_etyyy_kerssoc_convo_s_1102)

ep3_etyyy_kerssoc_convo_s_1104 = ConvoScreen:new {
	id = "s_1104",
	leftDialog = "@conversation/ep3_etyyy_kerssoc:s_1104", -- Well, look at these flawless Kashyyyk bantha pelts. Well done. I'd say I'm impressed, but it's not l...
	stopConversation = "false",
	options = {
		{"@conversation/ep3_etyyy_kerssoc:s_1106", "s_1108"},
	}
}
ep3_etyyy_kerssoc_convotemplate:addScreen(ep3_etyyy_kerssoc_convo_s_1104)

ep3_etyyy_kerssoc_convo_s_1118 = ConvoScreen:new {
	id = "s_1118",
	leftDialog = "@conversation/ep3_etyyy_kerssoc:s_1118", -- Go get those flawless Kashyyyk bantha pelts. I'm waiting.
	stopConversation = "false",
	options = {
		{"@conversation/ep3_etyyy_kerssoc:s_1120", "s_1122"},
	}
}
ep3_etyyy_kerssoc_convotemplate:addScreen(ep3_etyyy_kerssoc_convo_s_1118)

ep3_etyyy_kerssoc_convo_s_1124 = ConvoScreen:new {
	id = "s_1124",
	animation = "greet",
	leftDialog = "@conversation/ep3_etyyy_kerssoc:s_1124", -- You want to enter the hunting grounds? You think Etyyy is open to just anyone? Ha. Not even close. I...
	stopConversation = "false",
	options = {
		{"@conversation/ep3_etyyy_kerssoc:s_1126", "s_1128"},
		{"@conversation/ep3_etyyy_kerssoc:s_1142", "s_1144"},
	}
}
ep3_etyyy_kerssoc_convotemplate:addScreen(ep3_etyyy_kerssoc_convo_s_1124)

ep3_etyyy_kerssoc_convo_s_1146 = ConvoScreen:new {
	id = "s_1146",
	leftDialog = "@conversation/ep3_etyyy_kerssoc:s_1146", -- Bah, you're no hunter. Leave now.
	stopConversation = "false",
	options = {
		{"@conversation/ep3_etyyy_kerssoc:s_1148", "s_1150"},
		{"@conversation/ep3_etyyy_kerssoc:s_1164", "s_1166"},
	}
}
ep3_etyyy_kerssoc_convotemplate:addScreen(ep3_etyyy_kerssoc_convo_s_1146)

addConversationTemplate("ep3_etyyy_kerssoc_convotemplate", ep3_etyyy_kerssoc_convotemplate);
