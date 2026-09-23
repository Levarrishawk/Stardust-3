ig88EntryWay = ScreenPlay:new {
  numberOfActs = 1,

  screenplayName = "ig88EntryWay"
}

registerScreenPlay("ig88EntryWay", true)

function ig88EntryWay:start()
  if (isZoneEnabled("lok")) then
    self:spawnMobiles()
    self:spawnSceneObjects()
  end
end

function ig88EntryWay:spawnSceneObjects()
--Entry
  
  -- Position: the SOE instance exit, exit_one = "416,0,5268,lok"
  -- (instance_datatable.tab row heroic_ig88). Players leaving the instance land here, so
  -- the entrance belongs in the same spot. Height 0 is the datatable's own value and is
  -- almost certainly wrong for Lok terrain -- CHECK IN CLIENT and correct (SC8 step 1).
  -- x/z SOURCED (SOE, instance_datatable.tab:4). Height is OURS, NOT SOURCED.
  spawnSceneObject("lok", "object/tangible/quest/township/ig88_instance_exit.iff", 416, 0, 5268, 0, math.rad(0))

end

function ig88EntryWay:spawnMobiles()

  --[[
  local pNpc = spawnMobile("kaas", "chandriltech_security_guard",60,-79.6,15.6,4679.7,-13,0)
  self:setMoodString(pNpc, "neutral")
  pNpc = spawnMobile("kaas", "chandriltech_security_guard",60,-85.8,15.6,4679.7,-13,0)
  self:setMoodString(pNpc, "neutral")
  
--]]
  
end
