-- ep3_etyyy_ryoo_finn -- Etyyy hunting-grounds ground conversation
-- ruling 2026-09-04: "ensure kashyyyk is fully done"
-- getInitialScreen is live condition order. runScreenHandlers fires grant / signal / turn-in.
-- No journal engine: this branch has no managers/quest/journal.lua.

ep3_etyyy_ryoo_finn_conv_handler = conv_handler:new {}

ep3_etyyy_ryoo_finn_conv_handler.screenAnimations = {
	s_1203 = "greet",
}

function ep3_etyyy_ryoo_finn_conv_handler:hasCompletedRyooQuest(pPlayer, pNpc)
	if (pPlayer == nil) then
		return false
	end
	return huntJohnsonRetrieveRyoosStashScreenPlay:hasCompletedQuest(pPlayer)
end

function ep3_etyyy_ryoo_finn_conv_handler:foundRyoosSalt(pPlayer, pNpc)
	if (pPlayer == nil) then
		return false
	end
	return huntJohnsonRetrieveRyoosStashScreenPlay:isTaskActive(pPlayer, "johnson_ryoosSalt")
end

function ep3_etyyy_ryoo_finn_conv_handler:isRetrievingRyoosSalt(pPlayer, pNpc)
	if (pPlayer == nil) then
		return false
	end
	return huntJohnsonRetrieveRyoosStashScreenPlay:isTaskActive(pPlayer, "johnson_findRyoosStash")
end

function ep3_etyyy_ryoo_finn_conv_handler:speakWithRyoo(pPlayer, pNpc)
	if (pPlayer == nil) then
		return false
	end
	return huntJohnsonRetrieveRyoosStashScreenPlay:isTaskActive(pPlayer, "johnson_talkToRyoo")
end

function ep3_etyyy_ryoo_finn_conv_handler:_defaultCondition(pPlayer, pNpc)
	if (pPlayer == nil) then
		return false
	end
	return true
end

function ep3_etyyy_ryoo_finn_conv_handler:getInitialScreen(pPlayer, pNpc, pConvTemplate)
	local convoTemplate = LuaConversationTemplate(pConvTemplate)
	if (pPlayer ~= nil) then
		huntLootNamedKillsScreenPlay:attachPlayer(pPlayer)
	end
	if (pPlayer == nil) then
		return convoTemplate:getScreen("s_1213")
	end
	if (self:hasCompletedRyooQuest(pPlayer, pNpc)) then
		return convoTemplate:getScreen("s_1179")
	elseif (self:foundRyoosSalt(pPlayer, pNpc)) then
		return convoTemplate:getScreen("s_1222")
	elseif (self:isRetrievingRyoosSalt(pPlayer, pNpc)) then
		return convoTemplate:getScreen("s_1197")
	elseif (self:speakWithRyoo(pPlayer, pNpc)) then
		return convoTemplate:getScreen("s_1203")
	end
	return convoTemplate:getScreen("s_1213")
end

function ep3_etyyy_ryoo_finn_conv_handler:runScreenHandlers(pConvTemplate, pPlayer, pNpc, selectedOption, pConvScreen)
	local screen = LuaConversationScreen(pConvScreen)
	local screenID = screen:getScreenID()
	local pClonedScreen = screen:cloneScreen()
	local clonedConversation = LuaConversationScreen(pClonedScreen)
	if (self.screenAnimations ~= nil and self.screenAnimations[screenID] ~= nil and pNpc ~= nil) then
		CreatureObject(pNpc):doAnimation(self.screenAnimations[screenID])
	end
	if (screenID == "s_1221") then
		EtyyyHuntState:raise(pPlayer, "johnson_talkToRyoo")
	end
	return pClonedScreen
end
