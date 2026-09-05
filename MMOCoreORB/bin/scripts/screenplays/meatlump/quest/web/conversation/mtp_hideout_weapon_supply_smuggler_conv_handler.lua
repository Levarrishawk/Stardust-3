-- mtp_hideout_weapon_supply_smuggler_conv_handler
-- ruling 2026-09-04
-- getInitialScreen is live condition order. runScreenHandlers fires grant / signal / turn-in.

mtp_hideout_weapon_supply_smuggler_conv_handler = conv_handler:new {}


function mtp_hideout_weapon_supply_smuggler_conv_handler:getInitialScreen(pPlayer, pNpc, pConvTemplate)
	local convoTemplate = LuaConversationTemplate(pConvTemplate)

	if (MtpQuestEngine.isTaskActive(MtpQuestEngine.byName("mtp_hideout_retrieve_delivery"), pPlayer, "speakSmuggler")) then
		return convoTemplate:getScreen("s_4")
	end

	return convoTemplate:getScreen("s_15")
end

function mtp_hideout_weapon_supply_smuggler_conv_handler:runScreenHandlers(pConvTemplate, pPlayer, pNpc, selectedOption, pConvScreen)
	local screen = LuaConversationScreen(pConvScreen)
	local screenID = screen:getScreenID()
	local pClonedScreen = screen:cloneScreen()

	if (screenID == "s_42") then
		MtpQuestEngine.sendSignalAny(pPlayer, "smugglerSpoken")
	end

	return pClonedScreen
end
