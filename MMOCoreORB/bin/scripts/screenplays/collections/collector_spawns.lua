-- Collector world placements (ruling 2026-09-04: "finish ... collections").
-- SOURCED spawnMobile respawn 0, Kashyyyk static-NPC shape (kashyyyk_static_npcs.lua)
-- plus spawnIfMissing (kashyyyk_travel.lua: stored OID, skip if still in zone).
-- World x, z, y = area x1 + px, py, area z1 + pz (areas_<planet>.tab). Heading =
-- degrees(2 * atan2(qy, qw)). Collector column is written per-NPC as
-- <oid>:collection.columnName (override path; customName is not overwritten).
--
-- nexus_collector (dathomir_7_2.tab:243): OURS placement on SOURCED coordinates.
-- DirectorManager.cpp:3110 spawnSceneObject of a BUILDING template calls
-- createCellObjects(). Hut template is registered
-- (object/custom_content/building/content/aurilia/aurilia_pyramid_hut.lua).
-- Cell index: BuildingObject.idl:241 "Cells start index 1";
-- BuildingObjectImplementation.cpp:127 createCellObjects addCell(..., i + 1);
-- getCell(0) errors. In-tree: tutorial.lua:91 getCell(i) for
-- i = 1 .. getTotalCellNumber(); corellianCorvette.lua:895 getCell(1).
-- SOE cell_index 1 is getCell(1), not getCell(0).

CollectorSpawns = ScreenPlay:new {
	numberOfActs = 1,
	screenplayName = "CollectorSpawns",

	HUT_TEMPLATE = "object/building/content/aurilia/aurilia_pyramid_hut.iff",
	HUT_ZONE = "dathomir",
	HUT_X = 5355.09,
	HUT_Z = 78.5,
	HUT_Y = -4138.22,
	HUT_QW = -0.707107,
	HUT_QX = 0,
	HUT_QY = 0.707107,
	HUT_QZ = 0,
	HUT_ADOPT_RANGE = 3,
	HUT_SNAPSHOT_NODE = 15092,
	HUT_CELL_INDEX = 1,

	-- Each row: zone, template, transform, cell (0 outdoor; indoor = building
	-- resolved at spawn), collector key.
	npcs = {
		-- SOURCED buildout/endor/endor_6_3.tab row 32; areas_endor.tab endor_6_3 x1 2048 z1 -4096
		-- 2048+1230.48=3278.48, -4096+597.653=-3498.347; qw 0.880172 qy -0.474655
		{
			collector = "endor_collector",
			zone = "endor",
			template = "npc_dressed_collection_npc_male_human_02",
			x = 3278.48, z = 24, y = -3498.347,
			heading = -56.674,
			cell = 0,
		},
		-- SOURCED buildout/tatooine/tatooine_6_2.tab:195; areas_tatooine.tab tatooine_6_2 x1 2048 z1 -6144
		-- 2048+1217.65=3265.65, -6144+1324.76=-4819.24; qw -0.299758 qy 0.954015
		{
			collector = "novice_collector",
			zone = "tatooine",
			template = "npc_dressed_collection_npc_female_human_03",
			x = 3265.65, z = 5, y = -4819.24,
			heading = 214.886,
			cell = 0,
		},
		-- SOURCED buildout/yavin4/yavin4_4_7.tab:3; areas_yavin4.tab yavin4_4_7 x1 -2048 z1 4096
		-- -2048+1703.71=-344.29, 4096+716.168=4812.168; qw 0.26192 qy 0.96509
		{
			collector = "yavin4_collector",
			zone = "yavin4",
			template = "npc_dressed_collection_npc_male_ithorian_02",
			x = -344.29, z = 35, y = 4812.168,
			heading = 149.632,
			cell = 0,
		},
		-- SOURCED buildout/dathomir/dathomir_7_2.tab:243 cell_index 1 (parent cell :238 of
		-- aurilia_pyramid_hut :237). Building world 4096+1259.09=5355.09, 78.5, -6144+2005.78=-4138.22
		-- CELL-LOCAL transform. qw 0.998575 qy -0.0533642. Hut is spawned (or adopted) first.
		{
			collector = "nexus_collector",
			zone = "dathomir",
			template = "npc_dressed_collection_npc_female_mon_01",
			x = 0.1333, z = 1.20562, y = -1.58838,
			heading = -6.118,
			hut = true,
			cellIndex = 1,
		},
	},

	-- SOURCED dathomir_7_2.tab world rows (areas_dathomir.tab dathomir_7_2 x1 4096 z1 -6144).
	villageWorld = {
		-- :231 aurilia_shere -- the shipped row's server template aurilia_shere.tpf points at
		-- shared_aurilia_sphere.iff; this tree registers that client file as aurilia_sphere.
		{row = "dathomir_7_2:231", template = "object/building/content/aurilia/aurilia_sphere.iff",
			x = 5278, z = 83.91, y = -4177, qw = 1, qx = 0, qy = 0, qz = 0},
		-- :234 aurilia_collector_sign
		{row = "dathomir_7_2:234", template = "object/building/content/aurilia/aurilia_collector_sign.iff",
			x = 5348.17, z = 78.5, y = -4139.92, qw = 0.707123, qx = 0, qy = -0.70709, qz = 0},
		-- :235 aurilia_shere
		{row = "dathomir_7_2:235", template = "object/building/content/aurilia/aurilia_sphere.iff",
			x = 5278, z = 83.91, y = -4134, qw = 1, qx = 0, qy = 0, qz = 0},
		-- :236 terminal_bank
		{row = "dathomir_7_2:236", template = "object/tangible/terminal/terminal_bank.iff",
			x = 5382, z = 78.5, y = -4135.67, qw = 0.707133, qx = 0, qy = 0.70708, qz = 0},
	},

	-- SOURCED dathomir_7_2.tab :239-242 cell-local in hut cell 1.
	villageFurniture = {
		{row = "dathomir_7_2:239", template = "object/tangible/furniture/decorative/spear_rack.iff",
			x = -3.1251, z = 1.20562, y = -4.13199, qw = 1, qx = 0, qy = 0, qz = 0},
		{row = "dathomir_7_2:240", template = "object/tangible/furniture/decorative/tanning_hide_s02.iff",
			x = 2.67026, z = 1.20562, y = -4.24114, qw = 1, qx = 0, qy = 0, qz = 0},
		{row = "dathomir_7_2:241", template = "object/static/item/wp_mle_sword_lightsaber_leather.iff",
			x = 3.10571, z = 2.25847, y = -1.80882, qw = 0.28833, qx = 0.28833, qy = 0.645652, qz = 0.645651},
		{row = "dathomir_7_2:242", template = "object/tangible/furniture/elegant/couch_s01.iff",
			x = -3.6744, z = 1.20562, y = 1.09241, qw = 0.707127, qx = 0, qy = 0.707086, qz = 0},
	},
}

registerScreenPlay("CollectorSpawns", true)

-- Never placed by SOE (no spawner row anywhere in the shipped tables -- verified):
-- corellia_collector  npc_dressed_collection_npc_male_bith_01     creatures.tab:5782
-- dantooine_collector npc_dressed_collection_npc_male_human_01    creatures.tab:5783
-- lok_collector       npc_dressed_collection_npc_male_ithorian_01 creatures.tab:5785
-- tatooine_collector  npc_dressed_collection_npc_female_zab_01    creatures.tab:5781
-- npe_collector       commoner (NPE station, dungeon1)            creatures.tab:6239 -- not this fork's zone
-- heroic_echo_collector hoth_collector.iff (echo_base, adventure2) creatures.tab:6209 -- no repo template

function CollectorSpawns:start()
	self:ensureAuriliaHut()
	self:spawnNpcs()
end

function CollectorSpawns:hutKey()
	return self.screenplayName .. ":aurilia_pyramid_hut"
end

function CollectorSpawns:propKey(row)
	return self.screenplayName .. ":" .. row
end

function CollectorSpawns:isHutAtSpot(pObj)
	if (pObj == nil) then
		return false
	end

	if (SceneObject(pObj):getTemplateObjectPath() ~= self.HUT_TEMPLATE) then
		return false
	end

	-- LuaSceneObject.cpp:353 getDistanceToPosition(x, z, y)
	local dist = SceneObject(pObj):getDistanceToPosition(self.HUT_X, self.HUT_Z, self.HUT_Y)

	return dist ~= nil and dist <= self.HUT_ADOPT_RANGE
end

function CollectorSpawns:findExistingHut()
	local oid = readData(self:hutKey())

	if (oid ~= nil and oid ~= 0) then
		local pStored = getSceneObject(oid)

		if (self:isHutAtSpot(pStored)) then
			return pStored
		end
	end

	-- Snapshot node from mtg_patch dathomir.ws (cited with the collector row).
	-- Core3 Lua has no getObjectsInRange (kashyyyk_travel.lua); probe that node
	-- and adopt when the template is within 3 m of the shipped world position.
	local pSnap = getSceneObject(self.HUT_SNAPSHOT_NODE)

	if (self:isHutAtSpot(pSnap)) then
		writeData(self:hutKey(), SceneObject(pSnap):getObjectID())
		return pSnap
	end

	return nil
end

function CollectorSpawns:ensureAuriliaHut()
	if (not isZoneEnabled(self.HUT_ZONE)) then
		return nil
	end

	local pHut = self:findExistingHut()

	if (pHut == nil) then
		pHut = spawnSceneObject(self.HUT_ZONE, self.HUT_TEMPLATE, self.HUT_X, self.HUT_Z, self.HUT_Y, 0, self.HUT_QW, self.HUT_QX, self.HUT_QY, self.HUT_QZ)

		if (pHut == nil) then
			print("CollectorSpawns: aurilia_pyramid_hut (dathomir_7_2.tab:237) did not spawn")
			return nil
		end

		writeData(self:hutKey(), SceneObject(pHut):getObjectID())
		print("CollectorSpawns: aurilia_pyramid_hut placed on dathomir (OURS on SOURCED coords)")
	end

	self:spawnVillageWorld()
	self:spawnVillageFurniture(pHut)
	return pHut
end

function CollectorSpawns:hutCell(pHut)
	if (pHut == nil or not SceneObject(pHut):isBuildingObject()) then
		return nil
	end

	-- BuildingObject.idl:241; tutorial.lua:91; corellianCorvette.lua:895
	local pCell = BuildingObject(pHut):getCell(self.HUT_CELL_INDEX)

	if (pCell == nil) then
		return nil
	end

	return pCell
end

function CollectorSpawns:existingInCell(pCell, template)
	if (pCell == nil or template == nil or template == "") then
		return nil
	end

	for i = 0, SceneObject(pCell):getContainerObjectsSize() - 1, 1 do
		local pItem = SceneObject(pCell):getContainerObject(i)

		if (pItem ~= nil and SceneObject(pItem):getTemplateObjectPath() == template) then
			return pItem
		end
	end

	return nil
end

function CollectorSpawns:spawnSceneIfMissing(entry, cellId)
	local key = self:propKey(entry.row)
	local oid = readData(key)

	if (oid ~= nil and oid ~= 0) then
		local pExisting = getSceneObject(oid)

		if (pExisting ~= nil) then
			return true
		end
	end

	if (cellId ~= 0) then
		local pCell = getSceneObject(cellId)

		if (pCell ~= nil) then
			local pAdopted = self:existingInCell(pCell, entry.template)

			if (pAdopted ~= nil) then
				writeData(key, SceneObject(pAdopted):getObjectID())
				return true
			end
		end
	end

	local pObject = spawnSceneObject(self.HUT_ZONE, entry.template, entry.x, entry.z, entry.y, cellId, entry.qw, entry.qx, entry.qy, entry.qz)

	if (pObject == nil) then
		print("CollectorSpawns: " .. entry.row .. " did not spawn (" .. entry.template .. ")")
		return false
	end

	writeData(key, SceneObject(pObject):getObjectID())
	return true
end

function CollectorSpawns:spawnVillageWorld()
	local rows = self.villageWorld

	for i = 1, #rows, 1 do
		self:spawnSceneIfMissing(rows[i], 0)
	end
end

function CollectorSpawns:spawnVillageFurniture(pHut)
	local pCell = self:hutCell(pHut)

	if (pCell == nil) then
		print("CollectorSpawns: hut cell 1 did not resolve; furniture not spawned")
		return
	end

	local cellId = SceneObject(pCell):getObjectID()
	local rows = self.villageFurniture

	for i = 1, #rows, 1 do
		self:spawnSceneIfMissing(rows[i], cellId)
	end
end

function CollectorSpawns:spawnNpcs()
	local npcs = self.npcs

	for i = 1, #npcs, 1 do
		self:spawnIfMissing(npcs[i])
	end
end

function CollectorSpawns:storedKey(entry)
	return self.screenplayName .. ":" .. entry.collector
end

function CollectorSpawns:resolveCell(entry)
	if (entry.cell ~= nil) then
		return entry.cell
	end

	if (entry.hut == true) then
		local pHut = self:findExistingHut()

		if (pHut == nil) then
			pHut = self:ensureAuriliaHut()
		end

		local pCell = self:hutCell(pHut)

		if (pCell == nil) then
			return nil
		end

		return SceneObject(pCell):getObjectID()
	end

	if (entry.buildingId == nil or entry.cellIndex == nil) then
		return nil
	end

	local pBuilding = getSceneObject(entry.buildingId)

	if (pBuilding == nil or not SceneObject(pBuilding):isBuildingObject()) then
		return nil
	end

	local pCell = BuildingObject(pBuilding):getCell(entry.cellIndex)

	if (pCell == nil) then
		return nil
	end

	return SceneObject(pCell):getObjectID()
end

function CollectorSpawns:spawnIfMissing(entry)
	if (not isZoneEnabled(entry.zone)) then
		return
	end

	local key = self:storedKey(entry)
	local oid = readData(key)

	if (oid ~= nil and oid ~= 0) then
		local pExisting = getSceneObject(oid)

		if (pExisting ~= nil) then
			self:bindCollector(pExisting, entry.collector)
			return
		end
	end

	local cellId = self:resolveCell(entry)

	if (cellId == nil) then
		return
	end

	local pNpc = spawnMobile(entry.zone, entry.template, 0, entry.x, entry.z, entry.y, entry.heading, cellId)

	if (pNpc == nil) then
		return
	end

	writeData(key, SceneObject(pNpc):getObjectID())
	self:bindCollector(pNpc, entry.collector)
	print("CollectorSpawns: " .. entry.collector .. " placed on " .. entry.zone .. " (" .. entry.template .. ")")
end

function CollectorSpawns:bindCollector(pNpc, collector)
	if (pNpc == nil or collector == nil or collector == "") then
		return
	end

	writeStringData(SceneObject(pNpc):getObjectID() .. ":collection.columnName", collector)
end
