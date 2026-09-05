-- ep3_myyydril_lorn
-- ruling 2026-09-04
-- getInitialScreen is live condition order. runScreenHandlers fires grant / signal / turn-in.
-- No journal API: this branch has no managers/quest/journal.lua.

ep3_myyydril_lorn_conv_handler = conv_handler:new {}

function ep3_myyydril_lorn_conv_handler:getInitialScreen(pPlayer, pNpc, pConvTemplate)
	local convoTemplate = LuaConversationTemplate(pConvTemplate)

	if ((myyydrilLornTalktoScreenPlay:getRuns(pPlayer) > 0 and myyydrilLornTalktoScreenPlay:getStage(pPlayer) == 0)) then
		return convoTemplate:getScreen("s_11")
	end

	return convoTemplate:getScreen("s_54")
end

function ep3_myyydril_lorn_conv_handler:runScreenHandlers(pConvTemplate, pPlayer, pNpc, selectedOption, pConvScreen)
	local screen = LuaConversationScreen(pConvScreen)
	local screenID = screen:getScreenID()
	local pClonedScreen = screen:cloneScreen()

	if (screenID == "s_66") then
		MyyydrilSignals:send(pPlayer, "lorn")
	end

	return pClonedScreen
end

