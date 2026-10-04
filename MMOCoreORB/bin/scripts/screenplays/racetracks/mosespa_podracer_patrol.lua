MosEspaPodracerPatrolScreenPlay = ScreenPlay:new {
	numberOfActs = 1,
	screenplayName = "MosEspaPodracerPatrolScreenPlay",
	planet = "tatooine",
	mountedSpeederSpeed = 17,
	mountedSpeederUpdateInterval = 100,
	mountedSpeederCount = 20,
	mountedSpeederRoute = {
		{2405, 5006}, {2156, 5062}, {1832, 4673}, {1540, 4951},
		{1564, 5391}, {1183, 5460}, {955, 5457}, {755, 5443},
		{184, 5331}, {49, 5291}, {-102, 5043}, {-398, 5130},
		{-478, 4935}, {-678, 4820}, {-723, 4385}, {-987, 4144},
		{-707, 3991}, {-552, 3916}, {-149, 3967}, {22, 4047},
		{444, 4392}, {588, 4341}, {665, 3994}, {926, 3839},
		{1170, 4002}, {1200, 4383}, {1424, 4509}, {1679, 4288},
		{2151, 4338}, {2446, 4580}
	},
	mountedSpeederTemplates = {
		"pod_racer_balta_podracer", "pod_racer_ipg_longtail",
		"pod_racer_one", "pod_racer_two", "podracer_anakin", "fg_8t8_podracer"
	},
	patrolNpcs = {
		"commoner_fat_patrol", "commoner_old_patrol", "commoner_tatooine_patrol",
		"commoner_technician_patrol", "explorer_patrol", "gambler_patrol", "scientist_patrol"
	}
}

registerScreenPlay("MosEspaPodracerPatrolScreenPlay", true)

function MosEspaPodracerPatrolScreenPlay:start()
	if (isZoneEnabled(self.planet)) then
		self:spawnMountedSpeederPatrol()
	end
end

function MosEspaPodracerPatrolScreenPlay:spawnMountedSpeederPatrol()
	self:spawnMountedSpeederGroup(self.mountedSpeederRoute, self.mountedSpeederCount, 0)
end

function MosEspaPodracerPatrolScreenPlay:spawnMountedSpeederGroup(route, count, indexOffset)
	local routeLength = 0
	for i = 1, #route do
		local point = route[i]
		local nextPoint = route[i % #route + 1]
		local dx = nextPoint[1] - point[1]
		local dy = nextPoint[2] - point[2]
		routeLength = routeLength + math.sqrt(dx * dx + dy * dy)
	end

	for trafficIndex = 1, count do
		local distance = 0
		if (trafficIndex > 1) then
			distance = (trafficIndex - 1 + getRandomNumber(20, 80) / 100) * routeLength / count
		end
		self:spawnMountedSpeeder(trafficIndex + indexOffset, distance, route)
	end
end

function MosEspaPodracerPatrolScreenPlay:spawnMountedSpeeder(trafficIndex, distance, route)
	local spawn = route[1]
	local pointIndex = 2

	for i = 1, #route do
		local point = route[i]
		local nextIndex = i % #route + 1
		local nextPoint = route[nextIndex]
		local dx = nextPoint[1] - point[1]
		local dy = nextPoint[2] - point[2]
		local segmentLength = math.sqrt(dx * dx + dy * dy)
		if (distance < segmentLength) then
			spawn = {point[1] + dx * distance / segmentLength, point[2] + dy * distance / segmentLength}
			pointIndex = nextIndex
			break
		end
		distance = distance - segmentLength
	end

	local target = route[pointIndex]
	local heading = math.atan(target[1] - spawn[1], target[2] - spawn[2])
	local templateName = self.mountedSpeederTemplates[(trafficIndex - 1) % #self.mountedSpeederTemplates + 1]
	local riderTemplate = self.patrolNpcs[getRandomNumber(1, #self.patrolNpcs)]
	local pVehicle = spawnSceneObject(self.planet, "object/mobile/vehicle/" .. templateName .. ".iff", spawn[1], 5, spawn[2], 0, heading)
	local pRider = spawnMobile(self.planet, riderTemplate, 0, spawn[1] + 2, 5, spawn[2], math.deg(heading), 0)

	if (pVehicle == nil or pRider == nil) then
		if (pVehicle ~= nil) then
			SceneObject(pVehicle):destroyObjectFromWorld()
		end
		if (pRider ~= nil) then
			SceneObject(pRider):destroyObjectFromWorld()
		end
		return
	end

	SceneObject(pVehicle):teleport(spawn[1], getTerrainHeight(pVehicle, spawn[1], spawn[2]), spawn[2], 0)
	CreatureObject(pRider):setCustomObjectName("Townsperson")
	CreatureObject(pRider):setPvpStatusBitmask(0)
	CreatureObject(pRider):setOptionBit(INVULNERABLE)
	CreatureObject(pRider):clearOptionBit(AIENABLED)

	if not mountNpc(pRider, pVehicle) then
		AiAgent(pRider):info("Mos Espa podracer patrol failed to attach its driver to " .. templateName)
		SceneObject(pRider):destroyObjectFromWorld()
		SceneObject(pVehicle):destroyObjectFromWorld()
		return
	end

	writeData(SceneObject(pVehicle):getObjectID() .. ":mosEspaPodracerRoutePoint", pointIndex)
	createEvent(self.mountedSpeederUpdateInterval + ((trafficIndex - 1) % 50) * 2, self.screenplayName, "moveMountedSpeederPatrol", pVehicle, "")
end

function MosEspaPodracerPatrolScreenPlay:moveMountedSpeederPatrol(pVehicle)
	if (pVehicle == nil or SceneObject(pVehicle):getZoneName() ~= self.planet) then
		return
	end

	local vehicle = SceneObject(pVehicle)
	local route = self.mountedSpeederRoute
	local routeKey = vehicle:getObjectID() .. ":mosEspaPodracerRoutePoint"
	local pointIndex = readData(routeKey)
	local currentX = vehicle:getPositionX()
	local currentY = vehicle:getPositionY()
	local remaining = self.mountedSpeederSpeed * self.mountedSpeederUpdateInterval / 1000
	local heading

	while (remaining > 0) do
		local target = route[pointIndex]
		local dx = target[1] - currentX
		local dy = target[2] - currentY
		local distance = math.sqrt(dx * dx + dy * dy)

		if (distance > 0) then
			heading = math.atan(dx, dy)
		end

		if (distance <= remaining) then
			currentX = target[1]
			currentY = target[2]
			remaining = remaining - distance
			pointIndex = pointIndex % #route + 1
		else
			currentX = currentX + dx / distance * remaining
			currentY = currentY + dy / distance * remaining
			remaining = 0
		end
	end

	local nextZ = getTerrainHeight(pVehicle, currentX, currentY)
	local canMove, detourX, detourZ, detourY = canMoveVehiclePatrol(pVehicle, currentX, nextZ, currentY, self.mountedSpeederSpeed, self.mountedSpeederUpdateInterval)
	if not canMove then
		if (detourX ~= nil) then
			vehicle:setDirectionalHeading(math.atan(detourX - vehicle:getPositionX(), detourY - vehicle:getPositionY()))
			checkVehiclePatrolImpact(pVehicle, detourX, detourZ, detourY, self.mountedSpeederSpeed)
			vehicle:teleport(detourX, detourZ, detourY, 0)
		end
		createEvent(self.mountedSpeederUpdateInterval, self.screenplayName, "moveMountedSpeederPatrol", pVehicle, "")
		return
	end

	writeData(routeKey, pointIndex)
	if (heading ~= nil) then
		vehicle:setDirectionalHeading(heading)
	end
	checkVehiclePatrolImpact(pVehicle, currentX, nextZ, currentY, self.mountedSpeederSpeed)
	vehicle:teleport(currentX, nextZ, currentY, 0)
	createEvent(self.mountedSpeederUpdateInterval, self.screenplayName, "moveMountedSpeederPatrol", pVehicle, "")
end
