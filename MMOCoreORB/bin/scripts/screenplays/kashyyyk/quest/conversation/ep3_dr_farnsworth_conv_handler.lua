-- Dr. Farnsworth -- ep3_kachirho_survey_data
-- ruling 2026-09-04: "ensure kashyyyk is done in full"
-- getInitialScreen is live condition order. runScreenHandlers fires grant / signal / turn-in.
-- No Journal.*: this branch has no managers/quest/journal.lua.

ep3_dr_farnsworth_conv_handler = conv_handler:new {}

ep3_dr_farnsworth_conv_handler.screenAnimations = {
	s_194 = "goodbye",
	s_196 = "greet",
	s_200 = "bow",
	s_202 = "greet",
	s_206 = "bow",
	s_208 = "greet",
	s_212 = "embarrassed",
	s_216 = "explain",
	s_220 = "clap_rousing",
	s_224 = "bow",
	s_228 = "goodbye",
}

function ep3_dr_farnsworth_conv_handler:stage(pPlayer)
	return kachirhoSurveyDataScreenPlay:getStage(pPlayer)
end

function ep3_dr_farnsworth_conv_handler:getInitialScreen(pPlayer, pNpc, pConvTemplate)
	local convoTemplate = LuaConversationTemplate(pConvTemplate)

	if (self:stage(pPlayer) == 0 and kachirhoSurveyDataScreenPlay:getRuns(pPlayer) > 0) then
		return convoTemplate:getScreen("s_194")
	elseif (self:stage(pPlayer) == 2) then
		return convoTemplate:getScreen("s_196")
	elseif (self:stage(pPlayer) > 0) then
		return convoTemplate:getScreen("s_202")
	end

	return convoTemplate:getScreen("s_208")
end

function ep3_dr_farnsworth_conv_handler:runScreenHandlers(pConvTemplate, pPlayer, pNpc, selectedOption, pConvScreen)
	local screen = LuaConversationScreen(pConvScreen)
	local screenID = screen:getScreenID()
	local pClonedScreen = screen:cloneScreen()
	local clonedConversation = LuaConversationScreen(pClonedScreen)

	if (self.screenAnimations ~= nil and self.screenAnimations[screenID] ~= nil and pNpc ~= nil) then
		CreatureObject(pNpc):doAnimation(self.screenAnimations[screenID])
	end

	if (screenID == "s_200") then
		kachirhoSurveyDataScreenPlay:signalTurnIn(pPlayer)
	elseif (screenID == "s_224") then
		kachirhoSurveyDataScreenPlay:grantQuest(pPlayer)
	end

	return pClonedScreen
end
