-- Athnalu (Shoartu Mystic) -- ep3_forest_athnalu_quest_1, ep3_forest_athnalu_quest_2, ep3_forest_kerritamba_epic_7, ep3_forest_wirartu_epic_2, ep3_forest_wirartu_epic_3
-- ruling 2026-09-04: "ensure kashyyyk is fully done"
-- getInitialScreen is live condition order. runScreenHandlers fires grant / signal / turn-in.
-- The journal engine lives on the journal branches. This arc does not call the Journal API.

ep3_forest_athnalu_conv_handler = conv_handler:new {}

ep3_forest_athnalu_conv_handler.screenAnimations = {
}

function ep3_forest_athnalu_conv_handler:condition__defaultCondition(pPlayer, pNpc)
	return true
end

function ep3_forest_athnalu_conv_handler:condition_isGoodGuy(pPlayer, pNpc)
	return ((forestWirartuEpic3ScreenPlay:getStage(pPlayer) == 1)  or  (forestWirartuEpic3ScreenPlay:getRuns(pPlayer) > 0 and forestWirartuEpic3ScreenPlay:getStage(pPlayer) == 0)  or  (forestKerritambaEpic7ScreenPlay:getRuns(pPlayer) > 0 and forestKerritambaEpic7ScreenPlay:getStage(pPlayer) == 0))
end

function ep3_forest_athnalu_conv_handler:condition_isBadGuy(pPlayer, pNpc)
	return ((forestWirartuEpic2ScreenPlay:getStage(pPlayer) == 1)  or  (forestWirartuEpic2ScreenPlay:getRuns(pPlayer) > 0 and forestWirartuEpic2ScreenPlay:getStage(pPlayer) == 0))
end

function ep3_forest_athnalu_conv_handler:condition_isTaskOneActive(pPlayer, pNpc)
	return (forestAthnaluQuest1ScreenPlay:getStage(pPlayer) == 1)
end

function ep3_forest_athnalu_conv_handler:condition_hasCompletedTaskOne(pPlayer, pNpc)
	return (forestAthnaluQuest1ScreenPlay:getStage(pPlayer) == 2)
end

function ep3_forest_athnalu_conv_handler:condition_hasCompletedQuestOne(pPlayer, pNpc)
	return (forestAthnaluQuest1ScreenPlay:getRuns(pPlayer) > 0 and forestAthnaluQuest1ScreenPlay:getStage(pPlayer) == 0)
end

function ep3_forest_athnalu_conv_handler:condition_isTaskActiveTwo(pPlayer, pNpc)
	return (forestAthnaluQuest2ScreenPlay:getStage(pPlayer) == 1)
end

function ep3_forest_athnalu_conv_handler:condition_hasCompletedTaskTwo(pPlayer, pNpc)
	return (forestAthnaluQuest2ScreenPlay:getStage(pPlayer) == 2)
end

function ep3_forest_athnalu_conv_handler:condition_hasCompletedQuestTwo(pPlayer, pNpc)
	return (forestAthnaluQuest2ScreenPlay:getRuns(pPlayer) > 0 and forestAthnaluQuest2ScreenPlay:getStage(pPlayer) == 0)
end

function ep3_forest_athnalu_conv_handler:condition_hasLanguage(pPlayer, pNpc)
	return (not CreatureObject(pPlayer):hasSkill("social_language_wookiee_comprehend"))
end

function ep3_forest_athnalu_conv_handler:getInitialScreen(pPlayer, pNpc, pConvTemplate)
	local convoTemplate = LuaConversationTemplate(pConvTemplate)
	if (self:condition_hasLanguage(pPlayer, pNpc)) then
		return convoTemplate:getScreen("s_1136")
	elseif (self:condition_hasCompletedQuestTwo(pPlayer, pNpc)) then
		return convoTemplate:getScreen("s_4176")
	elseif (self:condition_hasCompletedTaskTwo(pPlayer, pNpc)) then
		return convoTemplate:getScreen("s_4178")
	elseif (self:condition_isTaskActiveTwo(pPlayer, pNpc)) then
		return convoTemplate:getScreen("s_4184")
	elseif (self:condition_hasCompletedQuestOne(pPlayer, pNpc)) then
		return convoTemplate:getScreen("s_4186")
	elseif (self:condition_hasCompletedTaskOne(pPlayer, pNpc)) then
		return convoTemplate:getScreen("s_4200")
	elseif (self:condition_isTaskOneActive(pPlayer, pNpc)) then
		return convoTemplate:getScreen("s_4210")
	elseif (self:condition_isGoodGuy(pPlayer, pNpc)) then
		return convoTemplate:getScreen("s_4216")
	elseif (self:condition_isBadGuy(pPlayer, pNpc)) then
		return convoTemplate:getScreen("s_4238")
	end
	return convoTemplate:getScreen("s_4240")
end

function ep3_forest_athnalu_conv_handler:runScreenHandlers(pConvTemplate, pPlayer, pNpc, selectedOption, pConvScreen)
	local screen = LuaConversationScreen(pConvScreen)
	local screenID = screen:getScreenID()
	local pClonedScreen = screen:cloneScreen()
	local clonedConversation = LuaConversationScreen(pClonedScreen)

	if (self.screenAnimations ~= nil and self.screenAnimations[screenID] ~= nil and pNpc ~= nil) then
		CreatureObject(pNpc):doAnimation(self.screenAnimations[screenID])
	end

	if (screenID == "s_4182") then
		forestAthnaluQuest2ScreenPlay:signalSnakes(pPlayer)
	elseif (screenID == "s_4194") then
		forestAthnaluQuest2ScreenPlay:grantQuest(pPlayer)
	elseif (screenID == "s_4204") then
		forestAthnaluQuest1ScreenPlay:signalDolls(pPlayer)
	elseif (screenID == "s_4228") then
		forestAthnaluQuest1ScreenPlay:grantQuest(pPlayer)
	end

	return pClonedScreen
end
