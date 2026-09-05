-- ep3_rodian_doctor. Flavor only.
-- ruling 2026-09-04
-- getInitialScreen is live condition order. runScreenHandlers fires no grant.
-- NO JOURNAL: this branch has no managers/quest/journal.lua.

ep3_rodian_doctor_conv_handler = conv_handler:new {}

function ep3_rodian_doctor_conv_handler:getInitialScreen(pPlayer, pNpc, pConvTemplate)
	local convoTemplate = LuaConversationTemplate(pConvTemplate)

	return convoTemplate:getScreen("s_4")
end

function ep3_rodian_doctor_conv_handler:runScreenHandlers(pConvTemplate, pPlayer, pNpc, selectedOption, pConvScreen)
	local screen = LuaConversationScreen(pConvScreen)
	local pClonedScreen = screen:cloneScreen()

	return pClonedScreen
end
