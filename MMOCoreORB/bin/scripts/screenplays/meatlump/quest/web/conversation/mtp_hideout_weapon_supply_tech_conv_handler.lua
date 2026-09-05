-- mtp_hideout_weapon_supply_tech_conv_handler
-- ruling 2026-09-04
-- getInitialScreen is live condition order. runScreenHandlers fires grant / signal / turn-in.

mtp_hideout_weapon_supply_tech_conv_handler = conv_handler:new {}


function mtp_hideout_weapon_supply_tech_conv_handler:getInitialScreen(pPlayer, pNpc, pConvTemplate)
	local convoTemplate = LuaConversationTemplate(pConvTemplate)

	if (MtpQuestEngine.isQuestActiveOrComplete(pPlayer, "mtp_camp_quest_naboo")) then
		return convoTemplate:getScreen("s_39")
	elseif (MtpQuestEngine.isQuestComplete(pPlayer, "mtp_hideout_retrieve_delivery") and not MtpQuestEngine.isQuestActiveOrComplete(pPlayer, "mtp_camp_quest_naboo")) then
		return convoTemplate:getScreen("s_23")
	elseif (MtpQuestEngine.isTaskActive(MtpQuestEngine.byName("mtp_hideout_retrieve_delivery"), pPlayer, "seeArmorer")) then
		return convoTemplate:getScreen("s_23")
	elseif (MtpQuestEngine.isQuestActive(pPlayer, "mtp_hideout_retrieve_delivery")) then
		return convoTemplate:getScreen("s_49")
	elseif (not MtpQuestEngine.isQuestActiveOrComplete(pPlayer, "mtp_hideout_retrieve_delivery")) then
		return convoTemplate:getScreen("s_5")
	end

	return convoTemplate:getScreen("s_50")
end

function mtp_hideout_weapon_supply_tech_conv_handler:runScreenHandlers(pConvTemplate, pPlayer, pNpc, selectedOption, pConvScreen)
	local screen = LuaConversationScreen(pConvScreen)
	local screenID = screen:getScreenID()
	local pClonedScreen = screen:cloneScreen()

	if (screenID == "s_35") then
		MtpQuestEngine.sendSignalAny(pPlayer, "spokenToArmorer")
		MtpWebTasks.grant(pPlayer, "mtp_camp_quest_naboo")
	elseif (screenID == "s_17") then
		MtpWebTasks.grant(pPlayer, "mtp_hideout_retrieve_delivery")
	end

	return pClonedScreen
end
