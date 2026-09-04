-- Echo Base round EB-c: phase machine, factional chains, scoreboard, barks, token.
-- Round EB-d: AT-AT checkpoint chain, turret loop, mines, snowspeeder AI.
-- Methods hang off the echoBase table (echoBase.lua). Include AFTER echoBase.lua.
--
-- Shape: starDestroyer.lua (OBJECTDESTRUCTION objectives, handleVictory ->
-- awardTokenToAll) + ig88.lua (timing ladder) + axkvaMin.lua (Lev skeleton).
-- AT-AT chain: no Lev analogue (research-echo-base.md §2.4). Nearest shape is
-- a createEvent respawn after OBJECTDESTRUCTION (D-EBd1), plus ENTEREDAREA
-- 150 m death-watch areas.
-- Content: echo_controller.java, echo_quest_tracker.java:183-311,
-- player_instance.java:677-727, datatables/spawning/heroic/echo_base.tab,
-- at_at.java, rebel_turret.java, snowspeeder.java, vehicle_mine.java.
--
-- D-EBc1: faction = readData("echoBase:faction") 1 Rebel / 2 Imperial, set by
-- the entrance terminal (echoBaseEntryMenuComponent.lua:32-34).
-- D-EBd1..5 this round. Quest journal / collector are EB-f. Player vehicles cut.
--
-- NOT PORTED this round (D-EBd5):
--   ice_block.java (44 lines) -- 90 s self-cleanup + debuff link
--   echo_barricade.java (141) -- player-movable cover, barricade_defender
--   echo_placeable_object.java (110) -- deployable props
--   echo_theater.java (232) -- posture setter; kill_scott :98-118 /
--     kill_downey :119-139 flamethrower executions
-- Height keeper (snowspeeder.java:143-164 vehicle.setHoverHeight) -- no Core3 analogue.

-- ---------------------------------------------------------------------------
-- Scoreboard keys. D-EBc2: writeData("echoBase:<flag>", 1), cleared in reset.
-- echo_controller.java:604-648 (ping objective names).
-- Rebel P1: at_minor, at_major
-- Imperial P1: fail_major, fail_minor
-- Rebel P2: command_destroy, equipment, thermal, medical, command_escape, nonescape
-- Imperial P2: command_capture, hangar_capture, ion_cap_destroyed, food_destroy,
--              medical_destroy, equipment_destroy
-- Rebel P3: xport_minor, xport_major
-- Imperial P3: p3_minor, p3_major
-- Optional: wampa_boss_dead (EB-e writes it; worth zero tokens)
-- ---------------------------------------------------------------------------

function echoBase:clearPhaseKeys()
  writeData("echoBase:phase", 0)
  writeData("echoBase:spineSpawnState", 0)
  writeData("echoBase:atatKilled", 0)
  writeData("echoBase:xportDestroyed", 0)
  writeData("echoBase:xportAway", 0)
  writeData("echoBase:p2TimerGen", 0)
  writeData("echoBase:p3TimerGen", 0)
  writeData("echoBase:awarded", 0)
  writeData("echoBase:p1_ended", 0)
  writeData("echoBase:p2_ended", 0)
  writeData("echoBase:equipLeft", 0)
  writeData("echoBase:medLeft", 0)
  writeData("echoBase:foodLeft", 0)
  writeData("echoBase:thermalLeft", 0)
  writeData("echoBase:bombLeft", 0)
  writeData("echoBase:ionLeft", 0)
  writeData("echoBase:hangarLeft", 0)
  writeData("echoBase:at_minor", 0)
  writeData("echoBase:at_major", 0)
  writeData("echoBase:fail_major", 0)
  writeData("echoBase:fail_minor", 0)
  writeData("echoBase:command_destroy", 0)
  writeData("echoBase:equipment", 0)
  writeData("echoBase:thermal", 0)
  writeData("echoBase:medical", 0)
  writeData("echoBase:command_escape", 0)
  writeData("echoBase:nonescape", 0)
  writeData("echoBase:command_capture", 0)
  writeData("echoBase:hangar_capture", 0)
  writeData("echoBase:ion_cap_destroyed", 0)
  writeData("echoBase:food_destroy", 0)
  writeData("echoBase:medical_destroy", 0)
  writeData("echoBase:equipment_destroy", 0)
  writeData("echoBase:xport_minor", 0)
  writeData("echoBase:xport_major", 0)
  writeData("echoBase:p3_minor", 0)
  writeData("echoBase:p3_major", 0)
  writeData("echoBase:atatArrived", 0)
  for i = 1, 6 do
    writeData("echoBase:atat" .. i, 0)
    writeData("echoBase:atatCp" .. i, 0)
    writeData("echoBase:atatForce" .. i, 0)
    writeData("echoBase:atatMineSeq" .. i, 0)
    writeData("echoBase:atatArea" .. i, 0)
    -- Stamp a fresh gen so in-flight createEvent respawns no-op.
    writeData("echoBase:atatGen" .. i, self:nextAtatClock())
  end
end

function echoBase:nextAtatClock()
  local n = readData("echoBase:atatClock") + 1
  writeData("echoBase:atatClock", n)
  return n
end

-- Transcribed VERBATIM from echo_controller.java:713-762 getRebelTokenCountByVictory.
-- ScriptVar quest_tracker.rebel.<flag> -> readData("echoBase:<flag>").
function echoBase:rebelTokenCount()
  local p1_eval = 0
  local p2_eval = 0
  local p3_eval = 0
  local p1_token = 0
  local p2_token = 0
  local p3_token = 0
  -- java:722-726 p1_obj at_minor, at_major
  p1_eval = p1_eval + readData("echoBase:at_minor")
  p1_eval = p1_eval + readData("echoBase:at_major")
  -- java:727-735 p2_obj command_destroy, equipment, thermal, medical, command_escape, nonescape
  p2_eval = p2_eval + readData("echoBase:command_destroy")
  p2_eval = p2_eval + readData("echoBase:equipment")
  p2_eval = p2_eval + readData("echoBase:thermal")
  p2_eval = p2_eval + readData("echoBase:medical")
  p2_eval = p2_eval + readData("echoBase:command_escape")
  p2_eval = p2_eval + readData("echoBase:nonescape")
  -- java:736-740 p3_obj xport_minor, xport_major
  p3_eval = p3_eval + readData("echoBase:xport_minor")
  p3_eval = p3_eval + readData("echoBase:xport_major")
  -- java:750-761
  if (p1_eval > 0) then
    p1_token = (p1_eval == 1) and 1 or 3
  end
  if (p2_eval > 2) then
    p2_token = (p2_eval < 6) and 1 or 3
  end
  if (p3_eval > 0) then
    p3_token = (p3_eval == 1) and 1 or 3
  end
  return p1_token + p2_token + p3_token
end

-- Transcribed VERBATIM from echo_controller.java:764-818 getImperialTokenCountByVictory.
function echoBase:imperialTokenCount()
  local p1_eval = 0
  local p2_eval = 0
  local p3_eval = 0
  local p1_token = 0
  local p2_token = 0
  local p3_token = 0
  -- java:773-777 p1_obj fail_major, fail_minor
  p1_eval = p1_eval + readData("echoBase:fail_major")
  p1_eval = p1_eval + readData("echoBase:fail_minor")
  -- java:778-786 p2_obj command_capture, hangar_capture, ion_cap_destroyed,
  -- food_destroy, medical_destroy, equipment_destroy
  p2_eval = p2_eval + readData("echoBase:command_capture")
  p2_eval = p2_eval + readData("echoBase:hangar_capture")
  p2_eval = p2_eval + readData("echoBase:ion_cap_destroyed")
  p2_eval = p2_eval + readData("echoBase:food_destroy")
  p2_eval = p2_eval + readData("echoBase:medical_destroy")
  p2_eval = p2_eval + readData("echoBase:equipment_destroy")
  -- java:787-791 p3_obj p3_minor, p3_major
  p3_eval = p3_eval + readData("echoBase:p3_minor")
  p3_eval = p3_eval + readData("echoBase:p3_major")
  -- java:801-816  inverted P1: 0 fails -> 3 tokens, 1 fail -> 1, else 0
  if (p1_eval > 0) then
    p1_token = (p1_eval == 1) and 1 or 0
  else
    p1_token = 3
  end
  if (p2_eval > 2) then
    p2_token = (p2_eval < 6) and 1 or 3
  end
  if (p3_eval > 0) then
    p3_token = (p3_eval == 2) and 3 or 1
  end
  return p1_token + p2_token + p3_token
end

function echoBase:tokenCount()
  if (readData("echoBase:faction") == 2) then
    return self:imperialTokenCount()
  end
  return self:rebelTokenCount()
end

function echoBase:isRebel()
  return readData("echoBase:faction") ~= 2
end

-- Outdoor rows are self-relative to the controller building (research-echo-base.md
-- §1.4 / sequence_controller.java:412-421). Same transform as spawnWampaOutdoor:
-- world = (4000, 0, 3500) + (loc_x, loc_y+32.48, loc_z). SOE (x,y,z) -> Core3 (x, z, y).
function echoBase:spawnOutdoorMobile(templateName, locX, locY, locZ, yaw)
  local wx = 4000 + locX
  local wz = locY + 32.48
  local wy = 3500 + locZ
  return spawnMobile("dungeon1", templateName, 0, wx, wz, wy, yaw, 0)
end

function echoBase:spawnOutdoorScene(template, locX, locY, locZ, yaw)
  local wx = 4000 + locX
  local wz = locY + 32.48
  local wy = 3500 + locZ
  return spawnSceneObject("dungeon1", template, wx, wz, wy, 0, math.rad(yaw))
end

function echoBase:spawnInCell(templateName, cellName, locX, locY, locZ, yaw)
  local cell = self:cellId(cellName)
  if (cell == 0) then
    return nil
  end
  return spawnMobile("dungeon1", templateName, 0, locX, locY, locZ, yaw, cell)
end

function echoBase:spawnSceneInCell(template, cellName, locX, locY, locZ, yaw)
  local cell = self:cellId(cellName)
  if (cell == 0) then
    return nil
  end
  return spawnSceneObject("dungeon1", template, locX, locY, locZ, cell, math.rad(yaw))
end

function echoBase:trackSpine(pObj)
  if (pObj == nil) then
    return 0
  end
  local n = readData("echoBase:spineSeq") + 1
  writeData("echoBase:spineSeq", n)
  writeData("echoBase:spine" .. n, SceneObject(pObj):getObjectID())
  return SceneObject(pObj):getObjectID()
end

function echoBase:destroySpineOutdoor()
  local pBuilding = self:getBuildingObject()
  if (pBuilding ~= nil) then
    local players = SceneObject(pBuilding):getPlayersInRange(2500)  -- OURS, NOT SOURCED: reset sweep radius covering the ~2.3 x 2.4 km battlefield footprint (research-echo-base.md 1.4)
    if (players ~= nil) then
      for i = 1, #players do
        local pNear = players[i]
        if (pNear ~= nil and CreatureObject(pNear):isPlayerCreature()) then
          dropObserver(OBJECTDESTRUCTION, "echoBase", "atatNearbyPlayerDied", pNear)
          writeData(SceneObject(pNear):getObjectID() .. ":echoBaseAtatDeath", 0)
        end
      end
    end
  end
  local seq = readData("echoBase:spineSeq")
  for i = 1, seq do
    local id = readData("echoBase:spine" .. i)
    if (id ~= 0) then
      local pObj = getSceneObject(id)
      if (pObj ~= nil) then
        SceneObject(pObj):destroyObjectFromWorld()
      end
      writeData("echoBase:spine" .. i, 0)
    end
  end
  writeData("echoBase:spineSeq", 0)
  writeData("echoBase:generatorId", 0)
  writeData("echoBase:destroyedGeneratorId", 0)
end

-- ---------------------------------------------------------------------------
-- Spine spawns. Every row cites echo_base.tab. D-EBc4 / research §3.5.
-- ---------------------------------------------------------------------------

function echoBase:spawnSpineCheck(pPlayer)
  if (readData("echoBase:spineSpawnState") == 1) then
    return
  end
  self:destroySpineOutdoor()
  self:spawnSpine(pPlayer)
  writeData("echoBase:spineSpawnState", 1)
  self:startPhaseOne(pPlayer)
end

function echoBase:spawnSpine(pPlayer)
  self:spawnAtats()
  self:spawnTurrets()
  self:spawnTrenchLine()
  self:spawnLiveGenerator()
  -- 11 heroic_echo_snowspeeder_ai, Rebel run only (D-EBd4).
  if (self:isRebel()) then
    self:spawnSnowspeeders()
  end
  -- tab:5911 triggerId=imperial and tab:6045 triggerId=rebel spawn at
  -- beginSpawn (sequence_controller.java:184-190 defaultTrigger), not P3.
  self:spawnFactionExitShuttle()
end

-- 24 heroic_echo_atat rows = 6 walkers x 4 checkpoints (start + forwardSpawn1..3).
-- Index 5 is the generator finish (pathPoint at_finishN, tab:605-610), not a
-- spawn row: force-advance from checkpoint 4 lands there and starts
-- atatGeneratorShoot. Room is blank on every row (outdoor).
-- SOE (x, y, z, yaw) as stored; spawnOutdoorMobile maps to Core3 (x, z, y).
echoBaseAtatChains = {
  { -- walker 1 atatNumber=at1 spawn_id=at1
    {1227, 55, 1548, -178, 37, "at1_start"},
    {1224, 55, 1350, -178, 60, "at1_forwardSpawn1"},
    {1220, 55, 1205, -178, 69, "at1_forwardSpawn2"},
    {1198, 55, 982, -178, 78, "at1_forwardSpawn3"},
    {826.5, 55, 194, -178, 605, "at_finish1"}
  },
  { -- walker 2 atatNumber=at2 spawn_id=at3
    {1191.5281, 55, 1468.4258, -178, 40, "at2"},
    {1175, 55, 1350, -178, 93, "at2_forwardSpawn1"},
    {1155, 55, 1205, -178, 102, "at2_forwardSpawn2"},
    {1124, 55, 988, -178, 111, "at2_forwardSpawn3"},
    {784, 55, 198, -178, 606, "at_finish2"}
  },
  { -- walker 3 atatNumber=at3 spawn_id=at5
    {1130.4219, 55, 1377.852, -178, 43, "at3"},
    {1124, 55, 1348, -178, 126, "at3_forwardSpawn1"},
    {1104, 55, 1206, -178, 135, "at3_forwardSpawn2"},
    {1072, 55, 988, -178, 144, "at3_forwardSpawn3"},
    {735, 55, 238, -178, 607, "at_finish3"}
  },
  { -- walker 4 atatNumber=at4 spawn_id=at7
    {1060, 55, 1519, -178, 46, "at4"},
    {1045, 55, 1350, -178, 159, "at4_forwardSpawn1"},
    {1027, 55, 1206, -178, 168, "at4_forwardSpawn2"},
    {1000, 55, 988, -178, 177, "at4_forwardSpawn3"},
    {687, 55, 277, -178, 608, "at_finish4"}
  },
  { -- walker 5 atatNumber=at5 spawn_id=at9
    {982.4407, 55, 1425.4258, -178, 49, "at5"},
    {977, 55, 1350, -178, 192, "at5_forwardSpawn1"},
    {962, 55, 1203, -178, 201, "at5_forwardSpawn2"},
    {940, 55, 991, -178, 210, "at5_forwardSpawn3"},
    {650, 55, 306, -178, 609, "at_finish5"}
  },
  { -- walker 6 atatNumber=at6 spawn_id=at11
    {908, 55, 1487, -178, 52, "at6"},
    {887, 55, 1330, -178, 225, "at6_forwardSpawn1"},
    {868, 55, 1200, -178, 234, "at6_forwardSpawn2"},
    {839, 55, 989, -178, 243, "at6_forwardSpawn3"},
    {609, 55, 337, -178, 610, "at_finish6"}
  }
}

-- Last of the 24 tab rows. A kill here (or at the generator finish) counts.
echoBaseAtatLastKillCp = 4

-- Stagger from delayAction:at1_start:1 / at2:10 / at3:20 / at4:30 / at5:40 / at6:50
-- (tab:35, 38, 41, 44, 47, 50). Respawn delay 8 s from delayAction:*_forwardSpawn*:8
-- and delayAction:atN_start:8 triggerId atN_respawn (tab:36, 39, ...).
function echoBase:spawnAtats()
  for i = 1, 6 do
    local delay = 1
    if (i > 1) then
      delay = (i - 1) * 10
    end
    local gen = self:nextAtatClock()
    writeData("echoBase:atatGen" .. i, gen)
    createEvent(delay * 1000, "echoBase", "spawnAtatWalker", nil, i .. ":1:" .. gen)
  end
end

function echoBase:parseAtatArgs(args)
  local w, c, g = string.match(tostring(args), "^(%d+):(%d+):(%d+)$")
  if (w == nil) then
    return 0, 0, 0
  end
  return tonumber(w), tonumber(c), tonumber(g)
end

function echoBase:spawnAtatWalker(pDummy, args)
  if (readData("echoBase:occupiedState") ~= 1 or readData("echoBase:p1_ended") == 1) then
    return
  end
  local walker, cp, gen = self:parseAtatArgs(args)
  if (walker < 1 or walker > 6) then
    return
  end
  if (gen ~= readData("echoBase:atatGen" .. walker)) then
    return
  end
  local chain = echoBaseAtatChains[walker]
  if (chain == nil or cp < 1 or cp > #chain) then
    return
  end
  local r = chain[cp]
  local pAtat = self:spawnOutdoorMobile("heroic_echo_atat", r[1], r[2], r[3], r[4])
  if (pAtat == nil) then
    return
  end
  self:trackSpine(pAtat)
  local oid = SceneObject(pAtat):getObjectID()
  writeData("echoBase:atat" .. walker, oid)
  writeData("echoBase:atatCp" .. walker, cp)
  writeData("echoBase:atatForce" .. walker, 0)
  writeData(oid .. ":echoAtatWalker", walker)
  -- at_at.java:28-34: Rebel instance (team == 1) +20% HP.
  if (self:isRebel()) then
    for i = 0, 8, 3 do
      local ham = CreatureObject(pAtat):getMaxHAM(i)
      ham = ham + math.floor(ham / 5)
      CreatureObject(pAtat):setMaxHAM(i, ham)
      CreatureObject(pAtat):setHAM(i, ham)
    end
  end
  createObserver(OBJECTDESTRUCTION, "echoBase", "atatKilled", pAtat)
  createObserver(DAMAGERECEIVED, "echoBase", "atatDamaged", pAtat)
  self:spawnAtatDeathArea(pAtat, walker)
  if (cp == 5) then
    local arrived = readData("echoBase:atatArrived") + 1
    writeData("echoBase:atatArrived", arrived)
    -- D-EBd1: Imperial flags on 1 / 4 walkers arriving at the generator.
    -- echo_controller.java:189-190 CS-logs those same 1 / 4 thresholds as
    -- "Lost 1 AT-AT" / "Lost 4 AT-AT" keyed off at_died (tab:5884-5887).
    -- Arrival is the Imperial P1 fail condition this round (D-EBd1).
    if (readData("echoBase:p1_ended") ~= 1) then
      if (arrived >= 1) then
        writeData("echoBase:fail_major", 1)
      end
      if (arrived >= 4) then
        writeData("echoBase:fail_minor", 1)
      end
    end
    createEvent(12000, "echoBase", "atatGeneratorShoot", pAtat, tostring(walker))
  end
end

function echoBase:spawnAtatDeathArea(pAtat, walker)
  local oldId = readData("echoBase:atatArea" .. walker)
  if (oldId ~= 0) then
    local pOld = getSceneObject(oldId)
    if (pOld ~= nil) then
      SceneObject(pOld):destroyObjectFromWorld()
    end
    writeData("echoBase:atatArea" .. walker, 0)
  end
  if (pAtat == nil) then
    return
  end
  -- 150 m (D-EBd1). at_at.java ATATforceCheck has no radius; 150 is OURS.
  local wx = SceneObject(pAtat):getWorldPositionX()
  local wz = SceneObject(pAtat):getWorldPositionZ()
  local wy = SceneObject(pAtat):getWorldPositionY()
  local pArea = spawnActiveArea("dungeon1", "object/active_area.iff", wx, wz, wy, 150, 0)
  if (pArea == nil) then
    return
  end
  self:trackSpine(pArea)
  local areaId = SceneObject(pArea):getObjectID()
  writeData("echoBase:atatArea" .. walker, areaId)
  writeData(areaId .. ":echoAtatWalker", walker)
  createObserver(ENTEREDAREA, "echoBase", "atatDeathAreaEntered", pArea)
  local already = SceneObject(pAtat):getPlayersInRange(150)
  if (already ~= nil) then
    for i = 1, #already do
      self:armAtatPlayerDeath(already[i])
    end
  end
end

function echoBase:atatDeathAreaEntered(pArea, pCreature)
  if (pCreature ~= nil and CreatureObject(pCreature):isPlayerCreature()) then
    self:armAtatPlayerDeath(pCreature)
  end
  return 0
end

-- Core3 player-death hook: OBJECTDESTRUCTION on the player (village
-- sith_shadow_encounter.lua:103 / mellichae_outro_theater.lua). PLAYERKILLED
-- exists (ObserverEventType.h:54) but no Lua heroic uses it; this is the
-- clean Core3 equivalent of D-EBd1's DEATH observer.
function echoBase:armAtatPlayerDeath(pPlayer)
  if (pPlayer == nil or not CreatureObject(pPlayer):isPlayerCreature()) then
    return
  end
  local oid = SceneObject(pPlayer):getObjectID()
  if (readData(oid .. ":echoBaseAtatDeath") == 1) then
    return
  end
  writeData(oid .. ":echoBaseAtatDeath", 1)
  createObserver(OBJECTDESTRUCTION, "echoBase", "atatNearbyPlayerDied", pPlayer)
end

function echoBase:atatNearbyPlayerDied(pPlayer, pKiller)
  if (pPlayer == nil or readData("echoBase:occupiedState") ~= 1 or readData("echoBase:p1_ended") == 1) then
    return 0
  end
  for w = 1, 6 do
    local id = readData("echoBase:atat" .. w)
    if (id ~= 0) then
      local pAtat = getSceneObject(id)
      if (pAtat ~= nil and not CreatureObject(pAtat):isDead()
          and SceneObject(pPlayer):isInRangeWithObject(pAtat, 150)) then
        local n = readData("echoBase:atatForce" .. w) + 1
        writeData("echoBase:atatForce" .. w, n)
        -- at_at.java:235-258 ATATforceCheck maxDeathCount = 5.
        if (n >= 5) then
          writeData("echoBase:atatForce" .. w, 0)
          self:atatForceAdvance(w)
        end
      end
    end
  end
  return 0
end

function echoBase:atatForceAdvance(walker)
  local id = readData("echoBase:atat" .. walker)
  if (id == 0) then
    return
  end
  local pAtat = getSceneObject(id)
  local cp = readData("echoBase:atatCp" .. walker)
  local chain = echoBaseAtatChains[walker]
  if (chain == nil or cp >= #chain) then
    return
  end
  writeData("echoBase:atatSkip" .. id, 1)
  writeData("echoBase:atat" .. walker, 0)
  local gen = self:nextAtatClock()
  writeData("echoBase:atatGen" .. walker, gen)
  if (pAtat ~= nil) then
    SceneObject(pAtat):destroyObjectFromWorld()
  end
  -- tab delayAction 8 s (same as death-advance).
  createEvent(8000, "echoBase", "spawnAtatWalker", nil, walker .. ":" .. (cp + 1) .. ":" .. gen)
end

function echoBase:atatKilled(pAtat, pPlayer)
  if (pAtat == nil) then
    return 1
  end
  local oid = SceneObject(pAtat):getObjectID()
  local walker = readData(oid .. ":echoAtatWalker")
  if (walker < 1 or walker > 6) then
    return 1
  end
  writeData("echoBase:atat" .. walker, 0)
  if (readData("echoBase:atatSkip" .. oid) == 1) then
    writeData("echoBase:atatSkip" .. oid, 0)
    return 1
  end
  if (readData("echoBase:occupiedState") ~= 1) then
    return 1
  end
  local cp = readData("echoBase:atatCp" .. walker)
  local gen = self:nextAtatClock()
  writeData("echoBase:atatGen" .. walker, gen)
  local chain = echoBaseAtatChains[walker]
  -- Kill at last tab checkpoint (4) or the generator finish (5) counts.
  -- Intermediate deaths respawn at the next row (at_at.java:215-230 OnDeath
  -- -> atatNumber_spawnPoint_advancePoint / atatNumber_respawn).
  if (cp >= echoBaseAtatLastKillCp or (chain ~= nil and cp >= #chain)) then
    local n = readData("echoBase:atatKilled") + 1
    writeData("echoBase:atatKilled", n)
    -- P1 scoring frozen after generator destruction (echo_controller.java:68-70 p1_ended).
    if (readData("echoBase:p1_ended") ~= 1) then
      if (self:isRebel()) then
        -- tab:5875-5876 waitForComplete 4 / 6 at_died
        if (n >= 4) then
          writeData("echoBase:at_minor", 1)
        end
        if (n >= 6) then
          writeData("echoBase:at_major", 1)
        end
      end
    end
    return 1
  end
  if (chain ~= nil and cp < #chain) then
    createEvent(8000, "echoBase", "spawnAtatWalker", nil, walker .. ":" .. (cp + 1) .. ":" .. gen)
  end
  return 1
end

-- at_at.java:117-126 OnCreatureDamaged: mine every 12 s. Cap 10 live per
-- walker is OURS, NOT SOURCED.
function echoBase:atatDamaged(pAtat, pAttacker)
  if (pAtat == nil or CreatureObject(pAtat):isDead() or readData("echoBase:occupiedState") ~= 1) then
    return 0
  end
  local oid = SceneObject(pAtat):getObjectID()
  local walker = readData(oid .. ":echoAtatWalker")
  if (walker < 1) then
    return 0
  end
  local now = os.time()
  if (now < readData(oid .. ":echoAtatMineAt")) then
    return 0
  end
  writeData(oid .. ":echoAtatMineAt", now + 12)
  if (self:atatLiveMineCount(walker) >= 10) then
    return 0
  end
  self:spawnAtatMine(pAtat, walker)
  return 0
end

function echoBase:atatLiveMineCount(walker)
  local n = 0
  local seq = readData("echoBase:atatMineSeq" .. walker)
  for i = 1, seq do
    local id = readData("echoBase:atatMine" .. walker .. "_" .. i)
    if (id ~= 0) then
      local pMine = getSceneObject(id)
      if (pMine ~= nil and not CreatureObject(pMine):isDead()) then
        n = n + 1
      end
    end
  end
  return n
end

function echoBase:spawnAtatMine(pAtat, walker)
  if (pAtat == nil) then
    return
  end
  local wx = SceneObject(pAtat):getWorldPositionX()
  local wz = SceneObject(pAtat):getWorldPositionZ()
  local wy = SceneObject(pAtat):getWorldPositionY()
  local pMine = spawnMobile("dungeon1", "heroic_echo_vehicle_mine", 0, wx, wz, wy, 0, 0)
  if (pMine == nil) then
    return
  end
  self:trackSpine(pMine)
  -- vehicle_mine.java:13 createTriggerVolume("hoth_vehicle_mine", 10.0f, true)
  local pArea = spawnActiveArea("dungeon1", "object/active_area.iff", wx, wz, wy, 10, 0)
  local seq = readData("echoBase:atatMineSeq" .. walker) + 1
  writeData("echoBase:atatMineSeq" .. walker, seq)
  local mineId = SceneObject(pMine):getObjectID()
  writeData("echoBase:atatMine" .. walker .. "_" .. seq, mineId)
  writeData(mineId .. ":echoAtatWalker", walker)
  writeData(mineId .. ":echoAtatMineSlot", seq)
  if (pArea ~= nil) then
    self:trackSpine(pArea)
    local areaId = SceneObject(pArea):getObjectID()
    writeData("echoBase:atatMineArea" .. walker .. "_" .. seq, areaId)
    writeData(areaId .. ":echoAtatMine", mineId)
    createObserver(ENTEREDAREA, "echoBase", "atatMineEntered", pArea)
  end
end

function echoBase:atatMineEntered(pArea, pCreature)
  if (pArea == nil or pCreature == nil or not CreatureObject(pCreature):isPlayerCreature()
      or CreatureObject(pCreature):isDead()) then
    return 0
  end
  local areaId = SceneObject(pArea):getObjectID()
  local mineId = readData(areaId .. ":echoAtatMine")
  local pMine = getSceneObject(mineId)
  -- 14000: combat_data.tab:1223 hoth_atat_mine ELEMENTAL_HEAT. vehicle_mine.java
  -- has no damage constant (queues CRC -1220440242). Inflicted on the player.
  -- Binding: LuaCreatureObject.cpp:46, :613-629
  -- CreatureObject:inflictDamage(attacker, damageType, damage, destroy)
  -- damageType 0 = HEALTH (DirectorManager.cpp:700).
  if (pMine ~= nil) then
    CreatureObject(pCreature):inflictDamage(pMine, 0, 14000, 0)
  else
    CreatureObject(pCreature):inflictDamage(pCreature, 0, 14000, 0)
  end
  self:despawnAtatMine(mineId)
  SceneObject(pArea):destroyObjectFromWorld()
  return 1
end

function echoBase:despawnAtatMine(mineId)
  if (mineId == nil or mineId == 0) then
    return
  end
  local pMine = getSceneObject(mineId)
  if (pMine ~= nil) then
    local walker = readData(mineId .. ":echoAtatWalker")
    local slot = readData(mineId .. ":echoAtatMineSlot")
    writeData("echoBase:atatMine" .. walker .. "_" .. slot, 0)
    local areaId = readData("echoBase:atatMineArea" .. walker .. "_" .. slot)
    if (areaId ~= 0) then
      local pArea = getSceneObject(areaId)
      if (pArea ~= nil) then
        SceneObject(pArea):destroyObjectFromWorld()
      end
      writeData("echoBase:atatMineArea" .. walker .. "_" .. slot, 0)
    end
    SceneObject(pMine):destroyObjectFromWorld()
  end
end

-- at_at.java:128-158 atatGeneratorShoot fires client projectiles only -- no HP.
-- D-EBd1: scripted amount every 12 s until phase 2. 12500 is OURS, NOT SOURCED
-- (12 shots exhaust the 150000 generator HP from the_bomb.java / EB-c).
-- TangibleObject:inflictDamage is not Lua-bound (valley_battlefield.lua:1405-1407);
-- setConditionDamage + manual generatorDestroyed matches that file.
function echoBase:atatGeneratorShoot(pAtat, walkerStr)
  local walker = tonumber(walkerStr)
  if (walker == nil or readData("echoBase:occupiedState") ~= 1 or readData("echoBase:phase") ~= 1
      or readData("echoBase:p1_ended") == 1) then
    return
  end
  if (pAtat == nil or CreatureObject(pAtat):isDead()) then
    return
  end
  if (readData("echoBase:atatCp" .. walker) ~= 5) then
    return
  end
  local genId = readData("echoBase:generatorId")
  local pGen = getSceneObject(genId)
  if (pGen == nil) then
    return
  end
  local damage = TangibleObject(pGen):getConditionDamage() + 12500
  TangibleObject(pGen):setConditionDamage(damage)
  if (damage >= 150000) then
    self:generatorDestroyed(pGen, nil)
    return
  end
  createEvent(12000, "echoBase", "atatGeneratorShoot", pAtat, walkerStr)
end

function echoBase:pickLiveAtatInRange(pFrom, range)
  if (pFrom == nil) then
    return nil
  end
  local live = {}
  for i = 1, 6 do
    local id = readData("echoBase:atat" .. i)
    if (id ~= 0) then
      local pAtat = getSceneObject(id)
      if (pAtat ~= nil and not CreatureObject(pAtat):isDead()
          and SceneObject(pFrom):isInRangeWithObject(pAtat, range)) then
        live[#live + 1] = pAtat
      end
    end
  end
  if (#live == 0) then
    return nil
  end
  return live[getRandomNumber(1, #live)]
end

-- 11 heroic_echo_snowspeeder_ai, Rebel only. tab:652-659, 663-665.
function echoBase:spawnSnowspeeders()
  local rows = {
    {-153, 71, 608, 90, 652},
    {-173, 71, 610, 90, 653},
    {-192, 71, 611, 90, 654},
    {-200, 71, 631, 90, 655},
    {-183, 71, 631, 90, 656},
    {-156, 71, 631, 90, 657},
    {-164, 71, 646, 90, 658},
    {-185, 71, 645, 90, 659},
    {494, 108, 1193, 150, 663},
    {81.26, 96.43, 867.58, 133, 664},
    {271.61, 81.45, 965.58, 133, 665}
  }
  for i = 1, #rows do
    local r = rows[i]
    local pSp = self:spawnOutdoorMobile("heroic_echo_snowspeeder_ai", r[1], r[2], r[3], r[4])
    if (pSp ~= nil) then
      self:trackSpine(pSp)
      -- snowspeeder.java:23 trial.setHp(self, rand(400000, 500000))
      local hp = getRandomNumber(400000, 500000)
      for h = 0, 8, 3 do
        CreatureObject(pSp):setMaxHAM(h, hp)
        CreatureObject(pSp):setHAM(h, hp)
      end
      -- snowspeeder.java:24 findTarget first tick rand(10, 20) s.
      createEvent(getRandomNumber(10, 20) * 1000, "echoBase", "snowspeederStrafe", pSp, "")
    end
  end
end

-- Cone-target loop (snowspeeder.java:56-141, 96 m / 30 deg) approximated as
-- normal AI aggro + a periodic tick against the nearest walker. 15000 from
-- combat_data.tab:1215 hoth_ai_speeder_shoot (the command snowspeeder.java:139
-- queues). Height keeper (snowspeeder.java:143-164) NOT PORTED -- no Core3 analogue.
function echoBase:snowspeederStrafe(pSp)
  if (pSp == nil or CreatureObject(pSp):isDead() or readData("echoBase:occupiedState") ~= 1) then
    return
  end
  local pAtat = self:pickLiveAtatInRange(pSp, 700)
  if (pAtat ~= nil) then
    CreatureObject(pAtat):inflictDamage(pSp, 0, 15000, 0)
  end
  -- java findTarget rearms at 1 s; 4 s is OURS, NOT SOURCED (spam cap).
  createEvent(4000, "echoBase", "snowspeederStrafe", pSp, "")
end

-- 25 heroic_echo_rebel_turret_s1 + 15 heroic_echo_rebel_turret_s2.
-- boredHothTurrets (rebel_turret.java:32-84). HP per D-EBb (ELITE 85 rung; SOE
-- rand(100000,150000) is recorded on the mobile and is NOT applied here).
-- tab:2181-2743.
function echoBase:spawnTurrets()
  local s1 = {
    {774.3, 55, 1007.5, 38, 2181},
    {669, 55, 676, 34, 2190},
    {496, 90, 390, 90, 2193},
    {345, 55, 294, 94, 2202},
    {289, 55, 193, 82, 2205},
    {1274, 58, 974, -41, 2215},
    {1292, 61, 974, -31, 2218},
    {1288, 61, 861, -48, 2226},
    {1214, 58, 763, -32, 2232},
    {1179, 58, 692, -32, 2235},
    {1134, 58, 433, -10, 2238},
    {1161, 58, 439, -20, 2241},
    {1056, 55, 734, 3, 2643},
    {1087, 55, 942, 8, 2657},
    {921.5, 55, 725.1, 20, 2665},
    {940, 55, 707, 5, 2671},
    {957.7, 55, 958.2, 8, 2682},
    {767.9, 55, 699.6, 10, 2693},
    {780.4, 55, 662.1, 8, 2699},
    {919.7, 55, 210.8, -47, 2710},
    {861.9, 55, 161, -15, 2716},
    {797.9, 55, 180.9, 24, 2719},
    {699.1, 55, 183, 37, 2731},
    {677.2, 55, 244.9, 36, 2734},
    {568.9, 55, 267.2, 42, 2740}
  }
  local s2 = {
    {794.5, 55, 991.1, 21, 2184},
    {763, 55, 1028, 58, 2187},
    {1271, 61, 1280, -44, 2208},
    {1070, 55, 723, 4, 2646},
    {1074.6, 55, 927.5, 8, 2654},
    {957.9, 55, 725, 10, 2668},
    {976.2, 55, 925.3, 8, 2679},
    {825.7, 55, 689.6, 3, 2690},
    {792, 55, 671, 15, 2696},
    {821.2, 55, 160.2, 10, 2713},
    {720.9175, 55, 161.85693, 25.722576, 2722},
    {979.44, 55, 231.56, -45, 2725},
    {740.6, 55, 131.7, 18, 2728},
    {546, 55, 288, 42, 2737},
    {609.97, 55, 246.55, 29, 2743}
  }
  for i = 1, #s1 do
    local r = s1[i]
    local pTur = self:spawnOutdoorMobile("heroic_echo_rebel_turret_s1", r[1], r[2], r[3], r[4])
    if (pTur ~= nil) then
      self:trackSpine(pTur)
      -- rebel_turret.java:38-39 min 2.5 / max 7.5 s
      createEvent(getRandomNumber(2500, 7500), "echoBase", "turretBoredLoop", pTur, "")
    end
  end
  for i = 1, #s2 do
    local r = s2[i]
    local pTur = self:spawnOutdoorMobile("heroic_echo_rebel_turret_s2", r[1], r[2], r[3], r[4])
    if (pTur ~= nil) then
      self:trackSpine(pTur)
      createEvent(getRandomNumber(2500, 7500), "echoBase", "turretBoredLoop", pTur, "")
    end
  end
end

-- rebel_turret.java:32-133 boredHothTurrets / hothTurretShotApplyDamage.
-- Binding: LuaCreatureObject.cpp:46, :613-629
-- CreatureObject:inflictDamage(attacker, damageType, damage, destroy)
-- called on the AT-AT, attacker = turret, damageType 0 = HEALTH.
function echoBase:turretBoredLoop(pTur)
  if (pTur == nil or CreatureObject(pTur):isDead() or readData("echoBase:occupiedState") ~= 1
      or readData("echoBase:p1_ended") == 1) then
    return
  end
  -- java:42-43, 77-80: if the turret already has a combat target, skip the AT-AT shot.
  if (not CreatureObject(pTur):isInCombat()) then
    local pAtat = self:pickLiveAtatInRange(pTur, 700)
    if (pAtat ~= nil) then
      local dmg
      if (self:isRebel()) then
        -- java:118-120 isRebelInstance rand(1500, 3000)
        dmg = getRandomNumber(1500, 3000)
      else
        -- java:122-124 imperial rand(15000, 20000)
        dmg = getRandomNumber(15000, 20000)
      end
      CreatureObject(pAtat):inflictDamage(pTur, 0, dmg, 0)
    end
  end
  createEvent(getRandomNumber(2500, 7500), "echoBase", "turretBoredLoop", pTur, "")
end

-- ~60 trench troopers. snowtrooper_pathing rows are trigger: opcodes (not
-- creature names); instantiated as heroic_echo_snowtrooper at those coords.
-- trench_herc_* are heroic_echo_rebel_commando. Cap 60: 24 commandos + 30
-- atN_snowTrooper_*_leg2 + 6 snowtrooper_randomPat hoth. AT-ST trigger rows skipped.
function echoBase:spawnTrenchLine()
  -- tab:2837-2849 trench_herc_01, tab:2850-2860 trench_herc_02. Empty yaw -> 0.
  local commandos = {
    {454.8, 53.5, 245.5, 2837},
    {454.7, 53.5, 137.8, 2838},
    {588.41, 53.5, 138.33, 2839},
    {588.64, 53.5, 78, 2840},
    {749, 53.5, 77.99, 2841},
    {748.55, 53.5, 98.15, 2842},
    {748.8, 53.5, 141.66, 2843},
    {688.88, 53.5, 141.68, 2844},
    {658.93, 53.5, 142.34, 2845},
    {658.55, 53.5, 191.4, 2846},
    {558.82, 53.5, 191.77, 2847},
    {558.63, 53.5, 222.27, 2848},
    {499.86, 53.5, 222, 2849},
    {498.03, 53.5, 301.6, 2850},
    {558.68, 53.5, 301.78, 2851},
    {558.8, 53.5, 257.9, 2852},
    {688.48, 53.5, 258.05, 2853},
    {688.47, 53.5, 171.85, 2854},
    {808.79, 53.5, 172.33, 2855},
    {908.62, 53.5, 171.7, 2856},
    {908.95, 53.5, 221.48, 2857},
    {988.79, 53.5, 221.8, 2858},
    {988.76, 53.5, 287.58, 2859},
    {1033.12, 53.5, 288.14, 2860}
  }
  for i = 1, #commandos do
    local r = commandos[i]
    local pMob = self:spawnOutdoorMobile("heroic_echo_rebel_commando", r[1], r[2], r[3], 0)
    if (pMob ~= nil) then
      self:trackSpine(pMob)
    end
  end
  -- at1..at6 snowTrooper_*_leg2 (hoth), tab:1414-2049. AT-ST rows omitted.
  local snow = {
    {1207, 55, 895, 1414}, {1212, 55, 900, 1417}, {1217, 55, 905, 1420},
    {1202, 55, 900, 1423}, {1197, 55, 905, 1428},
    {1120, 55, 945, 1545}, {1125, 55, 950, 1548}, {1130, 55, 955, 1551},
    {1115, 55, 950, 1554}, {1110, 55, 955, 1557},
    {1057, 55, 890, 1668}, {1062, 55, 895, 1671}, {1067, 55, 900, 1674},
    {1052, 55, 895, 1677}, {1047, 55, 900, 1680},
    {995, 55, 895, 1791}, {1000, 55, 900, 1794}, {1005, 55, 905, 1797},
    {990, 55, 900, 1800}, {985, 55, 905, 1803},
    {930, 55, 880, 1914}, {935, 55, 885, 1917}, {940, 55, 890, 1920},
    {925, 55, 885, 1923}, {920, 55, 890, 1926},
    {825, 55, 895, 2037}, {830, 55, 900, 2040}, {835, 55, 905, 2043},
    {820, 55, 900, 2046}, {815, 55, 905, 2049},
    -- 6 snowtrooper_randomPat faction-npc-hoth to hit the ~60 cap
    {883, 55, 295, 1434}, {888, 55, 300, 1437}, {893, 55, 305, 1440},
    {878, 55, 300, 1443}, {873, 55, 305, 1446}, {858, 55, 345, 1563}
  }
  for i = 1, #snow do
    local r = snow[i]
    local pMob = self:spawnOutdoorMobile("heroic_echo_snowtrooper", r[1], r[2], r[3], 0)
    if (pMob ~= nil) then
      self:trackSpine(pMob)
    end
  end
end

-- tab:784 object/building/heroic/hoth_generator.iff sid=made  507, 49, -59, yaw 90  mc=1
-- Destroyed twin tab:786 is NOT spawned until OBJECTDESTRUCTION.
function echoBase:spawnLiveGenerator()
  local pGen = self:spawnOutdoorScene("object/building/heroic/hoth_generator.iff", 507, 49, -59, 90)
  if (pGen ~= nil) then
    writeData("echoBase:generatorId", self:trackSpine(pGen))
    -- OURS, NOT SOURCED (the HP). the_bomb.java HP 150000 used as the structure analogue.
    -- Mustafar valley_battlefield.lua:825-829: setMaxCondition + OBJECTDESTRUCTION.
    TangibleObject(pGen):setMaxCondition(150000)
    TangibleObject(pGen):setConditionDamage(0)
    createObserver(OBJECTDESTRUCTION, "echoBase", "generatorDestroyed", pGen)
    createObserver(OBJECTDISABLED, "echoBase", "generatorDestroyed", pGen)
  end
end

function echoBase:generatorDestroyed(pGen, pPlayer)
  if (readData("echoBase:phase") ~= 1 or readData("echoBase:occupiedState") ~= 1) then
    return 1
  end
  -- tab:786 object/building/heroic/hoth_generator_destroyed.iff sid=destroyed
  -- triggerId=play_blow_up_generator  same 507, 49, -59, yaw 90
  if (pGen ~= nil) then
    SceneObject(pGen):destroyObjectFromWorld()
  end
  writeData("echoBase:generatorId", 0)
  local pDead = self:spawnOutdoorScene("object/building/heroic/hoth_generator_destroyed.iff", 507, 49, -59, 90)
  if (pDead ~= nil) then
    writeData("echoBase:destroyedGeneratorId", self:trackSpine(pDead))
  end
  -- tab:788 messagePlayers:generator_destroyed:none  triggerId=play_blow_up_generator
  self:broadcastSequencer("generator_destroyed")
  self:enterPhaseTwo(pPlayer)
  return 1
end

-- Faction exit shuttles: scenery from instance start. Not P3.
-- tab:5911 object/tangible/dungeon/hoth/escape_shuttle_rebel.iff
--   triggerId=imperial  1263, 55, 1555 yaw -180  script=evac_shuttle  mc=1
-- tab:6045 object/tangible/dungeon/hoth/escape_shuttle_rebel.iff
--   triggerId=rebel     -208, 71, 654  yaw -35   script=evac_shuttle  mc=1
-- evac_shuttle.java:25-28 OnObjectMenuRequest always adds
-- @sequencer_spam:exit_echo (SID_EXIT_TRIAL). No phase gate in the script
-- and no tab row that enables the radial only in P3. Radial / menu
-- component is not this round (would be a second file).
function echoBase:spawnFactionExitShuttle()
  local locX, locY, locZ, yaw
  if (self:isRebel()) then
    locX, locY, locZ, yaw = -208, 71, 654, -35
  else
    locX, locY, locZ, yaw = 1263, 55, 1555, -180
  end
  local pSh = self:spawnOutdoorScene("object/tangible/dungeon/hoth/escape_shuttle_rebel.iff", locX, locY, locZ, yaw)
  if (pSh ~= nil) then
    self:trackSpine(pSh)
  end
end

-- P3-end exit shuttle. tab:5898 triggerId=spawn_rebel_evac_shuttle
--   -466, 93, -844 yaw 86  script=evac_shuttle  mc=1
-- Fired by delayAction:spawn_rebel_evac_shuttle:10 on rebel_p3_end
-- (tab:5895) and imperial_p3_end (tab:5897) -- after phase 3, not at
-- enterPhaseThree / start_rebel_evac. Called from phaseThreeTimer.
function echoBase:spawnEscapeShuttles()
  if (readData("echoBase:occupiedState") ~= 1) then
    return
  end
  local pSh = self:spawnOutdoorScene("object/tangible/dungeon/hoth/escape_shuttle_rebel.iff", -466, 93, -844, 86)
  if (pSh ~= nil) then
    self:trackSpine(pSh)
  end
end

-- ---------------------------------------------------------------------------
-- Phase machine. echo_quest_tracker.java:183-311: PHASE 2 on
-- p1_generator_destroyed, PHASE 3 on phase3_started, -1 on phase3_complete.
-- ---------------------------------------------------------------------------

function echoBase:startPhaseOne(pPlayer)
  writeData("echoBase:phase", 1)
  writeData("echoBase:p1_ended", 0)
  -- tab:702 messagePlayers:reb_prepare_1:none  triggerId=reb_start
  -- tab:705 messagePlayers:reb_prepare_2:none  triggerId=reb_start_2
  -- tab:3976 messagePlayers:echo_imperial_conversation_1_veers_01:...:10.0
  if (self:isRebel()) then
    self:broadcastSequencer("reb_prepare_1")
    createEvent(2000, "echoBase", "barkRebelPrepare2", pPlayer, "")
  else
    createEvent(10000, "echoBase", "barkVeers01", pPlayer, "")
  end
end

function echoBase:barkRebelPrepare2(pPlayer)
  if (readData("echoBase:occupiedState") ~= 1) then
    return
  end
  self:broadcastSequencer("reb_prepare_2")
end

function echoBase:barkVeers01(pPlayer)
  if (readData("echoBase:occupiedState") ~= 1) then
    return
  end
  self:broadcastSequencer("echo_imperial_conversation_1_veers_01")
end

function echoBase:enterPhaseTwo(pPlayer)
  writeData("echoBase:phase", 2)
  writeData("echoBase:p1_ended", 1)
  -- tab:5873 signalMaster;p1_end;none  triggerId=swap_generator
  -- tab:3967 delayAction:notification_rebel_phase_2_starting:2
  -- tab:3969 delayAction:notification_imperial_phase_2_starting:2
  createEvent(2000, "echoBase", "barkPhaseTwoStarting", pPlayer, "")
  self:spawnPhaseTwoObjectives()
  -- P2 timer: delayAction:reb_com_evac:1800 tab:5756 (tid=imp_invade_front)
  -- and delayAction:imp_destroy_hangar:1800 tab:5763. OURS mapping of those
  -- delayAction rows onto the phase-2 gate (D-EBc3).
  local gen = readData("echoBase:p2TimerGen") + 1
  writeData("echoBase:p2TimerGen", gen)
  createEvent(1800 * 1000, "echoBase", "phaseTwoTimer", pPlayer, tostring(gen))
end

function echoBase:barkPhaseTwoStarting(pPlayer)
  if (readData("echoBase:occupiedState") ~= 1 or readData("echoBase:phase") ~= 2) then
    return
  end
  -- tab:3971 echo_rebel_phase_2_starting  tab:3973 echo_imperial_phase_2_starting
  if (self:isRebel()) then
    self:broadcastSequencer("echo_rebel_phase_2_starting")
  else
    self:broadcastSequencer("echo_imperial_phase_2_starting")
  end
end

function echoBase:phaseTwoTimer(pPlayer, genStr)
  if (readData("echoBase:occupiedState") ~= 1 or readData("echoBase:phase") ~= 2) then
    return
  end
  if (tonumber(genStr) ~= readData("echoBase:p2TimerGen")) then
    return
  end
  self:grantRebelEvacByTimer()
  self:enterPhaseThree(pPlayer)
end

-- Rebel evac flags that SOE grants when the delayAction evac chains complete.
-- Without NPC pathing (EB-d/f), surviving crates + the P2 timer stand in.
function echoBase:grantRebelEvacByTimer()
  if (not self:isRebel()) then
    return
  end
  if (readData("echoBase:equipLeft") > 0) then
    writeData("echoBase:equipment", 1)
  end
  if (readData("echoBase:thermalLeft") > 0) then
    writeData("echoBase:thermal", 1)
  end
  if (readData("echoBase:medLeft") > 0) then
    writeData("echoBase:medical", 1)
  end
  -- command_escape / nonescape have no crate counter this round; the timer
  -- is delayAction:reb_com_evac:1800 / the nonescape fail gate. OURS.
  writeData("echoBase:command_escape", 1)
  writeData("echoBase:nonescape", 1)
end

function echoBase:checkP2Complete(pPlayer)
  if (readData("echoBase:phase") ~= 2) then
    return
  end
  local n = 0
  if (self:isRebel()) then
    n = readData("echoBase:command_destroy") + readData("echoBase:equipment") +
        readData("echoBase:thermal") + readData("echoBase:medical") +
        readData("echoBase:command_escape") + readData("echoBase:nonescape")
  else
    n = readData("echoBase:command_capture") + readData("echoBase:hangar_capture") +
        readData("echoBase:ion_cap_destroyed") + readData("echoBase:food_destroy") +
        readData("echoBase:medical_destroy") + readData("echoBase:equipment_destroy")
  end
  -- tab:5764 waitForComplete start_rebel_evac on 6 reb_* tasks
  -- tab:5765 waitForComplete start_imperial_evac on 6 imp_destroy_* tasks
  if (n >= 6) then
    self:enterPhaseThree(pPlayer)
  end
end

function echoBase:enterPhaseThree(pPlayer)
  if (readData("echoBase:phase") ~= 2) then
    return
  end
  writeData("echoBase:phase", 3)
  writeData("echoBase:p2_ended", 1)
  -- tab:590/591 messageTo questUpdate phase3_started
  -- tab:3968 delayAction:notification_rebel_phase_3_starting:2 tid=start_rebel_evac
  -- tab:3970 delayAction:notification_imperial_phase_3_starting:2 tid=start_imperial_evac
  createEvent(2000, "echoBase", "barkPhaseThreeStarting", pPlayer, "")
  self:spawnTransports()
  -- P3 timer: delayAction:spawn_evac_st:243 tab:2431 (last evac spawn beat).
  -- OURS mapping onto the phase-3 gate. Away = survived this timer (D-EBc3).
  local gen = readData("echoBase:p3TimerGen") + 1
  writeData("echoBase:p3TimerGen", gen)
  createEvent(243 * 1000, "echoBase", "phaseThreeTimer", pPlayer, tostring(gen))
end

function echoBase:barkPhaseThreeStarting(pPlayer)
  if (readData("echoBase:occupiedState") ~= 1 or readData("echoBase:phase") ~= 3) then
    return
  end
  -- tab:3972 echo_rebel_phase_3_starting  tab:3974 echo_imperial_phase_3_starting
  if (self:isRebel()) then
    self:broadcastSequencer("echo_rebel_phase_3_starting")
  else
    self:broadcastSequencer("echo_imperial_phase_3_starting")
  end
end

-- 5 rebel_transport.iff. Registered (object/custom_content/tangible/destructible/
-- rebel_transport.lua). Same coords for both factions; triggerId start_rebel_evac
-- tab:2346-2350 vs start_imperial_evac tab:2341-2345.
-- xport_1 -414, 105.5, -737
-- xport_2 -517, 105.5, -838
-- xport_3 -635, 105.5, -829
-- xport_4 -655, 105.5, -688
-- xport_5 -577, 105.5, -608
-- Empty yaw -> 0.
function echoBase:spawnTransports()
  local rows = {
    {-414, 105.5, -737, 2346},
    {-517, 105.5, -838, 2347},
    {-635, 105.5, -829, 2348},
    {-655, 105.5, -688, 2349},
    {-577, 105.5, -608, 2350}
  }
  writeData("echoBase:xportDestroyed", 0)
  for i = 1, #rows do
    local r = rows[i]
    local pX = self:spawnOutdoorScene("object/tangible/destructible/rebel_transport.iff", r[1], r[2], r[3], 0)
    if (pX ~= nil) then
      self:trackSpine(pX)
      TangibleObject(pX):setMaxCondition(150000)
      TangibleObject(pX):setConditionDamage(0)
      createObserver(OBJECTDESTRUCTION, "echoBase", "transportDestroyed", pX)
      createObserver(OBJECTDISABLED, "echoBase", "transportDestroyed", pX)
    end
  end
end

function echoBase:transportDestroyed(pXport, pPlayer)
  if (readData("echoBase:phase") ~= 3 or readData("echoBase:occupiedState") ~= 1) then
    return 1
  end
  local n = readData("echoBase:xportDestroyed") + 1
  writeData("echoBase:xportDestroyed", n)
  if (n >= 3) then
    writeData("echoBase:p3_minor", 1)
  end
  if (n >= 5) then
    writeData("echoBase:p3_major", 1)
    -- tab:2616 messagePlayers:heroic_echo_rebel_p3_all_destroyed:none
    self:broadcastSequencer("heroic_echo_rebel_p3_all_destroyed")
  end
  return 1
end

function echoBase:phaseThreeTimer(pPlayer, genStr)
  if (readData("echoBase:occupiedState") ~= 1 or readData("echoBase:phase") ~= 3) then
    return
  end
  if (tonumber(genStr) ~= readData("echoBase:p3TimerGen")) then
    return
  end
  local destroyed = readData("echoBase:xportDestroyed")
  local away = 5 - destroyed
  if (away < 0) then
    away = 0
  end
  writeData("echoBase:xportAway", away)
  -- Rebel: 3 / 5 transports away. Imperial flags already counted on destroy.
  if (self:isRebel()) then
    if (away >= 1) then
      -- tab:5292-5296 messagePlayers:xport_away_N:none  takeoff_one..five
      local nAway = away
      if (nAway > 5) then
        nAway = 5
      end
      for i = 1, nAway do
        self:broadcastSequencer("xport_away_" .. i)
      end
    end
    if (away >= 3) then
      writeData("echoBase:xport_minor", 1)
    end
    if (away >= 5) then
      writeData("echoBase:xport_major", 1)
      -- tab:5883 messagePlayers:heroic_echo_rebel_p3_all_away:none
      self:broadcastSequencer("heroic_echo_rebel_p3_all_away")
    end
  end
  -- tab:2617 messagePlayers:heroic_echo_rebel_finish:none  triggerId=rebel_p3_end
  self:broadcastSequencer("heroic_echo_rebel_finish")
  writeData("echoBase:phase", -1)
  -- tab:5895 delayAction:spawn_rebel_evac_shuttle:10  triggerId=rebel_p3_end
  -- tab:5897 delayAction:spawn_rebel_evac_shuttle:10  triggerId=imperial_p3_end
  createEvent(10 * 1000, "echoBase", "spawnEscapeShuttles", pPlayer, "")
  self:handleVictory(pPlayer)
end

-- ---------------------------------------------------------------------------
-- P2 destructible anchors. Spawned at phase 2. Faction branches on the
-- same objects SOE gated with spawn_rebel_extras / spawn_imperial_extras.
-- ---------------------------------------------------------------------------

function echoBase:spawnPhaseTwoObjectives()
  -- Bombs, tab:5806-5811 (three unique coords; rebel/imperial extras duplicate).
  -- object/tangible/destructible/misc_bomb_object.iff  r11
  local bombs = {
    {-35, 64, 104, 5806},
    {-23, 64, 128, 5807},
    {-34, 64, 106, 5808}
  }
  writeData("echoBase:bombLeft", 0)
  for i = 1, #bombs do
    local r = bombs[i]
    local pBomb = self:spawnSceneInCell("object/tangible/destructible/misc_bomb_object.iff", "r11", r[1], r[2], r[3], 0)
    if (pBomb ~= nil) then
      TangibleObject(pBomb):setMaxCondition(150000)
      TangibleObject(pBomb):setConditionDamage(0)
      writeData(SceneObject(pBomb):getObjectID() .. ":echoBaseP2", 5)
      writeData("echoBase:bombLeft", readData("echoBase:bombLeft") + 1)
      createObserver(OBJECTDESTRUCTION, "echoBase", "p2ObjectDestroyed", pBomb)
      createObserver(OBJECTDISABLED, "echoBase", "p2ObjectDestroyed", pBomb)
    end
  end
  -- the_bomb.java start_detonate default 900 s. If bombs remain, treat as detonation.
  createEvent(900 * 1000, "echoBase", "bombDetonateTimer", nil, "")

  self:spawnP2CrateSet("object/tangible/destructible/destructable_crate_02.iff", "r58", {
    {-179, -20, 551, 3783}, {-179, -20, 549, 3784}, {-138, -20, 539, 3787},
    {-135, -20, 533, 3789}, {-175, -20, 549, 3790}
  }, "object/tangible/destructible/destructable_crate_04.iff", {
    {-168, -19, 555, 3785}, {-138, -20, 541, 3786}, {-135, -20, 535, 3788},
    {-167, -20, 512, 3791}, {-172, -20, 512, 3792}
  }, 1, "equipLeft")

  self:spawnP2CrateSet("object/tangible/destructible/destructable_crate_02.iff", "r51", {
    {107, -14, 299, 4489}, {108, -14, 301, 4490}, {92, -14, 314, 4491},
    {90, -14, 315, 4494}, {68, -14, 293, 4497}, {67, -14, 292, 4498}
  }, "object/tangible/destructible/destructable_crate_04.iff", {
    {72, -14, 275, 4492}, {71, -14, 276, 4493}, {81, -14, 308, 4495}, {70, -14, 295, 4496}
  }, 2, "medLeft")

  self:spawnP2CrateSet("object/tangible/destructible/destructable_crate_02.iff", "tauntaun_grounds", {
    {-202, 22, 113, 4642}, {-217, 22, 165, 4643}
  }, "object/tangible/destructible/destructable_crate_04.iff", {
    {-192, 22, 118, 4640}, {-197, 22, 114, 4641}, {-215, 22, 172, 4644}, {-210, 22, 171, 4645}
  }, 3, "foodLeft")

  -- thermal, tab:4884-4888 r27  spawn_rebel_extras
  self:spawnP2CrateSet("object/tangible/destructible/destructable_crate_02.iff", "r27", {
    {-188, -21.5, 158, 4885}, {-192, -23.5, 154, 4886}, {-192, -21.5, 154, 4887}
  }, "object/tangible/destructible/destructable_crate_04.iff", {
    {-188, -23.5, 158, 4884}, {-193, -23.5, 153, 4888}
  }, 4, "thermalLeft")

  -- Ion capacitor: SOE is trigger:ion_cannon_capicator_destroyed tab:4477
  -- r32 -63, -4, 9 -- no object template. OURS stand-in: 4point_power_generator.iff
  -- (registered). Imperial only.
  if (not self:isRebel()) then
    local pIon = self:spawnSceneInCell("object/tangible/destructible/4point_power_generator.iff", "r32", -63, -4, 9, 0)
    if (pIon ~= nil) then
      TangibleObject(pIon):setMaxCondition(150000)
      TangibleObject(pIon):setConditionDamage(0)
      writeData(SceneObject(pIon):getObjectID() .. ":echoBaseP2", 6)
      writeData("echoBase:ionLeft", 1)
      createObserver(OBJECTDESTRUCTION, "echoBase", "p2ObjectDestroyed", pIon)
      createObserver(OBJECTDISABLED, "echoBase", "p2ObjectDestroyed", pIon)
    end
    -- Hangar capture stand-in for tab:4716-4717 trigger imp_hangar_1/2
    -- r15 -227.2, 95.23, 541. OURS: one crate at that cell-local coord.
    local pHang = self:spawnSceneInCell("object/tangible/destructible/destructable_crate_04.iff", "r15", -227.2, 95.23, 541, 0)
    if (pHang ~= nil) then
      TangibleObject(pHang):setMaxCondition(20000)
      TangibleObject(pHang):setConditionDamage(0)
      writeData(SceneObject(pHang):getObjectID() .. ":echoBaseP2", 7)
      writeData("echoBase:hangarLeft", 1)
      createObserver(OBJECTDESTRUCTION, "echoBase", "p2ObjectDestroyed", pHang)
      createObserver(OBJECTDISABLED, "echoBase", "p2ObjectDestroyed", pHang)
    end
  end

  -- Light interior opposition so P2 is not an empty POB. Faction-branched.
  -- OURS, NOT SOURCED (playable count; SOE rows 5934-5981 spawn_rebel_extras
  -- invaders / 4296-5915 spawn_imperial_extras). Four per faction from P2
  -- objective rooms. Empty yaw -> 0. heroic_echo_rebel_commando_interior is
  -- not registered; spawn heroic_echo_rebel_commando at those coords.
  if (self:isRebel()) then
    -- tab:5974 heroic_echo_stormcommando spawn_rebel_extras r11 -29, 64, 113
    self:spawnInCell("heroic_echo_stormcommando", "r11", -29, 64, 113, 0)
    -- tab:5975 heroic_echo_stormcommando spawn_rebel_extras r11 -21, 64, 106
    self:spawnInCell("heroic_echo_stormcommando", "r11", -21, 64, 106, 0)
    -- tab:5946 heroic_echo_stormcommando spawn_rebel_extras r51 101, -14, 297 yaw -121
    self:spawnInCell("heroic_echo_stormcommando", "r51", 101, -14, 297, -121)
    -- tab:5962 heroic_echo_stormcommando spawn_rebel_extras r58 -188, -20, 520
    self:spawnInCell("heroic_echo_stormcommando", "r58", -188, -20, 520, 0)
  else
    -- tab:4795 heroic_echo_rebel_commando_interior spawn_imperial_extras r11 -29, 64, 119
    self:spawnInCell("heroic_echo_rebel_commando", "r11", -29, 64, 119, 0)
    -- tab:4798 heroic_echo_rebel_commando_interior spawn_imperial_extras r11 -7, 64, 105
    self:spawnInCell("heroic_echo_rebel_commando", "r11", -7, 64, 105, 0)
    -- tab:5915 heroic_echo_rebel_phalax_guard spawn_imperial_extras r11 -19, 64, 109 yaw 0
    self:spawnInCell("heroic_echo_rebel_phalax_guard", "r11", -19, 64, 109, 0)
    -- tab:5731 heroic_echo_rebel_phalax_commander spawn_imperial_extras r15 -266, 76, 486 yaw 166
    self:spawnInCell("heroic_echo_rebel_phalax_commander", "r15", -266, 76, 486, 166)
  end
end

function echoBase:spawnP2CrateSet(t02, cellName, rows02, t04, rows04, typeCode, counterKey)
  writeData("echoBase:" .. counterKey, 0)
  for i = 1, #rows02 do
    self:spawnOneP2Crate(t02, cellName, rows02[i], typeCode, counterKey)
  end
  for i = 1, #rows04 do
    self:spawnOneP2Crate(t04, cellName, rows04[i], typeCode, counterKey)
  end
end

function echoBase:spawnOneP2Crate(template, cellName, row, typeCode, counterKey)
  local pCrate = self:spawnSceneInCell(template, cellName, row[1], row[2], row[3], 0)
  if (pCrate ~= nil) then
    TangibleObject(pCrate):setMaxCondition(20000)
    TangibleObject(pCrate):setConditionDamage(0)
    writeData(SceneObject(pCrate):getObjectID() .. ":echoBaseP2", typeCode)
    writeData("echoBase:" .. counterKey, readData("echoBase:" .. counterKey) + 1)
    createObserver(OBJECTDESTRUCTION, "echoBase", "p2ObjectDestroyed", pCrate)
    createObserver(OBJECTDISABLED, "echoBase", "p2ObjectDestroyed", pCrate)
  end
end

function echoBase:p2ObjectDestroyed(pObj, pPlayer)
  if (pObj == nil or readData("echoBase:phase") ~= 2 or readData("echoBase:p2_ended") == 1) then
    return 1
  end
  local oid = SceneObject(pObj):getObjectID()
  local t = readData(oid .. ":echoBaseP2")
  writeData(oid .. ":echoBaseP2", 0)
  if (t == 1) then
    local n = readData("echoBase:equipLeft") - 1
    if (n < 0) then n = 0 end
    writeData("echoBase:equipLeft", n)
    if (n == 0 and not self:isRebel()) then
      writeData("echoBase:equipment_destroy", 1)
    end
  elseif (t == 2) then
    local n = readData("echoBase:medLeft") - 1
    if (n < 0) then n = 0 end
    writeData("echoBase:medLeft", n)
    if (n == 0 and not self:isRebel()) then
      writeData("echoBase:medical_destroy", 1)
    end
  elseif (t == 3) then
    local n = readData("echoBase:foodLeft") - 1
    if (n < 0) then n = 0 end
    writeData("echoBase:foodLeft", n)
    if (n == 0 and not self:isRebel()) then
      writeData("echoBase:food_destroy", 1)
    end
  elseif (t == 4) then
    local n = readData("echoBase:thermalLeft") - 1
    if (n < 0) then n = 0 end
    writeData("echoBase:thermalLeft", n)
  elseif (t == 5) then
    local n = readData("echoBase:bombLeft") - 1
    if (n < 0) then n = 0 end
    writeData("echoBase:bombLeft", n)
    if (n == 0) then
      if (self:isRebel()) then
        writeData("echoBase:command_destroy", 1)
      else
        writeData("echoBase:command_capture", 1)
      end
    end
  elseif (t == 6) then
    writeData("echoBase:ionLeft", 0)
    writeData("echoBase:ion_cap_destroyed", 1)
  elseif (t == 7) then
    writeData("echoBase:hangarLeft", 0)
    writeData("echoBase:hangar_capture", 1)
  end
  self:checkP2Complete(pPlayer)
  return 1
end

function echoBase:bombDetonateTimer()
  if (readData("echoBase:phase") ~= 2 or readData("echoBase:occupiedState") ~= 1) then
    return
  end
  if (readData("echoBase:bombLeft") > 0 and self:isRebel()) then
    -- the_bomb.java detonates and fires p2_rebel_command_destroy
    writeData("echoBase:bombLeft", 0)
    writeData("echoBase:command_destroy", 1)
    self:checkP2Complete(nil)
  end
end

-- ---------------------------------------------------------------------------
-- Barks. D-EBc5: @sequencer_spam:<key> from messagePlayers rows. No English.
-- NOT the two "[Testing]" keys (echo_generator_destroyed_starting_invasion_60,
-- echo_secondary_generator_destroyed_evac_60) and not the six testing_rebel_*
-- rows (tab:5767-5784, spawn_id=idiot).
--
-- 33 messagePlayers rows transcribed (tab line : key : speakerIff : delay : triggerId):
--  702 reb_prepare_1 : none : reb_start
--  705 reb_prepare_2 : none : reb_start_2
--  788 generator_destroyed : none : play_blow_up_generator
-- 2616 heroic_echo_rebel_p3_all_destroyed : none : rebel_p3_xport_fail
-- 2617 heroic_echo_rebel_finish : none : rebel_p3_end
-- 2963 echo_rebel_rieekan_reroute : dressed_rebel_general_rieekan_01.iff : 10.0 : echo_base_storyline_1a
-- 3036 echo_rebel_conversation_4_trenches_01 : rebel_snow_m_01.iff : 3.0 : echo_base_storyline_11
-- 3061 echo_rebel_conversation_2_command_01 : dressed_rebel_general_rieekan_01.iff : 5.0 : echo_base_storyline_11
-- 3067 echo_rebel_conversation_2_command_03 : dressed_rebel_communication_female_01.iff : 3.0 : echo_base_storyline_13
-- 3071 echo_rebel_conversation_2_command_04 : dressed_rebel_communication_female_01.iff : 3.0 : echo_base_storyline_14
-- 3074 echo_rebel_announcement_01 : dressed_rebel_snow_echo_base_m_01.iff : 3.0 : echo_base_storyline_15
-- 3193 echo_rebel_conversation_7_command_08 : dressed_rebel_snow_echo_base_m_01.iff : 3.0 : echo_base_storyline_49
-- 3971 echo_rebel_phase_2_starting : none : notification_rebel_phase_2_starting
-- 3972 echo_rebel_phase_3_starting : none : notification_rebel_phase_3_starting
-- 3973 echo_imperial_phase_2_starting : none : notification_imperial_phase_2_starting
-- 3974 echo_imperial_phase_3_starting : none : notification_imperial_phase_3_starting
-- 3976 echo_imperial_conversation_1_veers_01 : veers.iff : 10.0 : echo_base_imperial_storyline_1
-- 3979 echo_imperial_conversation_1_veers_02 : veers.iff : 5.0 : echo_base_imperial_storyline_2
-- 3980 echo_imperial_conversation_1_veers_03 : veers.iff : 3.0 : swap_generator
-- 3984 echo_imperial_conversation_1_veers_04 : dressed_imperial_atat_pilot_m.iff : 3.0 : echo_base_imperial_storyline_3
-- 3986 echo_imperial_conversation_1_veers_05 : veers.iff : 3.0 : echo_base_imperial_storyline_4
-- 5292-5296 xport_away_1..5 : none : takeoff_one..five
-- 5767-5784 testing_rebel_* SKIPPED (spawn_id=idiot)
-- 5883 heroic_echo_rebel_p3_all_away : none : p3_rebel_major
-- Cinematic conversation beats (2963-3193, 3979-3986) need storyline NPCs
-- this round does not spawn; keys are transcribed, not fired.
-- @sequencer_spam:reb_prepare_1
-- @sequencer_spam:reb_prepare_2
-- @sequencer_spam:generator_destroyed
-- @sequencer_spam:heroic_echo_rebel_p3_all_destroyed
-- @sequencer_spam:heroic_echo_rebel_finish
-- @sequencer_spam:echo_rebel_rieekan_reroute
-- @sequencer_spam:echo_rebel_conversation_4_trenches_01
-- @sequencer_spam:echo_rebel_conversation_2_command_01
-- @sequencer_spam:echo_rebel_conversation_2_command_03
-- @sequencer_spam:echo_rebel_conversation_2_command_04
-- @sequencer_spam:echo_rebel_announcement_01
-- @sequencer_spam:echo_rebel_conversation_7_command_08
-- @sequencer_spam:echo_rebel_phase_2_starting
-- @sequencer_spam:echo_rebel_phase_3_starting
-- @sequencer_spam:echo_imperial_phase_2_starting
-- @sequencer_spam:echo_imperial_phase_3_starting
-- @sequencer_spam:echo_imperial_conversation_1_veers_01
-- @sequencer_spam:echo_imperial_conversation_1_veers_02
-- @sequencer_spam:echo_imperial_conversation_1_veers_03
-- @sequencer_spam:echo_imperial_conversation_1_veers_04
-- @sequencer_spam:echo_imperial_conversation_1_veers_05
-- @sequencer_spam:xport_away_1
-- @sequencer_spam:xport_away_2
-- @sequencer_spam:xport_away_3
-- @sequencer_spam:xport_away_4
-- @sequencer_spam:xport_away_5
-- @sequencer_spam:heroic_echo_rebel_p3_all_away
-- ---------------------------------------------------------------------------

function echoBase:broadcastSequencer(key)
  local pBuilding = self:getBuildingObject()
  if (pBuilding == nil) then
    return
  end
  -- OURS, NOT SOURCED (2500 m). Lev's 300 m group range does not cover the
  -- 2,327 x 2,434 m outdoor battlefield (research-echo-base.md §1.4).
  local players = SceneObject(pBuilding):getPlayersInRange(2500)
  local msg = "@sequencer_spam:" .. key
  if (players ~= nil) then
    for i = 1, #players do
      local pNear = players[i]
      if (pNear ~= nil and CreatureObject(pNear):isPlayerCreature()) then
        CreatureObject(pNear):sendSystemMessage(msg)
      end
    end
  end
end

-- ---------------------------------------------------------------------------
-- Victory. D-EBc6: handleVictory -> SuiMessageBox of objective results, then
-- awardTokenToAll. Token = object/tangible/loot/misc/echo_base_token.iff x
-- tokenCount (SOE tokenIndex 5; heroicTokenBonus = 1). Flawless painting at
-- tokenCount == 9 with per-player writeData("echoBase:flawless:<oid>:<run>", 1).
-- champion_of_hoth recorded, waiting on collections (no badge_map row).
-- ---------------------------------------------------------------------------

function echoBase:handleVictory(pPlayer)
  if (readData("echoBase:awarded") == 1) then
    return
  end
  writeData("echoBase:awarded", 1)
  self:winSuiDisplay(pPlayer)
  self:awardTokenToAll(pPlayer)
  -- OURS, NOT SOURCED (30 s). Lev resets immediately (starDestroyer.lua:873-875);
  -- the SUI would be yanked. Delay so the scoreboard can be read.
  createEvent(30 * 1000, "echoBase", "victoryCleanup", pPlayer, "")
end

function echoBase:victoryCleanup(pPlayer)
  if (pPlayer == nil) then
    return
  end
  self:resetInstance(pPlayer)
  self:ejectAllPlayers(pPlayer)
end

function echoBase:winSuiCallback(pPlayer, pSui, eventIndex, args)
end

-- Transcribed from echo_controller.java:204-603 winSuiDisplay. Color codes and
-- English lines are SOE's, not authored barks.
function echoBase:buildRebelWinMessage()
  local AtatMinor = readData("echoBase:at_minor")
  local AtatMajor = readData("echoBase:at_major")
  local p1VictoryMinor = false
  local p1VictoryMajor = false
  if (AtatMajor ~= 1) then
    if (AtatMinor == 1) then
      p1VictoryMinor = true
    end
  else
    p1VictoryMajor = true
  end
  local p1Tokens = 0
  if (p1VictoryMajor) then
    p1Tokens = 3
  elseif (p1VictoryMinor) then
    p1Tokens = 1
  end
  local winCount = 0
  local p2VictoryMinor = false
  local p2VictoryMajor = false
  local command_destroy = readData("echoBase:command_destroy")
  if (command_destroy == 1) then winCount = winCount + 1 end
  local equipment = readData("echoBase:equipment")
  if (equipment == 1) then winCount = winCount + 1 end
  local thermal = readData("echoBase:thermal")
  if (thermal == 1) then winCount = winCount + 1 end
  local medical = readData("echoBase:medical")
  if (medical == 1) then winCount = winCount + 1 end
  local command_escape = readData("echoBase:command_escape")
  if (command_escape == 1) then winCount = winCount + 1 end
  local nonescape = readData("echoBase:nonescape")
  if (nonescape == 1) then winCount = winCount + 1 end
  if (winCount < 6) then
    if (winCount >= 3) then
      p2VictoryMinor = true
    end
  else
    p2VictoryMajor = true
  end
  local p2Tokens = 0
  if (p2VictoryMajor) then
    p2Tokens = 3
  elseif (p2VictoryMinor) then
    p2Tokens = 1
  end
  local xport_minor = readData("echoBase:xport_minor")
  local xport_major = readData("echoBase:xport_major")
  local p3VictoryMinor = false
  local p3VictoryMajor = false
  if (xport_major ~= 1) then
    if (xport_minor == 1) then
      p3VictoryMinor = true
    end
  else
    p3VictoryMajor = true
  end
  local p3Tokens = 0
  if (p3VictoryMajor) then
    p3Tokens = 3
  elseif (p3VictoryMinor) then
    p3Tokens = 1
  end
  local message = " \\#FFFFFFNorth BattleField: (\\#FBEC5D" .. p1Tokens .. " \\#FFFFFFtokens)\n"
  if (not p1VictoryMajor and not p1VictoryMinor) then
    message = message .. " \\#FF0000You failed to stop the Imperial Walkers\n"
  elseif (p1VictoryMajor) then
    message = message .. " \\#00FF00Your Heroic efforts on the North Battlefield saved many lives.\n"
  elseif (p1VictoryMinor) then
    message = message .. " \\#FF6103You did your best to stop those Imperial Walkers.\n"
  end
  message = message .. " \\#FFFFFFEcho Base Interior: (\\#FBEC5D" .. p2Tokens .. " \\#FFFFFFtokens)\n"
  if (not p2VictoryMajor and not p2VictoryMinor) then
    message = message .. " \\#FF0000Despite your best efforts, not many personnel escaped.\n"
  elseif (p2VictoryMajor) then
    message = message .. " \\#00FF00Your Coordinated retreat allowed everyone to escape.\n"
  elseif (p2VictoryMinor) then
    message = message .. " \\#FF6103You manged to get most of the personnel out.\n"
  end
  if (command_destroy == 1) then
    message = message .. " \t\\#00FF00Destroyed Command Center\n"
  else
    message = message .. " \t\\#FF0000Destroyed Command Center\n"
  end
  if (equipment == 1) then
    message = message .. " \t\\#00FF00Equipment Evacuated\n"
  else
    message = message .. " \t\\#FF0000Equipment Evacuated\n"
  end
  if (thermal == 1) then
    message = message .. " \t\\#00FF00Thermal Generator Personnel Evacuated\n"
  else
    message = message .. " \t\\#FF0000Thermal Generator Personnel Evacuated\n"
  end
  if (medical == 1) then
    message = message .. " \t\\#00FF00Medical Personnel Evacuated\n"
  else
    message = message .. " \t\\#FF0000Medical Personnel Evacuated\n"
  end
  if (command_escape == 1) then
    message = message .. " \t\\#00FF00Command Personnel Evacuated\n"
  else
    message = message .. " \t\\#FF0000Command Personnel Evacuated\n"
  end
  if (nonescape == 1) then
    message = message .. " \t\\#00FF00Non-Essential Personnel Evacuated\n"
  else
    message = message .. " \t\\#FF0000Non-Essential Personnel Evacuated\n"
  end
  message = message .. " \\#FFFFFFEvacuation Area: (\\#FBEC5D" .. p3Tokens .. " \\#FFFFFFtokens)\n"
  if (not p3VictoryMajor and not p3VictoryMinor) then
    message = message .. " \\#FF0000Despite your best efforts, none of the transport got away.\n"
  elseif (p3VictoryMajor) then
    message = message .. " \\#00FF00All transports were loaded and got away safely.\n"
  elseif (p3VictoryMinor) then
    message = message .. " \\#FF6103You did your best to get as many transports away as you could."
  end
  -- wampa_boss_dead is logged in SOE CS and shown nowhere in the SUI; worth zero.
  return message
end

function echoBase:buildImperialWinMessage()
  local fail_major = readData("echoBase:fail_major")
  local fail_minor = readData("echoBase:fail_minor")
  local p1VictoryMinor = false
  local p1VictoryMajor = false
  if (fail_major ~= 0) then
    if (fail_minor == 0) then
      p1VictoryMinor = true
    end
  else
    p1VictoryMajor = true
  end
  local p1Tokens = 0
  if (p1VictoryMajor) then
    p1Tokens = 3
  elseif (p1VictoryMinor) then
    p1Tokens = 1
  end
  local winCount = 0
  local p2VictoryMinor = false
  local p2VictoryMajor = false
  local command_capture = readData("echoBase:command_capture")
  if (command_capture == 1) then winCount = winCount + 1 end
  local hangar_capture = readData("echoBase:hangar_capture")
  if (hangar_capture == 1) then winCount = winCount + 1 end
  local ion_cap_destroyed = readData("echoBase:ion_cap_destroyed")
  if (ion_cap_destroyed == 1) then winCount = winCount + 1 end
  local food_destroy = readData("echoBase:food_destroy")
  if (food_destroy == 1) then winCount = winCount + 1 end
  local medical_destroy = readData("echoBase:medical_destroy")
  if (medical_destroy == 1) then winCount = winCount + 1 end
  local equipment_destroy = readData("echoBase:equipment_destroy")
  if (equipment_destroy == 1) then winCount = winCount + 1 end
  if (winCount < 6) then
    if (winCount >= 3) then
      p2VictoryMinor = true
    end
  else
    p2VictoryMajor = true
  end
  local p2Tokens = 0
  if (p2VictoryMajor) then
    p2Tokens = 3
  elseif (p2VictoryMinor) then
    p2Tokens = 1
  end
  local xport_minor = readData("echoBase:p3_minor")
  local xport_major = readData("echoBase:p3_major")
  local p3VictoryMinor = false
  local p3VictoryMajor = false
  if (xport_major ~= 1) then
    if (xport_minor == 1) then
      p3VictoryMinor = true
    end
  else
    p3VictoryMajor = true
  end
  local p3Tokens = 0
  if (p3VictoryMajor) then
    p3Tokens = 3
  elseif (p3VictoryMinor) then
    p3Tokens = 1
  end
  local message = " \\#FFFFFFNorth BattleField: (\\#FBEC5D" .. p1Tokens .. " \\#FFFFFFtokens)\n"
  if (not p1VictoryMajor and not p1VictoryMinor) then
    message = message .. " \\#FF0000Field of Battle won with heavy casualties\n\n"
  elseif (p1VictoryMajor) then
    message = message .. " \\#00FF00Field of Battle won with no casualties.\n\n"
  elseif (p1VictoryMinor) then
    message = message .. " \\#FF6103Field of Battle won with few casualties.\n\n"
  end
  message = message .. " \\#FFFFFFEcho Base Interior: (\\#FBEC5D" .. p2Tokens .. " \\#FFFFFFtokens)\n"
  if (not p2VictoryMajor and not p2VictoryMinor) then
    message = message .. " \\#FF0000You failed to stop the Rebels from evacuating key personnel and supplies.\n"
  elseif (p2VictoryMajor) then
    message = message .. " \\#00FF00The Rebels were unable to evacuate any key personnel or supplies.\n"
  elseif (p2VictoryMinor) then
    message = message .. " \\#FF6103The Rebels were only able to escape with a few Key personnel and supplies\n"
  end
  if (command_capture == 1) then
    message = message .. " \t\\#00FF00Captured Command Center\n"
  else
    message = message .. " \t\\#FF0000Captured Command Center\n"
  end
  if (hangar_capture == 1) then
    message = message .. " \t\\#00FF00Main Hangar Captured\n"
  else
    message = message .. " \t\\#FF0000Main Hangar Captured\n"
  end
  if (ion_cap_destroyed == 1) then
    message = message .. " \t\\#00FF00Ion Cannon Capacitor Destroyed\n"
  else
    message = message .. " \t\\#FF0000Ion Cannon Capacitor Destroyed\n"
  end
  if (food_destroy == 1) then
    message = message .. " \t\\#00FF00Food Supplies Destroyed \n"
  else
    message = message .. " \t\\#FF0000Food Supplies Destroyed \n"
  end
  if (medical_destroy == 1) then
    message = message .. " \t\\#00FF00Medical Supplies Destroyed\n"
  else
    message = message .. " \t\\#FF0000Medical Supplies Destroyed\n"
  end
  if (equipment_destroy == 1) then
    message = message .. " \t\\#00FF00Equipment Stores Destroyed\n\n"
  else
    message = message .. " \t\\#FF0000Equipment Stores Destroyed\n\n"
  end
  message = message .. " \\#FFFFFFEvacuation Area: (\\#FBEC5D" .. p3Tokens .. " \\#FFFFFFtokens)\n"
  if (not p3VictoryMajor and not p3VictoryMinor) then
    message = message .. " \\#FF0000You failed in your task, all transports got away.\n"
  elseif (p3VictoryMajor) then
    message = message .. " \\#00FF00You performed greatly for your Empire, no transports escaped.\n"
  elseif (p3VictoryMinor) then
    message = message .. " \\#FF6103You destroyed many of the transports before they could take off."
  end
  return message
end

function echoBase:winSuiDisplay(pPlayer)
  if (pPlayer == nil) then
    return
  end
  local title
  local prompt
  if (self:isRebel()) then
    title = "Alliance: Echo Base"
    prompt = self:buildRebelWinMessage()
  else
    title = "Imperial: Echo Base"
    prompt = self:buildImperialWinMessage()
  end
  self:sendWinSui(pPlayer, title, prompt)
  if (CreatureObject(pPlayer):isGrouped()) then
    local groupSize = CreatureObject(pPlayer):getGroupSize()
    for i = 0, groupSize - 1, 1 do
      local pMember = CreatureObject(pPlayer):getGroupMember(i)
      if (pMember ~= nil and pMember ~= pPlayer
          and CreatureObject(pPlayer):isInRangeWithObject(pMember, 300)
          and not SceneObject(pMember):isAiAgent()) then
        self:sendWinSui(pMember, title, prompt)
      end
    end
  end
end

function echoBase:sendWinSui(pPlayer, title, prompt)
  local sui = SuiMessageBox.new("echoBase", "winSuiCallback")
  sui.setTitle(title)
  sui.setPrompt(prompt)
  sui.setOkButtonText("Ok")
  sui.hideCancelButton()
  sui.sendTo(pPlayer)
end

-- starDestroyer.lua:821-871. Count from rebelTokenCount / imperialTokenCount.
-- player_instance.java:677-727 handleAwardtoken; heroicTokenBonus multiplier is 1.
function echoBase:awardToken(pPlayer)
  if (pPlayer == nil) then
    return
  end
  local oid = SceneObject(pPlayer):getObjectID()
  local tokenKey = "echoBase:token:" .. oid .. ":" .. readData("echoBaseStartTime")
  if (readData(tokenKey) == 1) then
    return
  end
  local pInventory = CreatureObject(pPlayer):getSlottedObject("inventory")
  if (pInventory == nil) then
    return
  end
  local count = self:tokenCount()
  if (count < 1) then
    writeData(tokenKey, 1)
    return
  end
  local granted = 0
  for i = 1, count do
    local pToken = giveItem(pInventory, "object/tangible/loot/misc/echo_base_token.iff", -1, true)
    if (pToken ~= nil) then
      SceneObject(pToken):sendTo(pPlayer)
      granted = granted + 1
    end
  end
  if (granted > 0) then
    writeData(tokenKey, 1)
    -- SOURCED: player_instance.java:709-717 @set_bonus:recieve_heroic_token(_multi)
    if (granted > 1) then
      CreatureObject(pPlayer):sendSystemMessage("@set_bonus:recieve_heroic_token_multi")
    else
      CreatureObject(pPlayer):sendSystemMessage("@set_bonus:recieve_heroic_token")
    end
  end
  -- player_instance.java:718-725: tokenIndex == 5 && count == 9
  -- badge.grantBadge(self, "champion_of_hoth") -- NOT THIS ROUND (no badge_map row)
  if (count == 9) then
    local run = readData("echoBaseStartTime")
    local flawKey = "echoBase:flawless:" .. oid .. ":" .. run
    if (readData(flawKey) ~= 1) then
      local pPaint = giveItem(pInventory, "object/tangible/furniture/decorative/heroic_hoth_painting.iff", -1, true)
      if (pPaint ~= nil) then
        SceneObject(pPaint):sendTo(pPlayer)
        writeData(flawKey, 1)
      end
    end
  end
end

function echoBase:awardTokenToAll(pPlayer)
  createEvent(1000, "echoBase", "awardToken", pPlayer, "")
  if (CreatureObject(pPlayer):isGrouped()) then
    local groupSize = CreatureObject(pPlayer):getGroupSize()
    for i = 0, groupSize - 1, 1 do
      local pMember = CreatureObject(pPlayer):getGroupMember(i)
      if (pMember ~= nil and pMember ~= pPlayer
          and CreatureObject(pPlayer):isInRangeWithObject(pMember, 300)
          and not SceneObject(pMember):isAiAgent()) then
        self:awardToken(pMember)
      end
    end
  end
end
