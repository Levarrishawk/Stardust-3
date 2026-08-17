-- Fezrik Bendledon -- contraband broker on Kashyyyk who supplies the Trandoshan slavers.
--
-- Giver for the four-leg smuggling run that had no giver:
--
--     delivery_no_pickup/ep3_trando_fezrik_01   (head, questZone space_naboo)
--         -> delivery_no_pickup/ep3_trando_fezrik_02   (space_corellia)
--             -> delivery_no_pickup/ep3_trando_fezrik_03   (space_lok)
--                 -> destroy_surpriseattack/ep3_trando_fezrik_04
--
-- All four globals live in screenplays/space/squadrons/KashyyykSlaverScreenplay.lua and are
-- registered there (lines 478, 511, 544, 574). Legs 02-04 are side quests with
-- SIDE_QUEST_SPLIT_TYPES.COMPLETION, so the screenplays hand them out themselves; only the head is
-- granted from this conversation.
--
-- EVERY leftDialog and EVERY option below is a verbatim shipped key from
-- conversation/ep3_trandoshan_fezrik_bendledon.stf (26 entries). Nothing is authored.
--
-- The route in s_865/s_869 is the chain, leg for leg: uller pelts to a Naboo client for computer
-- control chips (fezrik_01, questZone space_naboo, deliveryPoint fezrik_rendal_rendezvous), chips to
-- Corellia for blaster crystals (fezrik_02, space_corellia, fezrik_harkon_rendezvous), crystals to
-- Nym on Lok for glitterdust (fezrik_03, space_lok, fezrik_nym_rendezvous), then the run home --
-- which is where fezrik_04's surprise attack falls.
--
-- FLAGGED INTERPRETATION -- SCREEN TOPOLOGY. The client ships no screen graph. The order used here
-- is a depth-first walk of the .stf's own key order.
--
-- FLAGGED INTERPRETATION -- ONE REUSED OPTION KEY. s_881 ("It's not really breaking the law...") is
-- Fezrik's answer to the s_879 refusal, and the client ships no dedicated follow-up option for it.
-- Rather than author one, s_855 ("I am a pilot and always looking for a way to make credits.") --
-- already the greeting's accept option -- is reused there so the persuaded player rejoins the pitch.
-- The key is shipped text; using it twice is the interpretation.
--
-- UNUSED SHIPPED KEYS: s_836 only (empty string in the client file).

ep3_fezrik_bendledon_convotemplate = ConvoTemplate:new {
	initialScreen = "ep3_fezrik_greeting",
	templateType = "Lua",
	luaClassHandler = "Ep3FezrikBendledonConvoHandler",
	screens = {}
}

ep3_fezrik_greeting = ConvoScreen:new {
	id = "ep3_fezrik_greeting",
	leftDialog = "@conversation/ep3_trandoshan_fezrik_bendledon:s_853", --Are you looking for work? Of course you are. Everyone on this blasted planet is looking for work. I am looking for a pilot to run some errands for me. Of course, I need someone who isn't amiss to bend the laws a little bit.
	stopConversation = "false",
	options = {
		{"@conversation/ep3_trandoshan_fezrik_bendledon:s_855", "ep3_fezrik_pitch"}, --I am a pilot and always looking for a way to make credits.
		{"@conversation/ep3_trandoshan_fezrik_bendledon:s_879", "ep3_fezrik_legal"}, --I am not interested in bending or even break the law.
	}
}
ep3_fezrik_bendledon_convotemplate:addScreen(ep3_fezrik_greeting);

ep3_fezrik_legal = ConvoScreen:new {
	id = "ep3_fezrik_legal",
	leftDialog = "@conversation/ep3_trandoshan_fezrik_bendledon:s_881", --It's not really breaking the law. No one around here really cares what goes on, as long as the Empire keeps getting fresh supplies of Wookiees.
	stopConversation = "false",
	options = {
		{"@conversation/ep3_trandoshan_fezrik_bendledon:s_855", "ep3_fezrik_pitch"}, --I am a pilot and always looking for a way to make credits.
	}
}
ep3_fezrik_bendledon_convotemplate:addScreen(ep3_fezrik_legal);

ep3_fezrik_pitch = ConvoScreen:new {
	id = "ep3_fezrik_pitch",
	leftDialog = "@conversation/ep3_trandoshan_fezrik_bendledon:s_857", --Yeah, I thought you might be. What I have for you is very simple. The Trandoshans on occasion ask me to supply them with certain items that the Empire has deemed illegal. I have several contacts that I work through in order to get the Trandoshans what they want. The Empire either doesn't know about what I do or doesn't care.
	stopConversation = "false",
	options = {
		{"@conversation/ep3_trandoshan_fezrik_bendledon:s_859", "ep3_fezrik_empire"}, --Why wouldn't the Empire care about contraband?
	}
}
ep3_fezrik_bendledon_convotemplate:addScreen(ep3_fezrik_pitch);

ep3_fezrik_empire = ConvoScreen:new {
	id = "ep3_fezrik_empire",
	leftDialog = "@conversation/ep3_trandoshan_fezrik_bendledon:s_861", --It is simple. In order to keep themselves in cheap labor the Empire is willing to allow many things to slide. I even have Imperial pilots who work for me once in a while. We do our best not to rub it in their faces and they ignore what goes on.
	stopConversation = "false",
	options = {
		{"@conversation/ep3_trandoshan_fezrik_bendledon:s_863", "ep3_fezrik_route_1"}, --I see. So what is it you want me to do?
	}
}
ep3_fezrik_bendledon_convotemplate:addScreen(ep3_fezrik_empire);

-- Legs 1 and 2 of the chain, in the client's own words.
ep3_fezrik_route_1 = ConvoScreen:new {
	id = "ep3_fezrik_route_1",
	leftDialog = "@conversation/ep3_trandoshan_fezrik_bendledon:s_865", --I have managed to get my hands on some fine uller pelts. I have a client in the Naboo system, where the pelts are in high demand, who is willing to trade a load of computer control chips for the pelts. Then I would need those computer chips delivered to the Corellia system to another contact of mine. He is willing to trade the chips for a shipment of blaster crystals.
	stopConversation = "false",
	options = {
		{"@conversation/ep3_trandoshan_fezrik_bendledon:s_867", "ep3_fezrik_route_2"}, --Pelts for chips, chips for blaster crystals...check.
	}
}
ep3_fezrik_bendledon_convotemplate:addScreen(ep3_fezrik_route_1);

-- Legs 3 and 4.
ep3_fezrik_route_2 = ConvoScreen:new {
	id = "ep3_fezrik_route_2",
	leftDialog = "@conversation/ep3_trandoshan_fezrik_bendledon:s_869", --Then I need that load of blaster crystals brought over to the Lok system, where I have arranged a trade with Nym for some glitterdust. The glitterdust is what the Trandoshans want. So once you have made that final trade bring that back to me. Do you think you can handle this?
	stopConversation = "false",
	options = {
		{"@conversation/ep3_trandoshan_fezrik_bendledon:s_871", "ep3_fezrik_accept"}, --Not a problem. I will make your deliveries.
		{"@conversation/ep3_trandoshan_fezrik_bendledon:s_875", "ep3_fezrik_decline"}, --I am not a spice smuggler. No thanks.
	}
}
ep3_fezrik_bendledon_convotemplate:addScreen(ep3_fezrik_route_2);

-- The grant happens in the handler on this screen id.
ep3_fezrik_accept = ConvoScreen:new {
	id = "ep3_fezrik_accept",
	leftDialog = "@conversation/ep3_trandoshan_fezrik_bendledon:s_873", --Good. You shouldn't run into any problems from the authorities. Like I said they tend to ignore anything that helps keep the slave labor trade moving along. I will have the pelts loaded onto your ship so that it is all ready to go when you take off. See you in a little while.
	stopConversation = "true",
	options = {}
}
ep3_fezrik_bendledon_convotemplate:addScreen(ep3_fezrik_accept);

ep3_fezrik_decline = ConvoScreen:new {
	id = "ep3_fezrik_decline",
	leftDialog = "@conversation/ep3_trandoshan_fezrik_bendledon:s_877", --Suit yourself. If you happen to change your mind, just come back and talk to me.
	stopConversation = "true",
	options = {}
}
ep3_fezrik_bendledon_convotemplate:addScreen(ep3_fezrik_decline);

-- Not a pilot, or JTL is off.
ep3_fezrik_no_pilot = ConvoScreen:new {
	id = "ep3_fezrik_no_pilot",
	leftDialog = "@conversation/ep3_trandoshan_fezrik_bendledon:s_1034", --Hmmm...I don't think that you can help me out. I have need of a pilot. If you ever happen to become one look me up and I might have some work for you to do.
	stopConversation = "true",
	options = {}
}
ep3_fezrik_bendledon_convotemplate:addScreen(ep3_fezrik_no_pilot);

-- Any leg of the run still in flight.
ep3_fezrik_busy = ConvoScreen:new {
	id = "ep3_fezrik_busy",
	leftDialog = "@conversation/ep3_trandoshan_fezrik_bendledon:s_851", --Shouldn't you be doing something else. I don't have time for a pilot who already has a job to do.
	stopConversation = "true",
	options = {}
}
ep3_fezrik_bendledon_convotemplate:addScreen(ep3_fezrik_busy);

-- Glitterdust delivered -- the last leg (fezrik_04) is complete.
ep3_fezrik_complete = ConvoScreen:new {
	id = "ep3_fezrik_complete",
	leftDialog = "@conversation/ep3_trandoshan_fezrik_bendledon:s_839", --Ah, that is some high quality stuff. Those Trandoshans are going to pay through their noses for this stuff. As promise here is your payment for a job well done. Take care of yourself.
	stopConversation = "true",
	options = {}
}
ep3_fezrik_bendledon_convotemplate:addScreen(ep3_fezrik_complete);

-- Every hail after that. The client wrote him an explicit "nothing more for you" ending.
ep3_fezrik_thanks = ConvoScreen:new {
	id = "ep3_fezrik_thanks",
	leftDialog = "@conversation/ep3_trandoshan_fezrik_bendledon:s_1732", --Thanks again for the...stuff. You are a pretty decent pilot but I am afraid that I don't have anything more for you to do. Take care of yourself.
	stopConversation = "true",
	options = {}
}
ep3_fezrik_bendledon_convotemplate:addScreen(ep3_fezrik_thanks);

--[[
	FLAGGED INTERPRETATION -- FAILURE DETECTION. s_841 "That stuff cost me a lot of money and is not
	easily replaced" is written for a player who lost the cargo. The delivery and surprise-attack
	screenplays leave no distinguishable failure record the conversation can read, so this handler
	cannot separate "lost the run" from "walked away from it": it shows this arc to anyone who once
	accepted and now holds no leg of the chain active or complete. The text is client fact; that
	trigger is not.
]]
ep3_fezrik_failed = ConvoScreen:new {
	id = "ep3_fezrik_failed",
	leftDialog = "@conversation/ep3_trandoshan_fezrik_bendledon:s_841", --What happened out there? That stuff cost me a lot of money and is not easily replaced. You are lucky that I like you for some reason, otherwise you would find yourself sleeping with the fishes.
	stopConversation = "false",
	options = {
		{"@conversation/ep3_trandoshan_fezrik_bendledon:s_843", "ep3_fezrik_retry"}, --Listen, I know I screwed up. Let me make it up to you.
		{"@conversation/ep3_trandoshan_fezrik_bendledon:s_847", "ep3_fezrik_retry_no"}, --I just can't do this. I am sorry.
	}
}
ep3_fezrik_bendledon_convotemplate:addScreen(ep3_fezrik_failed);

-- Re-grant happens in the handler on this screen id. s_845 restates the whole route, so the re-grant
-- is of the HEAD (fezrik_01) and the chain runs again from Naboo -- which is what the text says.
ep3_fezrik_retry = ConvoScreen:new {
	id = "ep3_fezrik_retry",
	leftDialog = "@conversation/ep3_trandoshan_fezrik_bendledon:s_845", --I am not sure that I can trust you with another shipment. But I am always willing to give someone another chance. I will have another load of pelts put onto your ship. It is the same deal as before. Go to Naboo for load of chips. Then to Corellia for load of blaster crystals. Then to Lok for the spice. Bring me back the spice. Now get going! Those Trandoshans are waiting and they are not a patient bunch.
	stopConversation = "true",
	options = {}
}
ep3_fezrik_bendledon_convotemplate:addScreen(ep3_fezrik_retry);

ep3_fezrik_retry_no = ConvoScreen:new {
	id = "ep3_fezrik_retry_no",
	leftDialog = "@conversation/ep3_trandoshan_fezrik_bendledon:s_849", --Figures. I should have known that you couldn't hack it.
	stopConversation = "true",
	options = {}
}
ep3_fezrik_bendledon_convotemplate:addScreen(ep3_fezrik_retry_no);

addConversationTemplate("ep3_fezrik_bendledon_convotemplate", ep3_fezrik_bendledon_convotemplate);
