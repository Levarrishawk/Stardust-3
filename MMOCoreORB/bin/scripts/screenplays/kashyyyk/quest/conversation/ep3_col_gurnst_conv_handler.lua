-- Colonel Gurnst -- ep3_kachirho_kill_wke
-- ruling 2026-09-04: "ensure kashyyyk is done in full"
-- getInitialScreen is live condition order. runScreenHandlers fires grant / signal / turn-in.
-- No Journal.*: this branch has no managers/quest/journal.lua.

ep3_col_gurnst_conv_handler = conv_handler:new {}

ep3_col_gurnst_conv_handler.screenAnimations = {
	s_124 = "pose_proudly",
	s_128 = "wave_on_dismissing",
	s_132 = "refuse_offer_affection",
	s_134 = "pose_proudly",
	s_138 = "explain",
	s_142 = "snap_finger1",
	s_146 = "check_wrist_device",
	s_148 = "shake_head_disgust",
	s_150 = "pose_proudly",
	s_154 = "explain",
	s_158 = "explain",
	s_162 = "point_to_self",
	s_166 = "pound_fist_palm",
	s_170 = "snap_finger1",
	s_174 = "wave_on_dismissing",
	s_178 = "nod_head_once",
	s_184 = "wave_on_dismissing",
}

function ep3_col_gurnst_conv_handler:stage(pPlayer)
	return kachirhoKillWkeScreenPlay:getStage(pPlayer)
end

function ep3_col_gurnst_conv_handler:getInitialScreen(pPlayer, pNpc, pConvTemplate)
	local convoTemplate = LuaConversationTemplate(pConvTemplate)

	if (self:stage(pPlayer) == 0 and kachirhoKillWkeScreenPlay:getRuns(pPlayer) > 0) then
		return convoTemplate:getScreen("s_124")
	elseif (self:stage(pPlayer) == 2) then
		return convoTemplate:getScreen("s_134")
	elseif (self:stage(pPlayer) > 0) then
		return convoTemplate:getScreen("s_148")
	end

	return convoTemplate:getScreen("s_150")
end

function ep3_col_gurnst_conv_handler:runScreenHandlers(pConvTemplate, pPlayer, pNpc, selectedOption, pConvScreen)
	local screen = LuaConversationScreen(pConvScreen)
	local screenID = screen:getScreenID()
	local pClonedScreen = screen:cloneScreen()
	local clonedConversation = LuaConversationScreen(pClonedScreen)

	if (self.screenAnimations ~= nil and self.screenAnimations[screenID] ~= nil and pNpc ~= nil) then
		CreatureObject(pNpc):doAnimation(self.screenAnimations[screenID])
	end

	if (screenID == "s_128") then
		kachirhoKillWkeScreenPlay:clearQuest(pPlayer)
		kachirhoKillWkeScreenPlay:grantQuest(pPlayer)
	elseif (screenID == "s_138") then
		kachirhoKillWkeScreenPlay:signalTurnIn(pPlayer)
	elseif (screenID == "s_142") then
		kachirhoKillWkeScreenPlay:clearQuest(pPlayer)
		kachirhoKillWkeScreenPlay:grantQuest(pPlayer)
	elseif (screenID == "s_170") then
		kachirhoKillWkeScreenPlay:grantQuest(pPlayer)
	end

	return pClonedScreen
end
