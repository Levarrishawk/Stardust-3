-- Rhylis (Arena Guard Interior) -- ep3_forest_kerritamba_epic_6, ep3_forest_wirartu_epic_1
-- ruling 2026-09-04: "ensure kashyyyk is fully done"
-- getInitialScreen is live condition order. runScreenHandlers fires grant / signal / turn-in.
-- The journal engine lives on the journal branches. This arc does not call the Journal API.
-- Eject (java space_dungeon.ejectPlayerFromDungeon): guarded
-- if KashyyykArena ~= nil then KashyyykArena:eject(pPlayer). The arena
-- screenplay owns enter/eject; the branches meet later.

ep3_forest_arena_guard_interior_conv_handler = conv_handler:new {}

ep3_forest_arena_guard_interior_conv_handler.screenAnimations = {
	s_9 = "nod_head_multiple",
	s_10 = "shake_head_no",
}

function ep3_forest_arena_guard_interior_conv_handler:condition__defaultCondition(pPlayer, pNpc)
	return true
end

function ep3_forest_arena_guard_interior_conv_handler:condition_TooMany(pPlayer, pNpc)
	return (forestKerritambaEpic6ScreenPlay:getStage(pPlayer) == 1)
end

function ep3_forest_arena_guard_interior_conv_handler:condition_EnoughPeople(pPlayer, pNpc)
	return (forestKerritambaEpic6ScreenPlay:getStage(pPlayer) == 1)
end

function ep3_forest_arena_guard_interior_conv_handler:condition_AAlwaysTrue(pPlayer, pNpc)
	return true
end

function ep3_forest_arena_guard_interior_conv_handler:condition_notDone(pPlayer, pNpc)
	return (forestWirartuEpic1ScreenPlay:getStage(pPlayer) > 0)
end

function ep3_forest_arena_guard_interior_conv_handler:getInitialScreen(pPlayer, pNpc, pConvTemplate)
	local convoTemplate = LuaConversationTemplate(pConvTemplate)
	if (self:condition_notDone(pPlayer, pNpc)) then
		return convoTemplate:getScreen("s_6")
	elseif (self:condition_AAlwaysTrue(pPlayer, pNpc)) then
		return convoTemplate:getScreen("s_157")
	end
	return convoTemplate:getScreen("s_202")
end

function ep3_forest_arena_guard_interior_conv_handler:runScreenHandlers(pConvTemplate, pPlayer, pNpc, selectedOption, pConvScreen)
	local screen = LuaConversationScreen(pConvScreen)
	local screenID = screen:getScreenID()
	local pClonedScreen = screen:cloneScreen()
	local clonedConversation = LuaConversationScreen(pClonedScreen)

	if (self.screenAnimations ~= nil and self.screenAnimations[screenID] ~= nil and pNpc ~= nil) then
		CreatureObject(pNpc):doAnimation(self.screenAnimations[screenID])
	end

	if (screenID == "s_9") then
		forestWirartuEpic1ScreenPlay:clearQuest(pPlayer)
		if (KashyyykArena ~= nil) then
			KashyyykArena:eject(pPlayer)
		end
	elseif (screenID == "s_159") then
		if (KashyyykArena ~= nil) then
			KashyyykArena:eject(pPlayer)
		end
	end

	return pClonedScreen
end
