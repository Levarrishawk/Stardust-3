-- mtp_hideout_access_crate_maker_conv_handler
-- ruling 2026-09-04
-- getInitialScreen is live condition order. runScreenHandlers fires grant / signal / turn-in.
-- No journal module: this branch has no managers/quest/journal.lua.

mtp_hideout_access_crate_maker_conv_handler = conv_handler:new {}


function mtp_hideout_access_crate_maker_conv_handler:getInitialScreen(pPlayer, pNpc, pConvTemplate)
	local convoTemplate = LuaConversationTemplate(pConvTemplate)
	local sp01 = MtpQuestEngine.byName("mtp_hideout_access_01")
	local spH = MtpQuestEngine.byName("mtp_hideout_access_high_01")

	if ((MtpQuestEngine.isTaskActive(sp01, pPlayer, "mtp_hideout_access_01_07") and not MtpQuestEngine.isQuestComplete(pPlayer, "mtp_hideout_access_01")) or (MtpQuestEngine.isTaskActive(spH, pPlayer, "mtp_hideout_access_01_07") and not MtpQuestEngine.isQuestComplete(pPlayer, "mtp_hideout_access_high_01"))) then
		return convoTemplate:getScreen("s_8")
	elseif ((MtpQuestEngine.hasCompletedTask(sp01, pPlayer, "mtp_hideout_access_01_04") and not MtpQuestEngine.hasCompletedTask(sp01, pPlayer, "mtp_hideout_access_01_06")) or (MtpQuestEngine.hasCompletedTask(spH, pPlayer, "mtp_hideout_access_01_04") and not MtpQuestEngine.hasCompletedTask(spH, pPlayer, "mtp_hideout_access_01_06"))) then
		return convoTemplate:getScreen("s_7")
	elseif ((MtpQuestEngine.hasCompletedTask(sp01, pPlayer, "mtp_hideout_access_01_02") and not MtpQuestEngine.hasCompletedTask(sp01, pPlayer, "mtp_hideout_access_01_04")) or (MtpQuestEngine.hasCompletedTask(spH, pPlayer, "mtp_hideout_access_01_02") and not MtpQuestEngine.hasCompletedTask(spH, pPlayer, "mtp_hideout_access_01_04"))) then
		return convoTemplate:getScreen("s_6")
	elseif ((MtpQuestEngine.hasCompletedTask(sp01, pPlayer, "mtp_hideout_access_01_01") and MtpQuestEngine.isTaskActive(sp01, pPlayer, "mtp_hideout_access_01_02")) or (MtpQuestEngine.hasCompletedTask(spH, pPlayer, "mtp_hideout_access_01_01") and MtpQuestEngine.isTaskActive(spH, pPlayer, "mtp_hideout_access_01_02"))) then
		return convoTemplate:getScreen("s_10")
	elseif (MtpQuestEngine.isTaskActive(sp01, pPlayer, "mtp_hideout_access_01_01") or MtpQuestEngine.isTaskActive(spH, pPlayer, "mtp_hideout_access_01_01")) then
		return convoTemplate:getScreen("s_12")
	end

	return convoTemplate:getScreen("s_26")
end

function mtp_hideout_access_crate_maker_conv_handler:runScreenHandlers(pConvTemplate, pPlayer, pNpc, selectedOption, pConvScreen)
	local screen = LuaConversationScreen(pConvScreen)
	local screenID = screen:getScreenID()
	local pClonedScreen = screen:cloneScreen()

	if (screenID == "s_24") then
		MtpQuestEngine.sendSignalAny(pPlayer, "mtp_hideout_access_01_01")
	end

	return pClonedScreen
end
