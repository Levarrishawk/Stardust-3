-- Star Destroyer Instanced Dungeon: authored for Stardust 3, round H(sd).
-- Structure copied from Levarris' exarKun.lua / axkvaMin.lua; content transcribed from
-- SOE's SRC/datatables/spawning/heroic/heroic_star_destroyer.tab and
-- SRC/script/theme_park/heroic/star_destroyer/*.java. Every authored value labelled OURS.
--
-- Reset hygiene mirrored from ig88.lua (clearEncounterKeys / destroyArenaContents):
-- the SD building is spawned at persistence 0, so leftover mobiles in the 58 cells
-- must be destroyed on every non-persist reset path, and every writeData key this
-- screenplay sets must be cleared on timeout, EXITEDBUILDING, and victory.
-- Instance system messages ("That area is currently unavailable", "currently occupied", "Instance Started",
-- "You decline to enter", "riding a mount", "being removed", "have left the dungeon", "has been reset") are
-- classification (c): Lev's own English, copied verbatim from axkvaMin.lua:29,34,43,94,1016,1031,1038 and
-- exarKun.lua:122 (mount). The token award message is OURS, NOT SOURCED, labelled at its line. (fix-2)
local ObjectManager = require("managers.object.object_manager")

starDestroyer = ScreenPlay:new {
	

}

registerScreenPlay("starDestroyer", true)

function starDestroyer:start()
	if (isZoneEnabled("dungeon1")) then
    self:spawnTheShip()
    writeData("starDestroyer:trashSpawnState", 0)
    writeData("starDestroyer:bossOneSpawnState", 0)
    writeData("starDestroyer:bossOneTrashState", 0)
    writeData("starDestroyer:bossOneDead", 0)
    writeData("starDestroyer:bossTwoDead", 0)
    writeData("starDestroyer:bossThreeDead", 0)
    writeData("starDestroyer:bossFourDead", 0)
    writeData("starDestroyer:occupiedState", 0)
	end
end

-- OURS, NOT SOURCED (the whole placement). SOE placed this building through
-- datatables/buildout/dungeon1/heroic_star_destroyer.tab, which ships in no loaded TRE.
-- Template is SD3's own already-registered base template, object/building/general/
-- serverobjects.lua:163 -> object/building/general/space_dungeon_star_destroyer.lua:48.
-- Its shared client template (objects.lua:7174-7234) carries
-- portalLayoutFilename = "appearance/thm_spc_star_destroyer_s01.pob" -- 58 interior cells.
-- Shape: ig88:start() -> spawnArena() (ig88.lua:58-108). Guarded existing-id so a
-- screenplay reload does not drop a second ship.
function starDestroyer:spawnTheShip()
  local existing = getSceneObject(readData("starDestroyer:buildingId"))
  if (existing ~= nil) then
    return
  end
  local pSD = spawnSceneObject("dungeon1",
          "object/building/general/space_dungeon_star_destroyer.iff",
          -3000, 0, -3000,      -- x, z(height), y   -- OURS, see PART 3.3
          0, math.rad(0))
  if (pSD ~= nil) then
    writeData("starDestroyer:buildingId", SceneObject(pSD):getObjectID())
    -- Building exists now; hangar ENTEREDAREA can resolve secondaryhangar.
    self:spawnBossRoomOneActiveArea()
  end
end


function starDestroyer:activate(pPlayer)
	if (not isZoneEnabled("dungeon1")) then
		CreatureObject(pPlayer):sendSystemMessage("That area is currently unavailable. Please try again later.") 
		return false
	end
	
	if (readData("starDestroyer:occupiedState") == 1) then
	   CreatureObject(pPlayer):sendSystemMessage("That instance is currently occupied, please try a different instance.")
	   return false
	end   
	   
  
  local pSD = self:getBuildingObject()
  if (pSD == nil) then
    CreatureObject(pPlayer):sendSystemMessage("That area is currently unavailable. Please try again later.")
    return false
  end
  
  writeData("starDestroyerStartTime", os.time()) 
  
  CreatureObject(pPlayer):sendSystemMessage("Instance Started: You have 60 minutes remaining to complete the instance.") 
  createEvent(1000, "starDestroyer", "transportPlayer", pPlayer, "")
     
  createObserver(EXITEDBUILDING, "starDestroyer", "resetInstanceA", pSD, "")
  
	if (CreatureObject(pPlayer):isGrouped()) then
		local groupSize = CreatureObject(pPlayer):getGroupSize()

		for i = 0, groupSize - 1, 1 do
			local pMember = CreatureObject(pPlayer):getGroupMember(i)
			if pMember ~= nil and pMember ~= pPlayer and CreatureObject(pPlayer):isInRangeWithObject(pMember, 50) and not SceneObject(pMember):isAiAgent() then
				self:sendAuthorizationSui(pMember, pPlayer)
			end
		end
	end
	
	createEvent(100, "starDestroyer", "spawnCheck", pPlayer, "")
	createEvent(100, "starDestroyer", "spawnBossOneCheck", pPlayer, "")
	
	writeData("starDestroyer:occupiedState", 1)  -- TO DO: Need to create the timer and conditions to reset the state of the instance.
	createEvent(1000, "starDestroyer", "checkIfActiveForTimer", pPlayer, "")

	return true
end



function starDestroyer:sendAuthorizationSui(pPlayer, pLeader)
	if (pPlayer == nil) then
		return
	end	

	local sui = SuiMessageBox.new("starDestroyer", "authorizationSuiCallback")
    
	sui.setTitle("The Blackguard")                                     -- OURS, NOT SOURCED
	-- "Blackguard" is sourced: SRC/script/conversation/station_heroic_star_destroyer.java:24
	-- setName(self, "Blackguard"). The sentence around it is OURS.
	sui.setPrompt(CreatureObject(pLeader):getFirstName() ..
	    " has granted you authorization to board the Star Destroyer Blackguard.  Do you accept this travel offer?")
	                                                                    -- OURS, NOT SOURCED
	sui.setOkButtonText("Yes")
	sui.setCancelButtonText("No")

	local pageId = sui.sendTo(pPlayer)

	createEvent(30 * 1000, "starDestroyer", "closeAuthorizationSui", pPlayer, pageId)
	
end


function starDestroyer:authorizationSuiCallback(pPlayer, pSui, eventIndex, args, ...)
  local cancelPressed = (eventIndex == 1)
  local args = {...}
 
  if (cancelPressed) then
    CreatureObject(pPlayer):sendSystemMessage("You decline to enter the instance.")   
    return 
  elseif (eventIndex == 0) then -- Teleport 
	 createEvent(1000, "starDestroyer", "transportPlayer", pPlayer, "")
	end 
end


function starDestroyer:closeAuthorizationSui(pPlayer, pageId)
	
	local pGhost = CreatureObject(pPlayer):getPlayerObject()

	if (pGhost == nil) then
		return
	end

	PlayerObject(pGhost):removeSuiBox(pageId)

end




function starDestroyer:transportPlayer(pPlayer)
	if pPlayer == nil then
		return
	end
	
  if (CreatureObject(pPlayer):isRidingMount()) then
    CreatureObject(pPlayer):sendSystemMessage("You fail to enter the instance because you are riding a mount.")  
    return 0
  else
     -- SOURCED: instance_datatable.tab:6 enter_one = "0,173,30,secondaryhangar"
     -- Coordinate mapping SOE (x,y,z) -> Core3 (x, z, y) per BINDING B4.
     local cell = self:cellId("secondaryhangar")
     if (cell == 0) then
       return
     end
     SceneObject(pPlayer):switchZone("dungeon1", 0, 173, 30, cell)
  end
end



-- OURS, NOT SOURCED (the 3600 constant). SOE gives this instance 7200 s
-- (instance_datatable.tab:6, time_limit column). Lev's timer ladder is built for 3600:
-- string/en/dungeon/corvette.stf (stardust_03.tre, the winning copy) ships 33 timer_* keys,
-- maximum timer_59. A 7200 s clock prints twelve raw @dungeon/corvette:timer_NNN keys before
-- it reaches a key that exists. 60 minutes matches exarKun.lua and axkvaMin.lua exactly.
function starDestroyer:handleTimer(pPlayer)  
  local startTime = readData("starDestroyerStartTime")
  local timeLeftSecs = 3600 - (os.time() - startTime)
  local timeLeft = math.floor(timeLeftSecs / 60)
  
  if (timeLeft > 10) then    
    CreatureObject(pPlayer):sendSystemMessage("@dungeon/corvette:timer_" .. timeLeft)
    createEvent(5 * 60 * 1000, "starDestroyer", "checkIfActiveForTimer", pPlayer, "")   
  elseif (timeLeft >= 3) then
    CreatureObject(pPlayer):sendSystemMessage("@dungeon/corvette:timer_" .. timeLeft)
    createEvent(60 * 1000, "starDestroyer", "checkIfActiveForTimer", pPlayer, "")
  elseif (timeLeft >= 2) then
    CreatureObject(pPlayer):sendSystemMessage("@dungeon/corvette:timer_" .. timeLeft)
    createEvent(30 * 1000, "starDestroyer", "checkIfActiveForTimer", pPlayer, "")
  elseif (timeLeftSecs >= 90) then
    CreatureObject(pPlayer):sendSystemMessage("@dungeon/corvette:timer_" .. timeLeft)
    createEvent(30 * 1000, "starDestroyer", "checkIfActiveForTimer", pPlayer, "")
  elseif (timeLeftSecs >= 60) then
    CreatureObject(pPlayer):sendSystemMessage("@dungeon/corvette:timer_" .. timeLeft)
    createEvent(30 * 1000, "starDestroyer", "checkIfActiveForTimer", pPlayer, "")
  elseif (timeLeftSecs >= 30) then
    CreatureObject(pPlayer):sendSystemMessage("@dungeon/corvette:timer_" .. timeLeft)
    createEvent(20 * 1000, "starDestroyer", "checkIfActiveForTimer", pPlayer, "")
  elseif (timeLeftSecs >= 10) then
    CreatureObject(pPlayer):sendSystemMessage("@dungeon/corvette:timer_" .. timeLeft)
    createEvent(10 * 1000, "starDestroyer", "checkIfActiveForTimer", pPlayer, "")
  else
    self:checkIfActive(pPlayer)   
  end
end

function starDestroyer:checkIfActiveForTimer(pPlayer)
  if (readData("starDestroyer:occupiedState") == 1) then
    createEvent(1, "starDestroyer", "handleTimer", pPlayer, "")
  else
    --self:ejectAllGroupMembers(pPlayer)
    self:resetInstance(pPlayer)    
  end      
end

function starDestroyer:spawnCheck()
  if (readData("starDestroyer:trashSpawnState") == 1) then
    return
  else
    self:spawnTrashMobs()
    writeData("starDestroyer:trashSpawnState", 1)       
  end 
end



function starDestroyer:spawnTrashMobs()
  -- H(sd-a): the 146 remaining spawn rows (hangar grenadiers, south-hall waves,
  -- Black Sun engineering deck, Olum escort, Kenkirk events) are H(sd-b).
  -- Same empty body as axkvaMin.lua:178-182 -- Axkva has no trash; the SD's
  -- trash is a later round.
end

function starDestroyer:spawnBossOneCheck()
  if (readData("starDestroyer:bossOneSpawnState") == 1) then
    return
  else
    self:spawnBossOne()
    writeData("starDestroyer:bossOneSpawnState", 1)       
  end 
end

function starDestroyer:spawnBossOne()
    local cell = self:cellId("hallway01")
    if (cell == 0) then return end
    -- SOE heroic_star_destroyer.tab:228: heroic_sd_watch_captain_prat, room hallway01,
    -- loc -56 / 172.08 / 333, yaw 0, spawn_id prat_group, trigger spawn_prat_group.
    -- Coordinate mapping SOE (x,y,z) -> Core3 (x, z, y) per BINDING B4.
    local boss1 = spawnMobile("dungeon1", "watch_captain_prat", 0, -56, 172.08, 333, 0, cell)
    if (boss1 == nil) then return end
    createObserver(OBJECTDESTRUCTION, "starDestroyer", "bossOneKilled", boss1)
    createObserver(DAMAGERECEIVED,   "starDestroyer", "boss1_damage",  boss1)
    writeData("starDestroyer:bossOneFightState", 0)
    -- SOE tab:229,230 give Prat two heroic_sd_ito escorts at -55/172.085/332 and -57/172.085/332.
    -- NOT SPAWNED: ito_interrogator has no creature template on SD3 (object/mobile/ito_interrogator.lua
    -- exists; mobile/**/ito_interrogator.lua does not). Recorded, deferred to H(sd-b). PART 7.5.
end

function starDestroyer:boss1_damage(boss1, pPlayer)
 
    local player = LuaCreatureObject(pPlayer)
    local boss = LuaCreatureObject(boss1)
    if ( boss ~= nil ) then
      local bossHealth = boss:getHAM(0)
      local bossAction = boss:getHAM(3)
      local bossMind = boss:getHAM(6)
      local bossMaxHealth = boss:getMaxHAM(0)
      local bossMaxAction = boss:getMaxHAM(3)
      local bossMaxMind = boss:getMaxHAM(6)
   
  
      if (((bossHealth <= (bossMaxHealth *0.99))) and readData("starDestroyer:bossOneFightState") == 0) then
      -- OURS, NOT SOURCED (Lev-style bark; beat from heroic_star_destroyer.tab:228,
      --   trigger_event OnEnterCombat:triggerId:lock_prat -- the corridor watch locking down on contact)
      spatialChat(boss1, "Intruders on deck three!  Seal the corridor, nobody gets past me.")
      -- OURS, NOT SOURCED (which effect fires at which gate). shp_shocked_01 at the 0.99 opener.
      CreatureObject(boss1):playEffect("clienteffect/space_command/shp_shocked_01.cef", "")
        writeData("starDestroyer:bossOneFightState", 1)        
      end 
      
      if (((bossAction <= (bossMaxAction *0.3)))) then
           CreatureObject(boss1):setHAM(3, bossMaxAction)
           -- OURS, NOT SOURCED (force effects used sparingly -- Imperial officer, not Sith).
           CreatureObject(boss1):playEffect("clienteffect/pl_force_channel_self.cef", "")
      end 
      
      if (((bossHealth <= (bossMaxHealth *0.75))) and readData("starDestroyer:bossOneFightState") == 1) then
      -- OURS, NOT SOURCED (Lev-style bark; beat from the same lock_prat trigger)
      spatialChat(boss1, "You are pirates in a warship.  Learn the difference.")
        writeData("starDestroyer:bossOneFightState", 2)               
      end
      
      if (((bossHealth <= (bossMaxHealth *0.50))) and readData("starDestroyer:bossOneFightState") == 2) then
      -- OURS, NOT SOURCED (Lev-style bark; beat from tab:228 OnExitCombat:triggerId:reset_prat)
      spatialChat(boss1, "Hold the line!  Do not let them reach the detention block!")
      -- OURS, NOT SOURCED (which effect fires at which gate). combat_pt_electricalfield at 0.50.
      CreatureObject(boss1):playEffect("clienteffect/combat_pt_electricalfield.cef", "")
        writeData("starDestroyer:bossOneFightState", 3)
      end  
      
      if (((bossHealth <= (bossMaxHealth *0.25))) and readData("starDestroyer:bossOneFightState") == 3) then
      -- OURS, NOT SOURCED (Lev-style bark; beat from tab:200-206, the six officers waiting on prat_dead)
      spatialChat(boss1, "The Captain will hear of this.  You will not enjoy what follows.")
        writeData("starDestroyer:bossOneFightState", 4)        
      end
      
      if (((bossHealth <= (bossMaxHealth *0.1))) and readData("starDestroyer:bossOneFightState") == 4) then
      -- OURS, NOT SOURCED (Lev-style bark; beat from OnDeath:triggerId:prat_dead, tab:228)
      spatialChat(boss1, "Watch... the watch is broken...")
      -- OURS, NOT SOURCED (which effect fires at which gate). combat_pt_electricalfield at 0.10.
      CreatureObject(boss1):playEffect("clienteffect/combat_pt_electricalfield.cef", "")
        writeData("starDestroyer:bossOneFightState", 5)        
      end  
      
      if (((bossHealth <= (bossMaxHealth *0.1))) and readData("starDestroyer:bossOneFightState") == 5) then      
        writeData("starDestroyer:bossOneFightState", 6)        
      end
    end
    return 0
end

function starDestroyer:spawnBossRoomOneActiveArea()
  -- OURS, NOT SOURCED (the radius and the exact position). Lev uses radius 15
  -- (exarKun.lua:311, axkvaMin.lua same). Position is SOE's instance entry point,
  -- instance_datatable.tab:6 "0,173,30,secondaryhangar".
  -- NOTE Lev's comment "Active areas use world coords" (exarKun.lua:306) applies to a
  -- snapshot-placed building. This building is spawned at a known world origin
  -- (-3000, 0, -3000), so the area goes at that origin plus the cell-local offset;
  -- setCellObjectID then scopes it to the cell. Verify in-client (SC9 item 4).
  local cell = self:cellId("secondaryhangar")
  if (cell == 0) then
    return
  end
  local pActiveArea1 = spawnSceneObject("dungeon1", "object/active_area.iff", -3000, 173, -2970, 0, 0, 0, 0, 0)
  if (pActiveArea1 ~= nil) then
    local activeArea = LuaActiveArea(pActiveArea1)
          activeArea:setCellObjectID(cell)
          activeArea:setRadius(15)
          createObserver(ENTEREDAREA, "starDestroyer", "notifyBossRoomOneActiveArea", pActiveArea1)
                  
      end
end

function starDestroyer:notifyBossRoomOneActiveArea(pActiveArea1, pMovingObject, pPlayer)
  
  if (not SceneObject(pMovingObject):isCreatureObject()) then
    return 0
  end
  
  return ObjectManager.withCreatureObject(pMovingObject, function(player)
    if (player:isAiAgent()) then
      return 0
    end
    
    if ((player:isImperial() or player:isRebel()or player:isNeutral())) then

      self:spawnBossRoomOneTrash()
      
      end
    return 0    
  end)
end

function starDestroyer:spawnBossRoomOneTrash()
  if (readData("starDestroyer:bossOneTrashState") == 1) then
    return
  else
    local cell = self:cellId("secondaryhangar")
    if (cell == 0) then
      writeData("starDestroyer:bossOneTrashState", 1)
      return
    end
    -- OURS, NOT SOURCED (the exact hangar pack). H(sd-b) owns the 146 remaining
    -- spawn rows; this is a visible hangar watch so the entry active area has
    -- something to fire (Lev's spawnBossRoomOneTrash, exarKun.lua:337-358).
    -- Positions sit next to SOE's instance entry 0,173,30.
    spawnMobile("dungeon1", "heroic_sd_stormtrooper", 0, 8, 173.83, 28, -90, cell)
    spawnMobile("dungeon1", "heroic_sd_stormtrooper", 0, -8, 173.83, 28, 90, cell)
    spawnMobile("dungeon1", "heroic_sd_darktrooper", 0, 0, 173.83, 20, 0, cell)
  end 
  writeData("starDestroyer:bossOneTrashState", 1) 
end

function starDestroyer:bossOneKilled(boss1) 
  writeData("starDestroyer:bossOneDead", 1) 
  self:spawnBossTwo()
  return 0
end

function starDestroyer:spawnBossTwo()
    local cell = self:cellId("secondaryhangar")
    if (cell == 0) then return end
    -- SOE heroic_star_destroyer.tab:63: heroic_sd_krix_swiftshadow, room secondaryhangar,
    -- loc -40 / 173.83 / 31.36, yaw 90, trigger spawn_krix.
    local boss2 = spawnMobile("dungeon1", "krix_swiftshadow", 0, -40, 173.83, 31.36, 90, cell)
    if (boss2 == nil) then return end
    createObserver(OBJECTDESTRUCTION, "starDestroyer", "bossTwoKilled", boss2)
    createObserver(DAMAGERECEIVED,   "starDestroyer", "boss2_damage",  boss2)
    writeData("starDestroyer:bossTwoFightState", 0)
end

function starDestroyer:boss2_damage(boss2, pPlayer)
 
    local player = LuaCreatureObject(pPlayer)
    local boss = LuaCreatureObject(boss2)
    if ( boss ~= nil ) then
      local bossHealth = boss:getHAM(0)
      local bossAction = boss:getHAM(3)
      local bossMind = boss:getHAM(6)
      local bossMaxHealth = boss:getMaxHAM(0)
      local bossMaxAction = boss:getMaxHAM(3)
      local bossMaxMind = boss:getMaxHAM(6)
   
  
      if (((bossHealth <= (bossMaxHealth *0.99))) and readData("starDestroyer:bossTwoFightState") == 0) then
      -- SOURCED: SRC/script/theme_park/heroic/star_destroyer/krix.java:158, hardcoded English in
      --   SOE's own source (the focus-name interpolation needs the grenadier focus system, H(sd-b);
      --   the sentence is otherwise verbatim).
      spatialChat(boss2, "No, you fools!  Kill them all!")
      -- OURS, NOT SOURCED (which effect fires at which gate). shp_shocked_01 at the 0.99 opener.
      CreatureObject(boss2):playEffect("clienteffect/space_command/shp_shocked_01.cef", "")
        writeData("starDestroyer:bossTwoFightState", 1)        
      end 
      
      if (((bossAction <= (bossMaxAction *0.3)))) then
           CreatureObject(boss2):setHAM(3, bossMaxAction)
           CreatureObject(boss2):playEffect("clienteffect/pl_force_channel_self.cef", "")
      end 
      
      if (((bossHealth <= (bossMaxHealth *0.75))) and readData("starDestroyer:bossTwoFightState") == 1) then
      -- OURS, NOT SOURCED (Lev-style bark; beat from @sequencer_spam:krix_taunt, tab:70)
      spatialChat(boss2, "The Empire built this ship.  I only had to walk in and take it.")
        writeData("starDestroyer:bossTwoFightState", 2)
      end
      
      if (((bossHealth <= (bossMaxHealth *0.50))) and readData("starDestroyer:bossTwoFightState") == 2) then
      -- SOURCED: krix.java:168, hardcoded English in SOE's own source. In SOE this line opens
      --   phase 2 (all grenadiers dead, krix.java:134-139); here it sits on the 50% gate.
      spatialChat(boss2, "Those useless Imperials, I will do this myself.")
      -- OURS, NOT SOURCED (which effect fires at which gate). combat_pt_electricalfield at 0.50.
      CreatureObject(boss2):playEffect("clienteffect/combat_pt_electricalfield.cef", "")
        writeData("starDestroyer:bossTwoFightState", 3)        
      end  
      
      if (((bossHealth <= (bossMaxHealth *0.25))) and readData("starDestroyer:bossTwoFightState") == 3) then
      -- OURS, NOT SOURCED (Lev-style bark; beat from @spam:krix_directed_target_spam, krix.java:160 --
      --   SOE calls a single player out by name here)
      spatialChat(boss2, "You.  Yes, you.  Black Sun remembers faces.")
        writeData("starDestroyer:bossTwoFightState", 4)
      end
      
      if (((bossHealth <= (bossMaxHealth *0.1))) and readData("starDestroyer:bossTwoFightState") == 4) then
      -- OURS, NOT SOURCED (Lev-style bark; beat from @sequencer_spam:krix_dead_notification, tab:53)
      spatialChat(boss2, "Swiftshadow does not run.  Swiftshadow was never here.")
      -- OURS, NOT SOURCED (which effect fires at which gate). combat_pt_electricalfield at 0.10.
      CreatureObject(boss2):playEffect("clienteffect/combat_pt_electricalfield.cef", "")
        writeData("starDestroyer:bossTwoFightState", 5)        
      end  
      
      if (((bossHealth <= (bossMaxHealth *0.1))) and readData("starDestroyer:bossTwoFightState") == 5) then      
        writeData("starDestroyer:bossTwoFightState", 6)        
      end
    end
    return 0
end

function starDestroyer:bossTwoKilled(boss2)
  writeData("starDestroyer:bossTwoDead", 1) 
  self:spawnBossThree()
  return 0
end

function starDestroyer:spawnBossThree()
    local cell = self:cellId("officerqrtr")
    if (cell == 0) then return end
    -- SOE heroic_star_destroyer.tab:268: heroic_sd_commander_kenkirk, room officerqrtr,
    -- loc 19.95 / 170.58 / 417.55, yaw 179, trigger spawn_kenkirk.
    local boss3 = spawnMobile("dungeon1", "commander_kenkirk", 0, 19.95, 170.58, 417.55, 179, cell)
    if (boss3 == nil) then return end
    createObserver(OBJECTDESTRUCTION, "starDestroyer", "bossThreeKilled", boss3)
    createObserver(DAMAGERECEIVED,   "starDestroyer", "boss3_damage",  boss3)
    writeData("starDestroyer:bossThreeFightState", 0)
end

function starDestroyer:boss3_damage(boss3, pPlayer)
 
    local player = LuaCreatureObject(pPlayer)
    local boss = LuaCreatureObject(boss3)
    if ( boss ~= nil ) then
      local bossHealth = boss:getHAM(0)
      local bossAction = boss:getHAM(3)
      local bossMind = boss:getHAM(6)
      local bossMaxHealth = boss:getMaxHAM(0)
      local bossMaxAction = boss:getMaxHAM(3)
      local bossMaxMind = boss:getMaxHAM(6)
   
  
      if (((bossHealth <= (bossMaxHealth *0.99))) and readData("starDestroyer:bossThreeFightState") == 0) then
      -- OURS, NOT SOURCED (Lev-style bark; beat from @spam:event_two_kenkirk_bothersome,
      --   SRC/script/conversation/sd_event_two_convo.java)
      spatialChat(boss3, "You have been bothersome.  That ends in my quarters, apparently.")
      -- OURS, NOT SOURCED (which effect fires at which gate). shp_shocked_01 at the 0.99 opener.
      CreatureObject(boss3):playEffect("clienteffect/space_command/shp_shocked_01.cef", "")
        writeData("starDestroyer:bossThreeFightState", 1)        
      end 
      
      if (((bossAction <= (bossMaxAction *0.3)))) then
           CreatureObject(boss3):setHAM(3, bossMaxAction)
           CreatureObject(boss3):playEffect("clienteffect/pl_force_channel_self.cef", "")
      end 
      
      if (((bossHealth <= (bossMaxHealth *0.75))) and readData("starDestroyer:bossThreeFightState") == 1) then
      -- OURS, NOT SOURCED (Lev-style bark; beat from @spam:event_two_kenkirk_allegiance, same file)
      spatialChat(boss3, "Allegiance is not a costume you put on for a boarding party.")
        writeData("starDestroyer:bossThreeFightState", 2)
      end
      
      if (((bossHealth <= (bossMaxHealth *0.50))) and readData("starDestroyer:bossThreeFightState") == 2) then
      -- OURS, NOT SOURCED (Lev-style bark; beat from @spam:event_one_kenkirk_incursion,
      --   SRC/script/conversation/sd_event_convo.java)
      spatialChat(boss3, "This incursion is over.  Security to the officers' deck!")
      -- OURS, NOT SOURCED (which effect fires at which gate). combat_pt_electricalfield at 0.50.
      CreatureObject(boss3):playEffect("clienteffect/combat_pt_electricalfield.cef", "")
        writeData("starDestroyer:bossThreeFightState", 3)        
      end  
      
      if (((bossHealth <= (bossMaxHealth *0.25))) and readData("starDestroyer:bossThreeFightState") == 3) then
      -- OURS, NOT SOURCED (Lev-style bark; beat from @spam:event_two_kenkirk_destination, sd_event_two_convo.java)
      spatialChat(boss3, "You will never reach the bridge.  You do not even know where it is.")
        writeData("starDestroyer:bossThreeFightState", 4)
      end
      
      if (((bossHealth <= (bossMaxHealth *0.1))) and readData("starDestroyer:bossThreeFightState") == 4) then
      -- OURS, NOT SOURCED (Lev-style bark; beat from tab:268 OnDeath:triggerId:access_bridge --
      --   his death is what unlocks the bridge)
      spatialChat(boss3, "The bridge... the Captain must be warned...")
      -- OURS, NOT SOURCED (which effect fires at which gate). combat_pt_electricalfield at 0.10.
      CreatureObject(boss3):playEffect("clienteffect/combat_pt_electricalfield.cef", "")
        writeData("starDestroyer:bossThreeFightState", 5)        
      end  
      
      if (((bossHealth <= (bossMaxHealth *0.1))) and readData("starDestroyer:bossThreeFightState") == 5) then      
        writeData("starDestroyer:bossThreeFightState", 6)        
      end
    end
    return 0
end

function starDestroyer:bossThreeKilled(boss3)
  writeData("starDestroyer:bossThreeDead", 1) 
  self:spawnBossFour()
  return 0
end

function starDestroyer:spawnBossFour()
    local cell = self:cellId("commandeck")
    if (cell == 0) then return end
    -- SOE heroic_star_destroyer.tab:390: heroic_sd_captain_sait, room commandeck,
    -- loc -0.14 / 453.6 / 323.63, yaw 0, trigger access_bridge.
    local boss4 = spawnMobile("dungeon1", "captain_andal_sait", 0, -0.14, 453.6, 323.63, 0, cell)
    if (boss4 == nil) then return end
    createObserver(OBJECTDESTRUCTION, "starDestroyer", "bossFourKilled", boss4)
    createObserver(DAMAGERECEIVED,   "starDestroyer", "boss4_damage",  boss4)
    writeData("starDestroyer:bossFourFightState", 0)
end

function starDestroyer:boss4_damage(boss4, pPlayer)
 
    local player = LuaCreatureObject(pPlayer)
    local boss = LuaCreatureObject(boss4)
    if ( boss ~= nil ) then
      local bossHealth = boss:getHAM(0)
      local bossAction = boss:getHAM(3)
      local bossMind = boss:getHAM(6)
      local bossMaxHealth = boss:getMaxHAM(0)
      local bossMaxAction = boss:getMaxHAM(3)
      local bossMaxMind = boss:getMaxHAM(6)
   
  
      if (((bossHealth <= (bossMaxHealth *0.99))) and readData("starDestroyer:bossFourFightState") == 0) then
      -- OURS, NOT SOURCED (Lev-style bark; beat from heroic_star_destroyer.tab:390 -- Sait stands on
      --   the command deck behind the access_bridge gate, with four crewmen at their stations)
      spatialChat(boss4, "So you climbed all the way to my deck.  Impressive.  Brief.")
      -- OURS, NOT SOURCED (which effect fires at which gate). shp_shocked_01 at the 0.99 opener.
      CreatureObject(boss4):playEffect("clienteffect/space_command/shp_shocked_01.cef", "")
        writeData("starDestroyer:bossFourFightState", 1)        
      end 
      
      if (((bossAction <= (bossMaxAction *0.3)))) then
           CreatureObject(boss4):setHAM(3, bossMaxAction)
           CreatureObject(boss4):playEffect("clienteffect/pl_force_channel_self.cef", "")
      end 
      
      if (((bossHealth <= (bossMaxHealth *0.75))) and readData("starDestroyer:bossFourFightState") == 1) then
      -- OURS, NOT SOURCED (Lev-style bark; beat from creatures.tab:5813, death_blow instant --
      --   the only creature in this heroic set to instant-killing blow)
      spatialChat(boss4, "I have scuttled ships for less than what you have cost me today.")
        writeData("starDestroyer:bossFourFightState", 2)
      end
      
      if (((bossHealth <= (bossMaxHealth *0.50))) and readData("starDestroyer:bossFourFightState") == 2) then
      -- OURS, NOT SOURCED (Lev-style bark; beat from tab:391-394, the four commandeck crew)
      spatialChat(boss4, "Every station, hold your post.  We do not surrender the Blackguard.")
      -- OURS, NOT SOURCED (which effect fires at which gate). combat_pt_electricalfield at 0.50.
      CreatureObject(boss4):playEffect("clienteffect/combat_pt_electricalfield.cef", "")
        writeData("starDestroyer:bossFourFightState", 3)        
      end  
      
      if (((bossHealth <= (bossMaxHealth *0.25))) and readData("starDestroyer:bossFourFightState") == 3) then
      -- OURS, NOT SOURCED (Lev-style bark; beat from tab:15,17 -- the two bridge exit elevators
      --   only unlock on sait_dead)
      spatialChat(boss4, "There is no way off this bridge that I do not open.")
        writeData("starDestroyer:bossFourFightState", 4)        
      end
      
      if (((bossHealth <= (bossMaxHealth *0.1))) and readData("starDestroyer:bossFourFightState") == 4) then
      -- OURS, NOT SOURCED (Lev-style bark; beat from sd_controller.java:14 saitDied, the instance's
      --   only completion handler)
      spatialChat(boss4, "The Blackguard... was mine...")
      -- OURS, NOT SOURCED (which effect fires at which gate). combat_pt_electricalfield at 0.10.
      CreatureObject(boss4):playEffect("clienteffect/combat_pt_electricalfield.cef", "")
        writeData("starDestroyer:bossFourFightState", 5)        
      end  
      
      if (((bossHealth <= (bossMaxHealth *0.1))) and readData("starDestroyer:bossFourFightState") == 5) then      
        writeData("starDestroyer:bossFourFightState", 6)        
      end
    end
    return 0
end

function starDestroyer:bossFourKilled(boss4, pPlayer)
    writeData("starDestroyer:bossFourDead", 1) 
    CreatureObject(pPlayer):sendSystemMessage(
        "You and your group have defeated Captain Andal Sait!  You will be removed from the instance in 120 seconds.")
                                                                      -- OURS (the name); Lev's sentence
    createEvent(1000,   "starDestroyer", "awardTokenToAll", pPlayer, "")  -- Lev's slot, 1 s (exarKun.lua:732)
    createEvent(120000, "starDestroyer", "handleVictory",   pPlayer, "")  -- Lev's 120 s
  return 0
end

function starDestroyer:getBuildingObject()
    -- H(sd): Lev hardcodes a snapshot id here (exarKun.lua:834-836 -> 480000292;
    -- axkvaMin.lua:956-958 -> 480000331). The SD building is spawned at boot with
    -- persistence 0 (DirectorManager.cpp:3100), so its id is not stable across restarts.
    -- The id is written by starDestroyer:spawnTheShip() (called from start()) and read back here.
    local id = readData("starDestroyer:buildingId")
    if (id == 0) then
        printLuaError("starDestroyer: unable to get building object.")
        return nil
    end
    return getSceneObject(id)
end

function starDestroyer:getCell(cellName)
  local pSD = self:getBuildingObject()
  
  if (pSD == nil) then
    printLuaError("unable to get building object.")
    return nil
  end
  
  return BuildingObject(pSD):getNamedCell(cellName)  
end

-- OURS, NOT SOURCED (helper only; no new engine binding).
function starDestroyer:cellId(cellName)
    local pCell = self:getCell(cellName)
    if (pCell == nil) then
        printLuaError("starDestroyer: no cell named " .. tostring(cellName))
        return 0
    end
    return SceneObject(pCell):getObjectID()
end

-- OURS, NOT SOURCED (the key list). Shape taken from ig88.lua:363-377. Every
-- writeData key this screenplay sets is cleared on timeout, EXITEDBUILDING, and victory.
function starDestroyer:clearEncounterKeys()
  writeData("starDestroyer:occupiedState", 0)
  writeData("starDestroyer:trashSpawnState", 0)
  writeData("starDestroyer:bossOneSpawnState", 0)
  writeData("starDestroyer:bossOneTrashState", 0)
  writeData("starDestroyer:bossOneDead", 0)
  writeData("starDestroyer:bossTwoDead", 0)
  writeData("starDestroyer:bossThreeDead", 0)
  writeData("starDestroyer:bossFourDead", 0)
  writeData("starDestroyer:bossOneFightState", 0)
  writeData("starDestroyer:bossTwoFightState", 0)
  writeData("starDestroyer:bossThreeFightState", 0)
  writeData("starDestroyer:bossFourFightState", 0)
end

-- OURS, NOT SOURCED (the 58-cell loop). Shape taken from ig88.lua:346-361,
-- which only has r1. The SD has 58 interior cells (thm_spc_star_destroyer_s01.pob).
-- Active areas are skipped so the hangar ENTEREDAREA observer survives a reset.
function starDestroyer:destroyArenaContents()
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

function starDestroyer:checkIfActive(pPlayer)
  if (readData("starDestroyer:occupiedState") == 1) then
    writeData("starDestroyer:trashSpawnState", 0)
    self:ejectAllPlayers(pPlayer)
    self:resetInstance(pPlayer)
    return true
  end
end

function starDestroyer:ejectAllPlayers(pPlayer)

  createEvent(1000, "starDestroyer", "ejectPlayer", pPlayer, "")
  
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

function starDestroyer:ejectAllGroupMembers(pPlayer)

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

function starDestroyer:ejectPlayer(pPlayer)
  if pPlayer == nil then
    return
  end
  
  if (SceneObject(pPlayer):getZoneName() == "dungeon1") then
    CreatureObject(pPlayer):sendSystemMessage("You are now being removed from the instance.")
    -- SOURCED: instance_datatable.tab:6 exit_one = "-137,0,-4723,corellia"
    SceneObject(pPlayer):switchZone("corellia", -137, 0, -4723, 0)
  else
    return
  end    
end



function starDestroyer:resetInstanceA(pBuilding, pPlayer)
  if not SceneObject(pPlayer):isPlayerCreature() then
    return 0
  end
  writeData("starDestroyer:occupiedState", 0)
  
  CreatureObject(pPlayer):sendSystemMessage("One or more group members have left the dungeon.")
  self:resetInstance(pPlayer)
  self:ejectAllGroupMembers(pPlayer)  
  return 0
end

function starDestroyer:resetInstance(pPlayer)
    CreatureObject(pPlayer):sendSystemMessage("The instance has been reset.")
    writeData("starDestroyer:occupiedState", 0)
    -- H(sd): same fix H(am) applied at axkvaMin.lua:1044-1049 -- the timeout path
    -- (checkIfActive) and the EXITEDBUILDING path (resetInstanceA) must clear the same
    -- keys the victory path clears, or the instance reopens unfinishable.
    writeData("starDestroyer:trashSpawnState",   0)
    writeData("starDestroyer:bossOneSpawnState", 0)
    writeData("starDestroyer:bossOneTrashState", 0)
    -- ig88.lua:1051-1053: clearEncounterKeys + destroyArenaContents on every reset path.
    self:clearEncounterKeys()
    self:destroyArenaContents()
end

-- H(sd) R-2. Lev grants a badge here (exarKun.lua:920-928 -> index 152;
-- axkvaMin.lua:1052-1058 -> 154). bdg_star_destroyer is in NO badge_map.iff in any loaded
-- TRE -- five variants extracted and parsed, zero hits (spec PART 7.1) -- so there is no
-- index to award. SOE's own completion reward is granted instead:
-- sd_controller.java:18 tokenIndex = 3 -> trial.java:264 item_heroic_token_black_sun_01_01.
-- ITEM: SOURCED (SOE). MECHANISM: OURS, NOT SOURCED.
-- giveItem binding: DirectorManager.cpp:2431-2461, persistence level 1 (persisted).
-- In-tree shape: ig88.lua:979-995 (guard + giveItem fourth arg true).
-- OURS, NOT SOURCED (Lev's awardBadgeToAll shape; the item is SOE's tokenIndex 3)
function starDestroyer:awardToken(pPlayer)
    if (pPlayer == nil) then
        return
    end

    -- Guard key is per player PER RUN (run = starDestroyerStartTime), so a repeat victory grants again the way
    -- SOE's script does on every kill; a per-player-only key would have meant one token per server
    -- uptime. Stale keys from old runs are harmless volatile writeData. (ig88.lua:983-985)
    local oid = SceneObject(pPlayer):getObjectID()
    local tokenKey = "starDestroyer:token:" .. oid .. ":" .. readData("starDestroyerStartTime")
    if (readData(tokenKey) == 1) then
        return
    end

    local pInventory = CreatureObject(pPlayer):getSlottedObject("inventory")

    if (pInventory == nil) then
        return
    end

    -- Registered server path, object/custom_content/tangible/loot/misc/black_sun_token.lua:5
    local pToken = giveItem(pInventory, "object/tangible/loot/misc/black_sun_token.iff", -1, true)

    if (pToken ~= nil) then
        writeData(tokenKey, 1)
        SceneObject(pToken):sendTo(pPlayer)
        -- OURS, NOT SOURCED. SOE sends @set_bonus:recieve_heroic_token here
        -- (player_instance.java:689-698); that stf was not confirmed present in the loaded
        -- TREs, so a plain English line is used, in Lev's voice.
        CreatureObject(pPlayer):sendSystemMessage("You have been awarded a Black Sun Token of Heroism.")  -- OURS, NOT SOURCED (Lev-style system line; SOE grants the token silently via tokenIndex 3)
    end
end

-- Lev's group-award helper (exarKun.lua:930-943), function for function: self on a 1 s event,
-- then every non-AI group member within 300 m.
function starDestroyer:awardTokenToAll(pPlayer)
    createEvent(1000, "starDestroyer", "awardToken", pPlayer, "")

    if (CreatureObject(pPlayer):isGrouped()) then
        local groupSize = CreatureObject(pPlayer):getGroupSize()

        for i = 0, groupSize - 1, 1 do
            local pMember = CreatureObject(pPlayer):getGroupMember(i)
            if pMember ~= nil and pMember ~= pPlayer
               and CreatureObject(pPlayer):isInRangeWithObject(pMember, 300)
               and not SceneObject(pMember):isAiAgent() then
                self:awardToken(pMember)
            end
        end
    end
end

function starDestroyer:handleVictory(pPlayer) 
  self:resetInstance(pPlayer)
  self:ejectAllPlayers(pPlayer)
   writeData("starDestroyer:bossOneDead", 0)
   writeData("starDestroyer:bossTwoDead", 0) 
   writeData("starDestroyer:bossThreeDead", 0) 
   writeData("starDestroyer:bossFourDead", 0)  
   writeData("starDestroyer:trashSpawnState", 0)
   writeData("starDestroyer:bossOneSpawnState", 0)
   writeData("starDestroyer:bossOneTrashState", 0) 
end
