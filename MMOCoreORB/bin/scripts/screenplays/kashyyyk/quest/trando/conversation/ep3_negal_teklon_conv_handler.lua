-- ep3_negal_teklon -- ep3_trandoshan_negal_teklon
-- ruling 2026-09-04
-- getInitialScreen is live condition order. runScreenHandlers fires grant / signal / turn-in.
-- NO JOURNAL: this branch has no managers/quest/journal.lua.

ep3_negal_teklon_conv_handler = conv_handler:new {}

ep3_negal_teklon_conv_handler.screenAnimations = {
	s_1173 = "gesticulate_wildly",
	s_1177 = "point_accusingly",
	s_1181 = "shrug_hands",
	s_1185 = "wave_on_dismissing",
	s_1167 = "wave_on_dismissing",
	s_1169 = "whisper",
	s_1187 = "shake_head_disgust",
	s_1189 = "wave_on_dismissing",
}

function ep3_negal_teklon_conv_handler:getInitialScreen(pPlayer, pNpc, pConvTemplate)
	local convoTemplate = LuaConversationTemplate(pConvTemplate)

	if (trandoBorantok01ScreenPlay:isTurnIn(pPlayer)) then
		return convoTemplate:getScreen("s_1169")
	elseif ((trandoBorantok01ScreenPlay:getStage(pPlayer) > 0 and not trandoBorantok01ScreenPlay:isTurnIn(pPlayer))) then
		return convoTemplate:getScreen("s_1187")
	end
	return convoTemplate:getScreen("s_1189")
end

function ep3_negal_teklon_conv_handler:runScreenHandlers(pConvTemplate, pPlayer, pNpc, selectedOption, pConvScreen)
	local screen = LuaConversationScreen(pConvScreen)
	local screenID = screen:getScreenID()
	local pClonedScreen = screen:cloneScreen()
	local clonedConversation = LuaConversationScreen(pClonedScreen)

	if (self.screenAnimations ~= nil and self.screenAnimations[screenID] ~= nil and pNpc ~= nil) then
		CreatureObject(pNpc):doAnimation(self.screenAnimations[screenID])
	end

	if (screenID == "s_1185") then
		trandoBorantok02ScreenPlay:grantQuest(pPlayer)
		trandoBorantok01ScreenPlay:signalHideBodies(pPlayer)
	end

	return pClonedScreen
end

