-- ep3_hssissk_bloodscale -- ep3_trandoshan_hssissk_zssik_06
-- ruling 2026-09-04
-- getInitialScreen is live condition order. runScreenHandlers fires grant / signal / turn-in.
-- NO JOURNAL: this branch has no managers/quest/journal.lua.

ep3_hssissk_bloodscale_conv_handler = conv_handler:new {}

ep3_hssissk_bloodscale_conv_handler.screenAnimations = {
	s_940 = "wave_on_dismissing",
	s_948 = "explain",
	s_976 = "rub_chin_thoughtful",
	s_952 = "pound_fist_palm",
	s_956 = "shake_head_disgust",
	s_960 = "explain",
	s_964 = "explain",
	s_968 = "dismiss",
	s_972 = "dismiss",
	s_934 = "dismiss",
	s_936 = "applause_polite",
	s_942 = "point_accusingly",
	s_944 = "greet",
	s_980 = "dismiss",
}

function ep3_hssissk_bloodscale_conv_handler:getInitialScreen(pPlayer, pNpc, pConvTemplate)
	local convoTemplate = LuaConversationTemplate(pConvTemplate)

	if ((trandoHssisskZssik10ScreenPlay:getStage(pPlayer) == 0 and trandoHssisskZssik10ScreenPlay:getRuns(pPlayer) > 0)) then
		return convoTemplate:getScreen("s_934")
	elseif (trandoHssisskZssik10ScreenPlay:isTurnIn(pPlayer)) then
		return convoTemplate:getScreen("s_936")
	elseif ((trandoHssisskZssik10ScreenPlay:getStage(pPlayer) > 0 and not trandoHssisskZssik10ScreenPlay:isTurnIn(pPlayer))) then
		return convoTemplate:getScreen("s_942")
	elseif ((trandoOroorooTransferScreenPlay:getStage(pPlayer) > 0 and not trandoOroorooTransferScreenPlay:isTurnIn(pPlayer))) then
		return convoTemplate:getScreen("s_944")
	elseif ((trandoOroorooZssik08ScreenPlay:getStage(pPlayer) == 0 and trandoOroorooZssik08ScreenPlay:getRuns(pPlayer) > 0)) then
		return convoTemplate:getScreen("s_212")
	end
	return convoTemplate:getScreen("s_980")
end

function ep3_hssissk_bloodscale_conv_handler:runScreenHandlers(pConvTemplate, pPlayer, pNpc, selectedOption, pConvScreen)
	local screen = LuaConversationScreen(pConvScreen)
	local screenID = screen:getScreenID()
	local pClonedScreen = screen:cloneScreen()
	local clonedConversation = LuaConversationScreen(pClonedScreen)

	if (self.screenAnimations ~= nil and self.screenAnimations[screenID] ~= nil and pNpc ~= nil) then
		CreatureObject(pNpc):doAnimation(self.screenAnimations[screenID])
	end

	if (screenID == "s_940") then
		trandoHssisskZssik10ScreenPlay:signalRewardHssissk(pPlayer)
	elseif (screenID == "s_968") then
		trandoHssisskZssik10ScreenPlay:grantQuest(pPlayer)
		trandoOroorooTransferScreenPlay:signalReadyForHssissk(pPlayer)
	end

	return pClonedScreen
end

