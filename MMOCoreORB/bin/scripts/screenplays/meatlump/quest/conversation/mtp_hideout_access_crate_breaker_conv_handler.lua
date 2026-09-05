-- mtp_hideout_access_crate_breaker_conv_handler
-- ruling 2026-09-04
-- getInitialScreen is live condition order. runScreenHandlers fires grant / signal / turn-in.
-- No journal module: this branch has no managers/quest/journal.lua.

mtp_hideout_access_crate_breaker_conv_handler = conv_handler:new {}


function mtp_hideout_access_crate_breaker_conv_handler:getInitialScreen(pPlayer, pNpc, pConvTemplate)
	local convoTemplate = LuaConversationTemplate(pConvTemplate)

	if (MtpQuestEngine.isTaskActive(MtpQuestEngine.byName("mtp_hideout_access_01"), pPlayer, "mtp_hideout_access_01_06") or MtpQuestEngine.isTaskActive(MtpQuestEngine.byName("mtp_hideout_access_high_01"), pPlayer, "mtp_hideout_access_01_06")) then
		return convoTemplate:getScreen("s_4")
	end

	return convoTemplate:getScreen("s_28")
end

function mtp_hideout_access_crate_breaker_conv_handler:runScreenHandlers(pConvTemplate, pPlayer, pNpc, selectedOption, pConvScreen)
	local screen = LuaConversationScreen(pConvScreen)
	local screenID = screen:getScreenID()
	local pClonedScreen = screen:cloneScreen()

	if (screenID == "s_25" and pNpc ~= nil) then
		CreatureObject(pNpc):setPvpStatusBitmask(ATTACKABLE)
		CreatureObject(pNpc):clearOptionBit(INVULNERABLE)
		CreatureObject(pNpc):clearOptionBit(CONVERSABLE)

		if (SceneObject(pNpc):isAiAgent()) then
			AiAgent(pNpc):setDefender(pPlayer)
		end
	end

	return pClonedScreen
end
