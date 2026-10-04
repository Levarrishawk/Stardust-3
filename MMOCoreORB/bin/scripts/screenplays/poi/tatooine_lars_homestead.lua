TatooineLarsHomesteadScreenPlay = ScreenPlay:new {
	numberOfActs = 1,
	screenplayName = "TatooineLarsHomesteadScreenPlay",

	-- Template, x, y, heading. All spawns are outdoors.
	family = {
		{"luke_skywalker", -2582, -5511, 180},
		{"owen_lars", -2585, -5513, 90},
		{"beru_lars", -2579, -5513, -90}
	},

	droids = {
		{"r2", -2602, -5495, 90},
		{"r5", -2562, -5492, -90},
		{"eg6_power_droid", -2605, -5530, 0},
		{"cll8_binary_load_lifter", -2558, -5532, 180},
		{"r2", -2584, -5476, 180},
		{"r5", -2580, -5548, 0}
	}
}

registerScreenPlay("TatooineLarsHomesteadScreenPlay", true)

function TatooineLarsHomesteadScreenPlay:start()
	if (isZoneEnabled("tatooine")) then
		self:spawnMobiles()
	end
end

function TatooineLarsHomesteadScreenPlay:spawnFarmMobile(mobile)
	local pMobile = spawnMobile("tatooine", mobile[1], 0, mobile[2], 0, mobile[3], mobile[4], 0)

	if (pMobile ~= nil) then
		local height = getTerrainHeight(pMobile, mobile[2], mobile[3])
		SceneObject(pMobile):teleport(mobile[2], height, mobile[3], 0)
		AiAgent(pMobile):setHomeLocation(mobile[2], height, mobile[3], 0)
	end

	return pMobile
end

function TatooineLarsHomesteadScreenPlay:spawnMobiles()
	for i = 1, #self.family do
		local pMobile = self:spawnFarmMobile(self.family[i])

		if (pMobile ~= nil) then
			AiAgent(pMobile):addObjectFlag(AI_STATIC)
			CreatureObject(pMobile):clearOptionBit(AIENABLED)
		end
	end

	for i = 1, #self.droids do
		local pMobile = self:spawnFarmMobile(self.droids[i])

		if (pMobile ~= nil) then
			CreatureObject(pMobile):setPvpStatusBitmask(0)
			self:droidPatrol(pMobile)
		end
	end
end

function TatooineLarsHomesteadScreenPlay:droidPatrol(pMobile)
	if (pMobile == nil or CreatureObject(pMobile):isDead() or SceneObject(pMobile):getZoneName() ~= "tatooine") then
		return
	end

	if (AiAgent(pMobile):getPatrolPointsSize() == 0) then
		AiAgent(pMobile):generatePatrol(3, 12)
	end

	createEvent(30000, self.screenplayName, "droidPatrol", pMobile, "")
end
