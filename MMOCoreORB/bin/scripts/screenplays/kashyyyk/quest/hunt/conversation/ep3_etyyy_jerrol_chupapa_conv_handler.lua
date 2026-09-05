-- ep3_etyyy_jerrol_chupapa -- Etyyy hunting-grounds ground conversation
-- ruling 2026-09-04: "ensure kashyyyk is fully done"
-- getInitialScreen is live condition order. runScreenHandlers fires grant / signal / turn-in.
-- No journal engine: this branch has no managers/quest/journal.lua.

ep3_etyyy_jerrol_chupapa_conv_handler = conv_handler:new {}

ep3_etyyy_jerrol_chupapa_conv_handler.screenAnimations = {
}

function ep3_etyyy_jerrol_chupapa_conv_handler:_defaultCondition(pPlayer, pNpc)
	if (pPlayer == nil) then
		return false
	end
	return true
end

-- OPEN: ep3_etyyy_jerrol_chupapa_condition_doesNotHaveBrodyQuest java was not a straight boolean; see report.
function ep3_etyyy_jerrol_chupapa_conv_handler:doesNotHaveBrodyQuest(pPlayer, pNpc)
	if (pPlayer == nil) then
		return false
	end
	return ((huntChriloocSeekJohnsonScreenPlay:isQuestActive(pPlayer) or huntChriloocSeekJohnsonScreenPlay:hasCompletedQuest(pPlayer)) and (not huntJohnsonBrodyJohnsonScreenPlay:isQuestActive(pPlayer)) and (not huntJohnsonBrodyJohnsonScreenPlay:hasCompletedQuest(pPlayer)))
end

function ep3_etyyy_jerrol_chupapa_conv_handler:getInitialScreen(pPlayer, pNpc, pConvTemplate)
	local convoTemplate = LuaConversationTemplate(pConvTemplate)
	if (pPlayer ~= nil) then
		huntLootNamedKillsScreenPlay:attachPlayer(pPlayer)
	end
	return convoTemplate:getScreen("s_285")
end

function ep3_etyyy_jerrol_chupapa_conv_handler:runScreenHandlers(pConvTemplate, pPlayer, pNpc, selectedOption, pConvScreen)
	local screen = LuaConversationScreen(pConvScreen)
	local screenID = screen:getScreenID()
	local pClonedScreen = screen:cloneScreen()
	local clonedConversation = LuaConversationScreen(pClonedScreen)
	if (self.screenAnimations ~= nil and self.screenAnimations[screenID] ~= nil and pNpc ~= nil) then
		CreatureObject(pNpc):doAnimation(self.screenAnimations[screenID])
	end
	if (screenID == "s_285") then
		clonedConversation:removeAllOptions()
		if (self:doesNotHaveBrodyQuest(pPlayer, pNpc)) then
			clonedConversation:addOption("@conversation/ep3_etyyy_jerrol_chupapa:s_287", "s_289")
		end
		clonedConversation:addOption("@conversation/ep3_etyyy_jerrol_chupapa:s_291", "s_293")
	elseif (screenID == "s_289") then
		huntJerrolSeekJohnsonScreenPlay:grantQuest(pPlayer)
		EtyyyHuntState:raise(pPlayer, "iluna_askAboutBrody")
	end
	return pClonedScreen
end
