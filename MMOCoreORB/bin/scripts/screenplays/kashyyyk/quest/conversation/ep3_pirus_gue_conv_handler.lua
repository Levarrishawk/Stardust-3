-- Pirus Gue -- ep3_kachirho_varactyl_egg. Live isPreOrder gated the pitch; this port treats every player as eligible so the quest can play (ruling 2026-09-04).
-- ruling 2026-09-04: "ensure kashyyyk is done in full"
-- getInitialScreen is live condition order. runScreenHandlers fires grant / signal / turn-in.
-- No Journal.*: this branch has no managers/quest/journal.lua.

ep3_pirus_gue_conv_handler = conv_handler:new {}

ep3_pirus_gue_conv_handler.screenAnimations = {
	s_327 = "greet",
	s_329 = "greet",
	s_333 = "explain",
	s_337 = "explain",
	s_341 = "explain",
	s_345 = "standing_placate",
	s_349 = "explain",
	s_353 = "nod_head_once",
}

function ep3_pirus_gue_conv_handler:stage(pPlayer)
	return kachirhoVaractylEggScreenPlay:getStage(pPlayer)
end

function ep3_pirus_gue_conv_handler:getInitialScreen(pPlayer, pNpc, pConvTemplate)
	local convoTemplate = LuaConversationTemplate(pConvTemplate)

	if (self:stage(pPlayer) == 0 and kachirhoVaractylEggScreenPlay:getRuns(pPlayer) > 0) then
		return convoTemplate:getScreen("s_16")
	elseif (self:stage(pPlayer) > 0) then
		return convoTemplate:getScreen("s_327")
	elseif (true) then
		return convoTemplate:getScreen("s_329")
	end

	return convoTemplate:getScreen("s_19")
end

function ep3_pirus_gue_conv_handler:runScreenHandlers(pConvTemplate, pPlayer, pNpc, selectedOption, pConvScreen)
	local screen = LuaConversationScreen(pConvScreen)
	local screenID = screen:getScreenID()
	local pClonedScreen = screen:cloneScreen()
	local clonedConversation = LuaConversationScreen(pClonedScreen)

	if (self.screenAnimations ~= nil and self.screenAnimations[screenID] ~= nil and pNpc ~= nil) then
		CreatureObject(pNpc):doAnimation(self.screenAnimations[screenID])
	end

	if (screenID == "s_349") then
		kachirhoVaractylEggScreenPlay:grantQuest(pPlayer)
	end

	return pClonedScreen
end
