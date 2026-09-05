-- Zhadran (Outcast Informant) -- ep3_forest_outcast_contact, ep3_forest_cryl_quest_2, ep3_forest_kerritamba_epic_7, ep3_forest_outcast_assassin, ep3_forest_wirartu_epic_2, ep3_forest_wirartu_epic_3
-- ruling 2026-09-04: "ensure kashyyyk is fully done"
-- getInitialScreen is live condition order. runScreenHandlers fires grant / signal / turn-in.
-- The journal engine lives on the journal branches. This arc does not call the Journal API.

ep3_forest_outcast_informant_conv_handler = conv_handler:new {}

ep3_forest_outcast_informant_conv_handler.screenAnimations = {
}

function ep3_forest_outcast_informant_conv_handler:condition__defaultCondition(pPlayer, pNpc)
	return true
end

function ep3_forest_outcast_informant_conv_handler:condition_isEpicTaskActiveBad(pPlayer, pNpc)
	return ((forestWirartuEpic2ScreenPlay:getStage(pPlayer) == 1)  or  (forestWirartuEpic2ScreenPlay:getRuns(pPlayer) > 0 and forestWirartuEpic2ScreenPlay:getStage(pPlayer) == 0))
end

function ep3_forest_outcast_informant_conv_handler:condition_isEpicTaskActiveGood(pPlayer, pNpc)
	return ((forestWirartuEpic3ScreenPlay:getStage(pPlayer) == 1)  or  (forestWirartuEpic3ScreenPlay:getRuns(pPlayer) > 0 and forestWirartuEpic3ScreenPlay:getStage(pPlayer) == 0)  or  (forestKerritambaEpic7ScreenPlay:getRuns(pPlayer) > 0 and forestKerritambaEpic7ScreenPlay:getStage(pPlayer) == 0))
end

function ep3_forest_outcast_informant_conv_handler:condition_isEpicTaskActiveContact(pPlayer, pNpc)
	return ((forestOutcastContactScreenPlay:getStage(pPlayer) == 1)  or  (forestOutcastContactScreenPlay:getRuns(pPlayer) > 0 and forestOutcastContactScreenPlay:getStage(pPlayer) == 0))
end

function ep3_forest_outcast_informant_conv_handler:condition_isEpicTaskAssassinActive(pPlayer, pNpc)
	return ((forestOutcastAssassin2ScreenPlay:getStage(pPlayer) == 1)  or  (forestOutcastAssassin2ScreenPlay:getRuns(pPlayer) > 0 and forestOutcastAssassin2ScreenPlay:getStage(pPlayer) == 0))
end

function ep3_forest_outcast_informant_conv_handler:condition_ChkActiveAssassin(pPlayer, pNpc)
	return (forestOutcastAssassin2ScreenPlay:getStage(pPlayer) == 1)
end

function ep3_forest_outcast_informant_conv_handler:condition_ChkCompleteAssassin(pPlayer, pNpc)
	return (forestOutcastAssassin2ScreenPlay:getRuns(pPlayer) > 0 and forestOutcastAssassin2ScreenPlay:getStage(pPlayer) == 0)
end

function ep3_forest_outcast_informant_conv_handler:condition_ChkContactActive(pPlayer, pNpc)
	return (forestOutcastContactScreenPlay:getStage(pPlayer) == 1)
end

function ep3_forest_outcast_informant_conv_handler:condition_ChkContactFinish(pPlayer, pNpc)
	return (forestOutcastContactScreenPlay:getRuns(pPlayer) > 0 and forestOutcastContactScreenPlay:getStage(pPlayer) == 0)
end

function ep3_forest_outcast_informant_conv_handler:condition_isTaskActiveOne(pPlayer, pNpc)
	return (forestCrylQuest2ScreenPlay:getStage(pPlayer) == 1)
end

function ep3_forest_outcast_informant_conv_handler:condition_hasCompletedQuestOne(pPlayer, pNpc)
	return (forestCrylQuest2ScreenPlay:getRuns(pPlayer) > 0 and forestCrylQuest2ScreenPlay:getStage(pPlayer) == 0)
end

function ep3_forest_outcast_informant_conv_handler:getInitialScreen(pPlayer, pNpc, pConvTemplate)
	local convoTemplate = LuaConversationTemplate(pConvTemplate)
	if (self:condition_hasCompletedQuestOne(pPlayer, pNpc)) then
		return convoTemplate:getScreen("s_583")
	elseif (self:condition_isTaskActiveOne(pPlayer, pNpc)) then
		return convoTemplate:getScreen("s_594")
	elseif (self:condition_isEpicTaskActiveContact(pPlayer, pNpc)) then
		return convoTemplate:getScreen("s_616")
	elseif (self:condition_isEpicTaskAssassinActive(pPlayer, pNpc)) then
		return convoTemplate:getScreen("s_628")
	elseif (self:condition_isEpicTaskActiveBad(pPlayer, pNpc)) then
		return convoTemplate:getScreen("s_638")
	elseif (self:condition_isEpicTaskActiveGood(pPlayer, pNpc)) then
		return convoTemplate:getScreen("s_652")
	end
	return convoTemplate:getScreen("s_662")
end

function ep3_forest_outcast_informant_conv_handler:runScreenHandlers(pConvTemplate, pPlayer, pNpc, selectedOption, pConvScreen)
	local screen = LuaConversationScreen(pConvScreen)
	local screenID = screen:getScreenID()
	local pClonedScreen = screen:cloneScreen()
	local clonedConversation = LuaConversationScreen(pClonedScreen)

	if (self.screenAnimations ~= nil and self.screenAnimations[screenID] ~= nil and pNpc ~= nil) then
		CreatureObject(pNpc):doAnimation(self.screenAnimations[screenID])
	end

	if (screenID == "s_610") then
		forestCrylQuest2ScreenPlay:signalZhadran(pPlayer)
	elseif (screenID == "s_642") then
		forestOutcastContactScreenPlay:grantQuest(pPlayer)
	end

	return pClonedScreen
end
