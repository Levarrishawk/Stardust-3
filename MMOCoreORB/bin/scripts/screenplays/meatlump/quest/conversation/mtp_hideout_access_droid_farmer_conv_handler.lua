-- mtp_hideout_access_droid_farmer_conv_handler
-- ruling 2026-09-04
-- getInitialScreen is live condition order. runScreenHandlers fires grant / signal / turn-in.
-- No journal module: this branch has no managers/quest/journal.lua.

mtp_hideout_access_droid_farmer_conv_handler = conv_handler:new {}


function mtp_hideout_access_droid_farmer_conv_handler:getInitialScreen(pPlayer, pNpc, pConvTemplate)
	local convoTemplate = LuaConversationTemplate(pConvTemplate)
	local sp = MtpQuestEngine.byName("mtp_hideout_access_02")

	if (MtpQuestEngine.isTaskActive(sp, pPlayer, "mtp_hideout_access_02_03") or MtpQuestEngine.hasCompletedTask(sp, pPlayer, "mtp_hideout_access_02_03")) then
		return convoTemplate:getScreen("s_4")
	elseif (MtpQuestEngine.isTaskActive(sp, pPlayer, "mtp_hideout_access_02_01")) then
		return convoTemplate:getScreen("s_29")
	end

	return convoTemplate:getScreen("s_28")
end

function mtp_hideout_access_droid_farmer_conv_handler:runScreenHandlers(pConvTemplate, pPlayer, pNpc, selectedOption, pConvScreen)
	local screen = LuaConversationScreen(pConvScreen)
	local screenID = screen:getScreenID()
	local pClonedScreen = screen:cloneScreen()

	if (screenID == "s_35") then
		MtpQuestEngine.sendSignalAny(pPlayer, "mtp_hideout_access_02_01")
	elseif (screenID == "s_39" or screenID == "s_41" or screenID == "s_43" or screenID == "s_45") then
		MtpQuestEngine.sendSignalAny(pPlayer, "mtp_hideout_access_02_03")
	end

	return pClonedScreen
end
