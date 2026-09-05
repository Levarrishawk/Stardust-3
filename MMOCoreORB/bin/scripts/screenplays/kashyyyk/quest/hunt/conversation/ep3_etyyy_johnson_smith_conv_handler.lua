-- ep3_etyyy_johnson_smith -- Etyyy hunting-grounds ground conversation
-- ruling 2026-09-04: "ensure kashyyyk is fully done"
-- getInitialScreen is live condition order. runScreenHandlers fires grant / signal / turn-in.
-- No journal engine: this branch has no managers/quest/journal.lua.

ep3_etyyy_johnson_smith_conv_handler = conv_handler:new {}

ep3_etyyy_johnson_smith_conv_handler.screenAnimations = {
	s_223 = "greet",
}

function ep3_etyyy_johnson_smith_conv_handler:completedSmithQuests(pPlayer, pNpc)
	if (pPlayer == nil) then
		return false
	end
	return huntJohnsonBrodyJohnsonScreenPlay:hasCompletedQuest(pPlayer) and huntJohnsonSeekKintScreenPlay:hasCompletedQuest(pPlayer)
end

-- OPEN: ep3_etyyy_johnson_smith_condition_doingSmithQuests java was not a straight boolean; see report.
function ep3_etyyy_johnson_smith_conv_handler:doingSmithQuests(pPlayer, pNpc)
	if (pPlayer == nil) then
		return false
	end
	return (huntJohnsonBrodyJohnsonScreenPlay:isQuestActive(pPlayer) or huntJohnsonRetrieveRyoosStashScreenPlay:isQuestActive(pPlayer) or huntJohnsonHelpKaraScreenPlay:isQuestActive(pPlayer) or huntJohnsonSeekKintScreenPlay:isQuestActive(pPlayer) or (huntJohnsonBrodyJohnsonScreenPlay:hasCompletedQuest(pPlayer) and not (huntJohnsonRetrieveRyoosStashScreenPlay:hasCompletedQuest(pPlayer) and huntJohnsonHelpKaraScreenPlay:hasCompletedQuest(pPlayer) and huntJohnsonSeekKintScreenPlay:hasCompletedQuest(pPlayer))))
end

function ep3_etyyy_johnson_smith_conv_handler:_defaultCondition(pPlayer, pNpc)
	if (pPlayer == nil) then
		return false
	end
	return true
end

function ep3_etyyy_johnson_smith_conv_handler:sentToKint(pPlayer, pNpc)
	if (pPlayer == nil) then
		return false
	end
	return huntJohnsonSeekKintScreenPlay:isQuestActive(pPlayer)
end

function ep3_etyyy_johnson_smith_conv_handler:needsKint(pPlayer, pNpc)
	if (pPlayer == nil) then
		return false
	end
	return huntJohnsonHelpKaraScreenPlay:hasCompletedQuest(pPlayer) and not (huntJohnsonSeekKintScreenPlay:isQuestActive(pPlayer) or huntJohnsonSeekKintScreenPlay:hasCompletedQuest(pPlayer))
end

function ep3_etyyy_johnson_smith_conv_handler:helpingKara(pPlayer, pNpc)
	if (pPlayer == nil) then
		return false
	end
	return huntJohnsonHelpKaraScreenPlay:isQuestActive(pPlayer)
end

function ep3_etyyy_johnson_smith_conv_handler:helpingRyoo(pPlayer, pNpc)
	if (pPlayer == nil) then
		return false
	end
	return huntJohnsonRetrieveRyoosStashScreenPlay:isQuestActive(pPlayer)
end

function ep3_etyyy_johnson_smith_conv_handler:findingBrody(pPlayer, pNpc)
	if (pPlayer == nil) then
		return false
	end
	return huntJohnsonBrodyJohnsonScreenPlay:isQuestActive(pPlayer)
end

function ep3_etyyy_johnson_smith_conv_handler:notStartedRyoo(pPlayer, pNpc)
	if (pPlayer == nil) then
		return false
	end
	return not huntJohnsonRetrieveRyoosStashScreenPlay:isQuestActive(pPlayer) and not huntJohnsonRetrieveRyoosStashScreenPlay:hasCompletedQuest(pPlayer)
end

function ep3_etyyy_johnson_smith_conv_handler:doesNotHaveBrodyQuest(pPlayer, pNpc)
	if (pPlayer == nil) then
		return false
	end
	return not huntJohnsonBrodyJohnsonScreenPlay:isQuestActive(pPlayer) and not huntJohnsonBrodyJohnsonScreenPlay:hasCompletedQuest(pPlayer)
end

function ep3_etyyy_johnson_smith_conv_handler:sentByChrilooc(pPlayer, pNpc)
	if (pPlayer == nil) then
		return false
	end
	return huntChriloocSeekJohnsonScreenPlay:isQuestActive(pPlayer) or huntChriloocSeekJohnsonScreenPlay:hasCompletedQuest(pPlayer)
end

-- OPEN: ep3_etyyy_johnson_smith_condition_sentByJerrol java was not a straight boolean; see report.
function ep3_etyyy_johnson_smith_conv_handler:sentByJerrol(pPlayer, pNpc)
	if (pPlayer == nil) then
		return false
	end
	return ((huntJerrolSeekJohnsonScreenPlay:isQuestActive(pPlayer) or huntJerrolSeekJohnsonScreenPlay:hasCompletedQuest(pPlayer)) and (not huntJohnsonBrodyJohnsonScreenPlay:isQuestActive(pPlayer)) and (not huntJohnsonBrodyJohnsonScreenPlay:hasCompletedQuest(pPlayer)))
end

function ep3_etyyy_johnson_smith_conv_handler:lookingForRyoo(pPlayer, pNpc)
	if (pPlayer == nil) then
		return false
	end
	return huntJohnsonRetrieveRyoosStashScreenPlay:isTaskActive(pPlayer, "johnson_talkToRyoo")
end

function ep3_etyyy_johnson_smith_conv_handler:finishedHelpingRyoo(pPlayer, pNpc)
	if (pPlayer == nil) then
		return false
	end
	return huntJohnsonRetrieveRyoosStashScreenPlay:isTaskActive(pPlayer, "johnson_ryoosSalt")
end

function ep3_etyyy_johnson_smith_conv_handler:hasPendant(pPlayer, pNpc)
	if (pPlayer == nil) then
		return false
	end
	return huntJohnsonBrodyJohnsonScreenPlay:isTaskActive(pPlayer, "johnson_foundPendant")
end

function ep3_etyyy_johnson_smith_conv_handler:lookingForBrodyCamp(pPlayer, pNpc)
	if (pPlayer == nil) then
		return false
	end
	return huntJohnsonBrodyJohnsonScreenPlay:isTaskActive(pPlayer, "johnson_searchCampsite")
end

function ep3_etyyy_johnson_smith_conv_handler:speakingToMada(pPlayer, pNpc)
	if (pPlayer == nil) then
		return false
	end
	return huntJohnsonBrodyJohnsonScreenPlay:isTaskActive(pPlayer, "johnson_talkToMada")
end

function ep3_etyyy_johnson_smith_conv_handler:returningFromMada(pPlayer, pNpc)
	if (pPlayer == nil) then
		return false
	end
	return huntJohnsonBrodyJohnsonScreenPlay:isTaskActive(pPlayer, "johnson_returnToSmith")
end

function ep3_etyyy_johnson_smith_conv_handler:finishedKaraQuest(pPlayer, pNpc)
	if (pPlayer == nil) then
		return false
	end
	return huntJohnsonHelpKaraScreenPlay:isTaskActive(pPlayer, "johnson_deliveriesMade")
end

function ep3_etyyy_johnson_smith_conv_handler:karaDeliveries(pPlayer, pNpc)
	if (pPlayer == nil) then
		return false
	end
	return huntJohnsonHelpKaraScreenPlay:isTaskActive(pPlayer, "johnson_karaDeliveries")
end

function ep3_etyyy_johnson_smith_conv_handler:lookingForKara(pPlayer, pNpc)
	if (pPlayer == nil) then
		return false
	end
	return huntJohnsonHelpKaraScreenPlay:isTaskActive(pPlayer, "johnson_talkToKara")
end

function ep3_etyyy_johnson_smith_conv_handler:getInitialScreen(pPlayer, pNpc, pConvTemplate)
	local convoTemplate = LuaConversationTemplate(pConvTemplate)
	if (pPlayer ~= nil) then
		huntLootNamedKillsScreenPlay:attachPlayer(pPlayer)
	end
	if (pPlayer == nil) then
		return convoTemplate:getScreen("s_239")
	end
	if (self:completedSmithQuests(pPlayer, pNpc)) then
		return convoTemplate:getScreen("s_106")
	elseif (self:doingSmithQuests(pPlayer, pNpc)) then
		return convoTemplate:getScreen("s_108")
	end
	return convoTemplate:getScreen("s_239")
end

function ep3_etyyy_johnson_smith_conv_handler:runScreenHandlers(pConvTemplate, pPlayer, pNpc, selectedOption, pConvScreen)
	local screen = LuaConversationScreen(pConvScreen)
	local screenID = screen:getScreenID()
	local pClonedScreen = screen:cloneScreen()
	local clonedConversation = LuaConversationScreen(pClonedScreen)
	if (self.screenAnimations ~= nil and self.screenAnimations[screenID] ~= nil and pNpc ~= nil) then
		CreatureObject(pNpc):doAnimation(self.screenAnimations[screenID])
	end
	if (screenID == "s_108") then
		clonedConversation:removeAllOptions()
		if (self:sentToKint(pPlayer, pNpc)) then
			clonedConversation:addOption("@conversation/ep3_etyyy_johnson_smith:s_110", "s_112")
		end
		if (self:needsKint(pPlayer, pNpc)) then
			clonedConversation:addOption("@conversation/ep3_etyyy_johnson_smith:s_83", "s_84")
		end
		if (self:finishedKaraQuest(pPlayer, pNpc)) then
			clonedConversation:addOption("@conversation/ep3_etyyy_johnson_smith:s_114", "s_116")
		elseif (self:karaDeliveries(pPlayer, pNpc)) then
			clonedConversation:addOption("@conversation/ep3_etyyy_johnson_smith:s_114", "s_138")
		elseif (self:lookingForKara(pPlayer, pNpc)) then
			clonedConversation:addOption("@conversation/ep3_etyyy_johnson_smith:s_114", "s_140")
		elseif (self:helpingKara(pPlayer, pNpc)) then
			clonedConversation:addOption("@conversation/ep3_etyyy_johnson_smith:s_114", "s_142")
		end
		if (self:finishedHelpingRyoo(pPlayer, pNpc)) then
			clonedConversation:addOption("@conversation/ep3_etyyy_johnson_smith:s_144", "s_146")
		elseif (self:lookingForRyoo(pPlayer, pNpc)) then
			clonedConversation:addOption("@conversation/ep3_etyyy_johnson_smith:s_144", "s_156")
		elseif (self:helpingRyoo(pPlayer, pNpc)) then
			clonedConversation:addOption("@conversation/ep3_etyyy_johnson_smith:s_144", "s_158")
		end
		if (self:returningFromMada(pPlayer, pNpc)) then
			clonedConversation:addOption("@conversation/ep3_etyyy_johnson_smith:s_160", "s_162")
		elseif (self:speakingToMada(pPlayer, pNpc)) then
			clonedConversation:addOption("@conversation/ep3_etyyy_johnson_smith:s_160", "s_210")
		elseif (self:hasPendant(pPlayer, pNpc)) then
			clonedConversation:addOption("@conversation/ep3_etyyy_johnson_smith:s_160", "s_212")
		elseif (self:lookingForBrodyCamp(pPlayer, pNpc)) then
			clonedConversation:addOption("@conversation/ep3_etyyy_johnson_smith:s_160", "s_223")
		elseif (self:findingBrody(pPlayer, pNpc)) then
			clonedConversation:addOption("@conversation/ep3_etyyy_johnson_smith:s_160", "s_227")
		end
		if (self:notStartedRyoo(pPlayer, pNpc) and (self:sentByChrilooc(pPlayer, pNpc) or huntChriloocSeekJohnsonScreenPlay:hasCompletedQuest(pPlayer))) then
			clonedConversation:addOption("@conversation/ep3_etyyy_johnson_smith:s_231", "s_267")
		end
		if (self:doesNotHaveBrodyQuest(pPlayer, pNpc) and (self:sentByChrilooc(pPlayer, pNpc) or self:sentByJerrol(pPlayer, pNpc))) then
			clonedConversation:addOption("@conversation/ep3_etyyy_johnson_smith:s_235", "s_251")
		end
	elseif (screenID == "s_239") then
		clonedConversation:removeAllOptions()
		if (self:sentByChrilooc(pPlayer, pNpc) or self:sentByJerrol(pPlayer, pNpc)) then
			clonedConversation:addOption("@conversation/ep3_etyyy_johnson_smith:s_243", "s_245")
		end
		clonedConversation:addOption("@conversation/ep3_etyyy_johnson_smith:s_279", "s_281")
	elseif (screenID == "s_146") then
		EtyyyHuntState:raise(pPlayer, "johnson_ryoosSalt")
	elseif (screenID == "s_116") then
		EtyyyHuntState:raise(pPlayer, "johnson_deliveriesMade")
	elseif (screenID == "s_128") then
		huntJohnsonSeekKintScreenPlay:grantQuest(pPlayer)
	elseif (screenID == "s_150") then
		huntJohnsonHelpKaraScreenPlay:grantQuest(pPlayer)
	elseif (screenID == "s_194") then
		EtyyyHuntState:raise(pPlayer, "johnson_returnToSmith")
		huntVritolRewardMountScreenPlay:grantQuest(pPlayer)
	elseif (screenID == "s_216") then
		EtyyyHuntState:raise(pPlayer, "johnson_foundPendant")
	elseif (screenID == "s_245") then
		EtyyyHuntState:raise(pPlayer, "chrilooc_seekJohnsonSmith")
		EtyyyHuntState:raise(pPlayer, "jerrol_talkToSmith")
	elseif (screenID == "s_259") then
		huntJohnsonBrodyJohnsonScreenPlay:grantQuest(pPlayer)
	elseif (screenID == "s_271") then
		huntJohnsonRetrieveRyoosStashScreenPlay:grantQuest(pPlayer)
	end
	return pClonedScreen
end
