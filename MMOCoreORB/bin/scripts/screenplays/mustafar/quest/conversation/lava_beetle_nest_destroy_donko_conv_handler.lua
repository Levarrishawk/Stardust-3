--[[
	Donko Jen -- conversation handler for the kubaza beetle nest job
	(som_lava_beetle_nest_destroy and som_lava_beetle_nest_destroy_2, both on
	lavaBeetleNestsScreenPlay).

	The tree is in
	mobile/conversations/mustafar/lava_beetle_nest_destroy_donko.lua.
	This file only routes.

	SOE's dispatch, and what each condition is here.  Every one of SOE's four
	conditions tests BOTH quest names; this screenplay carries both variants
	under one stage counter, so one stage test covers both:

	  hasCompletedQuest(either)                              -> done
	  isTaskActive(either,"mustafar_lava_beetle_nest_four")  -> report
	  isQuestActive(either)                                  -> checkin
	  default                                                -> greeting

	mustafar_lava_beetle_nest_four is the .qst's turn-in wait, which is
	STAGE_RETURN.  Unlike the other two Mensix givers this screenplay keeps a
	durable STAGE_DONE, so the done bubble routes off the stage directly and no
	run counter is needed.

	BOTH of SOE's grant sites pass variant "two", not "one".  That is SOE's
	choice, not a repo one -- see the grant block in lava_beetle_nests.lua.

	ONE EDGE ANIMATION.  Every other gesture in this tree fires with the reply
	and so lives on the screen, but s_34 fires one on the SELECTION and another
	on the reply.  A screen carries one playerAnimation, so the selection one is
	here on the edge and the reply one stays on the screen.  Same [from][to]
	shape as serpent_thief_conv_handler.
--]]

lava_beetle_nest_destroy_donko_conv_handler = conv_handler:new {}

-- [from screen][to screen] = { { actor, animation }, ... } in the order live plays them.
lava_beetle_nest_destroy_donko_conv_handler.edgeAnimations = {
	wait_a_min = {
		not_who_you_think = { { "player", "shrug_hands" } }, -- s_34
	},
}

function lava_beetle_nest_destroy_donko_conv_handler:getInitialScreen(pPlayer, pNpc, pConvTemplate)
	local convoTemplate = LuaConversationTemplate(pConvTemplate)
	local stage = lavaBeetleNestsScreenPlay:getStage(pPlayer)

	if (stage == lavaBeetleNestsScreenPlay.STAGE_DONE) then
		return convoTemplate:getScreen("done")
	elseif (stage == lavaBeetleNestsScreenPlay.STAGE_RETURN) then
		return convoTemplate:getScreen("report")
	elseif (stage > 0) then
		return convoTemplate:getScreen("checkin")
	end

	return convoTemplate:getScreen("greeting")
end

function lava_beetle_nest_destroy_donko_conv_handler:runScreenHandlers(pConvTemplate, pPlayer, pNpc, selectedOption, pConvScreen)
	local screen = LuaConversationScreen(pConvScreen)
	local screenID = screen:getScreenID()
	local pClonedScreen = screen:cloneScreen()
	local clonedConversation = LuaConversationScreen(pClonedScreen)

	self:playEdgeAnimations(pPlayer, pNpc, self:getLastScreenID(pPlayer), screenID)

	-- s_44 -> s_46.  grantQuest("som_lava_beetle_nest_destroy_2"), plus the
	-- leftover-scriptvar drop that grantNestQuest already does for us.
	if (screenID == "accept") then
		lavaBeetleNestsScreenPlay:grantNestQuest(pPlayer, "two")

	-- s_38 -> s_40.  clearQuest on BOTH names and drop the progress data,
	-- THEN grant _2 fresh.  Order matters: grantNestQuest refuses while a
	-- variant is still live.
	elseif (screenID == "restart") then
		lavaBeetleNestsScreenPlay:clearQuest(pPlayer)
		lavaBeetleNestsScreenPlay:grantNestQuest(pPlayer, "two")

	-- s_37 -> s_39.  clearQuest on both names and drop the progress data.
	-- Nothing is granted; the player walks away with no quest at all.
	elseif (screenID == "later") then
		lavaBeetleNestsScreenPlay:clearQuest(pPlayer)

	-- s_15 -> s_16.  sendSignal(player, "mustafar_lava_beetle_nest_reward").
	elseif (screenID == "hand_in") then
		lavaBeetleNestsScreenPlay:signalReward(pPlayer)
	end

	return pClonedScreen
end

-- The screen the player was looking at when he picked the option.  runScreenHandlers
-- runs before the new screen is sent, so this is still the previous one.  nil on the
-- opening screen.
function lava_beetle_nest_destroy_donko_conv_handler:getLastScreenID(pPlayer)
	if (pPlayer == nil) then
		return nil
	end

	local pSession = CreatureObject(pPlayer):getConversationSession()

	if (pSession == nil) then
		return nil
	end

	local pLastScreen = LuaConversationSession(pSession):getLastConversationScreen()

	if (pLastScreen == nil) then
		return nil
	end

	return LuaConversationScreen(pLastScreen):getScreenID()
end

function lava_beetle_nest_destroy_donko_conv_handler:playEdgeAnimations(pPlayer, pNpc, fromID, toID)
	if (fromID == nil) then
		return
	end

	local edges = self.edgeAnimations[fromID]

	if (edges == nil) then
		return
	end

	local animations = edges[toID]

	if (animations == nil) then
		return
	end

	for i = 1, #animations do
		local actor = animations[i][1] == "npc" and pNpc or pPlayer

		CreatureObject(actor):doAnimation(animations[i][2])
	end
end
