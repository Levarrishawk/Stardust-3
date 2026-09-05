-- ep3_myyydril_attiera
-- ruling 2026-09-04
-- getInitialScreen is live condition order. runScreenHandlers fires grant / signal / turn-in.
-- No journal API: this branch has no managers/quest/journal.lua.

ep3_myyydril_attiera_conv_handler = conv_handler:new {}

function ep3_myyydril_attiera_conv_handler:getInitialScreen(pPlayer, pNpc, pConvTemplate)
	local convoTemplate = LuaConversationTemplate(pConvTemplate)

	if ((myyydrilAttieraEscort2ScreenPlay:getRuns(pPlayer) > 0 and myyydrilAttieraEscort2ScreenPlay:getStage(pPlayer) == 0)) then
		return convoTemplate:getScreen("s_527")
	elseif (myyydrilAttieraEscort2ScreenPlay:getStage(pPlayer) == 2) then
		return convoTemplate:getScreen("s_524")
	elseif (myyydrilAttieraEscort2ScreenPlay:getStage(pPlayer) == 1) then
		return convoTemplate:getScreen("s_521")
	elseif ((myyydrilNawikaTalkto5ScreenPlay:getRuns(pPlayer) > 0 and myyydrilNawikaTalkto5ScreenPlay:getStage(pPlayer) == 0)) then
		return convoTemplate:getScreen("s_489")
	end

	return convoTemplate:getScreen("s_488")
end

function ep3_myyydril_attiera_conv_handler:runScreenHandlers(pConvTemplate, pPlayer, pNpc, selectedOption, pConvScreen)
	local screen = LuaConversationScreen(pConvScreen)
	local screenID = screen:getScreenID()
	local pClonedScreen = screen:cloneScreen()

	if (screenID == "s_526") then
		MyyydrilSignals:send(pPlayer, "giveLoot")
	elseif (screenID == "s_519") then
		myyydrilAttieraEscort2ScreenPlay:grantQuest(pPlayer)
	end

	return pClonedScreen
end

