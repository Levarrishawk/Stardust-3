ElysiumSpawnScreenPlay = ScreenPlay:new {
  numberOfActs = 1,

  screenplayName = "ElysiumSpawnScreenPlay"
}

registerScreenPlay("ElysiumSpawnScreenPlay", true)

function ElysiumSpawnScreenPlay:start()
  if (isZoneEnabled("elysium")) then
    self:spawnMobiles()
    self:spawnSceneObjects()
  end
end

function ElysiumSpawnScreenPlay:spawnSceneObjects()

  --Monument Square Cantina Static Objects
  
 -- spawnSceneObject("elysium", "object/building/player/city/shuttleport_corellia.iff", -5816, 0, -4833, 0, math.rad(180) )
 
end

function ElysiumSpawnScreenPlay:spawnMobiles()

    local x = math.random(-6500, 6500)
    local y = math.random(-6500, 6500)

    local pNpc = spawnMobile("elysium", "commoner", 60, x, 6, y, 0, 0)  -- Placeholder for the future.
    self:setMoodString(pNpc, "neutral")

end
