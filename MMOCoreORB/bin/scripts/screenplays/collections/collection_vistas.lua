-- Tatooine panoramic vista markers (ruling 2026-09-05: "the items across
-- the galaxy, everything").
-- SOURCED trigger_volume_vistas.java: createTriggerVolume 2 m (:15);
-- OnTriggerVolumeEntered fills collection.marker if the planet collection is
-- incomplete, the slot prereq is met, and the slot is empty (:30-36). No
-- message. spawnIfMissing key shape (collection_objects.lua:82-87).
-- Quaternion is the buildout row (OURS: consume_click was identity).
-- 2 m active area: spawnActiveArea + createObserver(ENTEREDAREA) as in
-- tutorial.lua:242-244.

CollectionVistas = ScreenPlay:new {
	numberOfActs = 1,
	screenplayName = "CollectionVistas",
	COLLECTION_PREFIX = "col_panoramic_vistas_",
	UPDATE_RADIUS = 2,
	markers = {
		-- SOURCED tatooine_6_2.tab:607; areas_tatooine.tab tatooine_6_2 x1 2048 z1 -6144
		{
			row = "tatooine_6_2:607",
			zone = "tatooine",
			template = "object/tangible/collection/col_tatooine_vistas_marker_01.iff",
			x = 3700.12, z = 171.988, y = -4452.29,
			qw = 0.934124, qx = 0, qy = 0.356949, qz = 0,
			slot = "tatooine_vistas_01",
		},
		-- SOURCED tatooine_5_5.tab:15; areas_tatooine.tab tatooine_5_5 x1 0 z1 0
		{
			row = "tatooine_5_5:15",
			zone = "tatooine",
			template = "object/tangible/collection/col_tatooine_vistas_marker_02.iff",
			x = 576.435, z = 171.144, y = 367.639,
			qw = 0.968912, qx = 0, qy = -0.247404, qz = 0,
			slot = "tatooine_vistas_02",
		},
		-- SOURCED tatooine_7_2.tab:82; areas_tatooine.tab tatooine_7_2 x1 4096 z1 -6144
		{
			row = "tatooine_7_2:82",
			zone = "tatooine",
			template = "object/tangible/collection/col_tatooine_vistas_marker_03.iff",
			x = 4949.238, z = 180.258, y = -4728.06,
			qw = 0.922997, qx = 0, qy = 0.384808, qz = 0,
			slot = "tatooine_vistas_03",
		},
		-- SOURCED tatooine_2_6.tab:26; areas_tatooine.tab tatooine_2_6 x1 -6144 z1 2048
		{
			row = "tatooine_2_6:26",
			zone = "tatooine",
			template = "object/tangible/collection/col_tatooine_vistas_marker_04.iff",
			x = -5175.386, z = 16.9049, y = 2687.951,
			qw = 0.928665, qx = 0, qy = -0.37092, qz = 0,
			slot = "tatooine_vistas_04",
		},
		-- SOURCED tatooine_3_7.tab:130; areas_tatooine.tab tatooine_3_7 x1 -4096 z1 4096
		{
			row = "tatooine_3_7:130",
			zone = "tatooine",
			template = "object/tangible/collection/col_tatooine_vistas_marker_05.iff",
			x = -3820.003, z = 271.297, y = 6077.67,
			qw = 0.947651, qx = 0, qy = -0.319309, qz = 0,
			slot = "tatooine_vistas_05",
		},
		-- SOURCED tatooine_2_1.tab:76; areas_tatooine.tab tatooine_2_1 x1 -6144 z1 -8192
		{
			row = "tatooine_2_1:76",
			zone = "tatooine",
			template = "object/tangible/collection/col_tatooine_vistas_marker_06.iff",
			x = -5530.691, z = 91.009, y = -6238.55,
			qw = -0.678557, qx = 0, qy = 0.734548, qz = 0,
			slot = "tatooine_vistas_06",
		},
		-- SOURCED tatooine_7_4.tab:4; areas_tatooine.tab tatooine_7_4 x1 4096 z1 -2048
		{
			row = "tatooine_7_4:4",
			zone = "tatooine",
			template = "object/tangible/collection/col_tatooine_vistas_marker_07.iff",
			x = 6142.84, z = 49.9665, y = -430.39,
			qw = 0.822502, qx = 0, qy = 0.568762, qz = 0,
			slot = "tatooine_vistas_07",
		},
		-- SOURCED tatooine_4_1.tab:4; areas_tatooine.tab tatooine_4_1 x1 -2048 z1 -8192
		{
			row = "tatooine_4_1:4",
			zone = "tatooine",
			template = "object/tangible/collection/col_tatooine_vistas_marker_08.iff",
			x = -509.23, z = 51.4497, y = -6955.96,
			qw = 0.930507, qx = 0, qy = -0.366273, qz = 0,
			slot = "tatooine_vistas_08",
		},
		-- SOURCED tatooine_8_7.tab:15; areas_tatooine.tab tatooine_8_7 x1 6144 z1 4096
		{
			row = "tatooine_8_7:15",
			zone = "tatooine",
			template = "object/tangible/collection/col_tatooine_vistas_marker_09.iff",
			x = 7404.26, z = 112.273, y = 4313.799,
			qw = 0.983844, qx = 0, qy = 0.17903, qz = 0,
			slot = "tatooine_vistas_09",
		},
		-- SOURCED tatooine_2_3.tab:109; areas_tatooine.tab tatooine_2_3 x1 -6144 z1 -4096
		{
			row = "tatooine_2_3:109",
			zone = "tatooine",
			template = "object/tangible/collection/col_tatooine_vistas_marker_10.iff",
			x = -4474.6, z = 36.4508, y = -2287.11,
			qw = 0.913089, qx = 0, qy = -0.407761, qz = 0,
			slot = "tatooine_vistas_10",
		},
	},
}

registerScreenPlay("CollectionVistas", true)

function CollectionVistas:start()
	self:spawnAll()
end

function CollectionVistas:spawnAll()
	local placed = 0
	local markers = self.markers

	for i = 1, #markers, 1 do
		if (self:spawnIfMissing(markers[i])) then
			placed = placed + 1
		end
	end

	print("CollectionVistas: placed " .. placed .. " on tatooine")
end

function CollectionVistas:storedKey(entry)
	return self.screenplayName .. ":" .. entry.zone .. ":" .. entry.row
end

function CollectionVistas:spawnIfMissing(entry)
	if (not isZoneEnabled(entry.zone)) then
		return false
	end

	local key = self:storedKey(entry)
	local oid = readData(key)

	if (oid ~= nil and oid ~= 0) then
		local pExisting = getSceneObject(oid)

		if (pExisting ~= nil) then
			self:bindMarker(pExisting, entry)
			self:ensureArea(entry)
			return true
		end
	end

	local pObject = spawnSceneObject(entry.zone, entry.template, entry.x, entry.z, entry.y, 0, entry.qw, entry.qx, entry.qy, entry.qz)

	if (pObject == nil) then
		return false
	end

	writeData(key, SceneObject(pObject):getObjectID())
	self:bindMarker(pObject, entry)
	self:ensureArea(entry)
	return true
end

function CollectionVistas:bindMarker(pObject, entry)
	if (pObject == nil or entry.slot == nil or entry.slot == "") then
		return
	end

	writeStringData(SceneObject(pObject):getObjectID() .. ":collection.slot", entry.slot)
end

function CollectionVistas:ensureArea(entry)
	local areaKey = self:storedKey(entry) .. ":area"
	local areaOid = readData(areaKey)

	if (areaOid ~= nil and areaOid ~= 0) then
		local pExisting = getSceneObject(areaOid)

		if (pExisting ~= nil) then
			self:bindArea(pExisting, entry)
			return true
		end
	end

	-- tutorial.lua:242-244 spawnActiveArea + createObserver(ENTEREDAREA)
	local pArea = spawnActiveArea(entry.zone, "object/active_area.iff", entry.x, entry.z, entry.y, self.UPDATE_RADIUS, 0)

	if (pArea == nil) then
		return false
	end

	writeData(areaKey, SceneObject(pArea):getObjectID())
	self:bindArea(pArea, entry)
	createObserver(ENTEREDAREA, "CollectionVistas", "notifyEnteredVista", pArea)
	return true
end

function CollectionVistas:bindArea(pArea, entry)
	if (pArea == nil or entry.slot == nil or entry.slot == "") then
		return
	end

	writeStringData(SceneObject(pArea):getObjectID() .. ":collection.slot", entry.slot)
end

function CollectionVistas:notifyEnteredVista(pArea, pCreature)
	-- trigger_volume_vistas.java:20-22
	if (pArea == nil or pCreature == nil or not SceneObject(pCreature):isPlayerCreature()) then
		return 0
	end

	-- trigger_volume_vistas.java:25 SLOT_OBJVAR collection.marker
	local slotToUpdate = readStringData(SceneObject(pArea):getObjectID() .. ":collection.slot")

	-- trigger_volume_vistas.java:26-28
	if (slotToUpdate == nil or slotToUpdate == "") then
		return 0
	end

	-- trigger_volume_vistas.java:24 getCurrentSceneName
	local planetName = SceneObject(pCreature):getZoneName()

	-- trigger_volume_vistas.java:30
	if (CollectionManager.hasCompletedCollection(pCreature, self.COLLECTION_PREFIX .. planetName) or not CollectionManager.hasCompletedCollectionSlotPrereq(pCreature, slotToUpdate)) then
		return 0
	end

	-- trigger_volume_vistas.java:34-36
	if (not CollectionManager.hasCompletedCollectionSlot(pCreature, slotToUpdate)) then
		CollectionManager.modifyCollectionSlotValue(pCreature, slotToUpdate, 1)
	end

	return 0
end

-- OPEN: 30 Nym theme-park consume_click rows in nym_*_objects.tab. Those
-- NGE dungeons are not on this fork (terminal_nym_cave.iff exists; the
-- rooms do not). Nothing spawned.
--
-- nym_droid_cave_objects.tab
--   :3  nyms_surveillance_device:icon_nyms_surveillance_device_10
--   :5  nyms_surveillance_device:icon_nyms_surveillance_device_01
--   :6  nyms_surveillance_device:icon_nyms_surveillance_device_02
--   :7  nyms_surveillance_device:icon_nyms_surveillance_device_03
--   :8  nyms_surveillance_device:icon_nyms_surveillance_device_04
--   :9  nyms_surveillance_device:icon_nyms_surveillance_device_05
--   :10 nyms_surveillance_device:icon_nyms_surveillance_device_06
--   :11 nyms_surveillance_device:icon_nyms_surveillance_device_07
--   :12 nyms_surveillance_device:icon_nyms_surveillance_device_08
--   :13 nyms_surveillance_device:icon_nyms_surveillance_device_09
-- nym_mining_cave_objects.tab
--   :4  nyms_steal_mined_ore:icon_nyms_steal_mined_ore_1
--   :5  nyms_steal_mined_ore:icon_nyms_steal_mined_ore_2
--   :6  nyms_steal_mined_ore:icon_nyms_steal_mined_ore_3
--   :7  nyms_steal_mined_ore:icon_nyms_steal_mined_ore_4
--   :8  nyms_steal_mined_ore:icon_nyms_steal_mined_ore_5
--   :9  nyms_steal_mined_ore:icon_nyms_steal_mined_ore_6
--   :10 nyms_steal_mined_ore:icon_nyms_steal_mined_ore_7
--   :11 nyms_steal_mined_ore:icon_nyms_steal_mined_ore_8
--   :12 nyms_steal_mined_ore:icon_nyms_steal_mined_ore_9
--   :13 nyms_steal_mined_ore:icon_nyms_steal_mined_ore_10
-- nym_research_lab_objects.tab
--   :5  nyms_steal_lab_data:icon_nyms_steal_lab_data_1
--   :6  nyms_steal_lab_data:icon_nyms_steal_lab_data_2
--   :7  nyms_steal_lab_data:icon_nyms_steal_lab_data_3
--   :8  nyms_steal_lab_data:icon_nyms_steal_lab_data_4
--   :9  nyms_steal_lab_data:icon_nyms_steal_lab_data_5
--   :10 nyms_steal_lab_data:icon_nyms_steal_lab_data_6
--   :11 nyms_steal_lab_data:icon_nyms_steal_lab_data_7
--   :12 nyms_steal_lab_data:icon_nyms_steal_lab_data_9
--   :13 nyms_steal_lab_data:icon_nyms_steal_lab_data_10
--   :14 nyms_steal_lab_data:icon_nyms_steal_lab_data_8
