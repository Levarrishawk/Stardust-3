-- Cryl -- ep3_forest_cryl_quest_1, ep3_forest_cryl_quest_2, ep3_forest_aveso_quest_2, ep3_forest_kerritamba_epic_7, ep3_forest_wirartu_epic_2, ep3_forest_wirartu_epic_3
-- ruling 2026-09-04: "ensure kashyyyk is fully done"
-- getInitialScreen is live condition order. runScreenHandlers fires grant / signal / turn-in.
-- The journal engine lives on the journal branches. This arc does not call the Journal API.

ep3_forest_cryl_conv_handler = conv_handler:new {}

ep3_forest_cryl_conv_handler.screenAnimations = {
}

function ep3_forest_cryl_conv_handler:condition__defaultCondition(pPlayer, pNpc)
	return true
end

function ep3_forest_cryl_conv_handler:condition_isGoodGuy(pPlayer, pNpc)
	return ((forestWirartuEpic3ScreenPlay:getStage(pPlayer) == 1)  or  (forestWirartuEpic3ScreenPlay:getRuns(pPlayer) > 0 and forestWirartuEpic3ScreenPlay:getStage(pPlayer) == 0)  or  (forestKerritambaEpic7ScreenPlay:getRuns(pPlayer) > 0 and forestKerritambaEpic7ScreenPlay:getStage(pPlayer) == 0))
end

function ep3_forest_cryl_conv_handler:condition_isBadGuy(pPlayer, pNpc)
	return ((forestWirartuEpic2ScreenPlay:getStage(pPlayer) == 1)  or  (forestWirartuEpic2ScreenPlay:getRuns(pPlayer) > 0 and forestWirartuEpic2ScreenPlay:getStage(pPlayer) == 0))
end

function ep3_forest_cryl_conv_handler:condition_hasCompleteInitial(pPlayer, pNpc)
	return (forestAvesoQuest2ScreenPlay:getRuns(pPlayer) > 0 and forestAvesoQuest2ScreenPlay:getStage(pPlayer) == 0)
end

function ep3_forest_cryl_conv_handler:condition_isTaskActiveOne(pPlayer, pNpc)
	return (forestCrylQuest1ScreenPlay:getStage(pPlayer) == 1)  or  (forestCrylQuest1ScreenPlay:getStage(pPlayer) >= 2 or forestCrylQuest1ScreenPlay:getRuns(pPlayer) > 0)
end

function ep3_forest_cryl_conv_handler:condition_hasCompletedTaskOne(pPlayer, pNpc)
	return ((forestCrylQuest1ScreenPlay:getStage(pPlayer) >= 2 or forestCrylQuest1ScreenPlay:getRuns(pPlayer) > 0)  and   not (forestCrylQuest1ScreenPlay:getRuns(pPlayer) > 0 and forestCrylQuest1ScreenPlay:getStage(pPlayer) == 0))
end

function ep3_forest_cryl_conv_handler:condition_hasCompletedQuestOne(pPlayer, pNpc)
	return (forestCrylQuest1ScreenPlay:getRuns(pPlayer) > 0 and forestCrylQuest1ScreenPlay:getStage(pPlayer) == 0)
end

function ep3_forest_cryl_conv_handler:condition_isTaskActiveTwo(pPlayer, pNpc)
	return (forestCrylQuest2ScreenPlay:getStage(pPlayer) == 1)  or  (forestCrylQuest2ScreenPlay:getStage(pPlayer) >= 2 or forestCrylQuest2ScreenPlay:getRuns(pPlayer) > 0)
end

function ep3_forest_cryl_conv_handler:condition_hasCompletedTaskTwo(pPlayer, pNpc)
	return ((forestCrylQuest2ScreenPlay:getStage(pPlayer) >= 2 or forestCrylQuest2ScreenPlay:getRuns(pPlayer) > 0)  and   not (forestCrylQuest2ScreenPlay:getRuns(pPlayer) > 0 and forestCrylQuest2ScreenPlay:getStage(pPlayer) == 0))
end

function ep3_forest_cryl_conv_handler:condition_hasCompletedQuestTwo(pPlayer, pNpc)
	return (forestCrylQuest2ScreenPlay:getRuns(pPlayer) > 0 and forestCrylQuest2ScreenPlay:getStage(pPlayer) == 0)
end

function ep3_forest_cryl_conv_handler:getInitialScreen(pPlayer, pNpc, pConvTemplate)
	local convoTemplate = LuaConversationTemplate(pConvTemplate)
	if (self:condition_hasCompletedQuestTwo(pPlayer, pNpc)) then
		return convoTemplate:getScreen("s_1293")
	elseif (self:condition_hasCompletedTaskTwo(pPlayer, pNpc)) then
		return convoTemplate:getScreen("s_1295")
	elseif (self:condition_isTaskActiveTwo(pPlayer, pNpc)) then
		return convoTemplate:getScreen("s_1309")
	elseif (self:condition_hasCompletedQuestOne(pPlayer, pNpc)) then
		return convoTemplate:getScreen("s_1311")
	elseif (self:condition_hasCompletedTaskOne(pPlayer, pNpc)) then
		return convoTemplate:getScreen("s_1325")
	elseif (self:condition_isTaskActiveOne(pPlayer, pNpc)) then
		return convoTemplate:getScreen("s_1331")
	elseif (self:condition_hasCompleteInitial(pPlayer, pNpc)) then
		return convoTemplate:getScreen("s_1337")
	elseif (self:condition_isBadGuy(pPlayer, pNpc)) then
		return convoTemplate:getScreen("s_1351")
	elseif (self:condition_isGoodGuy(pPlayer, pNpc)) then
		return convoTemplate:getScreen("s_1353")
	end
	return convoTemplate:getScreen("s_1355")
end

function ep3_forest_cryl_conv_handler:runScreenHandlers(pConvTemplate, pPlayer, pNpc, selectedOption, pConvScreen)
	local screen = LuaConversationScreen(pConvScreen)
	local screenID = screen:getScreenID()
	local pClonedScreen = screen:cloneScreen()
	local clonedConversation = LuaConversationScreen(pClonedScreen)

	if (self.screenAnimations ~= nil and self.screenAnimations[screenID] ~= nil and pNpc ~= nil) then
		CreatureObject(pNpc):doAnimation(self.screenAnimations[screenID])
	end

	if (screenID == "s_1299") then
		forestCrylQuest2ScreenPlay:signalFinish(pPlayer)
	elseif (screenID == "s_1319") then
		forestCrylQuest2ScreenPlay:grantQuest(pPlayer)
	elseif (screenID == "s_1329") then
		forestCrylQuest1ScreenPlay:signalMix(pPlayer)
	elseif (screenID == "s_1349") then
		forestCrylQuest1ScreenPlay:grantQuest(pPlayer)
	end

	return pClonedScreen
end
