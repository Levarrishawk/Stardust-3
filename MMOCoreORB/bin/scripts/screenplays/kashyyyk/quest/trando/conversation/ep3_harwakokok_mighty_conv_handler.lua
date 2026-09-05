-- ep3_harwakokok_mighty -- ep3_trandoshan_harwakokok_zssik_05
-- ruling 2026-09-04
-- getInitialScreen is live condition order. runScreenHandlers fires grant / signal / turn-in.
-- NO JOURNAL: this branch has no managers/quest/journal.lua.

ep3_harwakokok_mighty_conv_handler = conv_handler:new {}

ep3_harwakokok_mighty_conv_handler.screenAnimations = {
	s_892 = "bow",
	s_900 = "shake_head_no",
	s_904 = "point_accusingly",
	s_908 = "rub_chin_thoughtful",
	s_912 = "point_forward",
	s_916 = "explain",
	s_920 = "explain",
	s_924 = "wave_on_dismissing",
	s_928 = "wave_on_dismissing",
	s_886 = "bow",
	s_888 = "pose_proudly",
	s_894 = "wave_on_dismissing",
	s_896 = "rub_chin_thoughtful",
	s_930 = "wave_on_dismissing",
}

function ep3_harwakokok_mighty_conv_handler:getInitialScreen(pPlayer, pNpc, pConvTemplate)
	local convoTemplate = LuaConversationTemplate(pConvTemplate)

	if (CreatureObject(pPlayer):hasSkill("combat_smuggler_underworld_01")) then
		return convoTemplate:getScreen("s_122")
	elseif ((trandoHarwakokokZssik09ScreenPlay:getStage(pPlayer) == 0 and trandoHarwakokokZssik09ScreenPlay:getRuns(pPlayer) > 0)) then
		return convoTemplate:getScreen("s_886")
	elseif (trandoHarwakokokZssik09ScreenPlay:isTurnIn(pPlayer)) then
		return convoTemplate:getScreen("s_888")
	elseif ((trandoHarwakokokZssik09ScreenPlay:getStage(pPlayer) > 0 and not trandoHarwakokokZssik09ScreenPlay:isTurnIn(pPlayer))) then
		return convoTemplate:getScreen("s_894")
	elseif (trandoOroorooZssik08ScreenPlay:isTurnIn(pPlayer)) then
		return convoTemplate:getScreen("s_896")
	end
	return convoTemplate:getScreen("s_930")
end

function ep3_harwakokok_mighty_conv_handler:runScreenHandlers(pConvTemplate, pPlayer, pNpc, selectedOption, pConvScreen)
	local screen = LuaConversationScreen(pConvScreen)
	local screenID = screen:getScreenID()
	local pClonedScreen = screen:cloneScreen()
	local clonedConversation = LuaConversationScreen(pClonedScreen)

	if (self.screenAnimations ~= nil and self.screenAnimations[screenID] ~= nil and pNpc ~= nil) then
		CreatureObject(pNpc):doAnimation(self.screenAnimations[screenID])
	end

	if (screenID == "s_892") then
		trandoHarwakokokZssik09ScreenPlay:signalCompletedHarwakokok(pPlayer)
		trandoOroorooZssik08ScreenPlay:signalReturnToOrooroo(pPlayer)
	elseif (screenID == "s_924") then
		trandoHarwakokokZssik09ScreenPlay:grantQuest(pPlayer)
	end

	return pClonedScreen
end

