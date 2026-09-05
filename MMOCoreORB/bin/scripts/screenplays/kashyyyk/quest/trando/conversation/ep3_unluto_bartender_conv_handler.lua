-- ep3_unluto_bartender -- ep3_trandoshan_unluto_bartender
-- ruling 2026-09-04
-- getInitialScreen is live condition order. runScreenHandlers fires grant / signal / turn-in.
-- NO JOURNAL: this branch has no managers/quest/journal.lua.

ep3_unluto_bartender_conv_handler = conv_handler:new {}

ep3_unluto_bartender_conv_handler.screenAnimations = {
	s_1393 = "explain",
	s_1441 = "yawn",
	s_1397 = "sigh_deeply",
	s_1401 = "rub_chin_thoughtful",
	s_1405 = "explain",
	s_1409 = "explain",
	s_1413 = "point_accusingly",
	s_1429 = "shrug_hands",
	s_1417 = "slow_down",
	s_1421 = "shake_head_no",
	s_1425 = "nod_head_once",
	s_1433 = "rub_chin_thoughtful",
	s_1437 = "nod_head_multiple",
	s_1389 = "manipulate_high",
}

function ep3_unluto_bartender_conv_handler:getInitialScreen(pPlayer, pNpc, pConvTemplate)
	local convoTemplate = LuaConversationTemplate(pConvTemplate)

	return convoTemplate:getScreen("s_1389")
end

function ep3_unluto_bartender_conv_handler:runScreenHandlers(pConvTemplate, pPlayer, pNpc, selectedOption, pConvScreen)
	local screen = LuaConversationScreen(pConvScreen)
	local screenID = screen:getScreenID()
	local pClonedScreen = screen:cloneScreen()
	local clonedConversation = LuaConversationScreen(pClonedScreen)

	if (self.screenAnimations ~= nil and self.screenAnimations[screenID] ~= nil and pNpc ~= nil) then
		CreatureObject(pNpc):doAnimation(self.screenAnimations[screenID])
	end

	if (screenID == "s_1425") then
		trandoBorantok02ScreenPlay:signalThreatenBartender(pPlayer)
	elseif (screenID == "s_1437") then
		trandoBorantok02ScreenPlay:signalThreatenBartender(pPlayer)
	end

	return pClonedScreen
end

