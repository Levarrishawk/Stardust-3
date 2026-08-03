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

	if (isZoneEnabled("elysium2")) then
		self:spawnElysiumTwoMobiles()
	end
end

function ElysiumSpawnScreenPlay:spawnElysiumTwoMobiles()
	local mobiles = {
		{"elysium2_force_spirit", 2606, 2500, 0},
		{"elysium2_combat_spirit", 2606, 2520, 180},
		{"elysium2_reflexes_spirit", 2586, 2500, 90},
		{"elysium2_crafting_spirit", 2606, 2480, 0},
		{"elysium2_senses_spirit", 2625, 2500, -90},
		{"elysium2_initiate_spirit", 2606, 2580, 180},
	}

	for i = 1, #mobiles do
		local mobile = mobiles[i]
		local z = getWorldFloor(mobile[2], mobile[3], "elysium2")
		local pNpc = spawnMobile("elysium2", mobile[1], 0, mobile[2], z, mobile[3], mobile[4], 0)

		if (pNpc ~= nil) then
			CreatureObject(pNpc):clearOptionBit(AIENABLED)
			self:setMoodString(pNpc, "neutral")
		end
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
