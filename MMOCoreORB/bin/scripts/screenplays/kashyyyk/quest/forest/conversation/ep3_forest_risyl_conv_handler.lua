-- Risyl -- ep3_forest_cryl_quest_1
-- ruling 2026-09-04: "ensure kashyyyk is fully done"
-- getInitialScreen is live condition order. runScreenHandlers fires grant / signal / turn-in.
-- The journal engine lives on the journal branches. This arc does not call the Journal API.

ep3_forest_risyl_conv_handler = conv_handler:new {}

ep3_forest_risyl_conv_handler.screenAnimations = {
}

function ep3_forest_risyl_conv_handler:condition__defaultCondition(pPlayer, pNpc)
	return true
end

function ep3_forest_risyl_conv_handler:condition_isTaskActiveOne(pPlayer, pNpc)
	return (forestCrylQuest1ScreenPlay:getStage(pPlayer) == 1)
end

function ep3_forest_risyl_conv_handler:condition_hasCompletedQuestOne(pPlayer, pNpc)
	return (forestCrylQuest1ScreenPlay:getRuns(pPlayer) > 0 and forestCrylQuest1ScreenPlay:getStage(pPlayer) == 0)
end

function ep3_forest_risyl_conv_handler:getInitialScreen(pPlayer, pNpc, pConvTemplate)
	local convoTemplate = LuaConversationTemplate(pConvTemplate)
	if (self:condition_hasCompletedQuestOne(pPlayer, pNpc)) then
		return convoTemplate:getScreen("s_803")
	elseif (self:condition_isTaskActiveOne(pPlayer, pNpc)) then
		return convoTemplate:getScreen("s_805")
	end
	return convoTemplate:getScreen("s_823")
end

function ep3_forest_risyl_conv_handler:runScreenHandlers(pConvTemplate, pPlayer, pNpc, selectedOption, pConvScreen)
	local screen = LuaConversationScreen(pConvScreen)
	local screenID = screen:getScreenID()
	local pClonedScreen = screen:cloneScreen()
	local clonedConversation = LuaConversationScreen(pClonedScreen)

	if (self.screenAnimations ~= nil and self.screenAnimations[screenID] ~= nil and pNpc ~= nil) then
		CreatureObject(pNpc):doAnimation(self.screenAnimations[screenID])
	end

	if (screenID == "s_813") then
		forestCrylQuest1ScreenPlay:signalBile(pPlayer)
	end

	return pClonedScreen
end
