-- ep3_myyydril_refugee
-- ruling 2026-09-04
-- getInitialScreen is live condition order. runScreenHandlers fires grant / signal / turn-in.
-- No journal API: this branch has no managers/quest/journal.lua.

ep3_myyydril_refugee_conv_handler = conv_handler:new {}

function ep3_myyydril_refugee_conv_handler:getInitialScreen(pPlayer, pNpc, pConvTemplate)
	local convoTemplate = LuaConversationTemplate(pConvTemplate)

	if ((myyydrilRensalla1ScreenPlay:getRuns(pPlayer) > 0 and myyydrilRensalla1ScreenPlay:getStage(pPlayer) == 0)) then
		return convoTemplate:getScreen("s_716")
	elseif ((myyydrilRensalla1ScreenPlay:getStage(pPlayer) > 0) or (myyydrilRensalla1ScreenPlay:getStage(pPlayer) >= 1)) then
		return convoTemplate:getScreen("s_726")
	end

	return convoTemplate:getScreen("s_739")
end

function ep3_myyydril_refugee_conv_handler:runScreenHandlers(pConvTemplate, pPlayer, pNpc, selectedOption, pConvScreen)
	local screen = LuaConversationScreen(pConvScreen)
	local screenID = screen:getScreenID()
	local pClonedScreen = screen:cloneScreen()

	if (screenID == "s_731") then
		MyyydrilSignals:send(pPlayer, "finddagger")
	end

	return pClonedScreen
end

