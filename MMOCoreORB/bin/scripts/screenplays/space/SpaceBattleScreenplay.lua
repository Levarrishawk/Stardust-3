SpaceBattleScreenplay = SpaceQuestLogic:new {
	className = "SpaceBattleScreenplay",

	questName = "",
	questType = "",

	questZone = "",

	creditReward = 0,
	itemReward = {},

	parentQuest = "",
	parentQuestType = "",
	parentQuestName = "",

	sideQuest = false,
	sideQuestType = "",
	sideQuestName = "",
	sideQuestSplitType = SpaceQuestLogic.SIDE_QUEST_SPLIT_TYPES.NONE,
	sideQuestDelay = 5, -- Time in seconds to wait to trigger side quest

	-- Screenplay Specific Variables

	battleLocation = {},

	supportShipsDelay = 60,
	enemyShipsDelay = 90,

	supportShips = {},
	enemyShips = {},

	DEBUG_SPACE_BATTLE = false,
}

registerScreenPlay("SpaceBattleScreenplay", false)

--[[

		Space Rescue Quest Functions

--]]

function SpaceBattleScreenplay:start()
end

function SpaceBattleScreenplay:startQuest(pPlayer, pNpc)
	if (pPlayer == nil) then
		Logger:log("Quest: " .. self.questName .. " Type: " .. self.questType .. " -- Failed to startQuest due to pPlayer being nil.", LT_ERROR)
		return
	end

	if (self.DEBUG_SPACE_BATTLE) then
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

	-- Player accepted the quest inside the quest zone, send them to the battle location
	if (SpaceHelpers:isSpaceQuestTaskComplete(pPlayer, self.questType, self.questName, 0)) then
		createEvent(4000, self.className, "setupBattle", pPlayer, "")
	end
end

function SpaceBattleScreenplay:completeQuest(pPlayer, notifyClient)
	if (pPlayer == nil) then
		Logger:log("Quest: " .. self.questName .. " Type: " .. self.questType .. " -- Failed to completeQuest due to pPlayer being nil.", LT_ERROR)
		return
	end

	if (self.DEBUG_SPACE_BATTLE) then
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

function SpaceBattleScreenplay:failQuest(pPlayer, notifyClient)
	if (pPlayer == nil) then
		Logger:log(self.questName .. " Type: " .. self.questType .. " -- Failed to failQuest due to pPlayer being nil.", LT_ERROR)
		return
	end

	if (not SpaceHelpers:isSpaceQuestActive(pPlayer, self.questType, self.questName)) then
		return
	end

	if (self.DEBUG_SPACE_BATTLE) then
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

function SpaceBattleScreenplay:resetQuest(pPlayer)
	if (pPlayer == nil) then
		Logger:log(self.questName .. " Type: " .. self.questType .. " -- Failed to resetQuest due to pPlayer being nil.", LT_ERROR)
		return
	end

	if (self.DEBUG_SPACE_BATTLE) then
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

function SpaceBattleScreenplay:cleanUpQuestData(playerID)
	local pPlayer = getSceneObject(playerID)

	-- Despawn anything still flying for this player
	self:despawnShips(pPlayer)

	-- Delete the remaining enemy count
	deleteData(playerID .. ":" .. self.className .. ":enemyCount:")

	-- Delete the battle active area
	local areaID = readData(playerID .. ":" .. self.className .. ":battleArea:")
	deleteData(playerID .. ":" .. self.className .. ":battleArea:")

	local pActiveArea = getSceneObject(areaID)

	if (pActiveArea ~= nil) then
		dropObserver(ENTEREDAREA, self.className, "notifyEnteredQuestArea", pActiveArea)

		SceneObject(pActiveArea):destroyObjectFromWorld()
	end
end

--[[

		Space Battle Quest Mechanics

--]]

-- Returns the authored battle location as a {x, z, y} table, or nil when the quest has none
-- that this screenplay can read. Named patrol points ("<zone>:<point>") cannot be resolved
-- from a screenplay, so a quest authored that way runs without an approach waypoint.
function SpaceBattleScreenplay:getBattleLocation()
	local location = self.battleLocation

	if (location == nil or type(location) ~= "table") then
		return nil
	end

	if (type(location.x) ~= "number" or type(location.z) ~= "number" or type(location.y) ~= "number") then
		return nil
	end

	return location
end

-- Flattens an authored ship table into a plain list of ship agent names. Both the flat form
-- ({"ship_a", "ship_b"}) and the grouped form ({{"ship_a"}, {"ship_b"}}) are accepted.
function SpaceBattleScreenplay:getShipList(shipTable)
	local shipList = {}

	if (shipTable == nil or type(shipTable) ~= "table") then
		return shipList
	end

	for i = 1, #shipTable, 1 do
		local entry = shipTable[i]

		if (type(entry) == "table") then
			for j = 1, #entry, 1 do
				table.insert(shipList, entry[j])
			end
		elseif (type(entry) == "string") then
			table.insert(shipList, entry)
		end
	end

	return shipList
end

function SpaceBattleScreenplay:setupBattle(pPlayer)
	if (pPlayer == nil) then
		Logger:log(self.className .. ":setupBattle -- pPlayer is nil.", LT_ERROR)
		return
	end

	if (not SpaceHelpers:isSpaceQuestActive(pPlayer, self.questType, self.questName)) then
		return
	end

	local battleLocation = self:getBattleLocation()

	if (self.DEBUG_SPACE_BATTLE) then
		print(self.className .. ":setupBattle -- Player: " .. SceneObject(pPlayer):getDisplayedName() .. " Has Battle Location: " .. tostring(battleLocation ~= nil))
	end

	-- Without a readable location there is nothing to fly to, the battle joins the player
	if (battleLocation == nil) then
		createEvent(2000, self.className, "startBattle", pPlayer, "")
		return
	end

	local playerID = SceneObject(pPlayer):getObjectID()
	local pGhost = CreatureObject(pPlayer):getPlayerObject()

	if (pGhost ~= nil) then
		SpaceHelpers:clearQuestWaypoint(pPlayer, self.className)

		local waypointID = PlayerObject(pGhost):addWaypoint(self.questZone, "@spacequest/" .. self.questType .. "/" .. self.questName .. ":quest_findbattle_t", "", battleLocation.x, battleLocation.z, battleLocation.y, WAYPOINT_SPACE, true, true, WAYPOINTQUESTTASK)

		local pWaypoint = getSceneObject(waypointID)

		if (pWaypoint ~= nil) then
			WaypointObject(pWaypoint):setQuestDetails("@spacequest/" .. self.questType .. "/" .. self.questName .. ":title_d")
		end

		setQuestStatus(playerID .. ":" .. self.className .. ":waypointID", waypointID)
	end

	-- Spawn the arrival area for the player
	local pActiveArea = spawnSpaceActiveArea(self.questZone, "object/space_active_area.iff", battleLocation.x, battleLocation.z, battleLocation.y, self.battleAreaRadius or 400)

	if (pActiveArea == nil) then
		Logger:log(self.className .. ":setupBattle -- Failed to spawn the battle active area.", LT_ERROR)

		createEvent(2000, self.className, "startBattle", pPlayer, "")
		return
	end

	writeData(playerID .. ":" .. self.className .. ":battleArea:", SceneObject(pActiveArea):getObjectID())

	createObserver(ENTEREDAREA, self.className, "notifyEnteredQuestArea", pActiveArea)

	SpaceHelpers:sendQuestUpdate(pPlayer, "@spacequest/" .. self.questType .. "/" .. self.questName .. ":found_loc")
end

function SpaceBattleScreenplay:startBattle(pPlayer)
	if (pPlayer == nil) then
		Logger:log(self.className .. ":startBattle -- pPlayer is nil.", LT_ERROR)
		return
	end

	if (not SpaceHelpers:isSpaceQuestActive(pPlayer, self.questType, self.questName)) then
		return
	end

	-- Update the quest journal to the battle task
	SpaceHelpers:completeSpaceQuestTask(pPlayer, self.questType, self.questName, 1, false)
	SpaceHelpers:activateSpaceQuestTask(pPlayer, self.questType, self.questName, 2, true)

	local enemyShips = self:getShipList(self.enemyShips)

	-- Nothing was authored to fight, the battle is already over
	if (#enemyShips == 0) then
		if (self.DEBUG_SPACE_BATTLE) then
			print(self.className .. ":startBattle -- No enemy ships authored, completing the quest.")
		end

		createEvent(1000, self.className, "completeQuest", pPlayer, "true")
		return
	end

	CreatureObject(pPlayer):sendSystemMessage("@spacequest/" .. self.questType .. "/" .. self.questName .. ":battle_started")

	local supportDelay = self.allyArrivalDelay or self.supportShipsDelay
	local enemyDelay = self.enemyArrivalDelay or self.enemyShipsDelay

	createEvent(supportDelay * 1000, self.className, "spawnSupportShips", pPlayer, "")
	createEvent(enemyDelay * 1000, self.className, "spawnEnemyShips", pPlayer, "")
end

function SpaceBattleScreenplay:spawnSupportShips(pPlayer)
	if (pPlayer == nil) then
		return
	end

	if (not SpaceHelpers:isSpaceQuestActive(pPlayer, self.questType, self.questName)) then
		return
	end

	local supportTable = self.supportShips

	if (supportTable == nil or #supportTable == 0) then
		supportTable = self.alliedShips
	end

	local supportShips = self:getShipList(supportTable)

	if (#supportShips == 0) then
		return
	end

	local pPlayerShip = SceneObject(pPlayer):getRootParent()

	if (pPlayerShip == nil or not SceneObject(pPlayerShip):isShipObject()) then
		Logger:log(self.className .. ":spawnSupportShips -- pPlayerShip is nil.", LT_ERROR)
		return
	end

	local playerID = SceneObject(pPlayer):getObjectID()
	local playerFactionHash = SpaceHelpers:getPlayerSpaceFactionHash(pPlayer)
	local originDist = self.allyOriginDist or -800

	local spawnLocation = nil

	if (originDist < 0) then
		spawnLocation = ShipObject(pPlayerShip):getSpawnPointBehindShip(-originDist, -originDist + 400)
	else
		spawnLocation = ShipObject(pPlayerShip):getSpawnPointInFrontOfShip(originDist, originDist + 400)
	end

	if (self.DEBUG_SPACE_BATTLE) then
		print(self.className .. ":spawnSupportShips -- Support Ships: " .. #supportShips .. " Origin Distance: " .. originDist)
	end

	local shipIDs = readStringVectorSharedMemory(playerID .. ":" .. self.className .. ":supportShips:")
	deleteStringVectorSharedMemory(playerID .. ":" .. self.className .. ":supportShips:")

	local pSquadronLeader = nil

	for i = 1, #supportShips, 1 do
		local pShipAgent = spawnShipAgent(supportShips[i], self.questZone, spawnLocation[1] + getRandomNumber(100, 150), spawnLocation[2], spawnLocation[3] + getRandomNumber(100, 150), pPlayerShip)

		if (pShipAgent == nil) then
			goto continue
		end

		-- Set as a mission-specific ship locked to the mission holder
		ShipAiAgent(pShipAgent):setMissionOwner(pPlayer)

		-- Support ships fly with the player, they must never be left behind in the sector
		ShipAiAgent(pShipAgent):setDespawnOnNoPlayerInRange(true)

		-- Match the players faction so the player cannot be aggroed by their own support
		ShipObject(pShipAgent):setShipFactionString(SpaceHelpers:getPlayerShipFactionString(pPlayer))
		ShipAiAgent(pShipAgent):addSpaceFactionAlly(playerFactionHash)
		ShipAiAgent(pShipAgent):removeSpaceFactionEnemy(playerFactionHash)

		ShipAiAgent(pShipAgent):setGuardPatrol(pPlayerShip)
		ShipAiAgent(pShipAgent):setMinimumGuardPatrol(100)
		ShipAiAgent(pShipAgent):setMaximumGuardPatrol(1000)

		local agentID = SceneObject(pShipAgent):getObjectID()

		-- Set as space mission object
		CreatureObject(pPlayer):addSpaceMissionObject(agentID, (i == #supportShips))

		if (i == 1) then
			pSquadronLeader = pShipAgent
			ShipAiAgent(pShipAgent):createSquadron()
		elseif (pSquadronLeader ~= nil) then
			ShipAiAgent(pShipAgent):assignToSquadron(pSquadronLeader)
		end

		shipIDs[#shipIDs + 1] = agentID

		::continue::
	end

	writeStringVectorSharedMemory(playerID .. ":" .. self.className .. ":supportShips:", shipIDs)

	CreatureObject(pPlayer):sendSystemMessage("@spacequest/" .. self.questType .. "/" .. self.questName .. ":allies_arrived")
end

function SpaceBattleScreenplay:spawnEnemyShips(pPlayer)
	if (pPlayer == nil) then
		return
	end

	if (not SpaceHelpers:isSpaceQuestActive(pPlayer, self.questType, self.questName)) then
		return
	end

	local enemyShips = self:getShipList(self.enemyShips)

	if (#enemyShips == 0) then
		createEvent(1000, self.className, "completeQuest", pPlayer, "true")
		return
	end

	local pPlayerShip = SceneObject(pPlayer):getRootParent()

	if (pPlayerShip == nil or not SceneObject(pPlayerShip):isShipObject()) then
		Logger:log(self.className .. ":spawnEnemyShips -- pPlayerShip is nil.", LT_ERROR)
		return
	end

	local playerID = SceneObject(pPlayer):getObjectID()
	local playerFactionHash = SpaceHelpers:getPlayerSpaceFactionHash(pPlayer)
	local originDist = self.enemyOriginDist or 1000

	local spawnLocation = nil

	if (originDist < 0) then
		spawnLocation = ShipObject(pPlayerShip):getSpawnPointBehindShip(-originDist, -originDist + 400)
	else
		spawnLocation = ShipObject(pPlayerShip):getSpawnPointInFrontOfShip(originDist, originDist + 400)
	end

	if (self.DEBUG_SPACE_BATTLE) then
		print(self.className .. ":spawnEnemyShips -- Enemy Ships: " .. #enemyShips .. " Origin Distance: " .. originDist)
	end

	-- Player effect for the arriving enemy fleet
	CreatureObject(pPlayer):playEffect("clienteffect/ui_quest_spawn_wave.cef", "")

	local shipIDs = readStringVectorSharedMemory(playerID .. ":" .. self.className .. ":enemyShips:")
	deleteStringVectorSharedMemory(playerID .. ":" .. self.className .. ":enemyShips:")

	local pSquadronLeader = nil
	local spawnedCount = 0

	for i = 1, #enemyShips, 1 do
		local pShipAgent = spawnShipAgent(enemyShips[i], self.questZone, spawnLocation[1] + getRandomNumber(100, 150), spawnLocation[2], spawnLocation[3] + getRandomNumber(100, 150), pPlayerShip)

		if (pShipAgent == nil) then
			goto continue
		end

		-- Set as a mission-specific ship locked to the mission holder
		ShipAiAgent(pShipAgent):setMissionOwner(pPlayer)

		-- Battle ships are hyperspaced out on clean up, just in case make sure they are cleaned up
		ShipAiAgent(pShipAgent):setDespawnOnNoPlayerInRange(true)

		-- Add players faction as enemy
		ShipAiAgent(pShipAgent):addSpaceFactionEnemy(playerFactionHash)
		ShipAiAgent(pShipAgent):removeSpaceFactionAlly(playerFactionHash)

		-- Add kill observer
		createObserver(SHIPDESTROYED, self.className, "notifyEnemyShipDestroyed", pShipAgent)

		local agentID = SceneObject(pShipAgent):getObjectID()

		-- Set as space mission object
		CreatureObject(pPlayer):addSpaceMissionObject(agentID, (i == #enemyShips))

		if (i == 1) then
			pSquadronLeader = pShipAgent
			ShipAiAgent(pShipAgent):createSquadron()
		elseif (pSquadronLeader ~= nil) then
			ShipAiAgent(pShipAgent):assignToSquadron(pSquadronLeader)
		end

		shipIDs[#shipIDs + 1] = agentID
		spawnedCount = spawnedCount + 1

		-- Add aggro and set the players ship as the ShipAgents defender
		ShipAiAgent(pShipAgent):engageShipTarget(pPlayerShip)

		::continue::
	end

	-- Every authored enemy failed to spawn, do not soft lock the players datapad
	if (spawnedCount == 0) then
		Logger:log(self.className .. ":spawnEnemyShips -- No enemy ship agents could be spawned.", LT_ERROR)

		createEvent(1000, self.className, "completeQuest", pPlayer, "true")
		return
	end

	writeStringVectorSharedMemory(playerID .. ":" .. self.className .. ":enemyShips:", shipIDs)
	writeData(playerID .. ":" .. self.className .. ":enemyCount:", spawnedCount)

	CreatureObject(pPlayer):sendSystemMessage("@spacequest/" .. self.questType .. "/" .. self.questName .. ":enemies_arrived")
end

function SpaceBattleScreenplay:despawnShips(pPlayer)
	if (pPlayer == nil) then
		return
	end

	local playerID = SceneObject(pPlayer):getObjectID()

	local shipIDs = readStringVectorSharedMemory(playerID .. ":" .. self.className .. ":enemyShips:")
	local supportIDs = readStringVectorSharedMemory(playerID .. ":" .. self.className .. ":supportShips:")

	deleteStringVectorSharedMemory(playerID .. ":" .. self.className .. ":enemyShips:")
	deleteStringVectorSharedMemory(playerID .. ":" .. self.className .. ":supportShips:")

	for i = 1, #supportIDs, 1 do
		table.insert(shipIDs, supportIDs[i])
	end

	if (self.DEBUG_SPACE_BATTLE) then
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
		dropObserver(SHIPDESTROYED, self.className, "notifyEnemyShipDestroyed", pShipAgent)

		-- Make ship fly away first
		ShipObject(pShipAgent):setHyperspacing(true);

		local hyperspaceLocation = ShipObject(pShipAgent):getSpawnPointInFrontOfShip(2500, 8000)

		SceneObject(pShipAgent):setPosition(hyperspaceLocation[1], hyperspaceLocation[2], hyperspaceLocation[3])

		createEvent(2000, "SpaceHelpers", "delayedDestroyShipAgent", pShipAgent, "")

		::continue::
	end
end

--[[

		Space Battle Observers

--]]

function SpaceBattleScreenplay:notifyEnteredQuestArea(pActiveArea, pShip)
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
	local areaID = readData(playerID .. ":" .. self.className .. ":battleArea:")

	-- Another players battle area, or the battle has already begun
	if (areaID ~= SceneObject(pActiveArea):getObjectID()) then
		return 0
	end

	if (self.DEBUG_SPACE_BATTLE) then
		print(self.className .. ":notifyEnteredQuestArea -- Player Ship: " .. SceneObject(pShip):getDisplayedName())
	end

	deleteData(playerID .. ":" .. self.className .. ":battleArea:")

	SpaceHelpers:clearQuestWaypoint(pPilot, self.className)

	createEvent(1000, self.className, "startBattle", pPilot, "")

	return 1
end

function SpaceBattleScreenplay:notifyEnemyShipDestroyed(pShipAgent, pKillerShip)
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

	-- Drop the agent from the spawned vector
	local shipIDs = readStringVectorSharedMemory(missionOwnerID .. ":" .. self.className .. ":enemyShips:")
	deleteStringVectorSharedMemory(missionOwnerID .. ":" .. self.className .. ":enemyShips:")

	local remainingShips = {}

	for i = 1, #shipIDs, 1 do
		local shipID = tonumber(shipIDs[i])

		if (shipID == agentID) then
			goto continue
		end

		table.insert(remainingShips, shipID)

		::continue::
	end

	if (#remainingShips > 0) then
		writeStringVectorSharedMemory(missionOwnerID .. ":" .. self.className .. ":enemyShips:", remainingShips)
	end

	local enemyCount = readData(missionOwnerID .. ":" .. self.className .. ":enemyCount:")
	deleteData(missionOwnerID .. ":" .. self.className .. ":enemyCount:")

	enemyCount = enemyCount - 1

	if (self.DEBUG_SPACE_BATTLE) then
		print(self.className .. ":notifyEnemyShipDestroyed -- Ship Destroyed: " .. SceneObject(pShipAgent):getDisplayedName() .. " Enemies Remaining: " .. enemyCount)
	end

	if (enemyCount > 0) then
		writeData(missionOwnerID .. ":" .. self.className .. ":enemyCount:", enemyCount)

		local messageString = LuaStringIdChatParameter("@spacequest/" .. self.questType .. "/" .. self.questName .. ":enemies_remain")
		messageString:setDI(enemyCount)

		CreatureObject(pPlayer):sendSystemMessage(messageString:_getObject())

		return 1
	end

	CreatureObject(pPlayer):playEffect("clienteffect/ui_quest_destroyed_all.cef", "")
	CreatureObject(pPlayer):sendSystemMessage("@spacequest/" .. self.questType .. "/" .. self.questName .. ":allies_win")

	-- Complete the quest battle task
	SpaceHelpers:completeSpaceQuestTask(pPlayer, self.questType, self.questName, 2, false)

	createEvent(1000, self.className, "completeQuest", pPlayer, "true")

	return 1
end

function SpaceBattleScreenplay:enteredZone(pPlayer, nill, zoneNameHash)
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

	if (self.DEBUG_SPACE_BATTLE) then
		print(self.className .. ":enteredZone called -- QuestType: " .. self.questType .. " Quest Name: " .. self.questName .. " Player Zone Hash: " .. zoneNameHash .. " questZone hash: " .. spaceQuestHash)
	end

	-- Player is in the correct zone
	if (zoneNameHash == spaceQuestHash and not SpaceHelpers:isSpaceQuestTaskComplete(pPlayer, self.questType, self.questName, 0)) then
		-- Complete the quest task 0
		SpaceHelpers:completeSpaceQuestTask(pPlayer, self.questType, self.questName, 0, false)

		-- Activate quest task 1
		SpaceHelpers:activateSpaceQuestTask(pPlayer, self.questType, self.questName, 1, true)

		-- Send the player to the battle location
		createEvent(4000, self.className, "setupBattle", pPlayer, "")

		return 0
	elseif (zoneNameHash ~= spaceQuestHash and SpaceHelpers:isSpaceQuestTaskComplete(pPlayer, self.questType, self.questName, 0)) then
		createEvent(2000, self.className, "failQuest", pPlayer, "true")

		return 1
	end

	return 0
end