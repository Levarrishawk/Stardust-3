-- scripts/mobile/conversations/mustafar/striking_miners_nurfa.lua
--
-- Foreman Nurfa Laz'op -- the strikers' side of som_striking_miners.  He
-- does not give or complete the quest; he is the middle of it.  Runs on
-- somStrikingMinersScreenPlay.
--
-- THIS TREE IS NOT INFERRED.  It is SOE's own conversation script,
-- conversation/striking_miners_nurfa.java, read node for node.  Strings
-- are the shipped rows of
-- string/en/conversation/striking_miners_nurfa.stf.  His display name
-- "Foreman Nurfa Laz'op" is som_striking_miners.stf task01.
--
-- SOE's greeting dispatch is FIVE conditions, first match wins:
--
--   hasCompletedQuest("som_striking_miners")                   s_17  done
--   isTaskActive(...,"mustafar_striking_miners_three")         s_5   eggs_ready
--   isTaskActive(...,"mustafar_striking_miners_two")           s_11  checkin
--   isTaskActive(...,"mustafar_striking_miners_one")           s_22  greeting
--   default                                                    s_40  brush_off
--
-- Note the default.  Nurfa will NOT engage a player who has not been sent
-- by Urup Fal'co -- s_40 is a bubble with no options.  So is s_17.  That
-- is deliberate on SOE's part and it is kept here.
--
-- Two side effects, both in the handler, both exactly where SOE put them:
--   s_44 -> s_46   sendSignal(player, "mustafar_striking_miners_nurfa")
--   s_20 -> s_21   sendSignal(player, "mustafar_striking_miners_win")
--
-- The breather answer (s_15) changes nothing.
--
-- Animations are SOE's too.  animation is the NPC's and playerAnimation is
-- the player's (ConversationScreen.h:203-208).  A screen with no anim line
-- in SOE's script gets neither field -- s_11, the egg-run check-in, is the
-- one screen here that has none.

striking_miners_nurfa = ConvoTemplate:new {
	initialScreen = "brush_off",
	templateType = "Lua",
	luaClassHandler = "striking_miners_nurfa_conv_handler",
	screens = {}
}

-- =====================================================================
-- No quest, or quest not yet pointed at him.  s_40, a bubble with no
-- options.  This is also the template's initialScreen, so a player who
-- walks up cold gets the brush-off and nothing else.
-- =====================================================================

striking_miners_nurfa_brush_off = ConvoScreen:new {
	id = "brush_off",
	animation = "explain",
	leftDialog = "@conversation/striking_miners_nurfa:s_40", -- I am afraid that I cannot talk to you right now. I have a lot of planning to do with this strike and all. Hey, watch out for lava beetles. They have a nasty tendency to explode when you kill them.
	stopConversation = "true",
	options = {}
}
striking_miners_nurfa:addScreen(striking_miners_nurfa_brush_off)

-- =====================================================================
-- Sent by Urup.  s_22 -> s_24 -> s_26 -> s_28 -> s_30 -> s_32 -> s_34 ->
-- s_41 -> s_42 -> s_44 -> s_46.  SOE gave this branch no decline; the
-- player can only walk away by closing the window.
-- =====================================================================

striking_miners_nurfa_greeting = ConvoScreen:new {
	id = "greeting",
	animation = "check_wrist_device",
	leftDialog = "@conversation/striking_miners_nurfa:s_22", -- Sorry, I can't talk to you right now. I have too much planning to do.
	stopConversation = "false",
	options = {
		{"@conversation/striking_miners_nurfa:s_24", "urup_sent_me"}, -- Urup sent me to talk with you.
	}
}
striking_miners_nurfa:addScreen(striking_miners_nurfa_greeting)

striking_miners_nurfa_urup_sent_me = ConvoScreen:new {
	id = "urup_sent_me",
	animation = "threaten_combat",
	leftDialog = "@conversation/striking_miners_nurfa:s_26", -- Urup! So you're just some company messenger boy. You can go tell Urup that I am not interested in anything more the company has to say. We are going to start our own company. That will show them.
	stopConversation = "false",
	options = {
		{"@conversation/striking_miners_nurfa:s_28", "not_a_messenger"}, -- Listen, I am not a company messenger. I just want to help.
	}
}
striking_miners_nurfa:addScreen(striking_miners_nurfa_urup_sent_me)

striking_miners_nurfa_not_a_messenger = ConvoScreen:new {
	id = "not_a_messenger",
	animation = "wave_on_dismissing",
	playerAnimation = "standing_placate",
	leftDialog = "@conversation/striking_miners_nurfa:s_30", -- Yeah, right. Like I haven't heard that one before. Now run along. I think I hear your master calling.
	stopConversation = "false",
	options = {
		{"@conversation/striking_miners_nurfa:s_32", "trying_to_help"}, -- I don't work for the company. I am trying to help.
	}
}
striking_miners_nurfa:addScreen(striking_miners_nurfa_not_a_messenger)

striking_miners_nurfa_trying_to_help = ConvoScreen:new {
	id = "trying_to_help",
	animation = "gesticulate_wildly",
	leftDialog = "@conversation/striking_miners_nurfa:s_34", -- Okay, mister helpful guy...prove it. There is a place called Tulrus Isle out in the lava flows. The tulrus are known to nest there. You go collect me ten tulrus eggs, and that will show me you are more than just talk. If you can bring me those eggs, we will at least start talking with the company again.
	stopConversation = "false",
	options = {
		{"@conversation/striking_miners_nurfa:s_41", "tulrus_lay_eggs"}, -- Tulrus lay eggs?
	}
}
striking_miners_nurfa:addScreen(striking_miners_nurfa_trying_to_help)

striking_miners_nurfa_tulrus_lay_eggs = ConvoScreen:new {
	id = "tulrus_lay_eggs",
	animation = "rub_belly",
	playerAnimation = "wtf",
	leftDialog = "@conversation/striking_miners_nurfa:s_42", -- Sure they do. The steady heat on this rock makes incubation a snap. All you need to do is to travel out there, find their nesting sites, reach on into the nest, and pull out the eggs. Be careful. You wouldn't want to get trampled by an angry mama while stealing her eggs.
	stopConversation = "false",
	options = {
		{"@conversation/striking_miners_nurfa:s_44", "its_a_deal"}, -- It's a deal.
	}
}
striking_miners_nurfa:addScreen(striking_miners_nurfa_tulrus_lay_eggs)

-- ACTION sendFirstSignal: sendSignal(player, "mustafar_striking_miners_nurfa")
striking_miners_nurfa_its_a_deal = ConvoScreen:new {
	id = "its_a_deal",
	animation = "mock",
	leftDialog = "@conversation/striking_miners_nurfa:s_46", -- Yeah. Good luck with that, buddy.
	stopConversation = "true",
	options = {}
}
striking_miners_nurfa:addScreen(striking_miners_nurfa_its_a_deal)

-- =====================================================================
-- Out collecting eggs.  s_11 -> s_15 -> s_16.  No side effect.
-- =====================================================================

striking_miners_nurfa_checkin = ConvoScreen:new {
	id = "checkin",
	leftDialog = "@conversation/striking_miners_nurfa:s_11", -- So did you give up already?
	stopConversation = "false",
	options = {
		{"@conversation/striking_miners_nurfa:s_15", "breather"}, -- Just taking a breather.
	}
}
striking_miners_nurfa:addScreen(striking_miners_nurfa_checkin)

striking_miners_nurfa_breather = ConvoScreen:new {
	id = "breather",
	animation = "mock",
	leftDialog = "@conversation/striking_miners_nurfa:s_16", -- Yeah, you are going to need it.
	stopConversation = "true",
	options = {}
}
striking_miners_nurfa:addScreen(striking_miners_nurfa_breather)

-- =====================================================================
-- Eggs in hand.  s_5 -> s_18 -> s_19 -> s_20 -> s_21.  s_21 is where
-- mustafar_striking_miners_win fires and Nurfa agrees to go back to the
-- table.
-- =====================================================================

striking_miners_nurfa_eggs_ready = ConvoScreen:new {
	id = "eggs_ready",
	animation = "laugh",
	leftDialog = "@conversation/striking_miners_nurfa:s_5", -- Well, look who is back. Decide to give up yet?
	stopConversation = "false",
	options = {
		{"@conversation/striking_miners_nurfa:s_18", "here_are_the_eggs"}, -- Nope, here are your eggs.
	}
}
striking_miners_nurfa:addScreen(striking_miners_nurfa_eggs_ready)

striking_miners_nurfa_here_are_the_eggs = ConvoScreen:new {
	id = "here_are_the_eggs",
	animation = "wtf",
	playerAnimation = "manipulate_medium",
	leftDialog = "@conversation/striking_miners_nurfa:s_19", -- Whoa! You actually did it? I was kidding. No one is foolish enough to go out there and try to steal eggs from the tulrus. What is the matter with you?
	stopConversation = "false",
	options = {
		{"@conversation/striking_miners_nurfa:s_20", "a_deal_is_a_deal"}, -- Hey, you said if I got the eggs, you would go back to the talks.
	}
}
striking_miners_nurfa:addScreen(striking_miners_nurfa_here_are_the_eggs)

-- ACTION rewardTime: sendSignal(player, "mustafar_striking_miners_win")
striking_miners_nurfa_a_deal_is_a_deal = ConvoScreen:new {
	id = "a_deal_is_a_deal",
	animation = "smack_self",
	playerAnimation = "point_accusingly",
	leftDialog = "@conversation/striking_miners_nurfa:s_21", -- I did say that and a deal is a deal. This really didn't turn out the way I expected. Fine. You can tell Urup we will come back to the negotiations, but I am not promising anything beyond that. You have guts; I will give you that much.
	stopConversation = "true",
	options = {}
}
striking_miners_nurfa:addScreen(striking_miners_nurfa_a_deal_is_a_deal)

-- =====================================================================
-- After the quest.  s_17, a bubble with no options.
-- =====================================================================

striking_miners_nurfa_done = ConvoScreen:new {
	id = "done",
	animation = "standing_placate",
	leftDialog = "@conversation/striking_miners_nurfa:s_17", -- Look, I said I would return to the negotiations and I will. We made a deal and I do not break my deals.
	stopConversation = "true",
	options = {}
}
striking_miners_nurfa:addScreen(striking_miners_nurfa_done)

addConversationTemplate("striking_miners_nurfa", striking_miners_nurfa)
