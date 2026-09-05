-- ep3_borantok -- ep3_trandoshan_borantok
-- ruling 2026-09-04
-- getInitialScreen is live condition order. runScreenHandlers fires grant / signal / turn-in.
-- NO JOURNAL: this branch has no managers/quest/journal.lua.

ep3_borantok_conv_handler = conv_handler:new {}

ep3_borantok_conv_handler.screenAnimations = {
	s_513 = "celebrate",
	s_519 = "gesticulate_wildly",
	s_525 = "laugh",
	s_529 = "smack_self",
	s_545 = "point_accusingly",
	s_533 = "slow_down",
	s_537 = "snap_finger2",
	s_541 = "explain",
	s_553 = "gesticulate_wildly",
	s_559 = "explain",
	s_595 = "dismiss",
	s_563 = "slow_down",
	s_567 = "explain",
	s_571 = "standing_placate",
	s_575 = "explain",
	s_579 = "explain",
	s_583 = "tap_head",
	s_587 = "nod_head_multiple",
	s_507 = "dismiss",
	s_509 = "whisper",
	s_515 = "rub_chin_thoughtful",
	s_521 = "whisper",
	s_549 = "whisper",
	s_555 = "beckon",
}

function ep3_borantok_conv_handler:getInitialScreen(pPlayer, pNpc, pConvTemplate)
	local convoTemplate = LuaConversationTemplate(pConvTemplate)

	if ((trandoBorantok02ScreenPlay:getStage(pPlayer) == 0 and trandoBorantok02ScreenPlay:getRuns(pPlayer) > 0)) then
		return convoTemplate:getScreen("s_507")
	elseif (trandoBorantok02ScreenPlay:isTurnIn(pPlayer)) then
		return convoTemplate:getScreen("s_509")
	elseif (trandoBorantok02ScreenPlay:getStage(pPlayer) > 1) then
		return convoTemplate:getScreen("s_515")
	elseif (trandoBorantok02ScreenPlay:getStage(pPlayer) == 1) then
		return convoTemplate:getScreen("s_521")
	elseif (trandoBorantok01ScreenPlay:getStage(pPlayer) > 0) then
		return convoTemplate:getScreen("s_549")
	end
	return convoTemplate:getScreen("s_555")
end

function ep3_borantok_conv_handler:runScreenHandlers(pConvTemplate, pPlayer, pNpc, selectedOption, pConvScreen)
	local screen = LuaConversationScreen(pConvScreen)
	local screenID = screen:getScreenID()
	local pClonedScreen = screen:cloneScreen()
	local clonedConversation = LuaConversationScreen(pClonedScreen)

	if (self.screenAnimations ~= nil and self.screenAnimations[screenID] ~= nil and pNpc ~= nil) then
		CreatureObject(pNpc):doAnimation(self.screenAnimations[screenID])
	end

	if (screenID == "s_513") then
		trandoBorantok02ScreenPlay:signalRewardBorantok(pPlayer)
	elseif (screenID == "s_541") then
		trandoBorantok02ScreenPlay:signalReportToBorantok(pPlayer)
	elseif (screenID == "s_587") then
		trandoBorantok01ScreenPlay:grantQuest(pPlayer)
	end

	return pClonedScreen
end

