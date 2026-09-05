-- ep3_dakar -- ep3_trandoshan_dakar_zssik_02
-- ruling 2026-09-04
-- getInitialScreen is live condition order. runScreenHandlers fires grant / signal / turn-in.
-- NO JOURNAL: this branch has no managers/quest/journal.lua.

ep3_dakar_conv_handler = conv_handler:new {}

ep3_dakar_conv_handler.screenAnimations = {
	s_804 = "rub_chin_thoughtful",
	s_810 = "wave_on_dismissing",
	s_816 = "explain",
	s_820 = "explain",
	s_824 = "explain",
	s_828 = "pound_fist_palm",
	s_832 = "wave_on_dismissing",
	s_798 = "wave_on_dismissing",
	s_800 = "search",
	s_806 = "search",
	s_812 = "rub_chin_thoughtful",
	s_834 = "dismiss",
}

function ep3_dakar_conv_handler:getInitialScreen(pPlayer, pNpc, pConvTemplate)
	local convoTemplate = LuaConversationTemplate(pConvTemplate)

	if ((trandoDakarZssik03ScreenPlay:getStage(pPlayer) == 0 and trandoDakarZssik03ScreenPlay:getRuns(pPlayer) > 0)) then
		return convoTemplate:getScreen("s_798")
	elseif (trandoDakarZssik03ScreenPlay:isTurnIn(pPlayer)) then
		return convoTemplate:getScreen("s_800")
	elseif ((trandoDakarZssik03ScreenPlay:getStage(pPlayer) > 0 and not trandoDakarZssik03ScreenPlay:isTurnIn(pPlayer))) then
		return convoTemplate:getScreen("s_806")
	elseif ((trandoBoshazTransferScreenPlay:getStage(pPlayer) > 0 and not trandoBoshazTransferScreenPlay:isTurnIn(pPlayer))) then
		return convoTemplate:getScreen("s_812")
	elseif ((trandoBoshazZssik02ScreenPlay:getStage(pPlayer) == 0 and trandoBoshazZssik02ScreenPlay:getRuns(pPlayer) > 0)) then
		return convoTemplate:getScreen("s_95")
	end
	return convoTemplate:getScreen("s_834")
end

function ep3_dakar_conv_handler:runScreenHandlers(pConvTemplate, pPlayer, pNpc, selectedOption, pConvScreen)
	local screen = LuaConversationScreen(pConvScreen)
	local screenID = screen:getScreenID()
	local pClonedScreen = screen:cloneScreen()
	local clonedConversation = LuaConversationScreen(pClonedScreen)

	if (self.screenAnimations ~= nil and self.screenAnimations[screenID] ~= nil and pNpc ~= nil) then
		CreatureObject(pNpc):doAnimation(self.screenAnimations[screenID])
	end

	if (screenID == "s_804") then
		trandoMololiumZssikGotoScreenPlay:grantQuest(pPlayer)
		trandoDakarZssik03ScreenPlay:signalRewardDakar(pPlayer)
	elseif (screenID == "s_828") then
		trandoDakarZssik03ScreenPlay:grantQuest(pPlayer)
		trandoBoshazTransferScreenPlay:signalReadyForDakarMission(pPlayer)
	end

	return pClonedScreen
end

