-- mtp_hideout_access_lieutenant_kaiya_conv_handler
-- ruling 2026-09-04
-- getInitialScreen is live condition order. runScreenHandlers fires grant / signal / turn-in.
-- No journal module: this branch has no managers/quest/journal.lua.

mtp_hideout_access_lieutenant_kaiya_conv_handler = conv_handler:new {}


function mtp_hideout_access_lieutenant_kaiya_conv_handler:getInitialScreen(pPlayer, pNpc, pConvTemplate)
	local convoTemplate = LuaConversationTemplate(pConvTemplate)

	if (MtpQuestEngine.hasCompletedTask(MtpQuestEngine.byName("mtp_hideout_access_07"), pPlayer, "mtp_hideout_access_07_03") or MtpQuestEngine.hasCompletedTask(MtpQuestEngine.byName("mtp_hideout_access_high_07"), pPlayer, "mtp_hideout_access_07_03")) then
		return convoTemplate:getScreen("s_33")
	elseif (MtpQuestEngine.isTaskActive(MtpQuestEngine.byName("mtp_hideout_access_07"), pPlayer, "mtp_hideout_access_07_03") or MtpQuestEngine.isTaskActive(MtpQuestEngine.byName("mtp_hideout_access_high_07"), pPlayer, "mtp_hideout_access_07_03")) then
		return convoTemplate:getScreen("s_11")
	elseif (MtpQuestEngine.isQuestActive(pPlayer, "mtp_hideout_access_07") or MtpQuestEngine.isQuestActive(pPlayer, "mtp_hideout_access_high_07")) then
		return convoTemplate:getScreen("s_10")
	elseif (MtpQuestEngine.isTaskActive(MtpQuestEngine.byName("mtp_hideout_access_06"), pPlayer, "mtp_hideout_access_06_02") or MtpQuestEngine.isQuestComplete(pPlayer, "mtp_hideout_access_06") or MtpQuestEngine.isTaskActive(MtpQuestEngine.byName("mtp_hideout_access_high_06"), pPlayer, "mtp_hideout_access_06_02") or MtpQuestEngine.isQuestComplete(pPlayer, "mtp_hideout_access_high_06")) then
		return convoTemplate:getScreen("s_13")
	elseif (MtpQuestEngine.isQuestActive(pPlayer, "mtp_hideout_access_06") or MtpQuestEngine.isQuestActive(pPlayer, "mtp_hideout_access_high_06")) then
		return convoTemplate:getScreen("s_28")
	elseif (MtpQuestEngine.isTaskActive(MtpQuestEngine.byName("mtp_hideout_access_05"), pPlayer, "mtp_hideout_access_05_02") or MtpQuestEngine.isQuestComplete(pPlayer, "mtp_hideout_access_05")) then
		return convoTemplate:getScreen("s_34")
	end

	return convoTemplate:getScreen("s_48")
end

function mtp_hideout_access_lieutenant_kaiya_conv_handler:runScreenHandlers(pConvTemplate, pPlayer, pNpc, selectedOption, pConvScreen)
	local screen = LuaConversationScreen(pConvScreen)
	local screenID = screen:getScreenID()
	local pClonedScreen = screen:cloneScreen()

	if (screenID == "s_32") then
		MtpQuestEngine.sendSignalAny(pPlayer, "mtp_hideout_access_07_03")
	elseif (screenID == "s_22") then
		MtpQuestEngine.sendSignalAny(pPlayer, "mtp_hideout_access_06_02")
	elseif (screenID == "s_26") then
		MtpQuestEngine.tierGrant(pPlayer, "mtp_hideout_access_07", "mtp_hideout_access_high_07")
	elseif (screenID == "s_38") then
		MtpQuestEngine.sendSignalAny(pPlayer, "mtp_hideout_access_05_02")
	elseif (screenID == "s_46") then
		MtpQuestEngine.tierGrant(pPlayer, "mtp_hideout_access_06", "mtp_hideout_access_high_06")
	end

	return pClonedScreen
end
