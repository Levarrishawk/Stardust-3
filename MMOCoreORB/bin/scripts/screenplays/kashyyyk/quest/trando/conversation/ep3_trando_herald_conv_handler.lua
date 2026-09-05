-- ep3_trando_herald -- ep3_trando_herald
-- ruling 2026-09-04
-- getInitialScreen is live condition order. runScreenHandlers fires grant / signal / turn-in.
-- NO JOURNAL: this branch has no managers/quest/journal.lua.

ep3_trando_herald_conv_handler = conv_handler:new {}

ep3_trando_herald_conv_handler.screenAnimations = {
}

function ep3_trando_herald_conv_handler:getInitialScreen(pPlayer, pNpc, pConvTemplate)
	local convoTemplate = LuaConversationTemplate(pConvTemplate)

	if ((trandoHeraldScreenPlay:getStage(pPlayer) == 0 and trandoHeraldScreenPlay:getRuns(pPlayer) > 0)) then
		return convoTemplate:getScreen("s_35")
	elseif (trandoHeraldScreenPlay:getStage(pPlayer) > 0) then
		return convoTemplate:getScreen("s_222")
	end
	return convoTemplate:getScreen("s_224")
end

function ep3_trando_herald_conv_handler:runScreenHandlers(pConvTemplate, pPlayer, pNpc, selectedOption, pConvScreen)
	local screen = LuaConversationScreen(pConvScreen)
	local screenID = screen:getScreenID()
	local pClonedScreen = screen:cloneScreen()
	local clonedConversation = LuaConversationScreen(pClonedScreen)

	if (self.screenAnimations ~= nil and self.screenAnimations[screenID] ~= nil and pNpc ~= nil) then
		CreatureObject(pNpc):doAnimation(self.screenAnimations[screenID])
	end

	if (screenID == "s_244" or screenID == "s_268") then
		trandoHeraldScreenPlay:grantQuest(pPlayer)
	elseif (screenID == "s_286") then
		-- OPEN: attachScript event.ep3_trando_herald is not this fence
	end

	return pClonedScreen
end

