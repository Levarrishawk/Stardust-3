-- Marium Valmont -- ep3_avatar_return
-- ruling 2026-09-04: "ensure kashyyyk is fully done"
-- getInitialScreen is live condition order. runScreenHandlers fires grant / signal / turn-in.
-- NO JOURNAL: the journal engine is not in this tree.

ep3_kachirho_avatar_return_conv_handler = conv_handler:new {}

ep3_kachirho_avatar_return_conv_handler.screenAnimations = {
	s_76 = "greet",
	s_80 = "explain",
	s_84 = "goodbye",
	s_86 = "greet",
	s_90 = "shush",
	s_92 = "point_accusingly",
	s_94 = "laugh_titter",
	s_98 = "nod_head_once",
	s_102 = "laugh_titter",
	s_106 = "explain",
	s_110 = "explain",
	s_114 = "explain",
	s_118 = "slump_head",
	s_120 = "wave_on_dismissing",
}

function ep3_kachirho_avatar_return_conv_handler:stage(pPlayer)
	return avatarReturnScreenPlay:getStage(pPlayer)
end

function ep3_kachirho_avatar_return_conv_handler:getInitialScreen(pPlayer, pNpc, pConvTemplate)
	local convoTemplate = LuaConversationTemplate(pConvTemplate)

	if (avatarReturnScreenPlay:getRuns(pPlayer) > 0 and self:stage(pPlayer) == 0) then
		return convoTemplate:getScreen("s_76")
	elseif (self:stage(pPlayer) == 2) then
		return convoTemplate:getScreen("s_86")
	elseif (self:stage(pPlayer) > 0) then
		return convoTemplate:getScreen("s_92")
	elseif (avatarReturnScreenPlay:hasDestroyedAvatar(pPlayer)) then
		return convoTemplate:getScreen("s_94")
	end

	return convoTemplate:getScreen("s_120")
end

function ep3_kachirho_avatar_return_conv_handler:runScreenHandlers(pConvTemplate, pPlayer, pNpc, selectedOption, pConvScreen)
	local screen = LuaConversationScreen(pConvScreen)
	local screenID = screen:getScreenID()
	local pClonedScreen = screen:cloneScreen()
	local clonedConversation = LuaConversationScreen(pClonedScreen)

	if (self.screenAnimations ~= nil and self.screenAnimations[screenID] ~= nil and pNpc ~= nil) then
		CreatureObject(pNpc):doAnimation(self.screenAnimations[screenID])
	end

	if (screenID == "s_80") then
		avatarReturnScreenPlay:clearQuest(pPlayer)
		avatarReturnScreenPlay:grantQuest(pPlayer)
	elseif (screenID == "s_90") then
		avatarReturnScreenPlay:signalTurnIn(pPlayer)
	elseif (screenID == "s_114") then
		avatarReturnScreenPlay:grantQuest(pPlayer)
	end

	return pClonedScreen
end
