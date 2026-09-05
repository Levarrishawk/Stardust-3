-- Ardon -- ep3_forest_ardon_quest_1, ep3_forest_ardon_quest_2, ep3_forest_ardon_quest_3, ep3_forest_ardon_assassin, ep3_forest_athnalu_quest_2, ep3_forest_meust_quest_3, ep3_forest_perusta_quest_2, ep3_forest_kerritamba_epic_7, ep3_forest_wirartu_epic_2, ep3_forest_wirartu_epic_3
-- ruling 2026-09-04: "ensure kashyyyk is fully done"
-- getInitialScreen is live condition order. runScreenHandlers fires grant / signal / turn-in.
-- The journal engine lives on the journal branches. This arc does not call the Journal API.

ep3_forest_kerritamba_epic_conv_handler = conv_handler:new {}

ep3_forest_kerritamba_epic_conv_handler.screenAnimations = {
}

function ep3_forest_kerritamba_epic_conv_handler:condition__defaultCondition(pPlayer, pNpc)
	return true
end

function ep3_forest_kerritamba_epic_conv_handler:condition_isBadGuy(pPlayer, pNpc)
	return ((forestWirartuEpic2ScreenPlay:getStage(pPlayer) == 1)  or  (forestWirartuEpic2ScreenPlay:getRuns(pPlayer) > 0 and forestWirartuEpic2ScreenPlay:getStage(pPlayer) == 0))
end

function ep3_forest_kerritamba_epic_conv_handler:condition_isGoodGuy(pPlayer, pNpc)
	return ((forestWirartuEpic3ScreenPlay:getStage(pPlayer) == 1)  or  (forestWirartuEpic3ScreenPlay:getRuns(pPlayer) > 0 and forestWirartuEpic3ScreenPlay:getStage(pPlayer) == 0)  or  (forestKerritambaEpic7ScreenPlay:getRuns(pPlayer) > 0 and forestKerritambaEpic7ScreenPlay:getStage(pPlayer) == 0))
end

function ep3_forest_kerritamba_epic_conv_handler:condition_hasCompletedInitial(pPlayer, pNpc)
	return ((forestMeustQuest3ScreenPlay:getRuns(pPlayer) > 0 and forestMeustQuest3ScreenPlay:getStage(pPlayer) == 0)  and  (forestPerustaQuest2ScreenPlay:getRuns(pPlayer) > 0 and forestPerustaQuest2ScreenPlay:getStage(pPlayer) == 0)  and  (forestAthnaluQuest2ScreenPlay:getRuns(pPlayer) > 0 and forestAthnaluQuest2ScreenPlay:getStage(pPlayer) == 0))
end

function ep3_forest_kerritamba_epic_conv_handler:condition_isTaskActiveOne(pPlayer, pNpc)
	return (forestArdonQuest1ScreenPlay:getStage(pPlayer) == 1)  or  (forestArdonQuest1ScreenPlay:getStage(pPlayer) >= 2 or forestArdonQuest1ScreenPlay:getRuns(pPlayer) > 0)
end

function ep3_forest_kerritamba_epic_conv_handler:condition_hasCompletedTaskOne(pPlayer, pNpc)
	return ((forestArdonQuest1ScreenPlay:getStage(pPlayer) >= 2 or forestArdonQuest1ScreenPlay:getRuns(pPlayer) > 0)  and   not (forestArdonQuest1ScreenPlay:getRuns(pPlayer) > 0 and forestArdonQuest1ScreenPlay:getStage(pPlayer) == 0))
end

function ep3_forest_kerritamba_epic_conv_handler:condition_hasCompletedQuestOne(pPlayer, pNpc)
	return (forestArdonQuest1ScreenPlay:getRuns(pPlayer) > 0 and forestArdonQuest1ScreenPlay:getStage(pPlayer) == 0)
end

function ep3_forest_kerritamba_epic_conv_handler:condition_isTaskActiveTwo(pPlayer, pNpc)
	return (forestArdonQuest2ScreenPlay:getStage(pPlayer) == 1)  or  (forestArdonQuest2ScreenPlay:getStage(pPlayer) >= 2 or forestArdonQuest2ScreenPlay:getRuns(pPlayer) > 0)
end

function ep3_forest_kerritamba_epic_conv_handler:condition_hasCompletedTaskTwo(pPlayer, pNpc)
	return ((forestArdonQuest2ScreenPlay:getStage(pPlayer) >= 2 or forestArdonQuest2ScreenPlay:getRuns(pPlayer) > 0)  and   not (forestArdonQuest2ScreenPlay:getRuns(pPlayer) > 0 and forestArdonQuest2ScreenPlay:getStage(pPlayer) == 0))
end

function ep3_forest_kerritamba_epic_conv_handler:condition_hasCompletedQuestTwo(pPlayer, pNpc)
	return (forestArdonQuest2ScreenPlay:getRuns(pPlayer) > 0 and forestArdonQuest2ScreenPlay:getStage(pPlayer) == 0)
end

function ep3_forest_kerritamba_epic_conv_handler:condition_isTaskActiveThree(pPlayer, pNpc)
	return (forestArdonQuest3ScreenPlay:getStage(pPlayer) == 1)  or  (forestArdonQuest3ScreenPlay:getStage(pPlayer) >= 2 or forestArdonQuest3ScreenPlay:getRuns(pPlayer) > 0)
end

function ep3_forest_kerritamba_epic_conv_handler:condition_hasCompletedTaskThree(pPlayer, pNpc)
	return ((forestArdonQuest3ScreenPlay:getStage(pPlayer) >= 2 or forestArdonQuest3ScreenPlay:getRuns(pPlayer) > 0)  and   not (forestArdonQuest3ScreenPlay:getRuns(pPlayer) > 0 and forestArdonQuest3ScreenPlay:getStage(pPlayer) == 0))
end

function ep3_forest_kerritamba_epic_conv_handler:condition_hasCompletedQuestThree(pPlayer, pNpc)
	return (forestArdonQuest3ScreenPlay:getRuns(pPlayer) > 0 and forestArdonQuest3ScreenPlay:getStage(pPlayer) == 0)
end

function ep3_forest_kerritamba_epic_conv_handler:condition_hasCompletedAll(pPlayer, pNpc)
	-- OPEN: badge.hasBadge bdg_kash_kerritamba (no Core3 badge for this arc)
	return false
end

function ep3_forest_kerritamba_epic_conv_handler:condition_temp(pPlayer, pNpc)
	return (false  and   not false)
end

function ep3_forest_kerritamba_epic_conv_handler:getInitialScreen(pPlayer, pNpc, pConvTemplate)
	local convoTemplate = LuaConversationTemplate(pConvTemplate)
	if (self:condition_hasCompletedAll(pPlayer, pNpc)) then
		return convoTemplate:getScreen("s_1520")
	elseif (self:condition_hasCompletedQuestTwo(pPlayer, pNpc)) then
		return convoTemplate:getScreen("s_1526")
	elseif (self:condition_hasCompletedTaskTwo(pPlayer, pNpc)) then
		return convoTemplate:getScreen("s_1532")
	elseif (self:condition_isTaskActiveTwo(pPlayer, pNpc)) then
		return convoTemplate:getScreen("s_1542")
	elseif (self:condition_hasCompletedQuestOne(pPlayer, pNpc)) then
		return convoTemplate:getScreen("s_1548")
	elseif (self:condition_hasCompletedTaskOne(pPlayer, pNpc)) then
		return convoTemplate:getScreen("s_1566")
	elseif (self:condition_isTaskActiveOne(pPlayer, pNpc)) then
		return convoTemplate:getScreen("s_1576")
	elseif (self:condition_hasCompletedInitial(pPlayer, pNpc)) then
		return convoTemplate:getScreen("s_1582")
	elseif (self:condition_isGoodGuy(pPlayer, pNpc)) then
		return convoTemplate:getScreen("s_1608")
	elseif (self:condition_isBadGuy(pPlayer, pNpc)) then
		return convoTemplate:getScreen("s_1610")
	end
	return convoTemplate:getScreen("s_1616")
end

function ep3_forest_kerritamba_epic_conv_handler:runScreenHandlers(pConvTemplate, pPlayer, pNpc, selectedOption, pConvScreen)
	local screen = LuaConversationScreen(pConvScreen)
	local screenID = screen:getScreenID()
	local pClonedScreen = screen:cloneScreen()
	local clonedConversation = LuaConversationScreen(pClonedScreen)

	if (self.screenAnimations ~= nil and self.screenAnimations[screenID] ~= nil and pNpc ~= nil) then
		CreatureObject(pNpc):doAnimation(self.screenAnimations[screenID])
	end

	if (screenID == "s_1530") then
		-- OPEN: badge.grantBadge (no Core3 badge for this arc)
	elseif (screenID == "s_1536") then
		forestArdonQuest2ScreenPlay:signalExemplar(pPlayer)
	elseif (screenID == "s_1560") then
		forestArdonQuest2ScreenPlay:grantQuest(pPlayer)
	elseif (screenID == "s_1570") then
		forestArdonQuest1ScreenPlay:signalOutcasts(pPlayer)
	elseif (screenID == "s_1606") then
		forestArdonQuest1ScreenPlay:grantQuest(pPlayer)
	elseif (screenID == "s_1614") then
		forestArdonAssassinScreenPlay:grantQuest(pPlayer)
	end

	return pClonedScreen
end
