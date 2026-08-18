--[[
Mustafar instance pools  --  the six SOE dungeon pools

WHAT THIS IS, AND WHOSE WORK IT IS NOT

This file is Lua only. It does not touch Levarris's dungeon work: his contribution
is the C++ POB ('0001') and CellPortal ('0002') parsing in the portal-layout
reader, which is what makes these buildings load with working cells at all. That
is already compiled into the server and is left exactly alone. What was missing on
top of it was any script that lets a player reach the interiors. That is this file.

THE POOLS ARE SOE'S, AND THEY ARE ALREADY LOADED

snapshot/mustafar.ws in stardust_03.tre -- the snapshot the server actually loads --
places six dungeon buildings many times over, in evenly spaced rows well outside
the playable map:

    old_republic_facility    12 copies   z = -4746.16, x = -6748.81 .. 951.18, 700 apart
    working_droid_factory    12 copies   z = -3745.18, x = -6753.41 .. 946.59, 700 apart
    decrepit_droid_factory    9 copies   z = -2745.18, x = -6753.41 .. -1853.41
    monster_lair             12 copies
    lair_of_the_crystal      12 copies   x =  6748.99, z =  6954.54 .. -745.46, 700 apart
    uplink_cave               9 copies   x =  5947.36, z =  6255.33 .. 1355.33, 700 apart

That is SOE's instancing model: a fixed pool of identical off-map copies, one
handed to each party. Nothing has to be created for it. A boot probe on the devbox
enumerated all 66 copies live with cells attached and zero portal errors in the
log, so the pool is real at runtime and not just in the snapshot.

(Two positions in the snapshot are duplicated -- uplink 12114801/12114804 both at
z=2055.33, and decrepit 12115008/12115037 both at x=-2553.41. They are still
distinct buildings with distinct cells, so both are usable; SOE simply stacked
them. Noted so the coordinates above are not read as a transcription error.)

CELL NAMES COME FROM THE .ilf FILES

Each dungeon has an interior layout file (interiorlayout/*.ilf) listing every
placed object as a template, a cell name and a 4x3 transform. Those files are the
authoritative record of the interiors. Core3 has an InteriorLayoutTemplate parser
for them but nothing calls it, so the buildings load as correct geometry with none
of the furniture -- anything wanted inside has to be spawned from script.

The cell names read out of som_old_republic_facility.ilf were checked against a
live server: BuildingObject:getNamedCell resolved 22 of 22 of them on copy
12115823, and the first cell of each of the three single-room dungeons resolved
too. So getNamedCell against .ilf names is a sound way to address these interiors.

The ORF has 35 cells but the .ilf names only 22, because the .ilf only lists cells
that contain objects. The 13 unnamed ones are empty by construction.

RESERVATIONS

One copy per party, claimed on entry and released when it empties.

    mustafarInstance:<buildingID>              1 while the copy is claimed
    mustafarInstance:<buildingID>:claimedAt    os.time() of the claim
    <playerID>:mustafarInstance                the copy that player is inside
    <playerID>:mustafarInstanceEjecting        set while an eject is in flight

A copy is released when a sweep finds nobody in any of its cells and the claim is
older than claimGrace. The grace matters: between reserving a copy and the
switchZone landing the player in it, the copy is legitimately empty, and without
the grace it would be handed to somebody else in that window.

The sweep is a self-terminating chain rather than a global timer -- checkCopy
reschedules itself only while the copy is still claimed, so events exist only for
copies actually in use. EXITEDBUILDING also fires a one-shot releaseIfEmpty so a
copy normally frees within seconds rather than waiting for the next sweep.

initialize() clears every reservation and ejects anyone still inside at boot. That
is what covers a player who logged out in an instance: without it their copy would
stay claimed forever and the pool would leak one slot per stranded logout.

WHAT IS WIRED, AND WHAT DELIBERATELY IS NOT

Only the Old Republic Facility has an entry. It is the one this arc needs:
som_kenobi_historian_1 sends the player to it, and reunite_shard_3's fusion machine
stands inside it.

The other five pools have real exterior doors in the snapshot and they are recorded
below, but they are NOT wired, and each one says why in its own entry. In every
case the reason is the same shape: the door exists, the interior exists, but the
quest or device that opened it in live did not ship in this tree, and opening them
unconditionally would be inventing content rather than restoring it. A radial that
teleports a player into an empty dungeon with no reason to be there is a grant that
does nothing, which is worse than an honest gap.

STRINGS

"Enter the facility" is this file's wording, not a shipped one. The live entry was
a door you walked through, not a radial, so there is no SOE string for it.
--]]

MustafarInstances = ScreenPlay:new {
	numberOfActs = 1,

	screenplayName = "MustafarInstances",

	-- Seconds a claimed-but-empty copy is held before it can be reissued; see
	-- RESERVATIONS in the header.
	claimGrace = 60,

	-- How often the self-rescheduling sweep revisits a claimed copy.
	sweepSeconds = 120,

	pools = {
		{
			key = "old_republic_facility",
			label = "Old Republic Facility",

			buildings = { 12115823, 12115861, 12115785, 12115747, 12115709, 12115671,
				12115633, 12115595, 12115557, 12115519, 12115481, 12115443 },

			-- Snapshot node 12110161,
			-- object/building/mustafar/structures/shared_old_republic_facility_door_exterior.iff
			-- at (-775.93, 89.14, 6088.28). This is the door the client already draws.
			entry = {
				nodeID = 12110161,
				text = "Enter the facility",

				-- entrance cell, from som_old_republic_facility.ilf. Its floor is at
				-- y=0 and its clutter sits at x 4.4-14 / z +7..+9.4, x 19-23.4 at both
				-- ends, and x 6-8 / z -9. x=12 z=0 is open floor between them.
				-- .ilf y (up) becomes the switchZone height argument.
				cell = "entrance",
				x = 12.0, z = 0.0, y = 0.0,
			},

			-- Just outside the door, stepped ~7m along the vector from the facility
			-- exterior (node 12110934, -782.04/6096.14) through the door, so the
			-- player lands facing away from the building rather than inside its mass.
			-- Height is resolved with getWorldFloor, never hardcoded.
			exit = { x = -771.6, y = 6082.8 },
		},
		{
			key = "monster_lair",
			label = "Sherkar's Lair",
			buildings = { 12115929, 12115932, 12115926, 12115923, 12115920, 12115917,
				12115914, 12115911, 12115908, 12115905, 12115902, 12115899 },
			entry = nil,
			-- NOT WIRED. The door is snapshot node 12110143
			-- (shared_must_sherkar_door.iff, -2077.07/4276.08) beside exterior 12110517.
			-- In live this was the Sherkar boss lair, opened by the Mustafarian
			-- bandit chain. No .qst in this tree points at it and no screenplay here
			-- populates it, so an entry would drop the player into an empty room.
			door = 12110143,
		},
		{
			key = "uplink_cave",
			label = "Uplink Cave",
			buildings = { 12114807, 12114801, 12114804, 12114798, 12114795, 12114792,
				12114789, 12114786, 12114783 },
			entry = nil,
			-- NOT WIRED. The door is snapshot node 12111281
			-- (shared_must_uplink_bunker_entrance_door.iff, -3591.53/3489.44) beside
			-- entrance 12111374. This is the "establish uplink" quest's dungeon; that
			-- quest is not wired in this tree yet. Wire the quest first, then the door.
			door = 12111281,
		},
		{
			key = "lair_of_the_crystal",
			label = "Lair of the Crystal",
			buildings = { 12114830, 12114828, 12114832, 12114826, 12114824, 12114822,
				12114820, 12114818, 12114816, 12114814, 12114812, 12114810 },
			-- Snapshot node 12112106,
			-- object/tangible/dungeon/mustafar/obiwan_finale/shared_obiwan_finale_entrance_stone.iff
			-- at (-2693.52, 42.57, 6075.59). This is the end of the arc's main
			-- spine, not a side door, so unlike every other pool here it is gated:
			-- see gate below and kenobiSpineScreenPlay:mayEnterLair.
			entry = {
				nodeID = 12112106,

				-- Authored. main_quest_3 task 1 is a Go to Location and carries no
				-- retrieveMenuText, because in live the stone was a client-side
				-- dungeon portal rather than a quest object.
				text = "Wedge the crystal shard into the pillar",

				-- mainroom, from som_obiwan_crystal_lair.ilf. Its floor is at y=0
				-- and the statue gallery runs x 21..40 in two rows at z 2.5 and
				-- z 7.68; x=24 z=5.1 is the open aisle between them, at the near
				-- end. The boss waits at x=37 down the same aisle.
				cell = "mainroom",
				x = 24.0, z = 0.0, y = 5.1,
			},

			-- Stepped ~6 m back from the stone along the vector out of the temple
			-- ruin, so the player lands on open ground rather than inside the
			-- jeditemple wall at 7.67 m or the dome at 8.10 m. Height is resolved
			-- with getWorldFloor, never hardcoded.
			exit = { x = -2693.5, y = 6069.6 },

			-- Only this pool has one. See isEntryAllowed.
			gate = "kenobi_spine",

			door = 12112106,
		},
		{
			key = "working_droid_factory",
			label = "Working Droid Factory",
			buildings = { 12115385, 12115414, 12115356, 12115327, 12115298, 12115269,
				12115240, 12115211, 12115182, 12115153, 12115124, 12115095 },
			entry = nil,
			-- NOT WIRED. The door is snapshot node 12112909
			-- (shared_droid_factory_exterior_door.iff, 532.71/1977.03), and beside it
			-- the snapshot places a keypad (12112269) and a history terminal
			-- (12112268). In live the keypad gated the door behind a code from the
			-- factory quest line. Both factories share that one door, so which of the
			-- two pools a player gets is itself part of that quest's logic. None of it
			-- ships here.
			door = 12112909,
		},
		{
			key = "decrepit_droid_factory",
			label = "Decrepit Droid Factory",
			buildings = { 12115066, 12115008, 12115037, 12114979, 12114950, 12114921,
				12114892, 12114863, 12114834 },
			entry = nil,
			-- NOT WIRED. Same door and same reason as working_droid_factory above.
			door = 12112909,
		},
	},
}

registerScreenPlay("MustafarInstances", true)

function MustafarInstances:start()
	if (isZoneEnabled("mustafar")) then
		self:initialize()
	end
end

--[[ Setup ]]

function MustafarInstances:initialize()
	for i = 1, #self.pools do
		local pool = self.pools[i]

		if (pool.entry ~= nil) then
			for j = 1, #pool.buildings do
				self:prepareCopy(pool, pool.buildings[j])
			end

			self:attachEntryProp(pool)
		end
	end
end

-- Clear any reservation left over from the last run and get anybody who logged
-- out inside back onto the surface; see RESERVATIONS in the header.
function MustafarInstances:prepareCopy(pool, buildingID)
	local pBuilding = getSceneObject(buildingID)

	if (pBuilding == nil or not SceneObject(pBuilding):isBuildingObject()) then
		printLuaError("MustafarInstances: " .. pool.key .. " copy " .. buildingID .. " is missing or is not a building; that copy is out of the pool")
		return
	end

	deleteData("mustafarInstance:" .. buildingID)
	deleteData("mustafarInstance:" .. buildingID .. ":claimedAt")

	self:ejectAllPlayers(pBuilding)

	createObserver(ENTEREDBUILDING, "MustafarInstances", "onEnteredInstance", pBuilding)
	createObserver(EXITEDBUILDING, "MustafarInstances", "onExitedInstance", pBuilding)
end

function MustafarInstances:attachEntryProp(pool)
	local pProp = getSceneObject(pool.entry.nodeID)

	if (pProp == nil) then
		printLuaError("MustafarInstances: entry prop " .. pool.entry.nodeID .. " for " .. pool.key .. " was not found; that dungeon cannot be entered")
		return
	end

	writeStringData(pool.entry.nodeID .. ":mustafarInstancePool", pool.key)
	SceneObject(pProp):setObjectMenuComponent("MustafarInstanceMenuComponent")
end

--[[ Lookups ]]

function MustafarInstances:getPool(key)
	for i = 1, #self.pools do
		if (self.pools[i].key == key) then
			return self.pools[i]
		end
	end

	return nil
end

function MustafarInstances:getPoolByBuildingID(buildingID)
	for i = 1, #self.pools do
		local pool = self.pools[i]

		for j = 1, #pool.buildings do
			if (pool.buildings[j] == buildingID) then
				return pool
			end
		end
	end

	return nil
end

-- The building id list, so quest screenplays can furnish every copy of a dungeon
-- without duplicating the pool. reunite_shard.lua uses this for the fusion machine.
function MustafarInstances:getPoolBuildings(key)
	local pool = self:getPool(key)

	if (pool == nil) then
		return {}
	end

	return pool.buildings
end

--[[ Entry ]]

--[[ Most of these dungeons are open ground with a door on them; whoever walks up
     may go in. lair_of_the_crystal is not -- it is the last room of the Kenobi
     spine, and walking into it early would put the player in front of Sinistro
     with none of the arc behind them. So a pool may name a gate, and the gate is
     asked in both places: the radial is not offered to a player who cannot enter,
     and the selection is refused as well, because a radial the client already
     drew can still be clicked.

     kenobiSpineScreenPlay is a screenplay in this same Lua state, so calling it
     directly is safe; the check is written as a lookup rather than a hardcoded
     call so a second gated pool does not have to edit this function. ]]

function MustafarInstances:isEntryAllowed(pool, pPlayer)
	if (pool == nil or pPlayer == nil) then
		return false
	end

	if (pool.gate == nil) then
		return true
	end

	if (pool.gate == "kenobi_spine") then
		return kenobiSpineScreenPlay:mayEnterLair(pPlayer)
	end

	printLuaError("MustafarInstances: pool " .. pool.key .. " names an unknown gate '" .. pool.gate .. "'; it cannot be entered")

	return false
end

function MustafarInstances:enterInstance(pPlayer, poolKey)
	local pool = self:getPool(poolKey)

	if (pPlayer == nil or pool == nil or pool.entry == nil) then
		return
	end

	if (not self:isEntryAllowed(pool, pPlayer)) then
		return
	end

	local buildingID = self:findFreeCopy(pool)

	if (buildingID == 0) then
		CreatureObject(pPlayer):sendSystemMessage("@dungeon/space_dungeon:unable_to_find_dungeon") -- That area is currently unavailable. Please try again later.
		return
	end

	local pBuilding = getSceneObject(buildingID)
	local pCell = BuildingObject(pBuilding):getNamedCell(pool.entry.cell)

	if (pCell == nil) then
		printLuaError("MustafarInstances: copy " .. buildingID .. " has no cell named " .. pool.entry.cell .. "; " .. pool.key .. " cannot be entered")
		CreatureObject(pPlayer):sendSystemMessage("@dungeon/space_dungeon:unable_to_find_dungeon")
		return
	end

	writeData("mustafarInstance:" .. buildingID, 1)
	writeData("mustafarInstance:" .. buildingID .. ":claimedAt", os.time())

	if (CreatureObject(pPlayer):isRidingMount()) then
		CreatureObject(pPlayer):dismount()
	end

	writeData(SceneObject(pPlayer):getObjectID() .. ":mustafarInstance", buildingID)

	SceneObject(pPlayer):switchZone("mustafar", pool.entry.x, pool.entry.z, pool.entry.y, SceneObject(pCell):getObjectID())

	-- Starts the sweep chain for this copy; it ends itself when the copy is released.
	createEvent(self.sweepSeconds * 1000, "MustafarInstances", "checkCopy", pBuilding, "")
end

function MustafarInstances:findFreeCopy(pool)
	for i = 1, #pool.buildings do
		local buildingID = pool.buildings[i]

		if (readData("mustafarInstance:" .. buildingID) ~= 1 and getSceneObject(buildingID) ~= nil) then
			return buildingID
		end
	end

	return 0
end

--[[ Occupancy ]]

function MustafarInstances:countPlayersInside(pBuilding)
	if (pBuilding == nil) then
		return 0
	end

	local count = 0

	for i = 1, BuildingObject(pBuilding):getTotalCellNumber() do
		local pCell = BuildingObject(pBuilding):getCell(i)

		if (pCell ~= nil) then
			for j = 1, SceneObject(pCell):getContainerObjectsSize() do
				local pObject = SceneObject(pCell):getContainerObject(j - 1)

				if (pObject ~= nil and SceneObject(pObject):isPlayerCreature()) then
					count = count + 1
				end
			end
		end
	end

	return count
end

function MustafarInstances:ejectAllPlayers(pBuilding)
	if (pBuilding == nil) then
		return
	end

	local toEject = {}

	for i = 1, BuildingObject(pBuilding):getTotalCellNumber() do
		local pCell = BuildingObject(pBuilding):getCell(i)

		if (pCell ~= nil) then
			for j = 1, SceneObject(pCell):getContainerObjectsSize() do
				local pObject = SceneObject(pCell):getContainerObject(j - 1)

				if (pObject ~= nil and SceneObject(pObject):isPlayerCreature()) then
					table.insert(toEject, pObject)
				end
			end
		end
	end

	-- Collected first, then moved: switchZone mutates the cell's container while
	-- getContainerObject is walking it.
	for i = 1, #toEject do
		self:sendToExit(toEject[i], pBuilding)
	end
end

--[[ Exit ]]

function MustafarInstances:sendToExit(pPlayer, pBuilding)
	if (pPlayer == nil or pBuilding == nil) then
		return
	end

	local playerID = SceneObject(pPlayer):getObjectID()

	-- An eject is itself a switchZone out of a cell, which fires EXITEDBUILDING
	-- and lands back here. The flag makes the second pass a no-op.
	if (readData(playerID .. ":mustafarInstanceEjecting") == 1) then
		return
	end

	local pool = self:getPoolByBuildingID(SceneObject(pBuilding):getObjectID())

	if (pool == nil or pool.exit == nil) then
		printLuaError("MustafarInstances: no exit point for building " .. SceneObject(pBuilding):getObjectID() .. "; player " .. playerID .. " was left inside")
		return
	end

	writeData(playerID .. ":mustafarInstanceEjecting", 1)

	if (CreatureObject(pPlayer):isRidingMount()) then
		CreatureObject(pPlayer):dismount()
	end

	local height = getWorldFloor(pool.exit.x, pool.exit.y, "mustafar")

	SceneObject(pPlayer):switchZone("mustafar", pool.exit.x, height, pool.exit.y, 0)

	deleteData(playerID .. ":mustafarInstance")
	createEvent(2000, "MustafarInstances", "clearEjecting", pPlayer, "")
end

function MustafarInstances:clearEjecting(pPlayer)
	if (pPlayer ~= nil) then
		deleteData(SceneObject(pPlayer):getObjectID() .. ":mustafarInstanceEjecting")
	end
end

--[[ Observers ]]

function MustafarInstances:onEnteredInstance(pBuilding, pPlayer)
	if (pBuilding == nil or pPlayer == nil or not SceneObject(pPlayer):isPlayerCreature()) then
		return 0
	end

	local buildingID = SceneObject(pBuilding):getObjectID()

	-- Somebody who reached a copy without going through enterInstance -- the pool
	-- sits off the map, so in practice this is a stale reference or a warp. Claim
	-- the copy for them rather than leave it able to be handed to somebody else.
	if (readData("mustafarInstance:" .. buildingID) ~= 1) then
		writeData("mustafarInstance:" .. buildingID, 1)
		writeData("mustafarInstance:" .. buildingID .. ":claimedAt", os.time())
		createEvent(self.sweepSeconds * 1000, "MustafarInstances", "checkCopy", pBuilding, "")
	end

	writeData(SceneObject(pPlayer):getObjectID() .. ":mustafarInstance", buildingID)

	return 0
end

function MustafarInstances:onExitedInstance(pBuilding, pPlayer)
	if (pBuilding == nil or pPlayer == nil or not SceneObject(pPlayer):isPlayerCreature()) then
		return 0
	end

	self:sendToExit(pPlayer, pBuilding)
	createEvent(3000, "MustafarInstances", "releaseIfEmpty", pBuilding, "")

	return 0
end

--[[ Release

releaseIfEmpty is the one-shot fired by an exit; checkCopy is the recurring
backstop chain. Only checkCopy reschedules, so the two cannot multiply.
--]]

function MustafarInstances:releaseCopy(buildingID)
	deleteData("mustafarInstance:" .. buildingID)
	deleteData("mustafarInstance:" .. buildingID .. ":claimedAt")
end

function MustafarInstances:isReleasable(pBuilding)
	local buildingID = SceneObject(pBuilding):getObjectID()

	if (readData("mustafarInstance:" .. buildingID) ~= 1) then
		return false
	end

	if (self:countPlayersInside(pBuilding) > 0) then
		return false
	end

	local claimedAt = readData("mustafarInstance:" .. buildingID .. ":claimedAt")

	return (os.time() - claimedAt) >= self.claimGrace
end

function MustafarInstances:releaseIfEmpty(pBuilding)
	if (pBuilding ~= nil and self:isReleasable(pBuilding)) then
		self:releaseCopy(SceneObject(pBuilding):getObjectID())
	end
end

function MustafarInstances:checkCopy(pBuilding)
	if (pBuilding == nil) then
		return
	end

	local buildingID = SceneObject(pBuilding):getObjectID()

	if (readData("mustafarInstance:" .. buildingID) ~= 1) then
		return
	end

	if (self:isReleasable(pBuilding)) then
		self:releaseCopy(buildingID)
		return
	end

	createEvent(self.sweepSeconds * 1000, "MustafarInstances", "checkCopy", pBuilding, "")
end

--[[ Radial dispatch

Same shape as reunite_shard.lua's component: setObjectMenuComponent falls through
to LuaObjectMenuComponent when no C++ component of that name is registered, and
LuaObjectMenuComponent replaces the object's menu entirely, so this has to add
every item that should appear.
--]]

MustafarInstanceMenuComponent = {}

function MustafarInstanceMenuComponent:fillObjectMenuResponse(pSceneObject, pMenuResponse, pPlayer)
	if (pSceneObject == nil or pPlayer == nil or not SceneObject(pPlayer):isPlayerCreature()) then
		return
	end

	local poolKey = readStringData(SceneObject(pSceneObject):getObjectID() .. ":mustafarInstancePool")
	local pool = MustafarInstances:getPool(poolKey)

	if (pool ~= nil and pool.entry ~= nil and MustafarInstances:isEntryAllowed(pool, pPlayer)) then
		LuaObjectMenuResponse(pMenuResponse):addRadialMenuItem(20, 3, pool.entry.text)
	end
end

function MustafarInstanceMenuComponent:handleObjectMenuSelect(pSceneObject, pPlayer, selectedID)
	if (pSceneObject == nil or pPlayer == nil or selectedID ~= 20) then
		return 0
	end

	if (not CreatureObject(pPlayer):isInRangeWithObject(pSceneObject, 10)) then
		return 0
	end

	local poolKey = readStringData(SceneObject(pSceneObject):getObjectID() .. ":mustafarInstancePool")

	MustafarInstances:enterInstance(pPlayer, poolKey)

	return 0
end
