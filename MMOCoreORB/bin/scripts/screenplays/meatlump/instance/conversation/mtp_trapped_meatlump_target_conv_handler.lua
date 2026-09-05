-- mtp_trapped_meatlump_target_conv_handler
-- ruling 2026-09-04
-- getInitialScreen is live condition order. runScreenHandlers fires grant / signal / turn-in.
-- No journal module: this branch has no managers/quest/journal.lua.

mtp_trapped_meatlump_target_conv_handler = conv_handler:new {}


function mtp_trapped_meatlump_target_conv_handler:getInitialScreen(pPlayer, pNpc, pConvTemplate)
	local convoTemplate = LuaConversationTemplate(pConvTemplate)

	if (not MtpQuestEngine.isQuestActive(pPlayer, "mtp_hideout_instance_escort_trapped_meatlump")) then
		return convoTemplate:getScreen("s_16")
	end

	if (MtpQuestEngine.isTaskActive(MtpQuestEngine.byName("mtp_hideout_instance_escort_trapped_meatlump"), pPlayer, "escort_trapped_meatlump")) then
		if (pNpc ~= nil and readData(SceneObject(pNpc):getObjectID() .. ":mtpEscortFollow") == 1) then
			return convoTemplate:getScreen("s_10")
		end

		return convoTemplate:getScreen("s_11")
	end

	return convoTemplate:getScreen("s_16")
end

function mtp_trapped_meatlump_target_conv_handler:runScreenHandlers(pConvTemplate, pPlayer, pNpc, selectedOption, pConvScreen)
	local screen = LuaConversationScreen(pConvScreen)
	local screenID = screen:getScreenID()
	local pClonedScreen = screen:cloneScreen()

	if ((screenID == "s_13" or screenID == "s_24") and pNpc ~= nil) then
		MtpHideoutInstance:startEscort(pPlayer, pNpc)
	end

	return pClonedScreen
end
