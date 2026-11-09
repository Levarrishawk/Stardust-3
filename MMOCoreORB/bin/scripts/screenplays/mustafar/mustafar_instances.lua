-- Six native buildout pools. Entry cells and transfer coordinates are from
-- DSRC datatables/instance/instance_datatable.tab. Coordinates in Lua are
-- stored in Core3 switchZone order (x, height, y).
--
-- The two factories share an exterior door. story_arc_chapters.lua owns its
-- radial and selects the pool, so neither factory registers a separate entry.
--
-- Party members use the copy of a groupmate already inside. The occupancy
-- sweep releases empty copies after the transfer grace period or expires a run.

MustafarInstances = ScreenPlay:new {
	numberOfActs = 1,

	screenplayName = "MustafarInstances",

	-- Hold an empty copy long enough for the transfer to finish.
	claimGrace = 60,

	-- How often the self-rescheduling sweep revisits a claimed copy.
	sweepSeconds = 120,
	maxPlayers = 8,
	timeLimit = 3600,

	pools = {
		{
			key = "old_republic_facility",
			label = "Old Republic Facility",

			buildings = { 0xf8acfffffcc2fd70, 0xf8abfffffcc2fd70, 0xf8adfffffcc2fd70, 0xf8aefffffcc2fd70,
				0xf8affffffcc2fd70, 0xf8b0fffffcc2fd70, 0xf8b1fffffcc2fd70, 0xf8b2fffffcc2fd70,
				0xf8b3fffffcc2fd70, 0xf8b4fffffcc2fd70, 0xf8b5fffffcc2fd70, 0xf8b6fffffcc2fd70 },
			entry = {
				nodeID = MustafarBuildout.objects[12110161],
				text = "@travel/zone_transition:old_republic_facility",
				cell = "entrance", x = 12, z = 0, y = 0,
			},
			exit = { x = -768, z = 87, y = 6078 },
			gate = "old_republic_facility",
		},
		{
			key = "monster_lair",
			label = "Sherkar's Lair",
			buildings = { 0xf8a0fffffcc28840, 0xf89ffffffcc28840, 0xf8a1fffffcc28840, 0xf8a2fffffcc28840,
				0xf8a3fffffcc28840, 0xf8a4fffffcc28840, 0xf8a5fffffcc28840, 0xf8a6fffffcc28840,
				0xf8a7fffffcc28840, 0xf8a8fffffcc28840, 0xf8a9fffffcc28840, 0xf8aafffffcc28840 },
			entry = {
				nodeID = MustafarBuildout.objects[12110143],
				text = "@travel/zone_transition:sher_kar_cave",
				cell = "r1", x = -56, z = -5, y = 20,
			},
			exit = { x = -2017, z = 82, y = 4197 },
			door = MustafarBuildout.objects[12110143],
		},
		{
			key = "uplink_cave",
			label = "Uplink Cave",
			buildings = { 0xf8d7fffffcc4d230, 0xf8d8fffffcc4d230, 0xf8d9fffffcc4d230, 0xf8dafffffcc4d230,
				0xf8dbfffffcc4d230, 0xf8dcfffffcc4d230, 0xf8ddfffffcc4d230, 0xf8defffffcc4d230 },
			entry = {
				nodeID = MustafarBuildout.objects[12111281],
				text = "@dungeon/space_dungeon:uplink_cave",
				cell = "mainroom", x = -85, z = 0, y = 128,
			},
			exit = { x = -3601, z = 158, y = 3486 },
			gate = "story_arc_uplink",
			door = MustafarBuildout.objects[12111281],
		},
		{
			key = "lair_of_the_crystal",
			label = "Lair of the Crystal",
			maxPlayers = 1,
			timeLimit = 1800,
			buildings = { 0xf8ccfffffcc45d00, 0xf8cdfffffcc45d00, 0xf8cbfffffcc45d00, 0xf8cefffffcc45d00,
				0xf8cffffffcc45d00, 0xf8d0fffffcc45d00, 0xf8d1fffffcc45d00, 0xf8d2fffffcc45d00,
				0xf8d3fffffcc45d00, 0xf8d4fffffcc45d00, 0xf8d5fffffcc45d00, 0xf8d6fffffcc45d00 },
			entry = {
				nodeID = MustafarBuildout.objects[12112106],
				text = "Wedge the crystal shard into the pillar",
				cell = "mainroom", x = 9.4, z = 0, y = -3.5,
			},
			exit = { x = -2696, z = 42, y = 6077 },
			gate = "kenobi_spine",
			door = MustafarBuildout.objects[12112106],
		},
		{
			key = "working_droid_factory",
			label = "Working Droid Factory",
			buildings = { 0xfffffffffcab2fb0, 0xfffffffffcaaba80, 0xfffffffffcaba4e0, 0xfffffffffcac1a10,
				0xfffffffffcac8f40, 0xfffffffffcad0470, 0xfffffffffcad79a0, 0xfffffffffcadeed0,
				0xfffffffffcae6400, 0xfffffffffcaed930, 0xfffffffffcaf4e60, 0xfffffffffcafc390 },
			entry = {
				cell = "hall1", x = 0, z = 0, y = 4,
			},
			exit = { x = 515, z = 64, y = 1991 },
			gate = "story_arc_factory",
			door = MustafarBuildout.objects[12112909],
		},
		{
			key = "decrepit_droid_factory",
			label = "Decrepit Droid Factory",
			buildings = { 0xfffffffffcb038c0, 0xfffffffffcb0adf0, 0xfffffffffcb12320, 0xfffffffffcb19850,
				0xfffffffffcb20d80, 0xfffffffffcb282b0, 0xfffffffffcb2f7e0, 0xfffffffffcb36d10 },
			entry = {
				cell = "hall1", x = 0, z = 0, y = 4,
			},
			exit = { x = 515, z = 64, y = 1991 },
			gate = "story_arc_factory",
			door = MustafarBuildout.objects[12112909],
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

function MustafarInstances:prepareCopy(pool, buildingID)
	local pBuilding = getSceneObject(buildingID)

	if (pBuilding == nil or not SceneObject(pBuilding):isBuildingObject()) then
		printLuaError("MustafarInstances: " .. pool.key .. " copy " .. buildingID .. " is missing or is not a building; that copy is out of the pool")
		return
	end

	self:releaseCopy(buildingID)

	self:ejectAllPlayers(pBuilding)

	createObserver(ENTEREDBUILDING, "MustafarInstances", "onEnteredInstance", pBuilding)
	createObserver(EXITEDBUILDING, "MustafarInstances", "onExitedInstance", pBuilding)
end

--[[ A pool may have an entry point without owning a prop's radial. entry.nodeID
     nil means "somebody else owns the node that leads here" -- the two droid
     factory pools share door 12112909 with story_arc_chapters.lua, which holds
     that node's menu component for its own two tasks. setObjectMenuComponent
     REPLACES a menu rather than stacking, so attaching here would destroy those
     radials silently. Skipping is the whole mechanism that lets the factories be
     entered without a collision; it is not a disabled pool. ]]
function MustafarInstances:attachEntryProp(pool)
	if (pool.entry.nodeID == nil) then
		return
	end

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

function MustafarInstances:isEntryAllowed(pool, pPlayer)
	if (pool == nil or pPlayer == nil) then
		return false
	end

	if (pool.gate == nil) then
		return true
	end

	-- Guards fail closed: a missing gate screenplay must refuse, never admit.
	if (pool.gate == "kenobi_spine") then
		if (kenobiSpineScreenPlay == nil) then
			printLuaError("MustafarInstances: pool " .. pool.key .. " is gated on kenobi_spine.lua, which is not loaded; refusing entry")
			return false
		end

		return not CreatureObject(pPlayer):isGrouped() and kenobiSpineScreenPlay:mayEnterLair(pPlayer)
	end

	if (pool.gate == "old_republic_facility") then
		return self:mayEnterOldRepublicFacility(pPlayer)
	end

	if (pool.gate == "story_arc_uplink") then
		if (storyArcChaptersScreenPlay == nil) then
			printLuaError("MustafarInstances: pool " .. pool.key .. " is gated on story_arc_chapters.lua, which is not loaded; refusing entry")
			return false
		end

		return storyArcChaptersScreenPlay:mayEnterUplinkCave(pPlayer)
	end

	if (pool.gate == "story_arc_factory") then
		if (storyArcChaptersScreenPlay == nil) then
			printLuaError("MustafarInstances: pool " .. pool.key .. " is gated on story_arc_chapters.lua, which is not loaded; refusing entry")
			return false
		end

		return storyArcChaptersScreenPlay:mayEnterDroidFactory(pPlayer)
	end

	printLuaError("MustafarInstances: pool " .. pool.key .. " names an unknown gate '" .. pool.gate .. "'; it cannot be entered")

	return false
end

function MustafarInstances:mayEnterOldRepublicFacility(pPlayer)
	if (readScreenPlayData(pPlayer, self.screenplayName, "oldRepublicAccess") == "1") then
		return true
	end

	if (storyArcChaptersScreenPlay ~= nil
		and storyArcChaptersScreenPlay:getStage(pPlayer) >= storyArcChaptersScreenPlay.STAGE_TRAVEL_ORF) then
		return true
	end

	if (historianScreenPlay ~= nil) then
		local stage = historianScreenPlay:getStage(pPlayer)
		if (stage == historianScreenPlay.STAGE_Q1 or stage == historianScreenPlay.STAGE_Q1_TURNIN) then
			return true
		end
	end

	if (reuniteShardScreenPlay ~= nil) then
		local stage = reuniteShardScreenPlay:rawStage(pPlayer)
		return stage >= 4 and stage <= 6
	end

	return false
end

function MustafarInstances:enterInstance(pPlayer, poolKey)
	local pool = self:getPool(poolKey)

	if (pPlayer == nil or pool == nil or pool.entry == nil) then
		return
	end

	if (not self:isEntryAllowed(pool, pPlayer)) then
		-- Say so. A silent return is indistinguishable from a broken radial, and that
		-- is how a wrong gate threshold sat unnoticed: the task inside was refused at
		-- the door and nothing reported it.
		CreatureObject(pPlayer):sendSystemMessage("@dungeon/space_dungeon:not_authorized") -- You do not have the proper authorization to be in this area.
		return
	end

	local pBuilding = self:findPartyCopy(pPlayer, pool)
	local joining = pBuilding ~= nil
	if (not joining) then
		pBuilding = self:findFreeCopy(pool)
	end

	if (pBuilding == nil or not SceneObject(pBuilding):isBuildingObject()) then
		CreatureObject(pPlayer):sendSystemMessage("@dungeon/space_dungeon:unable_to_find_dungeon") -- That area is currently unavailable. Please try again later.
		return
	end
	if (SceneObject(pPlayer):getRootParent() == pBuilding) then
		return
	end
	if (joining and self:countPlayersInside(pBuilding) >= (pool.maxPlayers or self.maxPlayers)) then
		CreatureObject(pPlayer):sendSystemMessage("@dungeon/space_dungeon:unable_to_find_dungeon")
		return
	end

	local buildingID = SceneObject(pBuilding):getObjectID()
	local pCell = BuildingObject(pBuilding):getNamedCell(pool.entry.cell)

	if (pCell == nil) then
		printLuaError("MustafarInstances: copy " .. buildingID .. " has no cell named " .. pool.entry.cell .. "; " .. pool.key .. " cannot be entered")
		CreatureObject(pPlayer):sendSystemMessage("@dungeon/space_dungeon:unable_to_find_dungeon")
		return
	end

	if (pool.key == "old_republic_facility") then
		writeScreenPlayData(pPlayer, self.screenplayName, "oldRepublicAccess", "1")
	end

	if (not joining) then
		self:claimCopy(pBuilding, pool)
	end

	if (CreatureObject(pPlayer):isRidingMount()) then
		CreatureObject(pPlayer):dismount()
	end

	writeData(SceneObject(pPlayer):getObjectID() .. ":mustafarInstance", buildingID)

	SceneObject(pPlayer):switchZone("mustafar", pool.entry.x, pool.entry.z, pool.entry.y, SceneObject(pCell):getObjectID())
end

function MustafarInstances:findPartyCopy(pPlayer, pool)
	if (pool.maxPlayers == 1) then
		return nil
	end

	local player = CreatureObject(pPlayer)
	for i = 0, player:getGroupSize() - 1 do
		local pMember = player:getGroupMember(i)
		if (pMember ~= nil and pMember ~= pPlayer and SceneObject(pMember):isPlayerCreature()) then
			local pBuilding = SceneObject(pMember):getRootParent()
			if (pBuilding ~= nil and SceneObject(pBuilding):isBuildingObject()) then
				local buildingID = SceneObject(pBuilding):getObjectID()
				local key = "mustafarInstance:" .. buildingID
				if (self:getPoolByBuildingID(buildingID) == pool and readData(key) == 1
					and readData(key .. ":expiresAt") > os.time()) then
					return pBuilding
				end
			end
		end
	end
end

function MustafarInstances:findFreeCopy(pool)
	for i = 1, #pool.buildings do
		local buildingID = pool.buildings[i]

		if (readData("mustafarInstance:" .. buildingID) ~= 1) then
			local pBuilding = getSceneObject(buildingID)
			if (pBuilding ~= nil and SceneObject(pBuilding):isBuildingObject()) then
				return pBuilding
			end
		end
	end
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

	SceneObject(pPlayer):switchZone("mustafar", pool.exit.x, pool.exit.z, pool.exit.y, 0)

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
		local pool = self:getPoolByBuildingID(buildingID)
		if (pool == nil) then
			return 0
		end
		self:claimCopy(pBuilding, pool)
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

function MustafarInstances:claimCopy(pBuilding, pool)
	local key = "mustafarInstance:" .. SceneObject(pBuilding):getObjectID()
	local now = os.time()
	writeData(key .. ":claimedAt", now)
	writeData(key .. ":expiresAt", now + (pool.timeLimit or self.timeLimit))
	writeData(key, 1)
	self:scheduleCopyCheck(pBuilding, key, self.sweepSeconds)
end

function MustafarInstances:releaseCopy(buildingID)
	local key = "mustafarInstance:" .. buildingID
	deleteData(key)
	deleteData(key .. ":claimedAt")
	deleteData(key .. ":expiresAt")
end

function MustafarInstances:scheduleCopyCheck(pBuilding, key, delay)
	if (readData(key .. ":checkPending") == 0) then
		writeData(key .. ":checkPending", 1)
		createEvent(delay * 1000, "MustafarInstances", "checkCopy", pBuilding, "")
	end
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
	local key = "mustafarInstance:" .. buildingID
	deleteData(key .. ":checkPending")

	if (readData(key) ~= 1) then
		return
	end
	local remaining = readData(key .. ":expiresAt") - os.time()
	if (remaining <= 0) then
		self:ejectAllPlayers(pBuilding)
		self:releaseCopy(buildingID)
		return
	end

	if (self:isReleasable(pBuilding)) then
		self:releaseCopy(buildingID)
		return
	end

	self:scheduleCopyCheck(pBuilding, key, math.min(self.sweepSeconds, remaining))
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
