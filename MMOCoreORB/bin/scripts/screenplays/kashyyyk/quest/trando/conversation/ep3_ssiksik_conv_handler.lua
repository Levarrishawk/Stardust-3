-- ep3_ssiksik -- ep3_trandoshan_ssiksik
-- ruling 2026-09-04
-- getInitialScreen is live condition order. runScreenHandlers fires grant / signal / turn-in.
-- NO JOURNAL: this branch has no managers/quest/journal.lua.

ep3_ssiksik_conv_handler = conv_handler:new {}

ep3_ssiksik_conv_handler.screenAnimations = {
	s_95 = "wave_finger_warning",
	s_19 = "wave_on_dismissing",
	s_1321 = "pound_fist_palm",
	s_1325 = "explain",
	s_1339 = "sigh_deeply",
	s_1329 = "point_away",
	s_1333 = "pound_fist_palm",
	s_1313 = "salute2",
	s_1315 = "explain",
	s_1317 = "explain",
}

function ep3_ssiksik_conv_handler:getInitialScreen(pPlayer, pNpc, pConvTemplate)
	local convoTemplate = LuaConversationTemplate(pConvTemplate)

	if ((trandoSsiksikScreenPlay:getStage(pPlayer) == 0 and trandoSsiksikScreenPlay:getRuns(pPlayer) > 0)) then
		return convoTemplate:getScreen("s_1313")
	elseif ((trandoSsiksikScreenPlay:getStage(pPlayer) > 0 and not trandoSsiksikScreenPlay:isTurnIn(pPlayer))) then
		return convoTemplate:getScreen("s_1315")
	end
	return convoTemplate:getScreen("s_1317")
end

function ep3_ssiksik_conv_handler:runScreenHandlers(pConvTemplate, pPlayer, pNpc, selectedOption, pConvScreen)
	local screen = LuaConversationScreen(pConvScreen)
	local screenID = screen:getScreenID()
	local pClonedScreen = screen:cloneScreen()
	local clonedConversation = LuaConversationScreen(pClonedScreen)

	if (self.screenAnimations ~= nil and self.screenAnimations[screenID] ~= nil and pNpc ~= nil) then
		CreatureObject(pNpc):doAnimation(self.screenAnimations[screenID])
	end

	if (screenID == "s_19") then
		trandoSsiksikScreenPlay:grantQuest(pPlayer)
	elseif (screenID == "s_1333") then
		trandoSsiksikScreenPlay:grantQuest(pPlayer)
	end

	return pClonedScreen
end

