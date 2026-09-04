-- scripts/mobile/conversations/mustafar/xandank_trophy.lua
--
-- Miner Renlo Hens -- giver and turn-in for som_xandank_trophey,
-- "A Whole Pack of Trouble".  Runs on trophyHuntsScreenPlay.
--
-- THIS TREE IS NOT INFERRED.  It is SOE's own conversation script,
-- conversation/xandank_trophy.java, read node for node.  Strings are the
-- shipped rows of string/en/conversation/xandank_trophy.stf.  Where a node
-- below differs from the .stf ordering, the .java is the reason.
--
-- SOE's greeting dispatch is four conditions, first match wins, in this
-- order.  The screen ids keep that order:
--
--   hasCompletedQuest("som_xandank_trophey")               s_4   done
--   isTaskActive("som_xandank_trophey","xandank_trophy_nine") s_6   return_hens
--   isQuestActive("som_xandank_trophey")                   s_10  checkin
--   default                                                s_14  greeting
--
-- xandank_trophy_nine is the .qst's turn-in wait, which is
-- trophyHuntsScreenPlay's STAGE_RETURN.  The handler maps it that way.
--
-- Two side effects, both in the handler, both exactly where SOE put them:
--   s_32 -> s_34   groundquests.grantQuest(player, "som_xandank_trophey")
--   s_19 -> s_20   groundquests.sendSignal(player, "xandank_trophy_signal_three")
--
-- Note the signal fires on the ACCEPT/hand-in reply, not on the greeting
-- that offers it.  Declining (s_36) and the still-looking answer (s_17)
-- change nothing -- that is SOE's behaviour, so it is this file's too.
--
-- Animations are SOE's too.  animation is the NPC's and playerAnimation is
-- the player's (ConversationScreen.h:203-208).  A screen with no anim line
-- in SOE's script gets neither field; s_10 and s_18, the hunt check-in pair,
-- are the two here that have none.

xandank_trophy = ConvoTemplate:new {
	initialScreen = "greeting",
	templateType = "Lua",
	luaClassHandler = "xandank_trophy_conv_handler",
	screens = {}
}

-- =====================================================================
-- First meeting.  s_14 -> s_16 -> s_22 -> s_24 -> s_26 -> s_28 -> s_30,
-- then the accept/decline pair s_32 / s_36.
-- =====================================================================

xandank_trophy_greeting = ConvoScreen:new {
	id = "greeting",
	animation = "nod",
	leftDialog = "@conversation/xandank_trophy:s_14", -- Welcome, off-worlder. I wish I could greet you in a time when things were not so dire. But I am afraid that we have lots of troubles.
	stopConversation = "false",
	options = {
		{"@conversation/xandank_trophy:s_16", "so_dire"}, -- Really? What could be so...er....dire?
	}
}
xandank_trophy:addScreen(xandank_trophy_greeting)

xandank_trophy_so_dire = ConvoScreen:new {
	id = "so_dire",
	animation = "explain",
	leftDialog = "@conversation/xandank_trophy:s_22", -- Well, as you can see, work in this camp has shut down. Headquarters simply is working us too hard without proper compensation, so we have to stand up for ourselves. Naturally, that means we haven't seen any fresh supplies in days. And to make matters worse, we are being hounded by a pack of xandanks.
	stopConversation = "false",
	options = {
		{"@conversation/xandank_trophy:s_24", "further_east"}, -- Xandanks? Aren't they usually further east?
	}
}
xandank_trophy:addScreen(xandank_trophy_so_dire)

xandank_trophy_further_east = ConvoScreen:new {
	id = "further_east",
	animation = "sigh_deeply",
	playerAnimation = "rub_chin_thoughtful",
	leftDialog = "@conversation/xandank_trophy:s_26", -- Yeah. It is very strange to see a pack this far west. We have our suspicions that someone might have intentionally placed this pack in this region just to cause us problems. Not that we can prove anything, of course. That pack has been causing all sorts of problems with our crews out in the field trying to gather up any supplies we can get our hands on.
	stopConversation = "false",
	options = {
		{"@conversation/xandank_trophy:s_28", "why_not_hunt"}, -- Why don't you just hunt down and kill the pack?
	}
}
xandank_trophy:addScreen(xandank_trophy_further_east)

xandank_trophy_why_not_hunt = ConvoScreen:new {
	id = "why_not_hunt",
	animation = "explain",
	leftDialog = "@conversation/xandank_trophy:s_30", -- I wish we could. With everything else going on, we just do not have the manpower to spend hunting down a pack of xandanks that are really just a nuisance.
	stopConversation = "false",
	options = {
		{"@conversation/xandank_trophy:s_32", "accept"}, -- Tell you what...I will hunt them down for you.
		{"@conversation/xandank_trophy:s_36", "decline"}, -- Yeah, sounds like you do have troubles. Good luck with that.
	}
}
xandank_trophy:addScreen(xandank_trophy_why_not_hunt)

-- ACTION startMission: groundquests.grantQuest(player, "som_xandank_trophey")
xandank_trophy_accept = ConvoScreen:new {
	id = "accept",
	animation = "point_away",
	leftDialog = "@conversation/xandank_trophy:s_34", -- You would? That would be wonderful. I am not sure where they are, but I do know the last place they were spotted. If you can search around that area, maybe you can track them down. I would just ask that if you find them, you eliminate the whole pack, especially the pack leader. In fact, bring me back the head of the pack leader, so I can report to the boys that the xandanks are all dead. Thanks again.
	stopConversation = "true",
	options = {}
}
xandank_trophy:addScreen(xandank_trophy_accept)

xandank_trophy_decline = ConvoScreen:new {
	id = "decline",
	animation = "nod",
	leftDialog = "@conversation/xandank_trophy:s_38", -- Yeah, I will say we do.
	stopConversation = "true",
	options = {}
}
xandank_trophy:addScreen(xandank_trophy_decline)

-- =====================================================================
-- Quest active, hunt not finished.  s_10 -> s_17 -> s_18.  No side effect.
-- =====================================================================

xandank_trophy_checkin = ConvoScreen:new {
	id = "checkin",
	leftDialog = "@conversation/xandank_trophy:s_10", -- How is the hunt for those xandanks going?
	stopConversation = "false",
	options = {
		{"@conversation/xandank_trophy:s_17", "still_looking"}, -- Still trying to track them down.
	}
}
xandank_trophy:addScreen(xandank_trophy_checkin)

xandank_trophy_still_looking = ConvoScreen:new {
	id = "still_looking",
	leftDialog = "@conversation/xandank_trophy:s_18", -- Okay. I cannot thank you enough for trying to help us out with this little problem.
	stopConversation = "true",
	options = {}
}
xandank_trophy:addScreen(xandank_trophy_still_looking)

-- =====================================================================
-- Hand-in.  s_6 -> s_19 -> s_20.  s_20 is where the reward is handed over
-- and where xandank_trophy_signal_three fires.
-- =====================================================================

xandank_trophy_return_hens = ConvoScreen:new {
	id = "return_hens",
	animation = "greet",
	leftDialog = "@conversation/xandank_trophy:s_6", -- Hello again. Did you manage to track down that pack of xandanks?
	stopConversation = "false",
	options = {
		{"@conversation/xandank_trophy:s_19", "hand_in"}, -- Sure did. And I brought back the pack leader head too.
	}
}
xandank_trophy:addScreen(xandank_trophy_return_hens)

-- ACTION giveReward: groundquests.sendSignal(player, "xandank_trophy_signal_three")
xandank_trophy_hand_in = ConvoScreen:new {
	id = "hand_in",
	animation = "manipulate_medium",
	playerAnimation = "manipulate_medium",
	leftDialog = "@conversation/xandank_trophy:s_20", -- That is the best news that I have heard in a long time. I must say that I am highly impressed that you were able to do this so quickly. Hold on for a moment...there...done. Here, please take this for your troubles. It is a trophy to show everyone what an excellent xandank hunter you are. Thanks again, my friend.
	stopConversation = "true",
	options = {}
}
xandank_trophy:addScreen(xandank_trophy_hand_in)

-- =====================================================================
-- After the quest.  s_4, a bubble with no options.
-- =====================================================================

xandank_trophy_done = ConvoScreen:new {
	id = "done",
	animation = "wave1",
	leftDialog = "@conversation/xandank_trophy:s_4", -- Things have been going a little easier for us now that those xandanks have been taken care of. We really appreciate you helping us out like that.
	stopConversation = "true",
	options = {}
}
xandank_trophy:addScreen(xandank_trophy_done)

addConversationTemplate("xandank_trophy", xandank_trophy)
