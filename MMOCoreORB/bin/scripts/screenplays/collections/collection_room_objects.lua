-- Collection objects placed through building-spawn tables that name a ROOM
-- (ruling 2026-09-05: "finish up collection 100%").
-- SOURCED spawning/building_spawns/*.tab, clone_relic/ep3_mos_eisley_lucky_despot.tab,
-- quest/hero_of_tatooine/squill_cave.tab, spawning/dungeon/geonosian_bunker_spawner.tab.
-- Indoor path: getSceneObject(buildingNode) -> BuildingObject:getNamedCell(room)
-- (collection_listening_posts.lua:121-132). spawnSceneObject parent is the cell
-- oid with the room-local transform (collection_objects.lua:137-182). Adopt an
-- existing same-template child (collection_objects.lua:93-112 existingInCell)
-- then CollectionObjects:bindObject (collection_objects.lua:193-201).
-- Yaw is degrees. Quaternion is ValleyBattlefield:yawQuaternion
-- (valley_battlefield.lua:527-529): r = math.rad(yaw) / 2, qw = cos(r),
-- qy = sin(r). spawnMobile takes heading in degrees
-- (DirectorManager.cpp:2717 updateDirection deg2rad).
-- Geonosian bunker: geoLab.lua:104 getSceneObject(1627780); caveroom2 is
-- geoLab.lua:318 cell 1627798. This file uses that building node plus
-- getNamedCell("caveroom2") rather than editing geoLab.lua.
-- Valley flame thrower is ValleyBattlefield.stage1Props / runStage1, not here.
-- Squill cave table respawn_time 900: moot: the click does not consume
-- (consume_click does not destroy the world object; finishClick), so
-- respawn is resolved.

CollectionRoomObjects = ScreenPlay:new {
	numberOfActs = 1,
	screenplayName = "CollectionRoomObjects",
	rows = {
		-- SOURCED spawning/building_spawns/bestine_starport.tab foyer4.
		-- tatooine_regions.lua:180 Bestine -1218, -3688. Node 1026824 at
		-- -1376.15, -3576.23 (4 shared_starport_tatooine.iff on tatooine).
		{
			row = "bestine_starport:foyer4",
			zone = "tatooine",
			template = "object/tangible/collection/col_jalopy_crate_02.iff",
			buildingNode = 1026824,
			room = "foyer4",
			x = -11.9, z = 0.6, y = 50.8,
			yaw = 55,
			slot = "col_itv_01:itv_01_02",
		},
		-- SOURCED spawning/building_spawns/mos_eisley_starport.tab foyer4.
		-- tatooine_regions.lua:181 Mos Eisley 3460, -4768. Node 1106368 at
		-- 3618.98, -4801.09 (4 candidates).
		{
			row = "mos_eisley_starport:foyer4",
			zone = "tatooine",
			template = "object/tangible/collection/col_jalopy_crate_01.iff",
			buildingNode = 1106368,
			room = "foyer4",
			x = -11.9, z = 0.6, y = 50.8,
			yaw = 55,
			slot = "col_itv_01:itv_01_01",
		},
		-- SOURCED spawning/building_spawns/mos_espa_starport.tab foyer4.
		-- tatooine_regions.lua:183 Mos Espa -2940, 2190. Node 1261651 at
		-- -2828.78, 2079.61 (4 candidates).
		{
			row = "mos_espa_starport:foyer4",
			zone = "tatooine",
			template = "object/tangible/collection/col_jalopy_crate_05.iff",
			buildingNode = 1261651,
			room = "foyer4",
			x = -11.9, z = 0.6, y = 50.8,
			yaw = 55,
			slot = "col_itv_01:itv_01_05",
		},
		-- SOURCED spawning/building_spawns/coronet_starport.tab foyer4.
		-- corellia_regions.lua:103 Coronet -178, -4504. Node 1855671 at
		-- -51.29, -4734.80 (4 shared_starport_corellia.iff on corellia).
		{
			row = "coronet_starport:foyer4",
			zone = "corellia",
			template = "object/tangible/collection/col_jalopy_crate_04.iff",
			buildingNode = 1855671,
			room = "foyer4",
			x = -11.9, z = 0.6, y = 50.8,
			yaw = 55,
			slot = "col_itv_01:itv_01_04",
		},
		-- SOURCED spawning/building_spawns/kaadara_starport.tab foyer4.
		-- naboo_regions.lua:93 Kaadara 5168, 6704. Node 1741535 at
		-- 5295.29, 6664.33 (3 shared_starport_naboo.iff on naboo).
		{
			row = "kaadara_starport:foyer4",
			zone = "naboo",
			template = "object/tangible/collection/col_jalopy_crate_03.iff",
			buildingNode = 1741535,
			room = "foyer4",
			x = -11.9, z = 0.6, y = 50.8,
			yaw = 55,
			slot = "col_itv_01:itv_01_03",
		},
		-- SOURCED spawning/building_spawns/theed_hangar.tab hangar.
		-- naboo_regions.lua:96 Theed rectangle -6160, 3920 to -4480, 4816.
		-- Node 1692099 at -4795.27, 4238.79 (1 shared_hangar_naboo_theed.iff).
		{
			row = "theed_hangar:hangar",
			zone = "naboo",
			template = "object/tangible/collection/col_jalopy_crate_08.iff",
			buildingNode = 1692099,
			room = "hangar",
			x = 49.1, z = 8, y = -21.4,
			yaw = -160,
			slot = "col_itv_01:itv_01_08",
		},
		-- SOURCED spawning/building_spawns/talus_dearic_starport.tab foyer4.
		-- talus_regions.lua:191 Dearic 425, -3000. Node 3175352 at
		-- 244.89, -2931.13 (2 shared_starport_corellia.iff on talus).
		{
			row = "talus_dearic_starport:foyer4",
			zone = "talus",
			template = "object/tangible/collection/col_jalopy_crate_06.iff",
			buildingNode = 3175352,
			room = "foyer4",
			x = -11.9, z = 0.6, y = 50.8,
			yaw = 55,
			slot = "col_itv_01:itv_01_06",
		},
		-- SOURCED spawning/building_spawns/talus_nashal_starport.tab foyer4.
		-- talus_regions.lua:193 Nashal 4360, 5251. Node 4265355 at
		-- 4479.66, 5365.17 (2 candidates).
		{
			row = "talus_nashal_starport:foyer4",
			zone = "talus",
			template = "object/tangible/collection/col_jalopy_crate_07.iff",
			buildingNode = 4265355,
			room = "foyer4",
			x = -11.9, z = 0.6, y = 50.8,
			yaw = 55,
			slot = "col_itv_01:itv_01_07",
		},
		-- SOURCED spawning/dungeon/geonosian_bunker_spawner.tab caveroom2.
		-- geoLab.lua:104 building 1627780 (bunker_mad_bio.iff). planet_manager.lua:583
		-- geonosian_lab navArea -6440, -388. caveroom2 is geoLab.lua:318 (1627798).
		{
			row = "geonosian_bunker_spawner:caveroom2",
			zone = "yavin4",
			template = "object/tangible/collection/hanging_light_08.iff",
			buildingNode = 1627780,
			room = "caveroom2",
			x = 28.446888, z = -30.724522, y = -74.71904,
			slot = "col_hanging_light_01:hanging_light_08",
		},
		-- SOURCED spawning/clone_relic/ep3_mos_eisley_lucky_despot.tab cafe.
		-- tatooine_regions.lua:181 Mos Eisley 3460, -4768. Node 1076941 at
		-- 3383.24, -4594.67 (2 shared_lucky_despot.iff).
		{
			row = "ep3_mos_eisley_lucky_despot:cafe:white_thranta",
			zone = "tatooine",
			template = "object/tangible/collection/rare_pistol_white_thranta.iff",
			buildingNode = 1076941,
			room = "cafe",
			x = -2.8774793, z = 7.793666, y = -8.040081,
			yaw = 75,
			slot = "col_rare_pistol_03:white_thranta_01",
		},
		-- SOURCED spawning/clone_relic/ep3_mos_eisley_lucky_despot.tab cafe.
		{
			row = "ep3_mos_eisley_lucky_despot:cafe:stage_controller_01",
			zone = "tatooine",
			template = "object/tangible/collection/col_stage_controller_01.iff",
			buildingNode = 1076941,
			room = "cafe",
			x = -17.3, z = 7, y = -4.3,
			yaw = 143,
			slot = "col_stage_controller:col_stage_controller_01",
		},
		-- SOURCED spawning/clone_relic/ep3_mos_eisley_lucky_despot.tab guest07.
		{
			row = "ep3_mos_eisley_lucky_despot:guest07:stage_controller_02",
			zone = "tatooine",
			template = "object/tangible/collection/col_stage_controller_02.iff",
			buildingNode = 1076941,
			room = "guest07",
			x = 27.7, z = -0.3, y = -2.9,
			yaw = 0,
			slot = "col_stage_controller:col_stage_controller_02",
		},
		-- SOURCED spawning/clone_relic/ep3_mos_eisley_lucky_despot.tab meeting03.
		{
			row = "ep3_mos_eisley_lucky_despot:meeting03:stage_controller_03",
			zone = "tatooine",
			template = "object/tangible/collection/col_stage_controller_03.iff",
			buildingNode = 1076941,
			room = "meeting03",
			x = -11.6, z = -0.25, y = -13.39,
			yaw = 0,
			slot = "col_stage_controller:col_stage_controller_03",
		},
		-- SOURCED quest/hero_of_tatooine/squill_cave.tab r27. Node 7125559 at
		-- 38.65, -113.43 (1 shared_tatooine_squill_cave.iff). Table respawn_time
		-- 900 is moot: the click does not consume (finishClick does not
		-- consume the world object).
		{
			row = "squill_cave:r27",
			zone = "tatooine",
			template = "object/tangible/collection/rare_melee_bloodshot_ripper.iff",
			buildingNode = 7125559,
			room = "r27",
			x = 38.87179, z = -68.89614, y = -104.92778,
			yaw = 90,
			slot = "col_rare_melee_01:bloodshot_ripper_01",
			respawnNote = "table respawn_time 900 is moot; click does not consume the world object",
		},
	},
}

registerScreenPlay("CollectionRoomObjects", true)

function CollectionRoomObjects:start()
	self:spawnAll()
end

function CollectionRoomObjects:spawnAll()
	local placed = 0
	local rows = self.rows

	for i = 1, #rows, 1 do
		if (self:spawnIfMissing(rows[i])) then
			placed = placed + 1
		end
	end

	print("CollectionRoomObjects: placed " .. placed .. " room objects")
end

function CollectionRoomObjects:storedKey(entry)
	return self.screenplayName .. ":" .. entry.zone .. ":" .. entry.row
end

function CollectionRoomObjects:yawQuaternion(yaw)
	if (yaw == nil) then
		return 1, 0, 0, 0
	end

	-- valley_battlefield.lua:527-529; DirectorManager.cpp:2717
	local r = math.rad(yaw) / 2
	return math.cos(r), 0, math.sin(r), 0
end

function CollectionRoomObjects:namedCell(entry)
	local pBuilding = getSceneObject(entry.buildingNode)

	if (pBuilding == nil or not SceneObject(pBuilding):isBuildingObject()) then
		print("CollectionRoomObjects: " .. entry.row .. " on " .. entry.zone .. " building " .. tostring(entry.buildingNode) .. " did not resolve; not spawned")
		return nil
	end

	local pCell = BuildingObject(pBuilding):getNamedCell(entry.room)

	if (pCell == nil) then
		print("CollectionRoomObjects: " .. entry.row .. " on " .. entry.zone .. " room " .. entry.room .. " did not resolve; not spawned")
		return nil
	end

	return pCell
end

function CollectionRoomObjects:spawnIfMissing(entry)
	if (entry.absent) then
		print("CollectionRoomObjects: " .. entry.row .. " on " .. entry.zone .. " absent (" .. tostring(entry.absentNote) .. "); not spawned")
		return false
	end

	if (not isZoneEnabled(entry.zone)) then
		return false
	end

	if (entry.respawnNote ~= nil) then
		print("CollectionRoomObjects: " .. entry.row .. " note (" .. entry.respawnNote .. ")")
	end

	local key = self:storedKey(entry)
	local oid = readData(key)

	if (oid ~= nil and oid ~= 0) then
		local pExisting = getSceneObject(oid)

		if (pExisting ~= nil) then
			CollectionObjects:bindObject(pExisting, entry.slot)
			return true
		end
	end

	local pCell = self:namedCell(entry)

	if (pCell == nil) then
		return false
	end

	local cellId = SceneObject(pCell):getObjectID()
	local pAdopted = CollectionObjects:existingInCell(pCell, entry.template)

	if (pAdopted ~= nil) then
		writeData(key, SceneObject(pAdopted):getObjectID())
		CollectionObjects:bindObject(pAdopted, entry.slot)
		return true
	end

	local qw, qx, qy, qz = self:yawQuaternion(entry.yaw)
	local pObject = spawnSceneObject(entry.zone, entry.template, entry.x, entry.z, entry.y, cellId, qw, qx, qy, qz)

	if (pObject == nil) then
		return false
	end

	writeData(key, SceneObject(pObject):getObjectID())
	CollectionObjects:bindObject(pObject, entry.slot)
	return true
end
