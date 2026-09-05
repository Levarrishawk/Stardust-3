-- mtp_corsec_intelligence_officer_conv_handler
-- ruling 2026-09-04
-- getInitialScreen is live condition order. runScreenHandlers fires grant / signal / turn-in.

mtp_corsec_intelligence_officer_conv_handler = conv_handler:new {}


function mtp_corsec_intelligence_officer_conv_handler:getInitialScreen(pPlayer, pNpc, pConvTemplate)
	local convoTemplate = LuaConversationTemplate(pConvTemplate)

	-- SOURCED: OnStartNpcConversation has only _defaultCondition and always starts s_3.
	return convoTemplate:getScreen("s_3")
end

function mtp_corsec_intelligence_officer_conv_handler:runScreenHandlers(pConvTemplate, pPlayer, pNpc, selectedOption, pConvScreen)
	local screen = LuaConversationScreen(pConvScreen)
	local screenID = screen:getScreenID()
	local pClonedScreen = screen:cloneScreen()

	-- SOURCED: no grantQuest / sendSignal on any screen.

	-- OURS: the conversation never grants intro/safe or fires corSecIntelligenceOfficerMet,
	-- so both quests are unreachable. Grant intro on the greeting if it is not already
	-- active or complete. At s_17 fire the intro signal and grant the safe quest once.
	-- OPEN: safe minigame / collection slots until the collections branch merges.
	if (screenID == "s_3") then
		if (not MtpQuestEngine.isQuestActiveOrComplete(pPlayer, "mtp_corsec_intelligence_officer_intro")) then
			MtpWebTasks.grant(pPlayer, "mtp_corsec_intelligence_officer_intro")
		end
	elseif (screenID == "s_17") then
		MtpQuestEngine.sendSignalAny(pPlayer, "corSecIntelligenceOfficerMet")

		if (not MtpQuestEngine.isQuestActiveOrComplete(pPlayer, "mtp_corsec_intelligence_officer_safe")) then
			MtpWebTasks.grant(pPlayer, "mtp_corsec_intelligence_officer_safe")
		end
	end

	return pClonedScreen
end
