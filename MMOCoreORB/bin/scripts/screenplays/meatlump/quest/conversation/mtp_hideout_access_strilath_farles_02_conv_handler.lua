-- mtp_hideout_access_strilath_farles_02_conv_handler
-- ruling 2026-09-04
-- getInitialScreen is live condition order. runScreenHandlers fires grant / signal / turn-in.
-- No journal module: this branch has no managers/quest/journal.lua.

mtp_hideout_access_strilath_farles_02_conv_handler = conv_handler:new {}


function mtp_hideout_access_strilath_farles_02_conv_handler:getInitialScreen(pPlayer, pNpc, pConvTemplate)
	local convoTemplate = LuaConversationTemplate(pConvTemplate)

	if (MtpQuestEngine.hasCompletedTask(MtpQuestEngine.byName("mtp_hideout_access_04"), pPlayer, "mtp_hideout_access_04_03") or MtpQuestEngine.hasCompletedTask(MtpQuestEngine.byName("mtp_hideout_access_high_04"), pPlayer, "mtp_hideout_access_04_03")) then
		return convoTemplate:getScreen("s_4")
	elseif (MtpQuestEngine.isTaskActive(MtpQuestEngine.byName("mtp_hideout_access_04"), pPlayer, "mtp_hideout_access_04_03") or MtpQuestEngine.isTaskActive(MtpQuestEngine.byName("mtp_hideout_access_high_04"), pPlayer, "mtp_hideout_access_04_03")) then
		if (pNpc ~= nil) then
			local owner = readData(SceneObject(pNpc):getObjectID() .. ":mtpWavePlayer")

			if (owner ~= 0 and owner ~= SceneObject(pPlayer):getObjectID()) then
				return convoTemplate:getScreen("s_28")
			end
		end

		return convoTemplate:getScreen("s_29")
	elseif ((MtpQuestEngine.isQuestComplete(pPlayer, "mtp_hideout_access_03") and not MtpQuestEngine.isQuestActiveOrComplete(pPlayer, "mtp_hideout_access_04")) or (MtpQuestEngine.isQuestComplete(pPlayer, "mtp_hideout_access_high_03") and not MtpQuestEngine.isQuestActiveOrComplete(pPlayer, "mtp_hideout_access_high_04"))) then
		return convoTemplate:getScreen("s_25")
	end

	return convoTemplate:getScreen("s_28")
end

function mtp_hideout_access_strilath_farles_02_conv_handler:runScreenHandlers(pConvTemplate, pPlayer, pNpc, selectedOption, pConvScreen)
	local screen = LuaConversationScreen(pConvScreen)
	local screenID = screen:getScreenID()
	local pClonedScreen = screen:cloneScreen()

	if (screenID == "s_48") then
		MtpQuestEngine.sendSignalAny(pPlayer, "mtp_hideout_access_04_03")
	elseif (screenID == "s_25") then
		MtpQuestEngine.sendSignalAny(pPlayer, "mtp_hideout_access_04_pointer")
		MtpQuestEngine.tierGrant(pPlayer, "mtp_hideout_access_04", "mtp_hideout_access_high_04")
	elseif (screenID == "s_19" or screenID == "s_23") then
		if (pNpc ~= nil) then
			playClientEffectLoc(pPlayer, "appearance/pt_smoke_puff_noloop.prt", SceneObject(pNpc):getZoneName(), SceneObject(pNpc):getWorldPositionX(), SceneObject(pNpc):getWorldPositionZ(), SceneObject(pNpc):getWorldPositionY(), 0)
			SceneObject(pNpc):destroyObjectFromWorld()
		end
	end

	return pClonedScreen
end
