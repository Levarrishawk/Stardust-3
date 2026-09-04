-- scripts/mobile/conversations/mustafar/maneater_ulon.lua
--
-- Chief Ulon Glost -- giver and turn-in for som_maneater, "The Man-eater".
-- Runs on maneaterScreenPlay.
--
-- THIS TREE IS NOT INFERRED.  It is SOE's own conversation script,
-- conversation/maneater_ulon, read node for node.  The NPC's shipped display
-- name comes from the same script, which renames the mob "Chief Ulon Glost"
-- on attach -- the .qst spells him "Chief Glost" and both spellings are
-- reproduced where each one ships.  Strings are the shipped rows of
-- string/en/conversation/maneater_ulon.stf.
--
-- SOE's greeting dispatch is four conditions, first match wins:
--
--   hasCompletedQuest("som_maneater")                     s_4   bark, done
--   isTaskActive(...,"mustafar_maneater_five")            s_6   bark, turn_in
--   isQuestActive("som_maneater")                         s_8   checkin
--   default                                               s_18  greeting
--
-- The first two are chat.chat barks, not conversation windows: SOE says the
-- line over the NPC's head and returns.  They are rendered here as screens
-- with stopConversation "true" and no options, the same way every other bark
-- in this directory is.
--
-- THE TURN-IN IS A BARK.  s_6 is where the reward fires -- SOE calls
-- rewardTime (sendSignal "mustafar_maneater_reward") in the dispatch, before
-- the bark, with no player choice in between.  Walking up to him with task
-- five active IS the hand-in.
--
-- Task mapping onto maneaterScreenPlay's stages:
--   mustafar_maneater_four  = task 4, the Encounter   = STAGE_HUNT
--   mustafar_maneater_five  = task 7, Wait for Signal = STAGE_RETURN
--
-- s_15 ("I had it and I lost it") is CONDITIONAL: SOE only offers it while
-- task four is live, i.e. Foehorn was spawned and got away.  A ConvoScreen
-- option list is static, so s_14 is declared here and s_15 is added onto the
-- cloned screen in the handler.  Same idiom as
-- cube_ithes_olok_conv_handler.lua:37-41.
--
-- Three side effects, all in the handler, all exactly where SOE put them:
--   s_6            rewardTime    sendSignal(player, "mustafar_maneater_reward")
--   s_15 -> s_17   clearMission then startMission, both "som_maneater"
--   s_24 -> s_26   startMission  grantQuest(player, "som_maneater")
--
-- s_14 (the reassurance) and s_28 (the polite refusal) grant nothing.
--
-- Animations are SOE's.  animation is the NPC's and playerAnimation is the
-- player's (ConversationScreen.h:203-208).  Where SOE fires the player's
-- animation on selecting the option and the NPC's on the reply, both land on
-- the resulting screen -- there is no earlier screen to hang them on.

maneater_ulon = ConvoTemplate:new {
	initialScreen = "greeting",
	templateType = "Lua",
	luaClassHandler = "maneater_ulon_conv_handler",
	screens = {}
}

-- =====================================================================
-- First meeting.  s_18 -> s_20 -> s_22, then the branch: s_24 takes the
-- job, s_28 wishes him luck and leaves.
-- =====================================================================

maneater_ulon_greeting = ConvoScreen:new {
	id = "greeting",
	animation = "check_wrist_device",
	leftDialog = "@conversation/maneater_ulon:s_18", -- I am afraid that I do not have time to talk to you right now. We have a crisis brewing here and I need to focus on getting the problem dealt with.
	stopConversation = "false",
	options = {
		{"@conversation/maneater_ulon:s_20", "maybe_help"}, -- Maybe I can help.
	}
}
maneater_ulon:addScreen(maneater_ulon_greeting)

maneater_ulon_maybe_help = ConvoScreen:new {
	id = "maybe_help",
	animation = "rub_chin_thoughtful",
	leftDialog = "@conversation/maneater_ulon:s_22", -- Hmmm...you do look like someone who might be able to help us. There has been a series of attacks on our miners by a tulrus. Those things normally don't bother anyone unless provoked, but this one seems different. It has already attacked numerous miners, killing several of them. Our crews refuse to go out unless we can take care of the problem.
	stopConversation = "false",
	options = {
		{"@conversation/maneater_ulon:s_24", "accept"}, -- I am an expert hunter. I will help out.
		{"@conversation/maneater_ulon:s_28", "decline"}, -- Sounds like you have a lot to deal with. Good luck.
	}
}
maneater_ulon:addScreen(maneater_ulon_maybe_help)

-- ACTION startMission: groundquests.grantQuest(player, "som_maneater")
maneater_ulon_accept = ConvoScreen:new {
	id = "accept",
	animation = "celebrate",
	playerAnimation = "pose_proudly",
	leftDialog = "@conversation/maneater_ulon:s_26", -- That is the best news I have heard all day. We do not know which tulrus is doing this, so I am afraid we are going to have to kill tulrus in the areas of the attacks until we find it. Find tulrus and examine their stomach contents. That is the only way we can be sure.
	stopConversation = "true",
	options = {}
}
maneater_ulon:addScreen(maneater_ulon_accept)

maneater_ulon_decline = ConvoScreen:new {
	id = "decline",
	animation = "thank",
	leftDialog = "@conversation/maneater_ulon:s_30", -- Thank you, stranger. We will do our best.
	stopConversation = "true",
	options = {}
}
maneater_ulon:addScreen(maneater_ulon_decline)

-- =====================================================================
-- Quest active, the man-eater not yet down.  s_8 -> s_14, or s_15 while
-- the Encounter is live.  The s_15 path is SOE's retry: it clears the
-- quest and grants it again so the hunt runs from the top.
-- =====================================================================

maneater_ulon_checkin = ConvoScreen:new {
	id = "checkin",
	animation = "explain",
	leftDialog = "@conversation/maneater_ulon:s_8", -- We really need to find that rogue tulrus. The attacks are getting worse and our crews are scared.
	stopConversation = "false",
	options = {
		{"@conversation/maneater_ulon:s_14", "reassure"}, -- I will take care of it.
		-- s_15 "I had it and I lost it" is added by the handler while the
		-- player is on STAGE_HUNT.  See the header.
	}
}
maneater_ulon:addScreen(maneater_ulon_checkin)

maneater_ulon_reassure = ConvoScreen:new {
	id = "reassure",
	animation = "thank",
	leftDialog = "@conversation/maneater_ulon:s_16", -- That puts a lot of miners' minds at ease. Thank you.
	stopConversation = "true",
	options = {}
}
maneater_ulon:addScreen(maneater_ulon_reassure)

-- ACTION clearMission then startMission, both "som_maneater"
maneater_ulon_lost_it = ConvoScreen:new {
	id = "lost_it",
	animation = "pound_fist_palm",
	playerAnimation = "slump_head",
	leftDialog = "@conversation/maneater_ulon:s_17", -- That is too bad. We are going to have to go back to our original plan and start hunting tulrus in the area again. Hopefully, we will get another break and you will get it this time.
	stopConversation = "true",
	options = {}
}
maneater_ulon:addScreen(maneater_ulon_lost_it)

-- =====================================================================
-- Turn-in.  s_6, a bark.  rewardTime fires with it -- see the header.
-- =====================================================================

-- ACTION rewardTime: sendSignal(player, "mustafar_maneater_reward")
maneater_ulon_turn_in = ConvoScreen:new {
	id = "turn_in",
	animation = "celebrate1",
	playerAnimation = "expect_tip",
	leftDialog = "@conversation/maneater_ulon:s_6", -- You do not know how much better all the men feel. Thank you for taking down that rogue tulrus. The company has authorized me to issue you this reward for your service. Thank you again, my friend.
	stopConversation = "true",
	options = {}
}
maneater_ulon:addScreen(maneater_ulon_turn_in)

-- =====================================================================
-- After the quest.  s_4, a bark.  allowRepeats is true on the .qst, so
-- this is a record and not a lock -- the greeting comes back once the
-- screenplay's stage is cleared.
-- =====================================================================

maneater_ulon_done = ConvoScreen:new {
	id = "done",
	animation = "wave1",
	leftDialog = "@conversation/maneater_ulon:s_4", -- Hey, ever since you took care of that tulrus, our productivity has been up. We can't thank you enough.
	stopConversation = "true",
	options = {}
}
maneater_ulon:addScreen(maneater_ulon_done)

addConversationTemplate("maneater_ulon", maneater_ulon)
