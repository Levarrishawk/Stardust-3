-- mtp_corellia_times_contact_conv_handler
-- ruling 2026-09-05
-- getInitialScreen is live condition order. runScreenHandlers fires grant / signal / turn-in.

mtp_corellia_times_contact_conv_handler = conv_handler:new {}

mtp_corellia_times_contact_conv_handler.activationSlots = {
	"meatlump_safe_activation_01",
	"meatlump_container_activation_01",
	"meatlump_map_activation_01",
	"meatlump_bomb_activation_01",
	"meatlump_weapon_activation_01",
	"meatlump_food_activation_01",
}

mtp_corellia_times_contact_conv_handler.puzzleCollections = {
	"col_meatlump_safe_01",
	"col_meatlump_container_01",
	"col_meatlump_map_01",
	"col_meatlump_bomb_sabotage_01",
	"col_meatlump_weapon_sabotage_01",
	"col_meatlump_food_sabotage_01",
}

mtp_corellia_times_contact_conv_handler.clearOnRepeat = {
	"mtp_collection_tracking",
	"mtp_map_quest_dathomir_01",
	"mtp_map_quest_naboo_02",
	"mtp_map_quest_corellia_01",
	"mtp_map_quest_corellia_02",
	"mtp_map_quest_endor_01",
	"mtp_map_quest_lok_01",
	"mtp_map_quest_naboo_01",
	"mtp_map_quest_naboo_03",
	"mtp_map_quest_talus_01",
	"mtp_map_quest_tatooine_01",
	"mtp_camp_quest_lok",
	"mtp_camp_quest_corellia",
	"mtp_camp_quest_rori_talus",
	"mtp_camp_quest_tatooine",
	"mtp_camp_quest_naboo",
	"mtp_find_infiltrator_1",
	"mtp_find_infiltrator_2",
	"mtp_find_infiltrator_3",
	"mtp_find_infiltrator_4",
	"mtp_find_infiltrator_5",
	"mtp_hideout_retrieve_delivery",
	"mtp_hideout_get_lunch",
	"mtp_hideout_collect_bomb_items",
	"mtp_hideout_ragtag",
}

mtp_corellia_times_contact_conv_handler.deviceByKind = {
	bomb = "object/tangible/meatlump/event/slicing_device_meatlump_bomb.iff",
	food = "object/tangible/meatlump/event/slicing_device_meatlump_food.iff",
	weapon = "object/tangible/meatlump/event/slicing_device_meatlump_weapon.iff",
	map = "object/tangible/meatlump/event/slicing_device_meatlump_map.iff",
	container = "object/tangible/meatlump/event/slicing_device_meatlump_container.iff",
	safe = "object/tangible/meatlump/event/slicing_device_meatlump_safe.iff",
}

mtp_corellia_times_contact_conv_handler.deviceKinds = {
	"bomb", "food", "weapon", "map", "container", "safe",
}


function mtp_corellia_times_contact_conv_handler:modifySlot(pPlayer, slotName, delta)
	if (CollectionManager == nil or CollectionManager.modifyCollectionSlotValue == nil) then
		print("[meatlump] CollectionManager absent; slot " .. tostring(slotName) .. " not paid")
		return
	end

	CollectionManager.modifyCollectionSlotValue(pPlayer, slotName, delta)
end

function mtp_corellia_times_contact_conv_handler:clearCollection(pPlayer, collectionName)
	if (CollectionManager == nil or CollectionManager.clearCollection == nil) then
		print("[meatlump] CollectionManager absent; collection " .. tostring(collectionName) .. " not cleared")
		return
	end

	CollectionManager.clearCollection(pPlayer, collectionName)
end

function mtp_corellia_times_contact_conv_handler:hasItem(pPlayer, template)
	local pInv = CreatureObject(pPlayer):getSlottedObject("inventory")

	if (pInv ~= nil and getContainerObjectByTemplate(pInv, template, true) ~= nil) then
		return true
	end

	local pBank = CreatureObject(pPlayer):getSlottedObject("bank")

	if (pBank ~= nil and getContainerObjectByTemplate(pBank, template, true) ~= nil) then
		return true
	end

	return false
end

function mtp_corellia_times_contact_conv_handler:hasDevice(pPlayer, kind)
	return self:hasItem(pPlayer, self.deviceByKind[kind])
end

function mtp_corellia_times_contact_conv_handler:hasAllDevices(pPlayer)
	for i = 1, #self.deviceKinds do
		if (not self:hasDevice(pPlayer, self.deviceKinds[i])) then
			return false
		end
	end

	return true
end

function mtp_corellia_times_contact_conv_handler:giveDevice(pPlayer, kind)
	local pInventory = CreatureObject(pPlayer):getSlottedObject("inventory")

	if (pInventory == nil) then
		return
	end

	giveItem(pInventory, self.deviceByKind[kind], -1)
end

function mtp_corellia_times_contact_conv_handler:giveAllDevices(pPlayer)
	for i = 1, #self.deviceKinds do
		self:giveDevice(pPlayer, self.deviceKinds[i])
	end
end

function mtp_corellia_times_contact_conv_handler:allPuzzleCollectionsComplete(pPlayer)
	if (CollectionManager == nil or CollectionManager.hasCompletedCollection == nil) then
		print("[meatlump] CollectionManager absent; collection checks skipped")
		return false
	end

	for i = 1, #self.puzzleCollections do
		if (not CollectionManager.hasCompletedCollection(pPlayer, self.puzzleCollections[i])) then
			return false
		end
	end

	return true
end

function mtp_corellia_times_contact_conv_handler:activateMeatlumpCollections(pPlayer)
	for i = 1, #self.activationSlots do
		self:modifySlot(pPlayer, self.activationSlots[i], 1)
	end
end

function mtp_corellia_times_contact_conv_handler:removeMeatlumpCollections(pPlayer)
	for i = 1, #self.puzzleCollections do
		self:clearCollection(pPlayer, self.puzzleCollections[i])
	end
end

function mtp_corellia_times_contact_conv_handler:clearQuestByName(pPlayer, name)
	local sp = MtpQuestEngine.byName(name)

	if (sp ~= nil) then
		MtpQuestEngine.clearQuest(sp, pPlayer)
	end
end

function mtp_corellia_times_contact_conv_handler:grantCollectionQuest(pPlayer)
	local sp = MtpQuestEngine.byName("mtp_collection_tracking")

	if (sp ~= nil) then
		MtpQuestEngine.delete(sp, pPlayer, "runs")
	end

	MtpWebTasks.grant(pPlayer, "mtp_collection_tracking")
end

function mtp_corellia_times_contact_conv_handler:grantMeatlumpCollectionAndQuest(pPlayer)
	self:activateMeatlumpCollections(pPlayer)
	self:grantCollectionQuest(pPlayer)
end

function mtp_corellia_times_contact_conv_handler:removeAndReactivateMeatlumpCollectionsAndQuest(pPlayer)
	self:removeMeatlumpCollections(pPlayer)
	self:activateMeatlumpCollections(pPlayer)

	for i = 1, #self.clearOnRepeat do
		self:clearQuestByName(pPlayer, self.clearOnRepeat[i])
	end

	self:grantCollectionQuest(pPlayer)
end

function mtp_corellia_times_contact_conv_handler:isReadyForCollectionQuest(pPlayer)
	if (MtpQuestEngine.isQuestActive(pPlayer, "mtp_collection_tracking")) then
		return false
	end

	if (MtpQuestEngine.isQuestActive(pPlayer, "mtp_hideout_pointer")) then
		return true
	end

	return MtpQuestEngine.isQuestComplete(pPlayer, "mtp_hideout_pointer") and not MtpQuestEngine.isQuestActive(pPlayer, "mtp_collection_tracking")
end

function mtp_corellia_times_contact_conv_handler:getInitialScreen(pPlayer, pNpc, pConvTemplate)
	local convoTemplate = LuaConversationTemplate(pConvTemplate)

	if (self:allPuzzleCollectionsComplete(pPlayer) and MtpQuestEngine.isQuestComplete(pPlayer, "mtp_collection_tracking")) then
		return convoTemplate:getScreen("s_37")
	elseif (self:allPuzzleCollectionsComplete(pPlayer) and MtpQuestEngine.isTaskActive(MtpQuestEngine.byName("mtp_collection_tracking"), pPlayer, "goBackToHaldenWes")) then
		return convoTemplate:getScreen("s_19")
	elseif (self:isReadyForCollectionQuest(pPlayer)) then
		return convoTemplate:getScreen("s_10")
	elseif (MtpQuestEngine.isQuestActive(pPlayer, "mtp_collection_tracking") and not self:hasAllDevices(pPlayer)) then
		return convoTemplate:getScreen("s_50")
	end

	return convoTemplate:getScreen("s_76")
end

function mtp_corellia_times_contact_conv_handler:runScreenHandlers(pConvTemplate, pPlayer, pNpc, selectedOption, pConvScreen)
	local screen = LuaConversationScreen(pConvScreen)
	local screenID = screen:getScreenID()
	local pClonedScreen = screen:cloneScreen()
	local clonedScreen = LuaConversationScreen(pClonedScreen)

	if (screenID == "s_10") then
		if (MtpQuestEngine.isQuestActive(pPlayer, "mtp_hideout_pointer")) then
			MtpQuestEngine.sendSignalAny(pPlayer, "mtp_hideout_pointer_03")
		end
	elseif (screenID == "s_19") then
		if (pNpc ~= nil) then
			CreatureObject(pNpc):doAnimation("bow")
		end

		CreatureObject(pPlayer):doAnimation("thumb_up")
		MtpQuestEngine.sendSignalAny(pPlayer, "returnToHaldenWes")
	elseif (screenID == "s_23") then
		CreatureObject(pPlayer):doAnimation("laugh")
	elseif (screenID == "s_35") then
		self:giveAllDevices(pPlayer)
	elseif (screenID == "s_41") then
		self:removeAndReactivateMeatlumpCollectionsAndQuest(pPlayer)
	elseif (screenID == "s_42") then
		if (pNpc ~= nil) then
			CreatureObject(pNpc):doAnimation("salute2")
		end
	elseif (screenID == "s_48") then
		self:grantMeatlumpCollectionAndQuest(pPlayer)
	elseif (screenID == "s_50") then
		clonedScreen:removeAllOptions()

		local added = false

		if (not self:hasDevice(pPlayer, "bomb")) then
			clonedScreen:addOption("@conversation/mtp_corellia_times_contact:s_52", "s_54")
			added = true
		end

		if (not self:hasDevice(pPlayer, "food")) then
			clonedScreen:addOption("@conversation/mtp_corellia_times_contact:s_56", "s_58")
			added = true
		end

		if (not self:hasDevice(pPlayer, "weapon")) then
			clonedScreen:addOption("@conversation/mtp_corellia_times_contact:s_60", "s_62")
			added = true
		end

		if (not self:hasDevice(pPlayer, "map")) then
			clonedScreen:addOption("@conversation/mtp_corellia_times_contact:s_64", "s_66")
			added = true
		end

		if (not self:hasDevice(pPlayer, "container")) then
			clonedScreen:addOption("@conversation/mtp_corellia_times_contact:s_68", "s_70")
			added = true
		end

		if (not self:hasDevice(pPlayer, "safe")) then
			clonedScreen:addOption("@conversation/mtp_corellia_times_contact:s_72", "s_74")
			added = true
		end

		if (added) then
			clonedScreen:setStopConversation(false)
		end
	elseif (screenID == "s_54") then
		self:giveDevice(pPlayer, "bomb")
	elseif (screenID == "s_58") then
		self:giveDevice(pPlayer, "food")
	elseif (screenID == "s_62") then
		self:giveDevice(pPlayer, "weapon")
	elseif (screenID == "s_66") then
		self:giveDevice(pPlayer, "map")
	elseif (screenID == "s_70") then
		self:giveDevice(pPlayer, "container")
	elseif (screenID == "s_74") then
		self:giveDevice(pPlayer, "safe")
	end

	return pClonedScreen
end
