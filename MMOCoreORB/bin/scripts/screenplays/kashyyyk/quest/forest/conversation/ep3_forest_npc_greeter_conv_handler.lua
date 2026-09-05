-- Kerritamba Greeter (NPC Greeter) -- flavor / dealer
-- ruling 2026-09-04: "ensure kashyyyk is fully done"
-- getInitialScreen is live condition order. runScreenHandlers fires grant / signal / turn-in.
-- The journal engine lives on the journal branches. This arc does not call the Journal API.

ep3_forest_npc_greeter_conv_handler = conv_handler:new {}

ep3_forest_npc_greeter_conv_handler.screenAnimations = {
}

function ep3_forest_npc_greeter_conv_handler:condition__defaultCondition(pPlayer, pNpc)
	return true
end

function ep3_forest_npc_greeter_conv_handler:getInitialScreen(pPlayer, pNpc, pConvTemplate)
	local convoTemplate = LuaConversationTemplate(pConvTemplate)
	return convoTemplate:getScreen("s_4")
end

function ep3_forest_npc_greeter_conv_handler:runScreenHandlers(pConvTemplate, pPlayer, pNpc, selectedOption, pConvScreen)
	local screen = LuaConversationScreen(pConvScreen)
	local screenID = screen:getScreenID()
	local pClonedScreen = screen:cloneScreen()
	local clonedConversation = LuaConversationScreen(pClonedScreen)

	if (self.screenAnimations ~= nil and self.screenAnimations[screenID] ~= nil and pNpc ~= nil) then
		CreatureObject(pNpc):doAnimation(self.screenAnimations[screenID])
	end


	return pClonedScreen
end
