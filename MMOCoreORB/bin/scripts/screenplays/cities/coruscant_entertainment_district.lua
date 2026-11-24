CoruscantEntertainmentScreenPlay = ScreenPlay:new {
	numberOfActs = 1,

	screenplayName = "CoruscantEntertainmentScreenPlay",
	greatHallCellID = 37002512,
	throneRoomCellID = 37002514,
	councilChamberCellID = 37002516,
	operaPerformanceHallCellID = 1493525002,
	operaBuildingID = 1493525000,
	taxiStops = {
		district = {
			mobile = "entertainment_district_taxi_driver",
			driver = {x = 2161.65, height = 0, y = -4475.65, heading = 135},
			arrival = {x = 2163.25, height = 0, y = -4476.65},
			destination = "opera",
		},
		opera = {
			mobile = "opera_house_taxi_driver",
			driver = {x = 2043.4, height = 594, y = -4493.9, heading = -50},
			arrival = {x = 2042.2, height = 594.05, y = -4491.6},
			destination = "district",
		},
	},

	mountedSwoopRoute = {
		{-5746, 0, -5051},
		{-5660, 0, -5049},
		{-5659, 0, -4743},
		{-5862, 0, -4745},
		{-5865, 0, -5047}
	},
	mountedSwoopSpeed = 17,
	mountedSwoopUpdateInterval = 100,
	mountedSwoopRacerCount = 25
}

registerScreenPlay("CoruscantEntertainmentScreenPlay", true)

function CoruscantEntertainmentScreenPlay:start()
	if (isZoneEnabled("coruscant")) then
		self:spawnMobiles()
		self:spawnSceneObjects()
		self:spawnBackstageDoor()
		self:spawnOperaSeating()
		self:spawnTaxiDrivers()
		self:spawnMountedSwoopPatrol()
		self:spawnPalaceMusicAreas()
		-- World-space bounds of the rooftop auditorium, including the private box.
		self:spawnPalaceMusicRectangle("Opera Auditorium", self.operaPerformanceHallCellID, 1965, -4511, 2016, -4457, 594, "enteredOperaAuditorium", "exitedPalaceMusicArea")
	end
end

function CoruscantEntertainmentScreenPlay:isOperaTaxiPadAvailable()
	local pBuilding = getSceneObject(self.operaBuildingID)
	return pBuilding ~= nil and SceneObject(pBuilding):isBuildingObject() and SceneObject(pBuilding):getZoneName() == "coruscant"
end

function CoruscantEntertainmentScreenPlay:spawnTaxiDrivers()
	for name, stop in pairs(self.taxiStops) do
		local key = self.screenplayName .. ":" .. stop.mobile
		if getSceneObject(readData(key)) == nil and (name ~= "opera" or self:isOperaTaxiPadAvailable()) then
			local d = stop.driver
			local pDriver = spawnMobile("coruscant", stop.mobile, 0, d.x, d.height, d.y, d.heading, 0)
			if pDriver ~= nil then
				AiAgent(pDriver):addObjectFlag(AI_STATIONARY)
				writeData(key, SceneObject(pDriver):getObjectID())
			else
				printLuaError(self.screenplayName .. ": failed to spawn " .. stop.mobile)
			end
		end
	end
end

function CoruscantEntertainmentScreenPlay:spawnBackstageDoor()
	local cellID = 37000721
	local pCell = getSceneObject(cellID)
	if pCell == nil or not SceneObject(pCell):isCellObject() then return end

	local template = "object/tangible/door/south_cantina_backstage_door.iff"
	local pDoor
	local cell = SceneObject1(pCell)
	for i = 0, cell:getContainerObjectsSize() - 1 do
		local pObject = cell:getContainerObject(i)
		if pObject ~= nil and SceneObject(pObject):getTemplateObjectPath() == template then
			pDoor = pObject
			break
		end
	end

	if pDoor == nil then
		pDoor = spawnSceneObject("coruscant", template, -7.41334, 0.0043, -17.64, cellID, 0)
		if pDoor == nil then return end
	end

	-- Invalidate any pending poll when the screenplay reattaches to this door.
	local key = self.screenplayName .. ":backstageDoorGeneration"
	local generation = readData(key) + 1
	writeData(key, generation)
	self:updateBackstageDoor(pDoor, tostring(generation))
end

function CoruscantEntertainmentScreenPlay:updateBackstageDoor(pDoor, generation)
	if tonumber(generation) ~= readData(self.screenplayName .. ":backstageDoorGeneration") then return 0 end
	if pDoor == nil or SceneObject(pDoor):getParentID() ~= 37000721 then return 0 end
	local pCell = getSceneObject(37000721)
	if pCell == nil then return 0 end

	local openBit = 0x4000 -- WINGS_OPEN drives the two client-side door hinges.
	local open = TangibleObject(pDoor):hasOptionBit(openBit)
	local radius = open and 4.4 or 3.5
	local occupied, nearby = false, false
	local cell = SceneObject1(pCell)
	for i = 0, cell:getContainerObjectsSize() - 1 do
		local pObject = cell:getContainerObject(i)
		if pObject ~= nil and SceneObject(pObject):isPlayerCreature() then
			occupied = true
			if SceneObject(pObject):getDistanceTo(pDoor) <= radius then
				nearby = true
				break
			end
		end
	end
	if nearby and not open then
		TangibleObject(pDoor):setOptionBit(openBit)
	elseif open and not nearby then
		TangibleObject(pDoor):clearOptionBit(openBit)
	end
	createEvent(occupied and 200 or 900, self.screenplayName, "updateBackstageDoor", pDoor, generation)
	return 0
end

function CoruscantEntertainmentScreenPlay:spawnOperaSeating()
	local cellID = self.operaPerformanceHallCellID
	local pCell = getSceneObject(cellID)
	if pCell == nil or not SceneObject(pCell):isCellObject() then
		print(self.screenplayName .. ": opera performance hall cell missing, skipping seats")
		return
	end

	local chairTemplate = "object/tangible/furniture/plain/plain_chair_s01.iff"
	local cell = SceneObject(pCell)
	local seats = {}
	local function seatKey(x, z, y)
		return string.format("%d/%d/%d", math.floor(x * 100 + 0.5), math.floor(z * 100 + 0.5), math.floor(y * 100 + 0.5))
	end

	for i = 0, cell:getContainerObjectsSize() - 1 do
		local pObject = cell:getContainerObject(i)
		if pObject ~= nil then
			local object = SceneObject(pObject)
			if object:getTemplateObjectPath() == chairTemplate then
				seats[seatKey(object:getPositionX(), object:getPositionZ(), object:getPositionY())] = pObject
			end
		end
	end

	local function placeChair(x, height, y, heading, oldX, oldHeight, oldY, previousX, previousHeight, previousY)
		local key = seatKey(x, height, y)
		if seats[key] ~= nil then
			return true
		end
		local oldKey = seatKey(oldX, oldHeight, oldY)
		if previousX ~= nil then
			local previousKey = seatKey(previousX, previousHeight, previousY)
			if seats[previousKey] ~= nil then
				oldKey = previousKey
			end
		end
		local oldChair = seats[oldKey]
		if oldChair ~= nil then
			local chair = SceneObject(oldChair)
			chair:setDirectionalHeading(heading)
			chair:teleport(x, height, y, cellID)
			if seatKey(chair:getPositionX(), chair:getPositionZ(), chair:getPositionY()) ~= key then
				return false
			end
			seats[oldKey] = nil
			seats[key] = oldChair
			return true
		end
		local pChair = spawnSceneObject("coruscant", chairTemplate, x, height, y, cellID, heading)
		seats[key] = pChair
		return pChair ~= nil
	end

	local cut = math.asin(4.5 / 26)
	local centerY = -15 + 24 * math.cos(cut)
	local sectorAngle = (2 * math.pi - 2 * cut) / 64
	local atan2 = math.atan2 or math.atan
	local function position(sector, radius)
		local i = math.floor(sector)
		local t = sector - i
		local a = cut + i * sectorAngle
		local b = a + sectorAngle
		return radius * 26 * ((1-t) * math.sin(a) + t * math.sin(b)),
			centerY - radius * 24 * ((1-t) * math.cos(a) + t * math.cos(b))
	end

	-- Each bank has 98 chairs. Shorter inner arcs take fewer seats.
	-- Keep the flat cross-row passage in front of the chairs and the sit hardpoint on the platform.
	local previousCounts = {10, 12, 14, 15, 15, 16, 16}
	local seatsPerRow = {9, 12, 14, 15, 15, 17, 16}
	local pitch = (0.925 - 0.245) / 7
	for _, first in ipairs({1, 17, 33, 49}) do
		local index = 0
		local previousRow, previousSeat = 1, 1
		local sectors = first == 49 and 14 or 13
		for row, count in ipairs(seatsPerRow) do
			local radius = 0.245 + pitch * (row - 1 + 1.18)
			local height = -2.5 + 5.5 * row / 7
			for seat = 1, count do
				local fraction = (seat - 0.5) / count
				local previousRadius = 0.245 + pitch * (previousRow - 1 + 0.178)
				local previousFraction = (previousSeat - 0.5) / previousCounts[previousRow]
				local previousX, previousY = position(first + sectors * previousFraction, previousRadius)
				local previousHeight = -2.5 + 5.5 * previousRow / 7
				-- Leave room for a full player footprint beside the stair cheeks.
				local inset = 0.30
				local start, finish = first + inset, first + sectors - inset
				if row == 7 and first == 33 then
					start = first + 1.45
				elseif row == 7 and first == 17 then
					finish = first + sectors - 0.5
				end
				local x, y = position(start + (finish - start) * fraction, radius)
				local heading = atan2(-x, centerY - y)
				-- Reuse the corresponding original chair when upgrading an existing cell.
				local oldRow = math.floor(index / 14) + 1
				local oldRadius = 0.38 + 0.41 * (oldRow - 0.5) / 7
				local oldX, oldY = position(first + index % 14 + 0.5, oldRadius)
				if not placeChair(x, height, y, heading, oldX, -3.6 + 6.6 * oldRow / 7, oldY, previousX, previousHeight, previousY) then
					return
				end
				index = index + 1
				previousSeat = previousSeat + 1
				if previousSeat > previousCounts[previousRow] then
					previousRow, previousSeat = previousRow + 1, 1
				end
			end
		end
	end

	for _, x in ipairs({-2.25, 0, 2.25}) do
		-- The middle seat's original position lies on the join of two floor sectors.
		local seatX = x == 0 and 0.28 or x
		local priorY = centerY + 23.15
		if seatX ~= x and seats[seatKey(x, 3, centerY + 24.35)] ~= nil then
			priorY = centerY + 24.35
		end
		if not placeChair(seatX, 3, centerY + 24.35, math.pi, x, 3, centerY + 20.8, x, 3, priorY) then
			return
		end
	end
end

function CoruscantEntertainmentScreenPlay:spawnPalaceMusicAreas()
	self:spawnCouncilChamberMusicArea()
	self:spawnPalaceMusicRectangle("Great Hall", self.greatHallCellID, -263, 4594, 25, 5003, 1.2, "enteredGreatHall", "exitedPalaceMusicArea")

	-- The throne room and both lift landings share a cell. The audience floor starts at the south doorway.
	self:spawnPalaceMusicRectangle("Throne Room", self.throneRoomCellID, -129, 4800.25, -101, 4827.3, 333, "enteredThroneRoom", "exitedPalaceMusicArea")
	-- Core3 only sends a cell-bound EXITEDAREA on a cell change. Walking back into the lobby also stops the theme.
	self:spawnPalaceMusicRectangle("Throne Lift Lobby", self.throneRoomCellID, -117.2, 4793.8, -112.8, 4800.2495, 333, "exitedPalaceMusicArea")
end

function CoruscantEntertainmentScreenPlay:spawnPalaceMusicRectangle(name, cellID, x1, y1, x2, y2, height, onEnter, onExit)
	local pCell = getSceneObject(cellID)
	if (pCell == nil or not SceneObject(pCell):isCellObject()) then
		print(self.screenplayName .. ": " .. name .. " cell missing, skipping music area")
		return
	end

	local pArea = spawnRectangularActiveArea("coruscant", "object/active_area.iff", x1, y1, x2, y2, height, cellID)
	if (pArea == nil) then
		print(self.screenplayName .. ": failed to spawn " .. name .. " music area")
		return
	end

	createObserver(ENTEREDAREA, self.screenplayName, onEnter, pArea)
	if (onExit ~= nil) then
		createObserver(EXITEDAREA, self.screenplayName, onExit, pArea)
	end
end

function CoruscantEntertainmentScreenPlay:spawnCouncilChamberMusicArea()
	local pCell = getSceneObject(self.councilChamberCellID)
	if (pCell == nil or not SceneObject(pCell):isCellObject()) then
		print(self.screenplayName .. ": Council Chamber cell missing, skipping music area")
		return
	end

	-- Active areas use world coordinates. The cell filter separates the chamber from the lift.
	local pArea = spawnActiveArea("coruscant", "object/active_area.iff", -181.45, 306, 4863.78, 12, self.councilChamberCellID)
	if (pArea == nil) then
		print(self.screenplayName .. ": failed to spawn Council Chamber music area")
		return
	end

	createObserver(ENTEREDAREA, self.screenplayName, "enteredCouncilChamber", pArea)
	createObserver(EXITEDAREA, self.screenplayName, "exitedPalaceMusicArea", pArea)
end

function CoruscantEntertainmentScreenPlay:enteredOperaAuditorium(pArea, pObject)
	if (pObject ~= nil and SceneObject(pObject):isPlayerCreature()) then
		CreatureObject(pObject):playMusicMessage("sound/mus_squidlake.snd")
	end
	return 0
end

function CoruscantEntertainmentScreenPlay:enteredCouncilChamber(pArea, pObject)
	if (pObject ~= nil and SceneObject(pObject):isPlayerCreature()) then
		CreatureObject(pObject):playMusicMessage("sound/mus_ruminations.snd")
	end
	return 0
end

function CoruscantEntertainmentScreenPlay:enteredGreatHall(pArea, pObject)
	if (pObject ~= nil and SceneObject(pObject):isPlayerCreature()) then
		CreatureObject(pObject):playMusicMessage("sound/mus_isd_hangar2.snd")
	end
	return 0
end

function CoruscantEntertainmentScreenPlay:enteredThroneRoom(pArea, pObject)
	if (pObject ~= nil and SceneObject(pObject):isPlayerCreature()) then
		CreatureObject(pObject):playMusicMessage("sound/music_emperor_theme_stereo.snd")
	end
	return 0
end

function CoruscantEntertainmentScreenPlay:exitedPalaceMusicArea(pArea, pObject)
	if (pObject ~= nil and SceneObject(pObject):isPlayerCreature()) then
		CreatureObject(pObject):playMusicMessage("sound/music_silence.snd")
	end
	return 0
end

function CoruscantEntertainmentScreenPlay:spawnMountedSwoopPatrol()
	local distances = CityScreenPlay:getVehiclePatrolSpawnDistances(self.mountedSwoopRoute, self.mountedSwoopRacerCount)
	for racerIndex, distance in ipairs(distances) do
		self:spawnMountedSwoopRacer(racerIndex, distance)
	end
end

function CoruscantEntertainmentScreenPlay:customizeMountedSwoop(pVehicle, racerIndex)
	local vehicle = TangibleObject(pVehicle)
	local variables = {"/private/index_color_1", "/private/index_color_2", "/private/index_color_0"}
	local combination = racerIndex - 1
	local combinationsAvailable = 1

	for channel, variable in ipairs(variables) do
		local colorCount = vehicle:getPaletteColorCount(variable)

		if (colorCount > 0) then
			local choices = math.min(colorCount, self.mountedSwoopRacerCount)
			local colorIndex = math.floor((combination % choices) * colorCount / choices)

			-- Rotate the accents without repeating a frame/trim combination.
			if (channel > 1) then
				colorIndex = (colorIndex + ((racerIndex - 1) % combinationsAvailable) * 7) % colorCount
			end

			vehicle:setCustomizationVariable(variable, colorIndex)
			combination = math.floor(combination / choices)
			combinationsAvailable = combinationsAvailable * choices
		end
	end

	if (racerIndex == 1 and combinationsAvailable < self.mountedSwoopRacerCount) then
		print(self.screenplayName .. ": swoop palettes provide fewer than " .. self.mountedSwoopRacerCount .. " unique color combinations")
	end
end

function CoruscantEntertainmentScreenPlay:getMountedSwoopRoutePoint(racerIndex, pointIndex)
	local point = self.mountedSwoopRoute[pointIndex]

	if (racerIndex == 1) then
		return {point[1], point[2], point[3]}
	end

	local offsetDistance = 1 + ((racerIndex + pointIndex * 3) % 3) * 0.5
	local offsetAngle = math.rad((racerIndex * 47 + pointIndex * 73) % 360)
	local offsetX = math.cos(offsetAngle) * offsetDistance
	local offsetY = math.sin(offsetAngle) * offsetDistance

	return {point[1] + offsetX, point[2], point[3] + offsetY}
end

function CoruscantEntertainmentScreenPlay:spawnMountedSwoopRacer(racerIndex, distance)
	local spawn = self.mountedSwoopRoute[1]
	local pointIndex = 2
	for i = 1, #self.mountedSwoopRoute do
		local point = self.mountedSwoopRoute[i]
		local nextIndex = i % #self.mountedSwoopRoute + 1
		local nextPoint = self.mountedSwoopRoute[nextIndex]
		local dx = nextPoint[1] - point[1]
		local dy = nextPoint[3] - point[3]
		local segmentLength = math.sqrt(dx * dx + dy * dy)
		if (distance < segmentLength) then
			local progress = distance / segmentLength
			spawn = {point[1] + dx * progress, point[2] + (nextPoint[2] - point[2]) * progress, point[3] + dy * progress}
			pointIndex = nextIndex
			break
		end
		distance = distance - segmentLength
	end

	local target = self:getMountedSwoopRoutePoint(racerIndex, pointIndex)
	local heading = math.atan(target[1] - spawn[1], target[3] - spawn[3])
	local riderTemplate = racerIndex % 2 == 0 and "ambient_valarian_swooper" or "ambient_jabba_swooper"
	local pVehicle = spawnSceneObject("coruscant", "object/mobile/vehicle/speederbike_swoop.iff", spawn[1], spawn[2], spawn[3], 0, heading)
	local pRider = spawnMobile("coruscant", riderTemplate, 0, spawn[1] + 2, spawn[2], spawn[3], math.deg(heading), 0)

	if (pVehicle == nil or pRider == nil) then
		if (pVehicle ~= nil) then
			SceneObject(pVehicle):destroyObjectFromWorld()
		end

		if (pRider ~= nil) then
			SceneObject(pRider):destroyObjectFromWorld()
		end

		return
	end

	self:customizeMountedSwoop(pVehicle, racerIndex)

	if not mountNpc(pRider, pVehicle) then
		AiAgent(pRider):info("Mounted swoop patrol failed to attach to its swoop")
		return
	end

	CreatureObject(pRider):clearOptionBit(AIENABLED)

	local vehicleID = SceneObject(pVehicle):getObjectID()

	writeData(vehicleID .. ":mountedSwoopRacerIndex", racerIndex)
	writeData(vehicleID .. ":mountedSwoopRoutePoint", pointIndex)
	createEvent(self.mountedSwoopUpdateInterval + ((racerIndex - 1) % 10) * 10, self.screenplayName, "moveMountedSwoopPatrol", pVehicle, "")
end

function CoruscantEntertainmentScreenPlay:moveMountedSwoopPatrol(pVehicle)
	if (pVehicle == nil or SceneObject(pVehicle):getZoneName() == "") then
		return
	end

	local vehicle = SceneObject(pVehicle)
	local vehicleID = vehicle:getObjectID()
	local racerIndex = readData(vehicleID .. ":mountedSwoopRacerIndex")
	local pointIndex = readData(vehicleID .. ":mountedSwoopRoutePoint")
	local target = self:getMountedSwoopRoutePoint(racerIndex, pointIndex)
	local currentX = vehicle:getPositionX()
	local currentZ = vehicle:getPositionZ()
	local currentY = vehicle:getPositionY()
	local dx = target[1] - currentX
	local dy = target[3] - currentY
	local distance = math.sqrt(dx * dx + dy * dy)
	local step = self.mountedSwoopSpeed * self.mountedSwoopUpdateInterval / 1000

	if (distance <= step) then
		currentX = target[1]
		currentZ = target[2]
		currentY = target[3]
		pointIndex = pointIndex + 1

		if (pointIndex > #self.mountedSwoopRoute) then
			pointIndex = 1
		end

	else
		currentX = currentX + dx / distance * step
		currentZ = currentZ + (target[2] - currentZ) / distance * step
		currentY = currentY + dy / distance * step
	end

	local canMove, detourX, detourZ, detourY = canMoveVehiclePatrol(pVehicle, currentX, currentZ, currentY, self.mountedSwoopSpeed, self.mountedSwoopUpdateInterval)
	if not canMove then
		if (detourX ~= nil) then
			vehicle:setDirectionalHeading(math.atan(detourX - vehicle:getPositionX(), detourY - vehicle:getPositionY()))
			checkVehiclePatrolImpact(pVehicle, detourX, detourZ, detourY, self.mountedSwoopSpeed)
			vehicle:teleport(detourX, detourZ, detourY, 0)
		end
		createEvent(self.mountedSwoopUpdateInterval, self.screenplayName, "moveMountedSwoopPatrol", pVehicle, "")
		return
	end

	writeData(vehicleID .. ":mountedSwoopRoutePoint", pointIndex)
	if (distance > 0) then
		vehicle:setDirectionalHeading(math.atan(dx, dy))
	end

	checkVehiclePatrolImpact(pVehicle, currentX, currentZ, currentY, self.mountedSwoopSpeed)
	vehicle:teleport(currentX, currentZ, currentY, 0)
	createEvent(self.mountedSwoopUpdateInterval, self.screenplayName, "moveMountedSwoopPatrol", pVehicle, "")
end

function CoruscantEntertainmentScreenPlay:spawnSceneObjects()

	--Monument Square Cantina Static Objects
	spawnSceneObject("coruscant", "object/static/structure/general/streetlamp_small_red_style_01_on.iff", 27.1, -0.9, 12.0, 37000111, math.rad(0) )
  spawnSceneObject("coruscant", "object/static/structure/general/streetlamp_small_red_style_01_on.iff", 27.1, -0.9, -10.9, 37000111, math.rad(0) )
  spawnSceneObject("coruscant", "object/static/structure/general/streetlamp_small_red_style_01_on.iff", -16.4, -0.9, 0.4, 37000111, math.rad(0) )
  spawnSceneObject("coruscant", "object/static/structure/general/streetlamp_small_red_style_01_on.iff", 15.0, -0.9, -3.9, 37000111, math.rad(0) )
  spawnSceneObject("coruscant", "object/static/structure/general/streetlamp_small_red_style_01_on.iff", 15.6, -0.9, 5.7, 37000111, math.rad(0) )
  spawnSceneObject("coruscant", "object/static/structure/general/streetlamp_small_red_style_01_on.iff", -1.2, -0.9, 11.3, 37000111, math.rad(0) )
  spawnSceneObject("coruscant", "object/static/structure/general/streetlamp_small_red_style_01_on.iff", 11.8, -0.9, -10.2, 37000111, math.rad(0) )
  spawnSceneObject("coruscant", "object/static/structure/general/streetlamp_small_red_style_01_on.iff", -1.1, -0.9, -10.3, 37000111, math.rad(0) )
  spawnSceneObject("coruscant", "object/static/structure/general/streetlamp_small_red_style_01_on.iff", -11.4, -0.9, -7.6, 37000111, math.rad(0) )
  spawnSceneObject("coruscant", "object/static/structure/general/streetlamp_small_red_style_01_on.iff", 34.4, 0.1, 1.6, 37000112, math.rad(0) )
  spawnSceneObject("coruscant", "object/tangible/gambling/wheel/roulette.iff", 34.4, 0.1, 1.6, 37000112, math.rad(0) )
  spawnSceneObject("coruscant", "object/static/structure/general/streetlamp_small_red_style_01_on.iff", 31.7, 0.1, -6.8, 37000112, math.rad(0) )
  spawnSceneObject("coruscant", "object/static/structure/general/streetlamp_small_red_style_02_on.iff", -16.7, -0.9, 26.4, 37000112, math.rad(0) )
  spawnSceneObject("coruscant", "object/static/item/item_scrolling_screen.iff", 9.8, 3.6, 0.1, 37000111, math.rad(0) )

-- Entertainment District Caberet Cantina
  spawnSceneObject("coruscant", "object/tangible/furniture/all/frn_all_couch_divan_s1.iff", 0.0, -0.7, -7.3, 37000721, math.rad(180) )
  spawnSceneObject("coruscant", "object/tangible/furniture/all/frn_all_couch_divan_s1.iff", -3.1, -0.7, -8.0, 37000721, math.rad(142) )
  spawnSceneObject("coruscant", "object/tangible/furniture/all/frn_all_couch_divan_s1.iff", 3.1, -0.7, -8.0, 37000721, math.rad(-142) )
  spawnSceneObject("coruscant", "object/tangible/furniture/all/frn_all_couch_divan_s1.iff", 4.9, -0.7, -11.0, 37000721, math.rad(-90) )
  spawnSceneObject("coruscant", "object/tangible/furniture/all/frn_all_couch_divan_s1.iff", -4.9, -0.7, -11.0, 37000721, math.rad(90) )
  spawnSceneObject("coruscant", "object/tangible/furniture/all/frn_all_couch_divan_s1.iff", -6.1, -0.7, -6.9, 37000721, math.rad(142) )
  spawnSceneObject("coruscant", "object/tangible/furniture/all/frn_all_couch_divan_s1.iff", 6.1, -0.7, -6.9, 37000721, math.rad(-142) )
  spawnSceneObject("coruscant", "object/tangible/furniture/all/frn_all_couch_divan_s1.iff", 2.5, -0.7, -4.3, 37000721, math.rad(-168) ) 
  spawnSceneObject("coruscant", "object/tangible/furniture/all/frn_all_couch_divan_s1.iff", -2.5, -0.7, -4.3, 37000721, math.rad(168) )
  spawnSceneObject("coruscant", "object/tangible/furniture/all/frn_all_couch_divan_s1.iff", 0.0, -0.7, -3.7, 37000721, math.rad(180) )

  spawnSceneObject("coruscant", "object/tangible/furniture/all/frn_all_table_s03.iff", -11.7, 0.5, -3.2, 37000721, math.rad(0) )
  spawnSceneObject("coruscant", "object/tangible/furniture/all/frn_all_table_s03.iff", -11.7, 0.5, -11.9, 37000721, math.rad(0) )
  spawnSceneObject("coruscant", "object/tangible/furniture/all/frn_all_table_s03.iff", 11.7, 0.5, -3.2, 37000721, math.rad(0) )
  spawnSceneObject("coruscant", "object/tangible/furniture/all/frn_all_table_s03.iff", 11.7, 0.5, -11.9, 37000721, math.rad(0) )
  
  spawnSceneObject("coruscant", "object/tangible/furniture/modern/chair_modern_style_01.iff", -11.8, 0.5, -1.2, 37000721, math.rad(180) )
  spawnSceneObject("coruscant", "object/tangible/furniture/modern/chair_modern_style_01.iff", -11.8, 0.5, -5.2, 37000721, math.rad(0) )
  spawnSceneObject("coruscant", "object/tangible/furniture/modern/chair_modern_style_01.iff", -13.0, 0.5, -4.7, 37000721, math.rad(51) )
  spawnSceneObject("coruscant", "object/tangible/furniture/modern/chair_modern_style_01.iff", -13.0, 0.5, -2.0, 37000721, math.rad(128) )
  
  spawnSceneObject("coruscant", "object/tangible/furniture/modern/chair_modern_style_01.iff", -11.8, 0.5, -9.9, 37000721, math.rad(180) )
  spawnSceneObject("coruscant", "object/tangible/furniture/modern/chair_modern_style_01.iff", -11.8, 0.5, -14.0, 37000721, math.rad(0) )
  spawnSceneObject("coruscant", "object/tangible/furniture/modern/chair_modern_style_01.iff", -13.0, 0.5, -13.3, 37000721, math.rad(51) )
  spawnSceneObject("coruscant", "object/tangible/furniture/modern/chair_modern_style_01.iff", -13.0, 0.5, -10.6, 37000721, math.rad(128) )
  
  spawnSceneObject("coruscant", "object/tangible/furniture/modern/chair_modern_style_01.iff", 11.8, 0.5, -1.2, 37000721, math.rad(180) )
  spawnSceneObject("coruscant", "object/tangible/furniture/modern/chair_modern_style_01.iff", 11.8, 0.5, -5.2, 37000721, math.rad(0) )
  spawnSceneObject("coruscant", "object/tangible/furniture/modern/chair_modern_style_01.iff", 13.0, 0.5, -4.7, 37000721, math.rad(51) )
  spawnSceneObject("coruscant", "object/tangible/furniture/modern/chair_modern_style_01.iff", 13.0, 0.5, -2.0, 37000721, math.rad(128) )
  
  spawnSceneObject("coruscant", "object/tangible/furniture/modern/chair_modern_style_01.iff", 11.8, 0.5, -9.9, 37000721, math.rad(180) )
  spawnSceneObject("coruscant", "object/tangible/furniture/modern/chair_modern_style_01.iff", 11.8, 0.5, -14.0, 37000721, math.rad(0) )
  spawnSceneObject("coruscant", "object/tangible/furniture/modern/chair_modern_style_01.iff", 13.0, 0.5, -13.3, 37000721, math.rad(51) )
  spawnSceneObject("coruscant", "object/tangible/furniture/modern/chair_modern_style_01.iff", 13.0, 0.5, -10.6, 37000721, math.rad(128) )
  
   
-- Entertainment District Sports Bar Cantina

  spawnSceneObject("coruscant", "object/tangible/furniture/all/frn_all_table_s03.iff", -7.7, 0.25, -3.25, 37000714, math.rad(0) )
  spawnSceneObject("coruscant", "object/tangible/furniture/all/frn_all_table_s03.iff", -7.5, 3.3, -16.98, 37000714, math.rad(0) )
  spawnSceneObject("coruscant", "object/tangible/furniture/all/frn_all_table_s03.iff", 7.7, 0.25, -3.25, 37000714, math.rad(0) )
  spawnSceneObject("coruscant", "object/tangible/furniture/all/frn_all_table_s03.iff", 7.5, 3.3, -16.98, 37000714, math.rad(0) )
  
   spawnSceneObject("coruscant", "object/static/structure/general/streetlamp_small_blue_style_01_on.iff", -12.2, 0.25, 1.6, 37000714, math.rad(0) )
  spawnSceneObject("coruscant", "object/static/structure/general/streetlamp_small_blue_style_01_on.iff", -13.2, 3.3, -18.1, 37000714, math.rad(0) )
  spawnSceneObject("coruscant", "object/static/structure/general/streetlamp_small_blue_style_01_on.iff", 12.2, 0.25, 1.6, 37000714, math.rad(0) )
  spawnSceneObject("coruscant", "object/static/structure/general/streetlamp_small_blue_style_01_on.iff", 13.2, 3.3, -18.1, 37000714, math.rad(0) )
  
  
  spawnSceneObject("coruscant", "object/tangible/furniture/modern/chair_modern_style_01.iff", -7.7, 0.25, -1.92, 37000714, math.rad(180) )
  spawnSceneObject("coruscant", "object/tangible/furniture/modern/chair_modern_style_01.iff", -7.7, 0.25, -4.58, 37000714, math.rad(0) )
  spawnSceneObject("coruscant", "object/tangible/furniture/modern/chair_modern_style_01.iff", -9.15, 0.25, -3.25, 37000714, math.rad(90) )
  spawnSceneObject("coruscant", "object/tangible/furniture/modern/chair_modern_style_01.iff", -6.25, 0.25, -3.25, 37000714, math.rad(-90) )
  
  spawnSceneObject("coruscant", "object/tangible/furniture/modern/chair_modern_style_01.iff", -7.5, 3.3, -15.65, 37000714, math.rad(180) )
  spawnSceneObject("coruscant", "object/tangible/furniture/modern/chair_modern_style_01.iff", -7.5, 3.3, -18.31, 37000714, math.rad(0) )
  spawnSceneObject("coruscant", "object/tangible/furniture/modern/chair_modern_style_01.iff", -8.95, 3.3, -16.98, 37000714, math.rad(90) )
  spawnSceneObject("coruscant", "object/tangible/furniture/modern/chair_modern_style_01.iff", -6.05, 3.3, -16.98, 37000714, math.rad(-90) )
  
  spawnSceneObject("coruscant", "object/tangible/furniture/modern/chair_modern_style_01.iff", 7.7, 0.25, -1.92, 37000714, math.rad(180) )
  spawnSceneObject("coruscant", "object/tangible/furniture/modern/chair_modern_style_01.iff", 7.7, 0.25, -4.58, 37000714, math.rad(0) )
  spawnSceneObject("coruscant", "object/tangible/furniture/modern/chair_modern_style_01.iff", 6.25, 0.25, -3.25, 37000714, math.rad(90) )
  spawnSceneObject("coruscant", "object/tangible/furniture/modern/chair_modern_style_01.iff", 9.15, 0.25, -3.25, 37000714, math.rad(-90) )
  
  spawnSceneObject("coruscant", "object/tangible/furniture/modern/chair_modern_style_01.iff", 7.5, 3.3, -15.65, 37000714, math.rad(180) )
  spawnSceneObject("coruscant", "object/tangible/furniture/modern/chair_modern_style_01.iff", 7.5, 3.3, -18.31, 37000714, math.rad(0) )
  spawnSceneObject("coruscant", "object/tangible/furniture/modern/chair_modern_style_01.iff", 6.05, 3.3, -16.98, 37000714, math.rad(90) )
  spawnSceneObject("coruscant", "object/tangible/furniture/modern/chair_modern_style_01.iff", 8.95, 3.3, -16.98, 37000714, math.rad(-90) )
  
  spawnSceneObject("coruscant", "object/tangible/gambling/wheel/roulette.iff", 0, 0.25, -14, 37000714, math.rad(0) )
  spawnSceneObject("coruscant", "object/tangible/gambling/wheel/roulette.iff", -5.65, 0.25, -10.6, 37000714, math.rad(47) )
  spawnSceneObject("coruscant", "object/tangible/gambling/wheel/roulette.iff", 5.65, 0.25, -10.6, 37000714, math.rad(-47) )
     
-- Starport Static Objects
  spawnSceneObject("coruscant", "object/static/structure/general/streetlamp_small_blue_style_01_on.iff", 12.2, 0.6, 50.2, 37000200, math.rad(0) )
  spawnSceneObject("coruscant", "object/static/structure/general/streetlamp_small_blue_style_01_on.iff", -0.2, 0.6, 48.1, 37000200, math.rad(0) )
  spawnSceneObject("coruscant", "object/static/structure/general/streetlamp_small_blue_style_01_on.iff", -13.5, 0.6, 50.9, 37000200, math.rad(0) )
 

 --          :::: Starport District ::::
  
  -- Starport District Cantina
  
  spawnSceneObject("coruscant", "object/tangible/furniture/all/frn_all_table_s03.iff", -11.7, 0.5, -3.2, 37000316, math.rad(0) )
  spawnSceneObject("coruscant", "object/tangible/furniture/all/frn_all_table_s03.iff", -11.7, 0.5, -11.9, 37000316, math.rad(0) )
  spawnSceneObject("coruscant", "object/tangible/furniture/all/frn_all_table_s03.iff", 11.7, 0.5, -3.2, 37000316, math.rad(0) )
  spawnSceneObject("coruscant", "object/tangible/furniture/all/frn_all_table_s03.iff", 11.7, 0.5, -11.9, 37000316, math.rad(0) )
  
  spawnSceneObject("coruscant", "object/static/structure/general/streetlamp_small_green_style_01_on.iff", -11.7, 0.5, -3.2, 37000316, math.rad(0) )
  spawnSceneObject("coruscant", "object/static/structure/general/streetlamp_small_green_style_01_on.iff", -11.7, 0.5, -11.9, 37000316, math.rad(0) )
  spawnSceneObject("coruscant", "object/static/structure/general/streetlamp_small_green_style_01_on.iff", 11.7, 0.5, -3.2, 37000316, math.rad(0) )
  spawnSceneObject("coruscant", "object/static/structure/general/streetlamp_small_green_style_01_on.iff", 11.7, 0.5, -11.9, 37000316, math.rad(0) )
  
  
  spawnSceneObject("coruscant", "object/tangible/furniture/modern/chair_modern_style_01.iff", -11.8, 0.5, -1.2, 37000316, math.rad(180) )
  spawnSceneObject("coruscant", "object/tangible/furniture/modern/chair_modern_style_01.iff", -11.8, 0.5, -5.2, 37000316, math.rad(0) )
  spawnSceneObject("coruscant", "object/tangible/furniture/modern/chair_modern_style_01.iff", -13.0, 0.5, -4.7, 37000316, math.rad(51) )
  spawnSceneObject("coruscant", "object/tangible/furniture/modern/chair_modern_style_01.iff", -13.0, 0.5, -2.0, 37000316, math.rad(128) )
  
  spawnSceneObject("coruscant", "object/tangible/furniture/modern/chair_modern_style_01.iff", -11.8, 0.5, -9.9, 37000316, math.rad(180) )
  spawnSceneObject("coruscant", "object/tangible/furniture/modern/chair_modern_style_01.iff", -11.8, 0.5, -14.0, 37000316, math.rad(0) )
  spawnSceneObject("coruscant", "object/tangible/furniture/modern/chair_modern_style_01.iff", -13.0, 0.5, -13.3, 37000316, math.rad(51) )
  spawnSceneObject("coruscant", "object/tangible/furniture/modern/chair_modern_style_01.iff", -13.0, 0.5, -10.6, 37000316, math.rad(128) )
  
  spawnSceneObject("coruscant", "object/tangible/furniture/modern/chair_modern_style_01.iff", 11.8, 0.5, -1.2, 37000316, math.rad(180) )
  spawnSceneObject("coruscant", "object/tangible/furniture/modern/chair_modern_style_01.iff", 11.8, 0.5, -5.2, 37000316, math.rad(0) )
  spawnSceneObject("coruscant", "object/tangible/furniture/modern/chair_modern_style_01.iff", 13.0, 0.5, -4.7, 37000316, math.rad(51) )
  spawnSceneObject("coruscant", "object/tangible/furniture/modern/chair_modern_style_01.iff", 13.0, 0.5, -2.0, 37000316, math.rad(128) )
  
  spawnSceneObject("coruscant", "object/tangible/furniture/modern/chair_modern_style_01.iff", 11.8, 0.5, -9.9, 37000316, math.rad(180) )
  spawnSceneObject("coruscant", "object/tangible/furniture/modern/chair_modern_style_01.iff", 11.8, 0.5, -14.0, 37000316, math.rad(0) )
  spawnSceneObject("coruscant", "object/tangible/furniture/modern/chair_modern_style_01.iff", 13.0, 0.5, -13.3, 37000316, math.rad(51) )
  spawnSceneObject("coruscant", "object/tangible/furniture/modern/chair_modern_style_01.iff", 13.0, 0.5, -10.6, 37000316, math.rad(128) )
  
  spawnSceneObject("coruscant", "object/tangible/gambling/wheel/roulette.iff", 0.0, -0.7, -6.0, 37000316, math.rad(0) )
  spawnSceneObject("coruscant", "object/tangible/gambling/wheel/roulette.iff", 4.8, -0.7, -8.6, 37000316, math.rad(0) )
  spawnSceneObject("coruscant", "object/tangible/gambling/wheel/roulette.iff", -4.8, -0.7, -8.6, 37000316, math.rad(0) )


-- Collective Commerce district Objects
  --Dex's Diner
  spawnSceneObject("coruscant", "object/tangible/furniture/modern/bar_piece_curve_s1.iff", 3.8, 0.1, -2.2, 37000549, math.rad(0) )
  spawnSceneObject("coruscant", "object/tangible/furniture/modern/bar_piece_straight_s2.iff", -1, 0.1, -1.3, 37000549, math.rad(0) )
  spawnSceneObject("coruscant", "object/tangible/furniture/modern/bar_piece_straight_s1.iff", -5.5, 0.1, -1.9, 37000549, math.rad(180) )
  spawnSceneObject("coruscant", "object/tangible/furniture/modern/bar_counter_s1.iff", 2.0, -0.1, 3.6, 37000549, math.rad(90) )
  spawnSceneObject("coruscant", "object/tangible/furniture/modern/bar_counter_s1.iff", -2.0, -0.1, 3.6, 37000549, math.rad(90) )
  spawnSceneObject("coruscant", "object/tangible/furniture/modern/bar_counter_s1.iff", -5.7, -0.1, 3.6, 37000549, math.rad(90) )
  spawnSceneObject("coruscant", "object/tangible/furniture/cheap/chair_s01.iff", 3.5, 0.1, 3.5, 37000549, math.rad(-90) )
  spawnSceneObject("coruscant", "object/tangible/furniture/cheap/chair_s01.iff", 0.8, 0.1, 3.5, 37000549, math.rad(90) )
  spawnSceneObject("coruscant", "object/tangible/furniture/cheap/chair_s01.iff", -0.6, 0.1, 3.5, 37000549, math.rad(-90) )
  spawnSceneObject("coruscant", "object/tangible/furniture/cheap/chair_s01.iff", -3.2, 0.1, 3.5, 37000549, math.rad(90) )
  spawnSceneObject("coruscant", "object/tangible/furniture/cheap/chair_s01.iff", -4.5, 0.1, 3.5, 37000549, math.rad(-90) )
  spawnSceneObject("coruscant", "object/tangible/furniture/cheap/chair_s01.iff", -6.7, 0.1, 3.5, 37000549, math.rad(90) )
  spawnSceneObject("coruscant", "object/static/structure/general/all_foodcart_s01.iff", -1.8, 0.1, -7.5, 37000549, math.rad(90) )
  --exterior
  spawnSceneObject("coruscant", "object/static/structure/corellia/corl_fountain_brazier_square_s01.iff", -1898.7, 40, -178.2, 0, math.rad(90) )
  spawnSceneObject("coruscant", "object/static/structure/corellia/corl_fountain_brazier_square_s01.iff", -1868.2, 40, -47, 0, math.rad(90) )

  spawnSceneObject("coruscant", "object/static/vehicle/player_shuttle.iff", -1799, 40, -216, 0, math.rad(0) )
  spawnSceneObject("coruscant", "object/static/vehicle/player_shuttle.iff", -1799, 40, -186, 0, math.rad(0) )
  spawnSceneObject("coruscant", "object/static/vehicle/player_shuttle.iff", -1799, 40, -156, 0, math.rad(0) )
  spawnSceneObject("coruscant", "object/static/vehicle/player_shuttle.iff", -1799, 40, -126, 0, math.rad(0) )
  spawnSceneObject("coruscant", "object/static/vehicle/player_shuttle.iff", -1799, 40, -96, 0, math.rad(0) )
  spawnSceneObject("coruscant", "object/static/vehicle/player_shuttle.iff", -1799, 40, -66, 0, math.rad(0) )
  
  spawnSceneObject("coruscant", "object/static/vehicle/e3/landspeeder.iff", -1850, 40, -135, 0, math.rad(90) )
  spawnSceneObject("coruscant", "object/static/vehicle/e3/landspeeder.iff", -1850, 40, -140, 0, math.rad(90) )
  -- Captured imperial bunker
  
  
    --Lower CityCantina Static Objects
  spawnSceneObject("coruscant", "object/static/structure/general/streetlamp_small_blue_style_01_on.iff", 27.1, -0.9, 12.0, 37000970, math.rad(0) )
  spawnSceneObject("coruscant", "object/static/structure/general/streetlamp_small_blue_style_01_on.iff", 27.1, -0.9, -10.9, 37000970, math.rad(0) )
  spawnSceneObject("coruscant", "object/static/structure/general/streetlamp_small_blue_style_01_on.iff", -16.4, -0.9, 0.4, 37000970, math.rad(0) )
  spawnSceneObject("coruscant", "object/static/structure/general/streetlamp_small_blue_style_01_on.iff", 15.0, -0.9, -3.9, 37000970, math.rad(0) )
  spawnSceneObject("coruscant", "object/static/structure/general/streetlamp_small_blue_style_01_on.iff", 15.6, -0.9, 5.7, 37000970, math.rad(0) )
  spawnSceneObject("coruscant", "object/static/structure/general/streetlamp_small_blue_style_01_on.iff", -1.2, -0.9, 11.3, 37000970, math.rad(0) )
  spawnSceneObject("coruscant", "object/static/structure/general/streetlamp_small_blue_style_01_on.iff", 11.8, -0.9, -10.2, 37000970, math.rad(0) )
  spawnSceneObject("coruscant", "object/static/structure/general/streetlamp_small_blue_style_01_on.iff", -1.1, -0.9, -10.3, 37000970, math.rad(0) )
  spawnSceneObject("coruscant", "object/static/structure/general/streetlamp_small_blue_style_01_on.iff", -11.4, -0.9, -7.6, 37000970, math.rad(0) )
  spawnSceneObject("coruscant", "object/static/item/item_scrolling_screen.iff", 9.8, 3.6, 0.1, 37000970, math.rad(0) )
 
  --Lower City Bank
  spawnSceneObject("coruscant", "object/building/corellia/bank_corellia.iff", -5733, 0, -4968, 0, math.rad(0) )
  spawnSceneObject("coruscant", "object/building/corellia/garage_corellia.iff", -5745, 0, -5075, 0, math.rad(0) )
  
  
  -- Collecte commerce district uprising objects
  
  spawnSceneObject("coruscant", "object/static/structure/military/military_wall_weak_imperial_style_01.iff", -1815, 38, -47, 0, math.rad(15) )
  spawnSceneObject("coruscant", "object/static/structure/military/military_wall_weak_imperial_style_01.iff", -1825, 38, -38, 0, math.rad(45) )
  spawnSceneObject("coruscant", "object/static/structure/military/military_wall_weak_imperial_style_01.iff", -1828, 38, -25, 0, math.rad(75) )
-- lower city shuttle
  spawnSceneObject("coruscant", "object/building/player/city/shuttleport_corellia.iff", -5816, 0, -4833, 0, math.rad(180) )
  
  
 -- Imperial Palace 
  spawnSceneObject("coruscant", "object/tangible/veteran_reward/frn_vet_emp_chair.iff", 4.1, 334.0, 23.5, 37002514, math.rad(180) )
  
  spawnSceneObject("coruscant", "object/tangible/furniture/all/frn_all_jedi_council_seat.iff", -57.3, 306.0, 58.5, 37002516, math.rad(-40) )
  spawnSceneObject("coruscant", "object/tangible/furniture/all/frn_all_jedi_council_seat.iff", -55.3, 306.0, 61.9, 37002516, math.rad(-75) )
  spawnSceneObject("coruscant", "object/tangible/furniture/all/frn_all_jedi_council_seat.iff", -55.3, 306.0, 65.5, 37002516, math.rad(-109) )
  spawnSceneObject("coruscant", "object/tangible/furniture/all/frn_all_jedi_council_seat.iff", -57.3, 306.0, 68.8, 37002516, math.rad(-137) ) 
  spawnSceneObject("coruscant", "object/tangible/furniture/all/frn_all_jedi_council_seat.iff", -60.4, 306.0, 70.9, 37002516, math.rad(-164) )
  spawnSceneObject("coruscant", "object/tangible/furniture/all/frn_all_jedi_council_seat.iff", -64.4, 306.0, 70.9, 37002516, math.rad(164) )
  spawnSceneObject("coruscant", "object/tangible/furniture/all/frn_all_jedi_council_seat.iff", -67.7, 306.0, 68.9, 37002516, math.rad(134) )
  spawnSceneObject("coruscant", "object/tangible/furniture/all/frn_all_jedi_council_seat.iff", -69.7, 306.0, 65.7, 37002516, math.rad(104) )
  spawnSceneObject("coruscant", "object/tangible/furniture/all/frn_all_jedi_council_seat.iff", -69.6, 306.0, 61.9, 37002516, math.rad(75) )
  spawnSceneObject("coruscant", "object/tangible/furniture/all/frn_all_jedi_council_seat.iff", -67.6, 306.0, 58.6, 37002516, math.rad(40) )
  
  
  
end

-- Each pair of endpoints lies on one unobstructed stretch of the west sidewalk.
local westBankWalks = {
  -- South end and market frontage.
  {2141, -4553, 2131, -4543},
  {2134, -4551, 2153, -4551},
  {2157, -4547, 2167, -4557},
  {2163, -4542, 2149, -4556},
  {2123, -4540, 2123, -4521},
  {2122, -4528, 2122, -4505},
  {2119, -4519, 2119, -4538},
  {2120, -4509, 2120, -4495},
  -- Between the lantern tower and the gallery.
  {2124, -4498, 2138, -4484},
  {2130, -4486, 2140, -4476},
  {2145, -4485, 2122, -4485},
  {2119, -4481, 2119, -4500},
  {2156, -4481, 2142, -4481},
  {2126, -4481, 2112, -4495},
  {2138, -4480, 2124, -4480},
  -- Sidewalk between the gallery and the west rail.
  {2163, -4468, 2163, -4445},
  {2162, -4455, 2162, -4436},
  {2163, -4442, 2163, -4419},
  {2162, -4439, 2162, -4458},
  {2163, -4428, 2163, -4442},
  -- Cross street south of the terraced drum.
  {2131, -4419, 2150, -4419},
  {2120, -4416, 2120, -4402},
  {2157, -4415, 2134, -4415},
  {2143, -4413, 2162, -4413},
  {2149, -4411, 2159, -4401},
  {2121, -4405, 2135, -4419},
  {2163, -4397, 2153, -4407},
  {2120, -4395, 2120, -4418},
  -- North market approach.
  {2163, -4367, 2153, -4357},
  {2118, -4381, 2118, -4404},
  {2163, -4364, 2153, -4354},
  {2120, -4367, 2130, -4357},
  {2154, -4359, 2168, -4359},
  {2130, -4360, 2120, -4370},
  {2166, -4357, 2143, -4357},
  {2145, -4356, 2164, -4356},
}

local function westBankWalkerKey(slot)
  return "CoruscantEntertainmentScreenPlay:westBankWalker:" .. slot
end

function CoruscantEntertainmentScreenPlay:spawnWestBankWalker(pUnused, args)
  local slot = tonumber(args)
  local walk = westBankWalks[slot]
  if walk == nil or not isZoneEnabled("coruscant") then return end

  local key = westBankWalkerKey(slot)
  if getSceneObject(readData(key)) ~= nil then return end

  local atan2 = math.atan2 or math.atan
  local heading = math.deg(atan2(walk[3] - walk[1], walk[4] - walk[2]))
  local pNpc = spawnMobile("coruscant", "coruscant_promenade_pedestrian", 0, walk[1], 0, walk[2], heading, 0)
  if pNpc == nil then
    createEvent(60000, self.screenplayName, "spawnWestBankWalker", nil, tostring(slot))
    return
  end

  local id = SceneObject(pNpc):getObjectID()
  writeData(key, id)
  writeData(id .. ":westBankWalk", slot)
  self:setMoodString(pNpc, "neutral")
  AiAgent(pNpc):setMovementState(AI_PATROLLING)
  createObserver(DESTINATIONREACHED, self.screenplayName, "westBankWalkerArrived", pNpc)
  createObserver(CREATUREDESPAWNED, self.screenplayName, "westBankWalkerDespawned", pNpc)
  self:westBankWalkerArrived(pNpc)
end

function CoruscantEntertainmentScreenPlay:westBankWalkerArrived(pNpc)
  if pNpc == nil then return 1 end
  createEvent(getRandomNumber(3000, 9000), self.screenplayName, "walkWestBankWalker", pNpc, "")
  return 0
end

function CoruscantEntertainmentScreenPlay:walkWestBankWalker(pNpc)
  if pNpc == nil then return end
  local npc = SceneObject(pNpc)
  local walk = westBankWalks[readData(npc:getObjectID() .. ":westBankWalk")]
  if walk == nil or npc:getZoneName() ~= "coruscant" or CreatureObject(pNpc):isDead() then return end

  local agent = AiAgent(pNpc)
  if agent:getPatrolPointsSize() == 0 then
    local x, y = walk[1], walk[2]
    if npc:getDistanceToPosition(x, 0, y) < npc:getDistanceToPosition(walk[3], 0, walk[4]) then
      x, y = walk[3], walk[4]
    end
    agent:setNextPosition(x, 0, y, 0)
  end
end

function CoruscantEntertainmentScreenPlay:westBankWalkerDespawned(pNpc)
  if pNpc == nil then return 1 end
  local id = SceneObject(pNpc):getObjectID()
  local slot = readData(id .. ":westBankWalk")
  deleteData(id .. ":westBankWalk")
  if westBankWalks[slot] ~= nil and readData(westBankWalkerKey(slot)) == id then
    deleteData(westBankWalkerKey(slot))
    createEvent(60000, self.screenplayName, "spawnWestBankWalker", nil, tostring(slot))
  end
  return 1
end

function CoruscantEntertainmentScreenPlay:spawnPromenadePedestrians()
  for slot = 1, #westBankWalks do
    self:spawnWestBankWalker(nil, slot)
  end

  local pedestrians = {
    -- Shuttleport forecourt and the approaches on either side of the terminal.
    {2239, -4543, -134},
    {2257, -4545, -116},
    {2264, -4541, 163},
    {2271, -4551, -88},
    {2276, -4561, -166},
    {2272, -4572, 62},
    {2269, -4584, -112},
    {2259, -4589, -88},
    {2239, -4585, 52},
    {2229, -4578, 118},
    {2227, -4561, 71},
    {2230, -4557, 24},

    -- Spectators facing the dancing hologram from outside the dais.
    {2256, -4523, 65, "entertained"},
    {2260, -4529, 37, "entertained"},
    {2264, -4533, 17, "entertained"},
    {2272, -4531, -12, "entertained"},
    {2281, -4528, -47, "entertained"},
    {2284, -4521, -75, "entertained"},
    {2283, -4511, -113, "entertained"},
    {2278, -4506, -141, "entertained"},
    {2272, -4502, -169, "entertained"},
    {2263, -4503, 157, "entertained"},
    {2258, -4509, 126, "entertained"},
    {2253, -4516, 94, "entertained"}
  }

  for _, pedestrian in ipairs(pedestrians) do
    local pNpc = spawnMobile("coruscant", "commoner", 60, pedestrian[1], 0, pedestrian[2], pedestrian[3], 0)
    self:setMoodString(pNpc, pedestrian[4] or "neutral")
  end
end

function CoruscantEntertainmentScreenPlay:spawnMobiles()
  self:spawnPromenadePedestrians()

	--Entertainment District Exterior
	
  local pNpc = spawnMobile("coruscant", "at_st", 60, 443, 6, -2928, 0, 0)
  self:setMoodString(pNpc, "neutral")
  --AiAgent(pMobile):addCreatureFlag(AI_STATIC)
  
  pNpc = spawnMobile("coruscant", "commoner", 60, 2253, 0, -4413, 12, 0)
  self:setMoodString(pNpc, "neutral")
  --AiAgent(pMobile):addCreatureFlag(AI_STATIC)
  
  pNpc = spawnMobile("coruscant", "commoner", 60, 2257, 0, -4419, 20, 0)
  self:setMoodString(pNpc, "neutral")
 -- AiAgent(pMobile):addCreatureFlag(AI_STATIC)
  
  pNpc = spawnMobile("coruscant", "commoner", 60, 2251, 0, -4417, 90, 0)
  self:setMoodString(pNpc, "neutral")
 -- AiAgent(pMobile):addCreatureFlag(AI_STATIC)
  
  pNpc = spawnMobile("coruscant", "commoner", 60, 2245, 0, -4425, 135, 0)
  self:setMoodString(pNpc, "neutral")
 -- AiAgent(pMobile):addCreatureFlag(AI_STATIC)
  
  pNpc = spawnMobile("coruscant", "commoner", 60, 2254, 0, -4430, 0, 0)
  self:setMoodString(pNpc, "neutral")
 -- AiAgent(pMobile):addCreatureFlag(AI_STATIC)
  
  pNpc = spawnMobile("coruscant", "commoner", 60, 2239, 0, -4416, 118, 0)
  self:setMoodString(pNpc, "neutral")
 -- AiAgent(pMobile):addCreatureFlag(AI_STATIC)
  
  pNpc = spawnMobile("coruscant", "commoner", 60, 2245, 0, -4406, 180, 0)
  self:setMoodString(pNpc, "neutral")
 -- AiAgent(pMobile):addCreatureFlag(AI_STATIC)
  
  pNpc = spawnMobile("coruscant", "commoner", 60, 2254, 0, -4406, -122, 0)
  self:setMoodString(pNpc, "neutral")
  --AiAgent(pMobile):addCreatureFlag(AI_STATIC)
  
  pNpc = spawnMobile("coruscant", "commoner", 60, 2243, 0, -4394, 12, 0)
  self:setMoodString(pNpc, "neutral")
 -- AiAgent(pMobile):addCreatureFlag(AI_STATIC)
  
  pNpc = spawnMobile("coruscant", "commoner", 60, 2249, 0, -4378, 22, 0)
  self:setMoodString(pNpc, "neutral")
--  AiAgent(pMobile):addCreatureFlag(AI_STATIC)
  
  pNpc = spawnMobile("coruscant", "commoner", 60, 2243, 0, -4373, 108, 0)
  self:setMoodString(pNpc, "neutral")
--  AiAgent(pMobile):addCreatureFlag(AI_STATIC)
  
  pNpc = spawnMobile("coruscant", "commoner", 60, 2255, 0, -4367, -118, 0)
  self:setMoodString(pNpc, "neutral")
--  AiAgent(pMobile):addCreatureFlag(AI_STATIC)
  
  pNpc = spawnMobile("coruscant", "commoner", 60, 2247, 0, -4440, 2, 0)
  self:setMoodString(pNpc, "neutral")
 -- AiAgent(pMobile):addCreatureFlag(AI_STATIC)
  
  pNpc = spawnMobile("coruscant", "commoner", 60, 2239, 0, -4436, 100, 0)
  self:setMoodString(pNpc, "neutral")
 -- AiAgent(pMobile):addCreatureFlag(AI_STATIC)
  
  pNpc = spawnMobile("coruscant", "commoner", 60, 2257, 0, -4445, -126, 0)
  self:setMoodString(pNpc, "neutral")
--  AiAgent(pMobile):addCreatureFlag(AI_STATIC)
    
  pNpc = spawnMobile("coruscant", "commoner", 60, 2249, 0, -4452, 179, 0)
  self:setMoodString(pNpc, "neutral")
 -- AiAgent(pMobile):addCreatureFlag(AI_STATIC)
    
  pNpc = spawnMobile("coruscant", "commoner", 60, 2246, 0, -4362, 0, 0)
  self:setMoodString(pNpc, "neutral")
 -- AiAgent(pMobile):addCreatureFlag(AI_STATIC)
  
  pNpc = spawnMobile("coruscant", "commoner", 60, 2243, 0, -4478, 55, 0)
  self:setMoodString(pNpc, "neutral")
 -- AiAgent(pMobile):addCreatureFlag(AI_STATIC)
   
  pNpc = spawnMobile("coruscant", "commoner", 60, 2249, 0, -4476, -132, 0)
  self:setMoodString(pNpc, "neutral")
 -- AiAgent(pMobile):addCreatureFlag(AI_STATIC)
    
  pNpc = spawnMobile("coruscant", "commoner", 60, 2253, 0, -4487, 177, 0)
  self:setMoodString(pNpc, "neutral")
  --AiAgent(pMobile):addCreatureFlag(AI_STATIC)
  
  pNpc = spawnMobile("coruscant", "commoner", 60, 2257, 0, -4496, -155, 0)
  self:setMoodString(pNpc, "neutral")
 -- AiAgent(pMobile):addCreatureFlag(AI_STATIC) 
  
  pNpc = spawnMobile("coruscant", "commoner", 60, 2246, 0, -4502, 97, 0)
  self:setMoodString(pNpc, "neutral")
 -- AiAgent(pMobile):addCreatureFlag(AI_STATIC) 
  
  pNpc = spawnMobile("coruscant", "commoner", 60, 2241, 0, -4512, -1, 0)
  self:setMoodString(pNpc, "neutral")
--  AiAgent(pMobile):addCreatureFlag(AI_STATIC)
  
  pNpc = spawnMobile("coruscant", "commoner", 60, 2257, 0, -4515, -176, 0)
  self:setMoodString(pNpc, "neutral")
 -- AiAgent(pMobile):addCreatureFlag(AI_STATIC)
    
  pNpc = spawnMobile("coruscant", "commoner", 60, 2252, 0, -4539, -18, 0)
  self:setMoodString(pNpc, "neutral")
 -- AiAgent(pMobile):addCreatureFlag(AI_STATIC)
  
  spawnMobile("coruscant", "civilian_patrolman", 60, 2238, 0, -4546, 90, 0)
  
  
  
  spawnMobile("coruscant", "civilian_patrolman", 60, 2236, 0, -4469, 90, 0)
  
  spawnMobile("coruscant", "civilian_patrolman", 60, 2236, 0, -4395, 90, 0)
 
  --  Cantina 1 
  spawnMobile("coruscant", "bartender", 60, 0.3, 0.3, 4.4, 176, 37000721)

  -- Entertainment District cabaret audience
  local cabaretAudience = {
    {"patron", 0.0, -0.7, -7.3, 180, "npc_sitting_chair"},
    {"patron", -3.1, -0.7, -8.0, 142, "npc_sitting_chair"},
    {"patron", 3.1, -0.7, -8.0, -142, "npc_sitting_chair"},
    {"patron", -6.1, -0.7, -6.9, 142, "npc_sitting_chair"},
    {"patron", 6.1, -0.7, -6.9, -142, "npc_sitting_chair"},
    {"commoner", -8.5, 0.5, -9.5, 105, "entertained"},
    {"commoner", 8.5, 0.5, -9.5, -105, "entertained"}
  }

  for i = 1, #cabaretAudience do
    local audienceData = cabaretAudience[i]
    local pPatron = spawnMobile("coruscant", audienceData[1], 60, audienceData[2], audienceData[3], audienceData[4], audienceData[5], 37000721)

    if pPatron ~= nil then
      AiAgent(pPatron):addObjectFlag(AI_STATIC)
      self:setMoodString(pPatron, audienceData[6])
    end
  end

  --
  spawnMobile("coruscant", "bartender", 60, 0.95, 0.25, -7.13, 20, 37000714)
  spawnMobile("coruscant", "bartender", 60, 0.3, 0.3, 4.4, 176, 37000316)

  -- Starport District gambling den patrons
  local jubileeGamblers = {
    {"gambler", -1.7, -0.7, -6.0, 90},
    {"gambler", 1.7, -0.7, -6.0, -90},
    {"gambler", 3.5, -0.7, -7.3, -135},
    {"gambler", 6.2, -0.7, -7.2, -135},
    {"gambler", -3.5, -0.7, -7.3, 135},
    {"gambler", -6.2, -0.7, -9.7, -45}
  }

  for i = 1, #jubileeGamblers do
    local gamblerData = jubileeGamblers[i]
    local pGambler = spawnMobile("coruscant", gamblerData[1], 60, gamblerData[2], gamblerData[3], gamblerData[4], gamblerData[5], 37000316)

    if pGambler ~= nil then
      AiAgent(pGambler):addObjectFlag(AI_STATIC)
      self:setMoodString(pGambler, "neutral")
    end
  end
 
  
	--  :: Starport District NPCs :: --
	
	
	spawnMobile("coruscant", "stormtrooper", 60, -69.2, 40, 3137, -99, 0)
	spawnMobile("coruscant", "stormtrooper", 60, -70.9, 40, 3146.4, -130, 0)
  spawnMobile("coruscant", "stormtrooper", 60, -167.8, 40, 3130.5, 79, 0)
  spawnMobile("coruscant", "stormtrooper", 60, -114.9, 40, 3216.3, -58, 0)
  spawnMobile("coruscant", "stormtrooper", 60, -123.8, 40, 3216.3, 58, 0)
  spawnMobile("coruscant", "stormtrooper", 60, -29.3, 40.4, 3190, -75, 0)
  
 
  
  pNpc = spawnMobile("coruscant", "at_st", 60, -176, 40, 3245, 90, 0)
  self:setMoodString(pNpc, "neutral")
 -- AiAgent(pMobile):addCreatureFlag(AI_STATIC)
  
  spawnMobile("coruscant", "commoner", 60, -121, 40, 3259, 22, 0)
  
  pNpc = spawnMobile("coruscant", "commoner", 60, -116, 40, 3231, -148, 0)
  self:setMoodString(pNpc, "conversation")
  
  pNpc = spawnMobile("coruscant", "commoner", 60, -118.4, 40, 3228.1, 46, 0)
  self:setMoodString(pNpc, "conversation")
  
  spawnMobile("coruscant", "commoner", 60, -129, 40, 3231, 143, 0)
  
  --Imp Bunker
  spawnMobile("coruscant", "fbase_specialist_noncom", 60, 7.0, -6.7, -8.0, -94, 37000432)
  spawnMobile("coruscant", "fbase_specialist_noncom", 60, 2.0, -6.7, -8.0, 94, 37000432) 
  spawnMobile("coruscant", "fbase_stormtrooper_medic", 60, 6.9, -13.8, 13.9, 174, 37000435) 
  spawnMobile("coruscant", "fbase_dark_trooper_hard", 60, 15.7, -13.8, -15.0, 0, 37000437)
  
  spawnMobile("coruscant", "stormtrooper", 60, -176.1, 40, 3272.3, 90, 0)
  spawnMobile("coruscant", "stormtrooper", 60, -176.1, 40, 3261.9, 90, 0) 
  
  pNpc = spawnMobile("coruscant", "at_st", 60, -69, 40, 3216, 0, 0)
  self:setMoodString(pNpc, "neutral")
 -- AiAgent(pMobile):addCreatureFlag(AI_STATIC)
  
  spawnMobile("coruscant", "imperial_recruiter", 60, -188.7, 40, 3269.4, 90, 0) 
  
  -- :: Monument Square :: --
  spawnMobile("coruscant", "stormtrooper", 60, 1551.5, 40, 775.7, 180, 0) 
  
  pNpc = spawnMobile("coruscant", "at_st", 60, 1655.6, 40, 648.8, -90, 0)
  self:setMoodString(pNpc, "neutral")
 -- AiAgent(pMobile):addCreatureFlag(AI_STATIC)
  
  pNpc = spawnMobile("coruscant", "at_st", 60, 1541.3, 40, 574.3, 0, 0)
  self:setMoodString(pNpc, "neutral")
 -- AiAgent(pMobile):addCreatureFlag(AI_STATIC)
  
  pNpc = spawnMobile("coruscant", "at_st", 60, 1490, 40, 655, 90, 0)
  self:setMoodString(pNpc, "neutral")
 -- AiAgent(pMobile):addCreatureFlag(AI_STATIC)
  
  pNpc = spawnMobile("coruscant", "at_st", 60, 1484, 40, 753, 151, 0)
  self:setMoodString(pNpc, "neutral")
--  AiAgent(pMobile):addCreatureFlag(AI_STATIC)
  
  pNpc = spawnMobile("coruscant", "at_st", 60, 1596, 40, 740, -124, 0)
  self:setMoodString(pNpc, "neutral")
--  AiAgent(pMobile):addCreatureFlag(AI_STATIC)
  
  spawnMobile("coruscant", "stormtrooper", 60, 1660.6, 40, 619.8, 0, 0)
  spawnMobile("coruscant", "stormtrooper", 60, 1649.4, 40, 619.8, 0, 0)
  
  spawnMobile("coruscant", "imperial_recruiter", 60, 1653, 40, 606.9, 90, 0) 
  
  spawnMobile("coruscant", "fbase_dark_trooper_hard", 60, 4.4, -6.8, -7.2, 0, 37000254)  
  spawnMobile("coruscant", "fbase_stormtrooper_medic_hard", 60, 6.6, -13.8, 10.5, 0, 37000257)  
  spawnMobile("coruscant", "fbase_imperial_colonel", 60, 13.6, -13.8, 4.9, 64, 37000258)  
  spawnMobile("coruscant", "fbase_imperial_corporal", 60, 17.7, -11.5, -21.3, 168, 37000259)
  
  spawnMobile("coruscant", "stormtrooper", 60, 1525, 40, 718, 0, 0)
  spawnMobile("coruscant", "stormtrooper", 60, 1527, 40, 718, 0, 0)
  spawnMobile("coruscant", "stormtrooper", 60, 1529, 40, 718, 0, 0) 
  spawnMobile("coruscant", "stormtrooper", 60, 1531, 40, 718, 0, 0)
  spawnMobile("coruscant", "stormtrooper", 60, 1533, 40, 718, 0, 0)
  spawnMobile("coruscant", "stormtrooper", 60, 1535, 40, 718, 0, 0)
  spawnMobile("coruscant", "stormtrooper", 60, 1537, 40, 718, 0, 0)
  spawnMobile("coruscant", "stormtrooper", 60, 1539, 40, 718, 0, 0)
  spawnMobile("coruscant", "stormtrooper", 60, 1541, 40, 718, 0, 0)
  spawnMobile("coruscant", "stormtrooper", 60, 1543, 40, 718, 0, 0)
  
  spawnMobile("coruscant", "stormtrooper", 60, 1525, 40, 720, 0, 0)
  spawnMobile("coruscant", "stormtrooper", 60, 1527, 40, 720, 0, 0)
  spawnMobile("coruscant", "stormtrooper", 60, 1529, 40, 720, 0, 0) 
  spawnMobile("coruscant", "stormtrooper", 60, 1531, 40, 720, 0, 0)
  spawnMobile("coruscant", "stormtrooper", 60, 1533, 40, 720, 0, 0)
  spawnMobile("coruscant", "stormtrooper", 60, 1535, 40, 720, 0, 0)
  spawnMobile("coruscant", "stormtrooper", 60, 1537, 40, 720, 0, 0)
  spawnMobile("coruscant", "stormtrooper", 60, 1539, 40, 720, 0, 0)
  spawnMobile("coruscant", "stormtrooper", 60, 1541, 40, 720, 0, 0)
  spawnMobile("coruscant", "stormtrooper", 60, 1543, 40, 720, 0, 0)
  
  spawnMobile("coruscant", "stormtrooper", 60, 1525, 40, 722, 0, 0)
  spawnMobile("coruscant", "stormtrooper", 60, 1527, 40, 722, 0, 0)
  spawnMobile("coruscant", "stormtrooper", 60, 1529, 40, 722, 0, 0) 
  spawnMobile("coruscant", "stormtrooper", 60, 1531, 40, 722, 0, 0)
  spawnMobile("coruscant", "stormtrooper", 60, 1533, 40, 722, 0, 0)
  spawnMobile("coruscant", "stormtrooper", 60, 1535, 40, 722, 0, 0)
  spawnMobile("coruscant", "stormtrooper", 60, 1537, 40, 722, 0, 0)
  spawnMobile("coruscant", "stormtrooper", 60, 1539, 40, 722, 0, 0)
  spawnMobile("coruscant", "stormtrooper", 60, 1541, 40, 722, 0, 0)
  spawnMobile("coruscant", "stormtrooper", 60, 1543, 40, 722, 0, 0)
  
  spawnMobile("coruscant", "stormtrooper", 60, 1525, 40, 724, 0, 0)
  spawnMobile("coruscant", "stormtrooper", 60, 1527, 40, 724, 0, 0)
  spawnMobile("coruscant", "stormtrooper", 60, 1529, 40, 724, 0, 0) 
  spawnMobile("coruscant", "stormtrooper", 60, 1531, 40, 724, 0, 0)
  spawnMobile("coruscant", "stormtrooper", 60, 1533, 40, 724, 0, 0)
  spawnMobile("coruscant", "stormtrooper", 60, 1535, 40, 724, 0, 0)
  spawnMobile("coruscant", "stormtrooper", 60, 1537, 40, 724, 0, 0)
  spawnMobile("coruscant", "stormtrooper", 60, 1539, 40, 724, 0, 0)
  spawnMobile("coruscant", "stormtrooper", 60, 1541, 40, 724, 0, 0)
  spawnMobile("coruscant", "stormtrooper", 60, 1543, 40, 724, 0, 0)
  
  pNpc = spawnMobile("coruscant", "imperial_moff", 60, 1534, 40, 728.6, 180, 0)
  self:setMoodString(pNpc, "conversation")
 

  
  
  --  Collective Commerce District NPCs
  
  pNpc = spawnMobile("coruscant", "commoner", 60, 3.3, 0.1, 3.4, -90, 37000549)
  self:setMoodString(pNpc, "npc_sitting_chair")
  
  pNpc = spawnMobile("coruscant", "commoner", 60, 1.0, 0.1, 3.4, 90, 37000549)
  self:setMoodString(pNpc, "npc_sitting_chair")
  
  pNpc = spawnMobile("coruscant", "commoner", 60, -0.6, 0.1, 3.4, -90, 37000549)
  self:setMoodString(pNpc, "npc_sitting_chair")
  
  pNpc = spawnMobile("coruscant", "commoner", 60, -3.2, 0.1, 3.4, 90, 37000549)
  self:setMoodString(pNpc, "npc_sitting_chair")
  
  pNpc = spawnMobile("coruscant", "commoner", 60, -4.5, 0.1, 3.4, -90, 37000549)
  self:setMoodString(pNpc, "npc_sitting_chair")
  
  pNpc = spawnMobile("coruscant", "commoner", 60, -6.6, 0.1, 3.4, 90, 37000549)
  self:setMoodString(pNpc, "npc_sitting_chair")
  
  pNpc = spawnMobile("coruscant", "commoner", 60, -5.7, 0.1, -0.3, -150, 37000549)
  self:setMoodString(pNpc, "conversation")
  
  pNpc = spawnMobile("coruscant", "commoner", 60, -7.0, 0.1, -1.8, 32, 37000549)
  self:setMoodString(pNpc, "conversation")
  
  pNpc = spawnMobile("coruscant", "commoner", 60, -2.3, 0.1, -0.1, 172, 37000549)
  self:setMoodString(pNpc, "angry")
  
  spawnMobile("coruscant", "r4", 60, -1851.8, 40, -143.6, 9, 0)
  
  pNpc = spawnMobile("coruscant", "commoner_fat", 60, -1852.1, 40, -141.5, 165, 0)
  self:setMoodString(pNpc, "conversation")
  
  spawnMobile("coruscant", "commoner", 60, -1853.8, 40, -128.2, -80, 0)
  spawnMobile("coruscant", "commoner", 60, -1879.2, 40, -122.7, 95, 0)
  spawnMobile("coruscant", "commoner", 60, -1912.6, 40, -119.8, -110, 0)
  spawnMobile("coruscant", "commoner", 60, -1929.6, 40, -133.6, 179, 0)
  spawnMobile("coruscant", "commoner", 60, -1916.9, 40, -170.7, -7, 0)
  spawnMobile("coruscant", "commoner", 60, -1931.8, 40, -196.3, 34, 0)
  
  pNpc = spawnMobile("coruscant", "commoner_fat", 60, -1888.2, 40, -192.3, -175, 0)
  self:setMoodString(pNpc, "conversation")
  
  pNpc = spawnMobile("coruscant", "commoner_fat", 60, -1889.6, 40, -195.9, 22, 0)
  self:setMoodString(pNpc, "conversation")
  
  spawnMobile("coruscant", "commoner", 60, -1874.8, 40, -153.9, 0, 0)
  
  pNpc = spawnMobile("coruscant", "commoner", 60, -1847.3, 40, -163.8, 175, 0)
  self:setMoodString(pNpc, "conversation")
  
  pNpc = spawnMobile("coruscant", "commoner_fat", 60, -1847.8, 40, -166.6, 8, 0)
  self:setMoodString(pNpc, "conversation")
  
  spawnMobile("coruscant", "commoner", 60, -1846.0, 40, -197.3, 51, 0)
  
  pNpc = spawnMobile("coruscant", "commoner_fat", 60, -1874.2, 40, -96.2, 48, 0)
  self:setMoodString(pNpc, "conversation")
  
  pNpc = spawnMobile("coruscant", "commoner", 60, -1871.3, 40, -93.1, -127, 0)
  self:setMoodString(pNpc, "angry")
  
  spawnMobile("coruscant", "commoner", 60, -1902.8, 40, -77.2, -91, 0)
  
  pNpc = spawnMobile("coruscant", "commoner", 60, -1921.7, 40, -101.2, -30, 0)
  self:setMoodString(pNpc, "conversation")
  
  pNpc = spawnMobile("coruscant", "commoner", 60, -1924.6, 40, -98, 132, 0)
  self:setMoodString(pNpc, "conversation")
  
  spawnMobile("coruscant", "commoner", 60, -1928.5, 40, -58.6, 0, 0)
  spawnMobile("coruscant", "commoner", 60, -1966.5, 40, -15.6, -141, 0)
  spawnMobile("coruscant", "commoner", 60, -1993.2, 40, -39.5, 178, 0)
  spawnMobile("coruscant", "commoner", 60, -1979.8, 40, -85.3, -9, 0)
  spawnMobile("coruscant", "commoner", 60, -1988.6, 40, -113.4, -178, 0)
  spawnMobile("coruscant", "commoner", 60, -1977.9, 40, -154.9, -102, 0)
  spawnMobile("coruscant", "commoner", 60, -1971.9, 40, -199.4, 85, 0)
  
  spawnMobile("coruscant", "imperial_first_lieutenant", 60, -1809.2, 47, -22.1, -142, 0)
  spawnMobile("coruscant", "imperial_first_lieutenant", 60, -1804.8, 47, -23.9, 178, 0)
  spawnMobile("coruscant", "imperial_first_lieutenant", 60, -1811, 47, -18, -90, 0)
  
  spawnMobile("coruscant", "stormtrooper", 60, 4.0, 0.5, 2.7, 176, 37000756)
  spawnMobile("coruscant", "stormtrooper", 60, -1799.1, 40, -21.8, 85, 0)
  spawnMobile("coruscant", "stormtrooper", 60, -1800.9, 40, -26.9, 176, 0)
  spawnMobile("coruscant", "stormtrooper", 60, -1808.9, 40, -26.9, 176, 0)
  spawnMobile("coruscant", "stormtrooper", 60, -1813.7, 40, -21.9, -90, 0)
  spawnMobile("coruscant", "stormtrooper", 60, -1813.7, 40, -14.1, -90, 0)
  
  
  
  -- Lower City 1312
    -- Race Spectators  Row 1 Westside
    
  
  pNpc = spawnMobile("coruscant", "commoner", 60, -5856, 0, -4821, -90, 0)
  self:setMoodString(pNpc, "entertained")
  CreatureObject(pNpc):clearOptionBit(AIENABLED)
   
  pNpc = spawnMobile("coruscant", "commoner", 60, -5856, 0, -4825, -90, 0)
  self:setMoodString(pNpc, "entertained")
  CreatureObject(pNpc):clearOptionBit(AIENABLED)
   
  pNpc = spawnMobile("coruscant", "commoner", 60, -5856, 0, -4829, -90, 0)
  self:setMoodString(pNpc, "entertained")
  CreatureObject(pNpc):clearOptionBit(AIENABLED)
   
  pNpc = spawnMobile("coruscant", "commoner", 60, -5856, 0, -4833, -90, 0)
  self:setMoodString(pNpc, "entertained")
  CreatureObject(pNpc):clearOptionBit(AIENABLED)
   
  pNpc = spawnMobile("coruscant", "commoner", 60, -5856, 0, -4837, -90, 0)
  self:setMoodString(pNpc, "entertained")
  CreatureObject(pNpc):clearOptionBit(AIENABLED)
   
  pNpc = spawnMobile("coruscant", "commoner", 60, -5856, 0, -4841, -90, 0)
  self:setMoodString(pNpc, "entertained")
  CreatureObject(pNpc):clearOptionBit(AIENABLED)
   
  pNpc = spawnMobile("coruscant", "commoner", 60, -5856, 0, -4845, -90, 0)
  self:setMoodString(pNpc, "entertained")
  CreatureObject(pNpc):clearOptionBit(AIENABLED)
   
  pNpc = spawnMobile("coruscant", "commoner", 60, -5856, 0, -4849, -90, 0)
  self:setMoodString(pNpc, "entertained")
  CreatureObject(pNpc):clearOptionBit(AIENABLED)
   
  pNpc = spawnMobile("coruscant", "commoner", 60, -5856, 0, -4853, -90, 0)
  self:setMoodString(pNpc, "entertained")
  CreatureObject(pNpc):clearOptionBit(AIENABLED)
   
  pNpc = spawnMobile("coruscant", "commoner", 60, -5856, 0, -4857, -90, 0)
  self:setMoodString(pNpc, "entertained")
  CreatureObject(pNpc):clearOptionBit(AIENABLED)
    
  pNpc = spawnMobile("coruscant", "commoner", 60, -5856, 0, -4861, -90, 0)
  self:setMoodString(pNpc, "entertained")
  CreatureObject(pNpc):clearOptionBit(AIENABLED)
  
  pNpc = spawnMobile("coruscant", "commoner", 60, -5856, 0, -4865, -90, 0)
  self:setMoodString(pNpc, "entertained")
  CreatureObject(pNpc):clearOptionBit(AIENABLED)
  
  pNpc = spawnMobile("coruscant", "commoner", 60, -5856, 0, -4869, -90, 0)
  self:setMoodString(pNpc, "entertained")
  CreatureObject(pNpc):clearOptionBit(AIENABLED)
  
  pNpc = spawnMobile("coruscant", "commoner", 60, -5856, 0, -4873, -90, 0)
  self:setMoodString(pNpc, "entertained")
  CreatureObject(pNpc):clearOptionBit(AIENABLED)
  
  pNpc = spawnMobile("coruscant", "commoner", 60, -5856, 0, -4877, -90, 0)
  self:setMoodString(pNpc, "entertained")
  CreatureObject(pNpc):clearOptionBit(AIENABLED)
  
  pNpc = spawnMobile("coruscant", "commoner", 60, -5856, 0, -4881, -90, 0)
  self:setMoodString(pNpc, "entertained")
  CreatureObject(pNpc):clearOptionBit(AIENABLED)
  
  pNpc = spawnMobile("coruscant", "commoner", 60, -5856, 0, -4885, -90, 0)
  self:setMoodString(pNpc, "entertained")
  CreatureObject(pNpc):clearOptionBit(AIENABLED)
  
  pNpc = spawnMobile("coruscant", "commoner", 60, -5856, 0, -4889, -90, 0)
  self:setMoodString(pNpc, "entertained")
  CreatureObject(pNpc):clearOptionBit(AIENABLED)
  
  pNpc = spawnMobile("coruscant", "commoner", 60, -5856, 0, -4894, -90, 0)
  self:setMoodString(pNpc, "entertained")
  CreatureObject(pNpc):clearOptionBit(AIENABLED)
  
  pNpc = spawnMobile("coruscant", "commoner", 60, -5856, 0, -4898, -90, 0)
  self:setMoodString(pNpc, "entertained")
  CreatureObject(pNpc):clearOptionBit(AIENABLED)
  
  pNpc = spawnMobile("coruscant", "commoner", 60, -5856, 0, -4902, -90, 0)
  self:setMoodString(pNpc, "entertained")
  CreatureObject(pNpc):clearOptionBit(AIENABLED)
  
  pNpc = spawnMobile("coruscant", "commoner", 60, -5856, 0, -4906, -90, 0)
  self:setMoodString(pNpc, "entertained")
  CreatureObject(pNpc):clearOptionBit(AIENABLED)
  
  pNpc = spawnMobile("coruscant", "commoner", 60, -5856, 0, -4910, -90, 0)
  self:setMoodString(pNpc, "entertained")
  CreatureObject(pNpc):clearOptionBit(AIENABLED)
  
    -- Race Spectators Row 2 Westside
    
  pNpc = spawnMobile("coruscant", "commoner", 60, -5854, 0, -4823, -90, 0)
  self:setMoodString(pNpc, "entertained")
  CreatureObject(pNpc):clearOptionBit(AIENABLED)
    
  pNpc = spawnMobile("coruscant", "commoner", 60, -5854, 0, -4827, -90, 0)
  self:setMoodString(pNpc, "entertained")
  CreatureObject(pNpc):clearOptionBit(AIENABLED)
    
  pNpc = spawnMobile("coruscant", "commoner", 60, -5854, 0, -4831, -90, 0)
  self:setMoodString(pNpc, "entertained")
  CreatureObject(pNpc):clearOptionBit(AIENABLED)
    
  pNpc = spawnMobile("coruscant", "commoner", 60, -5854, 0, -4835, -90, 0)
  self:setMoodString(pNpc, "entertained")
  CreatureObject(pNpc):clearOptionBit(AIENABLED)
    
  pNpc = spawnMobile("coruscant", "commoner", 60, -5854, 0, -4839, -90, 0)
  self:setMoodString(pNpc, "entertained")
  CreatureObject(pNpc):clearOptionBit(AIENABLED)
    
  pNpc = spawnMobile("coruscant", "commoner", 60, -5854, 0, -4843, -90, 0)
  self:setMoodString(pNpc, "entertained")
  CreatureObject(pNpc):clearOptionBit(AIENABLED)
    
  pNpc = spawnMobile("coruscant", "commoner", 60, -5854, 0, -4847, -90, 0)
  self:setMoodString(pNpc, "entertained")
  CreatureObject(pNpc):clearOptionBit(AIENABLED)
  
    
  pNpc = spawnMobile("coruscant", "commoner", 60, -5854, 0, -4851, -90, 0)
  self:setMoodString(pNpc, "entertained")
  CreatureObject(pNpc):clearOptionBit(AIENABLED)
    
  pNpc = spawnMobile("coruscant", "commoner", 60, -5854, 0, -4855, -90, 0)
  self:setMoodString(pNpc, "entertained")
  CreatureObject(pNpc):clearOptionBit(AIENABLED)
    
  pNpc = spawnMobile("coruscant", "commoner", 60, -5854, 0, -4859, -90, 0)
  self:setMoodString(pNpc, "entertained")
  CreatureObject(pNpc):clearOptionBit(AIENABLED)
    
  pNpc = spawnMobile("coruscant", "commoner", 60, -5854, 0, -4863, -90, 0)
  self:setMoodString(pNpc, "entertained")
  CreatureObject(pNpc):clearOptionBit(AIENABLED)
  
  pNpc = spawnMobile("coruscant", "commoner", 60, -5854, 0, -4867, -90, 0)
  self:setMoodString(pNpc, "entertained")  
  CreatureObject(pNpc):clearOptionBit(AIENABLED)
  
  pNpc = spawnMobile("coruscant", "commoner", 60, -5854, 0, -4871, -90, 0)
  self:setMoodString(pNpc, "entertained")
  CreatureObject(pNpc):clearOptionBit(AIENABLED)
  
  pNpc = spawnMobile("coruscant", "commoner", 60, -5854, 0, -4875, -90, 0)
  self:setMoodString(pNpc, "entertained")
  CreatureObject(pNpc):clearOptionBit(AIENABLED)
  
  pNpc = spawnMobile("coruscant", "commoner", 60, -5854, 0, -4879, -90, 0)
  self:setMoodString(pNpc, "entertained")
  CreatureObject(pNpc):clearOptionBit(AIENABLED)
  
  pNpc = spawnMobile("coruscant", "commoner", 60, -5854, 0, -4883, -90, 0)
  self:setMoodString(pNpc, "entertained")
  CreatureObject(pNpc):clearOptionBit(AIENABLED)
  
  pNpc = spawnMobile("coruscant", "commoner", 60, -5854, 0, -4887, -90, 0)
  self:setMoodString(pNpc, "entertained")
  CreatureObject(pNpc):clearOptionBit(AIENABLED)
  
  pNpc = spawnMobile("coruscant", "commoner", 60, -5854, 0, -4891, -90, 0)
  self:setMoodString(pNpc, "entertained")
  CreatureObject(pNpc):clearOptionBit(AIENABLED)
  
  pNpc = spawnMobile("coruscant", "commoner", 60, -5854, 0, -4895, -90, 0)
  self:setMoodString(pNpc, "entertained")
  CreatureObject(pNpc):clearOptionBit(AIENABLED)
  
  pNpc = spawnMobile("coruscant", "commoner", 60, -5854, 0, -4899, -90, 0)
  self:setMoodString(pNpc, "entertained")
  CreatureObject(pNpc):clearOptionBit(AIENABLED)
  
  pNpc = spawnMobile("coruscant", "commoner", 60, -5854, 0, -4903, -90, 0)
  self:setMoodString(pNpc, "entertained")
  CreatureObject(pNpc):clearOptionBit(AIENABLED)
  
  pNpc = spawnMobile("coruscant", "commoner", 60, -5854, 0, -4907, -90, 0)
  self:setMoodString(pNpc, "entertained")
  CreatureObject(pNpc):clearOptionBit(AIENABLED)
  
  -- Lower City Market
  
  pNpc = spawnMobile("coruscant", "vendor", 60, -5747.8, 0, -4881.6, -82, 0)
  self:setMoodString(pNpc, "npc_accusing")
  
  pNpc = spawnMobile("coruscant", "vendor", 60, -5750.3, 0, -4896.8, -92, 0)
  self:setMoodString(pNpc, "angry")
  
  pNpc = spawnMobile("coruscant", "vendor", 60, -5750, 0, -4899, -102, 0)
  self:setMoodString(pNpc, "happy")
  
 
  self:setMoodString(pNpc, "neutral")
  
  pNpc = spawnMobile("coruscant", "commoner", 60, -5766.6, 0, -4918.3, -29, 0)
  self:setMoodString(pNpc, "conversation")
  
  pNpc = spawnMobile("coruscant", "commoner", 60, -5771.6, 0, -4917.5, 55, 0)
  self:setMoodString(pNpc, "conversation")
  
  pNpc = spawnMobile("coruscant", "commoner", 60, -5769.8, 0, -4910.3, 130, 0)
  self:setMoodString(pNpc, "conversation")
  
  pNpc = spawnMobile("coruscant", "commoner", 60, -5762.6, 0, -4911, -132, 0)
  self:setMoodString(pNpc, "conversation")
  
  pNpc = spawnMobile("coruscant", "smuggler", 60, -5786.8, 0, -4969.9, 0, 0)
  self:setMoodString(pNpc, "conversation")
  
  pNpc = spawnMobile("coruscant", "scoundrel", 60, -5786.8, 0, -4967.2, 180, 0)
  self:setMoodString(pNpc, "conversation")
  
  pNpc = spawnMobile("coruscant", "wookiee_brawler", 60, -5773.4, 0, -4948.9, 50, 0)
  self:setMoodString(pNpc, "npc_accusing")
  
  pNpc = spawnMobile("coruscant", "commoner", 60, -5771.8, 0, -4947.2, -139, 0)
  self:setMoodString(pNpc, "conversation")
  
  pNpc = spawnMobile("coruscant", "bounty_hunter_thug", 60, -5723.6, 0, -4842.7, 46, 0)
  self:setMoodString(pNpc, "npc_accusing")
  
  pNpc = spawnMobile("coruscant", "pirate", 60, -5720, 0, -4838.2, -146, 0)
  self:setMoodString(pNpc, "conversation")
  
  pNpc = spawnMobile("coruscant", "tough_thug_male_rodian", 60, -5703, 0, -4855.1, -60, 0)
  self:setMoodString(pNpc, "conversation")
  
  pNpc = spawnMobile("coruscant", "commoner", 60, -5716.4, 0, -4883.1, 50, 0)
  self:setMoodString(pNpc, "npc_accusing")
  
  pNpc = spawnMobile("coruscant", "gambler", 60, -5713.4, 0, -4880, -132, 0)
  self:setMoodString(pNpc, "npc_consoling")
  
  pNpc = spawnMobile("coruscant", "twilek_slave", 60, -5671.1, 0, -4903.8, -152, 0)
  self:setMoodString(pNpc, "worried")
  
  pNpc = spawnMobile("coruscant", "slaver", 60, -5672.4, 0, -4906.1, 31, 0)
  self:setMoodString(pNpc, "npc_accusing")
  
  pNpc = spawnMobile("coruscant", "slaver", 60, -5673.8, 0, -4905, 54, 0)
  self:setMoodString(pNpc, "npc_accusing")
  
  pNpc = spawnMobile("coruscant", "slavemaster", 60, -5674, 0, -4906.4, 48, 0)
  self:setMoodString(pNpc, "happy")
  
  
  pNpc = spawnMobile("coruscant", "r4", 60, -5706.7, 0, -4948.3, 114, 0)
  self:setMoodString(pNpc, "neutral")
  
  pNpc = spawnMobile("coruscant", "contractor", 60, -5705.4, 0, -4949.0, -57, 0)
  self:setMoodString(pNpc, "npc_consoling")
  
  pNpc = spawnMobile("coruscant", "tough_thug_male_rodian", 60, -5671.5, 0, -4961.9, -41, 0)
  self:setMoodString(pNpc, "neutral")
  
  pNpc = spawnMobile("coruscant", "mercenary", 60, -5680, 0, -4945, 143, 0)
  self:setMoodString(pNpc, "neutral")
  
  pNpc = spawnMobile("coruscant", "commoner", 60, -5767.0, 0, -4857.5, -133, 0)
  self:setMoodString(pNpc, "npc_accusing")
  
  pNpc = spawnMobile("coruscant", "commoner", 60, -5770.4, 0, -4859.8, 50, 0)
  self:setMoodString(pNpc, "npc_consoling")
  
  pNpc = spawnMobile("coruscant", "commoner", 60, -5754.8, 0, -4896.3, 90, 0)
  self:setMoodString(pNpc, "conversation")
  
  pNpc = spawnMobile("coruscant", "imperial_recruiter", 60, -5731, 0, -4927, 173, 0)
  self:setMoodString(pNpc, "conversation")
  
  pNpc = spawnMobile("coruscant", "commoner", 60, -5732, 0, -4930.1, 11, 0)
  self:setMoodString(pNpc, "conversation")
  
  
  pNpc = spawnMobile("coruscant", "thug", 60, -5706, 0, -4792, 0, 0)
  self:setMoodString(pNpc, "neutral")
  
  pNpc = spawnMobile("coruscant", "thug", 60, -5691, 0, -4787, -67, 0)
  self:setMoodString(pNpc, "neutral")
  
  pNpc = spawnMobile("coruscant", "thug", 60, -5695, 0, -4771, -97, 0)
  self:setMoodString(pNpc, "neutral")
  
  pNpc = spawnMobile("coruscant", "thug", 60, -5694, 0, -4764, -102, 0)
  self:setMoodString(pNpc, "neutral")
  
  pNpc = spawnMobile("coruscant", "thug", 60, -5703, 0, -4773, -80, 0)
  self:setMoodString(pNpc, "neutral")
  
  pNpc = spawnMobile("coruscant", "commoner", 60, -5787.2, 0, -4885.0, 54, 0)
  self:setMoodString(pNpc, "conversation")
  
  pNpc = spawnMobile("coruscant", "commoner", 60, -5784.5, 0, -4883.5, -128, 0)
  self:setMoodString(pNpc, "conversation")
  
  pNpc = spawnMobile("coruscant", "scavenger", 60, -5786, 0, -4793, 0, 0)
  self:setMoodString(pNpc, "angry")
  
  -- Inside LC Cantina
  
  pNpc = spawnMobile("coruscant", "entertainer", 60, 38.6, 0.1, 2.9, 133, 37000968)
  self:setMoodString(pNpc, "npc_accusing")
  
  pNpc = spawnMobile("coruscant", "smuggler", 60, 40.3, 0.1, 1.4, -57, 37000968)
  self:setMoodString(pNpc, "npc_consoling")
  
  pNpc = spawnMobile("coruscant", "commoner", 60, 30.3, 0.1, -8.7, 48, 37000969)
  self:setMoodString(pNpc, "npc_sitting_chair")
  
  pNpc = spawnMobile("coruscant", "commoner", 60, 30.1, 0.1, -5.6, 124, 37000969)
  self:setMoodString(pNpc, "npc_sitting_chair")
  
  pNpc = spawnMobile("coruscant", "bartender", 60, 8.6, -0.9, 0.6, 90, 37000970)
  self:setMoodString(pNpc, "neutral")

  pNpc = spawnMobile("coruscant", "bartender", 60, -0.9, -0.9, 3.3, 0, 37000970)
  self:setMoodString(pNpc, "conversation")
  
  pNpc = spawnMobile("coruscant", "bartender", 60, -1.7, -0.9, -2.4, -179, 37000970)
  self:setMoodString(pNpc, "npc_accusing")
  
  pNpc = spawnMobile("coruscant", "commoner", 60, -1.7, -0.9, -5.0, 0, 37000970)
  self:setMoodString(pNpc, "npc_consoling")
  
  pNpc = spawnMobile("coruscant", "patron",60,10.65,-0.894992,1.91,330,37000970)
  self:setMoodString(pNpc, "npc_standing_drinking")
  pNpc = spawnMobile("coruscant", "patron",60,-4.11,-0.894992,5.4,26.8951,37000970)
  self:setMoodString(pNpc, "happy")
  pNpc = spawnMobile("coruscant", "commoner",60,10.17,-0.894992,2.74,125.098,37000970)
  self:setMoodString(pNpc, "conversation")
  pNpc = spawnMobile("coruscant", "commoner_fat",60,2.11,-0.894992,5.4,180,37000970)
  self:setMoodString(pNpc, "npc_standing_drinking")
  pNpc = spawnMobile("coruscant", "commoner_fat",60,-3.2,-0.9,-10.8,65,37000970)
  self:setMoodString(pNpc, "npc_sitting_table_eating")
  pNpc = spawnMobile("coruscant", "commoner_naboo",60,3.11,0,5.4,161.005,37000970)
  self:setMoodString(pNpc, "bored")
  pNpc = spawnMobile("coruscant", "commoner_naboo",60,1.11,0,5.4,330.024,37000970)
  self:setMoodString(pNpc, "npc_standing_drinking")
  pNpc = spawnMobile("coruscant", "commoner_naboo",60,-3.11,0,5.4,16.6733,37000970)
  self:setMoodString(pNpc, "npc_standing_drinking")
  pNpc = spawnMobile("coruscant", "commoner_naboo",60,16.1,-0.9,4.1,340,37000970)
  self:setMoodString(pNpc, "conversation")
  pNpc = spawnMobile("coruscant", "commoner_tatooine",60,4.11,-0.894992,5.4,158.443,37000970)
  self:setMoodString(pNpc, "npc_standing_drinking")
  pNpc = spawnMobile("coruscant", "commoner_tatooine",60,1.99,-0.894992,-8.44,325.01,37000970)
  self:setMoodString(pNpc, "conversation")
  pNpc = spawnMobile("coruscant", "commoner_tatooine",60,1.19,-0.894992,-7.63,152.004,37000970)
  self:setMoodString(pNpc, "conversation")
  pNpc = spawnMobile("coruscant", "entertainer",60,9.4,0,3.9,310,37000970)
  self:setMoodString(pNpc, "conversation")
  pNpc = spawnMobile("coruscant", "patron",60,8.49,-0.894992,4.64,128.74,37000970)
  self:setMoodString(pNpc, "conversation")
  pNpc = spawnMobile("coruscant", "patron",60,13.7,-0.9,-5.6,67,37000970)
  self:setMoodString(pNpc, "npc_sitting_chair")
  pNpc = spawnMobile("coruscant", "patron",60,13.6,-0.9,-2.4,147,37000970)
  self:setMoodString(pNpc, "npc_sitting_chair")
  pNpc = spawnMobile("coruscant", "patron",60,16.3,-0.9,-5.6,320,37000970)
  self:setMoodString(pNpc, "npc_sitting_chair")
  pNpc = spawnMobile("coruscant", "patron",60,23.5,-0.9,-8.9,51,37000970)
  self:setMoodString(pNpc, "npc_sitting_table")
  pNpc = spawnMobile("coruscant", "patron",60,26.3,-0.9,-8.8,317,37000970)
  self:setMoodString(pNpc, "npc_sitting_table_eating")
  pNpc = spawnMobile("coruscant", "bounty_hunter",60,8.0,-0.9,-4.5,-21,37000970)
  self:setMoodString(pNpc, "angry")
  pNpc = spawnMobile("coruscant", "thug",60,6.8,-0.9,-4.5,-22,37000970)
  self:setMoodString(pNpc, "npc_worried")
  pNpc = spawnMobile("coruscant", "patron",60,-3.1,-0.9,11.6,97,37000970)
  self:setMoodString(pNpc, "npc_sitting_table")
  pNpc = spawnMobile("coruscant", "patron",60,1.2,-0.9,11.6,269,37000970)
  self:setMoodString(pNpc, "npc_sitting_chair")
  pNpc = spawnMobile("coruscant", "patron_ithorian",60,14.1,-0.9,4.3,51,37000970)
  self:setMoodString(pNpc, "npc_sitting_table")
  pNpc = spawnMobile("coruscant", "patron_klaatu",60,14.4,-0.9,7.5,139,37000970)
  self:setMoodString(pNpc, "npc_sitting_chair")
  pNpc = spawnMobile("coruscant", "patron_quarren",60,17.1,-0.9,7.8,226,37000970)
  self:setMoodString(pNpc, "npc_sitting_chair")
  
  pNpc = spawnMobile("coruscant", "jabba_swooper",60,-3.1,-0.9,-5.2,154,37000970)
  self:setMoodString(pNpc, "neutral")
  pNpc = spawnMobile("coruscant", "jabba_swooper",60,-5.4,-0.9,-5.2,79,37000970)
  self:setMoodString(pNpc, "neutral")
  pNpc = spawnMobile("coruscant", "jabba_swooper",60,-3.7,-0.9,-7.4,2,37000970)
  self:setMoodString(pNpc, "neutral")
  pNpc = spawnMobile("coruscant", "jabba_swooper_leader",60,5.7,-0.9,-12.4,3,37000970)
  self:setMoodString(pNpc, "neutral")
  pNpc = spawnMobile("coruscant", "jabba_swooper_leader",60,4.0,-0.9,-4.8,73,37000970)
  self:setMoodString(pNpc, "neutral")
  pNpc = spawnMobile("coruscant", "jabba_swooper",60,20.0,-0.9,-11.2,2,37000970)
  self:setMoodString(pNpc, "neutral")
  
  
  pNpc = spawnMobile("coruscant", "valarian_swooper",60,22.5,-0.9,-2.0,-104,37000970)
  self:setMoodString(pNpc, "neutral")
  pNpc = spawnMobile("coruscant", "valarian_swooper",60,5.4,-0.9,8.9,122,37000970)
  self:setMoodString(pNpc, "neutral")
  pNpc = spawnMobile("coruscant", "valarian_swooper",60,15.3,-0.9,10.2,-175,37000970)
  self:setMoodString(pNpc, "neutral")
  pNpc = spawnMobile("coruscant", "valarian_swooper_leader",60,24.3,-0.9,9.1,-148,37000970)
  self:setMoodString(pNpc, "neutral")
  pNpc = spawnMobile("coruscant", "valarian_swooper",60,6.5,-0.9,9.9,176,37000970)
  self:setMoodString(pNpc, "neutral")
  
  pNpc = spawnMobile("coruscant", "civil_patrol_sergeant",60,27.9,0.1,1.3,-179,37000970)
  self:setMoodString(pNpc, "neutral")
  
  pNpc = spawnMobile("coruscant", "valarian_swooper_leader",60,-5846.1,0,-5037.6,150,0)
  self:setMoodString(pNpc, "neutral")
  pNpc = spawnMobile("coruscant", "valarian_swooper",60,-5837.6,0,-5037.3,41,0)
  self:setMoodString(pNpc, "conversation")
  pNpc = spawnMobile("coruscant", "valarian_swooper",60,-5834.8,0,-5033.4,-130,0)
  self:setMoodString(pNpc, "conversation")
  pNpc = spawnMobile("coruscant", "valarian_swooper",60,-5840.3,0,-5026.2,87,0)
  self:setMoodString(pNpc, "neutral")
  pNpc = spawnMobile("coruscant", "valarian_swooper",60,-5830.0,0,-5018.0,-178,0)
  self:setMoodString(pNpc, "neutral")
  
  pNpc = spawnMobile("coruscant", "jabba_swooper_leader",60,-5678,0,-5032.6,-123,0)
  self:setMoodString(pNpc, "neutral")
  pNpc = spawnMobile("coruscant", "jabba_swooper",60,-5687.2,0,-5037.6,-16,0)
  self:setMoodString(pNpc, "conversation")
  pNpc = spawnMobile("coruscant", "jabba_swooper",60,-5687,0,-5032.6,-178,0)
  self:setMoodString(pNpc, "conversation")
  pNpc = spawnMobile("coruscant", "jabba_swooper",60,-5688.4,0,-5022.6,-165,0)
  self:setMoodString(pNpc, "conversation")
  pNpc = spawnMobile("coruscant", "jabba_swooper",60,-5694,0,-5029.6,108,0)
  self:setMoodString(pNpc, "conversation")
  
  pNpc = spawnMobile("coruscant", "tough_thug_male_rodian", 60, -5770, 0, -5012, 11, 0)
  self:setMoodString(pNpc, "neutral")
  pNpc = spawnMobile("coruscant", "tough_thug_male_rodian", 60, -5716, 0, -5031, -15, 0)
  self:setMoodString(pNpc, "neutral")
  
  
  
  
  --  MONUMENT SQUARE AGAIN
   -- Inside MS Cantina
  
  pNpc = spawnMobile("coruscant", "entertainer", 60, 38.6, 0.1, 2.9, 133, 37000109)
  self:setMoodString(pNpc, "npc_accusing")
  
  pNpc = spawnMobile("coruscant", "stormtrooper", 60, 40.3, 0.1, 1.4, -57, 37000109)
  self:setMoodString(pNpc, "npc_consoling")
  
  pNpc = spawnMobile("coruscant", "commoner", 60, 30.3, 0.1, -8.7, 48, 37000110)
  self:setMoodString(pNpc, "npc_sitting_chair")
  
  pNpc = spawnMobile("coruscant", "commoner", 60, 30.1, 0.1, -5.6, 124, 37000110)
  self:setMoodString(pNpc, "npc_sitting_chair")
  
  pNpc = spawnMobile("coruscant", "bartender", 60, 8.6, -0.9, 0.6, 90, 37000111)
  self:setMoodString(pNpc, "neutral")

  pNpc = spawnMobile("coruscant", "bartender", 60, -0.9, -0.9, 3.3, 0, 37000111)
  self:setMoodString(pNpc, "conversation")
  
  pNpc = spawnMobile("coruscant", "bartender", 60, -1.7, -0.9, -2.4, -179, 37000111)
  self:setMoodString(pNpc, "npc_accusing")
  
  pNpc = spawnMobile("coruscant", "commoner", 60, -1.7, -0.9, -5.0, 0, 37000111)
  self:setMoodString(pNpc, "npc_consoling")
  
  pNpc = spawnMobile("coruscant", "patron",60,10.65,-0.894992,1.91,330,37000111)
  self:setMoodString(pNpc, "npc_standing_drinking")
  pNpc = spawnMobile("coruscant", "patron",60,-4.11,-0.894992,5.4,26.8951,37000111)
  self:setMoodString(pNpc, "happy")
  pNpc = spawnMobile("coruscant", "comm_operator",60,10.17,-0.894992,2.74,125.098,37000111)
  self:setMoodString(pNpc, "conversation")
  pNpc = spawnMobile("coruscant", "civil_patrol_commander",60,2.11,-0.894992,5.4,180,37000111)
  self:setMoodString(pNpc, "npc_standing_drinking")
  pNpc = spawnMobile("coruscant", "civil_patrol_corporal",60,-3.2,-0.9,-10.8,65,37000111)
  self:setMoodString(pNpc, "npc_sitting_table_eating")
  pNpc = spawnMobile("coruscant", "civilian_patrolman",60,3.11,0,5.4,161.005,37000111)
  self:setMoodString(pNpc, "bored")
  pNpc = spawnMobile("coruscant", "stormtrooper_commando",60,1.11,0,5.4,330.024,37000111)
  self:setMoodString(pNpc, "npc_standing_drinking")
  pNpc = spawnMobile("coruscant", "scout_trooper",60,-3.11,0,5.4,16.6733,37000111)
  self:setMoodString(pNpc, "npc_standing_drinking")
  pNpc = spawnMobile("coruscant", "scout_trooper",60,16.1,-0.9,4.1,340,37000111)
  self:setMoodString(pNpc, "conversation")
  pNpc = spawnMobile("coruscant", "imperial_general",60,4.11,-0.894992,5.4,158.443,37000111)
  self:setMoodString(pNpc, "npc_standing_drinking")
  pNpc = spawnMobile("coruscant", "imperial_scientist",60,1.99,-0.894992,-8.44,325.01,37000111)
  self:setMoodString(pNpc, "conversation")
  pNpc = spawnMobile("coruscant", "imperial_trooper",60,1.19,-0.894992,-7.63,152.004,37000111)
  self:setMoodString(pNpc, "conversation")
  pNpc = spawnMobile("coruscant", "entertainer",60,9.4,0,3.9,310,37000111)
  self:setMoodString(pNpc, "conversation")
  pNpc = spawnMobile("coruscant", "patron",60,8.49,-0.894992,4.64,128.74,37000111)
  self:setMoodString(pNpc, "conversation")
  pNpc = spawnMobile("coruscant", "patron",60,13.7,-0.9,-5.6,67,37000111)
  self:setMoodString(pNpc, "npc_sitting_chair")
  pNpc = spawnMobile("coruscant", "patron",60,13.6,-0.9,-2.4,147,37000111)
  self:setMoodString(pNpc, "npc_sitting_chair")
  pNpc = spawnMobile("coruscant", "patron",60,16.3,-0.9,-5.6,320,37000111)
  self:setMoodString(pNpc, "npc_sitting_chair")
  pNpc = spawnMobile("coruscant", "patron",60,23.5,-0.9,-8.9,51,37000111)
  self:setMoodString(pNpc, "npc_sitting_table")
  pNpc = spawnMobile("coruscant", "patron",60,26.3,-0.9,-8.8,317,37000111)
  self:setMoodString(pNpc, "npc_sitting_table_eating")
  pNpc = spawnMobile("coruscant", "stormtrooper",60,8.0,-0.9,-4.5,-21,37000111)
  self:setMoodString(pNpc, "angry")
  pNpc = spawnMobile("coruscant", "imperial_master_sergeant",60,6.8,-0.9,-4.5,-22,37000111)
  self:setMoodString(pNpc, "npc_worried")
  pNpc = spawnMobile("coruscant", "imperial_major",60,-3.1,-0.9,11.6,97,37000111)
  self:setMoodString(pNpc, "npc_sitting_table")
  pNpc = spawnMobile("coruscant", "imperial_colonel",60,1.2,-0.9,11.6,269,37000111)
  self:setMoodString(pNpc, "npc_sitting_chair")
  pNpc = spawnMobile("coruscant", "scout_trooper",60,14.1,-0.9,4.3,51,37000111)
  self:setMoodString(pNpc, "npc_sitting_table")
  pNpc = spawnMobile("coruscant", "stormtrooper_squad_leader",60,14.4,-0.9,7.5,139,37000111)
  self:setMoodString(pNpc, "npc_sitting_chair")
  pNpc = spawnMobile("coruscant", "imperial_officer",60,17.1,-0.9,7.8,226,37000111)
  self:setMoodString(pNpc, "npc_sitting_chair")
  
  -- Starport
  pNpc = spawnMobile("coruscant", "bartender",60,-33.0,1.6,49.9,25,37000205)
  self:setMoodString(pNpc, "conversation")
  pNpc = spawnMobile("coruscant", "patron",60,-27.4,1.6,49.5,0,37000205)
  self:setMoodString(pNpc, "npc_sitting_chair")
  pNpc = spawnMobile("coruscant", "patron",60,-25.8,1.6,50.9,-87,37000205)
  self:setMoodString(pNpc, "npc_sitting_chair")
  pNpc = spawnMobile("coruscant", "patron",60,-27.2,1.6,52.4,-179,37000205)
  self:setMoodString(pNpc, "npc_sitting_chair")
  
  pNpc = spawnMobile("coruscant", "patron",60,-34.5,1.6,64.2,-52,37000205)
  self:setMoodString(pNpc, "npc_sitting_chair")
  pNpc = spawnMobile("coruscant", "patron",60,-34.8,1.6,66.2,-139,37000205)
  self:setMoodString(pNpc, "npc_sitting_chair")
  pNpc = spawnMobile("coruscant", "patron",60,-36.6,1.6,63.8,37,37000205)
  self:setMoodString(pNpc, "npc_sitting_chair")
  pNpc = spawnMobile("coruscant", "patron",60,-29.2,1.6,66.2,-118,37000205)
  self:setMoodString(pNpc, "npc_sitting_chair")
  pNpc = spawnMobile("coruscant", "patron",60,-27.1,1.6,65.4,-116,37000205)
  self:setMoodString(pNpc, "npc_sitting_chair")
  pNpc = spawnMobile("coruscant", "patron",60,-29.7,1.6,64.2,62,37000205)
  self:setMoodString(pNpc, "npc_sitting_chair")
  
  pNpc = spawnMobile("coruscant", "patron",60,-43.5,1.6,50.1,36,37000206)
  self:setMoodString(pNpc, "conversation")
  pNpc = spawnMobile("coruscant", "patron",60,-41.0,1.6,52.2,-129,37000206)
  self:setMoodString(pNpc, "conversation")
  
  pNpc = spawnMobile("coruscant", "stormtrooper",60,-56.9,1.0,8.7,-6,37000210)
  self:setMoodString(pNpc, "conversation")
  pNpc = spawnMobile("coruscant", "patron",60,-56.9,1.0,10.9,179,37000210)
  self:setMoodString(pNpc, "conversation")
  
  pNpc = spawnMobile("coruscant", "patron",60,47.8,0.6,46.0,4,37000203)
  self:setMoodString(pNpc, "npc_sitting_chair")
  pNpc = spawnMobile("coruscant", "patron",60,48.1,0.6,48.9,-175,37000203)
  self:setMoodString(pNpc, "npc_sitting_chair")
  pNpc = spawnMobile("coruscant", "patron",60,43.4,0.6,47.4,-67,37000203)
  self:setMoodString(pNpc, "npc_sitting_chair")
  pNpc = spawnMobile("coruscant", "patron",60,36.0,0.6,35.5,73,37000203)
  self:setMoodString(pNpc, "npc_sitting_chair")
  
  --  Collective Commerce District Uprising NPCs
  
  spawnMobile("coruscant", "at_st", 60, -1819, 40, -30, 0, 0)
  spawnMobile("coruscant", "stormtrooper", 60, -1822, 40, -19, -145, 0)
  spawnMobile("coruscant", "stormtrooper", 60, -1816, 40, -37, -3, 0)
  
  
  
  spawnMobile("coruscant", "stormtrooper", 60, -1802.3, 40, -138.8, -90, 0)
  spawnMobile("coruscant", "stormtrooper", 60, -1802.3, 40, -233.8, -90, 0)
  
  spawnMobile("coruscant", "pilot", 60, -1803, 40, -154, 47, 0)
  
  spawnMobile("coruscant", "commoner", 60, -1849, 40, -113, 90, 0)
  
  pNpc = spawnMobile("coruscant", "pilot",60,-1803,40,-178,180,0)
  self:setMoodString(pNpc, "npc_accusing")
  pNpc = spawnMobile("coruscant", "technician",60,-1803,40,-182,0,0)
  self:setMoodString(pNpc, "conversation")
  

  
  spawnMobile("coruscant", "civil_patrol_captain", 60, -1849, 40, -188, 77, 0)
  
  spawnMobile("coruscant", "civil_patrol_captain", 60, -1916, 40, -166, 129, 0)
  spawnMobile("coruscant", "civil_patrol_captain", 60, -1919, 40, -189, 53, 0)
  spawnMobile("coruscant", "civil_patrol_captain", 60, -1919, 40, -175, -109, 0)
  
  
  
  spawnMobile("coruscant", "stormtrooper", 60, -1982, 40, -124, -138, 0)
  spawnMobile("coruscant", "stormtrooper", 60, -1977, 40, -128, -138, 0)
  spawnMobile("coruscant", "stormtrooper", 60, -1973, 40, -135, -138, 0)
  spawnMobile("coruscant", "stormtrooper", 60, -1968, 40, -144, -104, 0)
  
  -- Monument Square Again
  pNpc = spawnMobile("coruscant", "at_at", 60, 1607, 40, 654, -90, 0)
  self:setMoodString(pNpc, "neutral")
 -- AiAgent(pMobile):addCreatureFlag(AI_STATIC)
  
  pNpc = spawnMobile("coruscant", "at_st", 60, 1488, 40, 706, 90, 0)
  self:setMoodString(pNpc, "neutral")
 -- AiAgent(pMobile):addCreatureFlag(AI_STATIC)
  
  spawnMobile("coruscant", "stormtrooper", 60, 1644, 40, 688, 180, 0)
  spawnMobile("coruscant", "stormtrooper", 60, 1665, 40, 688, 180, 0)
  
  
  pNpc = spawnMobile("coruscant", "noble",60,5.22842,0.3,2.91677,0,37000186) 
  self:setMoodString(pNpc, "conversation")
  pNpc = spawnMobile("coruscant", "info_broker",60,5.22842,0.3,4.01677,180.005,37000186)
  self:setMoodString(pNpc, "conversation")
  pNpc = spawnMobile("coruscant", "imperial_major",60,5.43518,2.27819,-27.0615,344.925,37000186)
  self:setMoodString(pNpc, "conversation")
  pNpc = spawnMobile("coruscant", "brawler",60,-1.72746,7.9,-32.175,0,37000186)
  self:setMoodString(pNpc, "conversation")
  pNpc = spawnMobile("coruscant", "comm_operator",300,-0.332123,0.3,-2.90219,134.998,37000186)
  self:setMoodString(pNpc, "conversation")
  pNpc = spawnMobile("coruscant", "entertainer",60,0.767877,0.3,-2.90219,180.005,37000186)
  self:setMoodString(pNpc, "conversation")
  pNpc = spawnMobile("coruscant", "farmer",60,-18.6014,1.30259,-11.3146,360.011,37000186)
  self:setMoodString(pNpc, "conversation")
  pNpc = spawnMobile("coruscant", "farmer",60,0.767877,0.3,-4.00219,0,37000186)
  self:setMoodString(pNpc, "conversation")
  pNpc = spawnMobile("coruscant", "medic",60,-0.332123,0.3,-4.00219,45.0054,37000186)
  self:setMoodString(pNpc, "conversation")
  pNpc = spawnMobile("coruscant", "medic",60,5.18395,2.27819,-26.1292,164.924,37000186)
  self:setMoodString(pNpc, "conversation")
  pNpc = spawnMobile("coruscant", "noble",60,4.12842,0.3,4.01677,134.998,37000186)
  self:setMoodString(pNpc, "conversation")
  pNpc = spawnMobile("coruscant", "scientist",60,-1.72746,7.9,-31.075,180.005,37000186)
  self:setMoodString(pNpc, "conversation")
  pNpc = spawnMobile("coruscant", "mercenary",60,-18.6014,1.30292,-10.2146,180.006,37000186)
  self:setMoodString(pNpc, "conversation")
  
  pNpc = spawnMobile("coruscant", "commoner_technician",300,-20.2743,3.22324,22.781,180.005,37000191)
  self:setMoodString(pNpc, "conversation")
  pNpc = spawnMobile("coruscant", "farmer",60,-20.2743,3.22324,21.681,0,37000191)
  self:setMoodString(pNpc, "conversation")
  
  pNpc = spawnMobile("coruscant", "info_broker",60,21.8079,3.22324,26.617,180.006,37000192) 
  self:setMoodString(pNpc, "conversation")
  pNpc = spawnMobile("coruscant", "artisan",300,21.8079,3.22324,25.517,360.011,37000192)
  self:setMoodString(pNpc, "conversation")
  
  pNpc = spawnMobile("coruscant", "farmer",60,37.1168,1.29422,-4.41488,0,37000193)
  self:setMoodString(pNpc, "conversation")
  pNpc = spawnMobile("coruscant", "businessman",60,37.1168,1.29422,-3.41488,180.005,37000193)
  self:setMoodString(pNpc, "conversation")
  
  spawnMobile("coruscant", "trainer_imagedesigner", 60, 0.5, 0.6, -5.4, -70, 0)
  
  pNpc = spawnMobile("coruscant", "commoner", 60, -4.7, 0.25, -4.93, 124, 37000714)
  self:setMoodString(pNpc, "entertained")
  pNpc = spawnMobile("coruscant", "commoner", 60, 3.9, 0.25, -6.2, -122, 37000714)
  self:setMoodString(pNpc, "entertained")
  pNpc = spawnMobile("coruscant", "commoner", 60, -5.5, 0.25, -12.2, 0, 37000714)
  self:setMoodString(pNpc, "angry")
  pNpc = spawnMobile("coruscant", "commoner", 60, 5.8, 0.25, -12.2, 0, 37000714)
  self:setMoodString(pNpc, "entertained")
  pNpc = spawnMobile("coruscant", "commoner", 60, 0.65, 0.25, -2.68, 178, 37000714)
  self:setMoodString(pNpc, "npc_accusing")
  
 -- Federal District ------------------------------------------------------------------------------------------------------
  -- ISB Quarter
  pNpc = spawnMobile("coruscant", "stormtrooper", 60, -108, 40, 5520, 177, 0)
  self:setMoodString(pNpc, "neutral")
  CreatureObject(pNpc):clearOptionBit(AIENABLED)
  
  pNpc = spawnMobile("coruscant", "stormtrooper", 60, -134, 40, 5520, 177, 0)
  self:setMoodString(pNpc, "neutral")
  CreatureObject(pNpc):clearOptionBit(AIENABLED)
  
  pNpc = spawnMobile("coruscant", "stormtrooper", 60, -126, 40, 5461, 0, 0)
  self:setMoodString(pNpc, "neutral")
  CreatureObject(pNpc):clearOptionBit(AIENABLED)
  
  pNpc = spawnMobile("coruscant", "stormtrooper", 60, -111, 40, 5461, 0, 0)
  self:setMoodString(pNpc, "neutral")
  CreatureObject(pNpc):clearOptionBit(AIENABLED)
  
  pNpc = spawnMobile("coruscant", "stormtrooper", 60, -117, 40, 5447, 0, 0)
  self:setMoodString(pNpc, "neutral")
  CreatureObject(pNpc):clearOptionBit(AIENABLED)
  
  pNpc = spawnMobile("coruscant", "stormtrooper", 60, -123, 40, 5447, 0, 0)
  self:setMoodString(pNpc, "neutral")
  CreatureObject(pNpc):clearOptionBit(AIENABLED)
  
  pNpc = spawnMobile("coruscant", "stormtrooper", 60, -95, 40, 5549, 177, 0)
  self:setMoodString(pNpc, "neutral")
  CreatureObject(pNpc):clearOptionBit(AIENABLED)
  
  pNpc = spawnMobile("coruscant", "stormtrooper", 60, -85, 40, 5549, 177, 0)
  self:setMoodString(pNpc, "neutral")
  CreatureObject(pNpc):clearOptionBit(AIENABLED)
  
  pNpc = spawnMobile("coruscant", "isb_officer", 60, -125, 40, 5500, 46, 0)
  self:setMoodString(pNpc, "conversation")
  CreatureObject(pNpc):clearOptionBit(AIENABLED)
  
  pNpc = spawnMobile("coruscant", "isb_officer", 60, -122, 40, 5502, -132, 0)
  self:setMoodString(pNpc, "conversation")
  CreatureObject(pNpc):clearOptionBit(AIENABLED)
  
  pNpc = spawnMobile("coruscant", "isb_officer", 60, -118, 40, 5479, -90, 0)
  self:setMoodString(pNpc, "npc_consoling")
  CreatureObject(pNpc):clearOptionBit(AIENABLED)
  
  pNpc = spawnMobile("coruscant", "isb_officer", 60, -122, 40, 5479, 90, 0)
  self:setMoodString(pNpc, "npc_accusing")
  CreatureObject(pNpc):clearOptionBit(AIENABLED)
  
  
  --Inside COMPNOR Arcology------------------------------
  pNpc = spawnMobile("coruscant", "dark_trooper", 60, 5.0, 0.3, -4.1, -90, 37002128)
  self:setMoodString(pNpc, "neutral")
  CreatureObject(pNpc):clearOptionBit(AIENABLED)

  pNpc = spawnMobile("coruscant", "dark_trooper", 60, 6.7, -12.0, 25.6, -95, 37002130)
  self:setMoodString(pNpc, "neutral")
  CreatureObject(pNpc):clearOptionBit(AIENABLED)

  pNpc = spawnMobile("coruscant", "stormtrooper", 60, -19.6, -12.0, 54.0, 120, 37002130)
  self:setMoodString(pNpc, "neutral")
  CreatureObject(pNpc):clearOptionBit(AIENABLED)
  
  pNpc = spawnMobile("coruscant", "stormtrooper", 60, 25.0, -12.0, 52.7, 178, 37002130)
  self:setMoodString(pNpc, "neutral")
  CreatureObject(pNpc):clearOptionBit(AIENABLED)
  -- Briefing room / conference
  pNpc = spawnMobile("coruscant", "stormtrooper", 60, 16.2, -12.0, 0.4, 84, 37002139)
  self:setMoodString(pNpc, "neutral")
  CreatureObject(pNpc):clearOptionBit(AIENABLED)
  
  pNpc = spawnMobile("coruscant", "stormtrooper", 60, 16.2, -12.0, 5.7, 84, 37002139)
  self:setMoodString(pNpc, "neutral")
  CreatureObject(pNpc):clearOptionBit(AIENABLED)
  -- armory
  pNpc = spawnMobile("coruscant", "stormtrooper", 60, -16.6, -20.0, 10.9, 180, 37002141)
  self:setMoodString(pNpc, "neutral")
  CreatureObject(pNpc):clearOptionBit(AIENABLED)
  
  pNpc = spawnMobile("coruscant", "isb_officer", 60, 0.8, -12.0, 26.1, 131, 37002130)
  self:setMoodString(pNpc, "npc_sitting_chair")
  CreatureObject(pNpc):clearOptionBit(AIENABLED)
  
  pNpc = spawnMobile("coruscant", "isb_officer", 60, 3.7, -12.0, 40.3, 1, 37002130)
  self:setMoodString(pNpc, "neutral")
  CreatureObject(pNpc):clearOptionBit(AIENABLED)
  
  pNpc = spawnMobile("coruscant", "isb_officer", 60, 26.9, -12.0, 43.4, -89, 37002130)
  self:setMoodString(pNpc, "npc_sitting_chair")
  CreatureObject(pNpc):clearOptionBit(AIENABLED)
  
  pNpc = spawnMobile("coruscant", "isb_officer", 60, 6.3, -12.0, 67.7, -0, 37002130)
  self:setMoodString(pNpc, "npc_sitting_chair")
  CreatureObject(pNpc):clearOptionBit(AIENABLED)
  
  pNpc = spawnMobile("coruscant", "isb_officer", 60, 3.5, -12.0, 67.7, -0, 37002130)
  self:setMoodString(pNpc, "npc_sitting_chair")
  CreatureObject(pNpc):clearOptionBit(AIENABLED)
  
  pNpc = spawnMobile("coruscant", "isb_officer", 60, 0.8, -12.0, 67.7, -0, 37002130)
  self:setMoodString(pNpc, "npc_sitting_chair")
  CreatureObject(pNpc):clearOptionBit(AIENABLED)
  
  pNpc = spawnMobile("coruscant", "isb_officer", 60, 3.6, -12.0, 60.8, -10, 37002130)
  self:setMoodString(pNpc, "conversation")
  CreatureObject(pNpc):clearOptionBit(AIENABLED)
  
  pNpc = spawnMobile("coruscant", "isb_officer", 60, 3.4, -12.0, 65.1, 168, 37002130)
  self:setMoodString(pNpc, "conversation")
  CreatureObject(pNpc):clearOptionBit(AIENABLED)
  
  pNpc = spawnMobile("coruscant", "isb_officer", 60, -19.2, -12.0, 43.4, 0, 37002130)
  self:setMoodString(pNpc, "npc_sitting_chair")
  CreatureObject(pNpc):clearOptionBit(AIENABLED)
  
  pNpc = spawnMobile("coruscant", "imperial_first_lieutenant", 60, 0.1, -12.0, 59.8, -1, 37002130)
  self:setMoodString(pNpc, "neutral")
  CreatureObject(pNpc):clearOptionBit(AIENABLED)
  
  pNpc = spawnMobile("coruscant", "stormtrooper", 60, 11.0, -12.0, 62.,5, -90, 37002130)
  self:setMoodString(pNpc, "npc_sitting_chair")
  CreatureObject(pNpc):clearOptionBit(AIENABLED)
  
  --conference room
  pNpc = spawnMobile("coruscant", "isb_officer", 60, 47.5, -12.0, 4.7, -0, 37002139)
  self:setMoodString(pNpc, "npc_sitting_chair")
  CreatureObject(pNpc):clearOptionBit(AIENABLED)
  
  pNpc = spawnMobile("coruscant", "isb_officer", 60, 44.2, -12.0, 4.7, -14, 37002139)
  self:setMoodString(pNpc, "npc_sitting_chair")
  CreatureObject(pNpc):clearOptionBit(AIENABLED)
  
  pNpc = spawnMobile("coruscant", "isb_officer", 60, 41.2, -12.0, 4.7, 7, 37002139)
  self:setMoodString(pNpc, "npc_sitting_chair")
  CreatureObject(pNpc):clearOptionBit(AIENABLED)
  
  pNpc = spawnMobile("coruscant", "isb_officer", 60, 38.5, -12.0, 4.7, 29, 37002139)
  self:setMoodString(pNpc, "npc_sitting_chair")
  CreatureObject(pNpc):clearOptionBit(AIENABLED)
  
  pNpc = spawnMobile("coruscant", "isb_officer", 60, 34.6, -12.0, 6.1, 51, 37002139)
  self:setMoodString(pNpc, "npc_sitting_chair")
  CreatureObject(pNpc):clearOptionBit(AIENABLED)
  
  pNpc = spawnMobile("coruscant", "isb_officer", 60, 33.2, -12.0, 10.1, 90, 37002139)   -- replace with partagaz
  self:setMoodString(pNpc, "npc_sitting_chair")
  CreatureObject(pNpc):clearOptionBit(AIENABLED)
  
  pNpc = spawnMobile("coruscant", "isb_officer", 60, 39.2, -12.0, 15.5, 180, 37002139)
  self:setMoodString(pNpc, "npc_sitting_chair")
  CreatureObject(pNpc):clearOptionBit(AIENABLED)
  
  pNpc = spawnMobile("coruscant", "isb_officer", 60, 41.8, -12.0, 15.5, 180, 37002139)
  self:setMoodString(pNpc, "npc_sitting_chair")
  CreatureObject(pNpc):clearOptionBit(AIENABLED)
  
  pNpc = spawnMobile("coruscant", "isb_officer", 60, 44.1, -12.0, 15.5, 180, 37002139)
  self:setMoodString(pNpc, "npc_sitting_chair")
  CreatureObject(pNpc):clearOptionBit(AIENABLED)
  
  pNpc = spawnMobile("coruscant", "isb_officer", 60, 45.9, -12.0, 15.5, 178, 37002139)
  self:setMoodString(pNpc, "npc_sitting_chair")
  CreatureObject(pNpc):clearOptionBit(AIENABLED)
  
  pNpc = spawnMobile("coruscant", "isb_officer", 60, 49.0, -12.0, 15.5, -169, 37002139)
  self:setMoodString(pNpc, "npc_sitting_chair")
  CreatureObject(pNpc):clearOptionBit(AIENABLED)
  
  -- Laboratories
  pNpc = spawnMobile("coruscant", "isb_officer", 60, 19.4, -20.0, 116.3, -90, 37002138)
  self:setMoodString(pNpc, "neutral")
  CreatureObject(pNpc):clearOptionBit(AIENABLED)
  
  pNpc = spawnMobile("coruscant", "imperial_warrant_officer_i", 60, 36.0, -20.0, 137.2, 168, 37002138)
  self:setMoodString(pNpc, "neutral")
  CreatureObject(pNpc):clearOptionBit(AIENABLED)
  
  pNpc = spawnMobile("coruscant", "isb_officer", 60, 46.7, -12.0, 64, -50, 37002137)
  self:setMoodString(pNpc, "neutral")
  CreatureObject(pNpc):clearOptionBit(AIENABLED)
  
  pNpc = spawnMobile("coruscant", "dark_trooper", 60, -2.5, -20.0, 71, 45, 37002146)
  self:setMoodString(pNpc, "neutral")
  CreatureObject(pNpc):clearOptionBit(AIENABLED)
  
  pNpc = spawnMobile("coruscant", "dark_trooper", 60, -28.0, -20.0, 103, 180, 37002144)
  self:setMoodString(pNpc, "neutral")
  CreatureObject(pNpc):clearOptionBit(AIENABLED)
  pNpc = spawnMobile("coruscant", "dark_trooper", 60, -26.0, -20.0, 103, 180, 37002144)
  self:setMoodString(pNpc, "neutral")
  CreatureObject(pNpc):clearOptionBit(AIENABLED)
  pNpc = spawnMobile("coruscant", "dark_trooper", 60, -24.0, -20.0, 103, 180, 37002144)
  self:setMoodString(pNpc, "neutral")
  CreatureObject(pNpc):clearOptionBit(AIENABLED)
  pNpc = spawnMobile("coruscant", "dark_trooper", 60, -22.0, -20.0, 103, 180, 37002144)
  self:setMoodString(pNpc, "neutral")
  CreatureObject(pNpc):clearOptionBit(AIENABLED)
  pNpc = spawnMobile("coruscant", "dark_trooper", 60, -20.0, -20.0, 103, 180, 37002144)
  self:setMoodString(pNpc, "neutral")
  CreatureObject(pNpc):clearOptionBit(AIENABLED)
  pNpc = spawnMobile("coruscant", "dark_trooper", 60, -18.0, -20.0, 103, 180, 37002144)
  self:setMoodString(pNpc, "neutral")
  CreatureObject(pNpc):clearOptionBit(AIENABLED)
  pNpc = spawnMobile("coruscant", "dark_trooper", 60, -16.0, -20.0, 103, 180, 37002144)
  self:setMoodString(pNpc, "neutral")
  CreatureObject(pNpc):clearOptionBit(AIENABLED)
  
  -- Prison Quarter
  pNpc = spawnMobile("coruscant", "stormtrooper", 60, -93, 40, 5605, 90, 0)
  self:setMoodString(pNpc, "neutral")
  CreatureObject(pNpc):clearOptionBit(AIENABLED)
  
  pNpc = spawnMobile("coruscant", "stormtrooper", 60, -87, 40, 5605, -90, 0)
  self:setMoodString(pNpc, "neutral")
  CreatureObject(pNpc):clearOptionBit(AIENABLED)
  
  pNpc = spawnMobile("coruscant", "imperial_first_lieutenant", 60, -1.2, 2.0, 4.7, 0, 37002228)
  self:setMoodString(pNpc, "npc_sitting_chair")
  CreatureObject(pNpc):clearOptionBit(AIENABLED)
  
  pNpc = spawnMobile("coruscant", "imperial_first_lieutenant", 60, 1.1, 2.0, 4.8, 0, 37002228)
  self:setMoodString(pNpc, "npc_sitting_chair")
  CreatureObject(pNpc):clearOptionBit(AIENABLED)
  
  pNpc = spawnMobile("coruscant", "imperial_major", 60, 0.1, 2.0, 4.6, 0, 37002228)
  self:setMoodString(pNpc, "neutral")
  CreatureObject(pNpc):clearOptionBit(AIENABLED)
  
  pNpc = spawnMobile("coruscant", "stormtrooper", 60, 2.5, 1.0, -15.5, -3, 37002228)
  self:setMoodString(pNpc, "neutral")
  CreatureObject(pNpc):clearOptionBit(AIENABLED)
  
  pNpc = spawnMobile("coruscant", "stormtrooper", 60, -2.1, 1.0, -15.5, -1, 37002228)
  self:setMoodString(pNpc, "neutral")
  CreatureObject(pNpc):clearOptionBit(AIENABLED)
  
  pNpc = spawnMobile("coruscant", "stormtrooper", 60, -112.1, 47, 5607.1, -137, 0)
  self:setMoodString(pNpc, "neutral")
  CreatureObject(pNpc):clearOptionBit(AIENABLED)
  
  pNpc = spawnMobile("coruscant", "stormtrooper", 60, -68.3, 47, 5607.1, 126, 0)
  self:setMoodString(pNpc, "neutral")
  CreatureObject(pNpc):clearOptionBit(AIENABLED)
  
  pNpc = spawnMobile("coruscant", "at_st", 60, -79, 40, 5679, -90, 0)
  self:setMoodString(pNpc, "neutral")
  CreatureObject(pNpc):clearOptionBit(AIENABLED)
  
  pNpc = spawnMobile("coruscant", "stormtrooper", 60, -86.8, 40, 5664, -0, 0)
  self:setMoodString(pNpc, "neutral")
  CreatureObject(pNpc):clearOptionBit(AIENABLED)
  
  pNpc = spawnMobile("coruscant", "stormtrooper", 60, -107.7, 40, 5685, 180, 0)
  self:setMoodString(pNpc, "neutral")
  CreatureObject(pNpc):clearOptionBit(AIENABLED)
  
  pNpc = spawnMobile("coruscant", "stormtrooper", 60, -107.7, 40, 5674, 0, 0)
  self:setMoodString(pNpc, "neutral")
  CreatureObject(pNpc):clearOptionBit(AIENABLED)
  
  pNpc = spawnMobile("coruscant", "dathomir_prisoner", 60, -147, 40, 5681, 0, 0)
  self:setMoodString(pNpc, "neutral")
  pNpc = spawnMobile("coruscant", "dathomir_prisoner", 60, -168, 40, 5673, 0, 0)
  self:setMoodString(pNpc, "neutral")
  pNpc = spawnMobile("coruscant", "dathomir_prisoner", 60, -169, 40, 5698, 0, 0)
  self:setMoodString(pNpc, "neutral")
  pNpc = spawnMobile("coruscant", "dathomir_prisoner", 60, -162, 40, 5653, 0, 0)
  self:setMoodString(pNpc, "neutral")
  pNpc = spawnMobile("coruscant", "dathomir_prisoner", 60, -133, 40, 5638, 0, 0)
  self:setMoodString(pNpc, "neutral")
  pNpc = spawnMobile("coruscant", "dathomir_prisoner", 60, -168, 40, 5636, 0, 0)
  self:setMoodString(pNpc, "neutral")

  pNpc = spawnMobile("coruscant", "imperial_first_lieutenant", 60, 13.7, -23.0, 112.5, -90, 37002249)
  self:setMoodString(pNpc, "neutral")
  CreatureObject(pNpc):clearOptionBit(AIENABLED)
  
  pNpc = spawnMobile("coruscant", "imperial_first_lieutenant", 60, -42.7, -23.0, 112.5, 90, 37002249)
  self:setMoodString(pNpc, "neutral")
  CreatureObject(pNpc):clearOptionBit(AIENABLED)
  
  pNpc = spawnMobile("coruscant", "imperial_first_lieutenant", 60, -42.7, -23.0, 202.2, 90, 37002249)
  self:setMoodString(pNpc, "neutral")
  CreatureObject(pNpc):clearOptionBit(AIENABLED)
  
  pNpc = spawnMobile("coruscant", "imperial_first_lieutenant", 60, 13.7, -23.0, 202.2, -90, 37002249)
  self:setMoodString(pNpc, "neutral")
  CreatureObject(pNpc):clearOptionBit(AIENABLED)
  
  pNpc = spawnMobile("coruscant", "dathomir_prisoner", 60, -18.0, -23.0, 179.7, 0, 37002249)
  self:setMoodString(pNpc, "neutral")
  pNpc = spawnMobile("coruscant", "dathomir_prisoner", 60, -19.1, -23.0, 174.7, 49, 37002249)
  self:setMoodString(pNpc, "neutral")
  pNpc = spawnMobile("coruscant", "dathomir_prisoner", 60, -25.2, -23.0, 170, 135, 37002249)
  self:setMoodString(pNpc, "neutral")
  
  pNpc = spawnMobile("coruscant", "dathomir_prisoner", 60, -3.0, -23.0, 163, 0, 37002249)
  self:setMoodString(pNpc, "neutral")
  pNpc = spawnMobile("coruscant", "dathomir_prisoner", 60, -11.4, -23.0, 169, 49, 37002249)
  self:setMoodString(pNpc, "neutral")
  pNpc = spawnMobile("coruscant", "dathomir_prisoner", 60, -5.2, -23.0, 177, 135, 37002249)
  self:setMoodString(pNpc, "neutral")
  
  pNpc = spawnMobile("coruscant", "dathomir_prisoner", 60, -3.2, -23.0, 129, 0, 37002249)
  self:setMoodString(pNpc, "neutral")
  pNpc = spawnMobile("coruscant", "dathomir_prisoner", 60, -7.7, -23.0, 133, 49, 37002249)
  self:setMoodString(pNpc, "neutral")
  pNpc = spawnMobile("coruscant", "dathomir_prisoner", 60, -6, -23.0, 141, 135, 37002249)
  self:setMoodString(pNpc, "neutral")
  
  pNpc = spawnMobile("coruscant", "dathomir_prisoner", 60, -18.2, -23.0, 126, 0, 37002249)
  self:setMoodString(pNpc, "neutral")
  pNpc = spawnMobile("coruscant", "dathomir_prisoner", 60, -23, -23.0, 140, 49, 37002249)
  self:setMoodString(pNpc, "neutral")
  pNpc = spawnMobile("coruscant", "dathomir_prisoner", 60, -22, -23.0, 150, 135, 37002249)
  self:setMoodString(pNpc, "neutral")
  -- Palace / Jedi Temple Quarter
  spawnMobile("coruscant", "imperial_palace_liaison_officer", 60, -112, 40, 3303, 180, 0)
  local pGreatHall = getSceneObject(imperialPalaceLiaisonConvoHandler.greatHallCellID)
  if pGreatHall ~= nil and SceneObject(pGreatHall):isCellObject() then
    spawnMobile("coruscant", "imperial_palace_liaison_officer", 60, 4, 1.2, -200, 0, imperialPalaceLiaisonConvoHandler.greatHallCellID)
  end
  pNpc = spawnMobile("coruscant", "royal_imperial_guard", 60, -4.6, 333.0, 4.8, 40, 37002514)
  self:setMoodString(pNpc, "neutral")
  pNpc = spawnMobile("coruscant", "royal_imperial_guard", 60, 12.8, 333.0, 4.8, -56, 37002514)
  self:setMoodString(pNpc, "neutral")
  pNpc = spawnMobile("coruscant", "emperors_hand", 60, -4.4, 333.0, 22.4, 131, 37002514)
  self:setMoodString(pNpc, "neutral")
  pNpc = spawnMobile("coruscant", "emperors_hand", 60, 12.4, 333.0, 22.4, -134, 37002514)
  self:setMoodString(pNpc, "neutral")
  pNpc = spawnMobile("coruscant", "royal_imperial_guard", 60, 1.3, 1.2, -7.4, 180, 37002512)
  self:setMoodString(pNpc, "neutral")
  pNpc = spawnMobile("coruscant", "royal_imperial_guard", 60, 6.5, 1.2, -7.4, 180, 37002512)
  self:setMoodString(pNpc, "neutral")
  pNpc = spawnMobile("coruscant", "fbase_stormtrooper_extreme", 60, -64.2, 0.0, -59.9, 0, 37002512)
  self:setMoodString(pNpc, "neutral")
  pNpc = spawnMobile("coruscant", "fbase_stormtrooper_extreme", 60, -64.5, 0.0, 51.2, 180, 37002512)
  self:setMoodString(pNpc, "neutral")
  pNpc = spawnMobile("coruscant", "fbase_stormtrooper_extreme", 60, 59.9, 0.0, -59.9, 0, 37002512)
  self:setMoodString(pNpc, "neutral")
  pNpc = spawnMobile("coruscant", "fbase_stormtrooper_extreme", 60, 62.9, 0.0, 51.2, 180, 37002512)
  self:setMoodString(pNpc, "neutral")
  pNpc = spawnMobile("coruscant", "fbase_stormtrooper_extreme", 60, -7.1, 1.2, -203.2, 0, 37002512)
  self:setMoodString(pNpc, "neutral")
  pNpc = spawnMobile("coruscant", "fbase_stormtrooper_extreme", 60, 7.1, 1.2, -203.2, 0, 37002512)
  self:setMoodString(pNpc, "neutral")
  
  
  
end
