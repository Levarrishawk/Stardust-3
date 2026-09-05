-- Rryatt Trail Guide -- raise site for ep3_rryatt_trail_mastery signals
-- ruling 2026-09-04: "ensure kashyyyk is fully done"
-- getInitialScreen is live condition order. runScreenHandlers fires signals.
-- OPEN: handleZoneTransitionRequest is not implemented.
-- Signals fire from s_65 only when the NPC carries zoneLine
-- (rryattOne_rryattTwo .. rryattFour_rryattFive). No spawn sets that objvar here.
-- NO JOURNAL: this branch has no managers/quest/journal.lua.

rryatt_trail_guide_conv_handler = conv_handler:new {}

rryatt_trail_guide_conv_handler.screenAnimations = {
}

function rryatt_trail_guide_conv_handler:getInitialScreen(pPlayer, pNpc, pConvTemplate)
	local convoTemplate = LuaConversationTemplate(pConvTemplate)

	return convoTemplate:getScreen("s_61")
end

function rryatt_trail_guide_conv_handler:runScreenHandlers(pConvTemplate, pPlayer, pNpc, selectedOption, pConvScreen)
	local screen = LuaConversationScreen(pConvScreen)
	local screenID = screen:getScreenID()
	local pClonedScreen = screen:cloneScreen()

	if (screenID == "s_65" and pNpc ~= nil) then
		local zoneLine = readStringData(SceneObject(pNpc):getObjectID() .. ":zoneLine")

		rryattTrailMasteryScreenPlay:signalFromZoneLine(pPlayer, zoneLine)
	end

	return pClonedScreen
end
