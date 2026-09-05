-- Wirartu (Arena Champion - Pre-Combat) -- ep3_forest_kerritamba_epic_6, ep3_forest_wirartu_epic_1
-- ruling 2026-09-04: "ensure kashyyyk is fully done"
-- getInitialScreen is live condition order. runScreenHandlers fires grant / signal / turn-in.
-- The journal engine lives on the journal branches. This arc does not call the Journal API.

ep3_forest_wirartu_arena_conv_handler = conv_handler:new {}

ep3_forest_wirartu_arena_conv_handler.screenAnimations = {
}

function ep3_forest_wirartu_arena_conv_handler:condition__defaultCondition(pPlayer, pNpc)
	return true
end

function ep3_forest_wirartu_arena_conv_handler:condition_isEpicTaskActiveOne(pPlayer, pNpc)
	return (forestKerritambaEpic6ScreenPlay:getStage(pPlayer) == 1)
end

function ep3_forest_wirartu_arena_conv_handler:getInitialScreen(pPlayer, pNpc, pConvTemplate)
	local convoTemplate = LuaConversationTemplate(pConvTemplate)
	if (self:condition_isEpicTaskActiveOne(pPlayer, pNpc)) then
		return convoTemplate:getScreen("s_541")
	end
	return convoTemplate:getScreen("s_555")
end

function ep3_forest_wirartu_arena_conv_handler:runScreenHandlers(pConvTemplate, pPlayer, pNpc, selectedOption, pConvScreen)
	local screen = LuaConversationScreen(pConvScreen)
	local screenID = screen:getScreenID()
	local pClonedScreen = screen:cloneScreen()
	local clonedConversation = LuaConversationScreen(pClonedScreen)

	if (self.screenAnimations ~= nil and self.screenAnimations[screenID] ~= nil and pNpc ~= nil) then
		CreatureObject(pNpc):doAnimation(self.screenAnimations[screenID])
	end

	if (screenID == "s_549") then
		forestKerritambaEpic6ScreenPlay:signalWirartu(pPlayer)
		forestWirartuEpic1ScreenPlay:signalWirartu(pPlayer)
		forestWirartuEpic1ScreenPlay:grantQuest(pPlayer)
		forestArenaEpic1ScreenPlay:signalStartfight(pPlayer)
		forestWirartuEpic1ScreenPlay:signalStartfight(pPlayer)
	end

	return pClonedScreen
end
