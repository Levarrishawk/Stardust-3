-- mtp_hideout_access_bike_racer_conv_handler
-- ruling 2026-09-04
-- getInitialScreen is live condition order. runScreenHandlers fires grant / signal / turn-in.
-- No journal module: this branch has no managers/quest/journal.lua.

mtp_hideout_access_bike_racer_conv_handler = conv_handler:new {}


function mtp_hideout_access_bike_racer_conv_handler:getInitialScreen(pPlayer, pNpc, pConvTemplate)
	local convoTemplate = LuaConversationTemplate(pConvTemplate)

	if (MtpQuestEngine.hasCompletedTask(MtpQuestEngine.byName("mtp_hideout_access_03"), pPlayer, "mtp_hideout_access_03_01") or MtpQuestEngine.hasCompletedTask(MtpQuestEngine.byName("mtp_hideout_access_high_03"), pPlayer, "mtp_hideout_access_03_01")) then
		return convoTemplate:getScreen("s_4")
	elseif (MtpQuestEngine.isTaskActive(MtpQuestEngine.byName("mtp_hideout_access_03"), pPlayer, "mtp_hideout_access_03_01") or MtpQuestEngine.isTaskActive(MtpQuestEngine.byName("mtp_hideout_access_high_03"), pPlayer, "mtp_hideout_access_03_01")) then
		return convoTemplate:getScreen("s_29")
	end

	return convoTemplate:getScreen("s_28")
end

function mtp_hideout_access_bike_racer_conv_handler:runScreenHandlers(pConvTemplate, pPlayer, pNpc, selectedOption, pConvScreen)
	local screen = LuaConversationScreen(pConvScreen)
	local screenID = screen:getScreenID()
	local pClonedScreen = screen:cloneScreen()

	if (screenID == "s_24") then
		MtpQuestEngine.sendSignalAny(pPlayer, "mtp_hideout_access_03_01")
	end

	return pClonedScreen
end
