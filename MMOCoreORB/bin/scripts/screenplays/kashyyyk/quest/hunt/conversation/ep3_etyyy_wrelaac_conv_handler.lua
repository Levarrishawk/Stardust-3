-- ep3_etyyy_wrelaac -- Etyyy hunting-grounds ground conversation
-- ruling 2026-09-04: "ensure kashyyyk is fully done"
-- getInitialScreen is live condition order. runScreenHandlers fires grant / signal / turn-in.
-- No journal engine: this branch has no managers/quest/journal.lua.

ep3_etyyy_wrelaac_conv_handler = conv_handler:new {}

ep3_etyyy_wrelaac_conv_handler.screenAnimations = {
	s_66 = "greet",
}

function ep3_etyyy_wrelaac_conv_handler:cannotSpeakWookiee(pPlayer, pNpc)
	if (pPlayer == nil) then
		return false
	end
	return (not CreatureObject(pPlayer):hasSkill("social_language_wookiee_comprehend"))
end

function ep3_etyyy_wrelaac_conv_handler:completedBrodyQuest(pPlayer, pNpc)
	if (pPlayer == nil) then
		return false
	end
	return huntJohnsonBrodyJohnsonScreenPlay:hasCompletedQuest(pPlayer)
end

function ep3_etyyy_wrelaac_conv_handler:hasCompletedMadaQuests(pPlayer, pNpc)
	if (pPlayer == nil) then
		return false
	end
	return huntWrelaacProofOfMadaScreenPlay:hasCompletedQuest(pPlayer) and huntWrelaacToChriloocScreenPlay:hasCompletedQuest(pPlayer)
end

function ep3_etyyy_wrelaac_conv_handler:talkToChrilooc(pPlayer, pNpc)
	if (pPlayer == nil) then
		return false
	end
	return huntWrelaacToChriloocScreenPlay:isQuestActive(pPlayer)
end

function ep3_etyyy_wrelaac_conv_handler:suppliedProof(pPlayer, pNpc)
	if (pPlayer == nil) then
		return false
	end
	return huntWrelaacProofOfMadaScreenPlay:hasCompletedQuest(pPlayer) and not (huntWrelaacToChriloocScreenPlay:isQuestActive(pPlayer) or huntWrelaacToChriloocScreenPlay:hasCompletedQuest(pPlayer))
end

function ep3_etyyy_wrelaac_conv_handler:needsProof(pPlayer, pNpc)
	if (pPlayer == nil) then
		return false
	end
	return huntWrelaacProofOfMadaScreenPlay:isQuestActive(pPlayer)
end

function ep3_etyyy_wrelaac_conv_handler:guessedWrong(pPlayer, pNpc)
	if (pPlayer == nil) then
		return false
	end
	return EtyyyHuntState:guessedWrong(pPlayer)
end

function ep3_etyyy_wrelaac_conv_handler:onMadasQuest(pPlayer, pNpc)
	if (pPlayer == nil) then
		return false
	end
	return huntMadaJohnsonToWrelaacScreenPlay:isQuestActive(pPlayer)
end

function ep3_etyyy_wrelaac_conv_handler:_defaultCondition(pPlayer, pNpc)
	if (pPlayer == nil) then
		return false
	end
	return true
end

function ep3_etyyy_wrelaac_conv_handler:hasProof(pPlayer, pNpc)
	if (pPlayer == nil) then
		return false
	end
	return huntWrelaacProofOfMadaScreenPlay:isTaskActive(pPlayer, "wrelaac_presentProofToWrelaac")
end

function ep3_etyyy_wrelaac_conv_handler:spokeToChrilooc(pPlayer, pNpc)
	if (pPlayer == nil) then
		return false
	end
	return huntWrelaacToChriloocScreenPlay:hasCompletedQuest(pPlayer)
end

function ep3_etyyy_wrelaac_conv_handler:getInitialScreen(pPlayer, pNpc, pConvTemplate)
	local convoTemplate = LuaConversationTemplate(pConvTemplate)
	if (pPlayer == nil) then
		return convoTemplate:getScreen("s_108")
	end
	if (self:cannotSpeakWookiee(pPlayer, pNpc)) then
		return convoTemplate:getScreen("s_37")
	elseif (self:completedBrodyQuest(pPlayer, pNpc)) then
		return convoTemplate:getScreen("s_40")
	elseif (self:hasCompletedMadaQuests(pPlayer, pNpc)) then
		return convoTemplate:getScreen("s_42")
	elseif (self:talkToChrilooc(pPlayer, pNpc)) then
		return convoTemplate:getScreen("s_44")
	elseif (self:suppliedProof(pPlayer, pNpc)) then
		return convoTemplate:getScreen("s_41")
	elseif (self:needsProof(pPlayer, pNpc)) then
		return convoTemplate:getScreen("s_50")
	elseif (self:guessedWrong(pPlayer, pNpc)) then
		return convoTemplate:getScreen("s_60")
	elseif (self:onMadasQuest(pPlayer, pNpc)) then
		return convoTemplate:getScreen("s_66")
	end
	return convoTemplate:getScreen("s_108")
end

function ep3_etyyy_wrelaac_conv_handler:runScreenHandlers(pConvTemplate, pPlayer, pNpc, selectedOption, pConvScreen)
	local screen = LuaConversationScreen(pConvScreen)
	local screenID = screen:getScreenID()
	local pClonedScreen = screen:cloneScreen()
	local clonedConversation = LuaConversationScreen(pClonedScreen)
	if (self.screenAnimations ~= nil and self.screenAnimations[screenID] ~= nil and pNpc ~= nil) then
		CreatureObject(pNpc):doAnimation(self.screenAnimations[screenID])
	end
	if (screenID == "s_54") then
		EtyyyHuntState:raise(pPlayer, "wrelaac_presentProofToWrelaac")
	elseif (screenID == "s_64") then
		huntWrelaacProofOfMadaScreenPlay:grantQuest(pPlayer)
		EtyyyHuntState:setGuessedWrong(pPlayer, false)
	elseif (screenID == "s_90") then
		EtyyyHuntState:setGuessedWrong(pPlayer, true)
	elseif (screenID == "s_94") then
		EtyyyHuntState:setGuessedWrong(pPlayer, true)
	elseif (screenID == "s_98") then
		EtyyyHuntState:setGuessedWrong(pPlayer, true)
	elseif (screenID == "s_102") then
		EtyyyHuntState:setGuessedWrong(pPlayer, true)
	elseif (screenID == "s_82") then
		EtyyyHuntState:raise(pPlayer, "mada_talkToWrelaac")
		huntWrelaacToChriloocScreenPlay:grantQuest(pPlayer)
	end
	return pClonedScreen
end
