-- Ortha Ledox -- ep3_kachirho_varactyl_hunt (journal names the turn-in Janno)
-- ruling 2026-09-04: "ensure kashyyyk is done in full"
-- getInitialScreen is live condition order. runScreenHandlers fires grant / signal / turn-in.
-- No Journal.*: this branch has no managers/quest/journal.lua.

ep3_ortha_ledox_conv_handler = conv_handler:new {}

ep3_ortha_ledox_conv_handler.screenAnimations = {
	s_357 = "rub_chin_thoughtful",
	s_361 = "nod_head_once",
	s_365 = "check_wrist_device",
	s_367 = "search",
	s_371 = "wave1",
	s_375 = "nod_head_once",
	s_377 = "refuse_offer_affection",
	s_379 = "wave_finger_warning",
	s_383 = "explain",
	s_387 = "explain",
	s_391 = "rub_chin_thoughtful",
	s_395 = "point_forward",
	s_403 = "nod_head_once",
}

function ep3_ortha_ledox_conv_handler:stage(pPlayer)
	return kachirhoVaractylHuntScreenPlay:getStage(pPlayer)
end

function ep3_ortha_ledox_conv_handler:getInitialScreen(pPlayer, pNpc, pConvTemplate)
	local convoTemplate = LuaConversationTemplate(pConvTemplate)

	if (self:stage(pPlayer) == 0 and kachirhoVaractylHuntScreenPlay:getRuns(pPlayer) > 0) then
		return convoTemplate:getScreen("s_357")
	elseif (self:stage(pPlayer) == 2) then
		return convoTemplate:getScreen("s_367")
	elseif (self:stage(pPlayer) > 0) then
		return convoTemplate:getScreen("s_377")
	end

	return convoTemplate:getScreen("s_379")
end

function ep3_ortha_ledox_conv_handler:runScreenHandlers(pConvTemplate, pPlayer, pNpc, selectedOption, pConvScreen)
	local screen = LuaConversationScreen(pConvScreen)
	local screenID = screen:getScreenID()
	local pClonedScreen = screen:cloneScreen()
	local clonedConversation = LuaConversationScreen(pClonedScreen)

	if (self.screenAnimations ~= nil and self.screenAnimations[screenID] ~= nil and pNpc ~= nil) then
		CreatureObject(pNpc):doAnimation(self.screenAnimations[screenID])
	end

	if (screenID == "s_361") then
		kachirhoVaractylHuntScreenPlay:clearQuest(pPlayer)
		kachirhoVaractylHuntScreenPlay:grantQuest(pPlayer)
	elseif (screenID == "s_367") then
		kachirhoVaractylHuntScreenPlay:signalTurnIn(pPlayer)
	elseif (screenID == "s_371") then
		kachirhoVaractylHuntScreenPlay:clearQuest(pPlayer)
		kachirhoVaractylHuntScreenPlay:grantQuest(pPlayer)
	elseif (screenID == "s_399") then
		kachirhoVaractylHuntScreenPlay:grantQuest(pPlayer)
	end

	return pClonedScreen
end
