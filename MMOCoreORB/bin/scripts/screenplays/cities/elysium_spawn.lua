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
	local x = 60
	local y = -14
	local z = getWorldFloor(x, y, "elysium")

	spawnSceneObject("elysium", "object/tangible/jedi/elysium_force_shrine_stone.iff", x, z, y, 0, 180)
end

function ElysiumSpawnScreenPlay:spawnMobiles()
	local x = getRandomNumber(-100, 100)
	local y = getRandomNumber(-100, 100)
	local z = getWorldFloor(x, y, "elysium")

	local pNpc = spawnMobile("elysium", "elysium_force_spirit", 60, x, z, y, 0, 0)

	if (pNpc ~= nil) then
		self:setMoodString(pNpc, "neutral")
	end
end
