--[[
	Leg structure taken from spacequest/convoy/ep3_trando_lesnorr.stf and
	spacequest/convoy/kashyyyk_mining_quest_11.stf (51 entries each):

		task 0 - quest_location  : travel to the quest zone
		task 1 - quest_rendezvous: meet the convoy at the rendezvous point
			:found_loc        - sent when the rendezvous waypoint is handed out
			:arrived_at_loc   - sent when the player reaches the rendezvous area
			:arrival_greeting - convoy leader greets the player
			:ship_greeting    - each remaining convoy ship checks in
			:ready_to_go      - convoy reports it is formed up
			:lets_move        - convoy sets course
			:get_moving       - the order to begin the run
		task 2 - quest_escort    : escort the convoy to its destination
			:attack_notify / :attack_stopped - wave arrival and wave cleared
			:taunt_1..N       - attacker taunt on wave arrival
			:panic_1..N       - convoy ship under fire
			:panic_destroyed_1..N - convoy ship going down
			:thanks_1..N      - convoy thanks the player once a wave is cleared
			:convoy_ship_lost - one convoy ship destroyed, others still running
			:convoy_destroyed - every convoy ship destroyed, quest fails
			:convoy_safe      - a convoy ship reached the destination
			:convoy_arrived   - the run is over with at least one survivor
			:complete         - final quest_update line

	:no_convoy, :were_moving and :abort are conversation replies, not screenplay messages, and
	:hull_half / :shields_depleted need a hull and shield threshold notification that the ship
	agent layer does not expose to Lua, so they are not emitted here.
]]

SpaceConvoyScreenplay = SpaceQuestLogic:new {
	className = "SpaceConvoyScreenplay",

	questName = "",
	questType = "",

	questZone = "",

	creditReward = 0,
	itemReward = {
		--{species = {}, item = ""},
	},

	sideQuest = false,
	sideQuestType = "",
	sideQuestName = "",

	DEBUG_SPACE_CONVOY = false,

	escortRange = 1000,
	escortSpeed = 20,
	testEscortSpeed = 40,

	--[[
		convoyShips / convoyPoints are the CANONICAL names for this class and every in-tree
		convoy quest uses them (convoy_ep3_trando_lesnorr, convoy_kashyyyk_mining_quest_11).

		escortShips / escortPoints are a deliberate COMPATIBILITY SHIM with no current consumer.
		They are kept, not removed, for two reasons:
		  1. The escort vocabulary is otherwise still live in this class -- escortRange /
		     escortSpeed / testEscortSpeed are real, read fields, and escortNumber is a required
		     key on every convoy point -- so a quest ported from SpaceEscortScreenplay will
		     naturally reach for escortShips / escortPoints too.
		  2. They must stay DECLARED as empty tables regardless: getConvoyPoints /
		     getConvoyShips fall through to them, and `#nil` is a hard error, so deleting the
		     declarations converts a silent-empty-convoy into a crash.
		Both aliases are read only through the two accessors below -- never index them directly.
	]]
	convoyShips = {},
	escortShips = {},

	convoyPoints = {
		--{patrolPointName = "", zoneName = "space_kashyyyk", x = -4381, z = -4943, y = -7262, escortNumber = 1, radius = 150},
	},

	escortPoints = {},

	spawnAttackWaves = true,
	checkPlayerDistance = true,

	arrivalDelay = 5, -- In Seconds

	attackDelay = 0, -- In Seconds
	attackShips = {},

	tauntData = {
		panicCount = 5,
		panicDestroyedCount = 5,
		tauntCount = 5,
		thanksCount = 5,
	},
}

registerScreenPlay("SpaceConvoyScreenplay", false)

--[[

		Space Convoy Quest Functions

--]]

function SpaceConvoyScreenplay:start()
	self:spawnActiveAreas()
end

function SpaceConvoyScreenplay:startQuest(pPlayer, pNpc)
	if (pPlayer == nil) then
		Logger:log("Quest: " .. self.questName .. " Type: " .. self.questType .. " -- Failed to startQuest due to pPlayer being nil.", LT_ERROR)
		return
	end

	if (self.DEBUG_SPACE_CONVOY) then
		print(self.className .. ":startQuest called -- QuestType: " .. self.questType .. " Quest Name: " .. self.questName)
	end

	if (pNpc == "") then
		pNpc = nil
	end

	-- Activate the Journal Quest
	SpaceHelpers:activateSpaceQuest(pPlayer, pNpc, self.questType, self.questName, false)

	local spaceQuestHash = getHashCode(self.questZone)
	local zoneName = SceneObject(pPlayer):getZoneName()
	local playerZoneHash = getHashCode(zoneName)
	local pRootParent = SceneObject(pPlayer):getRootParent()

	-- Check if the player is in the proper zone already
	if (playerZoneHash == spaceQuestHash and not SpaceHelpers:isInYacht(pPlayer)) then
		-- Complete the quest task 0
		SpaceHelpers:completeSpaceQuestTask(pPlayer, self.questType, self.questName, 0, false)

		-- Activate quest task 1
		SpaceHelpers:activateSpaceQuestTask(pPlayer, self.questType, self.questName, 1, true)

		createEvent(2000, self.className, "setupConvoy", pPlayer, "")
	end

	-- Create inital observer for player entering Zone and to handle failing quest
	if (not hasObserver(ZONESWITCHED, self.className, "enteredZone", pPlayer)) then
		createObserver(ZONESWITCHED, self.className, "enteredZone", pPlayer, 1)
	end
end

function SpaceConvoyScreenplay:completeQuest(pPlayer, notifyClient)
	if (pPlayer == nil) then
		Logger:log("Quest: " .. self.questName .. " Type: " .. self.questType .. " -- Failed to completeQuest due to pPlayer being nil.", LT_ERROR)
		return
	end

	if (self.DEBUG_SPACE_CONVOY) then
		print(self.className .. ":completeQuest called -- QuestType: " .. self.questType .. " Quest Name: " .. self.questName)
	end

	local notifyBool = true

	if (notifyClient == "false") then
		notifyBool = false
	end

	-- Complete the Journal Quest
	SpaceHelpers:completeSpaceQuest(pPlayer, self.questType, self.questName, notifyBool)

	-- Remove the zone entry observer
	dropObserver(ZONESWITCHED, self.className, "enteredZone", pPlayer)

	self:cleanUpQuestData(SceneObject(pPlayer):getObjectID())

	if (self.sideQuest and (self.sideQuestSplitType == self.SIDE_QUEST_SPLIT_TYPES.COMPLETION or self.sideQuestSplitType == self.SIDE_QUEST_SPLIT_TYPES.BIDIRECTIONAL)) then
		local alertMessage = "@spacequest/" .. self.questType .. "/" .. self.questName .. ":split_quest_alert"

		-- Split Quest Alert
		createEvent(self.sideQuestDelay * 1000, "SpaceHelpers", "sendQuestAlert", pPlayer, alertMessage)

		-- Trigger Sidequest
		createEvent(self.sideQuestDelay * 1050, self.sideQuestType .. "_" .. self.sideQuestName, "startQuest", pPlayer, "")
	end
end

function SpaceConvoyScreenplay:failQuest(pPlayer, notifyClient)
	if (pPlayer == nil) then
		Logger:log(self.questName .. " Type: " .. self.questType .. " -- Failed to failQuest due to pPlayer being nil.", LT_ERROR)
		return
	end

	if (not SpaceHelpers:isSpaceQuestActive(pPlayer, self.questType, self.questName)) then
		return
	end

	if (self.DEBUG_SPACE_CONVOY) then
		print(self.className .. ":failQuest called -- QuestType: " .. self.questType .. " Quest Name: " .. self.questName)
	end

	local notifyBool = true

	if (notifyClient == "false") then
		notifyBool = false
	end

	-- Set Quest failed
	SpaceHelpers:failSpaceQuest(pPlayer, self.questType, self.questName, notifyBool)

	-- Remove any patrol points
	SpaceHelpers:clearQuestWaypoint(pPlayer, self.className)

	-- Remove the zone entry observer
	dropObserver(ZONESWITCHED, self.className, "enteredZone", pPlayer)

	self:cleanUpQuestData(SceneObject(pPlayer):getObjectID())

	-- Fail the parent quest
	if (self.parentQuestType ~= "") then
		createEvent(200, self.parentQuestType .. "_" .. self.parentQuestName, "failQuest", pPlayer, "false")
	end

	-- Fail the side quest
	if (self.sideQuest and SpaceHelpers:isSpaceQuestActive(pPlayer, self.sideQuestType, self.sideQuestName)) then
		createEvent(200, self.sideQuestType .. "_" .. self.sideQuestName, "failQuest", pPlayer, "false")
	end

	if (self.sideQuest and (self.sideQuestSplitType == self.SIDE_QUEST_SPLIT_TYPES.FAILURE or self.sideQuestSplitType == self.SIDE_QUEST_SPLIT_TYPES.BIDIRECTIONAL)) then
		self:triggerFailureSplitQuest(pPlayer)
	end
end

function SpaceConvoyScreenplay:resetQuest(pPlayer)
	if (pPlayer == nil) then
		Logger:log(self.questName .. " Type: " .. self.questType .. " -- Failed to resetQuest due to pPlayer being nil.", LT_ERROR)
		return
	end

	if (self.DEBUG_SPACE_CONVOY) then
		print(self.className .. ":resetQuest called -- QuestType: " .. self.questType .. " Quest Name: " .. self.questName)
	end

	-- Set Quest failed
	SpaceHelpers:failSpaceQuest(pPlayer, self.questType, self.questName, false)

	-- Remove any patrol points
	SpaceHelpers:clearQuestWaypoint(pPlayer, self.className)

	-- Remove the zone entry observer
	dropObserver(ZONESWITCHED, self.className, "enteredZone", pPlayer)

	self:cleanUpQuestData(SceneObject(pPlayer):getObjectID())
end

function SpaceConvoyScreenplay:cleanUpQuestData(playerID)
	local pPlayer = getSceneObject(playerID)

	-- Despawn anything still flying for this player
	self:despawnShips(pPlayer)

	-- Delete player location data
	deleteData(playerID .. ":" .. self.className .. ":location:")

	-- Delete Start point
	deleteData(playerID .. self.className .. ":startPoint:")

	-- Delete the distance warnings
	deleteData(playerID .. ":" .. self.className .. ":distanceWarnings:")

	-- Delete the convoy tallies
	deleteData(playerID .. ":" .. self.className .. ":convoyTotal:")
	deleteData(playerID .. ":" .. self.className .. ":convoyArrived:")
	deleteData(playerID .. ":" .. self.className .. ":convoyLost:")

	-- Kill Count Tracking
	deleteData(playerID .. ":" .. self.className .. ":" .. ":ConvoyKillCount:")
end

--[[

		Space Convoy Quest Mechanics

--]]

-- The convoy lane, convoyPoints is preferred and escortPoints is the accepted alias
function SpaceConvoyScreenplay:getConvoyPoints()
	if (#self.convoyPoints > 0) then
		return self.convoyPoints
	end

	return self.escortPoints
end

-- The ships that make up the convoy, convoyShips is preferred and escortShips is the alias
function SpaceConvoyScreenplay:getConvoyShips()
	if (#self.convoyShips > 0) then
		return self.convoyShips
	end

	return self.escortShips
end

function SpaceConvoyScreenplay:spawnActiveAreas()
	local areasTable = self:getConvoyPoints()

	for i = 1, #areasTable, 1 do
		local zoneName = areasTable[i].zoneName
		local x = areasTable[i].x
		local z = areasTable[i].z
		local y = areasTable[i].y
		local escortNumber = areasTable[i].escortNumber

		if (not isZoneEnabled(zoneName)) then
			goto skip
		end

		local pQuestArea = spawnSpaceActiveArea(zoneName, "object/space_active_area.iff", x, z, y, areasTable[i].radius)

		if pQuestArea == nil then
			Logger:log(self.className .. ":spawnActiveAreas -- pQuestArea is nil.", LT_ERROR)
			return
		end

		local questAreaID = SceneObject(pQuestArea):getObjectID()

		-- Write the convoy point number
		writeData(questAreaID .. ":" .. self.className, escortNumber)

		-- Add Entry Observer for ships
		createObserver(ENTEREDAREA, self.className, "notifyEnteredQuestArea", pQuestArea)

		if (self.DEBUG_SPACE_CONVOY) then
			print(self.className .. ":spawnActiveAreas - Area Spawned ID: " .. questAreaID .. " Observer: " .. self.className .. ":notifyEnteredQuestArea Convoy Point Number: " .. escortNumber)
		end

		::skip::
	end
end

function SpaceConvoyScreenplay:setupConvoy(pPlayer)
	if (pPlayer == nil) then
		Logger:log("Quest: " .. self.questName .. " Type: " .. self.questType .. " -- Failed to setupConvoy due to pPlayer being nil.", LT_ERROR)
		return
	end

	local pGhost = CreatureObject(pPlayer):getPlayerObject()

	if (pGhost == nil) then
		return
	end

	local convoyPoints = self:getConvoyPoints()

	-- No lane was authored, the convoy has nowhere to run, do not hold the players datapad open
	if (#convoyPoints == 0 or #self:getConvoyShips() == 0) then
		Logger:log(self.className .. ":setupConvoy -- Quest: " .. self.questName .. " has no convoy ships or convoy points authored.", LT_ERROR)

		createEvent(1000, self.className, "completeQuest", pPlayer, "true")
		return
	end

	local playerID = SceneObject(pPlayer):getObjectID()

	-- Quest Progress update
	SpaceHelpers:sendQuestProgess(pPlayer, "@spacequest/" .. self.questType .. "/" .. self.questName .. ":title")

	-- The convoy always forms up on the first point of the lane and runs it in order
	writeData(playerID .. self.className .. ":startPoint:", convoyPoints[1].escortNumber)
	writeData(playerID .. ":" .. self.className .. ":location:", 1)

	if (self.DEBUG_SPACE_CONVOY) then
		print(self.className .. ":setupConvoy called -- QuestType: " .. self.questType .. " Quest Name: " .. self.questName .. " Convoy Points: " .. #convoyPoints)
	end

	-- Add rendezvous point to the player
	local convoyPoint = convoyPoints[1]
	local waypointID = PlayerObject(pGhost):addWaypoint(convoyPoint.zoneName, "@spacequest/" .. self.questType .. "/" .. self.questName .. ":quest_rendezvous_t", "", convoyPoint.x, convoyPoint.z, convoyPoint.y, WAYPOINT_SPACE, true, true, WAYPOINTQUESTTASK)

	local pWaypoint = getSceneObject(waypointID)

	if (pWaypoint ~= nil) then
		WaypointObject(pWaypoint):setQuestDetails("@spacequest/" .. self.questType .. "/" .. self.questName .. ":title_d")
	end

	-- Store the waypointID on the player
	setQuestStatus(playerID .. ":" .. self.className .. ":waypointID", waypointID)

	local questUpdate = LuaStringIdChatParameter("@spacequest/" .. self.questType .. "/" .. self.questName .. ":quest_update")
	questUpdate:setTO("@spacequest/" .. self.questType .. "/" .. self.questName .. ":found_loc")

	CreatureObject(pPlayer):sendSystemMessage(questUpdate:_getObject())
end

function SpaceConvoyScreenplay:spawnConvoy(pPlayer)
	if (pPlayer == nil) then
		Logger:log(self.className .. ":spawnConvoy -- pPlayer is nil.", LT_ERROR)
		return
	end

	if (not SpaceHelpers:isSpaceQuestActive(pPlayer, self.questType, self.questName)) then
		return
	end

	local pPlayerShip = SceneObject(pPlayer):getRootParent()

	if (pPlayerShip == nil or not SceneObject(pPlayerShip):isShipObject()) then
		Logger:log(self.className .. ":spawnConvoy -- pPlayerShip is nil.", LT_ERROR)
		return
	end

	-- Remove the rendezvous waypoint from player
	SpaceHelpers:clearQuestWaypoint(pPlayer, self.className)

	local playerID = SceneObject(pPlayer):getObjectID()
	local convoyShips = self:getConvoyShips()
	local convoyPoints = self:getConvoyPoints()
	local spawnLocation = ShipObject(pPlayerShip):getSpawnPointInFrontOfShip(50, 250)

	local playerFactionHash = SpaceHelpers:getPlayerShipFactionHash(pPlayer)
	local shipIDs = {}
	local pConvoyLeader = nil

	for i = 1, #convoyShips, 1 do
		local pShipAgent = spawnShipAgent(convoyShips[i], self.questZone, spawnLocation[1] + getRandomNumber(25, 100), spawnLocation[2], spawnLocation[3] + getRandomNumber(25, 100), pPlayerShip)

		if (pShipAgent == nil) then
			goto continue
		end

		local agentID = SceneObject(pShipAgent):getObjectID()

		-- Set the agent as a mission object
		CreatureObject(pPlayer):addSpaceMissionObject(agentID, (i == #convoyShips))

		-- Set as a mission-specific ship locked to the mission holder
		ShipAiAgent(pShipAgent):setMissionOwner(pPlayer)

		-- Set Fixed Patrol and escort flags
		ShipAiAgent(pShipAgent):setFixedPatrol()
		ShipAiAgent(pShipAgent):setEscort()

		if (self.DEBUG_SPACE_CONVOY) then
			ShipAiAgent(pShipAgent):setEscortSpeed(self.testEscortSpeed)
		else
			ShipAiAgent(pShipAgent):setEscortSpeed(self.escortSpeed)
		end

		-- Set as same space faction
		ShipObject(pShipAgent):setShipFactionString(SpaceHelpers:getPlayerShipFactionString(pPlayer))

		ShipAiAgent(pShipAgent):addSpaceFactionAlly(playerFactionHash)
		ShipAiAgent(pShipAgent):removeSpaceFactionEnemy(playerFactionHash)

		-- Add kill observer
		createObserver(SHIPDESTROYED, self.className, "notifyConvoyShipDestroyed", pShipAgent)

		-- Write the playersID that is escorting
		writeData(agentID .. ":" .. self.className .. ":escorterID:", playerID)

		-- Write the convoy ships progress along the lane
		writeData(agentID .. ":" .. self.className .. ":convoyShipProgress:", #convoyPoints)

		if (i == 1) then
			pConvoyLeader = pShipAgent
			ShipAiAgent(pShipAgent):createSquadron()

			-- Convoy leader checks in
			ShipAiAgent(pShipAgent):tauntPlayer(pPlayer, "@spacequest/" .. self.questType .. "/" .. self.questName .. ":arrival_greeting")
		else
			if (pConvoyLeader ~= nil) then
				ShipAiAgent(pShipAgent):assignToSquadron(pConvoyLeader)
			end

			-- The rest of the convoy checks in
			ShipAiAgent(pShipAgent):tauntPlayer(pPlayer, "@spacequest/" .. self.questType .. "/" .. self.questName .. ":ship_greeting")
		end

		-- Assign the convoy lane
		createEvent(5 * 1000, self.className, "assignConvoyPoints", pShipAgent, "")

		shipIDs[#shipIDs + 1] = agentID

		::continue::
	end

	-- The convoy could not be placed at all, do not soft lock the players datapad
	if (#shipIDs == 0) then
		Logger:log(self.className .. ":spawnConvoy -- No convoy ship agents could be spawned.", LT_ERROR)

		createEvent(1000, self.className, "completeQuest", pPlayer, "true")
		return
	end

	writeStringVectorSharedMemory(playerID .. ":" .. self.className .. ":convoyShips:", shipIDs)

	writeData(playerID .. ":" .. self.className .. ":convoyTotal:", #shipIDs)
	writeData(playerID .. ":" .. self.className .. ":convoyArrived:", 0)
	writeData(playerID .. ":" .. self.className .. ":convoyLost:", 0)

	if (self.DEBUG_SPACE_CONVOY) then
		print(self.className .. ":spawnConvoy -- Convoy Ships Spawned: " .. #shipIDs)
	end

	-- Player effect for player
	CreatureObject(pPlayer):playEffect("clienteffect/ui_quest_spawn_escort.cef", "")

	-- Player escort arrival music
	CreatureObject(pPlayer):playMusicMessage("sound/mus_quest_escort_arrival.snd")

	CreatureObject(pPlayer):sendSystemMessage("@spacequest/" .. self.questType .. "/" .. self.questName .. ":ready_to_go")
	CreatureObject(pPlayer):sendSystemMessage("@spacequest/" .. self.questType .. "/" .. self.questName .. ":get_moving")

	if (pConvoyLeader ~= nil) then
		ShipAiAgent(pConvoyLeader):tauntPlayer(pPlayer, "@spacequest/" .. self.questType .. "/" .. self.questName .. ":lets_move")

		if (self.checkPlayerDistance) then
			-- Player needs to stay within escortRange of the convoy leader
			createEvent(60 * 1000, self.className, "checkConvoy", pConvoyLeader, "")
		end

		-- Schedule attack wave
		if (self.spawnAttackWaves and #self.attackShips > 0) then
			createEvent(self.attackDelay * 1000, self.className, "spawnAttackWave", pConvoyLeader, "")
		end
	end
end

function SpaceConvoyScreenplay:assignConvoyPoints(pShipAgent)
	if (pShipAgent == nil) then
		return
	end

	local convoyPoints = self:getConvoyPoints()
	local lanePoints = {}

	-- The convoy runs the authored lane in order, it is a route and not a patrol
	for i = 1, #convoyPoints, 1 do
		table.insert(lanePoints, convoyPoints[i].patrolPointName)
	end

	if (self.DEBUG_SPACE_CONVOY) then
		print(self.className .. ":assignConvoyPoints -- Ship: " .. ShipObject(pShipAgent):getShipName() .. " Total Points to assign: " .. #lanePoints)
	end

	ShipAiAgent(pShipAgent):assignFixedPatrolPointsTable(lanePoints)
end

function SpaceConvoyScreenplay:checkConvoy(pShipAgent)
	if (pShipAgent == nil) then
		return
	end

	local shipAgentID = SceneObject(pShipAgent):getObjectID()
	local playerID = readData(shipAgentID .. ":" .. self.className .. ":escorterID:")

	local pPlayer = getSceneObject(playerID)

	if (pPlayer == nil or not SceneObject(pPlayer):isPlayerCreature() or not SpaceHelpers:isSpaceQuestTaskActive(pPlayer, self.questType, self.questName, 2)) then
		return
	end

	-- Make sure player is in the zone
	if (SceneObject(pShipAgent):getZoneName() ~= SceneObject(pPlayer):getZoneName()) then
		self:failQuest(pPlayer, "true")
		return
	end

	local distance = SceneObject(pShipAgent):getDistanceTo3d(pPlayer)
	local warningCount = readData(playerID .. ":" .. self.className .. ":distanceWarnings:")
	deleteData(playerID .. ":" .. self.className .. ":distanceWarnings:")

	if (self.DEBUG_SPACE_CONVOY) then
		print(self.className .. ":checkConvoy -- Convoy Leader: " .. ShipObject(pShipAgent):getShipName() .. " Current Distance: " .. distance .. " Warning Count: " .. warningCount)
	end

	-- Player is out of range
	if (distance > self.escortRange) then
		if (warningCount < 1) then
			warningCount = warningCount + 1

			ShipAiAgent(pShipAgent):tauntPlayer(pPlayer, "@space/quest:escort_too_far1")

			-- Update Warning count
			writeData(playerID .. ":" .. self.className .. ":distanceWarnings:", warningCount)
		elseif (warningCount < 2) then
			warningCount = warningCount + 1

			ShipAiAgent(pShipAgent):tauntPlayer(pPlayer, "@space/quest:escort_too_far2")

			-- Update Warning count
			writeData(playerID .. ":" .. self.className .. ":distanceWarnings:", warningCount)
		else
			ShipAiAgent(pShipAgent):tauntPlayer(pPlayer, "@space/quest:escort_too_far3")

			self:failQuest(pPlayer, "true")

			return
		end
	end

	createEvent(60 * 1000, self.className, "checkConvoy", pShipAgent, "")
end

function SpaceConvoyScreenplay:spawnAttackWave(pConvoyAgent)
	if (pConvoyAgent == nil or not self.spawnAttackWaves) then
		return
	end

	local playerID = readData(SceneObject(pConvoyAgent):getObjectID() .. ":" .. self.className .. ":escorterID:")
	local pPlayer = getSceneObject(playerID)

	-- This will fail to spawn the scheduled wave if the convoy run is over
	if (pPlayer == nil or not SpaceHelpers:isSpaceQuestActive(pPlayer, self.questType, self.questName)) then
		return
	end

	if (#self.attackShips == 0) then
		return
	end

	-- Send attack alert message
	CreatureObject(pPlayer):sendSystemMessage("@spacequest/" .. self.questType .. "/" .. self.questName .. ":attack_notify")

	-- Player effect for player
	CreatureObject(pPlayer):playEffect("clienteffect/ui_quest_spawn_wave.cef", "")

	local spawnLocation = ShipObject(pConvoyAgent):getSpawnPointInFrontOfShip(600, 1200)
	local spawnTable = self.attackShips[getRandomNumber(1, #self.attackShips)]

	if (type(spawnTable) ~= "table") then
		spawnTable = {spawnTable}
	end

	local shipIDs = readStringVectorSharedMemory(playerID .. self.className .. ":attackShips:")
	deleteStringVectorSharedMemory(playerID .. self.className .. ":attackShips:")

	local playerFactionHash = SpaceHelpers:getPlayerSpaceFactionHash(pPlayer)
	local pSquadronLeader = nil

	for i = 1, #spawnTable, 1 do
		local pShipAgent = spawnShipAgent(spawnTable[i], self.questZone, spawnLocation[1], spawnLocation[2], spawnLocation[3], pConvoyAgent)

		if (pShipAgent == nil) then
			goto continue
		end

		-- Set as a mission-specific ship locked to the mission holder
		ShipAiAgent(pShipAgent):setMissionOwner(pPlayer)

		-- Set as a wave attack ship
		ShipAiAgent(pShipAgent):setWaveAttack()

		-- Ships attacking the convoy are hyperspaced out, just in case make sure they are cleaned up
		ShipAiAgent(pShipAgent):setDespawnOnNoPlayerInRange(true)

		-- Add players faction as enemy
		ShipAiAgent(pShipAgent):addSpaceFactionEnemy(playerFactionHash)
		ShipAiAgent(pShipAgent):removeSpaceFactionAlly(playerFactionHash)

		-- Add kill observer
		createObserver(SHIPDESTROYED, self.className, "notifyAttackShipDestroyed", pShipAgent)

		local agentID = SceneObject(pShipAgent):getObjectID()

		-- Set as space mission object
		CreatureObject(pPlayer):addSpaceMissionObject(agentID, (i == #spawnTable))

		if (i == 1) then
			pSquadronLeader = pShipAgent
			ShipAiAgent(pShipAgent):createSquadron()

			-- Attacker taunt on arrival
			ShipAiAgent(pShipAgent):tauntPlayer(pPlayer, "@spacequest/" .. self.questType .. "/" .. self.questName .. ":taunt_" .. tostring(getRandomNumber(1, self.tauntData.tauntCount)))
		elseif (pSquadronLeader ~= nil) then
			ShipAiAgent(pShipAgent):assignToSquadron(pSquadronLeader)
		end

		-- Add to the list of shipIDs
		shipIDs[#shipIDs + 1] = agentID

		-- Write the playersID that is escorting
		writeData(agentID .. ":" .. self.className .. ":escorterID:", playerID)

		-- Add aggro and set the convoy ship as ShipAgents Defender
		ShipAiAgent(pShipAgent):engageShipTarget(pConvoyAgent)

		::continue::
	end

	-- Store the Spawned Attack Ships
	writeStringVectorSharedMemory(playerID .. self.className .. ":attackShips:", shipIDs)

	-- The convoy calls out that it is under fire
	ShipAiAgent(pConvoyAgent):tauntPlayer(pPlayer, "@spacequest/" .. self.questType .. "/" .. self.questName .. ":panic_" .. tostring(getRandomNumber(1, self.tauntData.panicCount)))

	-- Schedule next attack wave
	if (self.attackDelay > 0) then
		createEvent(self.attackDelay * 1000, self.className, "spawnAttackWave", pConvoyAgent, "")
	end
end

function SpaceConvoyScreenplay:removeConvoyShip(pShipAgent)
	if (pShipAgent == nil) then
		return
	end

	local shipAgentID = SceneObject(pShipAgent):getObjectID()
	local playerID = readData(shipAgentID .. ":" .. self.className .. ":escorterID:")

	deleteData(shipAgentID .. ":" .. self.className .. ":escorterID:")
	deleteData(shipAgentID .. ":" .. self.className .. ":convoyShipProgress:")

	local pPlayer = getSceneObject(playerID)

	if (pPlayer ~= nil) then
		-- Remove the agent as a mission object
		CreatureObject(pPlayer):removeSpaceMissionObject(shipAgentID, true)
	end

	-- Remove the kill observer
	dropObserver(SHIPDESTROYED, self.className, "notifyConvoyShipDestroyed", pShipAgent)

	-- Make ship fly away first
	ShipObject(pShipAgent):setHyperspacing(true);

	local hyperspaceLocation = ShipObject(pShipAgent):getSpawnPointInFrontOfShip(2500, 8000)

	SceneObject(pShipAgent):setPosition(hyperspaceLocation[1], hyperspaceLocation[2], hyperspaceLocation[3])

	createEvent(2000, "SpaceHelpers", "delayedDestroyShipAgent", pShipAgent, "")
end

function SpaceConvoyScreenplay:despawnShips(pPlayer)
	if (pPlayer == nil) then
		return
	end

	local playerID = SceneObject(pPlayer):getObjectID()

	local convoyIDs = readStringVectorSharedMemory(playerID .. ":" .. self.className .. ":convoyShips:")
	deleteStringVectorSharedMemory(playerID .. ":" .. self.className .. ":convoyShips:")

	for i = 1, #convoyIDs, 1 do
		local pConvoyShip = getSceneObject(tonumber(convoyIDs[i]))

		if (pConvoyShip ~= nil) then
			self:removeConvoyShip(pConvoyShip)
		end
	end

	local shipIDs = readStringVectorSharedMemory(playerID .. self.className .. ":attackShips:")
	deleteStringVectorSharedMemory(playerID .. self.className .. ":attackShips:")

	if (self.DEBUG_SPACE_CONVOY) then
		print(self.className .. ":despawnShips -- Convoy Ships: " .. #convoyIDs .. " Attack Ships: " .. #shipIDs)
	end

	for i = 1, #shipIDs, 1 do
		local attackAgentID = tonumber(shipIDs[i])

		-- Remove the attacking ship agent as a mission object
		CreatureObject(pPlayer):removeSpaceMissionObject(attackAgentID, (i == #shipIDs))

		local pAttackShip = getSceneObject(attackAgentID)

		if (pAttackShip == nil) then
			goto continue
		end

		-- Remove the kill observer
		dropObserver(SHIPDESTROYED, self.className, "notifyAttackShipDestroyed", pAttackShip)

		-- Make ship fly away first
		ShipObject(pAttackShip):setHyperspacing(true);

		local hyperspaceLocation = ShipObject(pAttackShip):getSpawnPointInFrontOfShip(2500, 8000)

		SceneObject(pAttackShip):setPosition(hyperspaceLocation[1], hyperspaceLocation[2], hyperspaceLocation[3])

		createEvent(2000, "SpaceHelpers", "delayedDestroyShipAgent", pAttackShip, "")

		::continue::
	end
end

-- Called once every convoy ship has either reached the destination or been destroyed
function SpaceConvoyScreenplay:finishConvoy(pPlayer)
	if (pPlayer == nil) then
		return
	end

	if (not SpaceHelpers:isSpaceQuestActive(pPlayer, self.questType, self.questName)) then
		return
	end

	local playerID = SceneObject(pPlayer):getObjectID()
	local arrived = readData(playerID .. ":" .. self.className .. ":convoyArrived:")

	if (self.DEBUG_SPACE_CONVOY) then
		print(self.className .. ":finishConvoy -- Convoy Ships Arrived: " .. arrived)
	end

	-- Every ship in the convoy was lost
	if (arrived <= 0) then
		CreatureObject(pPlayer):sendSystemMessage("@spacequest/" .. self.questType .. "/" .. self.questName .. ":convoy_destroyed")

		createEvent(1000, self.className, "failQuest", pPlayer, "true")
		return
	end

	CreatureObject(pPlayer):sendSystemMessage("@spacequest/" .. self.questType .. "/" .. self.questName .. ":convoy_arrived")

	-- Complete the quest final task 2
	SpaceHelpers:completeSpaceQuestTask(pPlayer, self.questType, self.questName, 2, false)

	local questUpdate = LuaStringIdChatParameter("@spacequest/" .. self.questType .. "/" .. self.questName .. ":quest_update")
	questUpdate:setTO("@spacequest/" .. self.questType .. "/" .. self.questName .. ":complete")

	CreatureObject(pPlayer):sendSystemMessage(questUpdate:_getObject())

	createEvent(1000, self.className, "completeQuest", pPlayer, "true")
end

--[[

		Space Convoy Observers

--]]

function SpaceConvoyScreenplay:enteredZone(pPlayer, nill, zoneNameHash)
	if (pPlayer == nil) then
		return 0
	end

	if (not SpaceHelpers:isSpaceQuestActive(pPlayer, self.questType, self.questName)) then
		return 1
	end

	local pGhost = CreatureObject(pPlayer):getPlayerObject()

	if (pGhost == nil) then
		return 0
	end

	local pRootParent = SceneObject(pPlayer):getRootParent()

	if (pRootParent ~= nil and SceneObject(pRootParent):getObjectName() == "player_sorosuub_space_yacht") then
		return 0
	end

	local playerID = SceneObject(pPlayer):getObjectID()
	local spaceQuestHash = getHashCode(self.questZone)

	if (self.DEBUG_SPACE_CONVOY) then
		print(self.className .. ":enteredZone called -- QuestType: " .. self.questType .. " Quest Name: " .. self.questName .. " Player Zone Hash: " .. zoneNameHash .. " questZone hash: " .. spaceQuestHash)
	end

	-- Player is in the correct zone
	if (zoneNameHash == spaceQuestHash and not SpaceHelpers:isSpaceQuestTaskComplete(pPlayer, self.questType, self.questName, 0)) then
		-- Complete the quest task 0
		SpaceHelpers:completeSpaceQuestTask(pPlayer, self.questType, self.questName, 0, false)

		-- Activate quest task 1
		SpaceHelpers:activateSpaceQuestTask(pPlayer, self.questType, self.questName, 1, true)

		-- Send the player to the rendezvous point
		createEvent(4000, self.className, "setupConvoy", pPlayer, "")

		return 0
	elseif (zoneNameHash ~= spaceQuestHash and SpaceHelpers:isSpaceQuestTaskComplete(pPlayer, self.questType, self.questName, 0)) then
		createEvent(2000, self.className, "failQuest", pPlayer, "true")

		return 1
	end

	return 0
end

function SpaceConvoyScreenplay:notifyEnteredQuestArea(pActiveArea, pShip)
	if ((pActiveArea == nil) or (pShip == nil)) then
		return 0
	end

	if (SceneObject(pShip):isPlayerShip()) then
		local pPilot = ShipObject(pShip):getPilot()

		if (pPilot == nil or not SceneObject(pPilot):isPlayerCreature()) then
			return 0
		end

		-- Player is not actively on this quest task
		if (not SpaceHelpers:isSpaceQuestTaskActive(pPilot, self.questType, self.questName, 1)) then
			return 0
		end

		local playerID = SceneObject(pPilot):getObjectID()
		local playerLocation = readData(playerID .. ":" .. self.className .. ":location:")

		-- Check if player is at the correct rendezvous point
		local assignedStart = readData(playerID .. self.className .. ":startPoint:")
		local activeAreaID = SceneObject(pActiveArea):getObjectID()
		local areaConvoyNumber = readData(activeAreaID .. ":" .. self.className)

		if (areaConvoyNumber ~= assignedStart) then
			return 0
		end

		-- Check to see if player needs to be updated
		if (playerLocation > 1) then
			return 0
		end

		if (self.DEBUG_SPACE_CONVOY) then
			print(self.className .. ":notifyEnteredQuestArea - Player Ship: " .. SceneObject(pShip):getDisplayedName())
		end

		-- Update player count
		writeData(playerID .. ":" .. self.className .. ":location:", 2)

		-- Complete the quest task 1
		SpaceHelpers:completeSpaceQuestTask(pPilot, self.questType, self.questName, 1, false)

		-- Activate quest task 2
		SpaceHelpers:activateSpaceQuestTask(pPilot, self.questType, self.questName, 2, false)

		-- Send player arrival message
		local questUpdate = LuaStringIdChatParameter("@spacequest/" .. self.questType .. "/" .. self.questName .. ":quest_update")
		questUpdate:setTO("@spacequest/" .. self.questType .. "/" .. self.questName .. ":arrived_at_loc")

		CreatureObject(pPilot):sendSystemMessage(questUpdate:_getObject())

		-- Schedule the convoy arriving
		createEvent(self.arrivalDelay * 1000, self.className, "spawnConvoy", pPilot, "")
	elseif (SceneObject(pShip):isShipAiAgent()) then
		local shipAgentID = SceneObject(pShip):getObjectID()
		local playerID = readData(shipAgentID .. ":" .. self.className .. ":escorterID:")

		-- The convoy will be inside one of the active areas before it can be assigned its owning player
		if (playerID == 0) then
			return 0
		end

		local shipProgress = readData(shipAgentID .. ":" .. self.className .. ":convoyShipProgress:")

		-- Attacking ships carry an escorterID but never a convoy progress count
		if (shipProgress == 0) then
			return 0
		end

		local pPlayer = getSceneObject(playerID)

		if (pPlayer == nil or not SceneObject(pPlayer):isPlayerCreature() or not SpaceHelpers:isSpaceQuestActive(pPlayer, self.questType, self.questName)) then
			createEvent(1000, self.className, "removeConvoyShip", pShip, "")
			return 0
		end

		shipProgress = shipProgress - 1

		if (self.DEBUG_SPACE_CONVOY) then
			print(self.className .. ":notifyEnteredQuestArea - Convoy Ship: " .. SceneObject(pShip):getDisplayedName() .. " Convoy Progress: " .. shipProgress)
		end

		-- This convoy ship has finished the lane
		if (shipProgress <= 0) then
			deleteData(shipAgentID .. ":" .. self.className .. ":convoyShipProgress:")

			CreatureObject(pPlayer):sendSystemMessage("@spacequest/" .. self.questType .. "/" .. self.questName .. ":convoy_safe")

			local arrived = readData(playerID .. ":" .. self.className .. ":convoyArrived:") + 1
			writeData(playerID .. ":" .. self.className .. ":convoyArrived:", arrived)

			local lost = readData(playerID .. ":" .. self.className .. ":convoyLost:")
			local total = readData(playerID .. ":" .. self.className .. ":convoyTotal:")

			-- Hyperspace out the ship that made it
			createEvent(500, self.className, "removeConvoyShip", pShip, "")

			if (arrived + lost >= total) then
				createEvent(1000, self.className, "finishConvoy", pPlayer, "")
			end

			return 0
		end

		-- Write the convoy ships progress
		writeData(shipAgentID .. ":" .. self.className .. ":convoyShipProgress:", shipProgress)

		return 0
	end

	return 0
end

function SpaceConvoyScreenplay:notifyConvoyShipDestroyed(pShipAgent, pKillerShip)
	if (pShipAgent == nil) then
		return 1
	end

	local missionOwnerID = ShipAiAgent(pShipAgent):getMissionOwnerID()
	local pPlayer = getSceneObject(missionOwnerID)

	if (pPlayer == nil or not SceneObject(pPlayer):isPlayerCreature()) then
		return 1
	end

	local agentID = SceneObject(pShipAgent):getObjectID()

	if (self.DEBUG_SPACE_CONVOY) then
		print(self.className .. ":notifyConvoyShipDestroyed - Ship Destoyed: " .. SceneObject(pShipAgent):getDisplayedName())
	end

	-- Remove agent as mission object
	CreatureObject(pPlayer):removeSpaceMissionObject(agentID, true)

	-- Clean Up Data
	deleteData(agentID .. ":" .. self.className .. ":convoyShipProgress:")
	deleteData(agentID .. ":" .. self.className .. ":escorterID:")

	-- Drop the ship from the convoy vector
	local convoyIDs = readStringVectorSharedMemory(missionOwnerID .. ":" .. self.className .. ":convoyShips:")
	local newIDs = {}

	for i = 1, #convoyIDs, 1 do
		if (tonumber(convoyIDs[i]) ~= agentID) then
			table.insert(newIDs, convoyIDs[i])
		end
	end

	deleteStringVectorSharedMemory(missionOwnerID .. ":" .. self.className .. ":convoyShips:")
	writeStringVectorSharedMemory(missionOwnerID .. ":" .. self.className .. ":convoyShips:", newIDs)

	if (not SpaceHelpers:isSpaceQuestActive(pPlayer, self.questType, self.questName)) then
		return 1
	end

	-- The ship going down
	ShipAiAgent(pShipAgent):tauntPlayer(pPlayer, "@spacequest/" .. self.questType .. "/" .. self.questName .. ":panic_destroyed_" .. tostring(getRandomNumber(1, self.tauntData.panicDestroyedCount)))

	local lost = readData(missionOwnerID .. ":" .. self.className .. ":convoyLost:") + 1
	writeData(missionOwnerID .. ":" .. self.className .. ":convoyLost:", lost)

	local arrived = readData(missionOwnerID .. ":" .. self.className .. ":convoyArrived:")
	local total = readData(missionOwnerID .. ":" .. self.className .. ":convoyTotal:")

	if (arrived + lost >= total) then
		createEvent(1000, self.className, "finishConvoy", pPlayer, "")

		return 1
	end

	CreatureObject(pPlayer):sendSystemMessage("@spacequest/" .. self.questType .. "/" .. self.questName .. ":convoy_ship_lost")

	return 1
end

function SpaceConvoyScreenplay:notifyAttackShipDestroyed(pShipAgent, pKillerShip)
	if (pShipAgent == nil) then
		return 1
	end

	local missionOwnerID = ShipAiAgent(pShipAgent):getMissionOwnerID()
	local pPlayer = getSceneObject(missionOwnerID)

	if (pPlayer == nil or not SceneObject(pPlayer):isPlayerCreature()) then
		return 1
	end

	local agentID = SceneObject(pShipAgent):getObjectID()

	-- Remove as Mission Objects
	CreatureObject(pPlayer):removeSpaceMissionObject(agentID, true)

	deleteData(agentID .. ":" .. self.className .. ":escorterID:")

	-- Remove from Attack Ships Vector
	local shipIDs = readStringVectorSharedMemory(missionOwnerID .. self.className .. ":attackShips:")
	local newIDs = {}

	deleteStringVectorSharedMemory(missionOwnerID .. self.className .. ":attackShips:")

	for i = 1, #shipIDs, 1 do
		local shipID = tonumber(shipIDs[i])

		if (agentID ~= shipID) then
			newIDs[#newIDs + 1] = shipID
		end
	end

	if (#newIDs > 0) then
		-- Store the Spawned Attack Ships
		writeStringVectorSharedMemory(missionOwnerID .. self.className .. ":attackShips:", newIDs)

		local messageString = LuaStringIdChatParameter("@space/quest:destroy_duty_targets_remaining")
		messageString:setDI(#newIDs)

		CreatureObject(pPlayer):sendSystemMessage(messageString:_getObject())
	else
		-- Send attack over message
		CreatureObject(pPlayer):sendSystemMessage("@spacequest/" .. self.questType .. "/" .. self.questName .. ":attack_stopped")

		CreatureObject(pPlayer):playEffect("clienteffect/ui_quest_destroyed_wave.cef", "")

		-- The convoy thanks the player
		local convoyIDs = readStringVectorSharedMemory(missionOwnerID .. ":" .. self.className .. ":convoyShips:")

		if (#convoyIDs > 0) then
			local pConvoyShip = getSceneObject(tonumber(convoyIDs[1]))

			if (pConvoyShip ~= nil and SceneObject(pConvoyShip):isShipAiAgent()) then
				ShipAiAgent(pConvoyShip):tauntPlayer(pPlayer, "@spacequest/" .. self.questType .. "/" .. self.questName .. ":thanks_" .. tostring(getRandomNumber(1, self.tauntData.thanksCount)))
			end
		end
	end

	-- Increase kill count
	local totalKills = readData(missionOwnerID .. ":" .. self.className .. ":" .. ":ConvoyKillCount:")
	deleteData(missionOwnerID .. ":" .. self.className .. ":" .. ":ConvoyKillCount:")

	totalKills = totalKills + 1

	writeData(missionOwnerID .. ":" .. self.className .. ":" .. ":ConvoyKillCount:", totalKills)

	return 1
end
