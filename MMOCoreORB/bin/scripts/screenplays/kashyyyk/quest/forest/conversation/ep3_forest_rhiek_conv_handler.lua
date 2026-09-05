-- Rhiek -- ep3_forest_rhiek_quest_1, ep3_forest_rhiek_quest_2, ep3_forest_rhiek_quest_3, ep3_forest_aveso_quest_2, ep3_forest_kerritamba_epic_7, ep3_forest_wirartu_epic_2, ep3_forest_wirartu_epic_3
-- ruling 2026-09-04: "ensure kashyyyk is fully done"
-- getInitialScreen is live condition order. runScreenHandlers fires grant / signal / turn-in.
-- The journal engine lives on the journal branches. This arc does not call the Journal API.

ep3_forest_rhiek_conv_handler = conv_handler:new {}

ep3_forest_rhiek_conv_handler.screenAnimations = {
}

function ep3_forest_rhiek_conv_handler:condition__defaultCondition(pPlayer, pNpc)
	return true
end

function ep3_forest_rhiek_conv_handler:condition_isGoodGuy(pPlayer, pNpc)
	return ((forestWirartuEpic3ScreenPlay:getStage(pPlayer) == 1)  or  (forestWirartuEpic3ScreenPlay:getRuns(pPlayer) > 0 and forestWirartuEpic3ScreenPlay:getStage(pPlayer) == 0)  or  (forestKerritambaEpic7ScreenPlay:getRuns(pPlayer) > 0 and forestKerritambaEpic7ScreenPlay:getStage(pPlayer) == 0))
end

function ep3_forest_rhiek_conv_handler:condition_isBadGuy(pPlayer, pNpc)
	return ((forestWirartuEpic2ScreenPlay:getStage(pPlayer) == 1)  or  (forestWirartuEpic2ScreenPlay:getRuns(pPlayer) > 0 and forestWirartuEpic2ScreenPlay:getStage(pPlayer) == 0))
end

function ep3_forest_rhiek_conv_handler:condition_hasCompletedInitial(pPlayer, pNpc)
	return (forestAvesoQuest2ScreenPlay:getRuns(pPlayer) > 0 and forestAvesoQuest2ScreenPlay:getStage(pPlayer) == 0)
end

function ep3_forest_rhiek_conv_handler:condition_isTaskActiveOne(pPlayer, pNpc)
	return (forestRhiekQuest1ScreenPlay:getStage(pPlayer) == 1)  or  (forestRhiekQuest1ScreenPlay:getStage(pPlayer) >= 2 or forestRhiekQuest1ScreenPlay:getRuns(pPlayer) > 0)
end

function ep3_forest_rhiek_conv_handler:condition_hasCompletedTaskOne(pPlayer, pNpc)
	return ((forestRhiekQuest1ScreenPlay:getStage(pPlayer) >= 2 or forestRhiekQuest1ScreenPlay:getRuns(pPlayer) > 0)  and   not (forestRhiekQuest1ScreenPlay:getRuns(pPlayer) > 0 and forestRhiekQuest1ScreenPlay:getStage(pPlayer) == 0))
end

function ep3_forest_rhiek_conv_handler:condition_hasCompletedQuestOne(pPlayer, pNpc)
	return (forestRhiekQuest1ScreenPlay:getRuns(pPlayer) > 0 and forestRhiekQuest1ScreenPlay:getStage(pPlayer) == 0)
end

function ep3_forest_rhiek_conv_handler:condition_isTaskActiveTwo(pPlayer, pNpc)
	return (forestRhiekQuest2ScreenPlay:getStage(pPlayer) == 1)  or  (forestRhiekQuest2ScreenPlay:getStage(pPlayer) >= 2 or forestRhiekQuest2ScreenPlay:getRuns(pPlayer) > 0)
end

function ep3_forest_rhiek_conv_handler:condition_hasCompletedTaskTwo(pPlayer, pNpc)
	return ((forestRhiekQuest2ScreenPlay:getStage(pPlayer) >= 2 or forestRhiekQuest2ScreenPlay:getRuns(pPlayer) > 0)  and   not (forestRhiekQuest2ScreenPlay:getRuns(pPlayer) > 0 and forestRhiekQuest2ScreenPlay:getStage(pPlayer) == 0))
end

function ep3_forest_rhiek_conv_handler:condition_hasCompletedQuestTwo(pPlayer, pNpc)
	return (forestRhiekQuest2ScreenPlay:getRuns(pPlayer) > 0 and forestRhiekQuest2ScreenPlay:getStage(pPlayer) == 0)
end

function ep3_forest_rhiek_conv_handler:condition_isTaskActiveThree(pPlayer, pNpc)
	return (forestRhiekQuest3ScreenPlay:getStage(pPlayer) == 1)  or  (forestRhiekQuest3ScreenPlay:getStage(pPlayer) >= 2 or forestRhiekQuest3ScreenPlay:getRuns(pPlayer) > 0)
end

function ep3_forest_rhiek_conv_handler:condition_hasCompletedTaskThree(pPlayer, pNpc)
	return ((forestRhiekQuest3ScreenPlay:getStage(pPlayer) >= 2 or forestRhiekQuest3ScreenPlay:getRuns(pPlayer) > 0)  and   not (forestRhiekQuest3ScreenPlay:getRuns(pPlayer) > 0 and forestRhiekQuest3ScreenPlay:getStage(pPlayer) == 0))
end

function ep3_forest_rhiek_conv_handler:condition_hasCompletedQuestThree(pPlayer, pNpc)
	return (forestRhiekQuest3ScreenPlay:getRuns(pPlayer) > 0 and forestRhiekQuest3ScreenPlay:getStage(pPlayer) == 0)
end

function ep3_forest_rhiek_conv_handler:getInitialScreen(pPlayer, pNpc, pConvTemplate)
	local convoTemplate = LuaConversationTemplate(pConvTemplate)
	if (self:condition_hasCompletedQuestThree(pPlayer, pNpc)) then
		return convoTemplate:getScreen("s_3892")
	elseif (self:condition_hasCompletedTaskThree(pPlayer, pNpc)) then
		return convoTemplate:getScreen("s_3894")
	elseif (self:condition_isTaskActiveThree(pPlayer, pNpc)) then
		return convoTemplate:getScreen("s_3908")
	elseif (self:condition_hasCompletedQuestTwo(pPlayer, pNpc)) then
		return convoTemplate:getScreen("s_3914")
	elseif (self:condition_hasCompletedTaskTwo(pPlayer, pNpc)) then
		return convoTemplate:getScreen("s_3932")
	elseif (self:condition_isTaskActiveTwo(pPlayer, pNpc)) then
		return convoTemplate:getScreen("s_3942")
	elseif (self:condition_hasCompletedQuestOne(pPlayer, pNpc)) then
		return convoTemplate:getScreen("s_3952")
	elseif (self:condition_hasCompletedTaskOne(pPlayer, pNpc)) then
		return convoTemplate:getScreen("s_3966")
	elseif (self:condition_isTaskActiveOne(pPlayer, pNpc)) then
		return convoTemplate:getScreen("s_3976")
	elseif (self:condition_hasCompletedInitial(pPlayer, pNpc)) then
		return convoTemplate:getScreen("s_3982")
	elseif (self:condition_isBadGuy(pPlayer, pNpc)) then
		return convoTemplate:getScreen("s_4008")
	elseif (self:condition_isGoodGuy(pPlayer, pNpc)) then
		return convoTemplate:getScreen("s_4010")
	end
	return convoTemplate:getScreen("s_4012")
end

function ep3_forest_rhiek_conv_handler:runScreenHandlers(pConvTemplate, pPlayer, pNpc, selectedOption, pConvScreen)
	local screen = LuaConversationScreen(pConvScreen)
	local screenID = screen:getScreenID()
	local pClonedScreen = screen:cloneScreen()
	local clonedConversation = LuaConversationScreen(pClonedScreen)

	if (self.screenAnimations ~= nil and self.screenAnimations[screenID] ~= nil and pNpc ~= nil) then
		CreatureObject(pNpc):doAnimation(self.screenAnimations[screenID])
	end

	if (screenID == "s_3898") then
		forestRhiekQuest3ScreenPlay:signalQueen(pPlayer)
	elseif (screenID == "s_3926") then
		forestRhiekQuest3ScreenPlay:grantQuest(pPlayer)
	elseif (screenID == "s_3936") then
		forestRhiekQuest2ScreenPlay:signalBones(pPlayer)
	elseif (screenID == "s_3960") then
		forestRhiekQuest2ScreenPlay:grantQuest(pPlayer)
	elseif (screenID == "s_3970") then
		forestRhiekQuest1ScreenPlay:signalPoison(pPlayer)
	elseif (screenID == "s_3998") then
		forestRhiekQuest1ScreenPlay:grantQuest(pPlayer)
	end

	return pClonedScreen
end
