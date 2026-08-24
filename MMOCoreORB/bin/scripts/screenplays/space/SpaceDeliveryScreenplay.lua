SpaceDeliveryScreenplay = SpaceQuestLogic:new {
	className = "SpaceDeliveryScreenplay",

	-- Screenplay Specific Variables

	DEBUG_SPACE_DELIVERY = false,

	arrivalDelay = 5, -- In Seconds, time between reaching a leg and the freighter arriving
	dockingDelay = 10, -- In Seconds, time the cargo transfer takes once docking starts

	pickupShip = "",
	pickupPoint = "",

	deliveryShip = "",
	deliveryPoint = "",

	rendezvousRadius = 200,

	attackDelay = 0, -- In Seconds
	attackShips = {},

	--[[
		Journal task layout, taken from the delivery_no_pickup string files:
			task 0 - quest_location   (get to the quest zone)
			task 1 - quest_rendezvous (pickup leg,   only on questType "delivery")
			task 2 - quest_dock       (pickup leg,   only on questType "delivery")
			task 1 - quest_rendezvous2 (delivery leg, no pickup)
			task 2 - quest_dock2       (delivery leg, no pickup)
		On questType "delivery" the delivery leg is pushed to tasks 3 and 4 by deliveryTaskOffset.
	]]
	hasPickupLeg = true,
	deliveryTaskOffset = 2,

	--[[
		Delivery leg string keys are VERIFIED against spacequest/delivery_no_pickup/*.stf.
		Pickup leg string keys are the symmetric _pickup form and are NOT verified - the
		spacequest/delivery/*.stf files are not extractable in this tree. They are fields so a
		quest can correct them without touching this class.
	]]
	pickupMessages = {
		foundLoc = "found_loc_p",
		arrived = "arrived_at_pickup",
		greeting = "hello_p",
		dockingStarted = "docking_started_pickup",
		dockingComplete = "docking_complete_pickup",
	},

	deliveryMessages = {
		foundLoc = "found_loc_d",
		arrived = "arrived_at_delivery",
		greeting = "hello_d",
		dockingStarted = "docking_started_delivery",
		dockingComplete = "docking_complete_delivery",
	},
}

registerScreenPlay("SpaceDeliveryScreenplay", false)

--[[

		Space Delivery Quest Functions

--]]

function SpaceDeliveryScreenplay:start()
end

function SpaceDeliveryScreenplay:startQuest(pPlayer, pNpc)
	if (pPlayer == nil) then
		Logger:log("Quest: " .. self.questName .. " Type: " .. self.questType .. " -- Failed to startQuest due to pPlayer being nil.", LT_ERROR)
		return
	end

	if (self.DEBUG_SPACE_DELIVERY) then
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

	-- Player accepted the quest inside the quest zone, start the run
	if (SpaceHelpers:isSpaceQuestTaskComplete(pPlayer, self.questType, self.questName, 0)) then
		createEvent(4000, self.className, "startFirstLeg", pPlayer, "")
	end
end

function SpaceDeliveryScreenplay:completeQuest(pPlayer, notifyClient)
	if (pPlayer == nil) then
		Logger:log("Quest: " .. self.questName .. " Type: " .. self.questType .. " -- Failed to completeQuest due to pPlayer being nil.", LT_ERROR)
		return
	end

	if (self.DEBUG_SPACE_DELIVERY) then
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

function SpaceDeliveryScreenplay:failQuest(pPlayer, notifyClient)
	if (pPlayer == nil) then
		Logger:log(self.questName .. " Type: " .. self.questType .. " -- Failed to failQuest due to pPlayer being nil.", LT_ERROR)
		return
	end

	if (not SpaceHelpers:isSpaceQuestActive(pPlayer, self.questType, self.questName) and (notifyClient ~= "false" or not SpaceHelpers:isSpaceQuestComplete(pPlayer, self.questType, self.questName))) then
		return
	end

	if (self.DEBUG_SPACE_DELIVERY) then
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

function SpaceDeliveryScreenplay:resetQuest(pPlayer)
	if (pPlayer == nil) then
		Logger:log(self.questName .. " Type: " .. self.questType .. " -- Failed to resetQuest due to pPlayer being nil.", LT_ERROR)
		return
	end

	if (self.DEBUG_SPACE_DELIVERY) then
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

function SpaceDeliveryScreenplay:cleanUpQuestData(playerID)
	local pPlayer = getSceneObject(playerID)

	-- Despawn anything still flying for this player
	self:despawnShips(pPlayer)

	-- Delete the stored escorted ship ID
	deleteData(playerID .. ":" .. self.className .. ":escortID:")

	-- Delete player location data
	deleteData(playerID .. ":" .. self.className .. ":location:")

	-- Delete Start point
	deleteData(playerID .. self.className .. ":startPoint:")

	-- Delete the distance warnings
	deleteData(playerID .. ":" .. self.className .. ":distanceWarnings:")

	-- Kill Count Tracking
	deleteData(playerID .. ":" .. self.className .. ":" .. ":EscortKillCount:")

	-- Delete the freighter tracking
	deleteData(playerID .. ":" .. self.className .. ":freighterID:")
	deleteStringData(playerID .. ":" .. self.className .. ":leg:")

	-- Delete the rendezvous area
	local areaID = readData(playerID .. ":" .. self.className .. ":rendezvousArea:")
	deleteData(playerID .. ":" .. self.className .. ":rendezvousArea:")

	local pActiveArea = getSceneObject(areaID)

	if (pActiveArea ~= nil) then
		dropObserver(ENTEREDAREA, self.className, "notifyEnteredQuestArea", pActiveArea)

		SceneObject(pActiveArea):destroyObjectFromWorld()
	end
end

--[[

		Space Delivery Quest Mechanics

--]]

-- Returns the message key table for the leg currently being run
function SpaceDeliveryScreenplay:getLegMessages(legName)
	if (legName == "pickup") then
		return self.pickupMessages
	end

	return self.deliveryMessages
end

-- Returns the journal task numbers used by the given leg
function SpaceDeliveryScreenplay:getLegTasks(legName)
	if (legName == "pickup") then
		return 1, 2
	end

	local offset = 0

	if (self.hasPickupLeg) then
		offset = self.deliveryTaskOffset
	end

	return 1 + offset, 2 + offset
end

-- Returns the ship agent template flown by the given leg, or "" when none was authored
function SpaceDeliveryScreenplay:getLegShip(legName)
	if (legName == "pickup") then
		return self.pickupShip
	end

	return self.deliveryShip
end

--[[
	pickupPoint and deliveryPoint are authored in the "<zone>:<point_name>" composite form. Named
	space patrol points live in ship_mobile/patrol_points and are loaded into the ship agent
	template Lua state, not this one, so a screenplay cannot turn that string into coordinates.
	A quest may instead author the point as a {x =, z =, y =} table, in which case the freighter
	is placed there and the player is given an approach waypoint.
]]
function SpaceDeliveryScreenplay:getLegLocation(legName)
	local point = self.pickupPoint

	if (legName ~= "pickup") then
		point = self.deliveryPoint
	end

	if (point == nil or type(point) ~= "table") then
		return nil
	end

	if (type(point.x) ~= "number" or type(point.z) ~= "number" or type(point.y) ~= "number") then
		return nil
	end

	return point
end

function SpaceDeliveryScreenplay:startFirstLeg(pPlayer)
	if (pPlayer == nil) then
		return
	end

	if (self.hasPickupLeg and self.pickupShip ~= "") then
		self:startLeg(pPlayer, "pickup")
		return
	end

	self:startLeg(pPlayer, "delivery")
end

function SpaceDeliveryScreenplay:startPickupLeg(pPlayer)
	self:startLeg(pPlayer, "pickup")
end

function SpaceDeliveryScreenplay:startDeliveryLeg(pPlayer)
	self:startLeg(pPlayer, "delivery")
end

function SpaceDeliveryScreenplay:startLeg(pPlayer, legName)
	if (pPlayer == nil) then
		Logger:log(self.className .. ":startLeg -- pPlayer is nil.", LT_ERROR)
		return
	end

	if (not SpaceHelpers:isSpaceQuestActive(pPlayer, self.questType, self.questName)) then
		return
	end

	local rendezvousTask, dockTask = self:getLegTasks(legName)
	local messages = self:getLegMessages(legName)

	-- Nothing was authored to meet on this leg, do not leave the player with an unfinishable run
	if (self:getLegShip(legName) == "") then
		if (self.DEBUG_SPACE_DELIVERY) then
			print(self.className .. ":startLeg -- No ship authored for leg " .. legName .. ", advancing.")
		end

		self:finishLeg(pPlayer, legName)
		return
	end

	local playerID = SceneObject(pPlayer):getObjectID()

	writeStringData(playerID .. ":" .. self.className .. ":leg:", legName)

	SpaceHelpers:activateSpaceQuestTask(pPlayer, self.questType, self.questName, rendezvousTask, true)

	SpaceHelpers:sendQuestUpdate(pPlayer, "@spacequest/" .. self.questType .. "/" .. self.questName .. ":" .. messages.foundLoc)

	local location = self:getLegLocation(legName)

	-- No readable coordinates, the freighter comes to the player instead
	if (location == nil) then
		createEvent(self.arrivalDelay * 1000, self.className, "spawnFreighter", pPlayer, "")
		return
	end

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

	local pActiveArea = spawnSpaceActiveArea(self.questZone, "object/space_active_area.iff", location.x, location.z, location.y, self.rendezvousRadius)

	if (pActiveArea == nil) then
		Logger:log(self.className .. ":startLeg -- Failed to spawn the rendezvous active area.", LT_ERROR)

		createEvent(self.arrivalDelay * 1000, self.className, "spawnFreighter", pPlayer, "")
		return
	end

	writeData(playerID .. ":" .. self.className .. ":rendezvousArea:", SceneObject(pActiveArea):getObjectID())

	createObserver(ENTEREDAREA, self.className, "notifyEnteredQuestArea", pActiveArea)
end

function SpaceDeliveryScreenplay:spawnFreighter(pPlayer)
	if (pPlayer == nil) then
		return
	end

	if (not SpaceHelpers:isSpaceQuestActive(pPlayer, self.questType, self.questName)) then
		return
	end

	local playerID = SceneObject(pPlayer):getObjectID()
	local legName = readStringData(playerID .. ":" .. self.className .. ":leg:")
	local messages = self:getLegMessages(legName)
	local freighter = self:getLegShip(legName)

	local pPlayerShip = SceneObject(pPlayer):getRootParent()

	if (pPlayerShip == nil or not SceneObject(pPlayerShip):isShipObject()) then
		Logger:log(self.className .. ":spawnFreighter -- pPlayerShip is nil.", LT_ERROR)
		return
	end

	local spawnLocation = ShipObject(pPlayerShip):getSpawnPointInFrontOfShip(250, 500)
	local pShipAgent = spawnShipAgent(freighter, self.questZone, spawnLocation[1], spawnLocation[2], spawnLocation[3], pPlayerShip)

	-- The freighter could not be placed, hand the leg to the player rather than stall the quest
	if (pShipAgent == nil) then
		Logger:log(self.className .. ":spawnFreighter -- Failed to spawn ship agent " .. freighter .. ".", LT_ERROR)

		self:finishLeg(pPlayer, legName)
		return
	end

	local agentID = SceneObject(pShipAgent):getObjectID()

	if (self.DEBUG_SPACE_DELIVERY) then
		print(self.className .. ":spawnFreighter -- Leg: " .. legName .. " Ship: " .. ShipObject(pShipAgent):getShipName() .. " ID: " .. agentID)
	end

	-- Set the agent as a mission object
	CreatureObject(pPlayer):addSpaceMissionObject(agentID, true)

	-- Set as a mission-specific ship locked to the mission holder
	ShipAiAgent(pShipAgent):setMissionOwner(pPlayer)

	-- The freighter holds station waiting on the player
	ShipAiAgent(pShipAgent):setFixedPatrol()

	-- Set as same space faction so the freighter is not attacked by the players own side
	ShipObject(pShipAgent):setShipFactionString(SpaceHelpers:getPlayerShipFactionString(pPlayer))

	local playerFactionHash = SpaceHelpers:getPlayerShipFactionHash(pPlayer)

	ShipAiAgent(pShipAgent):addSpaceFactionAlly(playerFactionHash)
	ShipAiAgent(pShipAgent):removeSpaceFactionEnemy(playerFactionHash)

	-- Losing the freighter fails the run
	createObserver(SHIPDESTROYED, self.className, "notifyFreighterDestroyed", pShipAgent)

	writeData(playerID .. ":" .. self.className .. ":freighterID:", agentID)

	-- Player effect and arrival music
	CreatureObject(pPlayer):playEffect("clienteffect/ui_quest_spawn_escort.cef", "")
	CreatureObject(pPlayer):playMusicMessage("sound/mus_quest_escort_arrival.snd")

	CreatureObject(pPlayer):sendSystemMessage("@spacequest/" .. self.questType .. "/" .. self.questName .. ":" .. messages.arrived)

	ShipAiAgent(pShipAgent):tauntPlayer(pPlayer, "@spacequest/" .. self.questType .. "/" .. self.questName .. ":" .. messages.greeting)

	local rendezvousTask, dockTask = self:getLegTasks(legName)

	SpaceHelpers:completeSpaceQuestTask(pPlayer, self.questType, self.questName, rendezvousTask, false)
	SpaceHelpers:activateSpaceQuestTask(pPlayer, self.questType, self.questName, dockTask, true)

	-- Schedule the attack wave that hits the transfer
	if (self.attackDelay > 0 and #self.attackShips > 0) then
		createEvent(self.attackDelay * 1000, self.className, "spawnAttackWave", pPlayer, "")
	end

	createEvent(self.arrivalDelay * 1000, self.className, "startDocking", pPlayer, "")
end

function SpaceDeliveryScreenplay:startDocking(pPlayer)
	if (pPlayer == nil) then
		return
	end

	if (not SpaceHelpers:isSpaceQuestActive(pPlayer, self.questType, self.questName)) then
		return
	end

	local playerID = SceneObject(pPlayer):getObjectID()
	local legName = readStringData(playerID .. ":" .. self.className .. ":leg:")
	local messages = self:getLegMessages(legName)

	-- Docking music
	CreatureObject(pPlayer):playMusicMessage("sound/mus_quest_theme_docking.snd")

	CreatureObject(pPlayer):sendSystemMessage("@spacequest/" .. self.questType .. "/" .. self.questName .. ":" .. messages.dockingStarted)

	createEvent(self.dockingDelay * 1000, self.className, "finishDocking", pPlayer, "")
end

function SpaceDeliveryScreenplay:finishDocking(pPlayer)
	if (pPlayer == nil) then
		return
	end

	if (not SpaceHelpers:isSpaceQuestActive(pPlayer, self.questType, self.questName)) then
		return
	end

	local playerID = SceneObject(pPlayer):getObjectID()
	local legName = readStringData(playerID .. ":" .. self.className .. ":leg:")
	local messages = self:getLegMessages(legName)

	CreatureObject(pPlayer):sendSystemMessage("@spacequest/" .. self.questType .. "/" .. self.questName .. ":" .. messages.dockingComplete)

	self:finishLeg(pPlayer, legName)
end

function SpaceDeliveryScreenplay:finishLeg(pPlayer, legName)
	if (pPlayer == nil) then
		return
	end

	local playerID = SceneObject(pPlayer):getObjectID()
	local rendezvousTask, dockTask = self:getLegTasks(legName)

	SpaceHelpers:completeSpaceQuestTask(pPlayer, self.questType, self.questName, rendezvousTask, false)
	SpaceHelpers:completeSpaceQuestTask(pPlayer, self.questType, self.questName, dockTask, false)

	self:despawnFreighter(pPlayer)

	deleteStringData(playerID .. ":" .. self.className .. ":leg:")

	if (legName == "pickup") then
		createEvent(2000, self.className, "startDeliveryLeg", pPlayer, "")
		return
	end

	createEvent(1000, self.className, "completeQuest", pPlayer, "true")
end

function SpaceDeliveryScreenplay:spawnAttackWave(pPlayer)
	if (pPlayer == nil) then
		return
	end

	if (not SpaceHelpers:isSpaceQuestActive(pPlayer, self.questType, self.questName)) then
		return
	end

	if (#self.attackShips == 0) then
		return
	end

	local pPlayerShip = SceneObject(pPlayer):getRootParent()

	if (pPlayerShip == nil or not SceneObject(pPlayerShip):isShipObject()) then
		return
	end

	local waveShips = self.attackShips[getRandomNumber(1, #self.attackShips)]

	if (type(waveShips) ~= "table") then
		waveShips = {waveShips}
	end

	local playerID = SceneObject(pPlayer):getObjectID()
	local playerFactionHash = SpaceHelpers:getPlayerSpaceFactionHash(pPlayer)
	local spawnLocation = ShipObject(pPlayerShip):getSpawnPointInFrontOfShip(600, 1200)

	if (self.DEBUG_SPACE_DELIVERY) then
		print(self.className .. ":spawnAttackWave -- Wave Size: " .. #waveShips)
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

	if (#shipIDs == 0) then
		return
	end

	writeStringVectorSharedMemory(playerID .. ":" .. self.className .. ":attackShips:", shipIDs)

	CreatureObject(pPlayer):playEffect("clienteffect/ui_quest_spawn_wave.cef", "")
	CreatureObject(pPlayer):sendSystemMessage("@spacequest/" .. self.questType .. "/" .. self.questName .. ":attack_notify")
end

function SpaceDeliveryScreenplay:despawnFreighter(pPlayer)
	if (pPlayer == nil) then
		return
	end

	local playerID = SceneObject(pPlayer):getObjectID()
	local freighterID = readData(playerID .. ":" .. self.className .. ":freighterID:")

	deleteData(playerID .. ":" .. self.className .. ":freighterID:")

	if (freighterID == 0) then
		return
	end

	-- Remove as Space Mission Object
	CreatureObject(pPlayer):removeSpaceMissionObject(freighterID, true)

	local pShipAgent = getSceneObject(freighterID)

	if (pShipAgent == nil) then
		return
	end

	dropObserver(SHIPDESTROYED, self.className, "notifyFreighterDestroyed", pShipAgent)

	-- Make ship fly away first
	ShipObject(pShipAgent):setHyperspacing(true);

	local hyperspaceLocation = ShipObject(pShipAgent):getSpawnPointInFrontOfShip(2500, 8000)

	SceneObject(pShipAgent):setPosition(hyperspaceLocation[1], hyperspaceLocation[2], hyperspaceLocation[3])

	createEvent(2000, "SpaceHelpers", "delayedDestroyShipAgent", pShipAgent, "")
end

function SpaceDeliveryScreenplay:despawnShips(pPlayer)
	if (pPlayer == nil) then
		return
	end

	self:despawnFreighter(pPlayer)

	local playerID = SceneObject(pPlayer):getObjectID()
	local shipIDs = readStringVectorSharedMemory(playerID .. ":" .. self.className .. ":attackShips:")

	deleteStringVectorSharedMemory(playerID .. ":" .. self.className .. ":attackShips:")

	for i = 1, #shipIDs, 1 do
		local shipID = tonumber(shipIDs[i])

		-- Remove as Space Mission Object
		CreatureObject(pPlayer):removeSpaceMissionObject(shipID, (i == #shipIDs))

		local pShipAgent = getSceneObject(shipID)

		if (pShipAgent == nil) then
			goto continue
		end

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

		Space Delivery Observers

--]]

function SpaceDeliveryScreenplay:enteredZone(pPlayer, nill, zoneNameHash)
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

	if (self.DEBUG_SPACE_DELIVERY) then
		print(self.className .. ":enteredZone called -- QuestType: " .. self.questType .. " Quest Name: " .. self.questName .. " Player Zone Hash: " .. zoneNameHash .. " questZone hash: " .. spaceQuestHash)
	end

	-- Player is in the correct zone. Always resume the first leg here because a chained
	-- quest may retain its completed location task without having created its waypoint.
	if (zoneNameHash == spaceQuestHash) then
		if (not SpaceHelpers:isSpaceQuestTaskComplete(pPlayer, self.questType, self.questName, 0)) then
			-- Complete the quest task 0
			SpaceHelpers:completeSpaceQuestTask(pPlayer, self.questType, self.questName, 0, false)

			-- Activate quest task 1
			SpaceHelpers:activateSpaceQuestTask(pPlayer, self.questType, self.questName, 1, true)
		end

		createEvent(4000, self.className, "startFirstLeg", pPlayer, "")

		return 0
	elseif (zoneNameHash ~= spaceQuestHash and SpaceHelpers:isSpaceQuestTaskComplete(pPlayer, self.questType, self.questName, 0)) then
		createEvent(2000, self.className, "failQuest", pPlayer, "true")

		return 1
	end

	return 0
end

function SpaceDeliveryScreenplay:notifyEnteredQuestArea(pActiveArea, pShip)
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
	local areaID = readData(playerID .. ":" .. self.className .. ":rendezvousArea:")

	-- Another players rendezvous area
	if (areaID ~= SceneObject(pActiveArea):getObjectID()) then
		return 0
	end

	deleteData(playerID .. ":" .. self.className .. ":rendezvousArea:")

	SpaceHelpers:clearQuestWaypoint(pPilot, self.className)

	createEvent(self.arrivalDelay * 1000, self.className, "spawnFreighter", pPilot, "")

	return 1
end

function SpaceDeliveryScreenplay:notifyFreighterDestroyed(pShipAgent, pKillerShip)
	if (pShipAgent == nil or not SceneObject(pShipAgent):isShipAiAgent()) then
		return 1
	end

	local missionOwnerID = ShipAiAgent(pShipAgent):getMissionOwnerID()
	local pPlayer = getSceneObject(missionOwnerID)

	if (pPlayer == nil or not SceneObject(pPlayer):isPlayerCreature()) then
		return 1
	end

	-- Remove agent as mission object
	CreatureObject(pPlayer):removeSpaceMissionObject(SceneObject(pShipAgent):getObjectID(), true)

	deleteData(missionOwnerID .. ":" .. self.className .. ":freighterID:")

	CreatureObject(pPlayer):sendSystemMessage("@spacequest/" .. self.questType .. "/" .. self.questName .. ":failed_destroyed")

	createEvent(2000, self.className, "failQuest", pPlayer, "true")

	return 1
end

function SpaceDeliveryScreenplay:notifyAttackShipDestroyed(pShipAgent, pKillerShip)
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

	CreatureObject(pPlayer):playEffect("clienteffect/ui_quest_destroyed_all.cef", "")
	CreatureObject(pPlayer):sendSystemMessage("@spacequest/" .. self.questType .. "/" .. self.questName .. ":attack_stopped")

	return 1
end
