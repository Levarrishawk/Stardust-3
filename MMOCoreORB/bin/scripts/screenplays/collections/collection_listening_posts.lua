-- Meatlump eavesdrop listening posts (ruling 2026-09-05: "the items across
-- the galaxy, everything").
-- SOURCED listening_device_location.java: 5 m trigger (:12, :16);
-- OnTriggerVolumeEntered writes device_location on the carried device and
-- sends @collection:entered_good_location (:37-40); OnTriggerVolumeExited
-- clears (:55-62). Lua stand-in is DirectorSharedMemory
-- playerOid .. ":collection.deviceLocation".
-- Device use: listening_device.java ITEM_USE @collection:use_device (:14,
-- :33); combat / mount / incap keys at :16-17 / :45-58; slot
-- eavesdrop_location_N (:19, :95) when the player stands in location N
-- (:81-103).
-- spawnIfMissing key shape (collection_objects.lua:82-87).
-- Areas: spawnActiveArea + ENTEREDAREA / EXITEDAREA as in
-- theater_manager.lua:314-325.
-- Menu attach: CollectionLoot.attachLootItemComponent
-- (setObjectMenuComponent after identifying the item). In-tree twin:
-- collection_objects.lua:126 / tutorial.lua:259.
-- Indoor spawn: MeatlumpHideoutScreenPlay.MAIN_ID + getNamedCell, guarded
-- like that branch's CollectionManager nil check. Cell-local transform
-- from the tab; spawnSceneObject parent is the cell oid.
-- col_listening_device_02_01 (master_item.tab:5572, template
-- object/tangible/collection/meatlump_listening_device.iff, no slot) is
-- added on the bridge. Enter matches the fork template in inventory
-- (java :30 static-item name).

CollectionListeningPosts = ScreenPlay:new {
	numberOfActs = 1,
	screenplayName = "CollectionListeningPosts",
	UPDATE_RADIUS = 5,
	COLLECTION_NAME = "col_meatlump_eavesdrop",
	SLOT_PREFIX = "eavesdrop_location_",
	DEVICE_TEMPLATE = "object/tangible/collection/meatlump_listening_device.iff",
	locations = {
		-- SOURCED corellia_4_2.tab:249 cell 39 device_location 1.
		-- Cell-local transform; parent named cell deathroom (hideout spawn
		-- table -- cell 39 deathroom).
		{
			row = "corellia_4_2:249",
			zone = "corellia",
			template = "object/static/item/mtp_trigger_vol_01.iff",
			x = 26.1394, z = -58.1976, y = 150.767,
			qw = 1, qx = 0, qy = 0, qz = 0,
			cellName = "deathroom",
			location = 1,
		},
		-- SOURCED corellia_4_2.tab:109 cell 12 device_location 2.
		-- Cell-local transform; parent named cell greathall (hideout spawn
		-- table -- cell 12 greathall; minigame corellia_4_2 greathall rows).
		{
			row = "corellia_4_2:109",
			zone = "corellia",
			template = "object/static/item/mtp_trigger_vol_02.iff",
			x = -100.951, z = -36, y = 168.546,
			qw = 1, qx = 0, qy = 0, qz = 0,
			cellName = "greathall",
			location = 2,
		},
		-- SOURCED corellia_4_2.tab:196 cell 38 device_location 3.
		-- Cell-local transform; parent named cell arena (hideout spawn
		-- table -- cell 38 arena).
		{
			row = "corellia_4_2:196",
			zone = "corellia",
			template = "object/static/item/mtp_trigger_vol_03.iff",
			x = -20.106, z = -60, y = 165.167,
			qw = 1, qx = 0, qy = 0, qz = 0,
			cellName = "arena",
			location = 3,
		},
		-- SOURCED corellia_4_2.tab:101 cell 12 device_location 4.
		-- Cell-local transform; parent named cell greathall (hideout spawn
		-- table -- cell 12 greathall; minigame corellia_4_2 greathall rows).
		{
			row = "corellia_4_2:101",
			zone = "corellia",
			template = "object/static/item/mtp_trigger_vol_04.iff",
			x = -30.8615, z = -35.6826, y = 160.866,
			qw = 1, qx = 0, qy = 0, qz = 0,
			cellName = "greathall",
			location = 4,
		},
		-- SOURCED corellia_4_2.tab:238 cell 38 device_location 5.
		-- Cell-local transform; parent named cell arena (hideout spawn
		-- table -- cell 38 arena).
		{
			row = "corellia_4_2:238",
			zone = "corellia",
			template = "object/static/item/mtp_trigger_vol_05.iff",
			x = -74.5734, z = -60, y = 182.304,
			qw = 1, qx = 0, qy = 0, qz = 0,
			cellName = "arena",
			location = 5,
		},
	},
}

registerScreenPlay("CollectionListeningPosts", true)

function CollectionListeningPosts:start()
	self:spawnAll()
end

function CollectionListeningPosts:spawnAll()
	local placed = 0
	local locations = self.locations

	for i = 1, #locations, 1 do
		if (self:spawnIfMissing(locations[i])) then
			placed = placed + 1
		end
	end

	print("CollectionListeningPosts: placed " .. placed .. " on corellia")
end

function CollectionListeningPosts:storedKey(entry)
	return self.screenplayName .. ":" .. entry.zone .. ":" .. entry.row
end

function CollectionListeningPosts:hideoutCell(cellName)
	if (MeatlumpHideoutScreenPlay == nil) then
		return nil
	end

	local pBuilding = getSceneObject(MeatlumpHideoutScreenPlay.MAIN_ID)

	if (pBuilding == nil) then
		return nil
	end

	return BuildingObject(pBuilding):getNamedCell(cellName)
end

function CollectionListeningPosts:spawnIfMissing(entry)
	if (not isZoneEnabled(entry.zone)) then
		return false
	end

	if (MeatlumpHideoutScreenPlay == nil) then
		print("CollectionListeningPosts: MeatlumpHideoutScreenPlay absent; " .. entry.row .. " on " .. entry.zone .. " not spawned")
		return false
	end

	local pCell = self:hideoutCell(entry.cellName)

	if (pCell == nil) then
		print("CollectionListeningPosts: " .. entry.row .. " on " .. entry.zone .. " cell " .. entry.cellName .. " did not resolve; not spawned")
		return false
	end

	local cellId = SceneObject(pCell):getObjectID()
	local key = self:storedKey(entry)
	local oid = readData(key)

	if (oid ~= nil and oid ~= 0) then
		local pExisting = getSceneObject(oid)

		if (pExisting ~= nil) then
			self:bindTrigger(pExisting, entry)
			self:ensureArea(entry, pExisting, cellId)
			return true
		end
	end

	local pObject = spawnSceneObject(entry.zone, entry.template, entry.x, entry.z, entry.y, cellId, entry.qw, entry.qx, entry.qy, entry.qz)

	if (pObject == nil) then
		return false
	end

	writeData(key, SceneObject(pObject):getObjectID())
	self:bindTrigger(pObject, entry)
	self:ensureArea(entry, pObject, cellId)
	return true
end

function CollectionListeningPosts:bindTrigger(pObject, entry)
	if (pObject == nil or entry.location == nil) then
		return
	end

	writeData(SceneObject(pObject):getObjectID() .. ":collection.deviceLocation", entry.location)
end

function CollectionListeningPosts:ensureArea(entry, pAnchor, cellId)
	local areaKey = self:storedKey(entry) .. ":area"
	local areaOid = readData(areaKey)

	if (areaOid ~= nil and areaOid ~= 0) then
		local pExisting = getSceneObject(areaOid)

		if (pExisting ~= nil) then
			self:bindArea(pExisting, entry)
			return true
		end
	end

	-- theater_manager.lua:314-325 spawnActiveArea + ENTEREDAREA / EXITEDAREA
	local x = entry.x
	local z = entry.z
	local y = entry.y

	if (pAnchor ~= nil) then
		x = SceneObject(pAnchor):getWorldPositionX()
		z = SceneObject(pAnchor):getWorldPositionZ()
		y = SceneObject(pAnchor):getWorldPositionY()
	end

	local pArea = spawnActiveArea(entry.zone, "object/active_area.iff", x, z, y, self.UPDATE_RADIUS, cellId)

	if (pArea == nil) then
		return false
	end

	writeData(areaKey, SceneObject(pArea):getObjectID())
	self:bindArea(pArea, entry)
	createObserver(ENTEREDAREA, "CollectionListeningPosts", "notifyEnteredLocation", pArea)
	createObserver(EXITEDAREA, "CollectionListeningPosts", "notifyExitedLocation", pArea)
	return true
end

function CollectionListeningPosts:bindArea(pArea, entry)
	if (pArea == nil or entry.location == nil) then
		return
	end

	writeData(SceneObject(pArea):getObjectID() .. ":collection.deviceLocation", entry.location)
end

function CollectionListeningPosts:deviceLocationKey(pPlayer)
	return SceneObject(pPlayer):getObjectID() .. ":collection.deviceLocation"
end

function CollectionListeningPosts:findDevice(pPlayer)
	-- listening_device_location.java:30 col_listening_device_02_01
	-- Bridge adds that static item separately. Match the fork template.
	local pInventory = CreatureObject(pPlayer):getSlottedObject("inventory")

	if (pInventory == nil) then
		return nil
	end

	for i = 0, SceneObject(pInventory):getContainerObjectsSize() - 1, 1 do
		local pItem = SceneObject(pInventory):getContainerObject(i)

		if (pItem ~= nil and SceneObject(pItem):getTemplateObjectPath() == self.DEVICE_TEMPLATE) then
			return pItem
		end
	end

	return nil
end

function CollectionListeningPosts:attachDeviceComponent(pItem)
	-- CollectionLoot.attachLootItemComponent; collection_objects.lua:126
	if (pItem == nil) then
		return
	end

	SceneObject(pItem):setObjectMenuComponent("CollectionListeningDeviceMenuComponent")
end

function CollectionListeningPosts:notifyEnteredLocation(pArea, pCreature)
	-- listening_device_location.java:22-24
	if (pArea == nil or pCreature == nil or not SceneObject(pCreature):isPlayerCreature()) then
		return 0
	end

	-- listening_device_location.java:26-28 isPlayer
	-- listening_device_location.java:30-34 device in inventory
	local pDevice = self:findDevice(pCreature)

	if (pDevice == nil) then
		return 0
	end

	-- listening_device_location.java:35
	if (CollectionManager.hasCompletedCollection(pCreature, self.COLLECTION_NAME)) then
		return 0
	end

	self:attachDeviceComponent(pDevice)

	-- listening_device_location.java:37 SID_ENTERED_GOOD_LOCATION
	CreatureObject(pCreature):sendSystemMessage("@collection:entered_good_location")

	-- listening_device_location.java:38-40 device_active + device_location.
	-- Lua: playerOid .. ":collection.deviceLocation"
	local triggerLocation = readData(SceneObject(pArea):getObjectID() .. ":collection.deviceLocation")

	if (triggerLocation ~= nil and triggerLocation ~= 0) then
		writeData(self:deviceLocationKey(pCreature), triggerLocation)
	end

	return 0
end

function CollectionListeningPosts:notifyExitedLocation(pArea, pCreature)
	-- listening_device_location.java:46-48
	if (pArea == nil or pCreature == nil or not SceneObject(pCreature):isPlayerCreature()) then
		return 0
	end

	-- listening_device_location.java:50-54 device in inventory
	if (self:findDevice(pCreature) == nil) then
		return 0
	end

	-- listening_device_location.java:55-62 clear device_active / device_location
	deleteData(self:deviceLocationKey(pCreature))
	return 0
end

function CollectionListeningPosts:onUse(pPlayer, pDevice)
	if (pPlayer == nil or pDevice == nil or not SceneObject(pPlayer):isPlayerCreature()) then
		return
	end

	-- listening_device.java:45-48
	if (CreatureObject(pPlayer):isInCombat()) then
		CreatureObject(pPlayer):sendSystemMessage("@base_player:not_while_in_combat")
		return
	end

	-- listening_device.java:50-53
	if (CreatureObject(pPlayer):isRidingMount()) then
		CreatureObject(pPlayer):sendSystemMessage("@collection:must_dismount")
		return
	end

	-- listening_device.java:55-58
	if (CreatureObject(pPlayer):isDead() or CreatureObject(pPlayer):isIncapacitated()) then
		CreatureObject(pPlayer):sendSystemMessage("@quest/ground/util/quest_giver_object:not_while_incapped")
		return
	end

	-- listening_device.java:60-63 device_active -> placeListeningDevice
	local triggerLocation = readData(self:deviceLocationKey(pPlayer))

	if (triggerLocation == nil or triggerLocation == 0) then
		return
	end

	self:updateCollection(pPlayer, triggerLocation)
end

function CollectionListeningPosts:updateCollection(pPlayer, triggerLocation)
	-- listening_device.java:95 EAVESDROP_COLLECTION_NAME .. triggerLocation
	local slotToUpdate = self.SLOT_PREFIX .. triggerLocation

	-- listening_device.java:96-99
	if (not CollectionManager.hasCompletedCollectionSlot(pPlayer, slotToUpdate)) then
		CollectionManager.modifyCollectionSlotValue(pPlayer, slotToUpdate, 1)
		return
	end

	-- listening_device.java:103
	CreatureObject(pPlayer):sendSystemMessage("@collection:need_to_activate_collection")
end

CollectionListeningDeviceMenuComponent = { }

function CollectionListeningDeviceMenuComponent:fillObjectMenuResponse(pSceneObject, pMenuResponse, pPlayer)
	if (pSceneObject == nil or pPlayer == nil) then
		return
	end

	-- listening_device.java:31-33 utils.isNestedWithinAPlayer
	if (SceneObject(pSceneObject):isASubChildOf(pPlayer) == false) then
		return
	end

	-- listening_device.java:14, :33 ITEM_USE SID_USE_DEVICE
	local menuResponse = LuaObjectMenuResponse(pMenuResponse)
	menuResponse:addRadialMenuItem(20, 3, "@collection:use_device")
end

function CollectionListeningDeviceMenuComponent:handleObjectMenuSelect(pSceneObject, pPlayer, selectedID)
	if (pPlayer == nil or pSceneObject == nil or selectedID ~= 20) then
		return 0
	end

	CollectionListeningPosts:onUse(pPlayer, pSceneObject)
	return 0
end
