-- mtp_hideout_safe_tech_conv_handler
-- ruling 2026-09-04
-- getInitialScreen is live condition order. runScreenHandlers fires grant / signal / turn-in.

mtp_hideout_safe_tech_conv_handler = conv_handler:new {}


function mtp_hideout_safe_tech_conv_handler:anyInfiltratorActive(pPlayer)
	for i = 1, 5 do
		if (MtpQuestEngine.isQuestActive(pPlayer, "mtp_find_infiltrator_" .. tostring(i))) then
			return true
		end
	end

	return false
end

function mtp_hideout_safe_tech_conv_handler:anyInfiltratorComplete(pPlayer)
	for i = 1, 5 do
		if (MtpQuestEngine.isQuestComplete(pPlayer, "mtp_find_infiltrator_" .. tostring(i))) then
			return true
		end
	end

	return false
end

function mtp_hideout_safe_tech_conv_handler:getInitialScreen(pPlayer, pNpc, pConvTemplate)
	local convoTemplate = LuaConversationTemplate(pConvTemplate)

	if (MtpQuestEngine.isQuestActiveOrComplete(pPlayer, "mtp_camp_quest_rori_talus")) then
		return convoTemplate:getScreen("s_46")
	elseif (self:anyInfiltratorActive(pPlayer)) then
		local returning = false

		for i = 1, 5 do
			if (MtpQuestEngine.isTaskActive(MtpQuestEngine.byName("mtp_find_infiltrator_" .. tostring(i)), pPlayer, "returnToLocksmith")) then
				returning = true
			end
		end

		if (returning) then
			return convoTemplate:getScreen("s_35")
		end

		return convoTemplate:getScreen("s_44")
	elseif (self:anyInfiltratorComplete(pPlayer) and not MtpQuestEngine.isQuestActiveOrComplete(pPlayer, "mtp_camp_quest_rori_talus")) then
		return convoTemplate:getScreen("s_35")
	elseif (not self:anyInfiltratorActive(pPlayer) and not self:anyInfiltratorComplete(pPlayer)) then
		return convoTemplate:getScreen("s_4")
	end

	return convoTemplate:getScreen("s_48")
end

function mtp_hideout_safe_tech_conv_handler:runScreenHandlers(pConvTemplate, pPlayer, pNpc, selectedOption, pConvScreen)
	local screen = LuaConversationScreen(pConvScreen)
	local screenID = screen:getScreenID()
	local pClonedScreen = screen:cloneScreen()

	if (screenID == "s_42") then
		MtpQuestEngine.sendSignalAny(pPlayer, "returnedToMeatlumpLocksmith")
		MtpWebTasks.grant(pPlayer, "mtp_camp_quest_rori_talus")
	elseif (screenID == "s_28") then
		local n = getRandomNumber(1, 5)
		MtpWebTasks.grant(pPlayer, "mtp_find_infiltrator_" .. tostring(n))
	end

	return pClonedScreen
end
