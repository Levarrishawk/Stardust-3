-- mtp_hideout_infiltrator_conv_handler
-- ruling 2026-09-04
-- getInitialScreen is live condition order. runScreenHandlers fires grant / signal / turn-in.

mtp_hideout_infiltrator_conv_handler = conv_handler:new {}


function mtp_hideout_infiltrator_conv_handler:getInitialScreen(pPlayer, pNpc, pConvTemplate)
	local convoTemplate = LuaConversationTemplate(pConvTemplate)

	for i = 1, 5 do
		if (MtpQuestEngine.isTaskActive(MtpQuestEngine.byName("mtp_find_infiltrator_" .. tostring(i)), pPlayer, "findInfiltrator")) then
			return convoTemplate:getScreen("s_4")
		end
	end

	return convoTemplate:getScreen("s_36")
end

function mtp_hideout_infiltrator_conv_handler:runScreenHandlers(pConvTemplate, pPlayer, pNpc, selectedOption, pConvScreen)
	local screen = LuaConversationScreen(pConvScreen)
	local screenID = screen:getScreenID()
	local pClonedScreen = screen:cloneScreen()

	if (screenID == "s_4") then
		MtpQuestEngine.sendSignalAny(pPlayer, "findTheInfiltrator")
	end

	return pClonedScreen
end
