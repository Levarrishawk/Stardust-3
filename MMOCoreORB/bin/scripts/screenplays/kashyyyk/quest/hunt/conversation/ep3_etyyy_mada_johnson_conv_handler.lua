-- ep3_etyyy_mada_johnson -- Etyyy hunting-grounds ground conversation
-- ruling 2026-09-04: "ensure kashyyyk is fully done"
-- getInitialScreen is live condition order. runScreenHandlers fires grant / signal / turn-in.
-- No journal engine: this branch has no managers/quest/journal.lua.

ep3_etyyy_mada_johnson_conv_handler = conv_handler:new {}

ep3_etyyy_mada_johnson_conv_handler.screenAnimations = {
	s_664 = "shake_head_disgust",
	s_282 = "greet",
}

function ep3_etyyy_mada_johnson_conv_handler:hasCompletedBrodyQuest(pPlayer, pNpc)
	if (pPlayer == nil) then
		return false
	end
	return huntJohnsonBrodyJohnsonScreenPlay:hasCompletedQuest(pPlayer)
end

function ep3_etyyy_mada_johnson_conv_handler:returnToJohnsonSmith(pPlayer, pNpc)
	if (pPlayer == nil) then
		return false
	end
	return huntJohnsonBrodyJohnsonScreenPlay:isTaskActive(pPlayer, "johnson_returnToSmith")
end

function ep3_etyyy_mada_johnson_conv_handler:isShownPendant(pPlayer, pNpc)
	if (pPlayer == nil) then
		return false
	end
	return huntJohnsonBrodyJohnsonScreenPlay:isTaskActive(pPlayer, "johnson_talkToMada")
end

function ep3_etyyy_mada_johnson_conv_handler:hasCompletedWrelaac(pPlayer, pNpc)
	if (pPlayer == nil) then
		return false
	end
	return (huntWrelaacToChriloocScreenPlay:isQuestActive(pPlayer)) or (huntWrelaacToChriloocScreenPlay:hasCompletedQuest(pPlayer))
end

function ep3_etyyy_mada_johnson_conv_handler:hasProof(pPlayer, pNpc)
	if (pPlayer == nil) then
		return false
	end
	return huntWrelaacProofOfMadaScreenPlay:isTaskActive(pPlayer, "wrelaac_presentProofToWrelaac")
end

function ep3_etyyy_mada_johnson_conv_handler:needsProofForWrelaac(pPlayer, pNpc)
	if (pPlayer == nil) then
		return false
	end
	return huntWrelaacProofOfMadaScreenPlay:isTaskActive(pPlayer, "wrelaac_getProofFromMada")
end

function ep3_etyyy_mada_johnson_conv_handler:seekingWrelaac(pPlayer, pNpc)
	if (pPlayer == nil) then
		return false
	end
	return huntMadaJohnsonToWrelaacScreenPlay:isQuestActive(pPlayer)
end

function ep3_etyyy_mada_johnson_conv_handler:_defaultCondition(pPlayer, pNpc)
	if (pPlayer == nil) then
		return false
	end
	return true
end

function ep3_etyyy_mada_johnson_conv_handler:getInitialScreen(pPlayer, pNpc, pConvTemplate)
	local convoTemplate = LuaConversationTemplate(pConvTemplate)
	if (pPlayer == nil) then
		return convoTemplate:getScreen("s_282")
	end
	if (self:hasCompletedBrodyQuest(pPlayer, pNpc)) then
		return convoTemplate:getScreen("s_252")
	elseif (self:returnToJohnsonSmith(pPlayer, pNpc)) then
		return convoTemplate:getScreen("s_254")
	elseif (self:isShownPendant(pPlayer, pNpc)) then
		return convoTemplate:getScreen("s_256")
	elseif (self:hasCompletedWrelaac(pPlayer, pNpc)) then
		return convoTemplate:getScreen("s_270")
	elseif (self:hasProof(pPlayer, pNpc)) then
		return convoTemplate:getScreen("s_272")
	elseif (self:needsProofForWrelaac(pPlayer, pNpc)) then
		return convoTemplate:getScreen("s_274")
	elseif (self:seekingWrelaac(pPlayer, pNpc)) then
		return convoTemplate:getScreen("s_280")
	end
	return convoTemplate:getScreen("s_282")
end

function ep3_etyyy_mada_johnson_conv_handler:runScreenHandlers(pConvTemplate, pPlayer, pNpc, selectedOption, pConvScreen)
	local screen = LuaConversationScreen(pConvScreen)
	local screenID = screen:getScreenID()
	local pClonedScreen = screen:cloneScreen()
	local clonedConversation = LuaConversationScreen(pClonedScreen)
	if (self.screenAnimations ~= nil and self.screenAnimations[screenID] ~= nil and pNpc ~= nil) then
		CreatureObject(pNpc):doAnimation(self.screenAnimations[screenID])
	end
	if (screenID == "s_264") then
		EtyyyHuntState:raise(pPlayer, "johnson_talkToMada")
	elseif (screenID == "s_290") then
		huntMadaJohnsonToWrelaacScreenPlay:grantQuest(pPlayer)
	end
	return pClonedScreen
end
