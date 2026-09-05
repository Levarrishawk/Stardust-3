-- Chief Kerritamba -- ep3_forest_kerritamba_epic_1, ep3_forest_kerritamba_epic_2, ep3_forest_kerritamba_epic_3, ep3_forest_kerritamba_epic_4, ep3_forest_kerritamba_epic_5, ep3_forest_kerritamba_epic_6, ep3_forest_kerritamba_epic_7, ep3_forest_kerritamba_assassin, ep3_forest_on_hold, ep3_forest_wirartu_epic_2, ep3_forest_wirartu_epic_3
-- ruling 2026-09-04: "ensure kashyyyk is fully done"
-- getInitialScreen is live condition order. runScreenHandlers fires grant / signal / turn-in.
-- The journal engine lives on the journal branches. This arc does not call the Journal API.

ep3_forest_kerritamba_conv_handler = conv_handler:new {}

ep3_forest_kerritamba_conv_handler.screenAnimations = {
}

function ep3_forest_kerritamba_conv_handler:condition__defaultCondition(pPlayer, pNpc)
	return true
end

function ep3_forest_kerritamba_conv_handler:condition_isEpicTaskActiveOne(pPlayer, pNpc)
	return (forestKerritambaEpic1ScreenPlay:getStage(pPlayer) == 1)
end

function ep3_forest_kerritamba_conv_handler:condition_EpicTaskCompletedOne(pPlayer, pNpc)
	return (forestKerritambaEpic1ScreenPlay:getStage(pPlayer) == 2)
end

function ep3_forest_kerritamba_conv_handler:condition_hasCompletedQuestOne(pPlayer, pNpc)
	return (forestKerritambaEpic1ScreenPlay:getRuns(pPlayer) > 0 and forestKerritambaEpic1ScreenPlay:getStage(pPlayer) == 0)
end

function ep3_forest_kerritamba_conv_handler:condition_isEpicTaskActiveTwo(pPlayer, pNpc)
	return (forestKerritambaEpic2ScreenPlay:getStage(pPlayer) == 1)
end

function ep3_forest_kerritamba_conv_handler:condition_EpicTaskCompletedTwo(pPlayer, pNpc)
	return (forestKerritambaEpic2ScreenPlay:getStage(pPlayer) == 2)
end

function ep3_forest_kerritamba_conv_handler:condition_hasCompletedQuestTwo(pPlayer, pNpc)
	return (forestKerritambaEpic2ScreenPlay:getRuns(pPlayer) > 0 and forestKerritambaEpic2ScreenPlay:getStage(pPlayer) == 0)
end

function ep3_forest_kerritamba_conv_handler:condition_isEpicTaskActiveThree(pPlayer, pNpc)
	return (forestKerritambaEpic3ScreenPlay:getStage(pPlayer) == 1)
end

function ep3_forest_kerritamba_conv_handler:condition_EpicTaskCompletedThree(pPlayer, pNpc)
	return (forestKerritambaEpic3ScreenPlay:getStage(pPlayer) == 2)
end

function ep3_forest_kerritamba_conv_handler:condition_hasCompletedQuestThree(pPlayer, pNpc)
	return (forestKerritambaEpic3ScreenPlay:getRuns(pPlayer) > 0 and forestKerritambaEpic3ScreenPlay:getStage(pPlayer) == 0)
end

function ep3_forest_kerritamba_conv_handler:condition_isEpicTaskActiveFour(pPlayer, pNpc)
	return (forestKerritambaEpic4ScreenPlay:getStage(pPlayer) == 1)
end

function ep3_forest_kerritamba_conv_handler:condition_EpicTaskCompletedFour(pPlayer, pNpc)
	return ((forestKerritambaEpic4ScreenPlay:getStage(pPlayer) >= 2 or forestKerritambaEpic4ScreenPlay:getRuns(pPlayer) > 0)  and   not (forestKerritambaEpic4ScreenPlay:getRuns(pPlayer) > 0 and forestKerritambaEpic4ScreenPlay:getStage(pPlayer) == 0))
end

function ep3_forest_kerritamba_conv_handler:condition_hasCompletedQuestFour(pPlayer, pNpc)
	return (forestKerritambaEpic4ScreenPlay:getRuns(pPlayer) > 0 and forestKerritambaEpic4ScreenPlay:getStage(pPlayer) == 0)
end

function ep3_forest_kerritamba_conv_handler:condition_isEpicTaskActiveFive(pPlayer, pNpc)
	return (forestKerritambaEpic5ScreenPlay:getStage(pPlayer) == 1)
end

function ep3_forest_kerritamba_conv_handler:condition_EpicTaskCompletedFive(pPlayer, pNpc)
	return ((forestKerritambaEpic5ScreenPlay:getStage(pPlayer) >= 2 or forestKerritambaEpic5ScreenPlay:getRuns(pPlayer) > 0)  and   not (forestKerritambaEpic5ScreenPlay:getRuns(pPlayer) > 0 and forestKerritambaEpic5ScreenPlay:getStage(pPlayer) == 0))
end

function ep3_forest_kerritamba_conv_handler:condition_hasCompletedQuestFive(pPlayer, pNpc)
	return (forestKerritambaEpic5ScreenPlay:getRuns(pPlayer) > 0 and forestKerritambaEpic5ScreenPlay:getStage(pPlayer) == 0)
end

function ep3_forest_kerritamba_conv_handler:condition_isEpicTaskActiveSix(pPlayer, pNpc)
	return (forestKerritambaEpic6ScreenPlay:getStage(pPlayer) == 1)
end

function ep3_forest_kerritamba_conv_handler:condition_isEpicTaskActiveGood(pPlayer, pNpc)
	return (forestWirartuEpic3ScreenPlay:getStage(pPlayer) == 1)
end

function ep3_forest_kerritamba_conv_handler:condition_isEpicTaskActiveBad(pPlayer, pNpc)
	return ((forestWirartuEpic2ScreenPlay:getStage(pPlayer) == 1)  or  (forestWirartuEpic2ScreenPlay:getStage(pPlayer) >= 1 or forestWirartuEpic2ScreenPlay:getRuns(pPlayer) > 0))
end

function ep3_forest_kerritamba_conv_handler:condition_isEpicTaskActiveSeven(pPlayer, pNpc)
	return ((forestKerritambaEpic7ScreenPlay:getStage(pPlayer) == 1)  and  (forestKerritambaEpic7ScreenPlay:getStage(pPlayer) == 1))
end

function ep3_forest_kerritamba_conv_handler:condition_EpicTaskCompletedSeven(pPlayer, pNpc)
	return ((forestKerritambaEpic7ScreenPlay:getStage(pPlayer) >= 2 or forestKerritambaEpic7ScreenPlay:getRuns(pPlayer) > 0)  and  (forestKerritambaEpic7ScreenPlay:getStage(pPlayer) >= 2 or forestKerritambaEpic7ScreenPlay:getRuns(pPlayer) > 0)  and   not (forestKerritambaEpic7ScreenPlay:getRuns(pPlayer) > 0 and forestKerritambaEpic7ScreenPlay:getStage(pPlayer) == 0))
end

function ep3_forest_kerritamba_conv_handler:condition_AllComplete(pPlayer, pNpc)
	return ((forestKerritambaEpic7ScreenPlay:getRuns(pPlayer) > 0 and forestKerritambaEpic7ScreenPlay:getStage(pPlayer) == 0)  or  (forestWirartuEpic3ScreenPlay:getRuns(pPlayer) > 0 and forestWirartuEpic3ScreenPlay:getStage(pPlayer) == 0))
end

function ep3_forest_kerritamba_conv_handler:condition_isOnHold(pPlayer, pNpc)
	-- OPEN: ep3_forest_on_hold is not in this arc
	return false
end

function ep3_forest_kerritamba_conv_handler:condition_AAlwaysTrue(pPlayer, pNpc)
	return true
end

function ep3_forest_kerritamba_conv_handler:condition_hasLanguage(pPlayer, pNpc)
	return (not CreatureObject(pPlayer):hasSkill("social_language_wookiee_comprehend"))
end

function ep3_forest_kerritamba_conv_handler:condition_hasCure(pPlayer, pNpc)
	-- OPEN: object/tangible/loot/quest/ep3_forest_cure.iff has no repo template
	return false
end

function ep3_forest_kerritamba_conv_handler:condition_badQuest(pPlayer, pNpc)
	return (forestKerritambaAssassinScreenPlay:getStage(pPlayer) > 0 or forestKerritambaAssassinScreenPlay:getRuns(pPlayer) > 0)
end

function ep3_forest_kerritamba_conv_handler:getInitialScreen(pPlayer, pNpc, pConvTemplate)
	local convoTemplate = LuaConversationTemplate(pConvTemplate)
	if (self:condition_hasLanguage(pPlayer, pNpc)) then
		return convoTemplate:getScreen("s_690")
	elseif (self:condition_badQuest(pPlayer, pNpc)) then
		return convoTemplate:getScreen("s_149")
	elseif (self:condition_AllComplete(pPlayer, pNpc)) then
		return convoTemplate:getScreen("s_603")
	elseif (self:condition_EpicTaskCompletedSeven(pPlayer, pNpc)) then
		return convoTemplate:getScreen("s_605")
	elseif (self:condition_isEpicTaskActiveSeven(pPlayer, pNpc)) then
		return convoTemplate:getScreen("s_615")
	elseif (self:condition_isEpicTaskActiveBad(pPlayer, pNpc)) then
		return convoTemplate:getScreen("s_617")
	elseif (self:condition_isEpicTaskActiveGood(pPlayer, pNpc)) then
		return convoTemplate:getScreen("s_639")
	elseif (self:condition_isEpicTaskActiveSix(pPlayer, pNpc)) then
		return convoTemplate:getScreen("s_645")
	elseif (self:condition_hasCompletedQuestFive(pPlayer, pNpc)) then
		return convoTemplate:getScreen("s_647")
	elseif (self:condition_EpicTaskCompletedFive(pPlayer, pNpc)) then
		return convoTemplate:getScreen("s_673")
	elseif (self:condition_isEpicTaskActiveFive(pPlayer, pNpc)) then
		return convoTemplate:getScreen("s_683")
	elseif (self:condition_hasCompletedQuestFour(pPlayer, pNpc)) then
		return convoTemplate:getScreen("s_689")
	elseif (self:condition_EpicTaskCompletedFour(pPlayer, pNpc)) then
		return convoTemplate:getScreen("s_715")
	elseif (self:condition_isEpicTaskActiveFour(pPlayer, pNpc)) then
		return convoTemplate:getScreen("s_725")
	elseif (self:condition_hasCompletedQuestThree(pPlayer, pNpc)) then
		return convoTemplate:getScreen("s_731")
	elseif (self:condition_EpicTaskCompletedThree(pPlayer, pNpc)) then
		return convoTemplate:getScreen("s_749")
	elseif (self:condition_isEpicTaskActiveThree(pPlayer, pNpc)) then
		return convoTemplate:getScreen("s_755")
	elseif (self:condition_hasCompletedQuestTwo(pPlayer, pNpc)) then
		return convoTemplate:getScreen("s_765")
	elseif (self:condition_EpicTaskCompletedTwo(pPlayer, pNpc)) then
		return convoTemplate:getScreen("s_787")
	elseif (self:condition_isEpicTaskActiveTwo(pPlayer, pNpc)) then
		return convoTemplate:getScreen("s_797")
	elseif (self:condition_hasCompletedQuestOne(pPlayer, pNpc)) then
		return convoTemplate:getScreen("s_803")
	elseif (self:condition_EpicTaskCompletedOne(pPlayer, pNpc)) then
		return convoTemplate:getScreen("s_821")
	elseif (self:condition_isEpicTaskActiveOne(pPlayer, pNpc)) then
		return convoTemplate:getScreen("s_831")
	end
	return convoTemplate:getScreen("s_837")
end

function ep3_forest_kerritamba_conv_handler:runScreenHandlers(pConvTemplate, pPlayer, pNpc, selectedOption, pConvScreen)
	local screen = LuaConversationScreen(pConvScreen)
	local screenID = screen:getScreenID()
	local pClonedScreen = screen:cloneScreen()
	local clonedConversation = LuaConversationScreen(pClonedScreen)

	if (self.screenAnimations ~= nil and self.screenAnimations[screenID] ~= nil and pNpc ~= nil) then
		CreatureObject(pNpc):doAnimation(self.screenAnimations[screenID])
	end

	if (screenID == "s_609") then
		forestArdonQuest3ScreenPlay:signalAlldone(pPlayer)
		forestKerritambaEpic7ScreenPlay:signalAlldone(pPlayer)
	elseif (screenID == "s_625") then
		forestWirartuEpic2ScreenPlay:signalBadguys(pPlayer)
		forestKerritambaAssassinScreenPlay:grantQuest(pPlayer)
	elseif (screenID == "s_637") then
		forestWirartuEpic2ScreenPlay:signalBadguys(pPlayer)
		forestKerritambaEpic7ScreenPlay:grantQuest(pPlayer)
	elseif (screenID == "s_643") then
		forestWirartuEpic3ScreenPlay:signalGoodguys(pPlayer)
		-- OPEN: badge.grantBadge (no Core3 badge for this arc)
	elseif (screenID == "s_663") then
		forestKerritambaEpic6ScreenPlay:clearQuest(pPlayer)
		forestKerritambaEpic6ScreenPlay:grantQuest(pPlayer)
		writeScreenPlayData(pPlayer, "forestKerritambaEpic6ScreenPlay", "arena", "1")
		-- OPEN: ep3_arena_challenge is not in this arc; arena flag lives on epic_6
	elseif (screenID == "s_677") then
		forestKerritambaEpic5ScreenPlay:signalEpic5(pPlayer)
	elseif (screenID == "s_709") then
		forestKerritambaEpic5ScreenPlay:grantQuest(pPlayer)
	elseif (screenID == "s_719") then
		forestKerritambaEpic4ScreenPlay:signalSayormi(pPlayer)
		forestMeustQuest3ScreenPlay:signalSayormi(pPlayer)
	elseif (screenID == "s_743") then
		forestKerritambaEpic4ScreenPlay:grantQuest(pPlayer)
	elseif (screenID == "s_753") then
		forestKerritambaEpic3ScreenPlay:signalCurereward(pPlayer)
	elseif (screenID == "s_763") then
		-- OPEN: object/tangible/loot/quest/ep3_forest_cure.iff has no repo template
	elseif (screenID == "s_769") then
		forestKerritambaEpic3ScreenPlay:grantQuest(pPlayer)
	elseif (screenID == "s_785") then
		forestKerritambaEpic3ScreenPlay:grantQuest(pPlayer)
	elseif (screenID == "s_791") then
		forestKerritambaEpic2ScreenPlay:signalCurestuff(pPlayer)
	elseif (screenID == "s_815") then
		forestKerritambaEpic2ScreenPlay:grantQuest(pPlayer)
	elseif (screenID == "s_829") then
		forestKerritambaEpic1ScreenPlay:signalSteps(pPlayer)
	elseif (screenID == "s_861") then
		forestKerritambaEpic1ScreenPlay:grantQuest(pPlayer)
	elseif (screenID == "s_889") then
		forestKerritambaEpic1ScreenPlay:grantQuest(pPlayer)
	end

	return pClonedScreen
end
