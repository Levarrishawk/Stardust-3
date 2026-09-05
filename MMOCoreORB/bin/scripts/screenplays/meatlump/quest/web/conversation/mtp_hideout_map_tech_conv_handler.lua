-- mtp_hideout_map_tech_conv_handler
-- ruling 2026-09-04
-- getInitialScreen is live condition order. runScreenHandlers fires grant / signal / turn-in.

mtp_hideout_map_tech_conv_handler = conv_handler:new {}


function mtp_hideout_map_tech_conv_handler:getInitialScreen(pPlayer, pNpc, pConvTemplate)
	local convoTemplate = LuaConversationTemplate(pConvTemplate)

	if (MtpQuestEngine.isQuestActiveOrComplete(pPlayer, "mtp_camp_quest_corellia")) then
		return convoTemplate:getScreen("s_56")
	elseif (MtpQuestEngine.isQuestActiveOrComplete(pPlayer, "mtp_hideout_get_lunch") and not MtpQuestEngine.isQuestActiveOrComplete(pPlayer, "mtp_camp_quest_corellia")) then
		return convoTemplate:getScreen("s_42")
	elseif (not MtpQuestEngine.isQuestActiveOrComplete(pPlayer, "mtp_hideout_get_lunch")) then
		return convoTemplate:getScreen("s_4")
	end

	return convoTemplate:getScreen("s_58")
end

function mtp_hideout_map_tech_conv_handler:runScreenHandlers(pConvTemplate, pPlayer, pNpc, selectedOption, pConvScreen)
	local screen = LuaConversationScreen(pConvScreen)
	local screenID = screen:getScreenID()
	local pClonedScreen = screen:cloneScreen()

	if (screenID == "s_50") then
		MtpQuestEngine.sendSignalAny(pPlayer, "foundMeatlumps")
		MtpWebTasks.grant(pPlayer, "mtp_camp_quest_corellia")
	elseif (screenID == "s_36") then
		MtpWebTasks.grant(pPlayer, "mtp_hideout_get_lunch")
	end

	return pClonedScreen
end
