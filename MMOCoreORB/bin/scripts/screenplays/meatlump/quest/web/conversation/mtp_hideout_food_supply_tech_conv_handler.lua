-- mtp_hideout_food_supply_tech_conv_handler
-- ruling 2026-09-04
-- getInitialScreen is live condition order. runScreenHandlers fires grant / signal / turn-in.

mtp_hideout_food_supply_tech_conv_handler = conv_handler:new {}


function mtp_hideout_food_supply_tech_conv_handler:getInitialScreen(pPlayer, pNpc, pConvTemplate)
	local convoTemplate = LuaConversationTemplate(pConvTemplate)

	if (MtpQuestEngine.isQuestActiveOrComplete(pPlayer, "mtp_camp_quest_tatooine") and MtpQuestEngine.isQuestComplete(pPlayer, "mtp_hideout_ragtag")) then
		return convoTemplate:getScreen("s_72")
	elseif (MtpQuestEngine.isQuestActive(pPlayer, "mtp_hideout_ragtag_fail")) then
		return convoTemplate:getScreen("s_69")
	elseif (MtpQuestEngine.isQuestComplete(pPlayer, "mtp_hideout_ragtag") and not MtpQuestEngine.isQuestActiveOrComplete(pPlayer, "mtp_camp_quest_tatooine")) then
		return convoTemplate:getScreen("s_56")
	elseif (MtpQuestEngine.isQuestActive(pPlayer, "mtp_hideout_ragtag")) then
		return convoTemplate:getScreen("s_51")
	elseif (not MtpQuestEngine.isQuestActiveOrComplete(pPlayer, "mtp_hideout_ragtag") and not MtpQuestEngine.isQuestActiveOrComplete(pPlayer, "mtp_camp_quest_tatooine")) then
		return convoTemplate:getScreen("s_7")
	end

	return convoTemplate:getScreen("s_74")
end

function mtp_hideout_food_supply_tech_conv_handler:runScreenHandlers(pConvTemplate, pPlayer, pNpc, selectedOption, pConvScreen)
	local screen = LuaConversationScreen(pConvScreen)
	local screenID = screen:getScreenID()
	local pClonedScreen = screen:cloneScreen()

	if (screenID == "s_71") then
		MtpQuestEngine.sendSignalAny(pPlayer, "beatUpComplete")
		MtpWebTasks.grant(pPlayer, "mtp_hideout_ragtag")
	elseif (screenID == "s_60") then
		MtpQuestEngine.sendSignalAny(pPlayer, "spokeToClerk")
		MtpWebTasks.grant(pPlayer, "mtp_camp_quest_tatooine")
	elseif (screenID == "s_51") then
		if (not MtpQuestEngine.isQuestActiveOrComplete(pPlayer, "mtp_hideout_ragtag")) then
			MtpWebTasks.grant(pPlayer, "mtp_hideout_ragtag")
		end
	end

	return pClonedScreen
end
