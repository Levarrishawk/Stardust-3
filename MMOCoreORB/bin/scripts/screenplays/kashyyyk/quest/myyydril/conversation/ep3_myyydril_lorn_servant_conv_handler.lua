-- ep3_myyydril_lorn_servant
-- ruling 2026-09-04
-- getInitialScreen is live condition order. runScreenHandlers fires grant / signal / turn-in.
-- No journal API: this branch has no managers/quest/journal.lua.

ep3_myyydril_lorn_servant_conv_handler = conv_handler:new {}

function ep3_myyydril_lorn_servant_conv_handler:getInitialScreen(pPlayer, pNpc, pConvTemplate)
	local convoTemplate = LuaConversationTemplate(pConvTemplate)

	if ((myyydrilLornRetrieve6ScreenPlay:getStage(pPlayer) == 2)) then
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

	if (screenID == "s_496") then
		myyydrilLornTalktoScreenPlay:grantQuest(pPlayer)
	elseif (screenID == "s_488") then
		myyydrilLornRetrieve6ScreenPlay:grantQuest(pPlayer)
	elseif (screenID == "s_434") then
		myyydrilLornTalktoScreenPlay:grantQuest(pPlayer)
	end

	return pClonedScreen
end

