-- Wirartu (Arena Champion - Post-Combat Submission) -- ep3_forest_wirartu_epic_1, ep3_forest_wirartu_epic_2, ep3_forest_wirartu_epic_3, ep3_forest_on_hold
-- ruling 2026-09-04: "ensure kashyyyk is fully done"
-- getInitialScreen is live condition order. runScreenHandlers fires grant / signal / turn-in.
-- The journal engine lives on the journal branches. This arc does not call the Journal API.

ep3_forest_wirartu_attack_conv_handler = conv_handler:new {}

ep3_forest_wirartu_attack_conv_handler.screenAnimations = {
}

function ep3_forest_wirartu_attack_conv_handler:condition__defaultCondition(pPlayer, pNpc)
	return true
end

function ep3_forest_wirartu_attack_conv_handler:condition_isEpicTaskActiveOne(pPlayer, pNpc)
	return (forestWirartuEpic3ScreenPlay:getStage(pPlayer) == 1)
end

function ep3_forest_wirartu_attack_conv_handler:condition_isOnHold(pPlayer, pNpc)
	-- OPEN: ep3_forest_on_hold is not in this arc
	return false
end

function ep3_forest_wirartu_attack_conv_handler:getInitialScreen(pPlayer, pNpc, pConvTemplate)
	local convoTemplate = LuaConversationTemplate(pConvTemplate)
	if (self:condition_isEpicTaskActiveOne(pPlayer, pNpc)) then
		return convoTemplate:getScreen("s_865")
	end
	return convoTemplate:getScreen("s_867")
end

function ep3_forest_wirartu_attack_conv_handler:runScreenHandlers(pConvTemplate, pPlayer, pNpc, selectedOption, pConvScreen)
	local screen = LuaConversationScreen(pConvScreen)
	local screenID = screen:getScreenID()
	local pClonedScreen = screen:cloneScreen()
	local clonedConversation = LuaConversationScreen(pClonedScreen)

	if (self.screenAnimations ~= nil and self.screenAnimations[screenID] ~= nil and pNpc ~= nil) then
		CreatureObject(pNpc):doAnimation(self.screenAnimations[screenID])
	end

	if (screenID == "s_871") then
		forestWirartuEpic1ScreenPlay:awardQuest(pPlayer)
		forestWirartuEpic3ScreenPlay:grantQuest(pPlayer)
	elseif (screenID == "s_875") then
		forestWirartuEpic1ScreenPlay:awardQuest(pPlayer)
		forestWirartuEpic2ScreenPlay:grantQuest(pPlayer)
		if (pNpc ~= nil) then
			CreatureObject(pNpc):inflictDamage(pPlayer, 0, 1000000, 1)
		end
	end

	return pClonedScreen
end
