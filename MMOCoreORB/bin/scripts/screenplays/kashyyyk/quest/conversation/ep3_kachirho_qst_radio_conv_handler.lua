-- Lisum's radio -- ep3_kachirho_destroyed_camp. String table is conversation/destroyed_camp_radio (not in the 370-row dump; shipped java c_stringFile).
-- ruling 2026-09-04: "ensure kashyyyk is done in full"
-- getInitialScreen is live condition order. runScreenHandlers fires grant / signal / turn-in.
-- No Journal.*: this branch has no managers/quest/journal.lua.

ep3_kachirho_qst_radio_conv_handler = conv_handler:new {}

ep3_kachirho_qst_radio_conv_handler.screenAnimations = {
}

function ep3_kachirho_qst_radio_conv_handler:stage(pPlayer)
	return kachirhoDestroyedCampScreenPlay:getStage(pPlayer)
end

function ep3_kachirho_qst_radio_conv_handler:getInitialScreen(pPlayer, pNpc, pConvTemplate)
	local convoTemplate = LuaConversationTemplate(pConvTemplate)

	-- Stages: 1 drum, 2 huntResearchers, 3 bag, 4 huntCanopy, 5 kill, 6 codeReceived, 7 codeEntered.
	if (self:stage(pPlayer) == 0 and kachirhoDestroyedCampScreenPlay:getRuns(pPlayer) > 0) then
		return convoTemplate:getScreen("s_407")
	elseif (self:stage(pPlayer) == 7) then
		return convoTemplate:getScreen("s_413")
	elseif (self:stage(pPlayer) == 6) then
		return convoTemplate:getScreen("s_409")
	elseif (self:stage(pPlayer) == 4) then
		return convoTemplate:getScreen("s_415")
	elseif (self:stage(pPlayer) == 2) then
		return convoTemplate:getScreen("s_441")
	elseif (self:stage(pPlayer) > 0) then
		return convoTemplate:getScreen("s_104")
	end

	return convoTemplate:getScreen("s_467")
end

function ep3_kachirho_qst_radio_conv_handler:runScreenHandlers(pConvTemplate, pPlayer, pNpc, selectedOption, pConvScreen)
	local screen = LuaConversationScreen(pConvScreen)
	local screenID = screen:getScreenID()
	local pClonedScreen = screen:cloneScreen()
	local clonedConversation = LuaConversationScreen(pClonedScreen)

	if (self.screenAnimations ~= nil and self.screenAnimations[screenID] ~= nil and pNpc ~= nil) then
		CreatureObject(pNpc):doAnimation(self.screenAnimations[screenID])
	end

	if (screenID == "s_413") then
		kachirhoDestroyedCampScreenPlay:signalCodeReceived(pPlayer)
		kachirhoDestroyedCampScreenPlay:signalCodeEntered(pPlayer)
	elseif (screenID == "s_76") then
		kachirhoDestroyedCampScreenPlay:signalHuntCanopy(pPlayer)
	elseif (screenID == "s_461") then
		kachirhoDestroyedCampScreenPlay:signalHuntResearchers(pPlayer)
	elseif (screenID == "s_465") then
		-- sendStatic: Core3 has no radio-static task. OPEN.
	elseif (screenID == "s_479") then
		kachirhoDestroyedCampScreenPlay:grantQuest(pPlayer)
	end

	return pClonedScreen
end
