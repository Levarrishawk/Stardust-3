--[[
The Webweaver cave populator

ruling 2026-09-04: "ensure kashyyyk is fully done"

WHAT THIS IS

object/building/kashyyyk/ep3_forest_webweaver.iff is a snapshot node of the
merged kashyyyk zone (dead-forest cut). Node 6292864. Until now nothing
	(snapshot node id of the merged kashyyyk zone; the dead-forest sub-snapshot numbers the same building 14913083 --
	the server loads the merged snapshot, world (-1288.23, 9.66, 1826.23))
read spawning/dungeon/ep3_forest_webweaver.tab, so a player who entered
walked through empty rooms. This file spawns that table's creature rows
into that one building.

The journal engine lives on the journal branches. This file does not call
the Journal API.

SOURCE OF RECORD

datatables/spawning/dungeon/ep3_forest_webweaver.tab  --  53 rows
	spawns / room / loc_x / loc_y / loc_z / yaw / script / respawn_time

Every room name, position and heading below is quoted from those rows.

WHICH WORLD FRAME  --  the snapshot node is already in merged space

kashyyyk_regions.lua has two different conversions:

	{#kash-offset} buildout tab -> world
		kashyyyk_dead_forest  world_x = buildout_x - 3548
		                      world_z = buildout_z - 548
	SUB-ZONE MERGE OFFSETS  sub-zone snapshot -> merged snapshot/kashyyyk.ws
		kashyyyk_dead_forest.ws  dx -1500.0  dz +1500.0

The building is a SNAPSHOT node, not a buildout row. Its dead-forest-snapshot
frame is (211.77, 9.66, 326.23). Applying {#kash-offset} to that would land
at (-3336.23, 9.66, -221.77) -- the wrong conversion. The merge offset puts
it at (-1288.23, 9.66, 1826.23), which sits on dead_forest_webweaver_den
(-1277, 1814).

The surface travel screenplay measured a hunting snapshot node already
at merged world (398.22, 41.08, -2399.41). snapshot/kashyyyk.ws stores
translated coordinates. This populator finds the building by node id
(getSceneObject(6292864)), so the cells resolve either way; start()
prints the building's world position so the maintainer can confirm.

THE AXIS MAPPING  --  copied from the POB dungeon populator

The table's columns are loc_x, loc_y, loc_z, yaw, and loc_y is HEIGHT.
This repo's Lua argument order is x, z, y, heading, and z is height. So:

	repo x        <-  loc_x
	repo z        <-  loc_y     (height)
	repo y        <-  loc_z
	repo heading  <-  yaw

spawnMobile takes heading in DEGREES, so yaw goes across unconverted.

ROOMS -> CELL INDEX

The table's room column is r1..r11. start() walks the building's cell
list (getCell(i) for i = 1 .. getTotalCellNumber()), records each cell's
name via getCellName, and prints the map. Rows look up that map; a name
the building does not have is reported once.

THE TEMPLATES ARE THIS TREE'S OWN

Forest-arc mapping (lair headers / giver attachment):

	ep3_forest_webweaver_gravespinner / tombsinger / bloodseeker
		-> webweaver  (numbered set size 1; iff-matched webweaver.iff)
	ep3_forest_outcast_assassin
		-> dressed_ep3_forest_outcast_assassin_01, _02  (rotate in table order)
	ep3_forest_dahlia   -> dressed_ep3_forest_outcast_female_03
	ep3_forest_rhiek    -> dressed_ep3_forest_outcast_male_01
	ep3_forest_aveso    -> dressed_ep3_forest_outcast_female_01
	ep3_forest_cryl     -> dressed_ep3_forest_outcast_male_03
	ep3_forest_outcast_dealer -> dressed_ep3_forest_outcast_dealer
	ep3_forest_risyl    -> dressed_forest_outcast_leader

OPEN, listed in place as comments, never a look-alike:

	ep3_forest_mother_vesad  r4  79.9971, -76.1955, -65.019, 4.67729  respawn 420

RESPAWN

Combat rows quote 300. Giver rows have a blank respawn_time; they use 0
the way unique surface NPCs do.

53 tab rows = 27 webweaver + 19 assassin + 1 OPEN mother_vesad + 6 givers.
--]]

KashyyykWebweaverPopulation = ScreenPlay:new {
	numberOfActs = 1,
	screenplayName = "KashyyykWebweaverPopulation",

	zone = "kashyyyk",
	buildingID = 6292864,

	-- { repo template, cell, x, z (height), y, heading, respawn }
	rows = {
		{ "webweaver", "r1", -1.98358, -11.8603, -7.07566, 86.8473, 300 },
		{ "webweaver", "r1", 23.1662, -28.1276, -10.1829, -174.795, 300 },
		{ "webweaver", "r2", 23.0297, -37.2582, -29.9053, -179.37, 300 },
		{ "webweaver", "r2", 24.0161, -40.9468, -50.5845, 175.704, 300 },
		{ "webweaver", "r2", 28.0063, -43.1017, -65.82, 99.8679, 300 },
		{ "webweaver", "r2", 50.8272, -48.0031, -68.3053, -4.12044, 300 },
		{ "webweaver", "r10", 49.6811, -51.6588, -90.8699, -178.138, 300 },
		{ "webweaver", "r10", 62.97, -47.2055, -106.43, 98.4601, 300 },
		{ "webweaver", "r5", 71.9626, -46.4406, -107.322, 94.4131, 300 },
		{ "webweaver", "r5", 93.4225, -45.8405, -100.164, -169.868, 300 },
		{ "webweaver", "r11", 92.2971, -46.9176, -137.273, -126.232, 300 },
		{ "webweaver", "r11", 79, -46.5529, -141.928, 63.2695, 300 },
		{ "webweaver", "r2", 45.1771, -47.6516, -39.2092, -1.30541, 300 },
		{ "webweaver", "r2", 55.7022, -49.6387, -15.5055, 81.3925, 300 },
		{ "webweaver", "r3", 84.8727, -62.9168, -18.5431, 165.322, 300 },
		{ "webweaver", "r3", 83.1835, -68.7035, -41.0718, -174.619, 300 },
		{ "webweaver", "r2", 57.3017, -68.3859, -36.9043, -80.3083, 300 },
		{ "webweaver", "r2", 50.8239, -67.4948, -47.3695, 50.073, 300 },
		{ "webweaver", "r4", 67.6305, -75.4073, -59.7072, -133.446, 300 },
		{ "webweaver", "r4", 63.7554, -76.6355, -82.2412, 123.446, 300 },
		{ "webweaver", "r4", 84.0108, -76.6423, -89.1168, 93.0057, 300 },
		{ "webweaver", "r4", 90.5749, -76.2048, -66.7016, -28.7539, 300 },
		{ "webweaver", "r6", 53.0008, -75.6514, -98.3109, 170.953, 300 },
		{ "webweaver", "r6", 55.4087, -71.3504, -115.079, 169.897, 300 },
		{ "webweaver", "r7", 69.7797, -66.1897, -139.039, 105.322, 300 },
		{ "webweaver", "r7", 89.2114, -67.0698, -133.896, 12.9469, 300 },
		{ "webweaver", "r5", 94.236, -66.1407, -115.167, 24.384, 300 },
		{ "dressed_ep3_forest_outcast_assassin_01", "r8", 113.629, -66.4289, -118.855, 166.906, 300 },
		{ "dressed_ep3_forest_outcast_assassin_02", "r8", 130.18, -66.636, -104.879, 60.4542, 300 },
		{ "dressed_ep3_forest_outcast_assassin_01", "r8", 151.899, -66.6226, -123.969, 9.95569, 300 },
		{ "dressed_ep3_forest_outcast_assassin_02", "r8", 155.316, -66.3611, -96.1209, -132.39, 300 },
		-- OPEN ep3_forest_mother_vesad  "r4"  79.9971, -76.1955, -65.019, 4.67729  respawn 420
		{ "dressed_ep3_forest_outcast_female_03", "r9", 180.136, -66.1165, -96.7275, -90.5224, 0 },
		{ "dressed_ep3_forest_outcast_male_01", "r8", 146.524, -67.2326, -123.671, 26.3458, 0 },
		{ "dressed_ep3_forest_outcast_female_01", "r8", 140.026, -67.1334, -91.2939, 160.712, 0 },
		{ "dressed_ep3_forest_outcast_male_03", "r8", 135.742, -66.2344, -109.189, -82.6612, 0 },
		{ "dressed_ep3_forest_outcast_assassin_01", "r5", 94.5955, -66.5879, -105.821, -95.5706, 300 },
		{ "dressed_ep3_forest_outcast_assassin_02", "r2", 56.7341, -68.4113, -43.4215, -126.787, 300 },
		{ "dressed_ep3_forest_outcast_assassin_01", "r2", 52.1823, -67.9702, -36.79, -20.2683, 300 },
		{ "dressed_ep3_forest_outcast_assassin_02", "r2", 44.3398, -47.1838, -10.0972, -16.9468, 300 },
		{ "dressed_ep3_forest_outcast_assassin_01", "r2", 41.2219, -46.3072, -28.5425, -145.138, 300 },
		{ "dressed_ep3_forest_outcast_assassin_02", "r2", 52.3357, -48.8913, -61.4344, -157.731, 300 },
		{ "dressed_ep3_forest_outcast_assassin_01", "r10", 48.8202, -48.9123, -101.045, 166.339, 300 },
		{ "dressed_ep3_forest_outcast_assassin_02", "r5", 94.7456, -46.8375, -113.249, 62.967, 300 },
		{ "dressed_ep3_forest_outcast_assassin_01", "r5", 84.6227, -46.6022, -116.124, 6.72038, 300 },
		{ "dressed_ep3_forest_outcast_assassin_02", "r11", 90.0074, -46.3734, -147.788, -89.6229, 300 },
		{ "dressed_ep3_forest_outcast_assassin_01", "r11", 82.3697, -46.2066, -138.215, -39.877, 300 },
		{ "dressed_ep3_forest_outcast_assassin_02", "r11", 73.6104, -46.0966, -141.437, -98.0497, 300 },
		{ "dressed_ep3_forest_outcast_assassin_01", "r2", 20.8388, -41.7931, -65.7011, -2.10513, 300 },
		{ "dressed_ep3_forest_outcast_assassin_02", "r1", 26.4671, -26.4333, -6.25681, -93.7979, 300 },
		{ "dressed_ep3_forest_outcast_assassin_01", "r1", -15.5229, -4.56978, -8.02114, -36.8618, 300 },
		{ "dressed_ep3_forest_outcast_dealer", "r8", 131.937, -66.9065, -86.9163, -142.323, 0 },
		{ "dressed_forest_outcast_leader", "r11", 82.9025, -46.4097, -143.164, -33.5273, 0 },
	},

	spawnedCount = 0,
}

registerScreenPlay("KashyyykWebweaverPopulation", true)

function KashyyykWebweaverPopulation:start()
	if (not isZoneEnabled(self.zone)) then
		return
	end

	local pBuilding = getSceneObject(self.buildingID)

	if (pBuilding == nil or not SceneObject(pBuilding):isBuildingObject()) then
		print("KashyyykWebweaverPopulation: building " .. self.buildingID .. " is missing; the cave gets no creatures")
		return
	end

	local wx = SceneObject(pBuilding):getWorldPositionX()
	local wz = SceneObject(pBuilding):getWorldPositionZ()
	local wy = SceneObject(pBuilding):getWorldPositionY()
	print("KashyyykWebweaverPopulation: building " .. self.buildingID .. " world (" .. wx .. ", " .. wz .. ", " .. wy .. ")")

	local cells = self:buildCellMap(pBuilding)
	local reported = {}

	for i = 1, #self.rows do
		local row = self.rows[i]
		local cellName = row[2]
		local cellId = cells[cellName]

		if (cellId == nil or cellId == 0) then
			if (reported[cellName] == nil) then
				print("KashyyykWebweaverPopulation: no cell named '" .. cellName .. "'; its rows are skipped")
				reported[cellName] = true
			end
		else
			self:spawnIfMissing(row, cellId)
		end
	end

	print("KashyyykWebweaverPopulation: " .. self.spawnedCount .. " creatures placed in the Webweaver cave")
end

function KashyyykWebweaverPopulation:buildCellMap(pBuilding)
	local cells = {}
	local total = BuildingObject(pBuilding):getTotalCellNumber()

	print("KashyyykWebweaverPopulation: " .. total .. " cells")

	for i = 1, total do
		local pCell = BuildingObject(pBuilding):getCell(i)

		if (pCell ~= nil) then
			local cellId = SceneObject(pCell):getObjectID()
			local cellNum = LuaCellObject(pCell):getCellNumber()
			local cellName = BuildingObject(pBuilding):getCellName(cellNum)

			if (cellName == nil) then
				cellName = ""
			end

			print("KashyyykWebweaverPopulation: cell index " .. i .. " number=" .. cellNum .. " name='" .. cellName .. "' id=" .. cellId)

			if (cellName ~= "") then
				cells[cellName] = cellId
			end

			cells["r" .. i] = cellId
		end
	end

	return cells
end

function KashyyykWebweaverPopulation:spawnIfMissing(row, cellId)
	local template = row[1]
	local cellName = row[2]
	local x = row[3]
	local z = row[4]
	local y = row[5]
	local heading = row[6]
	local respawn = row[7]
	local pCell = getSceneObject(cellId)

	if (pCell ~= nil) then
		local size = SceneObject(pCell):getContainerObjectsSize()

		for j = 1, size do
			local pObject = SceneObject(pCell):getContainerObject(j - 1)

			if (pObject ~= nil and SceneObject(pObject):isAiAgent()) then
				if (AiAgent(pObject):getCreatureTemplateName() == template) then
					local dx = SceneObject(pObject):getPositionX() - x
					local dy = SceneObject(pObject):getPositionY() - y

					if ((dx * dx + dy * dy) < 4) then
						return
					end
				end
			end
		end
	end

	local pMobile = spawnMobile(self.zone, template, respawn, x, z, y, heading, cellId)

	if (pMobile == nil) then
		print("KashyyykWebweaverPopulation: failed to spawn " .. template .. " in " .. cellName)
		return
	end

	self.spawnedCount = self.spawnedCount + 1
end
