-- ep3_musolium -- ep3_trandoshan_mosolium_zssik_03
-- ruling 2026-09-04
-- getInitialScreen is live condition order. runScreenHandlers fires grant / signal / turn-in.
-- NO JOURNAL: this branch has no managers/quest/journal.lua.

ep3_musolium_conv_handler = conv_handler:new {}

ep3_musolium_conv_handler.screenAnimations = {
	s_1045 = "point_away",
	s_1049 = "shrug_hands",
	s_1057 = "shake_head_disgust",
	s_1061 = "explain",
	s_1065 = "sigh_deeply",
	s_1069 = "slit_throat",
	s_1073 = "wave_on_dismissing",
	s_1079 = "wave_on_dismissing",
	s_1083 = "wave_on_dismissing",
	s_1091 = "nod_head_once",
	s_1095 = "point_accusingly",
	s_1099 = "explain",
	s_1111 = "point_accusingly",
	s_1103 = "explain",
	s_1107 = "dismiss",
	s_1039 = "point_away",
	s_1041 = "nod_head_once",
	s_1051 = "point_accusingly",
	s_1053 = "rub_chin_thoughtful",
	s_1075 = "shake_head_disgust",
	s_1085 = "dismiss",
	s_1087 = "point_accusingly",
	s_1113 = "wave_on_dismissing",
}

function ep3_musolium_conv_handler:getInitialScreen(pPlayer, pNpc, pConvTemplate)
	local convoTemplate = LuaConversationTemplate(pConvTemplate)

	if ((trandoMosoliumZssik05ScreenPlay:getStage(pPlayer) == 0 and trandoMosoliumZssik05ScreenPlay:getRuns(pPlayer) > 0)) then
		return convoTemplate:getScreen("s_1039")
	elseif (trandoMosoliumZssik05ScreenPlay:isTurnIn(pPlayer)) then
		return convoTemplate:getScreen("s_1041")
	elseif ((trandoMosoliumZssik05ScreenPlay:getStage(pPlayer) > 0 and not trandoMosoliumZssik05ScreenPlay:isTurnIn(pPlayer))) then
		return convoTemplate:getScreen("s_1051")
	elseif (trandoMololiumZssikGotoScreenPlay:isTurnIn(pPlayer)) then
		return convoTemplate:getScreen("s_1087")
	elseif ((trandoDakarZssik03ScreenPlay:getStage(pPlayer) == 0 and trandoDakarZssik03ScreenPlay:getRuns(pPlayer) > 0)) then
		return convoTemplate:getScreen("s_148")
	end
	return convoTemplate:getScreen("s_1113")
end

function ep3_musolium_conv_handler:runScreenHandlers(pConvTemplate, pPlayer, pNpc, selectedOption, pConvScreen)
	local screen = LuaConversationScreen(pConvScreen)
	local screenID = screen:getScreenID()
	local pClonedScreen = screen:cloneScreen()
	local clonedConversation = LuaConversationScreen(pClonedScreen)

	if (self.screenAnimations ~= nil and self.screenAnimations[screenID] ~= nil and pNpc ~= nil) then
		CreatureObject(pNpc):doAnimation(self.screenAnimations[screenID])
	end

	if (screenID == "s_1045") then
		trandoMosoliumTransferScreenPlay:grantQuest(pPlayer)
		trandoMosoliumZssik05ScreenPlay:signalRewardMosolium01(pPlayer)
	elseif (screenID == "s_1069") then
		trandoMosoliumZssik05ScreenPlay:grantQuest(pPlayer)
	elseif (screenID == "s_1079") then
		-- OPEN: space_quest.grantQuest is not this fence
	elseif (screenID == "s_1107") then
		trandoMololiumZssikGotoScreenPlay:signalReadyForMosoliumMission(pPlayer)
		-- OPEN: space_quest.grantQuest is not this fence
	end

	return pClonedScreen
end

