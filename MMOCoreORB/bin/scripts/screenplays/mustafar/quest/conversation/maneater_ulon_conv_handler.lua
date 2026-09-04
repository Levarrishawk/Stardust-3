--[[
	Chief Ulon Glost -- conversation handler for "The Man-eater"
	(maneaterScreenPlay).

	The tree is in mobile/conversations/mustafar/maneater_ulon.lua.  This file
	only routes and fires the three side effects.

	SOE's four dispatch conditions map onto maneaterScreenPlay's stages:

	  hasCompletedQuest("som_maneater")             -> runs > 0     -> done
	  isTaskActive(...,"mustafar_maneater_five")    -> STAGE_RETURN -> turn_in
	  isQuestActive("som_maneater")                 -> isActive     -> checkin
	  default                                                       -> greeting

	The order matters and is SOE's, not a preference: turn_in has to be tested
	before the generic "quest is active", because task five is still part of an
	active quest.

	getRuns is what stands in for hasCompletedQuest.  The .qst has allowRepeats
	true, so signalReward bumps a run counter and STAGE_DONE is a record rather
	than a lock -- the same reason miner_madness_chief_drono_conv_handler uses
	getRuns for its own "done" rung.

	s_15 is a CONDITIONAL option: SOE offers it only while the Encounter task is
	live, which is STAGE_HUNT.  ConvoScreen option lists are static, so it is
	added onto the CLONED screen here and the session stores that clone.
--]]

maneater_ulon_conv_handler = conv_handler:new {}

function maneater_ulon_conv_handler:getInitialScreen(pPlayer, pNpc, pConvTemplate)
	local convoTemplate = LuaConversationTemplate(pConvTemplate)
	local stage = maneaterScreenPlay:getStage(pPlayer)

	if (stage == maneaterScreenPlay.STAGE_RETURN) then
		return convoTemplate:getScreen("turn_in")
	elseif (maneaterScreenPlay:isActive(pPlayer)) then
		return convoTemplate:getScreen("checkin")
	elseif (maneaterScreenPlay:getNumber(pPlayer, "runs") > 0) then
		return convoTemplate:getScreen("done")
	end

	return convoTemplate:getScreen("greeting")
end

function maneater_ulon_conv_handler:runScreenHandlers(pConvTemplate, pPlayer, pNpc, selectedOption, pConvScreen)
	local screen = LuaConversationScreen(pConvScreen)
	local screenID = screen:getScreenID()
	local pClonedScreen = screen:cloneScreen()
	local clonedConversation = LuaConversationScreen(pClonedScreen)

	if (screenID == "turn_in") then
		-- SOE fires rewardTime in the dispatch, before the bark.  Walking up
		-- with task five live IS the hand-in; there is no confirm step.
		maneaterScreenPlay:signalReward(pPlayer)

	elseif (screenID == "checkin") then
		-- s_15 only while the Encounter is live.
		if (maneaterScreenPlay:getStage(pPlayer) == maneaterScreenPlay.STAGE_HUNT) then
			clonedConversation:addOption("@conversation/maneater_ulon:s_15", "lost_it") -- I had it and I lost it.
		end

	elseif (screenID == "lost_it") then
		maneaterScreenPlay:regrantManeater(pPlayer)

	elseif (screenID == "accept") then
		maneaterScreenPlay:grantManeater(pPlayer)
	end

	return pClonedScreen
end
