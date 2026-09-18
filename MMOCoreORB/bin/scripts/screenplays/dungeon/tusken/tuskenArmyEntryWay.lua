tuskenArmyEntryWay = ScreenPlay:new {
  numberOfActs = 1,

  screenplayName = "tuskenArmyEntryWay"
}

registerScreenPlay("tuskenArmyEntryWay", true)

function tuskenArmyEntryWay:start()
  if (isZoneEnabled("tatooine")) then
    self:spawnMobiles()
    self:spawnSceneObjects()
  end
end

function tuskenArmyEntryWay:spawnSceneObjects()
--Entry

  -- Position: the SOE instance exit, exit_one = "-3051,0,2611,tatooine"
  -- (instance_datatable.tab row heroic_tusken_army). Players leaving the instance land here, so
  -- the entrance belongs in the same spot. Height 0 is the datatable's own value and is
  -- almost certainly wrong for Tatooine terrain -- CHECK IN CLIENT and correct (boot probe).
  -- x/z SOURCED (SOE, instance_datatable.tab). Height is OURS, NOT SOURCED.
  --
  -- No dedicated tusken entrance object exists (SOE used conversation.tusken_invasion_instance,
  -- dropped with the intro chain, PART 7). Spawn a travel terminal and attach the radial at
  -- runtime. OURS, NOT SOURCED. setObjectMenuComponent is the Lev/Mustafar idiom
  -- (tutorial.lua:259, fs_cs_commander.lua:148).
  local pTerm = spawnSceneObject("tatooine", "object/tangible/terminal/terminal_travel.iff", -3051, 0, 2611, 0, math.rad(0))
  if (pTerm ~= nil) then
    SceneObject(pTerm):setObjectMenuComponent("tuskenArmyEntryMenuComponent")
  end

end

function tuskenArmyEntryWay:spawnMobiles()

  --[[
  local pNpc = spawnMobile("kaas", "chandriltech_security_guard",60,-79.6,15.6,4679.7,-13,0)
  self:setMoodString(pNpc, "neutral")
  pNpc = spawnMobile("kaas", "chandriltech_security_guard",60,-85.8,15.6,4679.7,-13,0)
  self:setMoodString(pNpc, "neutral")

--]]

end
