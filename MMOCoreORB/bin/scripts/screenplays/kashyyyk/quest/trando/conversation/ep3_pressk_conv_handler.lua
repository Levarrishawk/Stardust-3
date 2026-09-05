-- ep3_pressk -- ep3_trando_pressk
-- ruling 2026-09-04
-- getInitialScreen is live condition order. runScreenHandlers fires grant / signal / turn-in.
-- NO JOURNAL: this branch has no managers/quest/journal.lua.

ep3_pressk_conv_handler = conv_handler:new {}

ep3_pressk_conv_handler.screenAnimations = {
	s_497 = "rub_chin_thoughtful",
	s_501 = "shrug_hands",
	s_487 = "nod_head_once",
	s_489 = "salute2",
	s_491 = "smell_air",
	s_493 = "pound_fist_palm",
	s_503 = "wave_on_dismissing",
}

function ep3_pressk_conv_handler:getInitialScreen(pPlayer, pNpc, pConvTemplate)
	local convoTemplate = LuaConversationTemplate(pConvTemplate)

	if ((trandoSsiksikScreenPlay:getStage(pPlayer) == 0 and trandoSsiksikScreenPlay:getRuns(pPlayer) > 0)) then
		return convoTemplate:getScreen("s_487")
	elseif (trandoSsiksikScreenPlay:isTurnIn(pPlayer)) then
		return convoTemplate:getScreen("s_489")
	elseif (trandoSsiksikScreenPlay:getStage(pPlayer) >= 3) then
		return convoTemplate:getScreen("s_491")
	elseif (trandoSsiksikScreenPlay:getStage(pPlayer) == 2) then
		return convoTemplate:getScreen("s_493")
	end
	return convoTemplate:getScreen("s_503")
end

function ep3_pressk_conv_handler:runScreenHandlers(pConvTemplate, pPlayer, pNpc, selectedOption, pConvScreen)
	local screen = LuaConversationScreen(pConvScreen)
	local screenID = screen:getScreenID()
	local pClonedScreen = screen:cloneScreen()
	local clonedConversation = LuaConversationScreen(pClonedScreen)

	if (self.screenAnimations ~= nil and self.screenAnimations[screenID] ~= nil and pNpc ~= nil) then
		CreatureObject(pNpc):doAnimation(self.screenAnimations[screenID])
	end

	if (screenID == "s_501") then
		trandoSsiksikScreenPlay:signalStartWookieeAttack(pPlayer)
	elseif (screenID == "s_489") then
		trandoSsiksikScreenPlay:signalRewardSlaverLeader(pPlayer)
	end

	return pClonedScreen
end

