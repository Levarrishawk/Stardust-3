-- mtp_vendor_conv_handler
-- ruling 2026-09-04
-- getInitialScreen is live condition order. runScreenHandlers fires grant / signal / turn-in.

mtp_vendor_conv_handler = conv_handler:new {}


function mtp_vendor_conv_handler:getInitialScreen(pPlayer, pNpc, pConvTemplate)
	local convoTemplate = LuaConversationTemplate(pConvTemplate)
	MtpVendor:open(pPlayer)
	return convoTemplate:getScreen("vendor_credits")
end

function mtp_vendor_conv_handler:runScreenHandlers(pConvTemplate, pPlayer, pNpc, selectedOption, pConvScreen)
	return LuaConversationScreen(pConvScreen):cloneScreen()
end
