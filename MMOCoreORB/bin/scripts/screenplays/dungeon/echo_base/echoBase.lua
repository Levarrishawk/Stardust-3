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
--
-- Round EB-e adds the wampa cave (spawnWampaCave / wampaBoss_damage /
-- wampaBossKilled / leash / adds). grep -n wampa_boss over commands/ and src/
-- = 0 hits. Barks: wampa_boss.java has none; no @sequencer_spam / @theme_park/heroic
-- keys are used here. DNA item_cs_dna_wampa 5% NOT PORTED (no SD3 template).
--
-- Round EB-c adds the encounter: phase machine, both factional chains, the
-- 20-flag scoreboard, spine spawns, sourced barks, and the token / painting
-- award. Methods live in echoBasePhases.lua (included after this file).

echoBase = ScreenPlay:new {


}

registerScreenPlay("echoBase", true)

function echoBase:start()
	if (isZoneEnabled("dungeon1")) then
    self:spawnTheShip()
    writeData("echoBase:occupiedState", 0)
    writeData("echoBase:wampaSpawnState", 0)
    writeData("echoBase:wampaFightState", 0)
    writeData("echoBase:wampa_boss_dead", 0)
    writeData("echoBase:wampaAddSeq", 0)
    writeData("echoBase:wampaLeashRunning", 0)
    self:clearPhaseKeys()
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
  self:clearPhaseKeys()

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

	createEvent(100, "echoBase", "spawnWampaCaveCheck", pPlayer, "")
	createEvent(200, "echoBase", "spawnSpineCheck", pPlayer, "")

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
  writeData("echoBase:wampaSpawnState", 0)
  writeData("echoBase:wampaFightState", 0)
  writeData("echoBase:wampa_boss_dead", 0)
  writeData("echoBase:wampaAddSeq", 0)
  writeData("echoBase:wampaLeashRunning", 0)
  self:clearPhaseKeys()
end

-- OURS, NOT SOURCED. Shape taken from starDestroyer.lua:706-729 /
-- ig88.lua:346-361. Empty on EB-a (zero mobiles); keeps later rounds from
-- leaking props across a reset. Active areas skipped so a future ENTEREDAREA
-- observer would survive.
function echoBase:destroyArenaContents()
  self:destroyWampaOutdoor()
  self:destroySpineOutdoor()
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

-- EB-e: wampa cave. Indoor rows use getNamedCell on the stored building id
-- (D-EBe5). Outdoor rows are relative to the POB: world = (4000,0,3500) +
-- (loc_x, loc_y+32.48, loc_z). The +32.48 cancels SOE's adventure2 building
-- y (research-echo-base.md §0.3 / echo_base.tab:213). Coordinate mapping
-- SOE (x,y,z) -> Core3 (x, z, y) per BINDING B4.

function echoBase:spawnWampaCaveCheck()
  if (readData("echoBase:wampaSpawnState") == 1) then
    return
  end
  self:spawnWampaCave()
  writeData("echoBase:wampaSpawnState", 1)
end

function echoBase:spawnWampaInCell(templateName, cellName, locX, locY, locZ, yaw)
  local cell = self:cellId(cellName)
  if (cell == 0) then
    return nil
  end
  return spawnMobile("dungeon1", templateName, 0, locX, locY, locZ, yaw, cell)
end

function echoBase:spawnWampaOutdoor(templateName, locX, locY, locZ, yaw)
  local wx = 4000 + locX
  local wz = locY + 32.48
  local wy = 3500 + locZ
  return spawnMobile("dungeon1", templateName, 0, wx, wz, wy, yaw, 0)
end

function echoBase:spawnWampaCave()
  -- tauntaun_grounds ("The Grotto"), echo_base.tab:1102-1109. Empty yaw -> 0.
  self:spawnWampaInCell("heroic_echo_tauntaun_domesticated", "tauntaun_grounds", -163.48706, 20.477892, 161.9953, 0)
  self:spawnWampaInCell("heroic_echo_tauntaun_diseased", "tauntaun_grounds", -184.43279, 20.351288, 170.02417, 0)
  self:spawnWampaInCell("heroic_echo_tauntaun_bull", "tauntaun_grounds", -208.54852, 20.377186, 174.23012, 0)
  self:spawnWampaInCell("heroic_echo_tauntaun_feral", "tauntaun_grounds", -219.8739, 20.255919, 156.92752, 0)
  self:spawnWampaInCell("heroic_echo_tauntaun_agitator", "tauntaun_grounds", -227.60887, 20.355186, 134.38223, 0)
  self:spawnWampaInCell("heroic_echo_tauntaun_domesticated", "tauntaun_grounds", -209.11362, 20.462584, 112.63185, 0)
  self:spawnWampaInCell("heroic_echo_tauntaun_bull", "tauntaun_grounds", -194.63141, 20.710222, 116.234634, 0)
  self:spawnWampaInCell("heroic_echo_tauntaun_agitator", "tauntaun_grounds", -182.3405, 20.59968, 135.09642, 0)

  -- wampa_rm, echo_base.tab:4720.
  self:spawnWampaInCell("heroic_echo_wampa_berzerker", "wampa_rm", 10.7, -17.1, 341.3, 104)

  -- Uncle Joe, echo_base.tab:4733, blank room (outdoor), mission_critical 1.
  -- Bodyguards are the summon_wampas set (tab:4736-4738), not standing adds.
  local pBoss = self:spawnWampaOutdoor("heroic_echo_wampa_boss", -978.39, -32.48, 684.86, -146)
  if (pBoss ~= nil) then
    writeData("echoBase:wampaBossId", SceneObject(pBoss):getObjectID())
    createObserver(OBJECTDESTRUCTION, "echoBase", "wampaBossKilled", pBoss)
    createObserver(DAMAGERECEIVED, "echoBase", "wampaBoss_damage", pBoss)
    createObserver(STARTCOMBAT, "echoBase", "wampaBossEnteredCombat", pBoss)
    writeData("echoBase:wampaFightState", 0)
  end
end

-- SOE wampa_boss.java:28-42 OnEnteredCombat: getPlayerCreaturesInRange 250,
-- addHate 1000 + startCombat on each living player. Core3 has no hate API
-- (D-EBe3); approximated by engageCombat on every player in 250 m.
function echoBase:wampaBossEnteredCombat(pBoss, pPlayer)
  if (pBoss == nil or CreatureObject(pBoss):isDead()) then
    return 1
  end
  local players = SceneObject(pBoss):getPlayersInRange(250)
  if (players ~= nil) then
    for i = 1, #players do
      local pNear = players[i]
      if (pNear ~= nil and CreatureObject(pNear):isPlayerCreature() and not CreatureObject(pNear):isDead() and not CreatureObject(pNear):isIncapacitated()) then
        CreatureObject(pBoss):engageCombat(pNear)
      end
    end
  end
  if (readData("echoBase:wampaLeashRunning") ~= 1) then
    writeData("echoBase:wampaLeashRunning", 1)
    createEvent(3000, "echoBase", "wampaBossLeashCheck", pBoss, "")
  end
  return 0
end

-- SOE wampa_boss.java:44-60, UNCLE_JOE_MAX_DISTANCE = 104. On breach: full
-- HEALTH heal, setInvulnerable(true), stopCombat. Java then stops the 3 s
-- loop and never restores; D-EBe3 asks invulnerable until back, so the loop
-- keeps running and INVULNERABLE is cleared on return (no setInvulnerable
-- Lua binding -- TangibleObject option bit, same as kenobi_spine.lua:1169).
function echoBase:wampaBossLeashCheck(pBoss)
  if (pBoss == nil or CreatureObject(pBoss):isDead() or readData("echoBase:wampa_boss_dead") == 1 or readData("echoBase:occupiedState") ~= 1) then
    writeData("echoBase:wampaLeashRunning", 0)
    return
  end

  local homeX = 4000 + (-978.39)
  local homeY = 3500 + 684.86
  local x2 = SceneObject(pBoss):getPositionX()
  local y2 = SceneObject(pBoss):getPositionY()
  local distSq = ((x2 - homeX) * (x2 - homeX)) + ((y2 - homeY) * (y2 - homeY))
  local maxDist = 104

  if (distSq > (maxDist * maxDist)) then
    CreatureObject(pBoss):setHAM(0, CreatureObject(pBoss):getMaxHAM(0))
    TangibleObject(pBoss):setOptionBit(INVULNERABLE)
    forcePeace(pBoss)
  else
    if (TangibleObject(pBoss):hasOptionBit(INVULNERABLE)) then
      TangibleObject(pBoss):clearOptionBit(INVULNERABLE)
    end
  end

  createEvent(3000, "echoBase", "wampaBossLeashCheck", pBoss, "")
end

-- SOE wampa_boss.java:145-175 OnCreatureDamaged: adds at 80/60/40/20/10 %.
-- Lev's fightState ladder (axkvaMin.lua:244-312) so a spike cannot skip a
-- wave the way SOE's else-if chain can. Each gate fires summon_wampas
-- (tab:4736-4738, three heroic_echo_wampa_boss_bodyguard).
function echoBase:wampaBoss_damage(pBoss, pPlayer)
  if (pBoss == nil or CreatureObject(pBoss):isDead()) then
    return 0
  end

  local bossHealth = CreatureObject(pBoss):getHAM(0)
  local bossMaxHealth = CreatureObject(pBoss):getMaxHAM(0)

  if ((bossHealth <= (bossMaxHealth * 0.8)) and readData("echoBase:wampaFightState") == 0) then
    self:spawnWampaAdds(pBoss, pPlayer)
    writeData("echoBase:wampaFightState", 1)
  end

  if ((bossHealth <= (bossMaxHealth * 0.6)) and readData("echoBase:wampaFightState") == 1) then
    self:spawnWampaAdds(pBoss, pPlayer)
    writeData("echoBase:wampaFightState", 2)
  end

  if ((bossHealth <= (bossMaxHealth * 0.4)) and readData("echoBase:wampaFightState") == 2) then
    self:spawnWampaAdds(pBoss, pPlayer)
    writeData("echoBase:wampaFightState", 3)
  end

  if ((bossHealth <= (bossMaxHealth * 0.2)) and readData("echoBase:wampaFightState") == 3) then
    self:spawnWampaAdds(pBoss, pPlayer)
    writeData("echoBase:wampaFightState", 4)
  end

  if ((bossHealth <= (bossMaxHealth * 0.1)) and readData("echoBase:wampaFightState") == 4) then
    self:spawnWampaAdds(pBoss, pPlayer)
    writeData("echoBase:wampaFightState", 5)
  end

  return 0
end

-- SOE summon_adds -> trigger summon_wampas, then establishAgroLink(self, 250)
-- (wampa_boss.java:176-200). Adds themselves pick a random target in 125 m
-- (wampa_boss_add.java:22-29). Core3 has no agro-link / hate API: each add
-- engageCombat's the damager, then every player in 125 m.
function echoBase:spawnWampaAdds(pBoss, pPlayer)
  local spots = {
    {-960.68, -32.48, 648.67, -90},
    {-1031.72, -32.48, 632.95, 67},
    {-1003.85, -32.48, 682.08, 151}
  }
  for i = 1, #spots do
    local pAdd = self:spawnWampaOutdoor("heroic_echo_wampa_boss_bodyguard", spots[i][1], spots[i][2], spots[i][3], spots[i][4])
    if (pAdd ~= nil) then
      local n = readData("echoBase:wampaAddSeq") + 1
      writeData("echoBase:wampaAddSeq", n)
      writeData("echoBase:wampaAdd" .. n, SceneObject(pAdd):getObjectID())
      if (pPlayer ~= nil and CreatureObject(pPlayer):isPlayerCreature() and not CreatureObject(pPlayer):isDead()) then
        CreatureObject(pAdd):engageCombat(pPlayer)
      end
      local near = SceneObject(pAdd):getPlayersInRange(125)
      if (near ~= nil) then
        for j = 1, #near do
          local pNear = near[j]
          if (pNear ~= nil and CreatureObject(pNear):isPlayerCreature() and not CreatureObject(pNear):isDead() and not CreatureObject(pNear):isIncapacitated()) then
            CreatureObject(pAdd):engageCombat(pNear)
          end
        end
      end
    end
  end
end

-- Optional objective. echo_controller.java:123-127 wampa_boss_died sets
-- quest_tracker.wampa_boss_dead, worth zero tokens (research-echo-base.md §2.2).
-- EB-c reads echoBase:wampa_boss_dead. No token here (D-EBe5).
function echoBase:wampaBossKilled(pBoss, pPlayer)
  writeData("echoBase:wampa_boss_dead", 1)
  writeData("echoBase:wampaLeashRunning", 0)
  return 0
end

function echoBase:destroyWampaOutdoor()
  local bossId = readData("echoBase:wampaBossId")
  if (bossId ~= 0) then
    local pBoss = getSceneObject(bossId)
    if (pBoss ~= nil) then
      SceneObject(pBoss):destroyObjectFromWorld()
    end
    writeData("echoBase:wampaBossId", 0)
  end
  local seq = readData("echoBase:wampaAddSeq")
  for i = 1, seq do
    local id = readData("echoBase:wampaAdd" .. i)
    if (id ~= 0) then
      local pAdd = getSceneObject(id)
      if (pAdd ~= nil) then
        SceneObject(pAdd):destroyObjectFromWorld()
      end
      writeData("echoBase:wampaAdd" .. i, 0)
    end
  end
end

