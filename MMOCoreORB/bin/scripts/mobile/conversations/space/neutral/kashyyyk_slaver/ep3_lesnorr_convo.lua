-- Lesnorr -- Trandoshan slaver shuttle operator, Kashyyyk.
--
-- Giver for convoy/ep3_trando_lesnorr (KashyyykSlaverScreenplay.lua, registered line 766). Before
-- this file the only thing in the repo that named that quest was a comment in
-- screenplays/space/SpaceConvoyScreenplay.lua:56; it had no giver.
--
-- EVERY leftDialog and EVERY option below is a verbatim shipped key from
-- conversation/ep3_trandoshan_lesnorr.stf (20 entries). Nothing is authored.
--
-- The arc is unambiguous end to end and matches the screenplay field for field: s_1020 "I run a
-- group of shuttles that transfer the captured furballs from here up to the Avatar Space Platform"
-- is the screenplay's convoyPoints run to the Avatar Platform; "the resistance has been getting
-- bolder and bolder in attacking our convoys" is its attackShips list, which is wke_resist_tier4 /
-- wke_resist_tier5; s_1024 "For every ship you get through I will pay extra" is the convoy
-- screenplay's per-survivor payout.
--
-- FLAGGED INTERPRETATION -- SCREEN TOPOLOGY. The client ships no screen graph. The order used here
-- is the .stf's own key order, which for this file already reads as a single depth-first walk.
--
-- UNUSED SHIPPED KEYS: s_998 only (empty string in the client file).

ep3_lesnorr_convotemplate = ConvoTemplate:new {
	initialScreen = "ep3_lesnorr_greeting",
	templateType = "Lua",
	luaClassHandler = "Ep3LesnorrConvoHandler",
	screens = {}
}

ep3_lesnorr_greeting = ConvoScreen:new {
	id = "ep3_lesnorr_greeting",
	leftDialog = "@conversation/ep3_trandoshan_lesnorr:s_1016", --A a pilot...you are a pilot, aren't you? Of course you are. I can tell just by the way you walk...that arrogant strut, smug expressive, air of absolute confidence...no one but a pilot can pull that look off.
	stopConversation = "false",
	options = {
		{"@conversation/ep3_trandoshan_lesnorr:s_1018", "ep3_lesnorr_offer_1"}, --I know my way around a cockpit. What do you want?
	}
}
ep3_lesnorr_convotemplate:addScreen(ep3_lesnorr_greeting);

ep3_lesnorr_offer_1 = ConvoScreen:new {
	id = "ep3_lesnorr_offer_1",
	leftDialog = "@conversation/ep3_trandoshan_lesnorr:s_1020", --I need to hire some guards. Actually I would prefer to hire a team of them. You see I run a group of shuttles that transfer the captured furballs from here up to the Avatar Space Platform. Unfortunately, the resistance has been getting bolder and bolder in attacking our convoys. I need fighter pilots who can protect my shuttles.
	stopConversation = "false",
	options = {
		{"@conversation/ep3_trandoshan_lesnorr:s_1022", "ep3_lesnorr_offer_2"}, --I could be interested in that.
		{"@conversation/ep3_trandoshan_lesnorr:s_1030", "ep3_lesnorr_decline"}, --No thanks, I don't feel like escorting slave shuttles.
	}
}
ep3_lesnorr_convotemplate:addScreen(ep3_lesnorr_offer_1);

ep3_lesnorr_offer_2 = ConvoScreen:new {
	id = "ep3_lesnorr_offer_2",
	leftDialog = "@conversation/ep3_trandoshan_lesnorr:s_1024", --Good. How I run things is that I fill up several shuttles at the same time and send them in convoys to the station. This helps reduce overhead, but also means if I lose a convoy I take a big hit. For every ship you get through I will pay extra and if you can get them all through in one piece I will have a bonus for you.
	stopConversation = "false",
	options = {
		{"@conversation/ep3_trandoshan_lesnorr:s_1026", "ep3_lesnorr_accept"}, --Right. When do we leave?
	}
}
ep3_lesnorr_convotemplate:addScreen(ep3_lesnorr_offer_2);

-- The grant happens in the handler on this screen id.
ep3_lesnorr_accept = ConvoScreen:new {
	id = "ep3_lesnorr_accept",
	leftDialog = "@conversation/ep3_trandoshan_lesnorr:s_1028", --The convoy is ready to launch as soon as it has an escort waiting for it in space. I highly recommend that you put together a few other pilots to help you out on this. The resistance tends to attack in larger forces against a convoy and a single pilot might have trouble keeping those shuttles safe.
	stopConversation = "true",
	options = {}
}
ep3_lesnorr_convotemplate:addScreen(ep3_lesnorr_accept);

ep3_lesnorr_decline = ConvoScreen:new {
	id = "ep3_lesnorr_decline",
	leftDialog = "@conversation/ep3_trandoshan_lesnorr:s_1032", --Suit yourself. I don't want to hire someone who isn't willing to give their all any ways.
	stopConversation = "true",
	options = {}
}
ep3_lesnorr_convotemplate:addScreen(ep3_lesnorr_decline);

-- Not a pilot, or JTL is off.
ep3_lesnorr_no_pilot = ConvoScreen:new {
	id = "ep3_lesnorr_no_pilot",
	leftDialog = "@conversation/ep3_trandoshan_lesnorr:s_1035", --Sorry but I am looking for some trained pilots to lend me a hand. Until you learn to fly, you are really not very useful to me.
	stopConversation = "true",
	options = {}
}
ep3_lesnorr_convotemplate:addScreen(ep3_lesnorr_no_pilot);

-- Convoy contract already running.
ep3_lesnorr_busy = ConvoScreen:new {
	id = "ep3_lesnorr_busy",
	leftDialog = "@conversation/ep3_trandoshan_lesnorr:s_1008", --You look like you are already engaged with a pilot job. Finish that up and then talk to me.
	stopConversation = "true",
	options = {}
}
ep3_lesnorr_convotemplate:addScreen(ep3_lesnorr_busy);

-- Convoy delivered; the bonus he promised in s_1024 is paid on s_1006.
ep3_lesnorr_complete = ConvoScreen:new {
	id = "ep3_lesnorr_complete",
	leftDialog = "@conversation/ep3_trandoshan_lesnorr:s_1002", --I received word that you managed to get the convoy through. I knew that you had it in you. I would have loved to see the looks on those resistance furball's faces when you blew them to pieces.
	stopConversation = "false",
	options = {
		{"@conversation/ep3_trandoshan_lesnorr:s_1004", "ep3_lesnorr_bonus"}, --It wasn't any problem.
	}
}
ep3_lesnorr_convotemplate:addScreen(ep3_lesnorr_complete);

ep3_lesnorr_bonus = ConvoScreen:new {
	id = "ep3_lesnorr_bonus",
	leftDialog = "@conversation/ep3_trandoshan_lesnorr:s_1006", --Maybe not but I am impressed. Here is a little something extra for your troubles.
	stopConversation = "true",
	options = {}
}
ep3_lesnorr_convotemplate:addScreen(ep3_lesnorr_bonus);

ep3_lesnorr_paid = ConvoScreen:new {
	id = "ep3_lesnorr_paid",
	leftDialog = "@conversation/ep3_trandoshan_lesnorr:s_1000", --I appreciate your assistance in getting my convoy to the Avatar. But unfortunately I do not have time to chat with you right now. Thanks again, pilot.
	stopConversation = "true",
	options = {}
}
ep3_lesnorr_convotemplate:addScreen(ep3_lesnorr_paid);

--[[
	FLAGGED INTERPRETATION -- FAILURE DETECTION. s_1010 "you lost every shuttle in the fleet" is
	written for a convoy that was wiped out. SpaceConvoyScreenplay does not record a per-survivor
	count anywhere the conversation can read, so this handler cannot tell "lost the convoy" from
	"abandoned the mission": it shows this arc to anyone who once accepted the contract and no longer
	has it active or complete. The text is client fact; that trigger is not.
]]
ep3_lesnorr_lost = ConvoScreen:new {
	id = "ep3_lesnorr_lost",
	leftDialog = "@conversation/ep3_trandoshan_lesnorr:s_1010", --I can understand losing a few shuttles but you lost every shuttle in the fleet. I didn't even know that was possible. My profits for this month are completely ruined.
	stopConversation = "false",
	options = {
		{"@conversation/ep3_trandoshan_lesnorr:s_1012", "ep3_lesnorr_retry"}, --Give me another shot. I will get a convoy safely through.
	}
}
ep3_lesnorr_convotemplate:addScreen(ep3_lesnorr_lost);

-- Re-grant happens in the handler on this screen id.
ep3_lesnorr_retry = ConvoScreen:new {
	id = "ep3_lesnorr_retry",
	leftDialog = "@conversation/ep3_trandoshan_lesnorr:s_1014", --I am not entirely sure I should trust you with this again. That convoy cost me plenty of credits but if you can get another on through I should be able to make up for my losses by increasing my prices. Make sure you bring a team with you. Now get up there and protect my convoy.
	stopConversation = "true",
	options = {}
}
ep3_lesnorr_convotemplate:addScreen(ep3_lesnorr_retry);

addConversationTemplate("ep3_lesnorr_convotemplate", ep3_lesnorr_convotemplate);
