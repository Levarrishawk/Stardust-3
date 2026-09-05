-- mtp_meatlumps_supplies_giver_conv_handler
-- ruling 2026-09-04
-- getInitialScreen is live condition order. runScreenHandlers fires grant / signal / turn-in.
-- No journal module: this branch has no managers/quest/journal.lua.

mtp_meatlumps_supplies_giver_conv_handler = conv_handler:new {}

function mtp_meatlumps_supplies_giver_conv_handler:getInitialScreen(pPlayer, pNpc, pConvTemplate)
	local convoTemplate = LuaConversationTemplate(pConvTemplate)

	-- CreatureObject:isInCombat (LuaCreatureObject.cpp). Java SCRIPT_OVERRIDE; no refusal screen.
	if (pPlayer == nil or pNpc == nil or CreatureObject(pNpc):isInCombat() or CreatureObject(pPlayer):isInCombat()) then
		return nil
	end

	if (MtpQuestEngine.isQuestActive(pPlayer, "mtp_hideout_instance_recover_supplies_success")) then
		return convoTemplate:getScreen("s_4")
	elseif (MtpQuestEngine.isQuestActive(pPlayer, "mtp_hideout_instance_recover_supplies_fail")) then
		return convoTemplate:getScreen("s_19")
	elseif (MtpQuestEngine.isQuestActive(pPlayer, "mtp_hideout_instance_recover_supplies")) then
		return convoTemplate:getScreen("s_7")
	elseif (MtpQuestEngine.isQuestComplete(pPlayer, "mtp_hideout_instance_recover_supplies_success") and MtpHideoutInstance:isGiverLocked(pPlayer, "eligibleRecoverSupplies")) then
		return convoTemplate:getScreen("s_9")
	end

	return convoTemplate:getScreen("s_11")
end

function mtp_meatlumps_supplies_giver_conv_handler:runScreenHandlers(pConvTemplate, pPlayer, pNpc, selectedOption, pConvScreen)
	local screen = LuaConversationScreen(pConvScreen)
	local screenID = screen:getScreenID()
	local pClonedScreen = screen:cloneScreen()

	if (screenID == "s_4") then
		MtpQuestEngine.sendSignalAny(pPlayer, "mtp_recover_supplies_success")
		MtpHideoutInstance:lockGiver(pPlayer, "eligibleRecoverSupplies")
	elseif (screenID == "s_19") then
		MtpQuestEngine.sendSignalAny(pPlayer, "mtp_recover_supplies_failed")
	elseif (screenID == "s_15") then
		MtpHideoutInstance:clearNamed(pPlayer, "mtp_hideout_instance_recover_supplies")
		MtpHideoutInstance:clearNamed(pPlayer, "mtp_hideout_instance_recover_supplies_fail")
		MtpHideoutInstance:clearNamed(pPlayer, "mtp_hideout_instance_recover_supplies_success")
		MtpQuestEngine.grantByName(pPlayer, "mtp_hideout_instance_recover_supplies")
		MtpHideoutInstance:unlockGiver(pPlayer, "eligibleRecoverSupplies")
	end

	return pClonedScreen
end
