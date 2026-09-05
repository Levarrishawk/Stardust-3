-- ep3_trandoshan_slave_leader -- ep3_trandoshan_slave_leader
-- ruling 2026-09-04
-- getInitialScreen is live condition order. runScreenHandlers fires grant / signal / turn-in.
-- NO JOURNAL: this branch has no managers/quest/journal.lua.

ep3_trandoshan_slave_leader_conv_handler = conv_handler:new {}

ep3_trandoshan_slave_leader_conv_handler.screenAnimations = {
}

function ep3_trandoshan_slave_leader_conv_handler:getInitialScreen(pPlayer, pNpc, pConvTemplate)
	local convoTemplate = LuaConversationTemplate(pConvTemplate)

	if ((trandoSsiksikScreenPlay:getStage(pPlayer) == 0 and trandoSsiksikScreenPlay:getRuns(pPlayer) > 0)) then
		return convoTemplate:getScreen("s_81")
	elseif (trandoSsiksikScreenPlay:isTurnIn(pPlayer)) then
		return convoTemplate:getScreen("s_83")
	elseif (trandoSsiksikScreenPlay:isTurnIn(pPlayer)) then
		return convoTemplate:getScreen("s_87")
	end
	return convoTemplate:getScreen("s_93")
end

function ep3_trandoshan_slave_leader_conv_handler:runScreenHandlers(pConvTemplate, pPlayer, pNpc, selectedOption, pConvScreen)
	local screen = LuaConversationScreen(pConvScreen)
	local screenID = screen:getScreenID()
	local pClonedScreen = screen:cloneScreen()
	local clonedConversation = LuaConversationScreen(pClonedScreen)

	if (self.screenAnimations ~= nil and self.screenAnimations[screenID] ~= nil and pNpc ~= nil) then
		CreatureObject(pNpc):doAnimation(self.screenAnimations[screenID])
	end

	if (screenID == "s_91") then
		trandoSsiksikScreenPlay:signalStartWookieeAttack(pPlayer)
	elseif (screenID == "s_83") then
		trandoSsiksikScreenPlay:signalRewardSlaverLeader(pPlayer)
	end

	return pClonedScreen
end

