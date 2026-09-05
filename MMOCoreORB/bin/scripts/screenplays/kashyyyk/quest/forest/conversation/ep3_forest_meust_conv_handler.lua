-- Meust (Shoartu Mystic) -- ep3_forest_meust_quest_1, ep3_forest_meust_quest_2, ep3_forest_meust_quest_3, ep3_forest_kerritamba_epic_7, ep3_forest_wirartu_epic_2, ep3_forest_wirartu_epic_3
-- ruling 2026-09-04: "ensure kashyyyk is fully done"
-- getInitialScreen is live condition order. runScreenHandlers fires grant / signal / turn-in.
-- The journal engine lives on the journal branches. This arc does not call the Journal API.

ep3_forest_meust_conv_handler = conv_handler:new {}

ep3_forest_meust_conv_handler.screenAnimations = {
}

function ep3_forest_meust_conv_handler:condition__defaultCondition(pPlayer, pNpc)
	return true
end

function ep3_forest_meust_conv_handler:condition_isGoodGuy(pPlayer, pNpc)
	return ((forestWirartuEpic3ScreenPlay:getStage(pPlayer) == 1)  or  (forestWirartuEpic3ScreenPlay:getRuns(pPlayer) > 0 and forestWirartuEpic3ScreenPlay:getStage(pPlayer) == 0)  or  (forestKerritambaEpic7ScreenPlay:getRuns(pPlayer) > 0 and forestKerritambaEpic7ScreenPlay:getStage(pPlayer) == 0))
end

function ep3_forest_meust_conv_handler:condition_isBadGuy(pPlayer, pNpc)
	return ((forestWirartuEpic2ScreenPlay:getStage(pPlayer) == 1)  or  (forestWirartuEpic2ScreenPlay:getRuns(pPlayer) > 0 and forestWirartuEpic2ScreenPlay:getStage(pPlayer) == 0))
end

function ep3_forest_meust_conv_handler:condition_isTaskOneActive(pPlayer, pNpc)
	return (forestMeustQuest1ScreenPlay:getStage(pPlayer) == 1)  or  (forestMeustQuest1ScreenPlay:getStage(pPlayer) >= 2 or forestMeustQuest1ScreenPlay:getRuns(pPlayer) > 0)
end

function ep3_forest_meust_conv_handler:condition_hasCompletedTaskOne(pPlayer, pNpc)
	return ((forestMeustQuest1ScreenPlay:getStage(pPlayer) >= 2 or forestMeustQuest1ScreenPlay:getRuns(pPlayer) > 0)  and   not (forestMeustQuest1ScreenPlay:getRuns(pPlayer) > 0 and forestMeustQuest1ScreenPlay:getStage(pPlayer) == 0))
end

function ep3_forest_meust_conv_handler:condition_hasCompletedQuestOne(pPlayer, pNpc)
	return (forestMeustQuest1ScreenPlay:getRuns(pPlayer) > 0 and forestMeustQuest1ScreenPlay:getStage(pPlayer) == 0)
end

function ep3_forest_meust_conv_handler:condition_isTaskTwoActive(pPlayer, pNpc)
	return (forestMeustQuest2ScreenPlay:getStage(pPlayer) == 1)  or  (forestMeustQuest2ScreenPlay:getStage(pPlayer) >= 2 or forestMeustQuest2ScreenPlay:getRuns(pPlayer) > 0)
end

function ep3_forest_meust_conv_handler:condition_hasCompletedTaskTwo(pPlayer, pNpc)
	return ((forestMeustQuest2ScreenPlay:getStage(pPlayer) >= 2 or forestMeustQuest2ScreenPlay:getRuns(pPlayer) > 0)  and   not (forestMeustQuest2ScreenPlay:getRuns(pPlayer) > 0 and forestMeustQuest2ScreenPlay:getStage(pPlayer) == 0))
end

function ep3_forest_meust_conv_handler:condition_hasCompletedQuestTwo(pPlayer, pNpc)
	return (forestMeustQuest2ScreenPlay:getRuns(pPlayer) > 0 and forestMeustQuest2ScreenPlay:getStage(pPlayer) == 0)
end

function ep3_forest_meust_conv_handler:condition_isTaskThreeActive(pPlayer, pNpc)
	return (forestMeustQuest3ScreenPlay:getStage(pPlayer) == 1)  or  (forestMeustQuest3ScreenPlay:getStage(pPlayer) >= 2 or forestMeustQuest3ScreenPlay:getRuns(pPlayer) > 0)
end

function ep3_forest_meust_conv_handler:condition_hasCompletedTaskThree(pPlayer, pNpc)
	return ((forestMeustQuest3ScreenPlay:getStage(pPlayer) >= 2 or forestMeustQuest3ScreenPlay:getRuns(pPlayer) > 0)  and   not (forestMeustQuest3ScreenPlay:getRuns(pPlayer) > 0 and forestMeustQuest3ScreenPlay:getStage(pPlayer) == 0))
end

function ep3_forest_meust_conv_handler:condition_hasCompletedQuestThree(pPlayer, pNpc)
	return (forestMeustQuest3ScreenPlay:getRuns(pPlayer) > 0 and forestMeustQuest3ScreenPlay:getStage(pPlayer) == 0)
end

function ep3_forest_meust_conv_handler:condition_hasLanguage(pPlayer, pNpc)
	return (not CreatureObject(pPlayer):hasSkill("social_language_wookiee_comprehend"))
end

function ep3_forest_meust_conv_handler:getInitialScreen(pPlayer, pNpc, pConvTemplate)
	local convoTemplate = LuaConversationTemplate(pConvTemplate)
	if (self:condition_hasLanguage(pPlayer, pNpc)) then
		return convoTemplate:getScreen("s_1619")
	elseif (self:condition_hasCompletedQuestThree(pPlayer, pNpc)) then
		return convoTemplate:getScreen("s_2030")
	elseif (self:condition_hasCompletedTaskThree(pPlayer, pNpc)) then
		return convoTemplate:getScreen("s_2036")
	elseif (self:condition_isTaskThreeActive(pPlayer, pNpc)) then
		return convoTemplate:getScreen("s_2046")
	elseif (self:condition_hasCompletedQuestTwo(pPlayer, pNpc)) then
		return convoTemplate:getScreen("s_2052")
	elseif (self:condition_hasCompletedTaskTwo(pPlayer, pNpc)) then
		return convoTemplate:getScreen("s_2066")
	elseif (self:condition_isTaskTwoActive(pPlayer, pNpc)) then
		return convoTemplate:getScreen("s_2076")
	elseif (self:condition_hasCompletedQuestOne(pPlayer, pNpc)) then
		return convoTemplate:getScreen("s_2078")
	elseif (self:condition_hasCompletedTaskOne(pPlayer, pNpc)) then
		return convoTemplate:getScreen("s_2088")
	elseif (self:condition_isTaskOneActive(pPlayer, pNpc)) then
		return convoTemplate:getScreen("s_2094")
	elseif (self:condition_isGoodGuy(pPlayer, pNpc)) then
		return convoTemplate:getScreen("s_2104")
	elseif (self:condition_isBadGuy(pPlayer, pNpc)) then
		return convoTemplate:getScreen("s_2134")
	end
	return convoTemplate:getScreen("s_2136")
end

function ep3_forest_meust_conv_handler:runScreenHandlers(pConvTemplate, pPlayer, pNpc, selectedOption, pConvScreen)
	local screen = LuaConversationScreen(pConvScreen)
	local screenID = screen:getScreenID()
	local pClonedScreen = screen:cloneScreen()
	local clonedConversation = LuaConversationScreen(pClonedScreen)

	if (self.screenAnimations ~= nil and self.screenAnimations[screenID] ~= nil and pNpc ~= nil) then
		CreatureObject(pNpc):doAnimation(self.screenAnimations[screenID])
	end

	if (screenID == "s_2040") then
		forestKerritambaEpic4ScreenPlay:signalSayormi(pPlayer)
		forestMeustQuest3ScreenPlay:signalSayormi(pPlayer)
	elseif (screenID == "s_2060") then
		forestMeustQuest3ScreenPlay:grantQuest(pPlayer)
	elseif (screenID == "s_2070") then
		forestMeustQuest2ScreenPlay:signalSteelhoof(pPlayer)
	elseif (screenID == "s_2082") then
		forestMeustQuest2ScreenPlay:grantQuest(pPlayer)
	elseif (screenID == "s_2092") then
		forestMeustQuest1ScreenPlay:signalMouf(pPlayer)
	elseif (screenID == "s_2124") then
		forestMeustQuest1ScreenPlay:grantQuest(pPlayer)
	end

	return pClonedScreen
end
