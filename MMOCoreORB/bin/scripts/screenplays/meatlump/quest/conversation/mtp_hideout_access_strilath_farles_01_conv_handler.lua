-- mtp_hideout_access_strilath_farles_01_conv_handler
-- ruling 2026-09-04
-- getInitialScreen is live condition order. runScreenHandlers fires grant / signal / turn-in.
-- No journal module: this branch has no managers/quest/journal.lua.

mtp_hideout_access_strilath_farles_01_conv_handler = conv_handler:new {}


function mtp_hideout_access_strilath_farles_01_conv_handler:getInitialScreen(pPlayer, pNpc, pConvTemplate)
	local convoTemplate = LuaConversationTemplate(pConvTemplate)

	if (MtpQuestEngine.isQuestComplete(pPlayer, "mtp_hideout_access_03") or MtpQuestEngine.isQuestActive(pPlayer, "mtp_hideout_access_04") or MtpQuestEngine.isQuestComplete(pPlayer, "mtp_hideout_access_high_03") or MtpQuestEngine.isQuestActive(pPlayer, "mtp_hideout_access_high_04")) then
		return convoTemplate:getScreen("s_4")
	elseif (MtpQuestEngine.isTaskActive(MtpQuestEngine.byName("mtp_hideout_access_03"), pPlayer, "mtp_hideout_access_03_04") or MtpQuestEngine.isTaskActive(MtpQuestEngine.byName("mtp_hideout_access_high_03"), pPlayer, "mtp_hideout_access_03_04")) then
		if (pNpc ~= nil) then
			local owner = readData(SceneObject(pNpc):getObjectID() .. ":mtpWavePlayer")

			if (owner ~= 0 and owner ~= SceneObject(pPlayer):getObjectID()) then
				return convoTemplate:getScreen("s_28")
			end
		end

		return convoTemplate:getScreen("s_29")
	end

	return convoTemplate:getScreen("s_28")
end

function mtp_hideout_access_strilath_farles_01_conv_handler:runScreenHandlers(pConvTemplate, pPlayer, pNpc, selectedOption, pConvScreen)
	local screen = LuaConversationScreen(pConvScreen)
	local screenID = screen:getScreenID()
	local pClonedScreen = screen:cloneScreen()

	if (screenID == "s_29") then
		MtpQuestEngine.sendSignalAny(pPlayer, "mtp_hideout_access_03_04")
	elseif (screenID == "s_46") then
		MtpQuestEngine.tierGrant(pPlayer, "mtp_hideout_access_04", "mtp_hideout_access_high_04")

		if (pNpc ~= nil) then
			createEvent(7000, "mtpHideoutAccessGiversScreenPlay", "despawnNpc", pNpc, "")
		end
	elseif (screenID == "s_4") then
		if (MtpQuestEngine.playerLevel(pPlayer) >= MtpQuestEngine.TIER_LEVEL) then
			if (not MtpQuestEngine.isQuestActiveOrComplete(pPlayer, "mtp_hideout_access_high_04")) then
				MtpQuestEngine.grantByName(pPlayer, "mtp_hideout_access_high_04")
			end
		else
			if (not MtpQuestEngine.isQuestActiveOrComplete(pPlayer, "mtp_hideout_access_04")) then
				MtpQuestEngine.grantByName(pPlayer, "mtp_hideout_access_04")
			end
		end
	end

	return pClonedScreen
end
