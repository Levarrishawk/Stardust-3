-- mtp_corellia_times_contact_conv_handler
-- ruling 2026-09-04
-- getInitialScreen is live condition order. runScreenHandlers fires grant / signal / turn-in.

mtp_corellia_times_contact_conv_handler = conv_handler:new {}


function mtp_corellia_times_contact_conv_handler:getInitialScreen(pPlayer, pNpc, pConvTemplate)
	local convoTemplate = LuaConversationTemplate(pConvTemplate)

	if (MtpQuestEngine.isQuestActive(pPlayer, "mtp_hideout_pointer")) then
		return convoTemplate:getScreen("s_10")
	elseif (MtpQuestEngine.isQuestActive(pPlayer, "mtp_collection_tracking") or MtpQuestEngine.isQuestActive(pPlayer, "mtp_collection_tracking_02")) then
		return convoTemplate:getScreen("s_50")
	elseif (MtpQuestEngine.isQuestComplete(pPlayer, "mtp_hideout_pointer") and not MtpQuestEngine.isQuestActive(pPlayer, "mtp_collection_tracking")) then
		return convoTemplate:getScreen("s_19")
	end

	return convoTemplate:getScreen("s_76")
end

function mtp_corellia_times_contact_conv_handler:runScreenHandlers(pConvTemplate, pPlayer, pNpc, selectedOption, pConvScreen)
	local screen = LuaConversationScreen(pConvScreen)
	local screenID = screen:getScreenID()
	local pClonedScreen = screen:cloneScreen()

	if (screenID == "s_10") then
		MtpQuestEngine.sendSignalAny(pPlayer, "mtp_hideout_pointer_03")
	elseif (screenID == "s_31") then
		-- Collection glue: OPEN until the collections branch merges.
		MtpWebTasks.grant(pPlayer, "mtp_collection_tracking")
	end

	return pClonedScreen
end
