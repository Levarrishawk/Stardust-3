SpaceSurvivalScreenplay = SpaceQuestLogic:new {
	className = "SpaceSurvivalScreenplay",

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

	DEBUG_SPACE_SURVIVAL = false,

	-- Screenplay Specific Variables

	survivalPoint = "",
	survivalAreaRadius = 400,

	survivalTime = 600, -- In Seconds, 0 runs the quest on survivalWaves instead
	survivalWaves = 0, -- Number of waves that must be survived, 0 runs the quest on survivalTime
	survivalUpdateInterval = 0, -- In Seconds, 0 disables periodic remaining-time messages

	delayToFirstAttack = 5, -- In Seconds
	attackDelay = 100, -- In Seconds, time between waves
	waveDelay = 0, -- In Seconds, overrides attackDelay for the gap between waves when set

	attackShips = {},
}

registerScreenPlay("SpaceSurvivalScreenplay", false)

--[[

		Space Survival Quest Functions

--]]

function SpaceSurvivalScreenplay:start()
end

function SpaceSurvivalScreenplay:startQuest(pPlayer, pNpc)
	if (pPlayer == nil) then
		Logger:log("Quest: " .. self.questName .. " Type: " .. self.questType .. " -- Failed to startQuest due to pPlayer being nil.", LT_ERROR)
		return
	end

	if (self.DEBUG_SPACE_SURVIVAL) then
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

	end

	-- Create inital observer for player entering Zone and to handle failing quest
	if (not hasObserver(ZONESWITCHED, self.className, "enteredZone", pPlayer)) then
		createObserver(ZONESWITCHED, self.className, "enteredZone", pPlayer, 1)
	end

	-- Player accepted the quest inside the quest zone, send them to the defence point
	if (SpaceHelpers:isSpaceQuestTaskComplete(pPlayer, self.questType, self.questName, 0)) then
		createEvent(4000, self.className, "setupSurvival", pPlayer, "")
	end
end

function SpaceSurvivalScreenplay:completeQuest(pPlayer, notifyClient)
	if (pPlayer == nil) then
		Logger:log("Quest: " .. self.questName .. " Type: " .. self.questType .. " -- Failed to completeQuest due to pPlayer being nil.", LT_ERROR)
		return
	end

	if (self.DEBUG_SPACE_SURVIVAL) then
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

function SpaceSurvivalScreenplay:failQuest(pPlayer, notifyClient)
	if (pPlayer == nil) then
		Logger:log(self.questName .. " Type: " .. self.questType .. " -- Failed to failQuest due to pPlayer being nil.", LT_ERROR)
		return
	end

	if (not SpaceHelpers:isSpaceQuestActive(pPlayer, self.questType, self.questName) and (notifyClient ~= "false" or not SpaceHelpers:isSpaceQuestComplete(pPlayer, self.questType, self.questName))) then
		return
	end

	if (self.DEBUG_SPACE_SURVIVAL) then
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

function SpaceSurvivalScreenplay:resetQuest(pPlayer)
	if (pPlayer == nil) then
		Logger:log(self.questName .. " Type: " .. self.questType .. " -- Failed to failQuest due to pPlayer being nil.", LT_ERROR)
		return
	end

	if (self.DEBUG_SPACE_SURVIVAL) then
		print(self.className .. ":failQuest called -- QuestType: " .. self.questType .. " Quest Name: " .. self.questName)
	end

	-- Set Quest failed
	SpaceHelpers:failSpaceQuest(pPlayer, self.questType, self.questName, false)

	-- Remove any patrol points
	SpaceHelpers:clearQuestWaypoint(pPlayer, self.className)

	-- Remove the zone entry observer
	dropObserver(ZONESWITCHED, self.className, "enteredZone", pPlayer)

	self:cleanUpQuestData(SceneObject(pPlayer):getObjectID())
end

function SpaceSurvivalScreenplay:cleanUpQuestData(playerID)
	local pPlayer = getSceneObject(playerID)

	-- Despawn anything still flying for this player
	self:despawnShips(pPlayer)

	-- Delete the wave tracking
	deleteData(playerID .. ":" .. self.className .. ":waveCount:")
	deleteData(playerID .. ":" .. self.className .. ":survivalRunning:")
	deleteData(playerID .. ":" .. self.className .. ":survivalRunID:")

	-- Delete the defence point active area
	local areaID = readData(playerID .. ":" .. self.className .. ":survivalArea:")
	deleteData(playerID .. ":" .. self.className .. ":survivalArea:")

	local pActiveArea = getSceneObject(areaID)

	if (pActiveArea ~= nil) then
		dropObserver(ENTEREDAREA, self.className, "notifyEnteredQuestArea", pActiveArea)

		SceneObject(pActiveArea):destroyObjectFromWorld()
	end
end

--[[

		Space Survival Quest Mechanics

--]]

--[[
	survivalPoint is authored in the "<zone>:<point_name>" composite form. Named space patrol
	points live in ship_mobile/patrol_points and are loaded into the ship agent template Lua
	state, not this one, so a screenplay cannot turn that string into coordinates. A quest may
	instead author the point as a {x =, z =, y =} table, in which case the player is given an
	approach waypoint and the waves start when they arrive.
]]
function SpaceSurvivalScreenplay:getSurvivalLocation()
	local point = self.survivalPoint

	if (point == nil or type(point) ~= "table") then
		return nil
	end

	if (type(point.x) ~= "number" or type(point.z) ~= "number" or type(point.y) ~= "number") then
		return nil
	end

	return point
end

-- Returns the gap in seconds between waves
function SpaceSurvivalScreenplay:getWaveDelay()
	if (self.waveDelay > 0) then
		return self.waveDelay
	end

	return self.attackDelay
end

function SpaceSurvivalScreenplay:setupSurvival(pPlayer)
	if (pPlayer == nil) then
		Logger:log(self.className .. ":setupSurvival -- pPlayer is nil.", LT_ERROR)
		return
	end

	if (not SpaceHelpers:isSpaceQuestActive(pPlayer, self.questType, self.questName)) then
		return
	end

	local location = self:getSurvivalLocation()

	if (self.DEBUG_SPACE_SURVIVAL) then
		print(self.className .. ":setupSurvival -- Has Survival Location: " .. tostring(location ~= nil))
	end

	-- Quest Progress update
	SpaceHelpers:sendQuestProgess(pPlayer, "@spacequest/" .. self.questType .. "/" .. self.questName .. ":title")

	-- Without a readable location the player defends wherever they are
	if (location == nil) then
		createEvent(2000, self.className, "startSurvival", pPlayer, "")
		return
	end

	local playerID = SceneObject(pPlayer):getObjectID()
	local pGhost = CreatureObject(pPlayer):getPlayerObject()

	if (pGhost ~= nil) then
		SpaceHelpers:clearQuestWaypoint(pPlayer, self.className)

		local waypointID = PlayerObject(pGhost):addWaypoint(self.questZone, "@spacequest/" .. self.questType .. "/" .. self.questName .. ":title", "", location.x, location.z, location.y, WAYPOINT_SPACE, true, true, WAYPOINTQUESTTASK)

		local pWaypoint = getSceneObject(waypointID)

		if (pWaypoint ~= nil) then
			WaypointObject(pWaypoint):setQuestDetails("@spacequest/" .. self.questType .. "/" .. self.questName .. ":title_d")
		end

		-- Store the waypointID on the player
		setQuestStatus(playerID .. ":" .. self.className .. ":waypointID", waypointID)
	end

	local pActiveArea = spawnSpaceActiveArea(self.questZone, "object/space_active_area.iff", location.x, location.z, location.y, self.survivalAreaRadius)

	if (pActiveArea == nil) then
		Logger:log(self.className .. ":setupSurvival -- Failed to spawn the survival active area.", LT_ERROR)

		createEvent(2000, self.className, "startSurvival", pPlayer, "")
		return
	end

	writeData(playerID .. ":" .. self.className .. ":survivalArea:", SceneObject(pActiveArea):getObjectID())

	createObserver(ENTEREDAREA, self.className, "notifyEnteredQuestArea", pActiveArea)
end

function SpaceSurvivalScreenplay:startSurvival(pPlayer)
	if (pPlayer == nil) then
		Logger:log(self.className .. ":startSurvival -- pPlayer is nil.", LT_ERROR)
		return
	end

	if (not SpaceHelpers:isSpaceQuestActive(pPlayer, self.questType, self.questName)) then
		return
	end

	local playerID = SceneObject(pPlayer):getObjectID()

	-- Already holding the line, do not start a second run of waves
	if (readData(playerID .. ":" .. self.className .. ":survivalRunning:") == 1) then
		return
	end

	-- Update the quest journal to the defence task
	SpaceHelpers:completeSpaceQuestTask(pPlayer, self.questType, self.questName, 1, false)
	SpaceHelpers:activateSpaceQuestTask(pPlayer, self.questType, self.questName, 2, true)

	-- Nothing was authored to survive, do not soft lock the players datapad
	if (#self.attackShips == 0) then
		if (self.DEBUG_SPACE_SURVIVAL) then
			print(self.className .. ":startSurvival -- No attack ships authored, completing the quest.")
		end

		createEvent(1000, self.className, "completeQuest", pPlayer, "true")
		return
	end

	-- Neither a duration nor a wave count was authored, one wave is the whole quest
	local totalWaves = self.survivalWaves

	if (self.survivalTime <= 0 and totalWaves <= 0) then
		totalWaves = 1
	end

	writeData(playerID .. ":" .. self.className .. ":survivalRunning:", 1)
	writeData(playerID .. ":" .. self.className .. ":waveCount:", 0)

	local survivalRunID = getRandomNumber(1, 2147483646)
	writeData(playerID .. ":" .. self.className .. ":survivalRunID:", survivalRunID)

	if (self.DEBUG_SPACE_SURVIVAL) then
		print(self.className .. ":startSurvival -- Survival Time: " .. self.survivalTime .. " Total Waves: " .. totalWaves .. " Wave Delay: " .. self:getWaveDelay())
	end

	createEvent(self.delayToFirstAttack * 1000, self.className, "spawnAttackWave", pPlayer, "")

	-- Timed survival, holding out for the full duration completes the quest
	if (self.survivalTime > 0) then
		createEvent(self.survivalTime * 1000, self.className, "endSurvival", pPlayer, "")

		if (self.survivalUpdateInterval > 0) then
			CreatureObject(pPlayer):sendSystemMessage("Hold position: " .. self:getSurvivalTimeText(self.survivalTime) .. " remaining.")

			local remainingTime = self.survivalTime - self.survivalUpdateInterval

			if (remainingTime > 0) then
				createEvent(self.survivalUpdateInterval * 1000, self.className, "sendSurvivalUpdate", pPlayer, survivalRunID .. ":" .. remainingTime)
			end
		end
	end
end

function SpaceSurvivalScreenplay:getSurvivalTimeText(remainingTime)
	if (remainingTime >= 60 and remainingTime % 60 == 0) then
		local minutes = remainingTime / 60
		local unit = " minutes"

		if (minutes == 1) then
			unit = " minute"
		end

		return minutes .. unit
	end

	local unit = " seconds"

	if (remainingTime == 1) then
		unit = " second"
	end

	return remainingTime .. unit
end

function SpaceSurvivalScreenplay:sendSurvivalUpdate(pPlayer, eventData)
	if (pPlayer == nil or eventData == nil) then
		return
	end

	local runID, remainingTime = string.match(eventData, "^(%d+):(%d+)$")

	if (runID == nil or remainingTime == nil) then
		return
	end

	local playerID = SceneObject(pPlayer):getObjectID()

	if (not SpaceHelpers:isSpaceQuestActive(pPlayer, self.questType, self.questName)
			or readData(playerID .. ":" .. self.className .. ":survivalRunning:") ~= 1
			or readData(playerID .. ":" .. self.className .. ":survivalRunID:") ~= tonumber(runID)) then
		return
	end

	remainingTime = tonumber(remainingTime)
	CreatureObject(pPlayer):sendSystemMessage("Hold position: " .. self:getSurvivalTimeText(remainingTime) .. " remaining.")

	remainingTime = remainingTime - self.survivalUpdateInterval

	if (remainingTime > 0) then
		createEvent(self.survivalUpdateInterval * 1000, self.className, "sendSurvivalUpdate", pPlayer, runID .. ":" .. remainingTime)
	end
end

function SpaceSurvivalScreenplay:spawnAttackWave(pPlayer)
	if (pPlayer == nil) then
		return
	end

	if (not SpaceHelpers:isSpaceQuestActive(pPlayer, self.questType, self.questName)) then
		return
	end

	if (#self.attackShips == 0) then
		return
	end

	local playerID = SceneObject(pPlayer):getObjectID()

	if (readData(playerID .. ":" .. self.className .. ":survivalRunning:") ~= 1) then
		return
	end

	local pPlayerShip = SceneObject(pPlayer):getRootParent()

	if (pPlayerShip == nil or not SceneObject(pPlayerShip):isShipObject()) then
		Logger:log(self.className .. ":spawnAttackWave -- pPlayerShip is nil.", LT_ERROR)
		return
	end

	local waveCount = readData(playerID .. ":" .. self.className .. ":waveCount:") + 1
	writeData(playerID .. ":" .. self.className .. ":waveCount:", waveCount)

	-- Waves are taken in order and wrap once the authored groups run out
	local waveIndex = ((waveCount - 1) % #self.attackShips) + 1
	local waveShips = self.attackShips[waveIndex]

	if (type(waveShips) ~= "table") then
		waveShips = {waveShips}
	end

	local playerFactionHash = SpaceHelpers:getPlayerSpaceFactionHash(pPlayer)
	local spawnLocation = ShipObject(pPlayerShip):getSpawnPointInFrontOfShip(600, 1200)

	if (self.DEBUG_SPACE_SURVIVAL) then
		print(self.className .. ":spawnAttackWave -- Wave: " .. waveCount .. " Wave Size: " .. #waveShips)
	end

	local shipIDs = readStringVectorSharedMemory(playerID .. ":" .. self.className .. ":attackShips:")
	deleteStringVectorSharedMemory(playerID .. ":" .. self.className .. ":attackShips:")

	local pSquadronLeader = nil

	for i = 1, #waveShips, 1 do
		local pShipAgent = spawnShipAgent(waveShips[i], self.questZone, spawnLocation[1] + getRandomNumber(50, 150), spawnLocation[2], spawnLocation[3] + getRandomNumber(50, 150), pPlayerShip)

		if (pShipAgent == nil) then
			goto continue
		end

		-- Set as a mission-specific ship locked to the mission holder
		ShipAiAgent(pShipAgent):setMissionOwner(pPlayer)

		-- Wave attackers chase the player and clean themselves up when nobody is near
		ShipAiAgent(pShipAgent):setWaveAttack()
		ShipAiAgent(pShipAgent):setDespawnOnNoPlayerInRange(true)

		-- Add players faction as enemy
		ShipAiAgent(pShipAgent):addSpaceFactionEnemy(playerFactionHash)
		ShipAiAgent(pShipAgent):removeSpaceFactionAlly(playerFactionHash)

		createObserver(SHIPDESTROYED, self.className, "notifyAttackShipDestroyed", pShipAgent)

		local agentID = SceneObject(pShipAgent):getObjectID()

		-- Set as space mission object
		CreatureObject(pPlayer):addSpaceMissionObject(agentID, (i == #waveShips))

		if (i == 1) then
			pSquadronLeader = pShipAgent
			ShipAiAgent(pShipAgent):createSquadron()
		elseif (pSquadronLeader ~= nil) then
			ShipAiAgent(pShipAgent):assignToSquadron(pSquadronLeader)
		end

		shipIDs[#shipIDs + 1] = agentID

		-- Add aggro and set the players ship as the ShipAgents defender
		ShipAiAgent(pShipAgent):engageShipTarget(pPlayerShip)

		::continue::
	end

	writeStringVectorSharedMemory(playerID .. ":" .. self.className .. ":attackShips:", shipIDs)

	CreatureObject(pPlayer):playEffect("clienteffect/ui_quest_spawn_wave.cef", "")

	local totalWaves = self.survivalWaves

	if (self.survivalTime <= 0 and totalWaves <= 0) then
		totalWaves = 1
	end

	-- Wave counted survival, the run ends once the last wave has been cleared
	if (totalWaves > 0 and waveCount >= totalWaves) then
		return
	end

	createEvent(self:getWaveDelay() * 1000, self.className, "spawnAttackWave", pPlayer, "")
end

function SpaceSurvivalScreenplay:endSurvival(pPlayer)
	if (pPlayer == nil) then
		return
	end

	if (not SpaceHelpers:isSpaceQuestActive(pPlayer, self.questType, self.questName)) then
		return
	end

	local playerID = SceneObject(pPlayer):getObjectID()

	if (readData(playerID .. ":" .. self.className .. ":survivalRunning:") ~= 1) then
		return
	end

	if (self.DEBUG_SPACE_SURVIVAL) then
		print(self.className .. ":endSurvival -- Waves Survived: " .. readData(playerID .. ":" .. self.className .. ":waveCount:"))
	end

	writeData(playerID .. ":" .. self.className .. ":survivalRunning:", 0)

	-- Complete the defence task
	SpaceHelpers:completeSpaceQuestTask(pPlayer, self.questType, self.questName, 2, false)

	CreatureObject(pPlayer):playEffect("clienteffect/ui_quest_destroyed_all.cef", "")

	createEvent(1000, self.className, "completeQuest", pPlayer, "true")
end

function SpaceSurvivalScreenplay:despawnShips(pPlayer)
	if (pPlayer == nil) then
		return
	end

	local playerID = SceneObject(pPlayer):getObjectID()
	local shipIDs = readStringVectorSharedMemory(playerID .. ":" .. self.className .. ":attackShips:")

	deleteStringVectorSharedMemory(playerID .. ":" .. self.className .. ":attackShips:")

	if (self.DEBUG_SPACE_SURVIVAL) then
		print(self.className .. ":despawnShips -- Ship Count: " .. #shipIDs)
	end

	for i = 1, #shipIDs, 1 do
		local shipID = tonumber(shipIDs[i])

		-- Remove as Space Mission Object
		CreatureObject(pPlayer):removeSpaceMissionObject(shipID, (i == #shipIDs))

		local pShipAgent = getSceneObject(shipID)

		if (pShipAgent == nil) then
			goto continue
		end

		-- Remove the kill observer
		dropObserver(SHIPDESTROYED, self.className, "notifyAttackShipDestroyed", pShipAgent)

		-- Make ship fly away first
		ShipObject(pShipAgent):setHyperspacing(true);

		local hyperspaceLocation = ShipObject(pShipAgent):getSpawnPointInFrontOfShip(2500, 8000)

		SceneObject(pShipAgent):setPosition(hyperspaceLocation[1], hyperspaceLocation[2], hyperspaceLocation[3])

		createEvent(2000, "SpaceHelpers", "delayedDestroyShipAgent", pShipAgent, "")

		::continue::
	end
end

--[[

		Space Survival Observers

--]]

function SpaceSurvivalScreenplay:notifyEnteredQuestArea(pActiveArea, pShip)
	if ((pActiveArea == nil) or (pShip == nil)) then
		return 0
	end

	if (not SceneObject(pShip):isPlayerShip()) then
		return 0
	end

	local pPilot = ShipObject(pShip):getPilot()

	if (pPilot == nil or not SceneObject(pPilot):isPlayerCreature()) then
		return 0
	end

	if (not SpaceHelpers:isSpaceQuestActive(pPilot, self.questType, self.questName)) then
		return 0
	end

	local playerID = SceneObject(pPilot):getObjectID()
	local areaID = readData(playerID .. ":" .. self.className .. ":survivalArea:")

	-- Another players defence point, or the waves have already begun
	if (areaID ~= SceneObject(pActiveArea):getObjectID()) then
		return 0
	end

	if (self.DEBUG_SPACE_SURVIVAL) then
		print(self.className .. ":notifyEnteredQuestArea -- Player Ship: " .. SceneObject(pShip):getDisplayedName())
	end

	deleteData(playerID .. ":" .. self.className .. ":survivalArea:")

	SpaceHelpers:clearQuestWaypoint(pPilot, self.className)

	createEvent(1000, self.className, "startSurvival", pPilot, "")

	return 1
end

function SpaceSurvivalScreenplay:notifyAttackShipDestroyed(pShipAgent, pKillerShip)
	if (pShipAgent == nil or not SceneObject(pShipAgent):isShipAiAgent()) then
		return 1
	end

	local missionOwnerID = ShipAiAgent(pShipAgent):getMissionOwnerID()
	local pPlayer = getSceneObject(missionOwnerID)

	if (pPlayer == nil or not SceneObject(pPlayer):isPlayerCreature()) then
		return 1
	end

	local agentID = SceneObject(pShipAgent):getObjectID()

	-- Remove agent as mission object
	CreatureObject(pPlayer):removeSpaceMissionObject(agentID, true)

	local shipIDs = readStringVectorSharedMemory(missionOwnerID .. ":" .. self.className .. ":attackShips:")
	local newIDs = {}

	for i = 1, #shipIDs, 1 do
		if (tonumber(shipIDs[i]) ~= agentID) then
			table.insert(newIDs, shipIDs[i])
		end
	end

	deleteStringVectorSharedMemory(missionOwnerID .. ":" .. self.className .. ":attackShips:")

	if (#newIDs > 0) then
		writeStringVectorSharedMemory(missionOwnerID .. ":" .. self.className .. ":attackShips:", newIDs)

		return 1
	end

	CreatureObject(pPlayer):playEffect("clienteffect/ui_quest_destroyed_wave.cef", "")

	local totalWaves = self.survivalWaves

	if (self.survivalTime <= 0 and totalWaves <= 0) then
		totalWaves = 1
	end

	-- Wave counted survival, clearing the final wave ends the run
	if (totalWaves > 0 and readData(missionOwnerID .. ":" .. self.className .. ":waveCount:") >= totalWaves) then
		createEvent(1000, self.className, "endSurvival", pPlayer, "")
	end

	return 1
end

function SpaceSurvivalScreenplay:enteredZone(pPlayer, nill, zoneNameHash)
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

	if (self.DEBUG_SPACE_SURVIVAL) then
		print(self.className .. ":enteredZone called -- QuestType: " .. self.questType .. " Quest Name: " .. self.questName .. " Player Zone Hash: " .. zoneNameHash .. " questZone hash: " .. spaceQuestHash)
	end

	-- Player is in the correct zone. Always resume setup because a chained quest may
	-- retain its completed location task without having created its defence waypoint.
	if (zoneNameHash == spaceQuestHash) then
		if (not SpaceHelpers:isSpaceQuestTaskComplete(pPlayer, self.questType, self.questName, 0)) then
			-- Complete the quest task 0
			SpaceHelpers:completeSpaceQuestTask(pPlayer, self.questType, self.questName, 0, false)

			-- Activate quest task 1
			SpaceHelpers:activateSpaceQuestTask(pPlayer, self.questType, self.questName, 1, true)
		end

		-- Send the player to the defence point
		createEvent(4000, self.className, "setupSurvival", pPlayer, "")

		return 0
	elseif (zoneNameHash ~= spaceQuestHash and SpaceHelpers:isSpaceQuestTaskComplete(pPlayer, self.questType, self.questName, 0)) then
		createEvent(2000, self.className, "failQuest", pPlayer, "true")

		return 1
	end

	return 0
end
