-- scripts/mobile/conversations/mustafar/lava_beetle_nest_destroy_donko.lua
--
-- Donko Jen -- giver and turn-in for som_lava_beetle_nest_destroy and its
-- repeat variant som_lava_beetle_nest_destroy_2.  Runs on
-- lavaBeetleNestsScreenPlay.
--
-- THIS TREE IS NOT INFERRED.  It is SOE's own conversation script,
-- conversation/lava_beetle_nest_destroy_donko.java, read node for node.
-- Strings are the shipped rows of
-- string/en/conversation/lava_beetle_nest_destroy_donko.stf.  His display
-- name "Donko Jen" is som_lava_beetle_nest_destroy.stf task02 and task04.
--
-- SOE's greeting dispatch is four conditions, first match wins, and EVERY
-- condition tests BOTH quest names -- the original and the _2 variant:
--
--   hasCompletedQuest(either)                                  s_4   done
--   isTaskActive(either,"mustafar_lava_beetle_nest_four")      s_12  report
--   isQuestActive(either)                                      s_11  checkin
--   default                                                    s_26  greeting
--
-- mustafar_lava_beetle_nest_four is the .qst's turn-in wait, which is
-- lavaBeetleNestsScreenPlay's STAGE_RETURN.  The handler maps it that way
-- and reads the active variant with lavaBeetleNestsScreenPlay:getVariant.
--
-- IMPORTANT, and this is SOE's doing, not a repo choice: the first-meeting
-- branch grants som_lava_beetle_nest_destroy_2, NOT the original.  The
-- original is granted elsewhere.  Both grant sites in this tree use _2.
--
-- Four side effects, all in the handler, all exactly where SOE put them:
--   s_44 -> s_46   grantQuest("..._2") + drop the beetle_nest scriptvar
--   s_38 -> s_40   clear BOTH quests + drop the scriptvar, then grant _2
--   s_37 -> s_39   clear BOTH quests + drop the scriptvar, grant nothing
--   s_15 -> s_16   sendSignal(player, "mustafar_lava_beetle_nest_reward")
--
-- The "I will get back out there" answer (s_31) changes nothing.
--
-- Animations are SOE's too.  animation is the NPC's and playerAnimation is
-- the player's (ConversationScreen.h:203-208).  Every screen here has an
-- anim line.
--
-- CORRECTING A FALSE CLAIM.  This header used to say, of s_42:
--
--   "One of them, s_42, is malformed in SOE's own script: it lists two
--    PLAYER animations ("shrug_hands", then "explain") and no NPC one.
--    ConversationScreen holds a single playerAnimation, so the first is
--    kept and the second is dropped"
--
-- It is not malformed and nothing has to be dropped.  SOE fires the two at
-- DIFFERENT moments: shrug_hands when the player picks s_34, explain when
-- Donko answers with s_42.  A screen field can only carry the second of
-- those, but the first is exactly what edgeAnimations in the handler is
-- for -- it plays on the edge, before the new screen is sent.  Both now
-- play, in SOE's order.
--
-- ROOT CAUSE: the claim was written before the edge mechanism was in the
-- repo, and it read the one-playerAnimation-per-screen limit as a limit on
-- the conversation rather than on the screen.  The animation checker did
-- not catch it because it was hardcoded to one handler's edge table.

lava_beetle_nest_destroy_donko = ConvoTemplate:new {
	initialScreen = "greeting",
	templateType = "Lua",
	luaClassHandler = "lava_beetle_nest_destroy_donko_conv_handler",
	screens = {}
}

-- =====================================================================
-- First meeting.  Donko mistakes the player for a new hire and never lets
-- the player finish a sentence: s_26 -> s_28 -> s_30 -> s_34 -> s_42 ->
-- s_44 -> s_46.  There is no decline -- SOE gave this branch none.
-- =====================================================================

lava_beetle_nest_destroy_donko_greeting = ConvoScreen:new {
	id = "greeting",
	animation = "handshake_tandem",
	playerAnimation = "handshake_tandem",
	leftDialog = "@conversation/lava_beetle_nest_destroy_donko:s_26", -- You must be that new off-world miner the company said was coming. Good to have you onboard and not a moment too soon. We have a job that needs your immediate attention.
	stopConversation = "false",
	options = {
		{"@conversation/lava_beetle_nest_destroy_donko:s_28", "wait_a_min"}, -- Uhhh...wait a min...
	}
}
lava_beetle_nest_destroy_donko:addScreen(lava_beetle_nest_destroy_donko_greeting)

lava_beetle_nest_destroy_donko_wait_a_min = ConvoScreen:new {
	id = "wait_a_min",
	animation = "shakefist",
	playerAnimation = "catchbreath",
	leftDialog = "@conversation/lava_beetle_nest_destroy_donko:s_30", -- I don't know how they did things in your previous crew, but on this crew, when I speak, you listen. We have found a new vein of mentchal, and it is a rich one. The problem is that there are four nests of those nasty kubaza beetles ringing the camp we set up to mine it. Before we can start our drilling, those nests needs to be cleaned up.
	stopConversation = "false",
	options = {
		{"@conversation/lava_beetle_nest_destroy_donko:s_34", "not_who_you_think"}, -- I am not who...
	}
}
lava_beetle_nest_destroy_donko:addScreen(lava_beetle_nest_destroy_donko_wait_a_min)

lava_beetle_nest_destroy_donko_not_who_you_think = ConvoScreen:new {
	id = "not_who_you_think",
	-- SOE plays player:shrug_hands on picking s_34 and player:explain with
	-- this reply. The first is on the edge in the handler; only the second
	-- belongs here. See the header.
	playerAnimation = "explain",
	leftDialog = "@conversation/lava_beetle_nest_destroy_donko:s_42", -- All you need to do is to take one of these charges and drop it into the mouth of each of the nests. Be careful because once you start messing with the nests, I am sure the kubaza soldiers will show up...they always do. Make sure you kill any of them that get out of the nests or they will just rebuild them. With your qualifications, this job should be no problem at all. Well, don't just stand there. Get moving.
	stopConversation = "false",
	options = {
		{"@conversation/lava_beetle_nest_destroy_donko:s_44", "accept"}, -- I don't know how...
	}
}
lava_beetle_nest_destroy_donko:addScreen(lava_beetle_nest_destroy_donko_not_who_you_think)

-- ACTION grantMission: grantQuest("som_lava_beetle_nest_destroy_2") and
-- remove the beetle_nest scriptvar tree if one is left over.
lava_beetle_nest_destroy_donko_accept = ConvoScreen:new {
	id = "accept",
	animation = "shoo",
	playerAnimation = "catchbreath",
	leftDialog = "@conversation/lava_beetle_nest_destroy_donko:s_46", -- No need to be modest. Just get out there, blow up those nests, and kill any soldiers that get out. We can discuss your permanent position when you get back. Good luck.
	stopConversation = "true",
	options = {}
}
lava_beetle_nest_destroy_donko:addScreen(lava_beetle_nest_destroy_donko_accept)

-- =====================================================================
-- Quest active, nests still standing.  s_11 offers two answers: keep
-- going (s_31) or give up (s_35).  Giving up leads to the restart pair.
-- =====================================================================

lava_beetle_nest_destroy_donko_checkin = ConvoScreen:new {
	id = "checkin",
	animation = "point_away",
	leftDialog = "@conversation/lava_beetle_nest_destroy_donko:s_11", -- Are those nests gone yet? No? Well, no time to chitchat. Get out there and get the job done. No excuses on this crew.
	stopConversation = "false",
	options = {
		{"@conversation/lava_beetle_nest_destroy_donko:s_31", "keep_going"}, -- Sorry, I will get back out there and do my best.
		{"@conversation/lava_beetle_nest_destroy_donko:s_35", "could_not_finish"}, -- I wasn't able to finish the job.
	}
}
lava_beetle_nest_destroy_donko:addScreen(lava_beetle_nest_destroy_donko_checkin)

lava_beetle_nest_destroy_donko_keep_going = ConvoScreen:new {
	id = "keep_going",
	animation = "nod",
	leftDialog = "@conversation/lava_beetle_nest_destroy_donko:s_32", -- See that you do.
	stopConversation = "true",
	options = {}
}
lava_beetle_nest_destroy_donko:addScreen(lava_beetle_nest_destroy_donko_keep_going)

lava_beetle_nest_destroy_donko_could_not_finish = ConvoScreen:new {
	id = "could_not_finish",
	animation = "rub_chin_thoughtful",
	playerAnimation = "explain",
	leftDialog = "@conversation/lava_beetle_nest_destroy_donko:s_36", -- I see. Well, my guess is that those beetles have already rebuilt their nests. You just need to get some more charges and get back out there and take care of business.
	stopConversation = "false",
	options = {
		{"@conversation/lava_beetle_nest_destroy_donko:s_37", "later"}, -- Maybe I will take care of it later.
		{"@conversation/lava_beetle_nest_destroy_donko:s_38", "restart"}, -- Ok, I am ready to do it this time.
	}
}
lava_beetle_nest_destroy_donko:addScreen(lava_beetle_nest_destroy_donko_could_not_finish)

-- ACTION clearMission: clear BOTH quest names and drop the beetle_nest
-- scriptvar tree.  Nothing is granted -- the player walks away clean.
lava_beetle_nest_destroy_donko_later = ConvoScreen:new {
	id = "later",
	animation = "wave_on_dismissing",
	leftDialog = "@conversation/lava_beetle_nest_destroy_donko:s_39", -- Bah, I thought you were supposed to be a specialist with this sort of thing. Well, I guess we will just have to wait for you to get ready.
	stopConversation = "true",
	options = {}
}
lava_beetle_nest_destroy_donko:addScreen(lava_beetle_nest_destroy_donko_later)

-- ACTION clearMission then grantMission: clear BOTH quest names, drop the
-- scriptvar tree, then grant som_lava_beetle_nest_destroy_2 fresh.
lava_beetle_nest_destroy_donko_restart = ConvoScreen:new {
	id = "restart",
	animation = "manipulate_medium",
	leftDialog = "@conversation/lava_beetle_nest_destroy_donko:s_40", -- Good. Here are the charges. Remember, there are four nests that need to be taken out. Be ready for those soldiers to retaliate.
	stopConversation = "true",
	options = {}
}
lava_beetle_nest_destroy_donko:addScreen(lava_beetle_nest_destroy_donko_restart)

-- =====================================================================
-- Turn-in.  s_12 -> s_13 -> s_14 -> s_15 -> s_16.  The joke is that Donko
-- only now works out the player never worked for him; s_16 is where the
-- reward is handed over and where the reward signal fires.
-- =====================================================================

lava_beetle_nest_destroy_donko_report = ConvoScreen:new {
	id = "report",
	animation = "thumbs_up",
	leftDialog = "@conversation/lava_beetle_nest_destroy_donko:s_12", -- The reports just came in. Nicely done. You have proven that you will be a fine addition to our team.
	stopConversation = "false",
	options = {
		{"@conversation/lava_beetle_nest_destroy_donko:s_13", "not_an_employee"}, -- I don't work for the company.
	}
}
lava_beetle_nest_destroy_donko:addScreen(lava_beetle_nest_destroy_donko_report)

lava_beetle_nest_destroy_donko_not_an_employee = ConvoScreen:new {
	id = "not_an_employee",
	animation = "wtf",
	playerAnimation = "explain",
	leftDialog = "@conversation/lava_beetle_nest_destroy_donko:s_14", -- Yes, I think that with you around, we will have the finest crew in the whole company. ...Did you just say that you do not work for the company?
	stopConversation = "false",
	options = {
		{"@conversation/lava_beetle_nest_destroy_donko:s_15", "hand_in"}, -- That is what I have been trying to tell you.
	}
}
lava_beetle_nest_destroy_donko:addScreen(lava_beetle_nest_destroy_donko_not_an_employee)

-- ACTION grantReward: sendSignal(player, "mustafar_lava_beetle_nest_reward")
lava_beetle_nest_destroy_donko_hand_in = ConvoScreen:new {
	id = "hand_in",
	animation = "shush",
	playerAnimation = "sigh_deeply",
	leftDialog = "@conversation/lava_beetle_nest_destroy_donko:s_16", -- Hmmm...well, maybe you should keep this under wraps. Having you go out and take care of that nest wasn't exactly legit, according to company bylaws. In fact, take this as payment for a job well done.
	stopConversation = "true",
	options = {}
}
lava_beetle_nest_destroy_donko:addScreen(lava_beetle_nest_destroy_donko_hand_in)

-- =====================================================================
-- After either variant.  s_4, a bubble with no options.
-- =====================================================================

lava_beetle_nest_destroy_donko_done = ConvoScreen:new {
	id = "done",
	animation = "thank",
	leftDialog = "@conversation/lava_beetle_nest_destroy_donko:s_4", -- Thanks for not saying anything to my foreman. I would have really gotten into hot water for sending a civilian out to a job site.
	stopConversation = "true",
	options = {}
}
lava_beetle_nest_destroy_donko:addScreen(lava_beetle_nest_destroy_donko_done)

addConversationTemplate("lava_beetle_nest_destroy_donko", lava_beetle_nest_destroy_donko)
