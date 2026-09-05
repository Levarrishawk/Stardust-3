-- Chatook -- ep3_kachirho_missing_son
-- ruling 2026-09-04: "ensure kashyyyk is done in full"
-- getInitialScreen is live condition order. runScreenHandlers fires grant / signal / turn-in.
-- No Journal.*: this branch has no managers/quest/journal.lua.

ep3_kachirho_chatook_conv_handler = conv_handler:new {}

ep3_kachirho_chatook_conv_handler.screenAnimations = {
	s_236 = "weeping",
	s_238 = "slump_head",
	s_242 = "cover_mouth",
	s_246 = "weeping",
	s_250 = "weeping",
	s_254 = "sigh_deeply",
	s_258 = "weeping",
	s_260 = "implore",
	s_262 = "beckon",
	s_272 = "gesticulate_wildly",
	s_281 = "refuse_offer_affection",
	s_285 = "bow2",
	s_289 = "slump_head",
}

function ep3_kachirho_chatook_conv_handler:stage(pPlayer)
	return kachirhoMissingSonScreenPlay:getStage(pPlayer)
end

function ep3_kachirho_chatook_conv_handler:getInitialScreen(pPlayer, pNpc, pConvTemplate)
	local convoTemplate = LuaConversationTemplate(pConvTemplate)

	if (not CreatureObject(pPlayer):hasSkill("social_language_wookiee_comprehend")) then
		return convoTemplate:getScreen("s_32")
	elseif (self:stage(pPlayer) == 0 and kachirhoMissingSonScreenPlay:getRuns(pPlayer) > 0) then
		return convoTemplate:getScreen("s_236")
	elseif (self:stage(pPlayer) == 3) then
		return convoTemplate:getScreen("s_238")
	elseif (self:stage(pPlayer) > 0) then
		return convoTemplate:getScreen("s_260")
	end

	return convoTemplate:getScreen("s_262")
end

function ep3_kachirho_chatook_conv_handler:runScreenHandlers(pConvTemplate, pPlayer, pNpc, selectedOption, pConvScreen)
	local screen = LuaConversationScreen(pConvScreen)
	local screenID = screen:getScreenID()
	local pClonedScreen = screen:cloneScreen()
	local clonedConversation = LuaConversationScreen(pClonedScreen)

	if (self.screenAnimations ~= nil and self.screenAnimations[screenID] ~= nil and pNpc ~= nil) then
		CreatureObject(pNpc):doAnimation(self.screenAnimations[screenID])
	end

	if (screenID == "s_254") then
		kachirhoMissingSonScreenPlay:signalTurnIn(pPlayer)
	elseif (screenID == "s_285") then
		kachirhoMissingSonScreenPlay:grantQuest(pPlayer)
	end

	return pClonedScreen
end
