-- scripts/mobile/conversations/mustafar/striking_miners_urst.lua
--
-- Urup Fal'co -- giver and turn-in for som_striking_miners, the Mensix
-- Mining Company's side of the labour dispute.  Runs on
-- somStrikingMinersScreenPlay.
--
-- THIS TREE IS NOT INFERRED.  It is SOE's own conversation script,
-- conversation/striking_miners_urst.java, read node for node.  The file
-- keeps SOE's name ("urst") even though the shipped display name is "Urup
-- Fal'co" (som_striking_miners.stf journal + task04).  Strings are the
-- shipped rows of string/en/conversation/striking_miners_urst.stf.
--
-- SOE's greeting dispatch is four conditions, first match wins:
--
--   hasCompletedQuest("som_striking_miners")                   s_4   done
--   isTaskActive(...,"mustafar_striking_miners_five")          s_6   report
--   isQuestActive("som_striking_miners")                       s_16  checkin
--   default                                                    s_13  greeting
--
-- mustafar_striking_miners_five is the .qst's turn-in wait, which is
-- somStrikingMinersScreenPlay's STAGE_REPORT_URUP.  The handler maps it
-- that way.
--
-- Two side effects, both in the handler, both exactly where SOE put them:
--   s_32 -> s_34   groundquests.grantQuest(player, "som_striking_miners")
--   s_19 -> s_20   sendSignal(player, "mustafar_striking_miners_reward")
--
-- The decline (s_36) and the not-yet answer (s_17) change nothing.  That
-- is SOE's behaviour, so it is this file's too.
--
-- Animations are SOE's too.  animation is the NPC's and playerAnimation is
-- the player's (ConversationScreen.h:203-208).  A screen with no anim line
-- in SOE's script gets neither field; s_38, s_16 and s_18 are the three
-- here that have none, and Urup uses no player animations at all.

striking_miners_urst = ConvoTemplate:new {
	initialScreen = "greeting",
	templateType = "Lua",
	luaClassHandler = "striking_miners_urst_conv_handler",
	screens = {}
}

-- =====================================================================
-- First meeting.  s_13 -> s_15 -> s_22 -> s_24 -> s_26 -> s_28 -> s_30,
-- then the accept/decline pair s_32 / s_36.
-- =====================================================================

striking_miners_urst_greeting = ConvoScreen:new {
	id = "greeting",
	animation = "bow3",
	leftDialog = "@conversation/striking_miners_urst:s_13", -- Welcome, my friend. What brings you to our humble facility?
	stopConversation = "false",
	options = {
		{"@conversation/striking_miners_urst:s_15", "what_is_this_place"}, -- Just looking around. What is this place?
	}
}
striking_miners_urst:addScreen(striking_miners_urst_greeting)

striking_miners_urst_what_is_this_place = ConvoScreen:new {
	id = "what_is_this_place",
	animation = "explain",
	leftDialog = "@conversation/striking_miners_urst:s_22", -- This is mining facility AG3-T of the Mensix Mining Company. Our world is rich with many resources that are considered to be desirable in numerous systems throughout the galaxy. We Mustafarians have made a very comfortable living supplying those systems.
	stopConversation = "false",
	options = {
		{"@conversation/striking_miners_urst:s_24", "not_very_busy"}, -- For a mining facility, it doesn't seem to be very busy.
	}
}
striking_miners_urst:addScreen(striking_miners_urst_what_is_this_place)

striking_miners_urst_not_very_busy = ConvoScreen:new {
	id = "not_very_busy",
	animation = "nod",
	leftDialog = "@conversation/striking_miners_urst:s_26", -- A very astute observation. It is true we are having a bit of a labor crisis. A group of our miners have gone on strike and we are having a great deal of difficulty getting them to at least talk with us.
	stopConversation = "false",
	options = {
		{"@conversation/striking_miners_urst:s_28", "anything_i_can_do"}, -- Is there anything I can do?
	}
}
striking_miners_urst:addScreen(striking_miners_urst_not_very_busy)

striking_miners_urst_anything_i_can_do = ConvoScreen:new {
	id = "anything_i_can_do",
	animation = "rub_chin_thoughtful",
	leftDialog = "@conversation/striking_miners_urst:s_30", -- Maybe there is. The striking miners refuse to talk with anyone involved with the company, but maybe they will talk to a third party. If you could convince the miners to return to the talks, that would be most helpful.
	stopConversation = "false",
	options = {
		{"@conversation/striking_miners_urst:s_32", "accept"}, -- I will try to convince them to talk with you again.
		{"@conversation/striking_miners_urst:s_36", "decline"}, -- Nah, I don't think I should get involved in a labor dispute.
	}
}
striking_miners_urst:addScreen(striking_miners_urst_anything_i_can_do)

-- ACTION grantMission: groundquests.grantQuest(player, "som_striking_miners")
striking_miners_urst_accept = ConvoScreen:new {
	id = "accept",
	animation = "thank",
	leftDialog = "@conversation/striking_miners_urst:s_34", -- That is most kind of you. You will need to speak with Nurfa Laz'op. He is heading up the group of miners. They have a camp not too far from here. Do your best to convince them to return to the negotiations with us. We need those miners to get back to work, but we also wish to do right by them. Thank you again.
	stopConversation = "true",
	options = {}
}
striking_miners_urst:addScreen(striking_miners_urst_accept)

striking_miners_urst_decline = ConvoScreen:new {
	id = "decline",
	leftDialog = "@conversation/striking_miners_urst:s_38", -- That is too bad. Well, I hope you enjoy your stay on our world.
	stopConversation = "true",
	options = {}
}
striking_miners_urst:addScreen(striking_miners_urst_decline)

-- =====================================================================
-- Quest active, Nurfa not yet turned around.  s_16 -> s_17 -> s_18.
-- No side effect.
-- =====================================================================

striking_miners_urst_checkin = ConvoScreen:new {
	id = "checkin",
	leftDialog = "@conversation/striking_miners_urst:s_16", -- Have you managed to convince Nurfa to return to the negotiations?
	stopConversation = "false",
	options = {
		{"@conversation/striking_miners_urst:s_17", "not_yet"}, -- Not yet.
	}
}
striking_miners_urst:addScreen(striking_miners_urst_checkin)

striking_miners_urst_not_yet = ConvoScreen:new {
	id = "not_yet",
	leftDialog = "@conversation/striking_miners_urst:s_18", -- I really hope you can get him to return soon.
	stopConversation = "true",
	options = {}
}
striking_miners_urst:addScreen(striking_miners_urst_not_yet)

-- =====================================================================
-- Turn-in.  s_6 -> s_19 -> s_20.  s_20 is where the reward is handed over
-- and where mustafar_striking_miners_reward fires.
-- =====================================================================

striking_miners_urst_report = ConvoScreen:new {
	id = "report",
	animation = "beckon",
	leftDialog = "@conversation/striking_miners_urst:s_6", -- How did your talks with Nurfa go?
	stopConversation = "false",
	options = {
		{"@conversation/striking_miners_urst:s_19", "hand_in"}, -- I managed to convince him to return to the talks with you.
	}
}
striking_miners_urst:addScreen(striking_miners_urst_report)

-- ACTION grantreward: sendSignal(player, "mustafar_striking_miners_reward")
striking_miners_urst_hand_in = ConvoScreen:new {
	id = "hand_in",
	animation = "thank",
	leftDialog = "@conversation/striking_miners_urst:s_20", -- That is most excellent news. Hopefully, we can hammer out a deal that both parties will be satisfied with. Please accept this as a token of the company's appreciation for what you have done. Thank you, my friend.
	stopConversation = "true",
	options = {}
}
striking_miners_urst:addScreen(striking_miners_urst_hand_in)

-- =====================================================================
-- After the quest.  s_4, a bubble with no options.
-- =====================================================================

striking_miners_urst_done = ConvoScreen:new {
	id = "done",
	animation = "nod",
	leftDialog = "@conversation/striking_miners_urst:s_4", -- It is good to see you are still doing well.
	stopConversation = "true",
	options = {}
}
striking_miners_urst:addScreen(striking_miners_urst_done)

addConversationTemplate("striking_miners_urst", striking_miners_urst)
