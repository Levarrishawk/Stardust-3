-- ep3_ysith -- ep3_trandoshan_ysith
-- ruling 2026-09-04
-- getInitialScreen is live condition order. runScreenHandlers fires grant / signal / turn-in.
-- NO JOURNAL: this branch has no managers/quest/journal.lua.

ep3_ysith_conv_handler = conv_handler:new {}

ep3_ysith_conv_handler.screenAnimations = {
	s_1454 = "shrug_hands",
	s_1458 = "celebrate",
	s_1464 = "wave_on_dismissing",
	s_1470 = "rub_chin_thoughtful",
	s_1474 = "gesticulate_wildly",
	s_1478 = "explain",
	s_1482 = "celebrate1",
	s_1486 = "wave_on_dismissing",
	s_1448 = "goodbye",
	s_1450 = "nervous",
	s_1460 = "nervous",
	s_1466 = "beckon",
}

function ep3_ysith_conv_handler:getInitialScreen(pPlayer, pNpc, pConvTemplate)
	local convoTemplate = LuaConversationTemplate(pConvTemplate)

	if ((trandoYsithScreenPlay:getStage(pPlayer) == 0 and trandoYsithScreenPlay:getRuns(pPlayer) > 0)) then
		return convoTemplate:getScreen("s_1448")
	elseif (trandoYsithScreenPlay:isTurnIn(pPlayer)) then
		return convoTemplate:getScreen("s_1450")
	elseif ((trandoYsithScreenPlay:getStage(pPlayer) > 0 and not trandoYsithScreenPlay:isTurnIn(pPlayer))) then
		return convoTemplate:getScreen("s_1460")
	end
	return convoTemplate:getScreen("s_1466")
end

function ep3_ysith_conv_handler:runScreenHandlers(pConvTemplate, pPlayer, pNpc, selectedOption, pConvScreen)
	local screen = LuaConversationScreen(pConvScreen)
	local screenID = screen:getScreenID()
	local pClonedScreen = screen:cloneScreen()
	local clonedConversation = LuaConversationScreen(pClonedScreen)

	if (self.screenAnimations ~= nil and self.screenAnimations[screenID] ~= nil and pNpc ~= nil) then
		CreatureObject(pNpc):doAnimation(self.screenAnimations[screenID])
	end

	if (screenID == "s_1458") then
		trandoYsithScreenPlay:signalGiveYsithReward(pPlayer)
	elseif (screenID == "s_1482") then
		trandoYsithScreenPlay:grantQuest(pPlayer)
	end

	return pClonedScreen
end

