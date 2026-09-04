-- IG-88 Instanced Dungeon, in the shape of Levarris' Exar Kun and Axkva Min instances.
-- Lev never built this one: neither SD1 nor SD3 has any ig88 file under screenplays/.
-- The SHAPE below is his (screenplays/dungeon/exar_kun/exarKun.lua, H(ek) 2c76b9049a);
-- the ENCOUNTER is SOE's (script/theme_park/heroic/ig88/*.java, datatables/spawning/
-- heroic/heroic_ig88.tab); the BALANCE is Stardust's. Every authored value is marked
-- OURS, NOT SOURCED at the line that carries it.
--
-- The arena is spawned, not placed: no snapshot the live server loads carries
-- ig88_factory_arena (PART 6 / finding 0.1). getBuildingObject therefore reads a
-- writeData id, not a hardcoded snapshot id.
--
-- EXITEDBUILDING vs the fail-and-restart loop (flagged for Aaron): Lev's
-- resetInstanceA ejects everybody the moment one member steps out. SOE's
-- ig88_failure_check restarts the encounter in-place when r1 has no live
-- players. On SD3 a wipe leaves incapacitated players in-cell, so
-- getLivePlayersInArena returns 0 and restartSpawn fires -- but a cloning
-- player leaves the building and trips EXITEDBUILDING first. Both mechanisms
-- are kept: EXITEDBUILDING is Lev's shape (H(ek) and H(am) kept it); the
-- failure loop handles the in-cell wipe only. Observed winner is SC8 item 14.
--
-- getLivePlayersInArena / getPlayersInArena: the loop is OURS, NOT SOURCED;
-- the predicate (player, not incapacitated, not dead) is SOE's
-- trial.getNonStealthedTargetsInCell. The stealth clause is dropped -- SD3
-- has no hasInvisibleBuff binding.
--
-- Daily lockout (instance_datatable lockoutTimer = daily): recorded, not built.
-- Same call as H(ek) Part 12 and H(am).
--
-- The arena template is registered as CLONINGBUILDING / CLONER_STANDARD
-- (object/custom_content/building/heroic/ig88_factory_arena.lua:49-51). Fenced;
-- not edited. It may appear as a cloning destination. Recorded, not solved.
--
-- Interior dressing (~140 .ilf nodes) will not appear: Core3's
-- InteriorLayoutTemplate parser is unused. The room loads as empty geometry.
--
-- Kick radial: replaced with an ENTEREDAREA active area (OURS, NOT SOURCED).
-- Flag for Aaron -- the kick is a charming beat and losing it is a real loss,
-- but a radial on a dynamically spawned mob is not a shape Lev ever used.
--
-- Alarm CONDITION_ON visual: skipped. setConditionBitmask is not bound in
-- SD3 Lua (no hits under screenplays/ or src Lua bindings). Not substituted.
--
-- Mouse blink appearance/pt_ig88_mouse_droid_blink.prt: dropped. The .prt is
-- not referenced anywhere in this tree and was not verified to ship; spec 1.5
-- says drop it rather than substitute a different effect.
--
-- Barks: Lev-style spatialChat, one line per SOE shout beat (H(ig-b)).

local ObjectManager = require("managers.object.object_manager")

ig88 = ScreenPlay:new {
	

}

registerScreenPlay("ig88", true)

function ig88:start()
	if (isZoneEnabled("lok")) then
    self:spawnArena()                       -- PART 6. Lev has no equivalent; his building is placed.
    writeData("ig88:occupiedState", 0)
    writeData("ig88:encounterState", 0)     -- 0 idle, 1 running, 2 defeated
    writeData("ig88:bossSpawnState", 0)
    writeData("ig88:mouseStarterState", 0)
    writeData("ig88:alarmState", 0)
    writeData("ig88:bombWave", 0)
    writeData("ig88:droidekasAlive", 0)
    writeData("ig88:superDroidsAlive", 0)
    writeData("ig88:normalDroidekasAlive", 0)
    writeData("ig88:failureCount", 0)
    writeData("ig88:lastFailureTime", 0)
    -- All eleven keys OURS, NOT SOURCED in their naming; the state machine they encode is SOE's.
    writeData("ig88:bossFightState", 0)     -- OURS, NOT SOURCED. Lev's HP-threshold counter.
    self:destroyArenaContents()
    self:spawnPhaseZero()
	end
end

-- OURS, NOT SOURCED -- the position. Lev never needed this: stardust_03.tre's yavin4.ws and
-- dathomir.ws place his tomb and lair, so exarKun.lua:842 and axkvaMin.lua:957 just call
-- getSceneObject on a snapshot id. No snapshot the live server loads places
-- ig88_factory_arena (checked: lok.ws from stardust_s.tre, dungeon1.ws from
-- mtg_patch_013_configurable_02.tre, dungeon2.ws from stardust_03.tre -- 0 hits in all
-- three), so the arena is created here instead.
--
-- spawnSceneObject builds the cells: DirectorManager.cpp:3105-3110 calls
-- createCellObjects() for any building object. The arena's portal layout
-- (appearance/heroic_ig_88_dungeon.pob, named by shared_ig88_factory_arena.iff in
-- mtg_patch_019.tre) has exactly two cells -- "r0" exterior and "r1" interior -- so
-- getTotalCellNumber() == 1 and getNamedCell("r1") is the room every spawn row uses.
--
-- Position is off-map, following SOE's own convention for this building: its 12 placements
-- in mtg_patch_023.tre's dungeon2.ws sit at x = -6000, well outside play. Lok is chosen
-- because it is the instance's own planet (instance_datatable exit "416,0,5268,lok") and is
-- in ZonesEnabled (conf/config.lua:102); dungeon2 is NOT enabled.
function ig88:spawnArena()
  local existing = getSceneObject(readData("ig88:arenaID"))
  if (existing ~= nil) then
    return
  end
  local pArena = spawnSceneObject("lok", "object/building/heroic/ig88_factory_arena.iff",
                                  -6000, 0, 6000, 0, math.rad(0))
  if (pArena == nil) then
    printLuaError("ig88: unable to spawn the factory arena.")
    return
  end
  writeData("ig88:arenaID", SceneObject(pArena):getObjectID())
end


function ig88:activate(pPlayer)
	if (not isZoneEnabled("lok")) then
		CreatureObject(pPlayer):sendSystemMessage("That area is currently unavailable. Please try again later.") 
		return false
	end
	
	if (readData("ig88:occupiedState") == 1) then
	   CreatureObject(pPlayer):sendSystemMessage("That instance is currently occupied, please try a different instance.")
	   return false
	end   
	   
  
  local pArena = self:getBuildingObject()
  if (pArena == nil) then
    CreatureObject(pPlayer):sendSystemMessage("That area is currently unavailable. Please try again later.")
    return false
  end
  
  writeData("ig88StartTime", os.time()) 
  
  -- 60 minutes: Lev's string (exarKun.lua:42) AND independently correct for IG-88 --
  -- instance_datatable.tab row heroic_ig88 leaves time_limit blank, column default i[3600].
  CreatureObject(pPlayer):sendSystemMessage("Instance Started: You have 60 minutes remaining to complete the instance.") 
  createEvent(1000, "ig88", "transportPlayer", pPlayer, "")
     
  createObserver(EXITEDBUILDING, "ig88", "resetInstanceA", pArena, "")
  
	if (CreatureObject(pPlayer):isGrouped()) then
		local groupSize = CreatureObject(pPlayer):getGroupSize()

		for i = 0, groupSize - 1, 1 do
			local pMember = CreatureObject(pPlayer):getGroupMember(i)
			if pMember ~= nil and pMember ~= pPlayer and CreatureObject(pPlayer):isInRangeWithObject(pMember, 50) and not SceneObject(pMember):isAiAgent() then
				self:sendAuthorizationSui(pMember, pPlayer)
			end
		end
	end
	
	writeData("ig88:occupiedState", 1)  -- TO DO: Need to create the timer and conditions to reset the state of the instance.
	createEvent(1000, "ig88", "checkIfActiveForTimer", pPlayer, "")

	return true
end



function ig88:sendAuthorizationSui(pPlayer, pLeader)
	if (pPlayer == nil) then
		return
	end	

	local sui = SuiMessageBox.new("ig88", "authorizationSuiCallback")
    
	-- SOURCED (SOE, instance.stf:heroic_ig88) = "Heroic: IG-88" (mtg_patch_019.tre).
	sui.setTitle("Heroic: IG-88")
	-- OURS, NOT SOURCED -- Lev's prompt with the place name swapped.
	sui.setPrompt(CreatureObject(pLeader):getFirstName() .. " has granted you authorization to travel to the IG-88 Factory.  Do you accept this travel offer?")
	sui.setOkButtonText("Yes")
	sui.setCancelButtonText("No")

	local pageId = sui.sendTo(pPlayer)

	createEvent(30 * 1000, "ig88", "closeAuthorizationSui", pPlayer, pageId)
	
end


function ig88:authorizationSuiCallback(pPlayer, pSui, eventIndex, args, ...)
  local cancelPressed = (eventIndex == 1)
  local args = {...}
 
  if (cancelPressed) then
    CreatureObject(pPlayer):sendSystemMessage("You decline to enter the instance.")   
    return 
  elseif (eventIndex == 0) then -- Teleport 
	 createEvent(1000, "ig88", "transportPlayer", pPlayer, "")
	end 
end


function ig88:closeAuthorizationSui(pPlayer, pageId)
	
	local pGhost = CreatureObject(pPlayer):getPlayerObject()

	if (pGhost == nil) then
		return
	end

	PlayerObject(pGhost):removeSuiBox(pageId)

end




function ig88:transportPlayer(pPlayer)
	if pPlayer == nil then
		return
	end
	
  if (CreatureObject(pPlayer):isRidingMount()) then
    CreatureObject(pPlayer):sendSystemMessage("You fail to enter the instance because you are riding a mount.")  
    return 0
  else
     -- SOURCED (SOE, instance_datatable.tab row heroic_ig88 enter_one = "0,0,43,r1")
     local cellID = self:getR1CellID()
     if (cellID == 0) then
       return
     end
     SceneObject(pPlayer):switchZone("lok", 0, 0, 43, cellID)
  end
end



function ig88:handleTimer(pPlayer)  
  local startTime = readData("ig88StartTime")
  local timeLeftSecs = 3600 - (os.time() - startTime)
  local timeLeft = math.floor(timeLeftSecs / 60)
  
  if (timeLeft > 10) then    
    CreatureObject(pPlayer):sendSystemMessage("@dungeon/corvette:timer_" .. timeLeft)
    createEvent(5 * 60 * 1000, "ig88", "checkIfActiveForTimer", pPlayer, "")   
  elseif (timeLeft >= 3) then
    CreatureObject(pPlayer):sendSystemMessage("@dungeon/corvette:timer_" .. timeLeft)
    createEvent(60 * 1000, "ig88", "checkIfActiveForTimer", pPlayer, "")
  elseif (timeLeft >= 2) then
    CreatureObject(pPlayer):sendSystemMessage("@dungeon/corvette:timer_" .. timeLeft)
    createEvent(30 * 1000, "ig88", "checkIfActiveForTimer", pPlayer, "")
  elseif (timeLeftSecs >= 90) then
    CreatureObject(pPlayer):sendSystemMessage("@dungeon/corvette:timer_" .. timeLeft)
    createEvent(30 * 1000, "ig88", "checkIfActiveForTimer", pPlayer, "")
  elseif (timeLeftSecs >= 60) then
    CreatureObject(pPlayer):sendSystemMessage("@dungeon/corvette:timer_" .. timeLeft)
    createEvent(30 * 1000, "ig88", "checkIfActiveForTimer", pPlayer, "")
  elseif (timeLeftSecs >= 30) then
    CreatureObject(pPlayer):sendSystemMessage("@dungeon/corvette:timer_" .. timeLeft)
    createEvent(20 * 1000, "ig88", "checkIfActiveForTimer", pPlayer, "")
  elseif (timeLeftSecs >= 10) then
    CreatureObject(pPlayer):sendSystemMessage("@dungeon/corvette:timer_" .. timeLeft)
    createEvent(10 * 1000, "ig88", "checkIfActiveForTimer", pPlayer, "")
  else
    self:checkIfActive(pPlayer)   
  end
end

function ig88:checkIfActiveForTimer(pPlayer)
  if (readData("ig88:occupiedState") == 1) then
    createEvent(1, "ig88", "handleTimer", pPlayer, "")
  else
    --self:ejectAllGroupMembers(pPlayer)
    self:resetInstance(pPlayer)    
  end      
end

function ig88:getBuildingObject()
  return getSceneObject(readData("ig88:arenaID"))
end

function ig88:getCell(cellName)
  local pArena = self:getBuildingObject()
  
  if (pArena == nil) then
    printLuaError("ig88: unable to get building object.")
    return nil
  end
  
  return BuildingObject(pArena):getNamedCell(cellName)  
end

function ig88:getR1CellID()
  local pCell = self:getCell("r1")
  if (pCell == nil) then
    return 0
  end
  return SceneObject(pCell):getObjectID()
end

-- OURS, NOT SOURCED (the loop). Predicate is SOE trial.getNonStealthedTargetsInCell
-- minus the stealth clause (SD3 has no hasInvisibleBuff binding).
function ig88:getLivePlayersInArena()
  local live = {}
  local pCell = self:getCell("r1")
  if (pCell == nil) then
    return live
  end
  for j = 1, SceneObject(pCell):getContainerObjectsSize() do
    local pObject = SceneObject(pCell):getContainerObject(j - 1)
    if (pObject ~= nil and SceneObject(pObject):isPlayerCreature()) then
      if (not CreatureObject(pObject):isIncapacitated() and not CreatureObject(pObject):isDead()) then
        live[#live + 1] = pObject
      end
    end
  end
  return live
end

-- Idiom taken from mustafar_instances.lua:684-706. With one cell this is identical
-- to getLivePlayersInArena without the alive filter.
function ig88:getPlayersInArena()
  local players = {}
  local pArena = self:getBuildingObject()
  if (pArena == nil) then
    return players
  end
  for i = 1, BuildingObject(pArena):getTotalCellNumber() do
    local pCell = BuildingObject(pArena):getCell(i)
    if (pCell ~= nil) then
      for j = 1, SceneObject(pCell):getContainerObjectsSize() do
        local pObject = SceneObject(pCell):getContainerObject(j - 1)
        if (pObject ~= nil and SceneObject(pObject):isPlayerCreature()) then
          players[#players + 1] = pObject
        end
      end
    end
  end
  return players
end

function ig88:spawnMobileInR1(templateName, x, z, y, heading)
  local cellID = self:getR1CellID()
  if (cellID == 0) then
    return nil
  end
  return spawnMobile("lok", templateName, 0, x, z, y, heading, cellID)
end

function ig88:pickLivePlayer()
  local live = self:getLivePlayersInArena()
  if (#live <= 0) then
    return nil
  end
  return live[getRandomNumber(1, #live)]
end

function ig88:destroyArenaContents()
  local pCell = self:getCell("r1")
  if (pCell == nil) then
    return
  end
  local toDestroy = {}
  for j = 1, SceneObject(pCell):getContainerObjectsSize() do
    local pObject = SceneObject(pCell):getContainerObject(j - 1)
    if (pObject ~= nil and not SceneObject(pObject):isPlayerCreature()) then
      toDestroy[#toDestroy + 1] = pObject
    end
  end
  for i = 1, #toDestroy do
    SceneObject(toDestroy[i]):destroyObjectFromWorld()
  end
end

function ig88:clearEncounterKeys()
  writeData("ig88:encounterState", 0)
  writeData("ig88:bossSpawnState", 0)
  writeData("ig88:mouseStarterState", 0)
  writeData("ig88:alarmState", 0)
  writeData("ig88:bombWave", 0)
  writeData("ig88:droidekasAlive", 0)
  writeData("ig88:superDroidsAlive", 0)
  writeData("ig88:normalDroidekasAlive", 0)
  writeData("ig88:failureCount", 0)
  writeData("ig88:lastFailureTime", 0)
  writeData("ig88:bossFightState", 0)
  writeData("ig88:bombSeq", 0)
  writeData("ig88:chargedSeq", 0)
end

-- Phase 0 + the starter mouse (phase 1 spawn). On start() and after reset, not on entry.
-- Alarm positions SOURCED (SOE, heroic_ig88.tab:3-8). Mouse SOURCED (SOE, heroic_ig88.tab:11).
function ig88:spawnPhaseZero()
  local cellID = self:getR1CellID()
  if (cellID == 0) then
    return
  end

  local alarmSpots = {
    {2, 1, -22}, {-2, 1, -22}, {21, 0, -22}, {-21, 0, -22}, {21, 0, 43}, {-21, 0, 43}
  }
  for i = 1, #alarmSpots do
    spawnSceneObject("lok", "object/tangible/ship/interior_components/alarm_interior.iff", alarmSpots[i][1], alarmSpots[i][2], alarmSpots[i][3], cellID, math.rad(0))
  end
  -- Alarm-on visual skipped: setConditionBitmask is not bound. SOE ig88_alarm.java:11-19 is setCondition(CONDITION_ON).

  local pMouse = self:spawnMobileInR1("heroic_ig88_mouse_droid", 0, 0, 10, 180)
  if (pMouse ~= nil) then
    TangibleObject(pMouse):setOptionBit(INVULNERABLE)
    -- Blink dropped: appearance/pt_ig88_mouse_droid_blink.prt was not verified to ship.
    writeData("ig88:starterMouseID", SceneObject(pMouse):getObjectID())
  end

  -- OURS, NOT SOURCED -- ENTEREDAREA replaces SOE's kick radial (ig88_mouse_droid_coward.java:49-86).
  -- Flag for Aaron: the kick is a charming beat; a radial on a dynamically spawned mob is not Lev's shape.
  local pActiveArea = spawnSceneObject("lok", "object/active_area.iff", 0, 0, 10, cellID, 0)
  if (pActiveArea ~= nil) then
    local activeArea = LuaActiveArea(pActiveArea)
    activeArea:setCellObjectID(cellID)
    activeArea:setRadius(8)
    createObserver(ENTEREDAREA, "ig88", "notifyStarterMouseArea", pActiveArea)
    writeData("ig88:starterAreaID", SceneObject(pActiveArea):getObjectID())
  end

  writeData("ig88:mouseStarterState", 0)
  writeData("ig88:alarmState", 0)
end

function ig88:notifyStarterMouseArea(pActiveArea, pMovingObject)
  if (not SceneObject(pMovingObject):isCreatureObject()) then
    return 0
  end
  if (SceneObject(pMovingObject):isAiAgent()) then
    return 0
  end
  if (not SceneObject(pMovingObject):isPlayerCreature()) then
    return 0
  end
  if (readData("ig88:mouseStarterState") == 1) then
    return 0
  end
  if (readData("ig88:occupiedState") ~= 1) then
    return 0
  end

  writeData("ig88:mouseStarterState", 1)

  local pMouse = getSceneObject(readData("ig88:starterMouseID"))
  if (pMouse ~= nil) then
    local cellID = self:getR1CellID()
    -- SOURCED (SOE, heroic_ig88.tab:9) pathPoint mouse_destination (0,0,-22)
    AiAgent(pMouse):setNextPosition(0, 0, -22, cellID)
    spatialChat(pMouse, "Intruders! Raise the alarm!")  -- OURS, NOT SOURCED (Lev-style bark; beat from ig88.java ig88_defeat)
  end

  createEvent(5 * 1000, "ig88", "startEncounter", pMovingObject, "")
  return 0
end

function ig88:startEncounter(pPlayer)
  if (pPlayer == nil) then
    return
  end
  if (readData("ig88:encounterState") == 1 or readData("ig88:encounterState") == 2) then
    return
  end

  writeData("ig88:encounterState", 1)

  local pMouse = getSceneObject(readData("ig88:starterMouseID"))
  if (pMouse ~= nil) then
    SceneObject(pMouse):destroyObjectFromWorld()
  end

  -- SOURCED (SOE, heroic_ig88.tab:19-20). IG-88 at (0,0,-22) heading 0, invulnerable; alarms deleted same tick.
  if (readData("ig88:bossSpawnState") ~= 1) then
    local pBoss = self:spawnMobileInR1("heroic_ig88_ig88_rocket", 0, 0, -22, 0)
    if (pBoss ~= nil) then
      TangibleObject(pBoss):setOptionBit(INVULNERABLE)
      writeData("ig88:bossID", SceneObject(pBoss):getObjectID())
      writeData("ig88:bossSpawnState", 1)
      writeData("ig88:bossFightState", 0)
    end
  end

  self:deleteAlarms()

  -- Timing ladder off message_start_encounter. delayAction seconds * 1000.
  createEvent(10 * 1000, "ig88", "ig88Waypoint1", pPlayer, "")
  createEvent(11 * 1000, "ig88", "barkRegret", pPlayer, "")

  -- Bomb-droid ladder SOURCED (SOE, heroic_ig88.tab:22,30-59). t+61 and t+70 appear twice -- SOE duplicates, transcribed both.
  createEvent(22 * 1000, "ig88", "barkBombDroids", pPlayer, "")
  createEvent(22 * 1000, "ig88", "spawnBombWave", pPlayer, "")
  createEvent(23 * 1000, "ig88", "chargeBombDroids", pPlayer, "")
  createEvent(27 * 1000, "ig88", "spawnBombWave", pPlayer, "")
  createEvent(28 * 1000, "ig88", "chargeBombDroids", pPlayer, "")
  createEvent(32 * 1000, "ig88", "spawnBombWave", pPlayer, "")
  createEvent(33 * 1000, "ig88", "chargeBombDroids", pPlayer, "")
  createEvent(38 * 1000, "ig88", "barkBombIntermission", pPlayer, "")
  createEvent(42 * 1000, "ig88", "spawnBombWave", pPlayer, "")
  createEvent(43 * 1000, "ig88", "chargeBombDroids", pPlayer, "")
  createEvent(46 * 1000, "ig88", "spawnBombWave", pPlayer, "")
  createEvent(47 * 1000, "ig88", "chargeBombDroids", pPlayer, "")
  createEvent(50 * 1000, "ig88", "spawnBombWave", pPlayer, "")
  createEvent(51 * 1000, "ig88", "chargeBombDroids", pPlayer, "")
  createEvent(55 * 1000, "ig88", "barkBombIntermission", pPlayer, "")
  createEvent(55 * 1000, "ig88", "spawnBombWave", pPlayer, "")
  createEvent(56 * 1000, "ig88", "chargeBombDroids", pPlayer, "")
  createEvent(58 * 1000, "ig88", "spawnBombWave", pPlayer, "")
  createEvent(59 * 1000, "ig88", "chargeBombDroids", pPlayer, "")
  createEvent(61 * 1000, "ig88", "spawnBombWave", pPlayer, "")
  createEvent(61 * 1000, "ig88", "spawnBombWave", pPlayer, "")
  createEvent(62 * 1000, "ig88", "chargeBombDroids", pPlayer, "")
  createEvent(66 * 1000, "ig88", "barkBombIntermission", pPlayer, "")
  createEvent(66 * 1000, "ig88", "spawnBombWave", pPlayer, "")
  createEvent(67 * 1000, "ig88", "chargeBombDroids", pPlayer, "")
  createEvent(68 * 1000, "ig88", "spawnBombWave", pPlayer, "")
  createEvent(69 * 1000, "ig88", "chargeBombDroids", pPlayer, "")
  createEvent(70 * 1000, "ig88", "spawnBombWave", pPlayer, "")
  createEvent(70 * 1000, "ig88", "spawnBombWave", pPlayer, "")
  createEvent(71 * 1000, "ig88", "chargeBombDroids", pPlayer, "")

  -- Phase 4 droidekas. SOURCED (SOE, heroic_ig88.tab:60-69).
  createEvent(80 * 1000, "ig88", "spawnDroidekas", pPlayer, "")
  createEvent(81 * 1000, "ig88", "chargeDroidekas", pPlayer, "")

  createEvent(5 * 1000, "ig88", "failureCheck", pPlayer, "")
end

function ig88:deleteAlarms()
  local pCell = self:getCell("r1")
  if (pCell == nil) then
    return
  end
  local toDestroy = {}
  for j = 1, SceneObject(pCell):getContainerObjectsSize() do
    local pObject = SceneObject(pCell):getContainerObject(j - 1)
    if (pObject ~= nil) then
      local path = SceneObject(pObject):getTemplateObjectPath()
      if (path == "object/tangible/ship/interior_components/alarm_interior.iff") then
        toDestroy[#toDestroy + 1] = pObject
      end
    end
  end
  for i = 1, #toDestroy do
    SceneObject(toDestroy[i]):destroyObjectFromWorld()
  end
  writeData("ig88:alarmState", 1)
end

function ig88:barkRegret(pPlayer)
  local pBoss = getSceneObject(readData("ig88:bossID"))
  if (pBoss == nil) then
    return
  end
  spatialChat(pBoss, "You should not have come here.")  -- OURS, NOT SOURCED (Lev-style bark; beat from ig88.java ig88_regret)
  createEvent(4 * 1000, "ig88", "barkRegretLater", pPlayer, "")
end

function ig88:barkRegretLater(pPlayer)
  if (readData("ig88:encounterState") ~= 1) then
    return
  end
  local pBoss = getSceneObject(readData("ig88:bossID"))
  if (pBoss == nil) then
    return
  end
  spatialChat(pBoss, "Did you think I would not be ready for you?")  -- OURS, NOT SOURCED (Lev-style bark; beat from ig88.java ig88_regret)
end

function ig88:barkBombDroids(pPlayer)
  local pBoss = getSceneObject(readData("ig88:bossID"))
  if (pBoss == nil) then
    return
  end
  spatialChat(pBoss, "Bomb droids, destroy them.")  -- OURS, NOT SOURCED (Lev-style bark; beat from ig88.java ig88_bomb_droids)
end

function ig88:barkBombIntermission(pPlayer)
  local pBoss = getSceneObject(readData("ig88:bossID"))
  if (pBoss == nil) then
    return
  end
  spatialChat(pBoss, "Is that all? I am just getting started.")  -- OURS, NOT SOURCED (Lev-style bark; beat from ig88.java ig88_bomb_intermission)
end

function ig88:ig88Waypoint1(pPlayer)
  -- SOURCED (SOE, ig88.java:65-77) walk +8 on z. Spawned at loc_z -22 -> Core3 y -14.
  local pBoss = getSceneObject(readData("ig88:bossID"))
  if (pBoss == nil) then
    return
  end
  spatialChat(pBoss, "So. You found me. That was a mistake.")  -- OURS, NOT SOURCED (Lev-style bark; beat from ig88.java start_ig88_taunt)
  local cellID = self:getR1CellID()
  AiAgent(pBoss):setNextPosition(0, 0, -14, cellID)
end

-- Bomb corners SOURCED (SOE, heroic_ig88.tab:23-26).
function ig88:spawnBombWave(pPlayer)
  if (readData("ig88:encounterState") ~= 1) then
    return
  end
  local spots = {
    {20, 0, -22}, {-20, 0, -22}, {20, 0, 43}, {-20, 0, 43}
  }
  local seq = readData("ig88:bombSeq")
  for i = 1, #spots do
    local pBomb = self:spawnMobileInR1("heroic_ig88_bomb_droid", spots[i][1], spots[i][2], spots[i][3], 0)
    if (pBomb ~= nil) then
      TangibleObject(pBomb):setOptionBit(INVULNERABLE)
      seq = seq + 1
      writeData("ig88:bombID" .. seq, SceneObject(pBomb):getObjectID())
      writeData("ig88:bombCharged" .. seq, 0)
    end
  end
  writeData("ig88:bombSeq", seq)
  writeData("ig88:bombWave", readData("ig88:bombWave") + 1)
end

function ig88:chargeBombDroids(pPlayer)
  if (readData("ig88:encounterState") ~= 1) then
    return
  end
  local seq = readData("ig88:bombSeq")
  for i = 1, seq do
    if (readData("ig88:bombCharged" .. i) ~= 1) then
      local pBomb = getSceneObject(readData("ig88:bombID" .. i))
      if (pBomb ~= nil and not CreatureObject(pBomb):isDead()) then
        TangibleObject(pBomb):clearOptionBit(INVULNERABLE)
        local pTarget = self:pickLivePlayer()
        if (pTarget ~= nil) then
          CreatureObject(pBomb):engageCombat(pTarget)
        end
        writeData("ig88:bombCharged" .. i, 1)
        createEvent(1000, "ig88", "bombDroidTick", pBomb, "")
      end
    end
  end
end

function ig88:bombDroidTick(pBomb)
  if (pBomb == nil) then
    return
  end
  if (CreatureObject(pBomb):isDead()) then
    return
  end
  if (readData("ig88:encounterState") ~= 1) then
    return
  end
  local live = self:getLivePlayersInArena()
  for i = 1, #live do
    if (SceneObject(pBomb):getDistanceTo(live[i]) <= 5) then
      CreatureObject(pBomb):playEffect("clienteffect/ig88_bomb_droid_explode.cef", "")
      SceneObject(pBomb):destroyObjectFromWorld()
      return
    end
  end
  createEvent(1000, "ig88", "bombDroidTick", pBomb, "")
end

-- Droideka corners SOURCED (SOE, heroic_ig88.tab:66-69).
function ig88:spawnDroidekas(pPlayer)
  if (readData("ig88:encounterState") ~= 1) then
    return
  end
  local pBoss = getSceneObject(readData("ig88:bossID"))
  if (pBoss ~= nil) then
    spatialChat(pBoss, "Droidekas, wipe them out.")  -- OURS, NOT SOURCED (Lev-style bark; beat from ig88.java ig88_droidekas)
  end
  local spots = {
    {20, 0, -22}, {-20, 0, 43}, {-20, 0, -22}, {20, 0, 43}
  }
  writeData("ig88:droidekasAlive", 4)
  for i = 1, #spots do
    local pDeka = self:spawnMobileInR1("heroic_ig88_droideka", spots[i][1], spots[i][2], spots[i][3], 0)
    if (pDeka ~= nil) then
      writeData("ig88:droidekaID" .. i, SceneObject(pDeka):getObjectID())
      createObserver(OBJECTDESTRUCTION, "ig88", "droidekaKilled", pDeka)
    end
  end
end

function ig88:chargeDroidekas(pPlayer)
  if (readData("ig88:encounterState") ~= 1) then
    return
  end
  for i = 1, 4 do
    local pDeka = getSceneObject(readData("ig88:droidekaID" .. i))
    if (pDeka ~= nil and not CreatureObject(pDeka):isDead()) then
      local pTarget = self:pickLivePlayer()
      if (pTarget ~= nil) then
        CreatureObject(pDeka):engageCombat(pTarget)
      end
    end
  end
end

function ig88:droidekaKilled(pDeka, pPlayer)
  local left = readData("ig88:droidekasAlive") - 1
  if (left < 0) then
    left = 0
  end
  writeData("ig88:droidekasAlive", left)
  if (left == 0 and readData("ig88:encounterState") == 1) then
    -- waitForComplete on all four -> message_ig88_droidekas_defeated. Counter is OURS, NOT SOURCED.
    createEvent(1000, "ig88", "spawnSuperDroidsAndMice", pPlayer, "")
    createEvent(2000, "ig88", "chargeSuperDroids", pPlayer, "")
  end
  return 0
end

-- Super droids + patrol mice. SOURCED (SOE, heroic_ig88.tab:78-81).
function ig88:spawnSuperDroidsAndMice(pPlayer)
  if (readData("ig88:encounterState") ~= 1) then
    return
  end
  local pBoss = getSceneObject(readData("ig88:bossID"))
  if (pBoss ~= nil) then
    spatialChat(pBoss, "Super battle droids, kill them all.")  -- OURS, NOT SOURCED (Lev-style bark; beat from ig88.java ig88_super_droids)
  end
  writeData("ig88:superDroidsAlive", 2)

  local pSuper1 = self:spawnMobileInR1("heroic_ig88_super_battle_droid", 20, 0, -22, 0)
  local pSuper2 = self:spawnMobileInR1("heroic_ig88_super_battle_droid", -20, 0, -22, 0)
  if (pSuper1 ~= nil) then
    TangibleObject(pSuper1):setOptionBit(INVULNERABLE)
    writeData("ig88:super1ID", SceneObject(pSuper1):getObjectID())
    createObserver(OBJECTDESTRUCTION, "ig88", "superDroidKilled", pSuper1)
    createObserver(DAMAGERECEIVED, "ig88", "superDroidDamage", pSuper1)
  end
  if (pSuper2 ~= nil) then
    TangibleObject(pSuper2):setOptionBit(INVULNERABLE)
    writeData("ig88:super2ID", SceneObject(pSuper2):getObjectID())
    createObserver(OBJECTDESTRUCTION, "ig88", "superDroidKilled", pSuper2)
    createObserver(DAMAGERECEIVED, "ig88", "superDroidDamage", pSuper2)
  end

  local pMouse1 = self:spawnMobileInR1("heroic_ig88_mouse_droid", 1, 0, -41, 0)
  local pMouse2 = self:spawnMobileInR1("heroic_ig88_mouse_droid", 1, 0, 41, 0)
  if (pMouse1 ~= nil) then
    writeData("ig88:mouseDroid1ID", SceneObject(pMouse1):getObjectID())
    writeData(SceneObject(pMouse1):getObjectID() .. ":ig88Patrol", 0)
    writeData(SceneObject(pMouse1):getObjectID() .. ":ig88Dir", 1)
    createEvent(1000, "ig88", "mousePatrolStep", pMouse1, "")
  end
  if (pMouse2 ~= nil) then
    writeData("ig88:mouseDroid2ID", SceneObject(pMouse2):getObjectID())
    writeData(SceneObject(pMouse2):getObjectID() .. ":ig88Patrol", 0)
    writeData(SceneObject(pMouse2):getObjectID() .. ":ig88Dir", -1)
    createEvent(1000, "ig88", "mousePatrolStep", pMouse2, "")
  end

  -- Path to (5,0,10) / (-5,0,10) then stop. SOURCED (SOE, ig88_super_battle_droid.java:57-76).
  local cellID = self:getR1CellID()
  if (pSuper1 ~= nil) then
    AiAgent(pSuper1):setNextPosition(5, 0, 10, cellID)
  end
  if (pSuper2 ~= nil) then
    AiAgent(pSuper2):setNextPosition(-5, 0, 10, cellID)
  end
end

function ig88:chargeSuperDroids(pPlayer)
  if (readData("ig88:encounterState") ~= 1) then
    return
  end
  local pSuper1 = getSceneObject(readData("ig88:super1ID"))
  local pSuper2 = getSceneObject(readData("ig88:super2ID"))
  local pMouse1 = getSceneObject(readData("ig88:mouseDroid1ID"))
  local pMouse2 = getSceneObject(readData("ig88:mouseDroid2ID"))
  if (pSuper1 ~= nil) then
    TangibleObject(pSuper1):clearOptionBit(INVULNERABLE)
    if (pMouse1 ~= nil) then
      CreatureObject(pSuper1):engageCombat(pMouse1)
    elseif (pMouse2 ~= nil) then
      CreatureObject(pSuper1):engageCombat(pMouse2)
    end
  end
  if (pSuper2 ~= nil) then
    TangibleObject(pSuper2):clearOptionBit(INVULNERABLE)
    if (pMouse2 ~= nil) then
      CreatureObject(pSuper2):engageCombat(pMouse2)
    elseif (pMouse1 ~= nil) then
      CreatureObject(pSuper2):engageCombat(pMouse1)
    end
  end
end

-- SOURCED (SOE, ig88_mouse_droid.java:25-61). Four waypoints, one clockwise and one counter-clockwise.
-- OURS, NOT SOURCED for the createEvent chain.
function ig88:mousePatrolStep(pMouse)
  if (pMouse == nil or CreatureObject(pMouse):isDead()) then
    return
  end
  if (readData("ig88:encounterState") ~= 1) then
    return
  end
  local waypoints = {
    {20, 0, 30}, {20, 0, -10}, {-20, 0, -10}, {-20, 0, 30}
  }
  local oid = SceneObject(pMouse):getObjectID()
  local step = readData(oid .. ":ig88Patrol")
  local dir = readData(oid .. ":ig88Dir")
  if (dir == 0) then
    dir = 1
  end
  step = step + dir
  if (step > 4) then
    step = 1
  elseif (step < 1) then
    step = 4
  end
  writeData(oid .. ":ig88Patrol", step)
  local cellID = self:getR1CellID()
  AiAgent(pMouse):setNextPosition(waypoints[step][1], waypoints[step][2], waypoints[step][3], cellID)
  createEvent(8 * 1000, "ig88", "mousePatrolStep", pMouse, "")
end

function ig88:superDroidDamage(pSuper, pPlayer)
  if (pSuper == nil) then
    return 0
  end
  local boss = LuaCreatureObject(pSuper)
  if (boss == nil) then
    return 0
  end
  -- SOURCED (SOE, ig88_super_battle_droid.java:105-109): ACTION below 10% destroys both mice.
  if (boss:getHAM(3) <= (boss:getMaxHAM(3) * 0.1)) then
    self:destroyPatrolMice()
  end
  return 0
end

function ig88:destroyPatrolMice()
  local pMouse1 = getSceneObject(readData("ig88:mouseDroid1ID"))
  local pMouse2 = getSceneObject(readData("ig88:mouseDroid2ID"))
  if (pMouse1 ~= nil) then
    SceneObject(pMouse1):destroyObjectFromWorld()
  end
  if (pMouse2 ~= nil) then
    SceneObject(pMouse2):destroyObjectFromWorld()
  end
  writeData("ig88:mouseDroid1ID", 0)
  writeData("ig88:mouseDroid2ID", 0)
end

function ig88:superDroidKilled(pSuper, pPlayer)
  local left = readData("ig88:superDroidsAlive") - 1
  if (left < 0) then
    left = 0
  end
  writeData("ig88:superDroidsAlive", left)
  if (left == 0 and readData("ig88:encounterState") == 1) then
    -- waitForComplete on the two super droids -> delete both mice, shoutAssassination, charge +1 s.
    self:destroyPatrolMice()
    local pBoss = getSceneObject(readData("ig88:bossID"))
    if (pBoss ~= nil) then
      spatialChat(pBoss, "Enough. I will finish this myself.")  -- OURS, NOT SOURCED (Lev-style bark; beat from ig88.java ig88_assassination)
    end
    createEvent(1000, "ig88", "ig88Charge", pPlayer, "")
  end
  return 0
end

function ig88:ig88Charge(pPlayer)
  -- SOURCED (SOE, ig88.java:78-91) waypoint2 to (0,0,10) then findTarget.
  local pBoss = getSceneObject(readData("ig88:bossID"))
  if (pBoss == nil) then
    return
  end
  local cellID = self:getR1CellID()
  AiAgent(pBoss):setNextPosition(0, 0, 10, cellID)
  createEvent(3000, "ig88", "ig88FindTarget", pPlayer, "")
end

function ig88:ig88FindTarget(pPlayer)
  local pBoss = getSceneObject(readData("ig88:bossID"))
  if (pBoss == nil) then
    return
  end
  -- x4 HEALTH / x2 ACTION already folded into authored RAID 200 baseHAM (PART 3 header).
  TangibleObject(pBoss):clearOptionBit(INVULNERABLE)
  createObserver(OBJECTDESTRUCTION, "ig88", "ig88Killed", pBoss)
  createObserver(DAMAGERECEIVED, "ig88", "boss_damage", pBoss)
  local pTarget = self:pickLivePlayer()
  if (pTarget ~= nil) then
    CreatureObject(pBoss):engageCombat(pTarget)
  end
end

-- OURS, NOT SOURCED -- the round's largest authored decision: SOE's weapon/combo timers
-- mapped onto Lev's HP-threshold machine (exarKun.lua:614-733). Thresholds 0.99 / 0.75 /
-- 0.50 / 0.25 / 0.10 of getMaxHAM(0). Combos that have no Core3 command (ig88_rocket_launch,
-- ig88_shockwave, ig88_grenade, ig88_shield, ig88_droideka_electrify, bh_dread_strike_5)
-- become playEffect + the normal_droideka spawns SOE fires from the DROIDEKA combo.
function ig88:boss_damage(pBoss, pPlayer)
  local boss = LuaCreatureObject(pBoss)
  if (boss == nil) then
    return 0
  end
  local bossHealth = boss:getHAM(0)
  local bossAction = boss:getHAM(3)
  local bossMaxHealth = boss:getMaxHAM(0)
  local bossMaxAction = boss:getMaxHAM(3)

  -- Lev's uncapped action self-heal (exarKun.lua:238-243). Deliberate in H(ek)/H(am);
  -- same call here. The fight cannot be won on an action drain.
  if (bossAction <= (bossMaxAction * 0.3)) then
    CreatureObject(pBoss):setHAM(3, bossMaxAction)
    CreatureObject(pBoss):playEffect("clienteffect/pl_force_channel_self.cef", "")
  end

  if ((bossHealth <= (bossMaxHealth * 0.99)) and readData("ig88:bossFightState") == 0) then
    -- ELECTRICAL combo
    CreatureObject(pBoss):playEffect("clienteffect/combat_pt_electricalfield.cef", "")
    writeData("ig88:bossFightState", 1)
  end

  if ((bossHealth <= (bossMaxHealth * 0.75)) and readData("ig88:bossFightState") == 1) then
    -- GRENADE combo; spawn 4 normal_droideka
    CreatureObject(pBoss):playEffect("clienteffect/pl_storm_lord_special.cef", "")
    self:spawnNormalDroidekas(pPlayer)
    writeData("ig88:bossFightState", 2)
  end

  if ((bossHealth <= (bossMaxHealth * 0.50)) and readData("ig88:bossFightState") == 2) then
    -- DROIDEKA combo; spawn 4 more
    CreatureObject(pBoss):playEffect("clienteffect/combat_pt_electricalfield.cef", "")
    self:spawnNormalDroidekas(pPlayer)
    writeData("ig88:bossFightState", 3)
  end

  if ((bossHealth <= (bossMaxHealth * 0.25)) and readData("ig88:bossFightState") == 3) then
    -- ELECTRICAL + GRENADE together
    CreatureObject(pBoss):playEffect("clienteffect/pl_storm_lord_special.cef", "")
    CreatureObject(pBoss):playEffect("clienteffect/combat_pt_electricalfield.cef", "")
    writeData("ig88:bossFightState", 4)
  end

  if ((bossHealth <= (bossMaxHealth * 0.10)) and readData("ig88:bossFightState") == 4) then
    -- all three; last normal_droideka set
    CreatureObject(pBoss):playEffect("clienteffect/pl_storm_lord_special.cef", "")
    CreatureObject(pBoss):playEffect("clienteffect/combat_pt_electricalfield.cef", "")
    self:spawnNormalDroidekas(pPlayer)
    writeData("ig88:bossFightState", 5)
  end

  return 0
end

-- Corners SOURCED (SOE, heroic_ig88.tab:92-95).
function ig88:spawnNormalDroidekas(pPlayer)
  local spots = {
    {20, 0, -22}, {-20, 0, -22}, {20, 0, 43}, {-20, 0, 43}
  }
  writeData("ig88:normalDroidekasAlive", readData("ig88:normalDroidekasAlive") + 4)
  for i = 1, #spots do
    local pDeka = self:spawnMobileInR1("heroic_ig88_normal_droideka", spots[i][1], spots[i][2], spots[i][3], 0)
    if (pDeka ~= nil) then
      createObserver(OBJECTDESTRUCTION, "ig88", "normalDroidekaKilled", pDeka)
      local pTarget = self:pickLivePlayer()
      if (pTarget ~= nil) then
        CreatureObject(pDeka):engageCombat(pTarget)
      end
    end
  end
end

function ig88:normalDroidekaKilled(pDeka, pPlayer)
  local left = readData("ig88:normalDroidekasAlive") - 1
  if (left < 0) then
    left = 0
  end
  writeData("ig88:normalDroidekasAlive", left)
  return 0
end

function ig88:ig88Killed(pBoss, pPlayer)
  writeData("ig88:encounterState", 2)
  if (pPlayer ~= nil) then
    CreatureObject(pPlayer):sendSystemMessage("You and your group have defeated IG-88!  You will be removed from the instance in 120 seconds.")
    -- OURS, NOT SOURCED (Lev's awardBadgeToAll shape; the item is SOE's tokenIndex 2)
    createEvent(1000, "ig88", "awardTokenToAll", pPlayer, "")
    createEvent(120000, "ig88", "handleVictory", pPlayer, "")
  end
  return 0
end

function ig88:awardToken(pPlayer)
  if (pPlayer == nil) then
    return
  end
  -- Guard key is per player PER RUN (run = ig88StartTime), so a repeat victory grants again the way
  -- SOE's script does on every kill; a per-player-only key would have meant one token per server
  -- uptime. Stale keys from old runs are harmless volatile writeData. (orchestrator fix-2, H(ig-b))
  local oid = SceneObject(pPlayer):getObjectID() .. ":" .. tostring(readData("ig88StartTime"))
  if (readData("ig88:token:" .. oid) == 1) then
    return
  end
  local pInventory = SceneObject(pPlayer):getSlottedObject("inventory")
  if (pInventory ~= nil) then
    giveItem(pInventory, "object/tangible/loot/misc/ig88_token.iff", -1, true)
    writeData("ig88:token:" .. oid, 1)
  end
end

function ig88:awardTokenToAll(pPlayer)
  -- OURS, NOT SOURCED (Lev's awardBadgeToAll shape; the item is SOE's tokenIndex 2)
  createEvent(1000, "ig88", "awardToken", pPlayer, "")

  if (CreatureObject(pPlayer):isGrouped()) then
    local groupSize = CreatureObject(pPlayer):getGroupSize()

    for i = 0, groupSize - 1, 1 do
      local pMember = CreatureObject(pPlayer):getGroupMember(i)
      if pMember ~= nil and pMember ~= pPlayer and CreatureObject(pPlayer):isInRangeWithObject(pMember, 300) and not SceneObject(pMember):isAiAgent() then
        self:awardToken(pMember, pPlayer)
      end
    end
  end
end

-- SOURCED (SOE, ig88_controller.java:61-87). Polls every 5 s while anyone is alive in r1;
-- on a wipe, debounced by 1 s, shouts and restarts the encounter after 5 s.
function ig88:failureCheck(pPlayer)
  if (readData("ig88:encounterState") ~= 1) then return end
  local live = self:getLivePlayersInArena()
  if (#live > 0) then
    createEvent(5 * 1000, "ig88", "failureCheck", pPlayer, "")
    return
  end
  local now = os.time()
  if (now - readData("ig88:lastFailureTime") > 1) then
    writeData("ig88:lastFailureTime", now)
    writeData("ig88:failureCount", readData("ig88:failureCount") + 1)
    local pBoss = getSceneObject(readData("ig88:bossID"))
    if (pBoss ~= nil) then
      spatialChat(pBoss, "You have failed. As expected.")  -- OURS, NOT SOURCED (Lev-style bark; beat from ig88.java ig88_failed)
    end
    createEvent(5 * 1000, "ig88", "restartSpawn", pPlayer, "")
  end
end

-- OURS, NOT SOURCED for the key list; the behaviour is SOE's. Clears the same keys
-- resetInstance clears, then re-runs phase 0/1, without clearing occupiedState and
-- without ejecting.
function ig88:restartSpawn(pPlayer)
  if (readData("ig88:occupiedState") ~= 1) then
    return
  end
  self:clearEncounterKeys()
  self:destroyArenaContents()
  self:spawnPhaseZero()
end

function ig88:checkIfActive(pPlayer)
  if (readData("ig88:occupiedState") == 1) then
    self:ejectAllPlayers(pPlayer)
    self:resetInstance(pPlayer)
    return true
  end
end

function ig88:ejectAllPlayers(pPlayer)

  createEvent(1000, "ig88", "ejectPlayer", pPlayer, "")
  
  if (CreatureObject(pPlayer):isGrouped()) then
    local groupSize = CreatureObject(pPlayer):getGroupSize()

    for i = 0, groupSize - 1, 1 do
      local pMember = CreatureObject(pPlayer):getGroupMember(i)
      if pMember ~= nil and pMember ~= pPlayer and CreatureObject(pPlayer):isInRangeWithObject(pMember, 300) and not SceneObject(pMember):isAiAgent() then
        self:ejectPlayer(pMember, pPlayer)
      end
    end
  end
end

function ig88:ejectAllGroupMembers(pPlayer)

  if (CreatureObject(pPlayer):isGrouped()) then
    local groupSize = CreatureObject(pPlayer):getGroupSize()

    for i = 0, groupSize - 1, 1 do
      local pMember = CreatureObject(pPlayer):getGroupMember(i)
      if pMember ~= nil and pMember ~= pPlayer and not SceneObject(pMember):isAiAgent() then
        self:ejectPlayer(pMember, pPlayer)
      end
    end
  end
end

function ig88:ejectPlayer(pPlayer)
  if pPlayer == nil then
    return
  end
  
  if (SceneObject(pPlayer):getZoneName() == "lok") then
    CreatureObject(pPlayer):sendSystemMessage("You are now being removed from the instance.")
    -- SOURCED (SOE, instance_datatable.tab exit_one = "416,0,5268,lok"). Height 0 is OURS, NOT SOURCED -- SOE placeholder, correct from client (SC8 step 1).
    SceneObject(pPlayer):switchZone("lok", 416, 0, 5268, 0)
  else
    return
  end    
end



function ig88:resetInstanceA(pArena, pPlayer)
  if not SceneObject(pPlayer):isPlayerCreature() then
    return 0
  end
  writeData("ig88:occupiedState", 0)
  
  CreatureObject(pPlayer):sendSystemMessage("One or more group members have left the dungeon.")
  self:resetInstance(pPlayer)
  self:ejectAllGroupMembers(pPlayer)  
  return 0
end

function ig88:resetInstance(pPlayer)
  CreatureObject(pPlayer):sendSystemMessage("The instance has been reset.")
  writeData("ig88:occupiedState", 0)
  -- SOURCED (Lev+H(am), axkvaMin.lua:1037-1050). Lev's handleVictory cleared the
  -- spawn-state keys on a win; resetInstance -- timeout and EXITEDBUILDING --
  -- cleared only occupiedState, so after any non-victory end the instance could
  -- never be completed again until a restart. Clear every state key handleVictory
  -- clears, in both the timeout path and the EXITEDBUILDING path.
  self:clearEncounterKeys()
  self:destroyArenaContents()
  self:spawnPhaseZero()
end

function ig88:handleVictory(pPlayer) 
  self:resetInstance(pPlayer)
  self:ejectAllPlayers(pPlayer)
end
