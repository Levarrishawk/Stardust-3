-- mtp_ragtag_ames_missd_conv_handler
-- ruling 2026-09-04
-- getInitialScreen is live condition order. runScreenHandlers fires grant / signal / turn-in.

mtp_ragtag_ames_missd_conv_handler = conv_handler:new {}


function mtp_ragtag_ames_missd_conv_handler:getInitialScreen(pPlayer, pNpc, pConvTemplate)
	local convoTemplate = LuaConversationTemplate(pConvTemplate)
	local rag = MtpQuestEngine.byName("mtp_hideout_ragtag")

	if (MtpQuestEngine.isTaskActive(rag, pPlayer, "speakAmesBoxDone")) then
		return convoTemplate:getScreen("s_75")
	elseif (MtpQuestEngine.isTaskActive(rag, pPlayer, "speakAmesAnitaDone")) then
		return convoTemplate:getScreen("s_72")
	elseif (MtpQuestEngine.isTaskActive(rag, pPlayer, "beatUpRagTag")) then
		return convoTemplate:getScreen("s_6")
	end

	return convoTemplate:getScreen("s_35")
end

function mtp_ragtag_ames_missd_conv_handler:runScreenHandlers(pConvTemplate, pPlayer, pNpc, selectedOption, pConvScreen)
	local screen = LuaConversationScreen(pConvScreen)
	local screenID = screen:getScreenID()
	local pClonedScreen = screen:cloneScreen()

	if (screenID == "s_62") then
		MtpQuestEngine.sendSignalAny(pPlayer, "fightAnita")
	elseif (screenID == "s_74") then
		MtpQuestEngine.sendSignalAny(pPlayer, "fightBox")
	elseif (screenID == "s_77") then
		MtpQuestEngine.sendSignalAny(pPlayer, "spokenAmes")
	end

	return pClonedScreen
end
