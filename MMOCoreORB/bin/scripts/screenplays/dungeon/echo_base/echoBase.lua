-- Echo Base Instanced Dungeon: authored for Stardust 3, round EB-a.
-- Structure copied from starDestroyer.lua (which copies Levarris' exarKun.lua /
-- axkvaMin.lua). Host is dungeon1 (D1): Aaron 2026-09-04, hoth snapshot is a relic.
-- Skeleton only: start / activate / authorization SUI / transportPlayer /
-- handleTimer / reset / eject. Zero mobiles, zero phase logic, zero loot, zero barks.
-- Instance system messages ("That area is currently unavailable", "currently occupied",
-- "Instance Started", "You decline to enter", "riding a mount", "being removed",
-- "have left the dungeon", "has been reset") are classification (c): Lev's own English,
-- copied verbatim from axkvaMin.lua:29,34,43,94,1016,1031,1038 (via starDestroyer.lua) and
-- exarKun.lua:122 (the mount line). (fix-1 citations)

echoBase = ScreenPlay:new {


}

registerScreenPlay("echoBase", true)

function echoBase:start()
	if (isZoneEnabled("dungeon1")) then
    self:spawnTheShip()
    writeData("echoBase:occupiedState", 0)
	end
end

-- OURS, NOT SOURCED (the whole placement). SOE placed this building through
-- datatables/buildout/adventure2/echo_base.tab:213 at (1893.23, 32.48, 1900.09)
-- on adventure2, which this client cannot load (no adventure2.trn). Template is
-- SD3's already-registered heroic building,
-- object/custom_content/building/heroic/echo_base.lua:47 ->
-- object/building/heroic/echo_base.iff. Client shared_echo_base.iff is
-- objects.lua:163. Shape: starDestroyer:spawnTheShip() (starDestroyer.lua:45-59).
-- Guarded existing-id so a screenplay reload does not drop a second building.
-- Origin is (4000, 0, 3500), not the requested (3500, 0, 3500): snapshot/dungeon1.ws
-- corvettes reach (2700, 3600), 806 m from (3500, 3500). (4000, 3500) is the nearest
-- 500-grid origin with >= 1,200 m clearance (1,304 m from (2700, 3600)).
function echoBase:spawnTheShip()
  local existing = getSceneObject(readData("echoBase:buildingId"))
  if (existing ~= nil) then
    return
  end
  local pBuilding = spawnSceneObject("dungeon1",
          "object/building/heroic/echo_base.iff",
          4000, 0, 3500,      -- x, z(height), y
          0, math.rad(0))
  if (pBuilding ~= nil) then
    writeData("echoBase:buildingId", SceneObject(pBuilding):getObjectID())
  end
end


function echoBase:activate(pPlayer)
	if (not isZoneEnabled("dungeon1")) then
		CreatureObject(pPlayer):sendSystemMessage("That area is currently unavailable. Please try again later.")
		return false
	end

	if (readData("echoBase:occupiedState") == 1) then
	   CreatureObject(pPlayer):sendSystemMessage("That instance is currently occupied, please try a different instance.")
	   return false
	end

  -- SOURCED: datatables/instance/instance_datatable.tab row echo_base,
  -- min_players = 4 (research-heroics.md:263; only heroic with a min_players value).
  -- SOE conversation echo_base_launch_condition_tooSmallGroup is the same gate.
  if (not CreatureObject(pPlayer):isGrouped() or CreatureObject(pPlayer):getGroupSize() < 4) then
    CreatureObject(pPlayer):sendSystemMessage("You must be in a group of at least 4 to enter Echo Base.")  -- OURS, NOT SOURCED (wording; the 4 is SOE instance_datatable.tab echo_base min_players)
    return false
  end

  local pBuilding = self:getBuildingObject()
  if (pBuilding == nil) then
    CreatureObject(pPlayer):sendSystemMessage("That area is currently unavailable. Please try again later.")
    return false
  end

  writeData("echoBaseStartTime", os.time())

  -- OURS, NOT SOURCED (the 120-minute wording). SOE time_limit = 7200
  -- (instance_datatable.tab echo_base row). Lev's @dungeon/corvette:timer_N keys
  -- exist only for N <= 59, so the start line is plain English (Tusken D7).
  CreatureObject(pPlayer):sendSystemMessage("Instance Started: You have 120 minutes remaining to complete the instance.")
  createEvent(1000, "echoBase", "transportPlayer", pPlayer, "")

  createObserver(EXITEDBUILDING, "echoBase", "resetInstanceA", pBuilding, "")

	if (CreatureObject(pPlayer):isGrouped()) then
		local groupSize = CreatureObject(pPlayer):getGroupSize()

		for i = 0, groupSize - 1, 1 do
			local pMember = CreatureObject(pPlayer):getGroupMember(i)
			if pMember ~= nil and pMember ~= pPlayer and CreatureObject(pPlayer):isInRangeWithObject(pMember, 50) and not SceneObject(pMember):isAiAgent() then
				self:sendAuthorizationSui(pMember, pPlayer)
			end
		end
	end

	writeData("echoBase:occupiedState", 1)
	createEvent(1000, "echoBase", "checkIfActiveForTimer", pPlayer, "")

	return true
end



function echoBase:sendAuthorizationSui(pPlayer, pLeader)
	if (pPlayer == nil) then
		return
	end

	local sui = SuiMessageBox.new("echoBase", "authorizationSuiCallback")

	sui.setTitle("Echo Base")                                     -- OURS, NOT SOURCED
	sui.setPrompt(CreatureObject(pLeader):getFirstName() ..
	    " has granted you authorization to travel to Echo Base.  Do you accept this travel offer?")
	                                                                    -- OURS, NOT SOURCED
	sui.setOkButtonText("Yes")
	sui.setCancelButtonText("No")

	local pageId = sui.sendTo(pPlayer)

	createEvent(30 * 1000, "echoBase", "closeAuthorizationSui", pPlayer, pageId)

end


function echoBase:authorizationSuiCallback(pPlayer, pSui, eventIndex, args, ...)
  local cancelPressed = (eventIndex == 1)
  local args = {...}

  if (cancelPressed) then
    CreatureObject(pPlayer):sendSystemMessage("You decline to enter the instance.")
    return
  elseif (eventIndex == 0) then -- Teleport
	 createEvent(1000, "echoBase", "transportPlayer", pPlayer, "")
	end
end


function echoBase:closeAuthorizationSui(pPlayer, pageId)

	local pGhost = CreatureObject(pPlayer):getPlayerObject()

	if (pGhost == nil) then
		return
	end

	PlayerObject(pGhost):removeSuiBox(pageId)

end




function echoBase:transportPlayer(pPlayer)
	if pPlayer == nil then
		return
	end

  if (CreatureObject(pPlayer):isRidingMount()) then
    CreatureObject(pPlayer):sendSystemMessage("You fail to enter the instance because you are riding a mount.")
    return 0
  else
     -- SOURCED: instance_datatable.tab echo_base enter_one = "-255,73,531,r15"
     -- (research-heroics.md:263). r15 is named "Main Hangar" by setCellLabel
     -- (research-echo-base.md §3.2). enter_two = "1241,55,1509,none" is the
     -- outdoor battlefield start; EB-a lands inside the POB.
     -- Coordinate mapping SOE (x,y,z) -> Core3 (x, z, y) per BINDING B4.
     local cell = self:cellId("r15")
     if (cell == 0) then
       return
     end
     SceneObject(pPlayer):switchZone("dungeon1", -255, 73, 531, cell)
  end
end



-- OURS, NOT SOURCED (the 7200 constant and the 59-minute ladder start).
-- SOE gives this instance 7200 s (instance_datatable.tab echo_base, time_limit).
-- Lev's @dungeon/corvette:timer_N keys exist only for N <= 59; a 120-minute
-- clock would print raw @dungeon/corvette:timer_120 ... timer_60 before a
-- key that exists. Ladder messages therefore start at 59 (Tusken D7).
function echoBase:handleTimer(pPlayer)
  local startTime = readData("echoBaseStartTime")
  local timeLeftSecs = 7200 - (os.time() - startTime)
  local timeLeft = math.floor(timeLeftSecs / 60)

  if (timeLeft > 59) then
    local secsUntil59 = timeLeftSecs - (59 * 60)
    if (secsUntil59 < 1) then
      secsUntil59 = 1
    end
    createEvent(secsUntil59 * 1000, "echoBase", "checkIfActiveForTimer", pPlayer, "")
  elseif (timeLeft > 10) then
    CreatureObject(pPlayer):sendSystemMessage("@dungeon/corvette:timer_" .. timeLeft)
    createEvent(5 * 60 * 1000, "echoBase", "checkIfActiveForTimer", pPlayer, "")
  elseif (timeLeft >= 3) then
    CreatureObject(pPlayer):sendSystemMessage("@dungeon/corvette:timer_" .. timeLeft)
    createEvent(60 * 1000, "echoBase", "checkIfActiveForTimer", pPlayer, "")
  elseif (timeLeft >= 2) then
    CreatureObject(pPlayer):sendSystemMessage("@dungeon/corvette:timer_" .. timeLeft)
    createEvent(30 * 1000, "echoBase", "checkIfActiveForTimer", pPlayer, "")
  elseif (timeLeftSecs >= 90) then
    CreatureObject(pPlayer):sendSystemMessage("@dungeon/corvette:timer_" .. timeLeft)
    createEvent(30 * 1000, "echoBase", "checkIfActiveForTimer", pPlayer, "")
  elseif (timeLeftSecs >= 60) then
    CreatureObject(pPlayer):sendSystemMessage("@dungeon/corvette:timer_" .. timeLeft)
    createEvent(30 * 1000, "echoBase", "checkIfActiveForTimer", pPlayer, "")
  elseif (timeLeftSecs >= 30) then
    CreatureObject(pPlayer):sendSystemMessage("@dungeon/corvette:timer_" .. timeLeft)
    createEvent(20 * 1000, "echoBase", "checkIfActiveForTimer", pPlayer, "")
  elseif (timeLeftSecs >= 10) then
    CreatureObject(pPlayer):sendSystemMessage("@dungeon/corvette:timer_" .. timeLeft)
    createEvent(10 * 1000, "echoBase", "checkIfActiveForTimer", pPlayer, "")
  else
    self:checkIfActive(pPlayer)
  end
end

function echoBase:checkIfActiveForTimer(pPlayer)
  if (readData("echoBase:occupiedState") == 1) then
    createEvent(1, "echoBase", "handleTimer", pPlayer, "")
  else
    self:resetInstance(pPlayer)
  end
end

function echoBase:getBuildingObject()
    -- starDestroyer.lua:652-662: the building is spawned at boot with
    -- persistence 0 (DirectorManager.cpp:3100), so its id is not stable
    -- across restarts. Written by echoBase:spawnTheShip() from start().
    local id = readData("echoBase:buildingId")
    if (id == 0) then
        printLuaError("echoBase: unable to get building object.")
        return nil
    end
    return getSceneObject(id)
end

function echoBase:getCell(cellName)
  local pBuilding = self:getBuildingObject()

  if (pBuilding == nil) then
    printLuaError("unable to get building object.")
    return nil
  end

  return BuildingObject(pBuilding):getNamedCell(cellName)
end

-- OURS, NOT SOURCED (helper only; no new engine binding).
function echoBase:cellId(cellName)
    local pCell = self:getCell(cellName)
    if (pCell == nil) then
        printLuaError("echoBase: no cell named " .. tostring(cellName))
        return 0
    end
    return SceneObject(pCell):getObjectID()
end

-- OURS, NOT SOURCED (the key list). Shape taken from starDestroyer.lua:688-701.
function echoBase:clearEncounterKeys()
  writeData("echoBase:occupiedState", 0)
end

-- OURS, NOT SOURCED. Shape taken from starDestroyer.lua:706-729 /
-- ig88.lua:346-361. Empty on EB-a (zero mobiles); keeps later rounds from
-- leaking props across a reset. Active areas skipped so a future ENTEREDAREA
-- observer would survive.
function echoBase:destroyArenaContents()
  local pBuilding = self:getBuildingObject()
  if (pBuilding == nil) then
    return
  end
  for i = 1, BuildingObject(pBuilding):getTotalCellNumber() do
    local pCell = BuildingObject(pBuilding):getCell(i)
    if (pCell ~= nil) then
      local toDestroy = {}
      for j = 1, SceneObject(pCell):getContainerObjectsSize() do
        local pObject = SceneObject(pCell):getContainerObject(j - 1)
        if (pObject ~= nil and not SceneObject(pObject):isPlayerCreature()) then
          local path = SceneObject(pObject):getTemplateObjectPath()
          if (path ~= "object/active_area.iff") then
            toDestroy[#toDestroy + 1] = pObject
          end
        end
      end
      for k = 1, #toDestroy do
        SceneObject(toDestroy[k]):destroyObjectFromWorld()
      end
    end
  end
end

function echoBase:checkIfActive(pPlayer)
  if (readData("echoBase:occupiedState") == 1) then
    self:ejectAllPlayers(pPlayer)
    self:resetInstance(pPlayer)
    return true
  end
end

function echoBase:ejectAllPlayers(pPlayer)

  createEvent(1000, "echoBase", "ejectPlayer", pPlayer, "")

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

function echoBase:ejectAllGroupMembers(pPlayer)

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

function echoBase:ejectPlayer(pPlayer)
  if pPlayer == nil then
    return
  end

  if (SceneObject(pPlayer):getZoneName() == "dungeon1") then
    CreatureObject(pPlayer):sendSystemMessage("You are now being removed from the instance.")
    -- SOURCED: instance_datatable.tab echo_base exit_one = "5426,0,-4169,dathomir"
    -- (research-heroics.md:263; SOE exit = SOE entry, Aurilia).
    SceneObject(pPlayer):switchZone("dathomir", 5426, 0, -4169, 0)
  else
    return
  end
end



function echoBase:resetInstanceA(pBuilding, pPlayer)
  if not SceneObject(pPlayer):isPlayerCreature() then
    return 0
  end
  writeData("echoBase:occupiedState", 0)

  CreatureObject(pPlayer):sendSystemMessage("One or more group members have left the dungeon.")
  self:resetInstance(pPlayer)
  self:ejectAllGroupMembers(pPlayer)
  return 0
end

function echoBase:resetInstance(pPlayer)
    CreatureObject(pPlayer):sendSystemMessage("The instance has been reset.")
    writeData("echoBase:occupiedState", 0)
    self:clearEncounterKeys()
    self:destroyArenaContents()
end
