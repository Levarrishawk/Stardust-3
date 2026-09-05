-- Sertild -- ep3_forest_dahlia_epic_3, ep3_forest_dahlia_epic_4
-- ruling 2026-09-04: "ensure kashyyyk is fully done"
-- getInitialScreen is live condition order. runScreenHandlers fires grant / signal / turn-in.
-- The journal engine lives on the journal branches. This arc does not call the Journal API.

ep3_forest_sertild_conv_handler = conv_handler:new {}

ep3_forest_sertild_conv_handler.screenAnimations = {
}

function ep3_forest_sertild_conv_handler:condition__defaultCondition(pPlayer, pNpc)
	return true
end

function ep3_forest_sertild_conv_handler:condition_isTaskActiveOne(pPlayer, pNpc)
	return (forestDahliaEpic3ScreenPlay:getStage(pPlayer) > 0 or forestDahliaEpic3ScreenPlay:getRuns(pPlayer) > 0)
end

function ep3_forest_sertild_conv_handler:condition_hasCompletedQuestOne(pPlayer, pNpc)
	return (forestDahliaEpic4ScreenPlay:getStage(pPlayer) > 0 or forestDahliaEpic4ScreenPlay:getRuns(pPlayer) > 0)
end

function ep3_forest_sertild_conv_handler:getInitialScreen(pPlayer, pNpc, pConvTemplate)
	local convoTemplate = LuaConversationTemplate(pConvTemplate)
	if (self:condition_hasCompletedQuestOne(pPlayer, pNpc)) then
		return convoTemplate:getScreen("s_827")
	elseif (self:condition_isTaskActiveOne(pPlayer, pNpc)) then
		return convoTemplate:getScreen("s_829")
	end
	return convoTemplate:getScreen("s_843")
end

function ep3_forest_sertild_conv_handler:runScreenHandlers(pConvTemplate, pPlayer, pNpc, selectedOption, pConvScreen)
	local screen = LuaConversationScreen(pConvScreen)
	local screenID = screen:getScreenID()
	local pClonedScreen = screen:cloneScreen()
	local clonedConversation = LuaConversationScreen(pClonedScreen)

	if (self.screenAnimations ~= nil and self.screenAnimations[screenID] ~= nil and pNpc ~= nil) then
		CreatureObject(pNpc):doAnimation(self.screenAnimations[screenID])
	end

	if (screenID == "s_841") then
		forestDahliaEpic3ScreenPlay:signalStart(pPlayer)
		forestDahliaEpic4ScreenPlay:grantQuest(pPlayer)
	end

	return pClonedScreen
end
