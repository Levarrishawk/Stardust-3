-- mtp_hideout_bomb_tech_conv_handler
-- ruling 2026-09-04
-- getInitialScreen is live condition order. runScreenHandlers fires grant / signal / turn-in.

mtp_hideout_bomb_tech_conv_handler = conv_handler:new {}


function mtp_hideout_bomb_tech_conv_handler:getInitialScreen(pPlayer, pNpc, pConvTemplate)
	local convoTemplate = LuaConversationTemplate(pConvTemplate)

	if (MtpQuestEngine.isQuestActiveOrComplete(pPlayer, "mtp_camp_quest_lok")) then
		return convoTemplate:getScreen("s_94")
	elseif (MtpQuestEngine.isTaskActive(MtpQuestEngine.byName("mtp_hideout_collect_bomb_items"), pPlayer, "returnTechnician")) then
		return convoTemplate:getScreen("s_58")
	elseif (MtpQuestEngine.isQuestActive(pPlayer, "mtp_hideout_collect_bomb_items")) then
		return convoTemplate:getScreen("s_68")
	elseif (not MtpQuestEngine.isQuestActiveOrComplete(pPlayer, "mtp_hideout_collect_bomb_items")) then
		return convoTemplate:getScreen("s_4")
	end

	return convoTemplate:getScreen("s_100")
end

function mtp_hideout_bomb_tech_conv_handler:runScreenHandlers(pConvTemplate, pPlayer, pNpc, selectedOption, pConvScreen)
	local screen = LuaConversationScreen(pConvScreen)
	local screenID = screen:getScreenID()
	local pClonedScreen = screen:cloneScreen()

	if (screenID == "s_62") then
		MtpQuestEngine.sendSignalAny(pPlayer, "spokeToTechnician")
		MtpWebTasks.grant(pPlayer, "mtp_camp_quest_lok")
	elseif (screenID == "s_33") then
		MtpWebTasks.grant(pPlayer, "mtp_hideout_collect_bomb_items")
	end

	return pClonedScreen
end
