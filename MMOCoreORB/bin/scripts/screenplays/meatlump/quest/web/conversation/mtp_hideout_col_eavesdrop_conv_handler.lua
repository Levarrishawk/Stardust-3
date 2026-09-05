-- mtp_hideout_col_eavesdrop_conv_handler
-- ruling 2026-09-05
-- getInitialScreen is live condition order. runScreenHandlers fires grant / signal / turn-in.

mtp_hideout_col_eavesdrop_conv_handler = conv_handler:new {}

mtp_hideout_col_eavesdrop_conv_handler.LISTENING_DEVICE = "object/tangible/collection/meatlump_listening_device.iff"
mtp_hideout_col_eavesdrop_conv_handler.LOCKOUT_SECONDS = 82800 -- buff.tab:1732 DURATION; fork has no hasBuff/addBuff
mtp_hideout_col_eavesdrop_conv_handler.bugLocations = {
	"eavesdrop_location_1",
	"eavesdrop_location_2",
	"eavesdrop_location_3",
	"eavesdrop_location_4",
	"eavesdrop_location_5",
}


function mtp_hideout_col_eavesdrop_conv_handler:lockoutKey(pPlayer)
	return SceneObject(pPlayer):getObjectID() .. ":mtpEavesdropLockout"
end

-- java hasLockoutBuff is inverted: true when the player does NOT have mtp_eavesdrop_lockout
function mtp_hideout_col_eavesdrop_conv_handler:hasLockoutBuff(pPlayer)
	local expiry = readData(self:lockoutKey(pPlayer)) or 0

	return expiry <= os.time()
end

function mtp_hideout_col_eavesdrop_conv_handler:applyLockout(pPlayer)
	writeData(self:lockoutKey(pPlayer), os.time() + self.LOCKOUT_SECONDS)
end

function mtp_hideout_col_eavesdrop_conv_handler:hasCompletedCollection(pPlayer, collectionName)
	if (CollectionManager == nil or CollectionManager.hasCompletedCollection == nil) then
		print("[meatlump] CollectionManager absent; collection checks skipped")
		return false
	end

	return CollectionManager.hasCompletedCollection(pPlayer, collectionName)
end

function mtp_hideout_col_eavesdrop_conv_handler:hasCompletedCollectionSlot(pPlayer, slotName)
	if (CollectionManager == nil or CollectionManager.hasCompletedCollectionSlot == nil) then
		print("[meatlump] CollectionManager absent; collection checks skipped")
		return false
	end

	return CollectionManager.hasCompletedCollectionSlot(pPlayer, slotName)
end

function mtp_hideout_col_eavesdrop_conv_handler:hasCompletedCollectionSlotPrereq(pPlayer, slotName)
	if (CollectionManager == nil or CollectionManager.hasCompletedCollectionSlotPrereq == nil) then
		print("[meatlump] CollectionManager absent; collection checks skipped")
		return false
	end

	return CollectionManager.hasCompletedCollectionSlotPrereq(pPlayer, slotName)
end

function mtp_hideout_col_eavesdrop_conv_handler:modifySlot(pPlayer, slotName, delta)
	if (CollectionManager == nil or CollectionManager.modifyCollectionSlotValue == nil) then
		print("[meatlump] CollectionManager absent; slot " .. tostring(slotName) .. " not paid")
		return
	end

	CollectionManager.modifyCollectionSlotValue(pPlayer, slotName, delta)
end

function mtp_hideout_col_eavesdrop_conv_handler:findListeningDevice(pPlayer)
	local pInv = CreatureObject(pPlayer):getSlottedObject("inventory")

	if (pInv == nil) then
		return nil
	end

	return getContainerObjectByTemplate(pInv, self.LISTENING_DEVICE, true)
end

function mtp_hideout_col_eavesdrop_conv_handler:giveListeningDevice(pPlayer)
	local pInventory = CreatureObject(pPlayer):getSlottedObject("inventory")

	if (pInventory == nil) then
		return
	end

	giveItem(pInventory, self.LISTENING_DEVICE, -1)
end

function mtp_hideout_col_eavesdrop_conv_handler:destroyListeningDevice(pPlayer)
	local pDev = self:findListeningDevice(pPlayer)

	if (pDev == nil) then
		return
	end

	SceneObject(pDev):destroyObjectFromWorld()
	SceneObject(pDev):destroyObjectFromDatabase()
end

function mtp_hideout_col_eavesdrop_conv_handler:activeOrCompleteCollection(pPlayer)
	if (self:hasCompletedCollection(pPlayer, "col_meatlump_eavesdrop") or self:hasCompletedCollectionSlotPrereq(pPlayer, "eavesdrop_location_1")) then
		return false
	end

	return true
end

function mtp_hideout_col_eavesdrop_conv_handler:readyForTurnIn(pPlayer)
	for i = 1, #self.bugLocations do
		if (not self:hasCompletedCollectionSlot(pPlayer, self.bugLocations[i])) then
			return false
		end
	end

	if (self:findListeningDevice(pPlayer) == nil) then
		return false
	end

	return true
end

function mtp_hideout_col_eavesdrop_conv_handler:grantBugJar(pPlayer)
	self:giveListeningDevice(pPlayer)
	self:modifySlot(pPlayer, "meatlump_eavesdrop_start", 1)
end

function mtp_hideout_col_eavesdrop_conv_handler:returnBugJar(pPlayer)
	if (self:findListeningDevice(pPlayer) == nil) then
		return
	end

	if (not self:hasCompletedCollectionSlotPrereq(pPlayer, "eavesdrop_location_1")) then
		return
	end

	for i = 1, #self.bugLocations do
		if (not self:hasCompletedCollectionSlot(pPlayer, self.bugLocations[i])) then
			return
		end
	end

	self:modifySlot(pPlayer, "meatlump_eavesdrop_finish", 1)

	if (self:hasCompletedCollection(pPlayer, "col_meatlump_eavesdrop")) then
		self:destroyListeningDevice(pPlayer)
		self:applyLockout(pPlayer)
	end
end

function mtp_hideout_col_eavesdrop_conv_handler:clearCollectionGrantNew(pPlayer)
	if (CollectionManager == nil) then
		print("[meatlump] CollectionManager absent; col_meatlump_eavesdrop not cleared")
	elseif (CollectionManager.clearCollection ~= nil) then
		CollectionManager.clearCollection(pPlayer, "col_meatlump_eavesdrop")
	elseif (CollectionManager.getAllCollectionSlotsInCollection ~= nil and CollectionManager.getCollectionSlotValue ~= nil and CollectionManager.modifyCollectionSlotValue ~= nil) then
		local slots = CollectionManager.getAllCollectionSlotsInCollection("col_meatlump_eavesdrop")

		for i = 1, #slots do
			local value = CollectionManager.getCollectionSlotValue(pPlayer, slots[i]) or 0

			if (value ~= 0) then
				CollectionManager.modifyCollectionSlotValue(pPlayer, slots[i], value * -1)
			end
		end
	else
		print("[meatlump] CollectionManager absent; col_meatlump_eavesdrop not cleared")
	end

	self:grantBugJar(pPlayer)
end

function mtp_hideout_col_eavesdrop_conv_handler:getInitialScreen(pPlayer, pNpc, pConvTemplate)
	local convoTemplate = LuaConversationTemplate(pConvTemplate)

	return convoTemplate:getScreen("s_4")
end

function mtp_hideout_col_eavesdrop_conv_handler:runScreenHandlers(pConvTemplate, pPlayer, pNpc, selectedOption, pConvScreen)
	local screen = LuaConversationScreen(pConvScreen)
	local screenID = screen:getScreenID()
	local pClonedScreen = screen:cloneScreen()
	local clonedScreen = LuaConversationScreen(pClonedScreen)

	if (screenID == "s_4") then
		clonedScreen:removeAllOptions()

		if (self:activeOrCompleteCollection(pPlayer)) then
			clonedScreen:addOption("@conversation/mtp_hideout_col_eavesdrop:s_5", "s_27")
		end

		clonedScreen:addOption("@conversation/mtp_hideout_col_eavesdrop:s_6", "s_41")

		if (self:readyForTurnIn(pPlayer)) then
			clonedScreen:addOption("@conversation/mtp_hideout_col_eavesdrop:s_42", "s_43")
		end

		if (self:hasCompletedCollection(pPlayer, "col_meatlump_eavesdrop")) then
			if (self:hasLockoutBuff(pPlayer)) then
				clonedScreen:addOption("@conversation/mtp_hideout_col_eavesdrop:s_44", "s_45")
			else
				clonedScreen:addOption("@conversation/mtp_hideout_col_eavesdrop:s_44", "s_51")
			end
		end
	elseif (screenID == "s_43") then
		self:returnBugJar(pPlayer)
	elseif (screenID == "s_49") then
		self:grantBugJar(pPlayer)
	elseif (screenID == "s_50") then
		self:clearCollectionGrantNew(pPlayer)
	end

	return pClonedScreen
end
