-- mtp_hideout_recon_conv_handler
-- ruling 2026-09-04
-- getInitialScreen is live condition order. runScreenHandlers fires grant / signal / turn-in.
-- Slot: meatlump_camera_starter_slot (col_meatlump_photo_01).

mtp_hideout_recon_conv_handler = conv_handler:new {}

mtp_hideout_recon_conv_handler.CAMERA_STARTER = "meatlump_camera_starter_slot"


function mtp_hideout_recon_conv_handler:hasCompletedCollectionSlot(pPlayer, slotName)
	if (CollectionManager == nil or CollectionManager.hasCompletedCollectionSlot == nil) then
		print("[meatlump] CollectionManager absent; collection checks skipped")
		return false
	end

	return CollectionManager.hasCompletedCollectionSlot(pPlayer, slotName)
end

function mtp_hideout_recon_conv_handler:modifySlot(pPlayer, slotName, delta)
	if (CollectionManager == nil or CollectionManager.modifyCollectionSlotValue == nil) then
		print("[meatlump] CollectionManager absent; slot " .. tostring(slotName) .. " not paid")
		return
	end

	CollectionManager.modifyCollectionSlotValue(pPlayer, slotName, delta)
end

function mtp_hideout_recon_conv_handler:getInitialScreen(pPlayer, pNpc, pConvTemplate)
	local convoTemplate = LuaConversationTemplate(pConvTemplate)

	if (self:hasCompletedCollectionSlot(pPlayer, self.CAMERA_STARTER)) then
		return convoTemplate:getScreen("s_36")
	end

	return convoTemplate:getScreen("s_8")
end

function mtp_hideout_recon_conv_handler:runScreenHandlers(pConvTemplate, pPlayer, pNpc, selectedOption, pConvScreen)
	local screen = LuaConversationScreen(pConvScreen)
	local screenID = screen:getScreenID()
	local pClonedScreen = screen:cloneScreen()

	if (screenID == "s_20") then
		self:modifySlot(pPlayer, self.CAMERA_STARTER, 1)
	end

	return pClonedScreen
end
