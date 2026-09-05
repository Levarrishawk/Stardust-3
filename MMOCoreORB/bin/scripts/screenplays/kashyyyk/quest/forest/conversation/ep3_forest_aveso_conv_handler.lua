-- Aveso -- ep3_forest_aveso_quest_1, ep3_forest_aveso_quest_2, ep3_forest_aveso_quest_3, ep3_forest_outcast_contact, ep3_forest_outcast_assassin, ep3_forest_kerritamba_epic_7, ep3_forest_wirartu_epic_2, ep3_forest_wirartu_epic_3
-- ruling 2026-09-04: "ensure kashyyyk is fully done"
-- getInitialScreen is live condition order. runScreenHandlers fires grant / signal / turn-in.
-- The journal engine lives on the journal branches. This arc does not call the Journal API.

ep3_forest_aveso_conv_handler = conv_handler:new {}

ep3_forest_aveso_conv_handler.screenAnimations = {
	s_1233 = "bow",
}

function ep3_forest_aveso_conv_handler:condition__defaultCondition(pPlayer, pNpc)
	return true
end

function ep3_forest_aveso_conv_handler:condition_isGoodguy(pPlayer, pNpc)
	return ((forestWirartuEpic3ScreenPlay:getStage(pPlayer) == 1)  or  (forestWirartuEpic3ScreenPlay:getRuns(pPlayer) > 0 and forestWirartuEpic3ScreenPlay:getStage(pPlayer) == 0)  or  (forestKerritambaEpic7ScreenPlay:getRuns(pPlayer) > 0 and forestKerritambaEpic7ScreenPlay:getStage(pPlayer) == 0))
end

function ep3_forest_aveso_conv_handler:condition_isBadGuy(pPlayer, pNpc)
	return ((forestWirartuEpic2ScreenPlay:getStage(pPlayer) == 1)  or  (forestWirartuEpic2ScreenPlay:getRuns(pPlayer) > 0 and forestWirartuEpic2ScreenPlay:getStage(pPlayer) == 0))
end

function ep3_forest_aveso_conv_handler:condition_isTaskActiveInitial(pPlayer, pNpc)
	return (forestOutcastContactScreenPlay:getStage(pPlayer) == 1)  or  (forestOutcastContactScreenPlay:getStage(pPlayer) >= 1 or forestOutcastContactScreenPlay:getRuns(pPlayer) > 0)
end

function ep3_forest_aveso_conv_handler:condition_isTaskActiveOne(pPlayer, pNpc)
	return (forestAvesoQuest1ScreenPlay:getStage(pPlayer) == 1)  or  (forestAvesoQuest1ScreenPlay:getStage(pPlayer) >= 2 or forestAvesoQuest1ScreenPlay:getRuns(pPlayer) > 0)
end

function ep3_forest_aveso_conv_handler:condition_hasCompletedTaskOne(pPlayer, pNpc)
	return ((forestAvesoQuest1ScreenPlay:getStage(pPlayer) >= 2 or forestAvesoQuest1ScreenPlay:getRuns(pPlayer) > 0)  and   not (forestAvesoQuest1ScreenPlay:getRuns(pPlayer) > 0 and forestAvesoQuest1ScreenPlay:getStage(pPlayer) == 0))
end

function ep3_forest_aveso_conv_handler:condition_hasCompletedQuestOne(pPlayer, pNpc)
	return (forestAvesoQuest1ScreenPlay:getRuns(pPlayer) > 0 and forestAvesoQuest1ScreenPlay:getStage(pPlayer) == 0)
end

function ep3_forest_aveso_conv_handler:condition_isTaskActiveTwo(pPlayer, pNpc)
	return (forestAvesoQuest2ScreenPlay:getStage(pPlayer) == 1)  or  (forestAvesoQuest2ScreenPlay:getStage(pPlayer) >= 2 or forestAvesoQuest2ScreenPlay:getRuns(pPlayer) > 0)
end

function ep3_forest_aveso_conv_handler:condition_hasCompletedTaskTwo(pPlayer, pNpc)
	return ((forestAvesoQuest2ScreenPlay:getStage(pPlayer) >= 2 or forestAvesoQuest2ScreenPlay:getRuns(pPlayer) > 0)  and   not (forestAvesoQuest2ScreenPlay:getRuns(pPlayer) > 0 and forestAvesoQuest2ScreenPlay:getStage(pPlayer) == 0))
end

function ep3_forest_aveso_conv_handler:condition_hasCompletedQuestTwo(pPlayer, pNpc)
	return (forestAvesoQuest2ScreenPlay:getRuns(pPlayer) > 0 and forestAvesoQuest2ScreenPlay:getStage(pPlayer) == 0)
end

function ep3_forest_aveso_conv_handler:condition_isTaskActiveThree(pPlayer, pNpc)
	return (forestAvesoQuest3ScreenPlay:getStage(pPlayer) == 1)  or  (forestAvesoQuest3ScreenPlay:getStage(pPlayer) >= 2 or forestAvesoQuest3ScreenPlay:getRuns(pPlayer) > 0)
end

function ep3_forest_aveso_conv_handler:condition_hasCompletedTaskThree(pPlayer, pNpc)
	return ((forestAvesoQuest3ScreenPlay:getStage(pPlayer) >= 2 or forestAvesoQuest3ScreenPlay:getRuns(pPlayer) > 0)  and   not (forestAvesoQuest3ScreenPlay:getRuns(pPlayer) > 0 and forestAvesoQuest3ScreenPlay:getStage(pPlayer) == 0))
end

function ep3_forest_aveso_conv_handler:condition_hasCompletedQuestThree(pPlayer, pNpc)
	return (forestAvesoQuest3ScreenPlay:getRuns(pPlayer) > 0 and forestAvesoQuest3ScreenPlay:getStage(pPlayer) == 0)
end

function ep3_forest_aveso_conv_handler:getInitialScreen(pPlayer, pNpc, pConvTemplate)
	local convoTemplate = LuaConversationTemplate(pConvTemplate)
	if (self:condition_hasCompletedQuestTwo(pPlayer, pNpc)) then
		return convoTemplate:getScreen("s_1173")
	elseif (self:condition_hasCompletedTaskTwo(pPlayer, pNpc)) then
		return convoTemplate:getScreen("s_1179")
	elseif (self:condition_isTaskActiveTwo(pPlayer, pNpc)) then
		return convoTemplate:getScreen("s_1193")
	elseif (self:condition_hasCompletedQuestOne(pPlayer, pNpc)) then
		return convoTemplate:getScreen("s_1195")
	elseif (self:condition_hasCompletedTaskOne(pPlayer, pNpc)) then
		return convoTemplate:getScreen("s_1213")
	elseif (self:condition_isTaskActiveOne(pPlayer, pNpc)) then
		return convoTemplate:getScreen("s_1223")
	elseif (self:condition_isTaskActiveInitial(pPlayer, pNpc)) then
		return convoTemplate:getScreen("s_1229")
	elseif (self:condition_isBadGuy(pPlayer, pNpc)) then
		return convoTemplate:getScreen("s_1271")
	elseif (self:condition_isGoodguy(pPlayer, pNpc)) then
		return convoTemplate:getScreen("s_1277")
	end
	return convoTemplate:getScreen("s_1283")
end

function ep3_forest_aveso_conv_handler:runScreenHandlers(pConvTemplate, pPlayer, pNpc, selectedOption, pConvScreen)
	local screen = LuaConversationScreen(pConvScreen)
	local screenID = screen:getScreenID()
	local pClonedScreen = screen:cloneScreen()
	local clonedConversation = LuaConversationScreen(pClonedScreen)

	if (self.screenAnimations ~= nil and self.screenAnimations[screenID] ~= nil and pNpc ~= nil) then
		CreatureObject(pNpc):doAnimation(self.screenAnimations[screenID])
	end

	if (screenID == "s_1183") then
		forestAvesoQuest2ScreenPlay:signalBoxes(pPlayer)
	elseif (screenID == "s_1207") then
		forestAvesoQuest2ScreenPlay:grantQuest(pPlayer)
	elseif (screenID == "s_1217") then
		forestAvesoQuest1ScreenPlay:signalMeat(pPlayer)
	elseif (screenID == "s_1233") then
		forestOutcastContactScreenPlay:signalContact(pPlayer)
	elseif (screenID == "s_1253") then
		forestOutcastContactScreenPlay:signalContact(pPlayer)
	elseif (screenID == "s_1245") then
		forestAvesoQuest1ScreenPlay:grantQuest(pPlayer)
	elseif (screenID == "s_1249") then
		forestAvesoQuest1ScreenPlay:grantQuest(pPlayer)
	elseif (screenID == "s_1265") then
		forestAvesoQuest1ScreenPlay:grantQuest(pPlayer)
	elseif (screenID == "s_1281") then
		forestOutcastAssassin2ScreenPlay:grantQuest(pPlayer)
	end

	return pClonedScreen
end
