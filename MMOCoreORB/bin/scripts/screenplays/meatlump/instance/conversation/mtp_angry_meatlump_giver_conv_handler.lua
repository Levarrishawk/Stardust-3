-- mtp_angry_meatlump_giver_conv_handler
-- ruling 2026-09-04
-- getInitialScreen is live condition order. runScreenHandlers fires grant / signal / turn-in.
-- No journal module: this branch has no managers/quest/journal.lua.

mtp_angry_meatlump_giver_conv_handler = conv_handler:new {}

function mtp_angry_meatlump_giver_conv_handler:getInitialScreen(pPlayer, pNpc, pConvTemplate)
	local convoTemplate = LuaConversationTemplate(pConvTemplate)

	-- CreatureObject:isInCombat (LuaCreatureObject.cpp). Java SCRIPT_OVERRIDE; no refusal screen.
	if (pPlayer == nil or pNpc == nil or CreatureObject(pNpc):isInCombat() or CreatureObject(pPlayer):isInCombat()) then
		return nil
	end

	if (MtpQuestEngine.isTaskActive(MtpQuestEngine.byName("mtp_angry_meatlumps"), pPlayer, "angry_meatlumps_02")) then
		return convoTemplate:getScreen("s_4")
	elseif (MtpQuestEngine.isQuestActive(pPlayer, "mtp_angry_meatlumps")) then
		return convoTemplate:getScreen("s_6")
	elseif (MtpQuestEngine.isQuestComplete(pPlayer, "mtp_angry_meatlumps") and MtpHideoutInstance:isGiverLocked(pPlayer, "eligibleAngryMeatlump")) then
		return convoTemplate:getScreen("s_8")
	end

	return convoTemplate:getScreen("s_10")
end

function mtp_angry_meatlump_giver_conv_handler:runScreenHandlers(pConvTemplate, pPlayer, pNpc, selectedOption, pConvScreen)
	local screen = LuaConversationScreen(pConvScreen)
	local screenID = screen:getScreenID()
	local pClonedScreen = screen:cloneScreen()

	if (screenID == "s_4") then
		MtpQuestEngine.sendSignalAny(pPlayer, "angry_meatlumps_02")
		MtpHideoutInstance:lockGiver(pPlayer, "eligibleAngryMeatlump")
	elseif (screenID == "s_14") then
		MtpHideoutInstance:clearNamed(pPlayer, "mtp_angry_meatlumps")
		MtpQuestEngine.grantByName(pPlayer, "mtp_angry_meatlumps")
		MtpHideoutInstance:unlockGiver(pPlayer, "eligibleAngryMeatlump")
	end

	return pClonedScreen
end
