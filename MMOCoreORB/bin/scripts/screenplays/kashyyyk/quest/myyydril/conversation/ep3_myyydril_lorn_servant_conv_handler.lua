-- ep3_myyydril_lorn_servant
-- ruling 2026-09-04
-- getInitialScreen is live condition order. runScreenHandlers fires grant / signal / turn-in.
-- No journal API: this branch has no managers/quest/journal.lua.

ep3_myyydril_lorn_servant_conv_handler = conv_handler:new {}

function ep3_myyydril_lorn_servant_conv_handler:getInitialScreen(pPlayer, pNpc, pConvTemplate)
	local convoTemplate = LuaConversationTemplate(pConvTemplate)

	if (not MyyydrilGrievous:isLockoutClear(pPlayer)) then
		return convoTemplate:getScreen("s_418")
	elseif (myyydrilLornRetrieve6ScreenPlay:getStage(pPlayer) == 2) then
		return convoTemplate:getScreen("s_434")
	elseif ((myyydrilLornRetrieve6ScreenPlay:getStage(pPlayer) == 1)) then
		return convoTemplate:getScreen("s_438")
	end

	return convoTemplate:getScreen("s_442")
end

function ep3_myyydril_lorn_servant_conv_handler:runScreenHandlers(pConvTemplate, pPlayer, pNpc, selectedOption, pConvScreen)
	local screen = LuaConversationScreen(pConvScreen)
	local screenID = screen:getScreenID()
	local pClonedScreen = screen:cloneScreen()

	if (screenID == "s_434" or (screenID == "s_496" and MyyydrilGrievous:isGod(pPlayer))) then
		MyyydrilGrievous.beginEncounter(pPlayer)
	elseif (screenID == "s_442" and not MyyydrilGrievous:isGod(pPlayer)) then
		local clone = LuaConversationScreen(pClonedScreen)
		clone:removeAllOptions()
		clone:addOption("@conversation/ep3_myyydril_lorn_servant:s_446", "s_450")
	elseif (screenID == "s_488") then
		myyydrilLornRetrieve6ScreenPlay:grantQuest(pPlayer)
	end

	return pClonedScreen
end

