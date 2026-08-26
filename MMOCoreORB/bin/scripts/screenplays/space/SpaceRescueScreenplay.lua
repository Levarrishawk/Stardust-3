SpaceRescueScreenplay = SpaceQuestLogic:new {
	className = "SpaceRescueScreenplay",

	questName = "",
	questType = "rescue",

	questZone = "",

	creditReward = 0,
	itemReward = {
		--{species = {}, item = ""},
	},

	sideQuest = false,
	sideQuestType = "",
	sideQuestName = "",

	DEBUG_SPACE_RESCUE = false,

	-- Rescue mission specific variables
	arrivalDelay = 5, -- In Seconds before spawning rescue target

	rescueShip = "", -- Ship template to spawn as rescue target
	rescueLocation = {x = 0, z = 0, y = 0}, -- Where to spawn the rescue target

	repairDelay = 30, -- In Seconds for repairs to complete after docking

	attackDelay = 10, -- In Seconds after docking before attackers spawn (during repairs)
	attackShips = {
		-- {{count = 2, shipName = "enemy_ship_tier3"}},
	},

	-- Escort points after repair - route to safety/hyperspace
	escortPoints = {
		--{patrolPointName = "", zoneName = "", x = 0, z = 0, y = 0, escortNumber = 1, radius = 250},
	},

	escortSpeed = 20,

	-- Attackers during escort phase (e.g., single named ship)
	escortAttackDelay = 10, -- In Seconds after escort starts before attackers spawn
	escortAttackShips = {
		-- {{count = 1, shipName = "aynat_vaporizer_tier3"}},
	},

	tauntData = {
		panicCount = 5,
		thanksCount = 5,
	},
}

registerScreenPlay("SpaceRescueScreenplay", false)

--[[

		Space Rescue Quest Functions

--]]

function SpaceRescueScreenplay:start()
	self:spawnActiveAreas()
end

function SpaceRescueScreenplay:spawnActiveAreas()
	for i = 1, #self.escortPoints, 1 do
		local escortPoint = self.escortPoints[i]

		if (isZoneEnabled(escortPoint.zoneName)) then
			local pQuestArea = spawnSpaceActiveArea(escortPoint.zoneName, "object/space_active_area.iff", escortPoint.x, escortPoint.z, escortPoint.y, escortPoint.radius)

			if (pQuestArea == nil) then
				Logger:log(self.className .. ":spawnActiveAreas -- Failed to spawn escort area " .. i .. ".", LT_ERROR)
				return
			end

			local questAreaID = SceneObject(pQuestArea):getObjectID()
			writeData(questAreaID .. ":" .. self.className .. ":escortNumber", escortPoint.escortNumber)
			createObserver(ENTEREDAREA, self.className, "notifyEnteredQuestArea", pQuestArea)
		end
	end
end

function SpaceRescueScreenplay:startQuest(pPlayer, pNpc)
	if (pPlayer == nil) then
		Logger:log("Quest: " .. self.questName .. " Type: " .. self.questType .. " -- Failed to startQuest due to pPlayer being nil.", LT_ERROR)
		return
	end

	if (self.DEBUG_SPACE_RESCUE) then
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

	-- Check if the player is in the proper zone already
	if (playerZoneHash == spaceQuestHash and not SpaceHelpers:isInYacht(pPlayer)) then
		-- Complete the quest task 0
		SpaceHelpers:completeSpaceQuestTask(pPlayer, self.questType, self.questName, 0, false)

		-- Activate quest task 1
		SpaceHelpers:activateSpaceQuestTask(pPlayer, self.questType, self.questName, 1, true)

		-- Setup the rescue mission
		createEvent(self.arrivalDelay * 1000, self.className, "setupRescue", pPlayer, "")
	end

	-- Create initial observer for player entering Zone
	if (not hasObserver(ZONESWITCHED, self.className, "enteredZone", pPlayer)) then
		createObserver(ZONESWITCHED, self.className, "enteredZone", pPlayer, 1)
	end
end

function SpaceRescueScreenplay:completeQuest(pPlayer, notifyClient)
	if (pPlayer == nil) then
		Logger:log("Quest: " .. self.questName .. " Type: " .. self.questType .. " -- Failed to completeQuest due to pPlayer being nil.", LT_ERROR)
		return
	end

	if (self.DEBUG_SPACE_RESCUE) then
		print(self.className .. ":completeQuest called -- QuestType: " .. self.questType .. " Quest Name: " .. self.questName)
	end

	local notifyBool = true

	if (notifyClient == "false") then
		notifyBool = false
	end

	local playerID = SceneObject(pPlayer):getObjectID()

	-- Remove waypoint
	SpaceHelpers:clearQuestWaypoint(pPlayer, self.className)
	self:clearKnownQuestWaypoints(pPlayer)

	-- Send completion message
	SpaceHelpers:sendQuestUpdate(pPlayer, "@spacequest/" .. self.questType .. "/" .. self.questName .. ":complete")

	-- Complete the Journal Quest
	SpaceHelpers:completeSpaceQuest(pPlayer, self.questType, self.questName, notifyBool)

	-- Remove the zone entry observer
	dropObserver(ZONESWITCHED, self.className, "enteredZone", pPlayer)

	-- Remove dock observer
	dropObserver(SHIPDOCKED, self.className, "dockedShip", pPlayer)

	self:cleanUpQuestData(playerID)

	if (self.sideQuest and (self.sideQuestSplitType == self.SIDE_QUEST_SPLIT_TYPES.COMPLETION or self.sideQuestSplitType == self.SIDE_QUEST_SPLIT_TYPES.BIDIRECTIONAL)) then
		local alertMessage = "@spacequest/" .. self.questType .. "/" .. self.questName .. ":split_quest_alert"

		-- Split Quest Alert
		createEvent(self.sideQuestDelay * 1000, "SpaceHelpers", "sendQuestAlert", pPlayer, alertMessage)

		-- Trigger Sidequest
		createEvent(self.sideQuestDelay * 1050, self.sideQuestType .. "_" .. self.sideQuestName, "startQuest", pPlayer, "")
	end
end

function SpaceRescueScreenplay:failQuest(pPlayer, notifyClient)
	if (pPlayer == nil) then
		Logger:log(self.questName .. " Type: " .. self.questType .. " -- Failed to failQuest due to pPlayer being nil.", LT_ERROR)
		return
	end

	if (not SpaceHelpers:isSpaceQuestActive(pPlayer, self.questType, self.questName) and (notifyClient ~= "false" or not SpaceHelpers:isSpaceQuestComplete(pPlayer, self.questType, self.questName))) then
		return
	end

	if (self.DEBUG_SPACE_RESCUE) then
		print(self.className .. ":failQuest called -- QuestType: " .. self.questType .. " Quest Name: " .. self.questName)
	end

	local notifyBool = true

	if (notifyClient == "false") then
		notifyBool = false
	end

	local playerID = SceneObject(pPlayer):getObjectID()

	-- Send failure message
	SpaceHelpers:sendQuestUpdate(pPlayer, "@spacequest/" .. self.questType .. "/" .. self.questName .. ":failed_destroy")

	-- Set Quest failed
	SpaceHelpers:failSpaceQuest(pPlayer, self.questType, self.questName, notifyBool)

	-- Remove any patrol points
	SpaceHelpers:clearQuestWaypoint(pPlayer, self.className)
	self:clearKnownQuestWaypoints(pPlayer)

	-- Remove the zone entry observer
	dropObserver(ZONESWITCHED, self.className, "enteredZone", pPlayer)

	-- Remove dock observer
	dropObserver(SHIPDOCKED, self.className, "dockedShip", pPlayer)

	self:cleanUpQuestData(playerID)

	-- Fail the parent quest
	if (self.parentQuestType ~= nil and self.parentQuestType ~= "") then
		createEvent(200, self.parentQuestType .. "_" .. self.parentQuestName, "failQuest", pPlayer, "false")
	end

	-- Fail the side quest
	if (self.sideQuest and SpaceHelpers:isSpaceQuestActive(pPlayer, self.sideQuestType, self.sideQuestName)) then
		createEvent(200, self.sideQuestType .. "_" .. self.sideQuestName, "failQuest", pPlayer, "false")
	end

	if (self.sideQuest and (self.sideQuestSplitType == self.SIDE_QUEST_SPLIT_TYPES.FAILURE or self.sideQuestSplitType == self.SIDE_QUEST_SPLIT_TYPES.BIDIRECTIONAL)) then
		local alertMessage = "@spacequest/" .. self.questType .. "/" .. self.questName .. ":split_quest_alert_fail"

		-- Split Quest Alert
		createEvent(self.sideQuestDelay * 1000, "SpaceHelpers", "sendQuestAlert", pPlayer, alertMessage)

		-- Trigger Sidequest
		createEvent(self.sideQuestDelay * 1050, self.sideFailQuestType .. "_" .. self.sideFailQuestName, "startQuest", pPlayer, "")
	end
end

function SpaceRescueScreenplay:resetQuest(pPlayer)
	if (pPlayer == nil) then
		Logger:log(self.questName .. " Type: " .. self.questType .. " -- Failed to resetQuest due to pPlayer being nil.", LT_ERROR)
		return
	end

	if (self.DEBUG_SPACE_RESCUE) then
		print(self.className .. ":resetQuest called -- QuestType: " .. self.questType .. " Quest Name: " .. self.questName)
	end

	-- Set Quest failed
	SpaceHelpers:failSpaceQuest(pPlayer, self.questType, self.questName, false)

	-- Remove any patrol points
	SpaceHelpers:clearQuestWaypoint(pPlayer, self.className)
	self:clearKnownQuestWaypoints(pPlayer)

	-- Remove the zone entry observer
	dropObserver(ZONESWITCHED, self.className, "enteredZone", pPlayer)

	-- Remove dock observer
	dropObserver(SHIPDOCKED, self.className, "dockedShip", pPlayer)

	self:cleanUpQuestData(SceneObject(pPlayer):getObjectID())
end

function SpaceRescueScreenplay:cleanUpQuestData(playerID)
	local rescueShipID = readData(playerID .. ":" .. self.className .. ":rescueShipID")
	local pRescueShip = getSceneObject(rescueShipID)
	local pPlayer = getSceneObject(playerID)

	if (pPlayer ~= nil and pRescueShip ~= nil) then
		CreatureObject(pPlayer):removeSpaceMissionObject(rescueShipID, true)
	end

	if (pRescueShip ~= nil) then
		dropObserver(SHIPDESTROYED, self.className, "handleTargetDestroyed", pRescueShip)
		dropObserver(ENTEREDAREA, self.className, "notifyEnteredQuestArea", pRescueShip)
		SceneObject(pRescueShip):destroyObjectFromWorld()
	end

	-- Clean up stored data
	deleteData(playerID .. ":" .. self.className .. ":waypointID")
	deleteData(playerID .. ":" .. self.className .. ":rescueShipID")
	deleteData(playerID .. ":" .. self.className .. ":escortPointIndex")
	deleteData(playerID .. ":" .. self.className .. ":repairsComplete")
end

-- Remove persistent rescue waypoints even when their transient tracking key was
-- lost during a restart or an interrupted quest event.
function SpaceRescueScreenplay:clearKnownQuestWaypoints(pPlayer)
	if (pPlayer == nil) then
		return
	end

	local pGhost = CreatureObject(pPlayer):getPlayerObject()

	if (pGhost == nil) then
		return
	end

	local locations = {self.rescueLocation}

	for i = 1, #self.escortPoints, 1 do
		locations[#locations + 1] = self.escortPoints[i]
	end

	for i = 1, #locations, 1 do
		local location = locations[i]
		local pWaypoint = PlayerObject(pGhost):getWaypointAt(location.x, location.y, self.questZone)

		if (pWaypoint ~= nil) then
			PlayerObject(pGhost):removeWaypoint(SceneObject(pWaypoint):getObjectID(), true)
		end
	end
end

--[[

		Space Rescue Observers

--]]

function SpaceRescueScreenplay:enteredZone(pPlayer, nill, zoneNameHash)
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

	-- Skip if in yacht
	if (SpaceHelpers:isInYacht(pPlayer)) then
		return 0
	end

	local playerID = SceneObject(pPlayer):getObjectID()
	local spaceQuestHash = getHashCode(self.questZone)

	if (zoneNameHash == spaceQuestHash) then
		-- Player entered the quest zone
		-- Complete the quest task 0
		SpaceHelpers:completeSpaceQuestTask(pPlayer, self.questType, self.questName, 0, false)

		-- Activate quest task 1
		SpaceHelpers:activateSpaceQuestTask(pPlayer, self.questType, self.questName, 1, true)

		-- Setup the rescue mission
		createEvent(self.arrivalDelay * 1000, self.className, "setupRescue", pPlayer, "")

		return 0
	elseif (SpaceHelpers:isSpaceQuestTaskComplete(pPlayer, self.questType, self.questName, 0)) then
		-- Player left quest zone after starting - fail mission
		createEvent(2000, self.className, "failQuest", pPlayer, "true")
		return 1
	end

	return 0
end

--[[

		Space Rescue Setup Functions

--]]

function SpaceRescueScreenplay:setupRescue(pPlayer)
	if (pPlayer == nil) then
		return
	end

	if (not SpaceHelpers:isSpaceQuestActive(pPlayer, self.questType, self.questName)) then
		return
	end

	local pGhost = CreatureObject(pPlayer):getPlayerObject()

	if (pGhost == nil) then
		self:failQuest(pPlayer, "true")
		return
	end

	if (self.DEBUG_SPACE_RESCUE) then
		print(self.className .. ":setupRescue called -- QuestType: " .. self.questType .. " Quest Name: " .. self.questName)
	end

	local playerID = SceneObject(pPlayer):getObjectID()
	local rescueLocation = self.rescueLocation

	-- Send arrival message
	SpaceHelpers:sendQuestUpdate(pPlayer, "@spacequest/" .. self.questType .. "/" .. self.questName .. ":arrival_phase_1")

	-- Create waypoint to rescue location
	local waypointID = PlayerObject(pGhost):addWaypoint(self.questZone, "@spacequest/" .. self.questType .. "/" .. self.questName .. ":quest_location_t", "", rescueLocation.x, rescueLocation.z, rescueLocation.y, WAYPOINT_SPACE, true, true, WAYPOINTQUESTTASK)

	-- Store the waypointID
	setQuestStatus(playerID .. ":" .. self.className .. ":waypointID", waypointID)

	-- Spawn the rescue target ship
	self:spawnRescueShip(pPlayer)
end

function SpaceRescueScreenplay:spawnRescueShip(pPlayer)
	if (pPlayer == nil) then
		return
	end

	if (self.DEBUG_SPACE_RESCUE) then
		print(self.className .. ":spawnRescueShip called -- Ship: " .. self.rescueShip)
	end

	local playerID = SceneObject(pPlayer):getObjectID()
	local rescueLocation = self.rescueLocation

	-- Spawn the rescue ship at the location
	local pRescueShip = spawnShipAgent(self.rescueShip, self.questZone, rescueLocation.x, rescueLocation.z, rescueLocation.y)

	if (pRescueShip == nil) then
		Logger:log(self.className .. ":spawnRescueShip -- Failed to spawn rescue ship: " .. self.rescueShip, LT_ERROR)
		self:failQuest(pPlayer, "true")
		return
	end

	-- Set up the ship
	ShipAiAgent(pRescueShip):setMissionOwner(pPlayer)

	-- Make ship stationary (damaged, not moving)
	ShipAiAgent(pRescueShip):setFixedPatrol()

	local rescueShipID = SceneObject(pRescueShip):getObjectID()

	-- Store the rescue ship ID
	writeData(playerID .. ":" .. self.className .. ":rescueShipID", rescueShipID)

	-- Add as mission object
	CreatureObject(pPlayer):addSpaceMissionObject(rescueShipID, true)

	-- Create observer for ship destruction
	createObserver(SHIPDESTROYED, self.className, "handleTargetDestroyed", pRescueShip)

	-- Create observer for player docking
	if (not hasObserver(SHIPDOCKED, self.className, "dockedShip", pPlayer)) then
		createObserver(SHIPDOCKED, self.className, "dockedShip", pPlayer)
	end

	-- Send message that ship is waiting
	createEvent(2000, "SpaceHelpers", "sendQuestUpdate", pPlayer, "@spacequest/" .. self.questType .. "/" .. self.questName .. ":arrival_phase_2")

	-- Activate dock task
	SpaceHelpers:activateSpaceQuestTask(pPlayer, self.questType, self.questName, 2, true)
end

--[[

		Space Rescue Docking and Repair Functions

--]]

function SpaceRescueScreenplay:dockedShip(pPlayer, pTargetShip, cargoHash)
	if (pPlayer == nil or pTargetShip == nil) then
		return 1
	end

	if (not SpaceHelpers:isSpaceQuestActive(pPlayer, self.questType, self.questName)) then
		return 0
	end

	local playerID = SceneObject(pPlayer):getObjectID()
	local rescueShipID = readData(playerID .. ":" .. self.className .. ":rescueShipID")
	local targetShipID = SceneObject(pTargetShip):getObjectID()

	-- Verify this is the rescue ship
	if (rescueShipID ~= targetShipID) then
		return 0
	end

	if (self.DEBUG_SPACE_RESCUE) then
		print(self.className .. ":dockedShip called -- Player docked with rescue target")
	end

	-- Send docking started message
	SpaceHelpers:sendQuestUpdate(pPlayer, "@spacequest/" .. self.questType .. "/" .. self.questName .. ":docking_started")

	-- Play docking music
	CreatureObject(pPlayer):playMusicMessage("sound/mus_quest_theme_docking.snd")

	-- Complete dock task
	SpaceHelpers:completeSpaceQuestTask(pPlayer, self.questType, self.questName, 2, false)

	-- Activate repair task
	SpaceHelpers:activateSpaceQuestTask(pPlayer, self.questType, self.questName, 3, true)

	-- Schedule attackers to spawn
	if (#self.attackShips > 0) then
		createEvent(self.attackDelay * 1000, self.className, "spawnAttackers", pPlayer, "")
	end

	-- Schedule repairs to complete
	createEvent(self.repairDelay * 1000, self.className, "repairsComplete", pPlayer, "")

	-- Send docking complete message after short delay
	createEvent(3000, "SpaceHelpers", "sendQuestUpdate", pPlayer, "@spacequest/" .. self.questType .. "/" .. self.questName .. ":docking_complete")

	-- Remove dock observer - only dock once
	dropObserver(SHIPDOCKED, self.className, "dockedShip", pPlayer)

	return 1
end

function SpaceRescueScreenplay:spawnAttackers(pPlayer)
	if (pPlayer == nil) then
		return
	end

	if (not SpaceHelpers:isSpaceQuestActive(pPlayer, self.questType, self.questName)) then
		return
	end

	if (self.DEBUG_SPACE_RESCUE) then
		print(self.className .. ":spawnAttackers called")
	end

	local playerID = SceneObject(pPlayer):getObjectID()
	local rescueShipID = readData(playerID .. ":" .. self.className .. ":rescueShipID")
	local pRescueShip = getSceneObject(rescueShipID)

	if (pRescueShip == nil) then
		return
	end

	-- Send attack notification
	SpaceHelpers:sendQuestUpdate(pPlayer, "@spacequest/" .. self.questType .. "/" .. self.questName .. ":attack_notify")

	local pPilotShip = SceneObject(pPlayer):getRootParent()

	if (pPilotShip == nil or not SceneObject(pPilotShip):isShipObject()) then
		return
	end

	-- The attack event may fire after repairs are complete and the escort has
	-- already left its original rescue location. Spawn around the rescue ship's
	-- current position so the announced wave reaches the active encounter.
	local rescueX = SceneObject(pRescueShip):getPositionX()
	local rescueZ = SceneObject(pRescueShip):getPositionZ()
	local rescueY = SceneObject(pRescueShip):getPositionY()
	local attackShips = self.attackShips

	for i = 1, #attackShips, 1 do
		local waveShips = attackShips[i]

		for j = 1, #waveShips, 1 do
			local shipData = waveShips[j]
			local count = 1
			local shipName = shipData

			if (type(shipData) == "table") then
				count = shipData.count or 1
				shipName = shipData.shipName
			end

			if (type(shipName) ~= "string" or shipName == "") then
				Logger:log(self.className .. ":spawnAttackers -- Invalid attacker ship entry in wave " .. i .. ".", LT_ERROR)
				goto continueAttackShip
			end

			for k = 1, count, 1 do
				local pAttacker = spawnShipAgent(shipName, self.questZone, rescueX + getRandomNumber(200, 400), rescueZ + getRandomNumber(-100, 100), rescueY + getRandomNumber(200, 400))

				if (pAttacker ~= nil) then
					ShipAiAgent(pAttacker):setMissionOwner(pPlayer)
					ShipAiAgent(pAttacker):setMinimumGuardPatrol(100)
					ShipAiAgent(pAttacker):setMaximumGuardPatrol(500)
					ShipAiAgent(pAttacker):setGuardPatrol()

					-- Attack the rescue ship
					ShipAiAgent(pAttacker):setDefender(pRescueShip)
					ShipAiAgent(pAttacker):engageShipTarget(pRescueShip)

					local attackerID = SceneObject(pAttacker):getObjectID()
					CreatureObject(pPlayer):addSpaceMissionObject(attackerID, false)
				end
			end

			::continueAttackShip::
		end
	end
end

function SpaceRescueScreenplay:repairsComplete(pPlayer)
	if (pPlayer == nil) then
		return
	end

	if (not SpaceHelpers:isSpaceQuestActive(pPlayer, self.questType, self.questName)) then
		return
	end

	if (self.DEBUG_SPACE_RESCUE) then
		print(self.className .. ":repairsComplete called")
	end

	local playerID = SceneObject(pPlayer):getObjectID()

	-- Mark repairs as complete
	writeData(playerID .. ":" .. self.className .. ":repairsComplete", 1)

	-- Send repairs complete message
	SpaceHelpers:sendQuestUpdate(pPlayer, "@spacequest/" .. self.questType .. "/" .. self.questName .. ":rescue_phase_2")

	-- Complete repair task
	SpaceHelpers:completeSpaceQuestTask(pPlayer, self.questType, self.questName, 3, false)

	-- Activate escort task
	SpaceHelpers:activateSpaceQuestTask(pPlayer, self.questType, self.questName, 4, true)

	-- Start escort phase
	self:assignEscortPoints(pPlayer)
end

--[[

		Space Rescue Escort Functions

--]]

function SpaceRescueScreenplay:assignEscortPoints(pPlayer)
	if (pPlayer == nil) then
		return
	end

	if (self.DEBUG_SPACE_RESCUE) then
		print(self.className .. ":assignEscortPoints called")
	end

	local playerID = SceneObject(pPlayer):getObjectID()
	local rescueShipID = readData(playerID .. ":" .. self.className .. ":rescueShipID")
	local pRescueShip = getSceneObject(rescueShipID)

	if (pRescueShip == nil) then
		self:failQuest(pPlayer, "true")
		return
	end

	local pGhost = CreatureObject(pPlayer):getPlayerObject()

	if (pGhost == nil) then
		return
	end

	local escortPoints = self.escortPoints

	if (#escortPoints == 0) then
		-- No escort points, complete mission immediately
		self:completeQuest(pPlayer, "true")
		return
	end

	-- Build patrol points table for the ship.
	-- assignFixedPatrolPointsTable takes exactly ONE argument and it must be a table of
	-- point-name STRINGS -- it resolves each name against the ship's zone
	-- (LuaShipAiAgent.cpp:240-293). Passing a table of tables plus a second argument made
	-- the binding bail on the arg-count check, so the rescue ship never received a route.
	-- Escort speed is applied through its own binding, as SpaceRecoveryScreenplay:651-656 does.
	local pointsTable = {}

	for i = 1, #escortPoints, 1 do
		table.insert(pointsTable, escortPoints[i].patrolPointName)
	end

	-- Set escort point index
	writeData(playerID .. ":" .. self.className .. ":escortPointIndex", 1)

	-- Switch ship to patrol mode and assign points
	ShipAiAgent(pRescueShip):setFixedPatrol()
	ShipAiAgent(pRescueShip):assignFixedPatrolPointsTable(pointsTable)
	ShipAiAgent(pRescueShip):setEscortSpeed(self.escortSpeed)

	-- Clear old waypoint and create escort waypoint
	SpaceHelpers:clearQuestWaypoint(pPlayer, self.className)

	local firstPoint = escortPoints[1]
	local waypointID = PlayerObject(pGhost):addWaypoint(self.questZone, "@spacequest/" .. self.questType .. "/" .. self.questName .. ":quest_escort_t", "", firstPoint.x, firstPoint.z, firstPoint.y, WAYPOINT_SPACE, true, true, WAYPOINTQUESTTASK)

	setQuestStatus(playerID .. ":" .. self.className .. ":waypointID", waypointID)

	-- Schedule escort attackers if configured
	if (self.escortAttackShips ~= nil and #self.escortAttackShips > 0) then
		createEvent(self.escortAttackDelay * 1000, self.className, "spawnEscortAttackers", pPlayer, "")
	end
end

function SpaceRescueScreenplay:spawnEscortAttackers(pPlayer)
	if (pPlayer == nil) then
		return
	end

	if (not SpaceHelpers:isSpaceQuestActive(pPlayer, self.questType, self.questName)) then
		return
	end

	if (self.DEBUG_SPACE_RESCUE) then
		print(self.className .. ":spawnEscortAttackers called")
	end

	local playerID = SceneObject(pPlayer):getObjectID()
	local rescueShipID = readData(playerID .. ":" .. self.className .. ":rescueShipID")
	local pRescueShip = getSceneObject(rescueShipID)

	if (pRescueShip == nil) then
		return
	end

	-- Send attack notification
	SpaceHelpers:sendQuestUpdate(pPlayer, "@spacequest/" .. self.questType .. "/" .. self.questName .. ":attack_notify")

	local pPilotShip = SceneObject(pPlayer):getRootParent()

	if (pPilotShip == nil or not SceneObject(pPilotShip):isShipObject()) then
		return
	end

	-- Get current position of rescue ship for spawning attackers nearby
	local shipX = SceneObject(pRescueShip):getPositionX()
	local shipZ = SceneObject(pRescueShip):getPositionZ()
	local shipY = SceneObject(pRescueShip):getPositionY()

	local escortAttackShips = self.escortAttackShips

	for i = 1, #escortAttackShips, 1 do
		local waveShips = escortAttackShips[i]

		for j = 1, #waveShips, 1 do
			local shipData = waveShips[j]
			local count = 1
			local shipName = shipData

			if (type(shipData) == "table") then
				count = shipData.count or 1
				shipName = shipData.shipName
			end

			if (type(shipName) ~= "string" or shipName == "") then
				Logger:log(self.className .. ":spawnEscortAttackers -- Invalid attacker ship entry in wave " .. i .. ".", LT_ERROR)
				goto continueEscortAttackShip
			end

			for k = 1, count, 1 do
				local pAttacker = spawnShipAgent(shipName, self.questZone, shipX + getRandomNumber(200, 400), shipZ + getRandomNumber(-100, 100), shipY + getRandomNumber(200, 400))

				if (pAttacker ~= nil) then
					ShipAiAgent(pAttacker):setMissionOwner(pPlayer)
					ShipAiAgent(pAttacker):setMinimumGuardPatrol(100)
					ShipAiAgent(pAttacker):setMaximumGuardPatrol(500)
					ShipAiAgent(pAttacker):setGuardPatrol()

					-- Attack the rescue ship
					ShipAiAgent(pAttacker):setDefender(pRescueShip)
					ShipAiAgent(pAttacker):engageShipTarget(pRescueShip)

					local attackerID = SceneObject(pAttacker):getObjectID()
					CreatureObject(pPlayer):addSpaceMissionObject(attackerID, false)
				end
			end

			::continueEscortAttackShip::
		end
	end
end

function SpaceRescueScreenplay:notifyEnteredQuestArea(pActiveArea, pRescueShip)
	if (pActiveArea == nil or pRescueShip == nil or not SceneObject(pRescueShip):isShipAiAgent()) then
		return 0
	end

	local missionOwnerID = ShipAiAgent(pRescueShip):getMissionOwnerID()
	local pOwner = getSceneObject(missionOwnerID)

	if (pOwner == nil or not SceneObject(pOwner):isPlayerCreature()) then
		return 0
	end

	local playerID = SceneObject(pOwner):getObjectID()
	local rescueShipID = readData(playerID .. ":" .. self.className .. ":rescueShipID")

	-- Only this player's rescue target may advance the route.
	if (rescueShipID ~= SceneObject(pRescueShip):getObjectID()) then
		return 0
	end

	if (not SpaceHelpers:isSpaceQuestActive(pOwner, self.questType, self.questName)) then
		return 0
	end

	local questAreaID = SceneObject(pActiveArea):getObjectID()
	local pointNum = readData(questAreaID .. ":" .. self.className .. ":escortNumber")
	local currentIndex = readData(playerID .. ":" .. self.className .. ":escortPointIndex")

	-- Ignore a later area if a patrol path happens to cross it out of order.
	if (pointNum ~= currentIndex) then
		return 0
	end

	if (self.DEBUG_SPACE_RESCUE) then
		print(self.className .. ":notifyEnteredQuestArea called -- Point: " .. pointNum)
	end

	local pGhost = CreatureObject(pOwner):getPlayerObject()

	if (pGhost == nil) then
		return 0
	end

	local escortPoints = self.escortPoints

	-- Check if this is the final point
	if (currentIndex >= #escortPoints) then
		-- Mission complete!
		self:completeQuest(pOwner, "true")
		return 0
	end

	-- Move to next point
	local nextIndex = currentIndex + 1
	writeData(playerID .. ":" .. self.className .. ":escortPointIndex", nextIndex)

	-- Update waypoint to next point
	local nextPoint = escortPoints[nextIndex]

	SpaceHelpers:clearQuestWaypoint(pOwner, self.className)

	local waypointID = PlayerObject(pGhost):addWaypoint(self.questZone, "@spacequest/" .. self.questType .. "/" .. self.questName .. ":quest_escort_t", "", nextPoint.x, nextPoint.z, nextPoint.y, WAYPOINT_SPACE, true, true, WAYPOINTQUESTTASK)

	setQuestStatus(playerID .. ":" .. self.className .. ":waypointID", waypointID)

	return 0
end

function SpaceRescueScreenplay:handleTargetDestroyed(pRescueShip, pKiller)
	if (pRescueShip == nil) then
		return 1
	end

	local missionOwnerID = ShipAiAgent(pRescueShip):getMissionOwnerID()
	local pPlayer = getSceneObject(missionOwnerID)

	if (pPlayer == nil or not SceneObject(pPlayer):isPlayerCreature()) then
		return 1
	end

	if (self.DEBUG_SPACE_RESCUE) then
		print(self.className .. ":handleTargetDestroyed called -- Rescue ship destroyed")
	end

	-- Fail the quest
	self:failQuest(pPlayer, "true")

	return 1
end
