-- ep3_etyyy_pilot_from_bocctyyy -- Etyyy hunting-grounds ground conversation
-- ruling 2026-09-04: "ensure kashyyyk is fully done"
-- getInitialScreen is live condition order. runScreenHandlers fires grant / signal / turn-in.
-- No journal engine: this branch has no managers/quest/journal.lua.

ep3_etyyy_pilot_from_bocctyyy_conv_handler = conv_handler:new {}

ep3_etyyy_pilot_from_bocctyyy_conv_handler.screenAnimations = {
	s_750 = "nod",
}

function ep3_etyyy_pilot_from_bocctyyy_conv_handler:_defaultCondition(pPlayer, pNpc)
	if (pPlayer == nil) then
		return false
	end
	return true
end

function ep3_etyyy_pilot_from_bocctyyy_conv_handler:getInitialScreen(pPlayer, pNpc, pConvTemplate)
	local convoTemplate = LuaConversationTemplate(pConvTemplate)
	if (pPlayer ~= nil) then
		huntLootNamedKillsScreenPlay:attachPlayer(pPlayer)
	end
	if (pPlayer == nil) then
		return convoTemplate:getScreen("s_738")
	end
	return convoTemplate:getScreen("s_738")
end

function ep3_etyyy_pilot_from_bocctyyy_conv_handler:runScreenHandlers(pConvTemplate, pPlayer, pNpc, selectedOption, pConvScreen)
	local screen = LuaConversationScreen(pConvScreen)
	local screenID = screen:getScreenID()
	local pClonedScreen = screen:cloneScreen()
	local clonedConversation = LuaConversationScreen(pClonedScreen)
	if (self.screenAnimations ~= nil and self.screenAnimations[screenID] ~= nil and pNpc ~= nil) then
		CreatureObject(pNpc):doAnimation(self.screenAnimations[screenID])
	end
	if (screenID == "s_746") then
		self:sendHome(pPlayer)
	end
	return pClonedScreen
end

-- travelBack is the Core3 stand-in for space_dungeon.selectDungeonTicket on this island.
function ep3_etyyy_pilot_from_bocctyyy_conv_handler:sendHome(pPlayer)
	if (pPlayer == nil) then
		return
	end
	if (KashyyykIslands ~= nil) then
		KashyyykIslands.travelBack(pPlayer)
	end
end
