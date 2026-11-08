-- arena_guard_outer -- ep3_forest_arena_guard
-- ruling 2026-09-04
-- getInitialScreen is live condition order. runScreenHandlers fires grant / signal / turn-in.
-- NO JOURNAL: this branch has no managers/quest/journal.lua.

ep3_forest_arena_guard_conv_handler = conv_handler:new {}

ep3_forest_arena_guard_conv_handler.screenAnimations = {
}

function ep3_forest_arena_guard_conv_handler:getInitialScreen(pPlayer, pNpc, pConvTemplate)
	local convoTemplate = LuaConversationTemplate(pConvTemplate)

	if (pPlayer ~= nil and arenaChallengeScreenPlay:getStage(pPlayer) == 1) then
		return convoTemplate:getScreen("s_575")
	end
	return convoTemplate:getScreen("s_581")
end

function ep3_forest_arena_guard_conv_handler:runScreenHandlers(pConvTemplate, pPlayer, pNpc, selectedOption, pConvScreen)
	local screen = LuaConversationScreen(pConvScreen)
	local screenID = screen:getScreenID()
	local pClonedScreen = screen:cloneScreen()
	local clonedConversation = LuaConversationScreen(pClonedScreen)

	if (self.screenAnimations ~= nil and self.screenAnimations[screenID] ~= nil and pNpc ~= nil) then
		CreatureObject(pNpc):doAnimation(self.screenAnimations[screenID])
	end

	if (screenID == "s_579" and pPlayer ~= nil and arenaChallengeScreenPlay:getStage(pPlayer) == 1) then
		KashyyykArena.enter(pPlayer)
	end

	return pClonedScreen
end

