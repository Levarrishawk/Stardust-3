som_battlefield_miner_leader_conv_handler = conv_handler:new {}

function som_battlefield_miner_leader_conv_handler:getInitialScreen(pPlayer, pNpc, pConvTemplate)
	local state = ValleyBattlefield:getLeaderOrderState(pPlayer, pNpc)
	if (state ~= nil) then
		return LuaConversationTemplate(pConvTemplate):getScreen(state)
	end
end

function som_battlefield_miner_leader_conv_handler:runScreenHandlers(pConvTemplate, pPlayer, pNpc, selectedOption, pConvScreen)
	local screen = LuaConversationScreen(pConvScreen)
	local order = screen:getScreenID()
	if (order == "follow" or order == "stop" or order == "deploy" or order == "withdraw") then
		if (not ValleyBattlefield:orderMiningLeader(pPlayer, pNpc, order)) then
			return nil
		end
	end
	return screen:cloneScreen()
end
