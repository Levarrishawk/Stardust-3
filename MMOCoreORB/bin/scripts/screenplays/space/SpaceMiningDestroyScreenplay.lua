--[[
	String file mapping for the space_mining_destroy quest type.

	The three shipped string files (spacequest/space_mining_destroy/kessel_mining_quest_13.stf,
	kashyyyk_mining_quest_8.stf and kashyyyk_mining_quest_5.stf) declare far less than the other
	space quest types do, so the quest runs on two journal tasks only:

		Task 0 -- quest_location_t / quest_location_d ("Kessel System" / "Travel to the Kessel
		          System.") Completed when the player enters questZone.

		Task 1 -- the extraction leg. Only kashyyyk_mining_quest_5 declares quest_destroy_t and
		          quest_destroy_d for it, and both of those entries are empty, so the leg is
		          labeled with title / title_d instead. The unit counter is sent as a quest update
		          the same way SpaceDestroyScreenplay sends its kill counter.

	title / title_d carry the whole objective ("Extract 500 Units of Organometallic Asteroid" /
	"Mine 500 units and return to Captain Koh on Kashyyyk."), which is where resourceType and
	unitsRequired come from. split_quest_alert / split_quest_alert_fail feed the shared side quest
	handling in SpaceQuestLogic. assigned_delayed, autoreward*, unused1_* and unused2_* are empty
	in all three files and are not used here.

	GAP: there is no asteroid binding on the Lua side. DirectorManager exposes no way to read an
	asteroid, its resource type, or a mining action, so units cannot be credited off real ore
	extraction. Units are credited for working each authored asteroid field instead, and
	resourceType is descriptive authoring data that is logged but cannot be enforced against the
	asteroids actually present in the zone.
]]

SpaceMiningDestroyScreenplay = SpaceQuestLogic:new {
	className = "SpaceMiningDestroyScreenplay",

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

	DEBUG_SPACE_MINING_DESTROY = false,

	-- Screenplay Specific Variables

	resourceType = "",
	unitsRequired = 0,

	asteroidLocations = {
		--{patrolPointName = "", x = 0, z = 0, y = 0},
	},

	fieldRadius = 400,
	extractionTime = 60, -- In Seconds, time spent working a single asteroid field
	unitsPerField = 0, -- Units credited per field worked, 0 splits unitsRequired over the fields

	attackDelay = 0, -- In Seconds, 0 spawns no attackers
	attackShips = {},
}

registerScreenPlay("SpaceMiningDestroyScreenplay", false)

--[[

		Space Mining Destroy Quest Functions

--]]

function SpaceMiningDestroyScreenplay:start()
end

function SpaceMiningDestroyScreenplay:startQuest(pPlayer, pNpc)
	if (pPlayer == nil) then
		Logger:log("Quest: " .. self.questName .. " Type: " .. self.questType .. " -- Failed to startQuest due to pPlayer being nil.", LT_ERROR)
		return
	end

	if (self.DEBUG_SPACE_MINING_DESTROY) then
		print(self.className .. ":startQuest called -- QuestType: " .. self.questType .. " Quest Name: " .. self.questName .. " Resource: " .. self.resourceType .. " Units: " .. self.unitsRequired)
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
	end

	-- Create inital observer for player entering Zone and to handle failing quest
	if (not hasObserver(ZONESWITCHED, self.className, "enteredZone", pPlayer)) then
		createObserver(ZONESWITCHED, self.className, "enteredZone", pPlayer, 1)
	end

	-- Player accepted the quest inside the quest zone, send them to the first asteroid field
	if (SpaceHelpers:isSpaceQuestTaskComplete(pPlayer, self.questType, self.questName, 0)) then
		createEvent(4000, self.className, "setupMining", pPlayer, "")
	end
end

function SpaceMiningDestroyScreenplay:completeQuest(pPlayer, notifyClient)
	if (pPlayer == nil) then
		Logger:log("Quest: " .. self.questName .. " Type: " .. self.questType .. " -- Failed to completeQuest due to pPlayer being nil.", LT_ERROR)
		return
	end

	if (self.DEBUG_SPACE_MINING_DESTROY) then
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

function SpaceMiningDestroyScreenplay:failQuest(pPlayer, notifyClient)
	if (pPlayer == nil) then
		Logger:log(self.questName .. " Type: " .. self.questType .. " -- Failed to failQuest due to pPlayer being nil.", LT_ERROR)
		return
	end

	if (not SpaceHelpers:isSpaceQuestActive(pPlayer, self.questType, self.questName)) then
		return
	end

	if (self.DEBUG_SPACE_MINING_DESTROY) then
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

function SpaceMiningDestroyScreenplay:resetQuest(pPlayer)
	if (pPlayer == nil) then
		Logger:log(self.questName .. " Type: " .. self.questType .. " -- Failed to resetQuest due to pPlayer being nil.", LT_ERROR)
		return
	end

	if (self.DEBUG_SPACE_MINING_DESTROY) then
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

function SpaceMiningDestroyScreenplay:cleanUpQuestData(playerID)
	local pPlayer = getSceneObject(playerID)

	-- Despawn anything still flying for this player
	self:despawnShips(pPlayer)

	-- Delete the extraction tracking
	deleteData(playerID .. ":" .. self.className .. ":unitsExtracted:")
	deleteData(playerID .. ":" .. self.className .. ":fieldIndex:")
	deleteData(playerID .. ":" .. self.className .. ":miningRunning:")

	-- Delete the asteroid field active area
	local areaID = readData(playerID .. ":" .. self.className .. ":fieldArea:")
	deleteData(playerID .. ":" .. self.className .. ":fieldArea:")

	local pActiveArea = getSceneObject(areaID)

	if (pActiveArea ~= nil) then
		dropObserver(ENTEREDAREA, self.className, "notifyEnteredQuestArea", pActiveArea)

		SceneObject(pActiveArea):destroyObjectFromWorld()
	end
end

--[[

		Space Mining Destroy Quest Mechanics

--]]

--[[
	Returns the asteroid field table for the given lane position. Fields are worked in the order
	they are authored and the lane wraps, so a quest whose unitsPerField does not divide evenly
	into unitsRequired sends the player back around rather than stalling out.
]]
function SpaceMiningDestroyScreenplay:getAsteroidField(fieldIndex)
	local fields = self.asteroidLocations

	if (fields == nil or #fields == 0) then
		return nil
	end

	local field = fields[((fieldIndex - 1) % #fields) + 1]

	if (type(field) ~= "table") then
		return nil
	end

	--[[
		patrolPointName is the name of the field for the authors benefit. Named space patrol
		points live in ship_mobile/patrol_points and are loaded into the ship agent template Lua
		state, not this one, so the coordinates have to be authored on the field itself.
	]]
	if (type(field.x) ~= "number" or type(field.z) ~= "number" or type(field.y) ~= "number") then
		return nil
	end

	return field
end

-- Returns how many units working a single field is worth
function SpaceMiningDestroyScreenplay:getUnitsPerField()
	if (self.unitsPerField > 0) then
		return self.unitsPerField
	end

	local fieldCount = #self.asteroidLocations

	if (fieldCount < 1) then
		fieldCount = 1
	end

	local units = math.floor(self.unitsRequired / fieldCount)

	if (units < 1) then
		units = 1
	end

	return units
end

function SpaceMiningDestroyScreenplay:setupMining(pPlayer)
	if (pPlayer == nil) then
		Logger:log(self.className .. ":setupMining -- pPlayer is nil.", LT_ERROR)
		return
	end

	if (not SpaceHelpers:isSpaceQuestActive(pPlayer, self.questType, self.questName)) then
		return
	end

	local playerID = SceneObject(pPlayer):getObjectID()

	-- Already working the fields, do not start a second run
	if (readData(playerID .. ":" .. self.className .. ":miningRunning:") == 1) then
		return
	end

	-- Nothing was authored to mine, do not soft lock the players datapad
	if (self:getAsteroidField(1) == nil) then
		if (self.DEBUG_SPACE_MINING_DESTROY) then
			print(self.className .. ":setupMining -- No asteroid fields authored, completing the quest.")
		end

		createEvent(1000, self.className, "completeQuest", pPlayer, "true")
		return
	end

	writeData(playerID .. ":" .. self.className .. ":miningRunning:", 1)
	writeData(playerID .. ":" .. self.className .. ":unitsExtracted:", 0)
	writeData(playerID .. ":" .. self.className .. ":fieldIndex:", 0)

	-- Quest Progress update
	SpaceHelpers:sendQuestProgess(pPlayer, "@spacequest/" .. self.questType .. "/" .. self.questName .. ":title")

	if (self.DEBUG_SPACE_MINING_DESTROY) then
		print(self.className .. ":setupMining -- Fields: " .. #self.asteroidLocations .. " Units Per Field: " .. self:getUnitsPerField())
	end

	-- Pirates and the like harass the player for as long as the extraction leg runs
	if (#self.attackShips > 0 and self.attackDelay > 0) then
		createEvent(self.attackDelay * 1000, self.className, "spawnAttackWave", pPlayer, "")
	end

	self:sendToNextField(pPlayer)
end

function SpaceMiningDestroyScreenplay:sendToNextField(pPlayer)
	if (pPlayer == nil) then
		return
	end

	if (not SpaceHelpers:isSpaceQuestActive(pPlayer, self.questType, self.questName)) then
		return
	end

	local playerID = SceneObject(pPlayer):getObjectID()
	local fieldIndex = readData(playerID .. ":" .. self.className .. ":fieldIndex:") + 1
	local field = self:getAsteroidField(fieldIndex)

	-- The field lane became unreadable, credit the player rather than stranding them
	if (field == nil) then
		createEvent(1000, self.className, "finishMining", pPlayer, "")
		return
	end

	writeData(playerID .. ":" .. self.className .. ":fieldIndex:", fieldIndex)

	if (self.DEBUG_SPACE_MINING_DESTROY) then
		print(self.className .. ":sendToNextField -- Field #" .. fieldIndex .. " Name: " .. tostring(field.patrolPointName) .. " Loc: " .. field.x .. ", " .. field.z .. ", " .. field.y)
	end

	local pGhost = CreatureObject(pPlayer):getPlayerObject()

	if (pGhost ~= nil) then
		SpaceHelpers:clearQuestWaypoint(pPlayer, self.className)

		local waypointID = PlayerObject(pGhost):addWaypoint(self.questZone, "@spacequest/" .. self.questType .. "/" .. self.questName .. ":title", "", field.x, field.z, field.y, WAYPOINT_SPACE, true, true, WAYPOINTQUESTTASK)

		local pWaypoint = getSceneObject(waypointID)

		if (pWaypoint ~= nil) then
			WaypointObject(pWaypoint):setQuestDetails("@spacequest/" .. self.questType .. "/" .. self.questName .. ":title_d")
		end

		-- Store the waypointID on the player
		setQuestStatus(playerID .. ":" .. self.className .. ":waypointID", waypointID)
	end

	-- Player effect for player
	CreatureObject(pPlayer):playEffect("clienteffect/ui_quest_waypoint_target.cef", "")

	local pActiveArea = spawnSpaceActiveArea(self.questZone, "object/space_active_area.iff", field.x, field.z, field.y, self.fieldRadius)

	-- Without an area to trigger on the extraction cannot be observed, so credit the field on the timer alone
	if (pActiveArea == nil) then
		Logger:log(self.className .. ":sendToNextField -- Failed to spawn the asteroid field active area.", LT_ERROR)

		createEvent(self.extractionTime * 1000, self.className, "finishField", pPlayer, "")
		return
	end

	writeData(playerID .. ":" .. self.className .. ":fieldArea:", SceneObject(pActiveArea):getObjectID())

	createObserver(ENTEREDAREA, self.className, "notifyEnteredQuestArea", pActiveArea)
end

function SpaceMiningDestroyScreenplay:startExtraction(pPlayer)
	if (pPlayer == nil) then
		return
	end

	if (not SpaceHelpers:isSpaceQuestActive(pPlayer, self.questType, self.questName)) then
		return
	end

	local playerID = SceneObject(pPlayer):getObjectID()

	if (readData(playerID .. ":" .. self.className .. ":miningRunning:") ~= 1) then
		return
	end

	if (self.DEBUG_SPACE_MINING_DESTROY) then
		print(self.className .. ":startExtraction -- Field #" .. readData(playerID .. ":" .. self.className .. ":fieldIndex:") .. " Extraction Time: " .. self.extractionTime)
	end

	-- Extraction underway message
	SpaceHelpers:sendQuestUpdate(pPlayer, "You begin extracting from the asteroid field.") -- "mining_extraction_started"

	local extractionDelay = self.extractionTime * 1000

	if (extractionDelay < 1000) then
		extractionDelay = 1000
	end

	createEvent(extractionDelay, self.className, "finishField", pPlayer, "")
end

function SpaceMiningDestroyScreenplay:finishField(pPlayer)
	if (pPlayer == nil) then
		return
	end

	if (not SpaceHelpers:isSpaceQuestActive(pPlayer, self.questType, self.questName)) then
		return
	end

	local playerID = SceneObject(pPlayer):getObjectID()

	if (readData(playerID .. ":" .. self.className .. ":miningRunning:") ~= 1) then
		return
	end

	local unitsExtracted = readData(playerID .. ":" .. self.className .. ":unitsExtracted:") + self:getUnitsPerField()

	writeData(playerID .. ":" .. self.className .. ":unitsExtracted:", unitsExtracted)

	if (self.DEBUG_SPACE_MINING_DESTROY) then
		print(self.className .. ":finishField -- Units Extracted: " .. unitsExtracted .. " of " .. self.unitsRequired)
	end

	if (unitsExtracted >= self.unitsRequired) then
		-- Player effect for player
		CreatureObject(pPlayer):playEffect("clienteffect/ui_quest_destroyed_all.cef", "")

		self:finishMining(pPlayer)
		return
	end

	-- Unit counter sent to player
	SpaceHelpers:sendQuestUpdate(pPlayer, self.unitsRequired - unitsExtracted .. " units of " .. self.resourceType .. " remaining to be extracted.") -- "mining_remainder_update"

	self:sendToNextField(pPlayer)
end

function SpaceMiningDestroyScreenplay:finishMining(pPlayer)
	if (pPlayer == nil) then
		return
	end

	if (not SpaceHelpers:isSpaceQuestActive(pPlayer, self.questType, self.questName)) then
		return
	end

	local playerID = SceneObject(pPlayer):getObjectID()

	if (readData(playerID .. ":" .. self.className .. ":miningRunning:") ~= 1) then
		return
	end

	writeData(playerID .. ":" .. self.className .. ":miningRunning:", 0)

	if (self.DEBUG_SPACE_MINING_DESTROY) then
		print(self.className .. ":finishMining -- Fields Worked: " .. readData(playerID .. ":" .. self.className .. ":fieldIndex:"))
	end

	-- Complete the extraction task
	SpaceHelpers:completeSpaceQuestTask(pPlayer, self.questType, self.questName, 1, false)

	-- Clear the field waypoint
	SpaceHelpers:clearQuestWaypoint(pPlayer, self.className)

	createEvent(1000, self.className, "completeQuest", pPlayer, "true")
end

function SpaceMiningDestroyScreenplay:spawnAttackWave(pPlayer)
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

	if (readData(playerID .. ":" .. self.className .. ":miningRunning:") ~= 1) then
		return
	end

	local pPlayerShip = SceneObject(pPlayer):getRootParent()

	if (pPlayerShip == nil or not SceneObject(pPlayerShip):isShipObject()) then
		Logger:log(self.className .. ":spawnAttackWave -- pPlayerShip is nil.", LT_ERROR)
		return
	end

	-- Waves are taken in order off the field the player is working and wrap once the groups run out
	local fieldIndex = readData(playerID .. ":" .. self.className .. ":fieldIndex:")

	if (fieldIndex < 1) then
		fieldIndex = 1
	end

	local waveShips = self.attackShips[((fieldIndex - 1) % #self.attackShips) + 1]

	if (type(waveShips) ~= "table") then
		waveShips = {waveShips}
	end

	local playerFactionHash = SpaceHelpers:getPlayerSpaceFactionHash(pPlayer)
	local spawnLocation = ShipObject(pPlayerShip):getSpawnPointBehindShip(600, 1200)

	if (self.DEBUG_SPACE_MINING_DESTROY) then
		print(self.className .. ":spawnAttackWave -- Field #" .. fieldIndex .. " Wave Size: " .. #waveShips)
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

		-- Raiders chase the miner and clean themselves up when nobody is near
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

	-- Raiders keep coming back for as long as the player is working the fields
	createEvent(self.attackDelay * 1000, self.className, "spawnAttackWave", pPlayer, "")
end

function SpaceMiningDestroyScreenplay:despawnShips(pPlayer)
	if (pPlayer == nil) then
		return
	end

	local playerID = SceneObject(pPlayer):getObjectID()
	local shipIDs = readStringVectorSharedMemory(playerID .. ":" .. self.className .. ":attackShips:")

	deleteStringVectorSharedMemory(playerID .. ":" .. self.className .. ":attackShips:")

	if (self.DEBUG_SPACE_MINING_DESTROY) then
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

		Space Mining Destroy Observers

--]]

function SpaceMiningDestroyScreenplay:notifyEnteredQuestArea(pActiveArea, pShip)
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
	local areaID = readData(playerID .. ":" .. self.className .. ":fieldArea:")

	-- Another players asteroid field, or this field has already been reached
	if (areaID ~= SceneObject(pActiveArea):getObjectID()) then
		return 0
	end

	if (self.DEBUG_SPACE_MINING_DESTROY) then
		print(self.className .. ":notifyEnteredQuestArea -- Player Ship: " .. SceneObject(pShip):getDisplayedName())
	end

	deleteData(playerID .. ":" .. self.className .. ":fieldArea:")

	SpaceHelpers:clearQuestWaypoint(pPilot, self.className)

	SceneObject(pActiveArea):destroyObjectFromWorld()

	createEvent(1000, self.className, "startExtraction", pPilot, "")

	return 1
end

function SpaceMiningDestroyScreenplay:notifyAttackShipDestroyed(pShipAgent, pKillerShip)
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

	-- Player effect for player
	CreatureObject(pPlayer):playEffect("clienteffect/ui_quest_destroyed_wave.cef", "")

	return 1
end

function SpaceMiningDestroyScreenplay:enteredZone(pPlayer, nill, zoneNameHash)
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

	local spaceQuestHash = getHashCode(self.questZone)

	if (self.DEBUG_SPACE_MINING_DESTROY) then
		print(self.className .. ":enteredZone called -- QuestType: " .. self.questType .. " Quest Name: " .. self.questName .. " Player Zone Hash: " .. zoneNameHash .. " questZone hash: " .. spaceQuestHash)
	end

	-- Player is in the correct zone
	if (zoneNameHash == spaceQuestHash and not SpaceHelpers:isSpaceQuestTaskComplete(pPlayer, self.questType, self.questName, 0)) then
		-- Complete the quest task 0
		SpaceHelpers:completeSpaceQuestTask(pPlayer, self.questType, self.questName, 0, false)

		-- Activate quest task 1
		SpaceHelpers:activateSpaceQuestTask(pPlayer, self.questType, self.questName, 1, true)

		-- Send the player to the first asteroid field
		createEvent(4000, self.className, "setupMining", pPlayer, "")

		return 0
	elseif (zoneNameHash ~= spaceQuestHash and SpaceHelpers:isSpaceQuestTaskComplete(pPlayer, self.questType, self.questName, 0)) then
		createEvent(2000, self.className, "failQuest", pPlayer, "true")

		return 1
	end

	return 0
end
