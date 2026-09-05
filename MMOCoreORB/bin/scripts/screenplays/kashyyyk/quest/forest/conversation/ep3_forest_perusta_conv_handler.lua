-- Perusta (Shoartu Mystic) -- ep3_forest_perusta_quest_1, ep3_forest_perusta_quest_2, ep3_forest_kerritamba_epic_7, ep3_forest_wirartu_epic_2, ep3_forest_wirartu_epic_3
-- ruling 2026-09-04: "ensure kashyyyk is fully done"
-- getInitialScreen is live condition order. runScreenHandlers fires grant / signal / turn-in.
-- The journal engine lives on the journal branches. This arc does not call the Journal API.

ep3_forest_perusta_conv_handler = conv_handler:new {}

ep3_forest_perusta_conv_handler.screenAnimations = {
}

function ep3_forest_perusta_conv_handler:condition__defaultCondition(pPlayer, pNpc)
	return true
end

function ep3_forest_perusta_conv_handler:condition_isGoodGuy(pPlayer, pNpc)
	return ((forestWirartuEpic3ScreenPlay:getStage(pPlayer) == 1)  or  (forestWirartuEpic3ScreenPlay:getRuns(pPlayer) > 0 and forestWirartuEpic3ScreenPlay:getStage(pPlayer) == 0)  or  (forestKerritambaEpic7ScreenPlay:getRuns(pPlayer) > 0 and forestKerritambaEpic7ScreenPlay:getStage(pPlayer) == 0))
end

function ep3_forest_perusta_conv_handler:condition_isBadGuy(pPlayer, pNpc)
	return ((forestWirartuEpic2ScreenPlay:getStage(pPlayer) == 1)  or  (forestWirartuEpic2ScreenPlay:getRuns(pPlayer) > 0 and forestWirartuEpic2ScreenPlay:getStage(pPlayer) == 0))
end

function ep3_forest_perusta_conv_handler:condition_isTaskOneActive(pPlayer, pNpc)
	return (forestPerustaQuest1ScreenPlay:getStage(pPlayer) == 1)  or  (forestPerustaQuest1ScreenPlay:getStage(pPlayer) >= 2 or forestPerustaQuest1ScreenPlay:getRuns(pPlayer) > 0)
end

function ep3_forest_perusta_conv_handler:condition_hasCompletedTaskOne(pPlayer, pNpc)
	return ((forestPerustaQuest1ScreenPlay:getStage(pPlayer) >= 2 or forestPerustaQuest1ScreenPlay:getRuns(pPlayer) > 0)  and   not (forestPerustaQuest1ScreenPlay:getRuns(pPlayer) > 0 and forestPerustaQuest1ScreenPlay:getStage(pPlayer) == 0))
end

function ep3_forest_perusta_conv_handler:condition_hasCompletedQuestOne(pPlayer, pNpc)
	return (forestPerustaQuest1ScreenPlay:getRuns(pPlayer) > 0 and forestPerustaQuest1ScreenPlay:getStage(pPlayer) == 0)
end

function ep3_forest_perusta_conv_handler:condition_isTaskActiveTwo(pPlayer, pNpc)
	return (forestPerustaQuest2ScreenPlay:getStage(pPlayer) == 1)  or  (forestPerustaQuest2ScreenPlay:getStage(pPlayer) >= 2 or forestPerustaQuest2ScreenPlay:getRuns(pPlayer) > 0)
end

function ep3_forest_perusta_conv_handler:condition_hasCompletedTaskTwo(pPlayer, pNpc)
	return ((forestPerustaQuest2ScreenPlay:getStage(pPlayer) >= 2 or forestPerustaQuest2ScreenPlay:getRuns(pPlayer) > 0)  and   not (forestPerustaQuest2ScreenPlay:getRuns(pPlayer) > 0 and forestPerustaQuest2ScreenPlay:getStage(pPlayer) == 0))
end

function ep3_forest_perusta_conv_handler:condition_hasCompletedQuestTwo(pPlayer, pNpc)
	return (forestPerustaQuest2ScreenPlay:getRuns(pPlayer) > 0 and forestPerustaQuest2ScreenPlay:getStage(pPlayer) == 0)
end

function ep3_forest_perusta_conv_handler:condition_hasLanguage(pPlayer, pNpc)
	return (not CreatureObject(pPlayer):hasSkill("social_language_wookiee_comprehend"))
end

function ep3_forest_perusta_conv_handler:getInitialScreen(pPlayer, pNpc, pConvTemplate)
	local convoTemplate = LuaConversationTemplate(pConvTemplate)
	if (self:condition_hasLanguage(pPlayer, pNpc)) then
		return convoTemplate:getScreen("s_1676")
	elseif (self:condition_hasCompletedQuestTwo(pPlayer, pNpc)) then
		return convoTemplate:getScreen("s_2768")
	elseif (self:condition_hasCompletedTaskTwo(pPlayer, pNpc)) then
		return convoTemplate:getScreen("s_2774")
	elseif (self:condition_isTaskActiveTwo(pPlayer, pNpc)) then
		return convoTemplate:getScreen("s_2780")
	elseif (self:condition_hasCompletedQuestOne(pPlayer, pNpc)) then
		return convoTemplate:getScreen("s_2786")
	elseif (self:condition_hasCompletedTaskOne(pPlayer, pNpc)) then
		return convoTemplate:getScreen("s_2796")
	elseif (self:condition_isTaskOneActive(pPlayer, pNpc)) then
		return convoTemplate:getScreen("s_2802")
	elseif (self:condition_isGoodGuy(pPlayer, pNpc)) then
		return convoTemplate:getScreen("s_2812")
	elseif (self:condition_isBadGuy(pPlayer, pNpc)) then
		return convoTemplate:getScreen("s_2834")
	end
	return convoTemplate:getScreen("s_2836")
end

function ep3_forest_perusta_conv_handler:runScreenHandlers(pConvTemplate, pPlayer, pNpc, selectedOption, pConvScreen)
	local screen = LuaConversationScreen(pConvScreen)
	local screenID = screen:getScreenID()
	local pClonedScreen = screen:cloneScreen()
	local clonedConversation = LuaConversationScreen(pClonedScreen)

	if (self.screenAnimations ~= nil and self.screenAnimations[screenID] ~= nil and pNpc ~= nil) then
		CreatureObject(pNpc):doAnimation(self.screenAnimations[screenID])
	end

	if (screenID == "s_2778") then
		forestPerustaQuest2ScreenPlay:signalMysess(pPlayer)
	elseif (screenID == "s_2790") then
		forestPerustaQuest2ScreenPlay:grantQuest(pPlayer)
	elseif (screenID == "s_2800") then
		forestPerustaQuest1ScreenPlay:signalMoss(pPlayer)
	elseif (screenID == "s_2828") then
		forestPerustaQuest1ScreenPlay:grantQuest(pPlayer)
	end

	return pClonedScreen
end
