-- mtp_meatlump_king_conv_handler
-- ruling 2026-09-04
-- getInitialScreen is live condition order. runScreenHandlers fires grant / signal / turn-in.

mtp_meatlump_king_conv_handler = conv_handler:new {}


function mtp_meatlump_king_conv_handler:getInitialScreen(pPlayer, pNpc, pConvTemplate)
	local convoTemplate = LuaConversationTemplate(pConvTemplate)

	if (MtpQuestEngine.isQuestComplete(pPlayer, "mtp_meatlump_king_story")) then
		return convoTemplate:getScreen("s_41")
	elseif (MtpQuestEngine.isQuestComplete(pPlayer, "mtp_hideout_pointer") and not MtpQuestEngine.isQuestActiveOrComplete(pPlayer, "mtp_meatlump_king_story")) then
		return convoTemplate:getScreen("s_4")
	elseif (MtpQuestEngine.isQuestActive(pPlayer, "mtp_meatlump_king_story")) then
		return convoTemplate:getScreen("s_43")
	end

	return convoTemplate:getScreen(MeatlumpKing.flavorScreen())
end

function mtp_meatlump_king_conv_handler:runScreenHandlers(pConvTemplate, pPlayer, pNpc, selectedOption, pConvScreen)
	local screen = LuaConversationScreen(pConvScreen)
	local screenID = screen:getScreenID()
	local pClonedScreen = screen:cloneScreen()

	if (screenID == "s_4") then
		MtpWebTasks.grant(pPlayer, "mtp_meatlump_king_story")
	elseif (screenID == "s_43") then
		MeatlumpKing.openOfferings(pPlayer, pNpc)
	end

	return pClonedScreen
end
