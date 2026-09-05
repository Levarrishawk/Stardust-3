-- mtp_hideout_recon_conv_handler
-- ruling 2026-09-04
-- getInitialScreen is live condition order. runScreenHandlers fires grant / signal / turn-in.

mtp_hideout_recon_conv_handler = conv_handler:new {}


function mtp_hideout_recon_conv_handler:getInitialScreen(pPlayer, pNpc, pConvTemplate)
	local convoTemplate = LuaConversationTemplate(pConvTemplate)
	return convoTemplate:getScreen("s_8")
end

function mtp_hideout_recon_conv_handler:runScreenHandlers(pConvTemplate, pPlayer, pNpc, selectedOption, pConvScreen)
	local pClonedScreen = LuaConversationScreen(pConvScreen):cloneScreen()
	-- Collection slot grant is OPEN until the collections branch merges.
	return pClonedScreen
end
