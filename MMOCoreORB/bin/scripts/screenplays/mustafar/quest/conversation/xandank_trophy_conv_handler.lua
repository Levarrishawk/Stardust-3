--[[
	Miner Renlo Hens -- conversation handler for som_xandank_trophey
	("A Whole Pack of Trouble" / trophyHuntsScreenPlay).

	The tree is in mobile/conversations/mustafar/xandank_trophy.lua.
	This file only routes.

	SOE's greeting dispatch is four conditions, first match wins.  The
	equivalent stage test on trophyHuntsScreenPlay:

	  hasCompletedQuest        STAGE_DONE (8)          done
	  isTaskActive nine        STAGE_RETURN (7)        return_hens
	  isQuestActive            any stage 1..6          checkin
	  default                  stage 0                 greeting

	getStage returns STAGE_DONE for a finished run and 0 for a player who
	has never taken it, so the two ends do not collide.
--]]

xandank_trophy_conv_handler = conv_handler:new {}

function xandank_trophy_conv_handler:getInitialScreen(pPlayer, pNpc, pConvTemplate)
	local convoTemplate = LuaConversationTemplate(pConvTemplate)
	local quest = trophyHuntsScreenPlay.quests.xandankTrophey
	local stage = trophyHuntsScreenPlay:getStage(pPlayer, quest)

	if (stage == quest.STAGE_DONE) then
		return convoTemplate:getScreen("done")
	elseif (stage == quest.STAGE_RETURN) then
		return convoTemplate:getScreen("return_hens")
	elseif (stage > 0) then
		return convoTemplate:getScreen("checkin")
	end

	return convoTemplate:getScreen("greeting")
end

function xandank_trophy_conv_handler:runScreenHandlers(pConvTemplate, pPlayer, pNpc, selectedOption, pConvScreen)
	local screen = LuaConversationScreen(pConvScreen)
	local screenID = screen:getScreenID()
	local pClonedScreen = screen:cloneScreen()
	local clonedConversation = LuaConversationScreen(pClonedScreen)

	-- Both side effects sit on the reply screen, not the greeting, because
	-- that is where SOE put them.  s_36 (decline) and s_17 (still looking)
	-- deliberately do nothing.
	if (screenID == "accept") then
		trophyHuntsScreenPlay:grantXandankTrophey(pPlayer)
	elseif (screenID == "hand_in") then
		trophyHuntsScreenPlay:turnInXandank(pPlayer)
	end

	return pClonedScreen
end
