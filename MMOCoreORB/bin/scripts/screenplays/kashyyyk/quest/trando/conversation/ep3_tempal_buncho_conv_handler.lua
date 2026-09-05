-- ep3_tempal_buncho -- ep3_trandoshan_tempal_buncho
-- ruling 2026-09-04
-- getInitialScreen is live condition order. runScreenHandlers fires grant / signal / turn-in.
-- NO JOURNAL: this branch has no managers/quest/journal.lua.

ep3_tempal_buncho_conv_handler = conv_handler:new {}

ep3_tempal_buncho_conv_handler.screenAnimations = {
	s_1349 = "laugh",
	s_1355 = "shake_head_no",
	s_1361 = "point_to_self",
	s_1365 = "laugh",
	s_1369 = "explain",
	s_1373 = "laugh",
	s_1385 = "goodbye",
	s_1377 = "goodbye",
	s_1381 = "goodbye",
	s_1343 = "greet",
	s_1345 = "greet",
	s_1351 = "shake_head_no",
	s_1357 = "rub_chin_thoughtful",
}

function ep3_tempal_buncho_conv_handler:getInitialScreen(pPlayer, pNpc, pConvTemplate)
	local convoTemplate = LuaConversationTemplate(pConvTemplate)

	if ((trandoTempalBunchoScreenPlay:getStage(pPlayer) == 0 and trandoTempalBunchoScreenPlay:getRuns(pPlayer) > 0)) then
		return convoTemplate:getScreen("s_1343")
	elseif (trandoTempalBunchoScreenPlay:isTurnIn(pPlayer)) then
		return convoTemplate:getScreen("s_1345")
	elseif ((trandoTempalBunchoScreenPlay:getStage(pPlayer) > 0 and not trandoTempalBunchoScreenPlay:isTurnIn(pPlayer))) then
		return convoTemplate:getScreen("s_1351")
	end
	return convoTemplate:getScreen("s_1357")
end

function ep3_tempal_buncho_conv_handler:runScreenHandlers(pConvTemplate, pPlayer, pNpc, selectedOption, pConvScreen)
	local screen = LuaConversationScreen(pConvScreen)
	local screenID = screen:getScreenID()
	local pClonedScreen = screen:cloneScreen()
	local clonedConversation = LuaConversationScreen(pClonedScreen)

	if (self.screenAnimations ~= nil and self.screenAnimations[screenID] ~= nil and pNpc ~= nil) then
		CreatureObject(pNpc):doAnimation(self.screenAnimations[screenID])
	end

	if (screenID == "s_1349") then
		trandoTempalBunchoScreenPlay:signalRewardTempal(pPlayer)
	elseif (screenID == "s_1377") then
		trandoTempalBunchoScreenPlay:grantQuest(pPlayer)
	end

	return pClonedScreen
end

