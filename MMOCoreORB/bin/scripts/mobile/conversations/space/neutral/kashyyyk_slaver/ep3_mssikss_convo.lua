-- Mssikss -- Trandoshan slaver, Kashyyyk. Lost a freighter full of Imperial prototype slave collars.
--
-- Giver for recovery/ep3_trando_mssikss (KashyyykSlaverScreenplay.lua, registered line 712). Before
-- this file nothing in the repo gave that quest out.
--
-- EVERY leftDialog and EVERY option below is a verbatim shipped key from
-- conversation/ep3_trandoshan_mssikss.stf (26 entries). Nothing is authored.
--
-- The arc matches the screenplay field for field: s_1141/s_1145 "I just received a shipment of these
-- new prototype collars from the Empire r and d station on Naboo... the freighter carrying them was
-- hijacked as soon as it entered Kashyyyk space" is questZone space_kashyyyk with recoverShip
-- trn_slaver_barge_tier4; s_1149 "fly out to my freighter... kill all the resistance fighters that
-- attacked it... then escort it to a safe landing spot" is preRecoveryPoints -> attackShips
-- (wke_resist_tier4 / wke_resist_tier5) -> recoveryPoints, in that order.
--
-- FLAGGED INTERPRETATION -- SCREEN TOPOLOGY. The client ships no screen graph. The order used here
-- is a depth-first walk of the .stf's own key order, which for this file reads as one continuous
-- conversation (greeting s_1137 -> s_1141 -> s_1145 -> s_1149 -> s_1153) with the state screens
-- (s_1117 / s_1119 / s_1125 / s_1127) sitting above it.
--
-- UNUSED SHIPPED KEYS: s_1115 only (empty string in the client file).

ep3_mssikss_convotemplate = ConvoTemplate:new {
	initialScreen = "ep3_mssikss_greeting",
	templateType = "Lua",
	luaClassHandler = "Ep3MssikssConvoHandler",
	screens = {}
}

ep3_mssikss_greeting = ConvoScreen:new {
	id = "ep3_mssikss_greeting",
	leftDialog = "@conversation/ep3_trandoshan_mssikss:s_1137", --Hey, you are a fighter pilot. One of my men saw you land in the space port. I will pay you top credit if you help me out of crisis. What do you say...do we have a deal?
	stopConversation = "false",
	options = {
		{"@conversation/ep3_trandoshan_mssikss:s_1139", "ep3_mssikss_problem"}, --Slow down. What is the problem?
		{"@conversation/ep3_trandoshan_mssikss:s_1159", "ep3_mssikss_decline_greeting"}, --No thanks. I have some other stuff to do.
	}
}
ep3_mssikss_convotemplate:addScreen(ep3_mssikss_greeting);

ep3_mssikss_problem = ConvoScreen:new {
	id = "ep3_mssikss_problem",
	leftDialog = "@conversation/ep3_trandoshan_mssikss:s_1141", --I just received a shipment of these new prototype collars from the Empire r and d station on Naboo. These collars do it all...they can be used for control, they can inject a calming drug directly into the blood stream...they even have an air freshener built into them. These collars are absolutely cutting edge stuff.
	stopConversation = "false",
	options = {
		{"@conversation/ep3_trandoshan_mssikss:s_1143", "ep3_mssikss_hijacked"}, --That doesn't sound much like a problem.
	}
}
ep3_mssikss_convotemplate:addScreen(ep3_mssikss_problem);

ep3_mssikss_hijacked = ConvoScreen:new {
	id = "ep3_mssikss_hijacked",
	leftDialog = "@conversation/ep3_trandoshan_mssikss:s_1145", --Well, it wouldn't be if the freighter carrying them wasn't hijacked as soon as it entered Kashyyyk space. Would you go recover that freighter and those collars for me? I promise to make it worth your while. Someone had to tip the resistance off about its arrival.
	stopConversation = "false",
	options = {
		{"@conversation/ep3_trandoshan_mssikss:s_1147", "ep3_mssikss_task"}, --Ok, what do you need me to do.
		{"@conversation/ep3_trandoshan_mssikss:s_1155", "ep3_mssikss_decline_task"}, --No thanks. Good luck getting those collars back.
	}
}
ep3_mssikss_convotemplate:addScreen(ep3_mssikss_hijacked);

ep3_mssikss_task = ConvoScreen:new {
	id = "ep3_mssikss_task",
	leftDialog = "@conversation/ep3_trandoshan_mssikss:s_1149", --I need you to fly out to my freighter before they can get it out of the system. Then kill all the resistance fighters that attacked it. Get the freighter back under our control. And then escort it to a safe landing spot. Do that for me and I will see to it you are rewarded.
	stopConversation = "false",
	options = {
		{"@conversation/ep3_trandoshan_mssikss:s_1151", "ep3_mssikss_accept"}, --Let's do this.
	}
}
ep3_mssikss_convotemplate:addScreen(ep3_mssikss_task);

-- The grant happens in the handler on this screen id.
ep3_mssikss_accept = ConvoScreen:new {
	id = "ep3_mssikss_accept",
	leftDialog = "@conversation/ep3_trandoshan_mssikss:s_1153", --That is the best news I have heard all day. I will see you when you get back.
	stopConversation = "true",
	options = {}
}
ep3_mssikss_convotemplate:addScreen(ep3_mssikss_accept);

ep3_mssikss_decline_task = ConvoScreen:new {
	id = "ep3_mssikss_decline_task",
	leftDialog = "@conversation/ep3_trandoshan_mssikss:s_1157", --Fine...then quite wasting my time. I need to find a pilot before they destroy my collars.
	stopConversation = "true",
	options = {}
}
ep3_mssikss_convotemplate:addScreen(ep3_mssikss_decline_task);

ep3_mssikss_decline_greeting = ConvoScreen:new {
	id = "ep3_mssikss_decline_greeting",
	leftDialog = "@conversation/ep3_trandoshan_mssikss:s_1161", --Yeah, right...whatever. Fine then don't stand around gawking at me.
	stopConversation = "true",
	options = {}
}
ep3_mssikss_convotemplate:addScreen(ep3_mssikss_decline_greeting);

-- Not a pilot, or JTL is off. s_1163 is the client's own brush-off for exactly that case.
ep3_mssikss_no_pilot = ConvoScreen:new {
	id = "ep3_mssikss_no_pilot",
	leftDialog = "@conversation/ep3_trandoshan_mssikss:s_1163", --I do not have time to chat right now. I am in desperate need of a fighter pilot. Now please leave me alone.
	stopConversation = "true",
	options = {}
}
ep3_mssikss_convotemplate:addScreen(ep3_mssikss_no_pilot);

-- Recovery already running.
ep3_mssikss_busy = ConvoScreen:new {
	id = "ep3_mssikss_busy",
	leftDialog = "@conversation/ep3_trandoshan_mssikss:s_1125", --You already have a job to do. Finish what you started. I have need of a good pilot but I need you to be completely focused on my task before I am willing to give it to you.
	stopConversation = "true",
	options = {}
}
ep3_mssikss_convotemplate:addScreen(ep3_mssikss_busy);

ep3_mssikss_complete = ConvoScreen:new {
	id = "ep3_mssikss_complete",
	leftDialog = "@conversation/ep3_trandoshan_mssikss:s_1119", --Oh, these collars are going to do a world of good in the field. Once we get this around those stinking furball's necks they will be completely under our control. You have done me a great service today.
	stopConversation = "false",
	options = {
		{"@conversation/ep3_trandoshan_mssikss:s_1121", "ep3_mssikss_reward"}, --About my reward?
	}
}
ep3_mssikss_convotemplate:addScreen(ep3_mssikss_complete);

ep3_mssikss_reward = ConvoScreen:new {
	id = "ep3_mssikss_reward",
	leftDialog = "@conversation/ep3_trandoshan_mssikss:s_1123", --Yes, I promised to pay you handsomely and that is what I intend to do. We keep our deals unlike the furballs who will break their word at the slightest provocation. Here you go. Take care, pilot.
	stopConversation = "true",
	options = {}
}
ep3_mssikss_convotemplate:addScreen(ep3_mssikss_reward);

-- Every hail after the payoff. The client wrote him an ending: the collars turned out to be junk.
ep3_mssikss_paid = ConvoScreen:new {
	id = "ep3_mssikss_paid",
	leftDialog = "@conversation/ep3_trandoshan_mssikss:s_1117", --Hey, it is you again. You know what. Those collars are worthless. The scientists at the R and D center obviously didn't field test them...get a little bit of dirt or hair into them and they completely malfunction. Well, not completely...the air freshener still works. Oh, well...back to doing things the old fashioned way. Take care, pilot.
	stopConversation = "true",
	options = {}
}
ep3_mssikss_convotemplate:addScreen(ep3_mssikss_paid);

--[[
	FLAGGED INTERPRETATION -- FAILURE DETECTION. s_1127 "that freighter got jumped too" is written
	for a player who took the recovery and lost it. SpaceRecoveryScreenplay does not leave a
	distinguishable failure record the conversation can read, so this handler cannot separate "lost
	the freighter" from "abandoned the job": it shows this arc to anyone who once accepted and no
	longer has the quest active or complete. The text is client fact; that trigger is not.
]]
ep3_mssikss_retry = ConvoScreen:new {
	id = "ep3_mssikss_retry",
	leftDialog = "@conversation/ep3_trandoshan_mssikss:s_1127", --I must say that the Empire's representative isn't at all pleased with what happened. So they called in another shipment...and....and....that's right, you guessed it...that freighter got jumped too. Would you care to give it another shot?
	stopConversation = "false",
	options = {
		{"@conversation/ep3_trandoshan_mssikss:s_1129", "ep3_mssikss_retry_yes"}, --I will not fail again.
		{"@conversation/ep3_trandoshan_mssikss:s_1133", "ep3_mssikss_retry_no"}, --I am not doing that again.
	}
}
ep3_mssikss_convotemplate:addScreen(ep3_mssikss_retry);

-- Re-grant happens in the handler on this screen id.
ep3_mssikss_retry_yes = ConvoScreen:new {
	id = "ep3_mssikss_retry_yes",
	leftDialog = "@conversation/ep3_trandoshan_mssikss:s_1131", --Yes, please don't. The Empire gives us a lot of leeway here but if we keep losing their gear they might have a change of heart.
	stopConversation = "true",
	options = {}
}
ep3_mssikss_convotemplate:addScreen(ep3_mssikss_retry_yes);

ep3_mssikss_retry_no = ConvoScreen:new {
	id = "ep3_mssikss_retry_no",
	leftDialog = "@conversation/ep3_trandoshan_mssikss:s_1135", --Bah...I should have known you wouldn't be willing to try that again.
	stopConversation = "true",
	options = {}
}
ep3_mssikss_convotemplate:addScreen(ep3_mssikss_retry_no);

addConversationTemplate("ep3_mssikss_convotemplate", ep3_mssikss_convotemplate);
