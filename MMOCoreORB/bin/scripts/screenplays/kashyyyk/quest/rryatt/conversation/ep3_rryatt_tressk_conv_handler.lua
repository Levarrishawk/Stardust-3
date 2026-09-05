-- Tressk -- ep3_rryatt_tressk_* hunts
-- ruling 2026-09-04: "ensure kashyyyk is fully done"
-- getInitialScreen is live condition order. runScreenHandlers fires grant / signal / turn-in.
-- Gotal weapon-choice branch: the shipped script shows it only after the quest is complete, and the quest's last task waits for
-- tressk_gotalHuntersCompleted, which no shipped script ever sends. OURS (pending the maintainer's ruling): the kills-done state
-- (stage 2) also opens the weapon choice, and choosing completes the quest, so the hunt can be finished at all. s_27 / s_28 raise
-- tressk_chooseJuntiMace / tressk_chooseFlechettePistol as the script does.
-- NO JOURNAL: this branch has no managers/quest/journal.lua.

ep3_rryatt_tressk_conv_handler = conv_handler:new {}

ep3_rryatt_tressk_conv_handler.screenAnimations = {
}

local function doneOrReady(sp, pPlayer)
	return sp:getStage(pPlayer) == 2 or sp:isComplete(pPlayer)
end

function ep3_rryatt_tressk_conv_handler:getInitialScreen(pPlayer, pNpc, pConvTemplate)
	local convoTemplate = LuaConversationTemplate(pConvTemplate)
	local rodian = rryattTresskLostRodianHuntersScreenPlay
	local poachers = rryattTresskDeepWoodsPoachersScreenPlay
	local gotal = rryattTresskGotalHuntersScreenPlay

	if (gotal:hasChosenWeapon(pPlayer)) then
		return convoTemplate:getScreen("s_31")
	elseif (gotal:isComplete(pPlayer) or gotal:getStage(pPlayer) == 2) then
		return convoTemplate:getScreen("s_1367")
	elseif (gotal:getStage(pPlayer) == 1) then
		return convoTemplate:getScreen("s_1368")
	elseif (doneOrReady(poachers, pPlayer)) then
		return convoTemplate:getScreen("s_1369")
	elseif (poachers:getStage(pPlayer) == 1) then
		return convoTemplate:getScreen("s_1370")
	elseif (doneOrReady(rodian, pPlayer)) then
		return convoTemplate:getScreen("s_1371")
	elseif (rodian:getStage(pPlayer) == 1) then
		return convoTemplate:getScreen("s_1372")
	end

	return convoTemplate:getScreen("s_1366")
end

function ep3_rryatt_tressk_conv_handler:runScreenHandlers(pConvTemplate, pPlayer, pNpc, selectedOption, pConvScreen)
	local screen = LuaConversationScreen(pConvScreen)
	local screenID = screen:getScreenID()
	local pClonedScreen = screen:cloneScreen()
	local clonedConversation = LuaConversationScreen(pClonedScreen)

	if (screenID == "s_27") then
		rryattTresskGotalHuntersScreenPlay:raiseWeaponChoice(pPlayer, "tressk_chooseJuntiMace")
		rryattTresskGotalHuntersScreenPlay:signalTurnIn(pPlayer)
	elseif (screenID == "s_28") then
		rryattTresskGotalHuntersScreenPlay:raiseWeaponChoice(pPlayer, "tressk_chooseFlechettePistol")
		rryattTresskGotalHuntersScreenPlay:signalTurnIn(pPlayer)
	elseif (screenID == "s_1369") then
		rryattTresskDeepWoodsPoachersScreenPlay:signalTurnIn(pPlayer)
	elseif (screenID == "s_1387") then
		rryattTresskGotalHuntersScreenPlay:grantQuest(pPlayer)
	elseif (screenID == "s_1371") then
		rryattTresskLostRodianHuntersScreenPlay:signalTurnIn(pPlayer)
	elseif (screenID == "s_1383") then
		rryattTresskDeepWoodsPoachersScreenPlay:grantQuest(pPlayer)
	elseif (screenID == "s_1379") then
		rryattTresskLostRodianHuntersScreenPlay:grantQuest(pPlayer)
	end

	return pClonedScreen
end
