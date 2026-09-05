-- Dahlia -- ep3_forest_dahlia_epic_1, ep3_forest_dahlia_epic_2, ep3_forest_dahlia_epic_3, ep3_forest_dahlia_epic_4, ep3_forest_aveso_quest_2, ep3_forest_cryl_quest_2, ep3_forest_rhiek_quest_3, ep3_forest_kerritamba_epic_7, ep3_forest_outcast_assassin_2, ep3_forest_wirartu_epic_2, ep3_forest_wirartu_epic_3
-- ruling 2026-09-04: "ensure kashyyyk is fully done"
-- getInitialScreen is live condition order. runScreenHandlers fires grant / signal / turn-in.
-- The journal engine lives on the journal branches. This arc does not call the Journal API.

ep3_forest_dahlia_conv_handler = conv_handler:new {}

ep3_forest_dahlia_conv_handler.screenAnimations = {
}

function ep3_forest_dahlia_conv_handler:condition__defaultCondition(pPlayer, pNpc)
	return true
end

function ep3_forest_dahlia_conv_handler:condition_isGoodGuy(pPlayer, pNpc)
	return ((forestWirartuEpic3ScreenPlay:getStage(pPlayer) == 1)  or  (forestWirartuEpic3ScreenPlay:getRuns(pPlayer) > 0 and forestWirartuEpic3ScreenPlay:getStage(pPlayer) == 0)  or  (forestKerritambaEpic7ScreenPlay:getRuns(pPlayer) > 0 and forestKerritambaEpic7ScreenPlay:getStage(pPlayer) == 0))
end

function ep3_forest_dahlia_conv_handler:condition_isBadGuy(pPlayer, pNpc)
	return ((forestWirartuEpic2ScreenPlay:getStage(pPlayer) == 1)  or  (forestWirartuEpic2ScreenPlay:getRuns(pPlayer) > 0 and forestWirartuEpic2ScreenPlay:getStage(pPlayer) == 0))
end

function ep3_forest_dahlia_conv_handler:condition_hasCompletedInitial(pPlayer, pNpc)
	return ((forestAvesoQuest2ScreenPlay:getRuns(pPlayer) > 0 and forestAvesoQuest2ScreenPlay:getStage(pPlayer) == 0)  and  (forestCrylQuest2ScreenPlay:getRuns(pPlayer) > 0 and forestCrylQuest2ScreenPlay:getStage(pPlayer) == 0)  and  (forestRhiekQuest3ScreenPlay:getRuns(pPlayer) > 0 and forestRhiekQuest3ScreenPlay:getStage(pPlayer) == 0))
end

function ep3_forest_dahlia_conv_handler:condition_isFemale(pPlayer, pNpc)
	return ((CreatureObject(pPlayer):getGender() ~= 0))
end

function ep3_forest_dahlia_conv_handler:condition_isMale(pPlayer, pNpc)
	return ((CreatureObject(pPlayer):getGender() == 0))
end

function ep3_forest_dahlia_conv_handler:condition_isTaskActiveOne(pPlayer, pNpc)
	return (forestDahliaEpic1ScreenPlay:getStage(pPlayer) == 1)  or  (forestDahliaEpic1ScreenPlay:getStage(pPlayer) >= 2 or forestDahliaEpic1ScreenPlay:getRuns(pPlayer) > 0)
end

function ep3_forest_dahlia_conv_handler:condition_hasCompletedTaskOne(pPlayer, pNpc)
	return ((forestDahliaEpic1ScreenPlay:getStage(pPlayer) >= 2 or forestDahliaEpic1ScreenPlay:getRuns(pPlayer) > 0)  and   not (forestDahliaEpic1ScreenPlay:getRuns(pPlayer) > 0 and forestDahliaEpic1ScreenPlay:getStage(pPlayer) == 0))
end

function ep3_forest_dahlia_conv_handler:condition_hasCompletedQuestOne(pPlayer, pNpc)
	return (forestDahliaEpic1ScreenPlay:getRuns(pPlayer) > 0 and forestDahliaEpic1ScreenPlay:getStage(pPlayer) == 0)
end

function ep3_forest_dahlia_conv_handler:condition_isTaskActiveTwo(pPlayer, pNpc)
	return (forestDahliaEpic2ScreenPlay:getStage(pPlayer) == 1)  or  (forestDahliaEpic2ScreenPlay:getStage(pPlayer) >= 2 or forestDahliaEpic2ScreenPlay:getRuns(pPlayer) > 0)
end

function ep3_forest_dahlia_conv_handler:condition_hasCompletedTaskTwo(pPlayer, pNpc)
	return ((forestDahliaEpic2ScreenPlay:getStage(pPlayer) >= 2 or forestDahliaEpic2ScreenPlay:getRuns(pPlayer) > 0)  and   not (forestDahliaEpic2ScreenPlay:getRuns(pPlayer) > 0 and forestDahliaEpic2ScreenPlay:getStage(pPlayer) == 0))
end

function ep3_forest_dahlia_conv_handler:condition_hasCompletedQuestTwo(pPlayer, pNpc)
	return (forestDahliaEpic2ScreenPlay:getRuns(pPlayer) > 0 and forestDahliaEpic2ScreenPlay:getStage(pPlayer) == 0)
end

function ep3_forest_dahlia_conv_handler:condition_isTaskActiveThree(pPlayer, pNpc)
	return (forestDahliaEpic4ScreenPlay:getStage(pPlayer) == 1)  or  (forestDahliaEpic4ScreenPlay:getStage(pPlayer) >= 2 or forestDahliaEpic4ScreenPlay:getRuns(pPlayer) > 0)
end

function ep3_forest_dahlia_conv_handler:condition_hasCompletedTaskThree(pPlayer, pNpc)
	return ((forestDahliaEpic4ScreenPlay:getStage(pPlayer) >= 2 or forestDahliaEpic4ScreenPlay:getRuns(pPlayer) > 0)  and   not (forestDahliaEpic4ScreenPlay:getRuns(pPlayer) > 0 and forestDahliaEpic4ScreenPlay:getStage(pPlayer) == 0))
end

function ep3_forest_dahlia_conv_handler:condition_hasCompletedQuestThree(pPlayer, pNpc)
	return (forestDahliaEpic4ScreenPlay:getRuns(pPlayer) > 0 and forestDahliaEpic4ScreenPlay:getStage(pPlayer) == 0)
end

function ep3_forest_dahlia_conv_handler:condition_isTaskStillActive(pPlayer, pNpc)
	return (forestDahliaEpic3ScreenPlay:getStage(pPlayer) == 1)  or  (forestDahliaEpic3ScreenPlay:getStage(pPlayer) >= 1 or forestDahliaEpic3ScreenPlay:getRuns(pPlayer) > 0)
end

function ep3_forest_dahlia_conv_handler:getInitialScreen(pPlayer, pNpc, pConvTemplate)
	local convoTemplate = LuaConversationTemplate(pConvTemplate)
	if (self:condition_hasCompletedQuestThree(pPlayer, pNpc)) then
		return convoTemplate:getScreen("s_3134")
	elseif (self:condition_hasCompletedTaskThree(pPlayer, pNpc)) then
		return convoTemplate:getScreen("s_3140")
	elseif (self:condition_isTaskActiveThree(pPlayer, pNpc)) then
		return convoTemplate:getScreen("s_3182")
	elseif (self:condition_isTaskStillActive(pPlayer, pNpc)) then
		return convoTemplate:getScreen("s_3184")
	elseif (self:condition_hasCompletedQuestTwo(pPlayer, pNpc)) then
		return convoTemplate:getScreen("s_3186")
	elseif (self:condition_hasCompletedTaskTwo(pPlayer, pNpc)) then
		return convoTemplate:getScreen("s_3244")
	elseif (self:condition_isTaskActiveTwo(pPlayer, pNpc)) then
		return convoTemplate:getScreen("s_3270")
	elseif (self:condition_hasCompletedQuestOne(pPlayer, pNpc)) then
		return convoTemplate:getScreen("s_3276")
	elseif (self:condition_hasCompletedTaskOne(pPlayer, pNpc)) then
		return convoTemplate:getScreen("s_3342")
	elseif (self:condition_isTaskActiveOne(pPlayer, pNpc)) then
		return convoTemplate:getScreen("s_3368")
	elseif (self:condition_hasCompletedInitial(pPlayer, pNpc)) then
		return convoTemplate:getScreen("s_3374")
	elseif (self:condition_isBadGuy(pPlayer, pNpc)) then
		return convoTemplate:getScreen("s_3452")
	elseif (self:condition_isGoodGuy(pPlayer, pNpc)) then
		return convoTemplate:getScreen("s_3458")
	end
	return convoTemplate:getScreen("s_3460")
end

function ep3_forest_dahlia_conv_handler:runScreenHandlers(pConvTemplate, pPlayer, pNpc, selectedOption, pConvScreen)
	local screen = LuaConversationScreen(pConvScreen)
	local screenID = screen:getScreenID()
	local pClonedScreen = screen:cloneScreen()
	local clonedConversation = LuaConversationScreen(pClonedScreen)

	if (self.screenAnimations ~= nil and self.screenAnimations[screenID] ~= nil and pNpc ~= nil) then
		CreatureObject(pNpc):doAnimation(self.screenAnimations[screenID])
	end

	if (screenID == "s_3144") then
		forestDahliaEpic4ScreenPlay:signalWin(pPlayer)
		-- OPEN: badge.grantBadge (no Core3 badge for this arc)
	elseif (screenID == "s_3160") then
		forestDahliaEpic4ScreenPlay:signalWin(pPlayer)
		-- OPEN: badge.grantBadge (no Core3 badge for this arc)
	elseif (screenID == "s_3180") then
		forestDahliaEpic4ScreenPlay:signalWin(pPlayer)
		-- OPEN: badge.grantBadge (no Core3 badge for this arc)
	elseif (screenID == "s_3194") then
		forestDahliaEpic3ScreenPlay:grantQuest(pPlayer)
	elseif (screenID == "s_3214") then
		forestDahliaEpic3ScreenPlay:grantQuest(pPlayer)
	elseif (screenID == "s_3230") then
		forestDahliaEpic3ScreenPlay:grantQuest(pPlayer)
	elseif (screenID == "s_3234") then
	elseif (screenID == "s_3248") then
		forestDahliaEpic2ScreenPlay:signalWar(pPlayer)
	elseif (screenID == "s_3256") then
		forestDahliaEpic2ScreenPlay:signalWar(pPlayer)
	elseif (screenID == "s_3264") then
		forestDahliaEpic2ScreenPlay:signalWar(pPlayer)
	elseif (screenID == "s_3316") then
	elseif (screenID == "s_3288") then
		forestDahliaEpic2ScreenPlay:grantQuest(pPlayer)
	elseif (screenID == "s_3312") then
		forestDahliaEpic2ScreenPlay:grantQuest(pPlayer)
	elseif (screenID == "s_3332") then
		forestDahliaEpic2ScreenPlay:grantQuest(pPlayer)
	elseif (screenID == "s_3346") then
		forestDahliaEpic1ScreenPlay:signalWarriors(pPlayer)
	elseif (screenID == "s_3354") then
		forestDahliaEpic1ScreenPlay:signalWarriors(pPlayer)
	elseif (screenID == "s_3362") then
		forestDahliaEpic1ScreenPlay:signalWarriors(pPlayer)
	elseif (screenID == "s_3386") then
		forestDahliaEpic1ScreenPlay:grantQuest(pPlayer)
	elseif (screenID == "s_3406") then
		forestDahliaEpic1ScreenPlay:grantQuest(pPlayer)
	elseif (screenID == "s_3430") then
	elseif (screenID == "s_3422") then
		forestDahliaEpic1ScreenPlay:grantQuest(pPlayer)
	elseif (screenID == "s_3442") then
		forestDahliaEpic1ScreenPlay:grantQuest(pPlayer)
	end

	return pClonedScreen
end
