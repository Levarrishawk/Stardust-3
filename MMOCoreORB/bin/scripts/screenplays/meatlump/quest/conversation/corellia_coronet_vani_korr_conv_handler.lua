-- corellia_coronet_vani_korr_conv_handler
-- ruling 2026-09-04
-- getInitialScreen is live condition order. runScreenHandlers fires grant / signal / turn-in.
-- No journal module: this branch has no managers/quest/journal.lua.

corellia_coronet_vani_korr_conv_handler = conv_handler:new {}


function corellia_coronet_vani_korr_conv_handler:getInitialScreen(pPlayer, pNpc, pConvTemplate)
	local convoTemplate = LuaConversationTemplate(pConvTemplate)

	-- Access-chain order from OnStartNpcConversation. Act 1 is OPEN on this branch.
	if (MtpQuestEngine.isTaskActive(MtpQuestEngine.byName("mtp_hideout_access_07"), pPlayer, "mtp_hideout_access_07_04") or MtpQuestEngine.isQuestComplete(pPlayer, "mtp_hideout_access_07") or MtpQuestEngine.isTaskActive(MtpQuestEngine.byName("mtp_hideout_access_high_07"), pPlayer, "mtp_hideout_access_07_04") or MtpQuestEngine.isQuestComplete(pPlayer, "mtp_hideout_access_high_07")) then
		if (MtpQuestEngine.isQuestComplete(pPlayer, "mtp_hideout_access_07") or MtpQuestEngine.isQuestComplete(pPlayer, "mtp_hideout_access_high_07")) then
			return convoTemplate:getScreen("s_191")
		end

		return convoTemplate:getScreen("s_161")
	elseif (MtpQuestEngine.isQuestActive(pPlayer, "mtp_hideout_access_07") or MtpQuestEngine.isQuestActive(pPlayer, "mtp_hideout_access_high_07")) then
		return convoTemplate:getScreen("s_160")
	elseif (MtpQuestEngine.isQuestActive(pPlayer, "mtp_hideout_access_06") or MtpQuestEngine.isQuestActive(pPlayer, "mtp_hideout_access_high_06")) then
		return convoTemplate:getScreen("s_159")
	elseif (MtpQuestEngine.isQuestActive(pPlayer, "mtp_hideout_access_05")) then
		return convoTemplate:getScreen("s_158")
	elseif (MtpQuestEngine.isTaskActive(MtpQuestEngine.byName("mtp_hideout_access_04"), pPlayer, "mtp_hideout_access_04_04") or MtpQuestEngine.isQuestComplete(pPlayer, "mtp_hideout_access_04") or MtpQuestEngine.isTaskActive(MtpQuestEngine.byName("mtp_hideout_access_high_04"), pPlayer, "mtp_hideout_access_04_04") or MtpQuestEngine.isQuestComplete(pPlayer, "mtp_hideout_access_high_04")) then
		if (MtpQuestEngine.isQuestComplete(pPlayer, "mtp_hideout_access_04") or MtpQuestEngine.isQuestComplete(pPlayer, "mtp_hideout_access_high_04")) then
			return convoTemplate:getScreen("s_152")
		end

		return convoTemplate:getScreen("s_152")
	elseif (MtpQuestEngine.isQuestActive(pPlayer, "mtp_hideout_access_04") or MtpQuestEngine.isQuestActive(pPlayer, "mtp_hideout_access_high_04")) then
		return convoTemplate:getScreen("s_153")
	elseif ((MtpQuestEngine.isQuestComplete(pPlayer, "mtp_hideout_access_03") and not MtpQuestEngine.isQuestActiveOrComplete(pPlayer, "mtp_hideout_access_04")) or (MtpQuestEngine.isQuestComplete(pPlayer, "mtp_hideout_access_high_03") and not MtpQuestEngine.isQuestActiveOrComplete(pPlayer, "mtp_hideout_access_high_04"))) then
		return convoTemplate:getScreen("s_195")
	elseif (MtpQuestEngine.isQuestActive(pPlayer, "mtp_hideout_access_03") or MtpQuestEngine.isQuestActive(pPlayer, "mtp_hideout_access_high_03")) then
		return convoTemplate:getScreen("s_151")
	elseif (MtpQuestEngine.isTaskActive(MtpQuestEngine.byName("mtp_hideout_access_02"), pPlayer, "mtp_hideout_access_02_04") or MtpQuestEngine.isQuestComplete(pPlayer, "mtp_hideout_access_02")) then
		return convoTemplate:getScreen("s_146")
	elseif (MtpQuestEngine.isQuestActive(pPlayer, "mtp_hideout_access_02")) then
		return convoTemplate:getScreen("s_145")
	elseif (MtpQuestEngine.isTaskActive(MtpQuestEngine.byName("mtp_hideout_access_01"), pPlayer, "mtp_hideout_access_01_07") or MtpQuestEngine.isQuestComplete(pPlayer, "mtp_hideout_access_01") or MtpQuestEngine.isTaskActive(MtpQuestEngine.byName("mtp_hideout_access_high_01"), pPlayer, "mtp_hideout_access_01_07") or MtpQuestEngine.isQuestComplete(pPlayer, "mtp_hideout_access_high_01")) then
		return convoTemplate:getScreen("s_142")
	elseif (MtpQuestEngine.isQuestActive(pPlayer, "mtp_hideout_access_01") or MtpQuestEngine.isQuestActive(pPlayer, "mtp_hideout_access_high_01")) then
		return convoTemplate:getScreen("s_141")
	elseif (MtpQuestEngine.playerLevel(pPlayer) >= 55) then
		-- OPEN: shipped gate is act1_end AND level >= 55. Act 1 is not on this branch.
		return convoTemplate:getScreen("s_135")
	end

	return convoTemplate:getScreen("s_37")
end

function corellia_coronet_vani_korr_conv_handler:runScreenHandlers(pConvTemplate, pPlayer, pNpc, selectedOption, pConvScreen)
	local screen = LuaConversationScreen(pConvScreen)
	local screenID = screen:getScreenID()
	local pClonedScreen = screen:cloneScreen()

	if (screenID == "s_161") then
		MtpQuestEngine.sendSignalAny(pPlayer, "mtp_hideout_access_07_04")
	elseif (screenID == "s_152") then
		MtpQuestEngine.sendSignalAny(pPlayer, "mtp_hideout_access_04_04")
	elseif (screenID == "s_155") then
		MtpQuestEngine.grantByName(pPlayer, "mtp_hideout_access_05")
	elseif (screenID == "s_195") then
		if (not MtpQuestEngine.isQuestActive(pPlayer, "mtp_hideout_access_04_pointer")) then
			MtpQuestEngine.grantByName(pPlayer, "mtp_hideout_access_04_pointer")
		end
	elseif (screenID == "s_146") then
		MtpQuestEngine.sendSignalAny(pPlayer, "mtp_hideout_access_02_04")
	elseif (screenID == "s_150") then
		MtpQuestEngine.tierGrant(pPlayer, "mtp_hideout_access_03", "mtp_hideout_access_high_03")
	elseif (screenID == "s_142") then
		MtpQuestEngine.sendSignalAny(pPlayer, "mtp_hideout_access_01_07")
	elseif (screenID == "s_144") then
		MtpQuestEngine.grantByName(pPlayer, "mtp_hideout_access_02")
	elseif (screenID == "s_140") then
		MtpQuestEngine.tierGrant(pPlayer, "mtp_hideout_access_01", "mtp_hideout_access_high_01")
	end

	return pClonedScreen
end
