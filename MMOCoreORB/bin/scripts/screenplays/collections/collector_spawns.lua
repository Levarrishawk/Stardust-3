-- Collector world placements (ruling 2026-09-04: "finish ... collections").
-- SOURCED spawnMobile respawn 0, Kashyyyk static-NPC shape (kashyyyk_static_npcs.lua)
-- plus spawnIfMissing (kashyyyk_travel.lua: stored OID, skip if still in zone).
-- World x, z, y = area x1 + px, py, area z1 + pz (areas_<planet>.tab). Heading =
-- degrees(2 * atan2(qy, qw)). Collector column is written per-NPC as
-- <oid>:collection.columnName (override path; customName is not overwritten).

CollectorSpawns = ScreenPlay:new {
	numberOfActs = 1,
	screenplayName = "CollectorSpawns",

	-- Each row: zone, template, transform, cell (0 outdoor; indoor = buildingId +
	-- cellIndex resolved at spawn), collector key.
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
		-- matches snapshot/dathomir.ws node 15092; cell 1 is node 15093. CELL-LOCAL transform.
		-- qw 0.998575 qy -0.0533642. OPEN: those node ids are from mtg_patch_023's snapshot/dathomir.ws; the server's TRE
		-- order loads stardust_03's snapshot/dathomir.ws first, and that snapshot has no Aurilia hut at all (no
		-- aurilia template among its 387), so this row cannot spawn until the maintainer rules on the Aurilia village.
		-- The row stays for that day; open = true keeps it out of the boot spawn.
		-- WHAT SHE NEEDS (ruling 2026-09-05, "notate dathomir collector's absence and placement needed"): the Aurilia
		-- village rows of dathomir_7_2.tab -- the pyramid hut :237 at world 5355.09 / 78.5 / -4138.22, her sign :234
		-- (aurilia_collector_sign, world 5348.17 / 78.5 / -4139.92), the two sheres :231 / :235, the bank terminal :236,
		-- the hut's furniture :239-242 -- exist only in mtg_patch_023's snapshot. Two ways to give her a home, either one
		-- the maintainer's call: (a) load a dathomir snapshot that carries the village (the merged-snapshot shape used
		-- for Kashyyyk), then this row spawns as written with buildingId 15092 / cell 1; or (b) spawn the hut from Lua at
		-- the world position above (spawnSceneObject with the building template creates its cells) and adopt cell 1 --
		-- OURS placement on SOURCED coordinates. She activates seven collections (col_rock_bubbling among them); until
		-- she stands, those cannot be started.
		{
			collector = "nexus_collector",
			zone = "dathomir",
			template = "npc_dressed_collection_npc_female_mon_01",
			x = 0.1333, z = 1.20562, y = -1.58838,
			heading = -6.118,
			buildingId = 15092,
			cellIndex = 1,
			open = true,
		},
	},
}

registerScreenPlay("CollectorSpawns", true)

-- OPEN placement (no SOE spawner row; coordinates never invented):
-- corellia_collector  npc_dressed_collection_npc_male_bith_01     creatures.tab:5782
-- dantooine_collector npc_dressed_collection_npc_male_human_01    creatures.tab:5783
-- lok_collector       npc_dressed_collection_npc_male_ithorian_01 creatures.tab:5785
-- tatooine_collector  npc_dressed_collection_npc_female_zab_01    creatures.tab:5781
-- npe_collector       commoner (NPE station, dungeon1)            creatures.tab:6239 -- not this fork's zone
-- heroic_echo_collector hoth_collector.iff (echo_base, adventure2) creatures.tab:6209 -- no repo template

function CollectorSpawns:start()
	self:spawnNpcs()
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
	if (entry.open) then
		print("CollectorSpawns: " .. entry.collector .. " on " .. entry.zone .. " is OPEN (see the row's note); not spawned")
		return
	end

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
