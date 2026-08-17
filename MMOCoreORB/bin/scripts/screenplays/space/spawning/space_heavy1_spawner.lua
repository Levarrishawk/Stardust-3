SpaceHeavy1Spawner = SpaceSpawnerScreenPlay:new {
	numberOfActs = 1,

	screenplayName = "SpaceHeavy1Spawner",

	spaceZone = "space_heavy1",

	--[[
	Primary Targets - the two capital ships of Deep Space. Both are attackable and both respawn
	on a timer after they are destroyed. Respawn timers match the boss-tier spawns in
	space_naboo_spawner.lua and space_yavin4_spawner.lua (minRespawn 7200, maxRespawn 10800).
	]]

	primarySpawns = {
		{spawnName = "hvy_rebel_station", shipName = "spacestation_freedom", x = -6000, z = 0, y = 0, minRespawn = 7200, maxRespawn = 10800},
		{spawnName = "imperial_star_destroyer", shipName = "star_destroyer", x = 6000, z = 0, y = 0, minRespawn = 7200, maxRespawn = 10800},
	},

	shipSpawns = {
		{spawnName = "stardestroyer_patrol_01", spawnType = SHIP_SPAWN_SQUADRON, x = 4927, z = 0, y = -7105, patrolType = SHIP_AI_FIXED_PATROL, minRespawn = 180, maxRespawn = 600, minSpawnDistance = 250, maxSpawnDistance = 500, totalSpawns = 5,
			patrolsToAssign = 5, fixedPatrolPoints = {"stardestroyer_patrol_01_00", "stardestroyer_patrol_01_01", "stardestroyer_patrol_01_02", "stardestroyer_patrol_01_03", "stardestroyer_patrol_01_04", "stardestroyer_patrol_01_05", "stardestroyer_patrol_01_06", "stardestroyer_patrol_01_07", "stardestroyer_patrol_01_08", "stardestroyer_patrol_01_09"},
			shipSpawns = {"squad_stardestroyer_1"}
		},
		{spawnName = "stardestroyer_patrol_02", spawnType = SHIP_SPAWN_SQUADRON, x = -1472, z = 0, y = 5406, patrolType = SHIP_AI_FIXED_PATROL, minRespawn = 180, maxRespawn = 600, minSpawnDistance = 400, maxSpawnDistance = 500, totalSpawns = 5,
			patrolsToAssign = 5, fixedPatrolPoints = {"stardestroyer_patrol_02_00", "stardestroyer_patrol_02_01", "stardestroyer_patrol_02_02", "stardestroyer_patrol_02_03", "stardestroyer_patrol_02_04", "stardestroyer_patrol_02_05", "stardestroyer_patrol_02_06", "stardestroyer_patrol_02_07", "stardestroyer_patrol_02_08", "stardestroyer_patrol_02_09"},
			shipSpawns = {"squad_stardestroyer_2"}
		},
		{spawnName = "stardestroyer_patrol_03", spawnType = SHIP_SPAWN_SQUADRON, x = -1968, z = 0, y = -4993, patrolType = SHIP_AI_FIXED_PATROL, minRespawn = 180, maxRespawn = 600, minSpawnDistance = 400, maxSpawnDistance = 500, totalSpawns = 5,
			patrolsToAssign = 5, fixedPatrolPoints = {"stardestroyer_patrol_03_00", "stardestroyer_patrol_03_01", "stardestroyer_patrol_03_02", "stardestroyer_patrol_03_03", "stardestroyer_patrol_03_04", "stardestroyer_patrol_03_05", "stardestroyer_patrol_03_06", "stardestroyer_patrol_03_07", "stardestroyer_patrol_03_08", "stardestroyer_patrol_03_09"},
			shipSpawns = {"squad_stardestroyer_3"}
		},
		{spawnName = "stardestroyer_patrol_04", spawnType = SHIP_SPAWN_SQUADRON, x = 6495, z = 0, y = -5985, patrolType = SHIP_AI_FIXED_PATROL, minRespawn = 180, maxRespawn = 600, minSpawnDistance = 400, maxSpawnDistance = 500, totalSpawns = 5,
			patrolsToAssign = 5, fixedPatrolPoints = {"stardestroyer_patrol_04_00", "stardestroyer_patrol_04_01", "stardestroyer_patrol_04_02", "stardestroyer_patrol_04_03", "stardestroyer_patrol_04_04", "stardestroyer_patrol_04_05", "stardestroyer_patrol_04_06", "stardestroyer_patrol_04_07", "stardestroyer_patrol_04_08", "stardestroyer_patrol_04_09"},
			shipSpawns = {"squad_stardestroyer_4"}
		},
		{spawnName = "stardestroyer_patrol_05", spawnType = SHIP_SPAWN_SQUADRON, x = 4463, z = 0, y = 6750, patrolType = SHIP_AI_FIXED_PATROL, minRespawn = 180, maxRespawn = 600, minSpawnDistance = 400, maxSpawnDistance = 500, totalSpawns = 5,
			patrolsToAssign = 5, fixedPatrolPoints = {"stardestroyer_patrol_05_00", "stardestroyer_patrol_05_01", "stardestroyer_patrol_05_02", "stardestroyer_patrol_05_03", "stardestroyer_patrol_05_04", "stardestroyer_patrol_05_05", "stardestroyer_patrol_05_06", "stardestroyer_patrol_05_07", "stardestroyer_patrol_05_08", "stardestroyer_patrol_05_09"},
			shipSpawns = {"squad_stardestroyer_5"}
		},
		{spawnName = "freedom_station_patrol_01", spawnType = SHIP_SPAWN_SQUADRON, x = -4240, z = 0, y = 6014, patrolType = SHIP_AI_FIXED_PATROL, minRespawn = 180, maxRespawn = 600, minSpawnDistance = 400, maxSpawnDistance = 500, totalSpawns = 5,
			patrolsToAssign = 5, fixedPatrolPoints = {"freedom_station_patrol_01_00", "freedom_station_patrol_01_01", "freedom_station_patrol_01_02", "freedom_station_patrol_01_03", "freedom_station_patrol_01_04", "freedom_station_patrol_01_05", "freedom_station_patrol_01_06", "freedom_station_patrol_01_07", "freedom_station_patrol_01_08", "freedom_station_patrol_01_09"},
			shipSpawns = {"squad_rebel_station_1"}
		},
		{spawnName = "freedom_station_patrol_02", spawnType = SHIP_SPAWN_SQUADRON, x = -2464, z = 0, y = -2513, patrolType = SHIP_AI_FIXED_PATROL, minRespawn = 180, maxRespawn = 600, minSpawnDistance = 400, maxSpawnDistance = 500, totalSpawns = 5,
			patrolsToAssign = 5, fixedPatrolPoints = {"freedom_station_patrol_02_00", "freedom_station_patrol_02_01", "freedom_station_patrol_02_02", "freedom_station_patrol_02_03", "freedom_station_patrol_02_04", "freedom_station_patrol_02_05", "freedom_station_patrol_02_06", "freedom_station_patrol_02_07", "freedom_station_patrol_02_08", "freedom_station_patrol_02_09"},
			shipSpawns = {"squad_rebel_station_2"}
		},
		{spawnName = "freedom_station_patrol_03", spawnType = SHIP_SPAWN_SQUADRON, x = -4448, z = 0, y = 3726, patrolType = SHIP_AI_FIXED_PATROL, minRespawn = 180, maxRespawn = 500, minSpawnDistance = 400, maxSpawnDistance = 600, totalSpawns = 5,
			patrolsToAssign = 5, fixedPatrolPoints = {"freedom_station_patrol_03_00", "freedom_station_patrol_03_01", "freedom_station_patrol_03_02", "freedom_station_patrol_03_03", "freedom_station_patrol_03_04", "freedom_station_patrol_03_05", "freedom_station_patrol_03_06", "freedom_station_patrol_03_07", "freedom_station_patrol_03_08", "freedom_station_patrol_03_09"},
			shipSpawns = {"squad_rebel_station_3"}
		},
		{spawnName = "freedom_station_patrol_04", spawnType = SHIP_SPAWN_SQUADRON, x = 2287, z = 0, y = 5486, patrolType = SHIP_AI_FIXED_PATROL, minRespawn = 180, maxRespawn = 500, minSpawnDistance = 400, maxSpawnDistance = 600, totalSpawns = 5,
			patrolsToAssign = 5, fixedPatrolPoints = {"freedom_station_patrol_04_00", "freedom_station_patrol_04_01", "freedom_station_patrol_04_02", "freedom_station_patrol_04_03", "freedom_station_patrol_04_04", "freedom_station_patrol_04_05", "freedom_station_patrol_04_06", "freedom_station_patrol_04_07", "freedom_station_patrol_04_08", "freedom_station_patrol_04_09"},
			shipSpawns = {"squad_rebel_station_4"}
		},
		{spawnName = "freedom_station_patrol_05", spawnType = SHIP_SPAWN_SQUADRON, x = 831, z = 0, y = -6561, patrolType = SHIP_AI_FIXED_PATROL, minRespawn = 180, maxRespawn = 500, minSpawnDistance = 400, maxSpawnDistance = 600, totalSpawns = 5,
			patrolsToAssign = 5, fixedPatrolPoints = {"freedom_station_patrol_05_00", "freedom_station_patrol_05_01", "freedom_station_patrol_05_02", "freedom_station_patrol_05_03", "freedom_station_patrol_05_04", "freedom_station_patrol_05_05", "freedom_station_patrol_05_06", "freedom_station_patrol_05_07", "freedom_station_patrol_05_08", "freedom_station_patrol_05_09"},
			shipSpawns = {"squad_rebel_station_5"}
		},
	},
}

registerScreenPlay("SpaceHeavy1Spawner", true)

function SpaceHeavy1Spawner:start()
	if (not isZoneEnabled(self.spaceZone)) then
		return
	end

	local randomDelay = getRandomNumber(self.SERVER_STARTUP_MIN, self.SERVER_STARTUP_MAX)

	if (self.SPAWN_NO_DELAY) then
		randomDelay = 20
	end

	createEvent(randomDelay * 1000, self.screenplayName, "populateSpawns", nil, "")

	createEvent(randomDelay * 500, self.screenplayName, "spawnPrimaryTargets", nil, "")
end

function SpaceHeavy1Spawner:spawnPrimaryTargets()
	local primarySpawns = self.primarySpawns

	if (#primarySpawns < 1) then
		return
	end

	for i = 1, #primarySpawns, 1 do
		self:spawnPrimaryTarget(nil, tostring(i))
	end
end

function SpaceHeavy1Spawner:spawnPrimaryTarget(pNil, indexString)
	local tableNum = tonumber(indexString)

	local spawnTable = self.primarySpawns[tableNum]

	if (spawnTable == nil) then
		return
	end

	local pShipAgent = spawnShipAgent(spawnTable.shipName, self.spaceZone, spawnTable.x, spawnTable.z, spawnTable.y)

	if (pShipAgent == nil) then
		Logger:log(self.screenplayName .. " -- ERROR: Failed to spawn Ship Agent: " .. spawnTable.shipName .. " Spawner Name: " .. spawnTable.spawnName, LT_ERROR)
		return
	end

	ShipAiAgent(pShipAgent):setDespawnOnNoPlayerInRange(false)

	createObserver(SHIPDESTROYED, self.screenplayName, "primaryTargetDestroyed", pShipAgent)

	local agentID = SceneObject(pShipAgent):getObjectID()

	writeData(agentID .. ":PrimaryIndex:", tableNum)
	writeStringData(agentID .. ":PrimaryName:", spawnTable.spawnName)
end

function SpaceHeavy1Spawner:primaryTargetDestroyed(pShipAgent, pKillerShip)
	if (pShipAgent == nil or not SceneObject(pShipAgent):isShipAiAgent()) then
		return 1
	end

	local agentID = SceneObject(pShipAgent):getObjectID()
	local tableNum = readData(agentID .. ":PrimaryIndex:")

	-- Delete the data so it does not leak
	deleteData(agentID .. ":PrimaryIndex:")
	deleteStringData(agentID .. ":PrimaryName:")

	local spawnTable = self.primarySpawns[tableNum]

	if (spawnTable == nil) then
		return 1
	end

	local minRespawn = spawnTable.minRespawn
	local maxRespawn = spawnTable.maxRespawn

	createEvent(getRandomNumber(minRespawn, maxRespawn) * 1000, self.screenplayName, "spawnPrimaryTarget", nil, tostring(tableNum))

	return 1
end
